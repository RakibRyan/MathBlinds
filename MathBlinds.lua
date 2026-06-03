--- STEAMODDED HEADER
--- MOD_NAME: Math Blinds
--- MOD_ID: MathBlinds
--- PREFIX: mathbl
--- MOD_AUTHOR: [Bazinga_9000, tauttie]
--- MOD_DESCRIPTION: Adds more blinds based on mathematical symbols
--- VERSION: 1.2.3

local mod_path = SMODS.current_mod.path

-- SMODS 1.0 compliant Atlas registration
SMODS.Atlas({
    key = "mathblinds",
    path = "mathblinds.png",
    px = 34,
    py = 34
})

local blind_list = {
    "bottom", "radical", "norm", "tip", "bar", "aggregate", "floor",
    "drop", "approach", "infinite", "witness", "diamond_difference",
    "mahogany_millennium", "vanilla_void", "cappuccino_circus",
    "emerald_embedding", "waiouru_wreath"
}

for _, v in ipairs(blind_list) do
    -- SMODS 1.0 native file loader 
    local chunk, err = SMODS.load_file("blinds/" .. v .. ".lua")
    
    -- Fallback to NFS
    if not chunk and NFS then
        chunk, err = NFS.load(mod_path .. "blinds/" .. v .. ".lua")
    end
    
    if not chunk then
        sendErrorMessage("[MathBlinds] Failed to load blind file: " .. v .. " | Error: " .. tostring(err))
    else
        local blind_data = chunk()
        if type(blind_data) == "table" then
            -- Assign required object IDs directly to the table
            blind_data.key = v
            blind_data.atlas = "mathblinds"
            blind_data.discovered = false
            
            -- FIX 1: Force a root weight of 0 (minimum uses) to prevent boolean injection
            blind_data.weight = 0
            
            -- FIX 2: Override in_pool to securely return the integer directly
            blind_data.in_pool = function(self)
                local min = self.boss and self.boss.min or 0
                local max = self.boss and self.boss.max or 99
                local ante = G.GAME.round_resets.ante
                
                if ante >= min and ante <= max then
                    -- Returns true for eligibility, and the actual uses integer as the weight
                    return true, G.GAME.bosses_used[self.key] or 0
                end
                return false
            end
            
            -- Register the custom blind
            SMODS.Blind(blind_data)
        else
            sendErrorMessage("[MathBlinds] Blind file " .. v .. ".lua did not return a valid configuration table.")
        end
    end
end

