%% Enseñar optimizacion
clear, clc, close all
load 'optimizacionUmbral.mat'
%% Representación de mejoras 
figure(1)

subplot(3,1,1)
plot(rango, mejoraCart(:,1),'r','linewidth',1.5)
title('Mejora en cartesianas coordenada x','interpreter','latex') 
xlabel('dth') 
ylabel('Mejora en %') 
grid on

subplot(3,1,2)
plot(rango, mejoraCart(:,2),'r','linewidth',1.5)
title('Mejora en cartesianas coordenada y','interpreter','latex') 
xlabel('dth') 
ylabel('Mejora en %') 
grid on

subplot(3,1,3)
plot(rango, mejoraCart(:,3),'r','linewidth',1.5)
title('Mejora en cartesianas coordenada z','interpreter','latex') 
xlabel('dth') 
ylabel('Mejora en %') 
grid on

figure(2)

subplot(3,1,1)
plot(rango, mejoraSph(:,1),'b','linewidth',1.5)
title('Mejora en esfericas coordenada r','interpreter','latex') 
xlabel('dth') 
ylabel('Mejora en %') 
grid on

subplot(3,1,2)
plot(rango, mejoraSph(:,2),'b','linewidth',1.5)
title('Mejora en esfericas coordenada phi','interpreter','latex') 
xlabel('dth') 
ylabel('Mejora en %') 
grid on

subplot(3,1,3)
plot(rango, mejoraSph(:,3),'b','linewidth',1.5)
title('Mejora en esfericas coordenada theta','interpreter','latex') 
xlabel('dth') 
ylabel('Mejora en %')
grid on

figure(3)
plot(rango,tiemposConvergencia,'k','linewidth',1.5)
title('Tiempos de convergencia','interpreter','latex') 
xlabel('dth') 
ylabel('Tiempo convergencia medio(s)') 
grid on

figure(4) 
plot(rango, optimizacion,'k','linewidth',1.5)
title('Funcion optimizacion','interpreter','latex') 
xlabel('dth') 
ylabel('Optimización') 
grid on
%% Máximos 
[maxMejoraCart, indexMaxMejoraCart]=max(mejoraCart); 
[maxMejoraSph, indexMaxMejoraSph]=max(mejoraSph); 
mejorCart=rango(indexMaxMejoraCart);
mejorSph=rango(indexMaxMejoraSph);