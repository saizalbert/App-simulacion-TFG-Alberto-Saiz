%% TFG Alberto Saiz Fernández: 
%% Simulación de algoritmo para seguimiento de blancos en tres dimensiones basado en filtro de Kalman para radar de barrido electrónico.
%% Inicialización
clc
close all
clear
addpath(genpath(pwd))
%% Parámetros control Matlab (QUITAR CUANDO SE VAYA A ENTREGAR Y PONER CHECKBOX)
%  guardarResultado=true;
%  figurasSimultaneas=false; 
 %% Parámetros de visualización de figuras
widthBig=1.5; 
widthSmall=0.8;
 %% Warnings off
warning('off')
%% Parámetros iniciales
param.res=100; 
param.monitor=get(0,'ScreenSize');
param.periodoT=1.5;
param.b=0.01; %Coeficiente de rozamiento del aire  
param.g=9.8; %Gravedad

%% Parámetros de control de usuario de simulación
umbral=1000;
q=0.0067;
%q=0.18;
%q=0.8;
inicialEscalaP=1000;
%% Parámetros radar
% Parámetros precisión según sistema AN/TPQ-53 Lockheed Martin:
paramRadar.sigmar=30;  
paramRadar.sigmaphi=1*pi/180;
paramRadar.sigmatheta=1*pi/180;
%Probabilidad de No Detección
paramRadar.pd=0.9;
%Flags de radar e información
paramRadar.contnodet=0;
paramRadar.det=false;
paramRadar.posNoDet=[];
info=[];
%% Sigmas de desviación típica de blanco
paramBlanco.sigmar=0.02;
paramBlanco.sigmaphi=0.01; 
paramBlanco.sigmatheta=0.01;
paramBlanco.tEstimado=70;
%% Bienvenida
welcome=fileread('bienvenida.txt');
uiwait(msgbox(welcome,"Alberto Saiz.2022",'help'));
[guardarResultado,figurasSimultaneas]=controlUsuario(); 
dlgTitle    = 'Elección de modo';
dlgQuestion = 'Elija el modo de generación de blancos';
gen = questdlg(dlgQuestion,dlgTitle,'Manual','Automático','Escenarios predefinidos', 'Escenarios predefinidos');
%% Inicialización objeto
switch gen
    case 'Manual'
        disp("Has elegido el modo manual")
        introduzca=inputdlg("Introduzca número de blancos","Número de blancos");
        N=str2num(introduzca{1});
        blanco=cell(1,N);
        modF=elegirModelo();
        for i=1:N
            prompt = {"R inicial blanco nº" + i,"Phi inicial blanco nº" + i , "Theta inicial blanco nº" + i, "Modo de movimiento del blanco nº" + i ,"Velocidad radial del blanco nº" + i, "Velocidad angular del blanco nº" + i, "Vector velocidad x del blanco nº" + i,"Vector velocidad y del blanco nº" + i,"Vector velocidad z del blanco nº" + i, "Escala aceleración/velocidad del blanco nº" + i};
            dlgtitle = "Blanco nº" + i;
            answer = inputdlg(prompt,dlgtitle);
            blanco{i}.r_i=str2double(answer{1});
            blanco{i}.phi_i=str2double(answer{2});
            blanco{i}.theta_i=str2double(answer{3});
            blanco{i}.modo=str2double(answer{4});
            blanco{i}.v=str2double(answer{5});
            blanco{i}.w=str2double(answer{6});
            blanco{i}.vectorVel(1)=(answer{7});
            blanco{i}.vectorVel(2)=(answer{8});
            blanco{i}.vectorVel(3)=(answer{9});
            blanco{i}.escala=(answer{10});
            blanco{i}.vectorAcc=blanco{i}.escala*blanco{i}.vectorVel;
        end
    case 'Automático'
        introduzca=inputdlg("Introduzca número de blancos","Número de blancos");
        N=str2num(introduzca{1});
        blanco=cell(1,N);
        modF=elegirModelo();
        for i=1:N
            blanco{i}.modo=elegirModo();
            blanco{i}.r_i=rand_rango(400, 800);
            blanco{i}.phi_i=rand_rango(0, 2*pi);
            blanco{i}.theta_i=rand_rango(-pi/2, pi/2);
            blanco{i}.v=rand_rango(40, 60);
            blanco{i}.a=rand_rango(0,1);
            blanco{i}.w=rand_rango(0.01*2*pi,0.02*2*pi);
            blanco{i}.vectorVel(1)=rand_rango(-150,150);
            blanco{i}.vectorVel(2)=rand_rango(-150,150);
            blanco{i}.vectorVel(3)=rand_rango(-150,150);
            blanco{i}.escala=rand_rango(-0.2,0.2);
            blanco{i}.vectorAcc=blanco{i}.escala*blanco{i}.vectorVel;
            blanco{i}.mode=1;
        end
        
    case 'Escenarios predefinidos'
        disp("Has elegido Escenarios predefinidos")
        d = dir('Blancos');
        fn = {d.name};
        fn(1)=[]; fn(1)=[];
        [indx,tf] = listdlg('PromptString',{'Seleccione el escenario a simular',...
            'Solo se puede seleccionar un escenario',''},...
            'SelectionMode','single','ListString',fn, 'ListSize',[250,250]);
        selectedRaw=fn(indx);
        selectedRaw=selectedRaw{1};
        selectedNet=selectedRaw(1:(length(selectedRaw)-2));
        [blanco, N, modF]=eval(selectedNet+"(param)");
    otherwise
        disp('Introduzca un modo de funcionamiento válido')
