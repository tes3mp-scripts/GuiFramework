A convenient way to call standard tes3mp GUI functions.

Adds a function for every GUI type, which does basic work for you: gets and stores GUI ids and returns button/list labels as well as their number.

Functions
=====
Most of them have arguments similar to the originals, but with `id` replaced with `name`, which should be a unique string. I recommend adding your module's name as a prefix, e.g. `"CustomAlchemy_PotionName"`. `callback`, where necessary, will be called after the player closes the GUI element.
* `GuiFramework.MessageBox(opt)`  
    ```Lua
    opt = {
        --mandatory
        pid,
        name,
        label
    }
    ```
* `GuiFramework.CustomMessageBox(opt)`  
    ```Lua
    opt = {
        --mandatory
        pid,
        name,
        buttons,
        --optional
        label,
        callback,
        returnValues,
        parameters
    }
    ```
  `buttons` is an array of button labels.  
  `callback(pid, name, input, value, parameters)`, `input` is the number of the box in `buttons` and `value` is its label.
  `returnValues` optional array of data you would like to be returned instead of a button's label  
  `parameters` data to be passed through to `callback`
* `GuiFramework.InputDialog(opt)`  
    ```Lua
    opt = {
        --mandatory
        pid,
        name,
        --optional
        label,
        note,
        callback,
        parameters
    }
    ```
  `callback(pid, name, data, parameters)`, `data` is the string that player has put in.
* `GuiFramework.PasswordDialog(opt)`  
    ```Lua
    opt = {
        --mandatory
        pid,
        name,
        --optional
        label,
        note,
        callback,
        parameters
    }
    ```
  `callback(pid, name, data)`, `data` is the string that player has put in.
* `GuiFramework.ListBox(opt)`  
    ```Lua
    opt = {
        --mandatory
        pid,
        name,
        rows,
        --optional
        label,
        callback,
        returnValues,
        parameters
    }
    ```
  `rows` is an array of strings, without line breaks.  
  `callback(pid, name, input, value)`, `input` is the number of chosen row in `rows`, `value` is its string. If the player clicked the `Ok` button, `input` will be the same as with the standard function, and `value` is going to be `nil`.  
  `returnValues` optional array of data you would like to be returned instead of a row's label