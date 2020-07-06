--[[
--  API Name    : inventory
--  Author      : LinaTsukusu
--  Version     : 1.4
--
--  Turtle's Inventory Controller API
--]]

inventory = {}

function inventory.isEqual(slot, itemName, itemDamage)
    local detail = turtle.getItemDetail(slot)
    local result
    if detail ~= nil and detail.name == itemName then
        if itemDamage ~= nil then
            if detail.damage == itemDamage then
                result = true
            else
                result = false
            end
        else
            result = true
        end
    else
        result = false
    end

    return result
end

-- function searchItemFrom(itemName, startSlot)
function inventory.searchItemFrom(startSlot, itemName, itemDamage)

    local i = startSlot
    while i <= 16 and not inventory.isEqual(i, itemName, itemDamage) do
        i = i + 1
    end
    if i > 16 then
        i = nil
    end
    return i

end

-- function searchItem(itemName)
--   return searchItemFrom(itemName, 1)
-- end
function inventory.searchItem(itemName, itemDamage)
    return inventory.searchItemFrom(1, itemName, itemDamage)
end

function inventory.searchItemAll(itemName, itemDamage)
    local ret = {}
    -- local i = 1
    -- local slot = searchItemFrom(itemName, 1)
    local slot = inventory.searchItemFrom(1, itemName, itemDamage)
    while slot and slot < 16 do
        -- ret[i] = slot
        table.insert(ret, slot)
        -- slot = searchItemFrom(itemName, slot + 1)
        slot = inventory.searchItemFrom(slot + 1, itemName, itemDamage)
        -- i = i + 1
    end
    return ret
end

function inventory.getItemCountSum(itemName, itemDamage)
    local slots = inventory.searchItemAll(itemName, itemDamage)
    local sum = 0
    for k, v in ipairs(slots) do
        sum = sum + turtle.getItemCount(v)
    end
    return sum
end


function inventory.compressItem()
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        local count = turtle.getItemCount(i)
        if item ~= nil and count < 64 then
            for j = i + 1, 16 do
                -- local slot = searchItemFrom(item.name, j)
                local slot = inventory.searchItemFrom(j, item.name, item.damage)
                if slot then
                    turtle.select(slot)
                    turtle.transferTo(i)
                end
            end
        end
    end
    turtle.select(1)
end

function inventory.isSpaceInventory()
    local slot = 1
    local ret = false
    while ret == false and slot <= 16 do
        if turtle.getItemCount(slot) == 0 then
            ret = true
        end
        slot = slot + 1
    end
    return ret
end

function inventory.isFullInventory()
    local ret = true
    if inventory.isSpaceInventory() ~= true then
        inventory.compressItem()
        ret = not inventory.isSpaceInventory()
    else
        ret = false
    end
    return ret
end

return inventory