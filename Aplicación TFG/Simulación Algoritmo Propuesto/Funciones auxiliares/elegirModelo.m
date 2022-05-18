function [modF]=elegirModelo()
fn{1}='NCV: Nearly Constant Velocity Motion Model';
fn{2}='NCA: Nearly Constant Acceleration Motion Model';
[indx,tf] = listdlg('PromptString',{'Seleccione el modelo cinemático usado en la simulación',...
        'Solo se puede seleccionar un modelo cinemático',''},...
        'SelectionMode','single','ListString',fn, 'ListSize',[300,250]);
modF=indx;
end

