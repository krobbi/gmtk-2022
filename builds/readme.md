# Building The House Always Wins
[Go back](../readme.md)

# Contents
1. [Exporting from Godot Engine](#exporting-from-godot-engine)
   * [Pre-cleaning](#pre-cleaning)
   * [Exporting](#exporting)
2. [Distributing to itch.io](#distributing-to-itchio)
   * [Updating butler](#updating-butler)
   * [Using butler](#using-butler)
3. [Distributing to GitHub](#distributing-to-github)

# Exporting from Godot Engine
Different versions of the game expect different versions of Godot Engine. Make
sure you are using the correct versions before you open the project in Godot
Engine.

| Game version | Godot Engine version |
| -----------: | :------------------- |
| Development  | `3.5.1`              |
| v`1.1.2`     | `3.5.1`              |
| v`1.1.1`     | `3.4.4`              |
| v`1.1.0`     | `3.4.4`              |
| v`1.0.0`     | `3.4.4`              |
| v`1.0.0-jam` | `3.4.4`              |

If you are using game version `1.1.1` or below, these instructions will not be
accurate.

## Pre-cleaning
Godot Engine will allow you to overwrite exported files but it is recommended
to delete old exported files before you begin. This means all files in the
`linux/`, `mac/`, `web/`, and `windows/` directories in this directory except
for their `.empty` files.

The `.empty` files allow these directories to appear in Git if they otherwise
contain no files. All other files in these directories are ignored by Git.

## Exporting
Use the following steps to export the game from Godot Engine:

1. Open the project in the correct version of Godot Engine.
2. Wait for any assets to be reimported. (A progress bar may appear.)
3. Make sure you have export templates and export tools
(such as [rcedit](https://github.com/electron/rcedit)) set up in Godot Engine's
settings.
4. Select `Project > Export...` to open the 'Export' menu.
5. Select `Export All... > Release` to begin exporting the game.
6. Wait for the exporting process to finish. You may now close Godot Engine.

# Distributing to itch.io
Builds of the game are distributed to
[itch.io](https://ruxaroh.itch.io/the-house-always-wins) using their command
line tool, [butler](https://itch.io/docs/butler). Please see the documentation
for more information.

## Updating butler
If you have butler installed, you can update it from the command line by using
the following command.
```
butler upgrade
```

## Using butler
The following butler commands are used from this directory to push builds to
itch.io.
```
butler push --ignore=.empty --userversion-file=version.txt web ruxaroh/the-house-always-wins:web
butler push --ignore=.empty --userversion-file=version.txt windows ruxaroh/the-house-always-wins:windows
butler push --ignore=.empty --userversion-file=version.txt mac ruxaroh/the-house-always-wins:mac
butler push --ignore=.empty --userversion-file=version.txt linux ruxaroh/the-house-always-wins:linux
```

`version.txt` holds the version that will be displayed on itch.io. It should be
written in UTF-8 without a byte order mark and avoid leading and trailing
whitespace.

# Distributing to GitHub
Builds in `.zip` files on the
[GitHub releases page](https://github.com/krobbi/gmtk-2022/releases) are ripped
from the itch.io game page by selecting `Edit game` and selecting
`More... > Download` on each release channel. Because of this, tags and
releases are published on GitHub after the game is available on itch.io.
