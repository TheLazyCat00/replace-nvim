Don't use this plugin!
I stopped developing it because I found (https://github.com/gbprod/substitute.nvim)[substitute.nvim] which is way better.

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
            function() return require('replace-nvim').replace(true) end,
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

`replace()` has only parameter:

- `writeToReg`: Determines whether the removed text should be placed in the + register.

---
Feel free to open issues or pull requests!
