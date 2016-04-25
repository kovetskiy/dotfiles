import os

def set_prefs(prefs):
    prefs.add('python_path', os.environ['HOME'] . '/.vim/bundle/vim-pythonx/pythonx')
    prefs.add('python_path', os.environ['HOME'] . '/.vim/bundle/snippets/pythonx')

    prefs['ignored_resources'] = ['*.pyc', '*~', '.ropeproject',
                                  '.hg', '.svn', '_svn', '.git']
    prefs['save_objectdb'] = True
    prefs['compress_objectdb'] = False
    prefs['automatic_soa'] = True
    prefs['soa_followed_calls'] = 0
    prefs['perform_doa'] = True
    prefs['validate_objectdb'] = True
    prefs['max_history_items'] = 32
    prefs['save_history'] = True
    prefs['compress_history'] = False
    prefs['indent_size'] = 4
    prefs['extension_modules'] = []
    prefs['import_dynload_stdmods'] = True
    prefs['ignore_syntax_errors'] = False
    prefs['ignore_bad_imports'] = False

def project_opened(project):
    """This function is called after opening the project"""
