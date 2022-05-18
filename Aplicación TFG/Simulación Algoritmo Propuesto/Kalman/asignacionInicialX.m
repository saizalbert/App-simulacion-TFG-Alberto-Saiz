function X=asignacionInicialX(posIni,modF)
switch modF
    case 1
        X=[posIni(1);0; posIni(2);0; posIni(3);0];
    case 2 
        X=[posIni(1);0;0; posIni(2);0;0; posIni(3);0;0];
end 
end 