end
%% Inicialización estructuras asociadas a blanco
radar=cell(1,N);
errorRadar=cell(1,N);
kalman=cell(1,N);
%% Asignación inicial de blaco y radar 
for i=1:N
    %Asignación de blanco incial en cartesianas y esféricas
    blanco{i}.pos_ini=[blanco{i}.r_i blanco{i}.phi_i blanco{i}.theta_i]; %Vector de posición incial
    blanco{i}.movcart(1,:)=esf2cart(blanco{i}.pos_ini);
    blanco{i}.movsph(1,:)=cart2esf(blanco{i}.movcart(1,:));
    blanco{i}.pos_ini=blanco{i}.movsph(1,:);
    
    pos_sph(i,:)=blanco{i}.pos_ini; %Asignación a posición esféricas totales
    
    %Asignación de radar inicial en cartesianas y esféricas 
    radar{i}.detsph(1,:)=blanco{i}.pos_ini + randn*paramRadar.sigmar;
    radar{i}.detsph(1,:)=blanco{i}.pos_ini + randn*paramRadar.sigmaphi;
    radar{i}.detsph(1,:)=blanco{i}.pos_ini + randn*paramRadar.sigmatheta;
    radar{i}.detcart(1,:)=esf2cart(radar{i}.detsph(1,:));
end 

