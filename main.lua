local GuiFramework = {}

local TYPES = tableHelper.enum({
    "MessageBox",
    "CustomMessageBox",
    "InputDialog",
    "PasswordDialog",
    "ListBox"
})

GuiFramework.nameCache = {}
GuiFramework.typeCache = {}
GuiFramework.callbackCache = {}
GuiFramework.returnCache = {}

function GuiFramework.getGuiId(name)
    local id = guiHelper.ID[name]
    if id ~= nil then
        return id
    end

    table.insert(guiHelper.names, name)
    guiHelper.ID = tableHelper.enum(guiHelper.names)
    return guiHelper.ID[name]
end

function GuiFramework.MessageBox(pid, name, label)
    local id = GuiFramework.getGuiId(name)
    GuiFramework.nameCache[id] = name
    GuiFramework.typeCache[id] = TYPES.MessageBox

    tes3mp.MessageBox(pid, id, label)
end

function GuiFramework.CustomMessageBox(pid, name, label, buttons, callback, returnValues)
    local id = GuiFramework.getGuiId(name)
    GuiFramework.nameCache[id] = name
    GuiFramework.typeCache[id] = TYPES.CustomMessageBox
    GuiFramework.callbackCache[id] = callback
    GuiFramework.returnCache[pid] = returnValues or buttons

    tes3mp.CustomMessageBox(pid, id, label, table.concat(buttons, ";"))
end

function GuiFramework.InputDialog(pid, name, label, note, callback)
    local id = GuiFramework.getGuiId(name)
    GuiFramework.nameCache[id] = name
    GuiFramework.typeCache[id] = TYPES.InputDialog
    GuiFramework.callbackCache[id] = callback

    note = note or ''
    label = label or ''

    tes3mp.InputDialog(pid, id, label, note)
end

function GuiFramework.PasswordDialog(pid, name, label, note, callback)
    local id = GuiFramework.getGuiId(name)
    GuiFramework.nameCache[id] = name
    GuiFramework.typeCache[id] = TYPES.PasswordDialog
    GuiFramework.callbackCache[id] = callback

    note = note or ''
    label = label or ''

    tes3mp.PasswordDialog(pid, id, label, note)
end

function GuiFramework.ListBox(pid, name, label, rows, callback, returnValues)
    local id = GuiFramework.getGuiId(name)
    GuiFramework.nameCache[id] = name
    GuiFramework.typeCache[id] = TYPES.ListBox
    GuiFramework.callbackCache[id] = callback
    GuiFramework.returnCache[pid] = returnValues or rows

    local items = table.concat(rows,"\n")

    tes3mp.ListBox(pid, id, label, items)
end

function GuiFramework.OnGUIAction(evenStatus, pid, id, data)
    local callback = GuiFramework.callbackCache[id]

    if callback ~= nil then
        local name = GuiFramework.nameCache[id]
        local type = GuiFramework.typeCache[id]

        if type == TYPES.CustomMessageBox then
            local input = tonumber(data) + 1
            local value = GuiFramework.returnCache[pid][input]

            callback(pid, name, input, value)

        elseif type == TYPES.InputDialog then
            callback(pid, name, data)

        elseif type == TYPES.PasswordDialog then
            callback(pid, name, data)

        elseif type == TYPES.ListBox then
            local input = tonumber(data) + 1
            local value = GuiFramework.returnCache[pid][input]

            callback(pid, name, input, value)
        end
    end
end

customEventHooks.registerHandler("OnGUIAction", GuiFramework.OnGUIAction)

return GuiFramework