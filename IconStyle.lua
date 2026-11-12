-- Icon style: the methods every style has. A style starts from this with
-- CreateFromMixins(ns.IconStyle) and overrides the methods it needs.
--
-- parts: { frame, texture, cooldown }, shared by all styles. Before Apply,
-- the icon resets them to its baseline, so a style only sets what differs.

local _, ns = ...

if not ns.AddonIsActive() then return end

ns.IconStyle = {}

-- Configures the shared parts and shows the style's own elements.
function ns.IconStyle:Apply(_parts) end

-- Hides the style's own elements and detaches what it attached to the parts.
function ns.IconStyle:Remove(_parts) end

function ns.IconStyle:ShowRunning(_startedAt, _duration) end

function ns.IconStyle:ShowExpired() end

function ns.IconStyle:ShowRemaining(_seconds) end
