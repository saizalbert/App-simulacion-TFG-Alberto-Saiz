%% Optimización 1 Con Medias por Valor
clear, clc, close all 
addpath('..\..\Simulación Algoritmo Propuesto')
tic
%% Resultados empíricos 

%% Inicialización variables a optimizar
param.res=100; 
param.monitor=get(0,'ScreenSize');
param.periodoT=1.5;
param.g=9.8;
param.b=0.01;
inicialEscalaP=1000; 
umbral=1000; 
%q=0.2;
rangoLong=100;
rangoMedia=50; 
totSimul=rangoLong*rangoMedia;
contSimul=0;
rango=linspace(0,0.2, rangoLong); 
%% Inicialización vindicadores 
mejoraCart=zeros(rangoLong,3); 
mejoraSph=zeros(rangoLong,3);
precisionVel=zeros(rangoLong,3);
fiabilidad=zeros(1,rangoLong);
fallosTotales=zeros(1,rangoLong);
tiemposConvergencia=zeros(1,rangoLong);
tiempoConvRelativo=zeros(1,rangoLong);
%%
[datosBlanco,N, modF]=blancoBalistico(param);
cont=1; 
for q=rango
    cuentaNoVale=0;
    fallos=0;
    mejoraCartMedia=zeros(rangoMedia,3); 
    mejoraSphMedia=zeros(rangoMedia,3);
    tiemposConvergenciaMedia=zeros(1,rangoMedia);
    inicioTraza=zeros(1,rangoMedia);
    for k=1:rangoMedia
        [blanco, kalman, errorRadar, errorKalman]=funcionOptimizacion(q,umbral,datosBlanco, inicialEscalaP, N,modF, param);
        if ~errorKalman{1}.existeTraza
            mejoraCartMedia(k,:)=mejoraCartMedia(k-1,:);
            mejoraSphMedia(k,:)=mejoraSphMedia(k-1,:);
            fallos=fallos+1;
            continue; 
        end 
        inicioTraza(k)=errorKalman{1}.inicioTraza;
        mejoraCartMedia(k,:)=errorKalman{1}.mejora_cart;
        mejoraSphMedia(k,:)=errorKalman{1}.mejora_sph;
        tiemposConvergenciaMedia(k)=tiempoConvergencia(errorRadar, errorKalman,param,N);
    end
        fiabilidad(cont)=(param.res-mean(inicioTraza)+1); 
        fallosTotales(cont)=fallos; 
        mejoraCart(cont,:)=mean(mejoraCartMedia);
        mejoraSph(cont,:)=mean(mejoraSphMedia);
        tiemposConvergencia(cont)=mean(tiemposConvergenciaMedia);
        tiempoConvRelativo(cont)=(1-tiemposConvergencia(cont)/(param.res*param.periodoT))*100;
        clc
        cont=cont+1;
        disp((cont-1)/rangoLong*100 +"%")

end
%% Función optimización
pesoMejoraCart=1/2; 
pesoTiempo=1/2; 
optimizacion=sum(1/3*(pesoMejoraCart.*mejoraCart+pesoTiempo.*tiempoConvRelativo'),2);
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
plot(rango,tiemposConvergencia)
title('Tiempos de convergencia') 
xlabel('q') 
ylabel('Tiempo convergencia medio(s)') 
grid on

figure(4) 
plot(rango, optimizacion)
title('Funcion optimización') 
xlabel('q') 
ylabel('Optimización') 
grid on

figure(5) 
plot(rango, fiabilidad)
title('Fiabilidad de las medidas')
xlabel('q')
ylabel('Fiabilidad')
grid on
%% Máximos 
[maxMejoraCart, indexMaxMejoraCart]=max(mejoraCart); 
[maxMejoraSph, indexMaxMejoraSph]=max(mejoraSph); 
mejorCart=rango(indexMaxMejoraCart);
mejorSph=rango(indexMaxMejoraSph);
%% Tiempos 
t=toc;
disp("La simulación ha durado " + t + " s o "+ t/60 + " min")




