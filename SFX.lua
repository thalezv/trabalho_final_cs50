local love = require("love")

--sound settings, such as songs, volumes, playing time
function SFX()
    local bgm = love.audio.newSource("som/bgm.mp3", "stream")
    bgm:setVolume(0.1)
    --looping
    bgm:setLooping(true)
     return{
        --check if the music is playing or not
        playing_BGM = function()
            if not bgm:isPlaying() then
                return false
            else
                return true
            end
        end,   
        --When called, the music will stop if it is playing and play if it is stopped
        PandS_BGM = function(self)
            if self.playing_BGM() then
                bgm:stop()
            else
                bgm:play()
            end
        end,  
        --changes the volume for the order   
        volume = function(self, volume)
            bgm:setVolume(volume)
        end
     }
end

return SFX