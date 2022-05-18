function [tiempoConv]=tiempoConvergencia(errorRadar, errorKalman,param,N)
    ventana=param.res/10; 
for i=1:N 
    tiempoConv(i)=param.res*param.periodoT; 
    if isinf(errorKalman{i}.inicioTraza)
        continue;
    end 
    inicio=errorKalman{i}.inicioTraza; 
    contador=0;
    while(1+contador+ventana)<length(errorKalman{i}.sph(:,1))
        desvRadar=sqrt(mean(errorRadar{i}.sph((inicio+contador):(inicio+contador+ventana),:).^2));
        desvKalman=sqrt(mean(errorKalman{i}.sph((1+contador):(1+contador+ventana),:).^2));
        if desvKalman<desvRadar
            tiempoConv(i)=param.periodoT*(ventana+contador);
            break; 
        end 
        contador=contador+1;
    end 
end 
