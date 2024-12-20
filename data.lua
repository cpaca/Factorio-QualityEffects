local qualities = table.deepcopy(data.raw["quality"])

local new_machines = {}

for mname, machine_orig in pairs(data.raw["assembling-machine"]) do
    for qname, qvalue in pairs(qualities) do
        if machine_orig.module_slots ~= nil and machine_orig.module_slots > 0 and qvalue.level > 0 then
            local machine = table.deepcopy(machine_orig)
            machine.placeable_by = {item=machine_orig.minable.result, count=1, quality=qvalue}
            machine.localised_name = {"entity-name." .. mname}
            machine.localised_description = {"entity-description." .. mname}
            machine.hidden = true
            machine.name = "QualityEffects-" .. qname .. "-" .. machine.name
            machine.module_slots = machine.module_slots + qvalue.level

            table.insert(new_machines, machine)
        end
    end
end

data.extend(new_machines)