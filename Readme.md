A convenient way to call standard tes3mp GUI functions.

Adds a function for every GUI type, which does basic work for you: gets and stores GUI ids and returns button/list labels as well as their number.

Functions
=====
Most of them have arguments similar to the originals, but with `id` replaced with `name`, which should be a unique string. I recommend adding your module's name as a prefix, e.g. `"CustomAlchemy_PotionName"`. `callback`, where necessary, will be called after the player closes the GUI element.
* `GuiFramework.MessageBox(pid, name, label)`
* `GuiFramework.CustomMessageBox(pid, name, label, buttons, callback, returnValues)`  
  `buttons` is an array of button labels.  
  `callback(pid, name, input, value)`, `input` is the number of the box in `buttons` and `value` is its label.
  `returnValues` optional array of data you would like to be returned instead of a button's label
* `GuiFramework.InputDialog(pid, name, label, note, callback)`  
  `callback(pid, name, data)`, `data` is the string that player has put in.
* `GuiFramework.PasswordDialog(pid, name, label, note, callback)`  
  `callback(pid, name, data)`, `data` is the string that player has put in.
* `GuiFramework.ListBox(pid, name, label, rows, callback, returnValues)`  
  `rows` is an array of strings, without line breaks.  
  `callback(pid, name, input, value)`, `input` is the number of chosen row in `rows`, `value` is its string. If the player clicked the `Ok` button, `input` will be the same as with the standard function, and `value` is going to be `nil`.  
  `returnValues` optional array of data you would like to be returned instead of a row's label