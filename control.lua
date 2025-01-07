local function stringStarts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

local machines = {}
for name, machine in pairs(prototypes.get_entity_filtered{{filter="type", type="assembling-machine"}}) do
    if machine.module_inventory_size > 0 and not stringStarts(name, "QualityEffects-") then
        machines[name] = true
    end
end

local function check_entity(entity_name)
    if machines[entity_name] ~= nil then return true end
    return false
end

local on_built = function (data)
    local entity = data.entity
    if entity.quality.level == 0 then return end
    if not check_entity(entity.name) then return end

    local surface = entity.surface
    local info = {
        name = "QualityEffects-" .. entity.quality.name .. "-" .. entity.name,
        position = entity.position,
        direction = entity.direction,
        quality = entity.quality,
        force = entity.force,
        fast_replace = true,
        player = entity.last_user,
    }
    entity.destroy()
    surface.create_entity(info)
end

script.on_event(defines.events.on_built_entity, on_built, {{filter = "crafting-machine"}})
script.on_event(defines.events.on_robot_built_entity, on_built, {{filter = "crafting-machine"}})
script.on_event(defines.events.on_space_platform_built_entity, on_built, {{filter = "crafting-machine"}})
script.on_event(defines.events.script_raised_built, on_built, {{filter = "crafting-machine"}})
