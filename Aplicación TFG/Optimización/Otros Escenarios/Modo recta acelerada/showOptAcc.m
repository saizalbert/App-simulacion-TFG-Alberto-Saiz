%% Enseñar optimización acelerada
clc, clear, close all
load 'primeraOptTiempoConv.mat'
%load 'optiAccUmbral.mat'
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