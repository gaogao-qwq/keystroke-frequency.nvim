<h1 align="center">Keystroke frequency statistics tool for NeoVim</h1>

> [!NOTE]
> This project is just a toy project and there is no warranty that
> it will work as expected.

A simple plugin that records and exports statistics in the following format
with a simple `:KeyFreqStats` command.

| Rank | Command | Count | % of Total | % of None Data Entry |
| ---: | ------: | ----: | ---------: | -------------------: |
| 1 | insert char | 52372 | 43.42 | N/A |
| 2 | gj | 30553 | 25.33 | 44.77 |
| 3 | gk | 23151 | 19.19 | 33.93 |
| 4 | e | 3015 | 2.50 | 4.42 |
| 5 | b | 2434 | 2.02 | 3.57 |
| 6 | l | 2030 | 1.68 | 2.97 |
| 7 | j | 1543 | 1.28 | 2.26 |
| 8 | h | 1306 | 1.08 | 1.91 |
| 9 | a | 649 | 0.54 | 0.95 |
| 10 | zv | 592 | 0.49 | 0.87 |

## Installation

```lua
{
  "gaogao-qwq/keystroke-frequency.nvim",
  config = function()
    require("keystroke-frequency").setup()
  end,
}
```

## Explanations

### What is None Data Entry?

Every input key in [insert, replace, terminal mode](./lua/keystroke-frequency/init.lua#16)
will be treated as Data Entry. In contrast, any command that does not belong
to the above mode and can be captured by [showcmd](https://neovim.io/doc/user/options.html#'showcmd')
will be treated as None Data Entry.

It should be noted that command in visual
mode will also be ignored, because in this mode, basically only quantifiers
can be captured, which is considered meaningless.

## References

[Emacs: Command Frequency Statistics](http://xahlee.info/emacs/emacs/command-frequency.html)
