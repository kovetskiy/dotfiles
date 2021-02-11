import vim
import re
import subprocess
import yaml

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


def coc_filter_typescript_actions(titles):
    rules = _read_codeaction_rules()

    items = list(map(lambda item: {'id': item[0], 'title': item[1], 'score': 0}, enumerate(titles)))

    items = _assign_scores(items, rules)

    items = list(filter(_filter_item, items))

    items.sort(key=_sort_item, reverse=True)

    result = []

    excludes = ["Add import ", "Add all missing imports", "Import default 'React'"]
    includes = [
        "(Fix all auto-fixable problems)",
        "Import '(.*)'",
        "Add '(.*)'",
        "Import default '(.*)'"
    ]
    seen = []
    for item in items:
        title = item['title']

        skip = False
        for exclude in excludes:
            if re.search(exclude, title):
                skip = True
                break

        if skip:
            continue

        lib = None
        for pattern in includes:
            matches = re.match(pattern, title)
            if matches:
                lib = matches.group(1)
                break

        if not lib:
            continue

        if lib not in seen:
            seen.append(lib)
            result.append(item['id'])

    return result
