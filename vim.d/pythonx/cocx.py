import vim
import re
import subprocess
import yaml
import logging
import sys

debug = True

logger = logging.getLogger('cocxpy')
if debug:
    logger.setLevel(logging.DEBUG)

    formatter = logging.Formatter('%(asctime)s | %(levelname)s | %(message)s')
    stderr_handler = logging.StreamHandler(sys.stdout)
    stderr_handler.setLevel(logging.DEBUG)
    stderr_handler.setFormatter(formatter)

    file_handler = logging.FileHandler('/tmp/cocxpy.log')
    file_handler.setLevel(logging.DEBUG)

    # logger.addHandler(stderr_handler)
    logger.addHandler(file_handler)

def _get_git_root():
    return subprocess.Popen(
        ['git', 'rev-parse', '--show-toplevel'],
        stdout=subprocess.PIPE
    ).communicate()[0].rstrip().decode('utf-8')

def _read_codeaction_rules():
    data_loaded = []
    try:
        with open(_get_git_root() + "/.codeactions.yaml", 'r') as stream:
            data_loaded = yaml.safe_load(stream)
    except FileNotFoundError:
        return []
    return data_loaded


def _assign_scores(items, rules):
    for i in range(len(items)):
        for rule in rules:
            if re.search(rule['pattern'], items[i]['title']):
                items[i]['score'] += rule['score']
                if 'break' in rule and rule['break']:
                    break
    return items


def _sort_item(item):
    return item['score']


def _filter_item(item):
    return item['score'] >= 0


def cocx_filter_typescript_actions(titles):
    rules = _read_codeaction_rules()

    items = list(map(lambda item: {'id': item[0], 'title': item[1], 'score': 0}, enumerate(titles)))

    items = _assign_scores(items, rules)

    items = list(filter(_filter_item, items))

    items.sort(key=_sort_item, reverse=True)

    result = []

    excludes = ["Add import ", "Add all missing imports", "Import default 'React'"]
    includes = [
        "Import '(.*)' from module",
        "Add '(.*)'",
        "Import default '(.*)'",
        "(Fix all auto-fixable problems)",
    ]
    seen = []

    for exclude in excludes:
        for item in items:
            title = item['title']
            if re.search(exclude, title):
                items.remove(item)
                break

    if debug:
        for item in items:
            title = item['title']
            logger.debug('title: %s id: %d', title, item['id'])

    for pattern in includes:
        for item in items:
            title = item['title']
            matches = re.match(pattern, title)
            if not matches:
                continue

            lib = matches.group(1)
            if not lib:
                continue

            if lib not in seen:
                seen.append(lib)
                result.append(item['id'])

    if debug:
        for item in result:
           logger.debug('cocx_filter_typescript_actions: %s', str(item))
    #logger.debug('cocx_filter_typescript_actions start')
    #logger.debug('cocx_filter_typescript_actions finish')

    vim.command('let g:cocx_filter_typescript_actions = ' + str(int(len(result) > 0)))

    return result
