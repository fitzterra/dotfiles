# ~/.ipython/profile_default/ipython_config.py
c = get_config()
c.InteractiveShellApp.exec_lines = []
c.InteractiveShellApp.exec_lines.append('%load_ext autoreload')
c.InteractiveShellApp.exec_lines.append('%autoreload 2')

print("--------->>>>>>>> AUTORELOAD ENABLED <<<<<<<<<------------")

