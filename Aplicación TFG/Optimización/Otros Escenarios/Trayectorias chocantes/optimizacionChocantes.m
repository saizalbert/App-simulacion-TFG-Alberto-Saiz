%% Optimización 1 Con Medias por Valor
clear, clc, close all 
addpath('..\..\Simulación Algoritmo Propuesto')
tic
%% Resultados empíricos 

%% Inicialización variables a optimizar
param.res=100; 
param.monitor=get(0,'ScreenSize');
param.periodoT=1.5;
%inicialEscalaP=1000; 
umbral=100; 
q=0; %Óptimo para rectas constantes
rangoLong=100;
rangoMedia=200; 
rango=linspace(0,5000, rangoLong); 
%% Inicialización vindicadores 
mejoraCart=zeros(rangoLong,3); 
mejoraSph=zeros(rangoLong,3);
precisionVel=zeros(rangoLong,3);
fiabilidad=zeros(1,rangoLong); 
fallosTotales=zeros(1,rangoLong); 
tiemposConvergencia=zeros(1,rangoLong);
tiempoConvRelativo=zeros(1,rangoLong);
%%
[datosBlanco,N, modF]=blancoRectaChocantes(param);
cont=1; 
for inicialEscalaP=rango
    cuentaNoVale=0;
    fallos=0;
    mejoraCartMedia1=zeros(rangoMedia,3); 
    mejoraSphMedia1=zeros(rangoMedia,3);
    precisionVelMedia1=zeros(rangoMedia,3);
    mejoraCartMedia2=zeros(rangoMedia,3); 
    mejoraSphMedia2=zeros(rangoMedia,3);
    precisionVelMedia2=zeros(rangoMedia,3);
    tiemposConvergenciaMedia=zeros(rangoMedia,2);
    for k=1:rangoMedia
        [blanco, kalman, errorRadar, errorKalman]=funcionOptimizacion(q,umbral,datosBlanco, inicialEscalaP, N,modF, param);
        if ~errorKalman{1}.existeTraza || ~errorKalman{2}.existeTraza
            if k~=1
            mejoraCartMedia1(k,:)=mejoraCartMedia1(k-1,:);
            mejoraSphMedia1(k,:)=mejoraSphMedia1(k-1,:);
            precisionVelMedia1(k,:)=precisionVelMedia1(k-1,:);
            fallos=fallos+1;
            continue; 
            else 
            mejoraCartMedia1(k,:)=0;
            mejoraSphMedia1(k,:)=0;
            precisionVelMedia1(k,:)=0;
            fallos=fallos+1;
            continue; 
            end 
        end 
        if length(errorKalman{1}.cart(:,1)) ~=param.res 
            cuentaNoVale=cuentaNoVale+1;
        end
        mejoraCartMedia1(k,:)=errorKalman{1}.mejora_cart;
        mejoraSphMedia1(k,:)=errorKalman{1}.mejora_sph;
        precisionVelMedia1(k,:)=errorKalman{1}.precisionVelFinal;
        mejoraCartMedia2(k,:)=errorKalman{2}.mejora_cart;
        mejoraSphMedia2(k,:)=errorKalman{2}.mejora_sph;
        precisionVelMedia2(k,:)=errorKalman{2}.precisionVelFinal;
        tiemposConvergenciaMedia(k,:)=tiempoConvergencia(errorRadar, errorKalman,param,N);
    end
        fiabilidad(cont)=cuentaNoVale; 
        fallosTotales(cont)=fallos; 
        mejoraCart(cont,:)=(mean(mejoraCartMedia1)+mean(mejoraCartMedia2))/2;
        mejoraSph(cont,:)=(mean(mejoraSphMedia1)+mean(mejoraSphMedia2))/2;
        precisionVel(cont,:)=(mean(precisionVelMedia1)+mean(precisionVelMedia2))/2;
        tiemposConvergencia(cont)=sum(mean(tiemposConvergenciaMedia)/2);
        tiempoConvRelativo(cont)=(1-tiemposConvergencia(cont)/(param.res*param.periodoT))*100;
        clc
        cont=cont+1;
        disp((cont-1)/rangoLong*100 +"%")
end
%% Función optimización
pesoMejoraCart=1/3; 
pesoPrecision=1/3; 
pesoTiempo=1/3; 
optimizacion=sum(1/3*(pesoMejoraCart.*mejoraCart+pesoPrecision.*precisionVel+pesoTiempo.*tiempoConvRelativo'),2);
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
plot(rango, precisionVel(:,1))
title('Precisión de velocidad coordenada x') 
xlabel('q') 
ylabel('Precision de velocidad') 
grid on

subplot(3,1,2)
plot(rango, precisionVel(:,2))
title('Precisión de velocidad coordenada y') 
xlabel('q') 
ylabel('Precisión de velocidad') 
grid on

subplot(3,1,3)
plot(rango, precisionVel(:,3))
title('Precisión de velocidad coordenada z') 
xlabel('q') 
ylabel('Precisión de velocidad') 
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
[maxErrorVel, indexMaxErrorVel]=max(precisionVel);
mejorCart=rango(indexMaxMejoraCart);
mejorSph=rango(indexMaxMejoraSph);
mejorVel=rango(indexMaxErrorVel);
%% Tiempos 
t=toc;
disp("La simulación ha durado " + t + " s o "+ t/60 + " min")




