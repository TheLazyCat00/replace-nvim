# replace-nvim 📝

replace-nvim is a Neovim plugin that lets you replace parts of your code with the content from your clipboard using text objects. This means that if you bind `t` to it, you can do `tab` (`t` around block) and the content from the + register will be inserted into that section.

[Demo](https://github.com/user-attachments/assets/1bbfe47b-f7df-42cf-9850-e306a2f51c02)

## 🛠️ Configuration

replace-nvim has no options and is designed to be used via its functions.

> [!IMPORTANT]
> Make sure you set `expr` to `true` in the keymap.

Here is an example config:

```lua
return {
    "TheLazyCat00/replace-nvim",
    opts = {},
    keys = {
        {
            "t",
            function() return require('replace-nvim').replace(5, true) end,
            mode = { "n", "x" },
            expr = true, -- ⚠️ set expr to true
            desc = "Replace with clipboard",
        },
    },
}
```

> [!NOTE]
> `replace()` is the only available function.

## 🚧 Parameters

`replace()` has 2 parameters:

- `delay`: The duration in milliseconds to check if the user is in insert mode (this is part of how the plugin operates). Lower values result in faster execution (more responsive), while higher values are less resource intensive.
- `writeToReg`: Determines whether the removed text should be placed in the + register.

---
Feel free to open issues or pull requests!
