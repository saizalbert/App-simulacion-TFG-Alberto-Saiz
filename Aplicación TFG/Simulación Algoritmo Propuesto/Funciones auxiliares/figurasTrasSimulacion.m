function figurasTrasSimulacion(blanco,radar,trazasActivas, kalman, N)
    %% Figura 1: Simulación de blanco
    figure(1);
    hold on
    for i=1:N
        plot3(blanco{i}.movcart(:,1),blanco{i}.movcart(:,2),blanco{i}.movcart(:,3),'ok')
        texto="Blanco nº " +i;
        text(blanco{i}.movcart(1,1),blanco{i}.movcart(1,2),blanco{i}.movcart(1,3), texto,'interpreter','latex');
        grid on
        plot3(0,0,0,'.k','MarkerSize', 8)
    end
    hold off
    title('Trayectoria en cartesianas del blanco','interpreter','latex')
    grid on
    xlabel('x','interpreter','latex')
    ylabel('y','interpreter','latex')
    zlabel('z','interpreter','latex')
    ax=1;
    %% Figura 2: Simulación de radar
    figure(2)
    plot3(0,0,0,'.k','MarkerSize', 15)
    hold on
    for i=1:N
        plot3(blanco{i}.movcart(:,1),blanco{i}.movcart(:,2),blanco{i}.movcart(:,3),'ok')
        plot3(radar{i}.detcart(:,1),radar{i}.detcart(:,2),radar{i}.detcart(:,3),'ob')
        texto="Blanco nº " +i;
        text(blanco{i}.movcart(1,1),blanco{i}.movcart(1,2),blanco{i}.movcart(1,3), texto,'interpreter','latex');
        grid on
    end
    hold off
    title('Blanco y error simulado de radar en cartesianas','interpreter','latex')
    legend('Trayectoria exacta blanco', 'Trayectoria simulada','Location','SouthEast','interpreter','latex')
    xlabel('x','interpreter','latex')
    ylabel('y','interpreter','latex')
    zlabel('z','interpreter','latex')
    %% Figura 3: Trazas Kalman
    for j=trazasActivas
        figure(3);
        subplot(length(trazasActivas),1, ax)
        plot3(kalman{j}.historialX(:,1), kalman{j}.historialX(:,2), kalman{j}.historialX(:,3),'or');
        hold on
        plot3(blanco{kalman{j}.id}.movcart(:,1), blanco{kalman{j}.id}.movcart(:,2),blanco{kalman{j}.id}.movcart(:,3),'ok')
        plot3(radar{kalman{j}.id}.detcart(:,1), radar{kalman{j}.id}.detcart(:,2),radar{kalman{j}.id}.detcart(:,3),'ob')
        plot3(0,0,0,'.k','MarkerSize', 8)
        legend('Kalman', 'Blanco', 'Radar','interpreter','latex')
        hold off
        grid on
        title("Seguimiento del Kalman del blanco " +kalman{j}.id,'interpreter','latex');
        xlabel('x')
        ylabel('y')
        zlabel('z')
        ax=ax+1;
    end
end