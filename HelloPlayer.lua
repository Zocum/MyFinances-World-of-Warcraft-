SLASH_RELOADUI1 = "/rl" --For quicker reloading
SlashCmdList.RELOADUI = ReloadUI

SLASH_FRAMESTACK1 = "/fs" -- For quicker acess to frame stack
SlashCmdList.FRAMESTK = function ()
    LoadAddOn('Blizzard_DebugTools')
    FrameStackTooltip_Toggle()
end