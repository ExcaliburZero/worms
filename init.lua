local RADIUS = 1

local nodes = {"group:crumbly", "group:cracky", "group:choppy", "group:snappy"}

minetest.register_abm({
    nodenames = {"default:nyancat"},
    interval = 1.0,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local dir = minetest.facedir_to_dir(node.param2, true)
        local p = {x=pos.x-dir.x,y=pos.y-dir.y,z=pos.z-dir.z}

        -- Move forward and change direction if facing anything exept stone
        local p_node = minetest.get_node(p)
        if math.random(1,100) ~= 1 and
        (p_node.name == "default:stone"
        or p_node.name == "default:mossycobble"
        or p_node.name == "air"
        or p_node.name == "default:water_flowing"
        or p_node.name == "default:water_source"
        or p_node.name == "default:lava_flowing"
        or p_node.name == "default:lava_source") then
            minetest.set_node(p, node)
            minetest.remove_node(pos)
        else
            node.param2 = math.random(0,22)
            minetest.set_node(pos, node)
        end

        -- Dig the way
        for dx=-RADIUS,RADIUS do
            for dz=-RADIUS,RADIUS do
                for dy=-RADIUS,RADIUS do
                    local npos = {x=pos.x + dx, y=pos.y + dy, z=pos.z + dz}
                    local nnode = minetest.get_node(npos)
                    if nnode.name == "default:stone"
                    or nnode.name == "default:mossycobble" then
                        -- Randomly create rainbows or air:
                        if math.random(1, 100) == 1 then
                            minetest.set_node(npos, {name="default:nyancat_rainbow"})
                        else
                            minetest.remove_node(npos)
                        end
                    end
                end
            end
        end

        -- Create mossy walls:
        while true do
            local stone = minetest.find_node_near(pos, RADIUS + 1, "default:stone")
            if not stone then
                return
            end
            -- Randomly create mese lamps or mossy cobblestone
            if math.random(1, 80) == 1 then
                minetest.set_node(stone, {name="default:meselamp"})
            else
                minetest.set_node(stone, {name="default:mossycobble"})
            end
        end
    end,
})
