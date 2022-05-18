function [modo]=elegirModo()
fn{1}='Movimiento circular uniforme (MCU)';
fn{2}='Movimiento radial hacia el origen';
fn{3}='Movimiento aleatorio';
fn{4}='Movimiento circular con variaciones aleatorias';
fn{5}='Movimiento radial con variaciones aleatorias';
fn{6}='Movimiento rectilíneo con velocidad constante (MRU)';
fn{7}= 'Movimiento rectilíneo con velocidad constante con variaciones aleatorias.' ;
fn{8}='Caída libre' ;
fn{9}='Movimiento rectilíneo uniformemente acelerado (MRUA)';
fn{10}='Movimiento rectilíneo uniformemente acelerado (MRUA) con variaciones aleatorias';
fn{11}= 'Variación 1 (Circular + rectilíneo)' ;
fn{12}='Variación 2 (Cambio de vector velocidad y aceleración)'; 
fn{13}='Modo kamikaze';
fn{14}='Tiro balístico';
fn{15}='Espiral';

[indx,tf] = listdlg('PromptString',{'Seleccione el modo de movimiento del blanco ',...
        'Solo se puede seleccionar un modo de movimiento',''},...
        'SelectionMode','single','ListString',fn, 'ListSize',[400,300]);
modo=indx;
end
