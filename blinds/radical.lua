local blind = {
	loc_txt =  	{
        name = 'The Radical',
        text = { 'All enhanced cards',  'are debuffed' }
    },
    -- Added weight = 1 to prevent SMODS from injecting a boolean
    boss = { min = 2, max = 10, weight = 1 }, 
    boss_colour = HEX("54a74b"),
    atlas = "mathblinds",
    pos = { x = 0, y = 3},
}

blind.debuff_card = function(self, card, from_blind)
    if card.area ~= G.jokers then
        return card.config.center ~= G.P_CENTERS.c_base
    end
end

return blind
