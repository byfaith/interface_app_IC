

p = initialize_ACE


if (isfield(p,'Left')==1)
    p.General.LeftOn = 1; handles.parameters.General.LeftOn = 1;

else
    p.General.LeftOn = 0; handles.parameters.General.LeftOn = 0;

end
if (isfield(p,'Right')==1)
    p.General.RightOn = 1; handles.parameters.General.RightOn = 1;

else
    p.General.RightOn = 0; handles.parameters.General.RightOn = 0;

end

stimulate('S_01_01.wav',p)