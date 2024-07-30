local love = require("love")

function SFX()
    local bgm = love.audio.newSource("som/bgm.mp3", "stream")
    bgm:setVolume(0.1)
    bgm:setLooping(true)
     return{
        playing_BGM = function(self)
            if not bgm:isPlaying() then
                return false
            else
                return true
            end
        end,   
        PandS_BGM = function(self)
            if self.playing_BGM() then
                bgm:stop()
            else
                bgm:play()
            end
        end,     
        volume = function(self, volume)
            bgm:setVolume(volume)
        end
     }
end

return SFX