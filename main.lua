local GuiFramework = {}

local TYPES = tableHelper.enum({
    "MessageBox",
    "CustomMessageBox",
    "InputDialog",
    "PasswordDialog",
    "ListBox"
})

GuiFramework.currentId = 0
GuiFramework.coroutines = {}
GuiFramework.MessageBoxGuiId = 'GuiFramework_MessageBox'

function GuiFramework.getGuiId(name)
    if not name then
        GuiFramework.currentId = GuiFramework.currentId + 1
        name = 'GuiFramework' .. tostring(GuiFramework.currentId)
    end
    local id = guiHelper.ID[name]
    if id ~= nil then
        return id
    end
    
    table.insert(guiHelper.names, name)
    guiHelper.ID = tableHelper.enum(guiHelper.names)
    return guiHelper.ID[name]
end

function GuiFramework.SetCoroutine(id)
    local co = coroutine.running()
    if not co then
        error('[GuiFramework] Must run inside a coroutine!')
    end
    if id then
        GuiFramework.coroutines[id] = co
    end
    return co
end

function GuiFramework.MessageBox(pid, label)
    local id = GuiFramework.getGuiId(GuiFramework.MessageBoxGuiId)
    tes3mp.MessageBox(pid, id, label)
    return true
end

--pid, buttons, [label]
function GuiFramework.CustomMessageBox(pid, buttons, label)
    local id = GuiFramework.getGuiId()
    GuiFramework.SetCoroutine(id)
    label = label or ''
    tes3mp.CustomMessageBox(pid, id, label, table.concat(buttons, ";"))
    return coroutine.yield() + 1
end

--pid, [label, note]
function GuiFramework.InputDialog(pid, label, note)
    local id = GuiFramework.getGuiId()
    GuiFramework.SetCoroutine(id)
    note = note or ''
    label = label or ''
    tes3mp.InputDialog(pid, id, label, note)
    local result = coroutine.yield()
    return result
end

--pid, [label, note]
function GuiFramework.PasswordDialog(pid, label, note)
    local id = GuiFramework.getGuiId()
    GuiFramework.SetCoroutine(id)
    label = label or ''
    note = note or ''
    tes3mp.PasswordDialog(pid, id, label, note)
    return coroutine.yield()
end

--pid, rows, [label]
function GuiFramework.ListBox(pid, rows, label)
    local id = GuiFramework.getGuiId()
    GuiFramework.SetCoroutine(id)
    local items = table.concat(rows, "\n")
    label = label or ''
    tes3mp.ListBox(pid, id, label, items)
    local result = coroutine.yield() + 1
    if result > #rows or result < 1 then
        return nil
    end
    return result
end

function GuiFramework.OnGUIAction(evenStatus, pid, id, data)
    if evenStatus.validCustomHandlers then
        local co = GuiFramework.coroutines[id]
        if co then
            GuiFramework.coroutines[id] = nil
            coroutine.resume(co, data)
        end
    end
end
customEventHooks.registerHandler("OnGUIAction", GuiFramework.OnGUIAction)

return GuiFramework
