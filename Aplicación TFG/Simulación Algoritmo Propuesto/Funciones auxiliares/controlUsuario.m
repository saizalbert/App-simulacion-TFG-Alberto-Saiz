function [guardarResultado,figurasSimultaneas]=controlUsuario()
monitor=get(0,'ScreenSize'); 
% Create figure
h.f = figure('units','pixels','position',[monitor(3)/2-100,monitor(4)/2-50, 350, 50],...
             'toolbar','none','menu','none');

% Create yes/no checkboxes
h.c(1) = uicontrol('style','checkbox','units','pixels',...
                'position',[10,30,300,15],'string','Guardar resultados');
h.c(2) = uicontrol('style','checkbox','units','pixels',...
                'position',[150,30,300,15],'string','Visualizar figuras simultáneamente');    
% Create OK pushbutton   
h.p = uicontrol('style','pushbutton','units','pixels',...
                'position',[(monitor(3)/2-100)/4,5,70,20],'string','Siguiente',...
                'callback',@p_call);
bool=true;
% Pushbutton callback
    function [guardarResultado,figurasSimultaneas]=p_call(varargin)
        vals = get(h.c,'Value');
        guardarResultado=vals{1}; 
        figurasSimultaneas=vals{2}; 
        close(h.f)
        clear('h'), clear('monitor'), clear('vals'), clear('varargin')
        save 'controlUsuario.mat'
    end
uiwait(h.f)
load 'controlUsuario.mat'
end

