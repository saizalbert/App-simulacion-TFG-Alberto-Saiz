%% Optimización 1 Con Medias por Valor
clear, clc, close all 
addpath('..\..\Simulación Algoritmo Propuesto')
tic
%% Resultados empíricos 

%% Inicialización variables a optimizar
param.res=100; 
param.monitor=get(0,'ScreenSize');
param.periodoT=1.5;
umbral=100; 
q=0;
rangoLong=500;
rangoMedia=50; 
rango=linspace(0,1e6, rangoLong); 
%% Inicialización vindicadores 
mejoraCart=zeros(rangoLong,3); 
mejoraSph=zeros(rangoLong,3);
precisionAcc=zeros(rangoLong,3);
fiabilidad=zeros(1,rangoLong); 
fallosTotales=zeros(1,rangoLong); 
tiemposConvergencia=zeros(1,rangoLong);
tiempoConvRelativo=zeros(1,rangoLong);
%%
[datosBlanco,N, modF]=blancoRectaAcelerada(param);
cont=1; 
for inicialEscalaP=rango
    cuentaNoVale=0;
    fallos=0;
    mejoraCartMedia=zeros(rangoMedia,3); 
    mejoraSphMedia=zeros(rangoMedia,3);
    precisionAccMedia=zeros(rangoMedia,3);
    tiemposConvergenciaMedia=zeros(1,rangoMedia);
    for k=1:rangoMedia
        [blanco, kalman, errorRadar, errorKalman]=funcionOptimizacion(q,umbral,datosBlanco, inicialEscalaP, N,modF, param);
        %[blanco, kalman, errorRadar, errorKalman]=funcionOptimizacionPdiferente(q,umbral,datosBlanco, inicialEscalaP, N,modF, param);
        if ~errorKalman{1}.existeTraza
            mejoraCartMedia(k,:)=mejoraCartMedia(k-1,:);
            mejoraSphMedia(k,:)=mejoraSphMedia(k-1,:);
            precisionAccMedia(k,:)=precisionAccMedia(k-1,:);
            tiemposConvergenciaMedia(k)=tiemposConvergenciaMedia(k-1);
            fallos=fallos+1;
            continue; 
        end 
        if length(errorKalman{1}.cart(:,1)) ~=param.res 
            cuentaNoVale=cuentaNoVale+1;
        end
        mejoraCartMedia(k,:)=errorKalman{1}.mejora_cart;
        mejoraSphMedia(k,:)=errorKalman{1}.mejora_sph;
        precisionAccMedia(k,:)=errorKalman{1}.precisionAccFinal;
        tiemposConvergenciaMedia(k)=tiempoConvergencia(errorRadar, errorKalman,param,N);
    end
        fiabilidad(cont)=cuentaNoVale; 
        fallosTotales(cont)=fallos; 
        mejoraCart(cont,:)=mean(mejoraCartMedia);
        mejoraSph(cont,:)=mean(mejoraSphMedia);
        precisionAcc(cont,:)=mean(precisionAccMedia);
        tiemposConvergencia(cont)=mean(tiemposConvergenciaMedia);
        tiempoConvRelativo(cont)=(1-tiemposConvergencia(cont)/(param.res*param.periodoT))*100;
        clc
        cont=cont+1;
        disp((cont-1)/rangoLong*100 +"%")
end
%% Función optimización
pesoMejoraCart=1/3; 
pesoPrecision=1/3; 
pesoTiempo=1/3; 
optimizacion=sum(1/3*(pesoMejoraCart.*mejoraCart+pesoPrecision.*precisionAcc+pesoTiempo.*tiempoConvRelativo'),2);
%% Representación de mejoras
figure(1)

subplot(3,1,1)
plot(rango, mejoraCart(:,1))
title('Mejora en cartesianas coordenada x') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

subplot(3,1,2)
plot(rango, mejoraCart(:,2))
title('Mejora en cartesianas coordenada y') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

subplot(3,1,3)
plot(rango, mejoraCart(:,3))
title('Mejora en cartesianas coordenada z') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

figure(2)

subplot(3,1,1)
plot(rango, mejoraSph(:,1))
title('Mejora en esféricas coordenada r') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

subplot(3,1,2)
plot(rango, mejoraSph(:,2))
title('Mejora en esféricas coordenada phi') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

subplot(3,1,3)
plot(rango, mejoraSph(:,3))
title('Mejora en esféricas coordenada theta') 
xlabel('q') 
ylabel('Mejora en %')
grid on

figure(3)

subplot(3,1,1)
plot(rango, precisionAcc(:,1))
title('Precisión de aceleración coordenada x') 
xlabel('q') 
ylabel('Precision de aceleración') 
grid on

subplot(3,1,2)
plot(rango, precisionAcc(:,2))
title('Precisión de aceleración coordenada y') 
xlabel('q') 
ylabel('Precisión de aceleración') 
grid on

subplot(3,1,3)
plot(rango, precisionAcc(:,3))
title('Precisión de aceleración coordenada z') 
xlabel('q') 
ylabel('Precisión de aceleración') 
grid on

figure(4)
plot(rango,tiemposConvergencia)
title('Tiempos de convergencia') 
xlabel('q') 
ylabel('Tiempo convergencia medio(s)') 
grid on

figure(5) 
plot(rango, optimizacion)
title('Funcion optimización') 
xlabel('q') 
ylabel('Optimización') 
grid on
%% Máximos 
[maxMejoraCart, indexMaxMejoraCart]=max(mejoraCart); 
[maxMejoraSph, indexMaxMejoraSph]=max(mejoraSph); 
[maxErrorAcc, indexMaxErrorAcc]=max(precisionAcc);
mejorCart=rango(indexMaxMejoraCart);
mejorSph=rango(indexMaxMejoraSph);
mejorAcc=rango(indexMaxErrorAcc);
%% Tiempos 
t=toc;
disp("La simulación ha durado " + t + " s o "+ t/60 + " min")




