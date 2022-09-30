-- From Garan
-- https://forums.lotro.com/forums/showthread.php?468944-how-to-write-a-timer&p=6290840#post6290840

Timer = class( Turbine.UI.Control );
function Timer:Constructor()
    Turbine.UI.Control.Constructor( self );

    self.EndTime=Turbine.Engine.GetGameTime();

    self.Repeat=false;

    self.SetTime=function(sender, numSeconds, setRepeat)
        numSeconds=tonumber(numSeconds);
        if numSeconds==nil or numSeconds<=0 then
            numSeconds=0;
        end
        self.EndTime=Turbine.Engine.GetGameTime()+numSeconds;
        self.Repeat=false; -- default
        self.NumSeconds=numSeconds;
        if setRepeat~=nil and setRepeat~=false then
            -- any non-false value will trigger a repeat
            self.Repeat=true;
        end
        self:SetWantsUpdates(true);
    end
    
    self.Update=function()
        if self.EndTime~=nil and Turbine.Engine.GetGameTime()>=self.EndTime then
            self:SetWantsUpdates(false); -- turn off timer to avoid firing again while we are processing (not likely but it's a good practice)
            -- fire whatever event you are trying to trigger
            if self.TimeReached~=nil then
                if type(self.TimeReached)=="function" then
                    self.TimeReached();
                elseif type(self.TimeReached)=="table"  then
                    for k,v in pairs(self.TimeReached) do
                        if type(v)=="function" then
                            v();
                        end
                    end
                end
            end
            if self.Repeat then
                self.EndTime=Turbine.Engine.GetGameTime()+self.NumSeconds;
                self:SetWantsUpdates(true);
            end
        end
    end
end