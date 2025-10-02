# micro-opener
A universal file opener plugin for [micro](https://micro-editor.github.io/). This plugin lets you use **[yazi](https://github.com/sxyazi/yazi)**, **[lf](https://github.com/gokcehan/lf)**, **[fzf](https://github.com/junegunn/fzf)**, or any other external file chooser inside the Micro editor. It is based on [micro-fzfinder](https://github.com/MuratovAS/micro-fzfinder), generalized to be tool-agnostic: you choose the program; any tool that prints selected paths to stdout will work.

## Features
- Works with **Yazi**, **lf**, **fzf**, and more
- Opens files in the current pane, a split, or a new tab
- Multi-select: first file opens with one mode, subsequent files with another
- Config-only; no tool-specific defaults baked in

## Installation

This plugin for work requires `fzf`, install it in your system.

To install the plugin in `micro editor`, add to the `settings.json`:

~~~bash
micro ~/.config/micro/settings.json
~~~

~~~json
"pluginrepos": ["https://raw.githubusercontent.com/nazya/micro-opener/main/repo.json"],
~~~

Installing the plugin in micro editor

~~~bash
micro -plugin install opener
~~~


## Configuration
All behavior is controlled by global options in `settings.json`:

| Option         | Description                                                                                         | Default    |
|----------------|-----------------------------------------------------------------------------------------------------|------------|
| `openercmd`    | Command to run (e.g. `yazi`, `lf`, `fzf`)                                                           | required   |
| `openerargs`   | Extra arguments passed to the command                                                               | `""`       |
| `openermode`   | How to open the **first** file: `thispane`, `hsplit`, `vsplit`, `newtab`                            | `thispane` |
| `openermulti`  | How to open **subsequent** files                                                                    | `newtab`   |
| `openerpath`   | Starting directory: `"relative"` (use current buffer’s directory) or an explicit path string        | `relative` |

**Important:** the value of `openerpath` is **concatenated at the end of the command**. If your tool accepts a path argument, ensure it expects the path last.

## Keybinding

You can bind the plugin to a key in your `bindings.json`.  
For example, to run the opener with `Ctrl-o`:

~~~json
"Ctrl-o": "command:opener"
~~~


## Examples

### yazi
~~~json
"openercmd": "yazi --chooser-file /dev/stdout",
"openerargs": "",
"openerpath": "relative",
"openermode": "thispane",
"openermulti": "newtab"
~~~

### lf
~~~json
"openercmd": "lf",
"openerargs": "-print-selection",
"openerpath": "relative",
"openermode": "thispane",
"openermulti": "newtab"
~~~
