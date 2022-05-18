%% Enseñar optimizacion
clear, clc, close all
load 'optimizacionCircularModF2q0.mat'
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

%% Máximos 
[maxMejoraCart, indexMaxMejoraCart]=max(mejoraCart); 
[maxMejoraSph, indexMaxMejoraSph]=max(mejoraSph); 
mejorCart=rango(indexMaxMejoraCart);
mejorSph=rango(indexMaxMejoraSph);