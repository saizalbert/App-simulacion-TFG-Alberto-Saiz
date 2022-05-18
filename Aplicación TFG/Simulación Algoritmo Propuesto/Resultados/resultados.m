clear,clc, close all
archivo='N1M10F2'; 
load(archivo); 
modos=["Circular" "Radial" "Aleatorio" "Circular con variaciones" "Radial con variaciones" "Recto uniforme" "Recto uniforme con variaciones" "Caída libre" "Movimiento recto uniformemente acelerado" "Movimiento recto uniformemente acelerado con variaciones"];
for i=1:N
    info=blanco{i};
    disp("La posición inicial en cartesianas del blanco " + i +" es " + info.pos_inicart(1) +" " +info.pos_inicart(2) +" "+info.pos_inicart(3) )
    disp("El modo de movimiento del blanco " + i + " es " + modos(info.modo))
    disp("El vector de velocidad del blanco " + i + " es " + info.vectorVel(1) +" " + info.vectorVel(2) +" " +info.vectorVel(3))
    disp("El vector de aceleración del blanco " + i + " es " + info.vectorAcc(1) + " " +info.vectorAcc(2) + " "+info.vectorAcc(3))
    disp("La velocidad lineal es " + info.v + " y la velocidad angular es " + info.w)
end 
figure(1)
for i=1:N
hold on 
plot3(blanco{i}.movcart(:,1), blanco{i}.movcart(:,2), blanco{i}.movcart(:,3),'ok')
plot3(radar{i}.detcart(:,1),radar{i}.detcart(:,2), radar{i}.detcart(:,3), 'or')
end 
legend('Trayectoria exacta blanco', 'Trayectoria simulada','Location','SouthEast')
figure(2) 
for i=trazasActivas 
    plot3(kalman{i}.historialX(:,1),kalman{i}.historialX(:,2), kalman{i}.historialX(:,3), 'ok')
end 
for i=1:N
hold on 
figure(2)
subplot(1,2,1) 
plot(1:param.res, error{i}.sph)
title("Error en esféricas de detección")
legend('r', '\phi','\theta','Location','SouthEast')
subplot(1,2,2)
plot(1:param.res, error{i}.cart)
title("Error en cartesianas de detección")
legend('x', 'y','z','Location','SouthEast')
hold off
end 
%% Funciones Convergencia Kalman 
refBlanco=1:param.res; 
for i=1:N
    figure(3+i)
    existeTraza=false;
    for j=trazasActivas
        if kalman{j}.id==i
            existeTraza=true;
            idKalman=j;
            refKalman=kalman{j}.inicioTraza:(kalman{j}.inicioTraza +length(kalman{j}.historialX(:,1))-1);
        end 
    end
    for k=1:3
        subplot(3,1,k)
        hold on
        plot(refBlanco,blanco{i}.movcart(:,k), 'k')
        plot(refBlanco,radar{i}.detcart(:,k), 'b')
        if existeTraza
            plot(refKalman,kalman{idKalman}.historialX(:,k), 'r')
            legend('Blanco','Radar','Kalman')
        else 
            legend('Blanco', 'Radar')
        end 
        hold off
        
        switch k 
            case 1
                title('Coordenada x')
            case 2
                title('Coordenada y')
            case 3
                title ('Coordenada z')
        end 
        grid on
        xlabel('t')
    end
end 