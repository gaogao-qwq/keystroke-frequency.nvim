<h1 align="center">Keystroke frequency statistics tool for NeoVim</h1>

> [!NOTE]
> This project is just a toy project and there is no warranty that
> it will work as expected.

A simple plugin to record and export statistics as Markdown of your keystrokes
by following format:

| rank | Command | Count | % of Total | % of None Data Entry |
| ---: | ------: | ----: | ---------: | -------------------: |
| 1 | char | 19386 | 63.34 | N/A |
| 2 | gj | 3871 | 12.65 | 34.50 |
| 3 | gk | 3176 | 10.38 | 28.31 |
| 4 | h | 928 | 3.03 | 8.27 |
| 5 | e | 638 | 2.08 | 5.69 |
| 6 | b | 600 | 1.96 | 5.35 |
| 7 | j | 455 | 1.49 | 4.06 |
| 8 | i | 210 | 0.69 | 1.87 |
| 9 | A | 194 | 0.63 | 1.73 |

## Installation

```lua
{
  "gaogao-qwq/keystroke-frequency.nvim",
  config = function()
    require("keystroke-frequency").setup()
  end,
}
```

## References

[Emacs: Command Frequency Statistics](http://xahlee.info/emacs/emacs/command-frequency.html)
