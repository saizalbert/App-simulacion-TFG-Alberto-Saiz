%% Enseñar optimización acelerada
clc, clear, close all
load 'optRectaF1.mat'

%load 'optiAccUmbral.mat'
%% Representación de mejoras 
figure(1)

subplot(3,1,1)
plot(rango, mejoraCart(:,1),'r','linewidth',1.5)
title('Mejora en cartesianas coordenada x','interpreter','latex') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

subplot(3,1,2)
plot(rango, mejoraCart(:,2),'r','linewidth',1.5)
title('Mejora en cartesianas coordenada y','interpreter','latex') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

subplot(3,1,3)
plot(rango, mejoraCart(:,3),'r','linewidth',1.5)
title('Mejora en cartesianas coordenada z','interpreter','latex') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

figure(2)

subplot(3,1,1)
plot(rango, mejoraSph(:,1),'b','linewidth',1.5)
title('Mejora en esfericas coordenada r','interpreter','latex') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

subplot(3,1,2)
plot(rango, mejoraSph(:,2),'b','linewidth',1.5)
title('Mejora en esfericas coordenada \phi','interpreter','latex') 
xlabel('q') 
ylabel('Mejora en %') 
grid on

subplot(3,1,3)
plot(rango, mejoraSph(:,3),'b','linewidth',1.5)
title('Mejora en esfericas coordenada \theta','interpreter','latex') 
xlabel('q') 
ylabel('Mejora en %')
grid on

figure(3)

subplot(3,1,1)
plot(rango, precisionVel(:,1),'k','linewidth',1.5)
title('Precision de velocidad coordenada x','interpreter','latex') 
xlabel('q') 
ylabel('Precision de velocidad') 
grid on

subplot(3,1,2)
plot(rango, precisionVel(:,2),'k','linewidth',1.5)
title('Precision de velocidad coordenada y','interpreter','latex') 
xlabel('q') 
ylabel('Precision de velocidad') 
grid on

subplot(3,1,3)
plot(rango, precisionVel(:,3),'k','linewidth',1.5)
title('Precision de velocidad coordenada z','interpreter','latex') 
xlabel('q') 
ylabel('Precisión de velocidad') 
grid on

figure(4)
plot(rango,tiemposConvergencia,'r','linewidth',1.5)
title('Tiempos de convergencia','interpreter','latex') 
xlabel('q') 
ylabel('Tiempo convergencia medio(s)') 
grid on

figure(5) 
plot(rango, optimizacion,'b','linewidth',1.5)
title('Funcion optimizacion','interpreter','latex') 
xlabel('q') 
ylabel('Optimización') 
grid on
 %% Máximos 
% [maxMejoraCart, indexMaxMejoraCart]=max(mejoraCart); 
% [maxMejoraSph, indexMaxMejoraSph]=max(mejoraSph); 
% [maxErrorAcc, indexMaxErrorAcc]=max(precisionAcc);
% mejorCart=rango(indexMaxMejoraCart);
% mejorSph=rango(indexMaxMejoraSph);
% mejorAcc=rango(indexMaxErrorAcc);