%% Inicialización de Tiempos
t=0;
tiempos(1)=0;
%% Trazas
trazas=cell(1,N);
%Parámetros de ciclo de vida de trazas 
paramTrazas.numExtrapConf=3;  %Nº máximo de extrapolaciones permitidas en Trazas Firmes
paramTrazas.numExtrapTent=2; %Nº máximo de extrapolaciones permitidas en Trazas Tentativas
paramTrazas.iniCalidad=3; %Nº máximo de extrapolaciones permitidas en Trazas Tentativas
paramTrazas.maxCal=15;  %Valor de calidad máxima
paramTrazas.promoEstablecida=5; %Valor de calidad para generar Traza Firme
paramTrazas.umbralDrop=3; %Valor de calidad mínima (umbral de drop
paramTrazas.actCalcorr=1; %Actualización de la calidad de Trazas
paramTrazas.actCalext=1; %Actualización de la calidad de Trazas
%Asignación inicial de trazas
for i=1:N
    trazas{i}.r=radar{i}.detsph(1);
    trazas{i}.phi=radar{i}.detsph(2);
    trazas{i}.theta=radar{i}.detsph(3);
    trazas{i}.x=radar{i}.detcart(1);
    trazas{i}.y=radar{i}.detcart(2);
    trazas{i}.z=radar{i}.detcart(3);
    trazas{i}.calidad=paramTrazas.iniCalidad;
    trazas{i}.estado=1;
    trazas{i}.extrapol=0;
    trazas{i}.nueva=0;
    trazas{i}.corr=0;
    trazas{i}.cont=0;
    trazas{i}.id=i;
end
%Parámetros de control de trazas 
trazasActivas=1:N;
totalTrazas=N;
trazasFiltradas=[];
%% Kalman
%% Inicialización posiciones Kalman 
for i=1:N
     kalman{i}.X=asignacionInicialX(radar{i}.detcart,modF);
    kalman{i}.historialX=[];
    kalman{i}.historialVel=[];
    kalman{i}.historialAcc=[];
    kalman=asignacionHistorialX(kalman,modF,i);
    kalman{i}.historialVel=[0 0 0];
    kalman{i}.historialAcc=[0 0 0];
    kalman{i}.historialXsph=cart2esf(kalman{i}.historialX);
    kalman{i}.R=actualizarR(paramRadar,kalman{i}.historialXsph);
    kalman{i}.id=i;
    kalman{i}.relacionBlanco=true;
    kalman{i}.inicioTraza=1;
    kalman{i}.distMah=0;
end 
%% Asignación Parámetros Kalman según modelo cinemático 
switch modF
    case 1
        deltaK=param.periodoT; 
        historialDelta(1)=deltaK;
        [F, GQGt]=paramKalman(modF, deltaK,q);
        H=[1 0 0 0 0 0; 0 0 1 0 0 0; 0 0 0 0 1 0]; 
        escala=1.5;  
        for i=1:N
            inicialP=ones(1,6)*inicialEscalaP;
            P_ini=diag(inicialP);
            P_ini(1,1)=escala*kalman{i}.R(1,1); 
            P_ini(3,3)=escala*kalman{i}.R(2,2); 
            P_ini(5,5)=escala*kalman{i}.R(3,3);
            kalman{i}.P=P_ini;
        end 
    case 2
        deltaK=param.periodoT; 
        historialDelta(1)=deltaK;
        [F, GQGt]=paramKalman(modF, deltaK,q);
        H=[1 0 0 0 0 0 0 0 0; 0 0 0 1 0 0 0 0 0; 0 0 0 0 0 0 1 0 0];
         escala=1.5;  
        for i=1:N
            inicialP=ones(1,9)*inicialEscalaP;
            P_ini=diag(inicialP);
            P_ini(1,1)=escala*kalman{i}.R(1,1); 
            P_ini(4,4)=escala*kalman{i}.R(2,2); 
            P_ini(7,7)=escala*kalman{i}.R(3,3);
            kalman{i}.P=P_ini;
        end 
    otherwise 
        disp('Introduzca un modelo cinemático válido') 
end 

%% Generación de figuras 
%figure('Position' ,[0 0 param.monitor(3) param.monitor(4)])
figure
%% Simulación del movimiento 
%% Inicio del bucle de simulación
for i=2:param.res
    %% Gestión de tiempos
    t=tiempos(i-1) +param.periodoT;
    tiempos(i)=t;
    deltaK=tiempos(i)- tiempos(i-1);
%% Simulación de movimiento de blanco 
    [pos_sph,blanco]=movimiento(blanco,pos_sph,deltaK,t,N,paramBlanco,param);
    for j=1:N
        pos_cart(j,:)=esf2cart(pos_sph(j,:));
        %Guardamos el historial
        blanco{j}.movsph(i,:)=pos_sph(j,:);
        blanco{j}.movcart(i,:)=pos_cart(j,:);
    end

%% Simulación de Radar y probabilidad de No Detección
    if i<15 || paramRadar.pd-rand>0
        for j=1:N
            radar{j}.detsph(i,1)=pos_sph(j,1) + randn*paramRadar.sigmar;
            radar{j}.detsph(i,2)=pos_sph(j,2) + randn*paramRadar.sigmaphi;
            radar{j}.detsph(i,3)=pos_sph(j,3) + randn*paramRadar.sigmatheta;
            radar{j}.detcart(i,:)=esf2cart(radar{j}.detsph(i,:));
        end
        paramRadar.det=true;
        paramTrazas.haExtrapolado=0;
    else %Extrapolación al no haberse producido detección
        paramRadar.contnodet=paramRadar.contnodet+1;
        paramRadar.posNoDet(end+1)=i;
        paramTrazas.haExtrapolado=1;
        for j=trazasActivas
            %Extrapolación
            X_extrapol=F*kalman{j}.X;
            kalman{j}.X=X_extrapol;
            [kalman]=asignacionHistorialX(kalman,modF,j);
            kalman{j}.historialXsph(end+1,:)=cart2esf(kalman{j}.historialX(end,:));
            kalman{j}.relacionBlanco(i)=true(1);
            trazas{j}.detcart(i,:)=kalman{j}.historialX(end,:);
            trazas{j}.detsph(i,:)=cart2esf(kalman{j}.historialX(end,:));
            kalman{j}.distMah(end+1)=kalman{j}.distMah(end);

            radar{kalman{j}.id}.detcart(i,:)=trazas{j}.detcart(i,:);
            radar{kalman{j}.id}.detsph(i,:)=trazas{j}.detsph(i,:);
            trazas{j}.corr=0;
        end
        [trazas,trazasActivas,kalman]=gestionaTrazas(trazas, paramTrazas, trazasActivas,kalman);
        continue;
    end
%% Asignación de plots
for k=1:N
    plotDet.r(k)=radar{k}.detsph(i,1);
    plotDet.phi(k)=radar{k}.detsph(i,2);
    plotDet.theta(k)=radar{k}.detsph(i,3);
    plotDet.x(k)=radar{k}.detcart(i,1);
    plotDet.y(k)=radar{k}.detcart(i,2);
    plotDet.z(k)=radar{k}.detcart(i,3);
    plotDet.id(k)=i;
end

%% Correlación de plots mediante distancia de Mahalanobis
for k=trazasActivas 
    kalman{k}.R=actualizarR(paramRadar,kalman{k}.historialXsph(end,:));
    kalman{k}.Sprox=H * kalman{k}.P * H' + kalman{k}.R; 
    kalman{k}.Xpredict=F*kalman{k}.X;
    trazas{k}.extrapol=0;
end 
[trazas,info,kalman,trazasActivas,totalTrazas]= mahalanobis(plotDet, trazas, kalman,P_ini,paramRadar,trazasActivas,totalTrazas,i,modF,info,umbral,inicialEscalaP);
%% Gestión de trazas 
[trazas,trazasActivas,kalman]=gestionaTrazas(trazas,paramTrazas,trazasActivas,kalman);
%% Filtrado de Kalman

for j=trazasActivas
    Z=[trazas{j}.x(end); trazas{j}.y(end); trazas{j}.z(end);]; %Vector observación
    X=kalman{j}.X; %Vector estado 
    P=kalman{j}.P;
    R=kalman{j}.R;
    [X,P] = kalman_fun(F,GQGt,P,H,R,Z,X);
    kalman{j}.X=X;
    kalman=asignacionHistorialX(kalman,modF,j);
    kalman{j}.historialXsph(end+1,:)=cart2esf(kalman{j}.historialX(end,:));
    kalman{j}.P=P;

    %% Actualización trazas con información estado 
    trazas=asignaTrazas(X,modF,trazas,j);
    kalman{j}.relacionBlanco(i)=true(1); 
end
%% Visualización de figuras DURANTE simulación
if figurasSimultaneas
    %% Figura 1: Simulación de blanco
    f1=figure(1);
    hold on
    plot3(pos_cart(:,1),pos_cart(:,2),pos_cart(:,3),'ok')
    plot3(0,0,0,'.k','MarkerSize', 8)
    hold off
    title('Trayectoria en cartesianas del blanco')
    grid on
    xlabel('x')
    ylabel('y')
    zlabel('z')
    ax=1;
    %% Figura 2: Simulación de radar
    figure(2)
    plot3(0,0,0,'.k','MarkerSize', 15)
    hold on
    for i=1:N
        plot3(blanco{i}.movcart(:,1),blanco{i}.movcart(:,2),blanco{i}.movcart(:,3),'ok')
        plot3(radar{i}.detcart(:,1),radar{i}.detcart(:,2),radar{i}.detcart(:,3),'ob')
        texto="Blanco nº " +i;
        text(blanco{i}.movcart(1,1),blanco{i}.movcart(1,2),blanco{i}.movcart(1,3), texto);
        grid on
    end
    hold off
    title('Blanco y error simulado de radar en cartesianas')
    legend('Trayectoria exacta blanco', 'Trayectoria simulada','Location','SouthEast')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    %% Figura 3: Trazas Kalman
    for j=trazasActivas
        f3=figure(3);
        %f3.Position=[param.monitor(3)/2 0 param.monitor(3)/2 param.monitor(4)];
        subplot(length(trazasActivas),1, ax)
        plot3(kalman{j}.historialX(:,1), kalman{j}.historialX(:,2), kalman{j}.historialX(:,3),'or');
        hold on
        plot3(blanco{kalman{j}.id}.movcart(:,1), blanco{kalman{j}.id}.movcart(:,2),blanco{kalman{j}.id}.movcart(:,3),'ok')
        plot3(radar{kalman{j}.id}.detcart(:,1), radar{kalman{j}.id}.detcart(:,2),radar{kalman{j}.id}.detcart(:,3),'ob')
        plot3(0,0,0,'.k','MarkerSize', 8)
        legend('Kalman', 'Blanco', 'Radar')
        hold off
        grid on
        title("Seguimiento del Kalman del blanco " +kalman{j}.id);
        xlabel('x')
        ylabel('y')
        zlabel('z')
        ax=ax+1;
    end
end 
%% Información para usuario
clc
disp("Vuelta número " + i)
disp(i/param.res*100 + "%")
end 
%% Visualización figuras NO simultáneas 
if ~figurasSimultaneas
    figurasTrasSimulacion(blanco,radar,trazasActivas,kalman, N); 
end 
% % Ajuste 
% for i=1:N
%     kalman{i}.historialXsph(:,2)=abs(kalman{i}.historialXsph(:,2));
%     radar{i}.detsph(:,2)=abs(radar{i}.detsph(:,2));
% end 
%% Funciones error respecto a radar 
for i=1:N
%Desviaciones típicas en esféricas
errorRadar{i}.sph=abs(blanco{i}.movsph-radar{i}.detsph);
errorRadar{i}.var_sph=mean((errorRadar{i}.sph).^2);
errorRadar{i}.desv_sph=sqrt(errorRadar{i}.var_sph);

%Desviaciones típicas en cartesianas
errorRadar{i}.cart=abs(blanco{i}.movcart-radar{i}.detcart);
errorRadar{i}.var_cart=mean((errorRadar{i}.cart).^2);
errorRadar{i}.desv_cart=sqrt(errorRadar{i}.var_cart);
figure(3+i)
for k=1:3
    subplot(2,3,k)
    plot(1:param.res, errorRadar{i}.cart(:,k), 'linewidth',1.5)
    switch k
        case 1
            title('Error radar en coordenada x','interpreter','latex')
        case 2
            title('Error radar en coordenada y','interpreter','latex')
        case 3
            title ('Error radar en coordenada z','interpreter','latex')
    end
end 
for k=1:3
    subplot(2,3,3+k)
    plot(1:param.res, errorRadar{i}.sph(:,k),'linewidth',widthSmall)
    switch k
        case 1
            title('Error radar en coordenada r','interpreter','latex')
        case 2
            title('Error radar en coordenada \phi','interpreter','latex')
        case 3
            title ('Error radar en coordenada \theta','interpreter','latex')
    end
end

end 
%% Funciones Convergencia Kalman 
refBlanco=1:param.res; 
for i=1:N
    figure(3+N+i)
    existeTraza=false;
    for j=trazasActivas
        if kalman{j}.id==i
            existeTraza=true;
            idKalman=j;
            refKalman=kalman{j}.inicioTraza:(kalman{j}.inicioTraza +length(kalman{j}.historialX(:,1))-1);
        end 
    end
    aux=1;
    for k=1:3
        subplot(3,2,aux)
        hold on
        plot(refBlanco,blanco{i}.movcart(:,k), 'k','linewidth',widthSmall)
        plot(refBlanco,radar{i}.detcart(:,k), 'b','linewidth',widthSmall)
        if existeTraza
            plot(refKalman,kalman{idKalman}.historialX(:,k), 'r', 'linewidth',widthSmall)
            legend('Blanco','Radar','Kalman','interpreter','latex')
        else 
            legend('Blanco', 'Radar','interpreter','latex')
        end 
        hold off
        
        switch k 
            case 1
                title('Coordenada x','interpreter','latex')
            case 2
                title('Coordenada y','interpreter','latex')
            case 3
                title ('Coordenada z','interpreter','latex')
        end 
        grid on
        xlabel('t','interpreter','latex')
        aux=aux+2;
    end
    aux=2;
    for k=1:3
        subplot(3,2,aux)
         hold on
        plot(refBlanco,blanco{i}.movsph(:,k), 'k','linewidth',widthSmall)
        plot(refBlanco,radar{i}.detsph(:,k), 'b','linewidth',widthSmall)
        if existeTraza
            plot(refKalman,kalman{idKalman}.historialXsph(:,k), 'r', 'linewidth',widthSmall)
            legend('Blanco','Radar','Kalman','interpreter','latex')
        else 
            legend('Blanco', 'Radar','interpreter','latex')
        end 
        hold off
        
        switch k 
            case 1
                title('Coordenada r','interpreter','latex')
            case 2
                title('Coordenada phi','interpreter','latex')
            case 3
                title ('Coordenada theta','interpreter','latex')
        end 
        grid on
        xlabel('t')
        aux=aux+2;
    end
end

%% Funciones error respecto Kalman 
refBlanco=1:param.res; 
for i=1:N
    figure(3+2*N+i)
    existeTraza=false;
    for j=trazasActivas
        if kalman{j}.id==i
            existeTraza=true;
            idKalman=j;
            refKalman=kalman{j}.inicioTraza:(kalman{j}.inicioTraza +length(kalman{j}.historialX(:,1))-1);
            errorKalman{i}.inicioTraza=kalman{j}.inicioTraza;
        end 
    end
    errorKalman{i}.cart=abs(blanco{i}.movcart(refKalman,:)-kalman{idKalman}.historialX);
    errorKalman{i}.sph=abs(blanco{i}.movsph(refKalman,:)-kalman{idKalman}.historialXsph);
    errorKalman{i}.var_cart=mean((errorKalman{i}.cart).^2);
    errorKalman{i}.desv_cart=sqrt(errorKalman{i}.var_cart);
    errorKalman{i}.var_sph=mean(errorKalman{i}.sph.^2);
    errorKalman{i}.desv_sph=sqrt(errorKalman{i}.var_sph);
    errorKalman{i}.mejora_cart=(errorRadar{i}.desv_cart-errorKalman{i}.desv_cart)./errorRadar{i}.desv_cart*100;
    errorKalman{i}.mejora_sph=(errorRadar{i}.desv_sph-errorKalman{i}.desv_sph)./errorRadar{i}.desv_sph*100;
    errorKalman{i}.precisionVel=abs(blanco{i}.vectorVel-kalman{idKalman}.historialVel);
    errorKalman{i}.precisionAcc=abs(blanco{i}.vectorAcc-kalman{idKalman}.historialAcc);
%     errorKalman{i}.precisionVelFinal=(1-abs(errorKalman{i}.precisionVel(end,:)./blanco{i}.vectorVel))*100;
%     errorKalman{i}.precisionAccFinal=(1-abs(errorKalman{i}.precisionAcc(end,:)./blanco{i}.vectorAcc))*100;
    errorKalman{i}.precisionVelFinal=(1-abs((blanco{i}.vectorVel-mean(kalman{idKalman}.historialVel))./blanco{i}.vectorVel))*100;
    errorKalman{i}.precisionAccFinal=(1-abs((blanco{i}.vectorAcc-mean(kalman{idKalman}.historialAcc))./blanco{i}.vectorAcc))*100;
    for k=1:3
        subplot(2,3,k)
        plot(refKalman,errorKalman{i}.cart(:,k), 'r','linewidth',widthSmall)
        switch k 
            case 1
                title('Error Kalman coordenada x','interpreter','latex')
            case 2
                title('Error Kalman coordenada y','interpreter','latex')
            case 3
                title ('Error Kalman coordenada z','interpreter','latex')
        end 
        grid on
        xlabel('t')
    end
    for k=1:3
        subplot(2,3,3+k)
        plot(refKalman,errorKalman{i}.sph(:,k), 'r','linewidth',widthSmall)
        switch k 
            case 1
                title('Error Kalman coordenada r','interpreter','latex')
            case 2
                title('Error Kalman coordenada phi','interpreter','latex')
            case 3
                title ('Error Kalman coordenada theta','interpreter','latex')
        end 
        grid on
        xlabel('t')
    end
end

%% Distancias de Mahalanobis de traza
ax=1;
for i=trazasActivas
    figure(3+4*N+2)
    subplot(N,1,ax) 
    refKalman=kalman{i}.inicioTraza:(kalman{i}.inicioTraza +length(kalman{i}.historialX(:,1))-1);
    plot(1:length(kalman{i}.distMah), kalman{i}.distMah, 'linewidth',widthBig)
    grid 
    title('Distancia de Mahalanobis','interpreter','latex')
    xlabel('t','interpreter','latex') 
    ylabel('Dist. Mah.','interpreter','latex')
    grid on 
    ax=ax+1;
end 

%% Log 
if guardarResultado    
     modosArchivo="N"+string(N)+"M";
    for i=1:N
        modosArchivo=modosArchivo+string(blanco{i}.modo);
    end
    nombreArchivo=modosArchivo + "F" +modF;
    mkdir("./Resultados/" + nombreArchivo)
    string="./Resultados/"+nombreArchivo+"/" + "log.txt"; 
    diary(string)
end 
%% Tiempos de convergencia 
tiempoConv=tiempoConvergencia(errorRadar, errorKalman,param,N);
ax=1;
for i=1:N
disp("El algoritmo ha convergido en el blanco  "+ i+ " en " + tiempoConv(i) + " s")
end
%% Tiempos
tiempoTotal=tiempos(param.res); 
tiempoMedio=tiempoTotal/param.res; 
disp("La simulación ha tardado en total " + tiempoTotal+ " s, con un tiempo medio de " +tiempoMedio+" s/vuelta")
%% Resultados de error 
disp("ERRORES RADAR")
for i=1:N
    disp("Las desviaciones típicas del blanco "+ i + " en cartesianas son " + errorRadar{i}.desv_cart(1) + " (x) " + errorRadar{i}.desv_cart(2) + " (y) " + errorRadar{i}.desv_cart(3) + " (z) ")
    disp("Las desviaciones típicas del blanco "+ i +" en esféricas son " + errorRadar{i}.desv_sph(1) + " (r) " + errorRadar{i}.desv_sph(2) + " (\phi) " + errorRadar{i}.desv_sph(3) + " (\theta) ")
end
disp("")
disp("ERRORES KALMAN")
for i=1:N
    disp("Las desviaciones típicas del blanco "+ i + " en cartesianas son " + errorKalman{i}.desv_cart(1) + " (x) " + errorKalman{i}.desv_cart(2) + " (y) " + errorKalman{i}.desv_cart(3) + " (z) ")
    disp("Las desviaciones típicas del blanco "+ i + " en esféricas son " + errorKalman{i}.desv_sph(1) + " (r) " + errorKalman{i}.desv_sph(2) + " (\phi) " + errorKalman{i}.desv_sph(3) + " (\theta) ")
end
disp("")
disp("MEJORA KALMAN")
for i=1:N 
    disp("La mejora por uso de Kalman del blanco "+ i + " es de " + errorKalman{i}.mejora_cart(1) + " % (x) " + errorKalman{i}.mejora_cart(2) + " % (y) " + errorKalman{i}.mejora_cart(3) + " % (z) ")
    disp("La mejora por uso de Kalman del blanco "+ i + " es de " + errorKalman{i}.mejora_sph(1) + " % (r) " + errorKalman{i}.mejora_sph(2) + " % (\phi) " + errorKalman{i}.mejora_sph(3) + " % (\theta) ")
end 
for i=1:N
    switch blanco{i}.modo
        case {2,5,6}
            disp("PRECISIÓN DE VELOCIDAD DE BLANCO " + i)
            disp("La precisión de velocidad de Kalman del blanco "+ i + " es de " + errorKalman{i}.precisionVelFinal(1) + " % (x) " + errorKalman{i}.precisionVelFinal(2) + " % (y) " + errorKalman{i}.precisionVelFinal(3) + " % (z) ")
       
        case {8,9,10,13}
            disp("PRECISIÓN DE VELOCIDAD DE BLANCO " + i)
            
            disp("La precisión de aceleración de Kalman del blanco "+ i + " es de " +errorKalman{i}.precisionAccFinal(1) + " % (x) " + errorKalman{i}.precisionAccFinal(2) + " % (y) " + errorKalman{i}.precisionAccFinal(3) + " % (z) ")
            
    end
end
%% Función para guardar resultados
if guardarResultado
    diary off
    save("./Resultados/"+ nombreArchivo + "/" + nombreArchivo);
end

