local qualities = table.deepcopy(data.raw["quality"])

local new_machines = {}

for mname, machine_orig in pairs(data.raw["assembling-machine"]) do
    for qname, qvalue in pairs(qualities) do
        if machine_orig.module_slots ~= nil and machine_orig.module_slots > 0 and qvalue.level > 0 then
            local machine = table.deepcopy(machine_orig)
            if machine_orig.placeable_by == nil then
                if machine_orig.minable.result ~= nil then
                    machine.placeable_by = {item=machine_orig.minable.result, count=1, quality=qvalue}
                else
                    machine["results"] = {}
                    for idx,result in pairs(machine_orig.minable.results) do
                        local copy = table.deepcopy(result)
                        copy["quality"]=qvalue
                        machine["results"][idx] = copy
                    end
                end
            elseif machine_orig.placeable_by["item"] ~= nil then
                machine.placeable_by = table.deepcopy(machine_orig.placeable_by)
                machine.placeable_by["quality"]=qvalue
            else
                machine.placeable_by = table.deepcopy(machine_orig.placeable_by)
                for idx,value in pairs(machine_orig.placeable_by) do
                    machine.placeable_by[idx]["quality"] = qvalue
                end
                log(tostring(machine.placeable_by[1]["item"]))
            end
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