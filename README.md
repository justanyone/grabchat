# grabchat

[![Python Tests](https://github.com/kevin/grabchat/actions/workflows/python-tests.yml/badge.svg)](https://github.com/kevin/grabchat/actions/workflows/python-tests.yml)

Grabchat exports a Claude Code session transcript into a readable Markdown file and saves it under a local .chat_history directory.

It is designed to be useful both as a standalone utility and as a small repo that can be copied into another project. The goal is simple: take the transcript from a Claude Code session and turn it into an easy-to-read export you can inspect, share, or archive.

## What it does

- Reads Claude Code session logs stored as .jsonl files
- Filters out noisy or internal system artifacts
- Renders the conversation into a clean Markdown document
- Writes the export to .chat_history/ by default
- Optionally opens the resulting Markdown in a browser after export

## Requirements

- Python 3.9+
- Access to a Claude Code project directory under ~/.claude/projects/

## Installation

Clone the repository and run the CLI from the repo root:

```bash
git clone https://github.com/yourname/grabchat.git
cd grabchat
python3 scripts/grabchat.py --help
```

If you want to install it as a package in the current environment, you can also use:

```bash
pip install .
```

After installation, the command-line entry point becomes:

```bash
grabchat --help
```

## Usage

Typical commands:

```bash
python3 scripts/grabchat.py
python3 scripts/grabchat.py --list
python3 scripts/grabchat.py myfile
python3 scripts/grabchat.py -o path/to/out.md
```

### How the output is named

By default, exports are written to .chat_history/ using names like:

```text
.chat_history/chat_20260703_175255_exp_20260703_192115.md
```

You can also preserve a simpler filename by editing the configuration file described below.

## Configuration

A sample configuration file is included at [.claude/scripts/grabchat.ini](.claude/scripts/grabchat.ini). It controls things such as:

- timestamp rendering style
- how many exports are retained
- whether the latest export keeps a fixed filename
- whether the browser opens automatically

## Repository layout

- [.claude/scripts/grabchat.py](.claude/scripts/grabchat.py) — main implementation
- [scripts/grabchat.py](scripts/grabchat.py) — repo-friendly wrapper entry point
- [.claude/scripts/grabchat.ini](.claude/scripts/grabchat.ini) — default configuration
- [.claude/skills/grabchat_skill.md](.claude/skills/grabchat_skill.md) — Claude skill instructions

## Development

Run the test suite with:

```bash
pytest
```

## Notes

- The script is intentionally simple and dependency-light so it is easy to copy into another project.
- The browser auto-open feature is best-effort and only works when a browser binary is available.
