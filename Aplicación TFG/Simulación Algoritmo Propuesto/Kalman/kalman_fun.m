function [X,P] = kalman_fun(F,GQGt,P,H,R,Z,X)    
% X: Vector de estado 
% P: Matriz de covarianza 

% F: kinematic motion constrained between t(k) and t(k+1) //Modelo
% H: Matriz de observación // Matriz cambio coordenadas
% R: Covarianza del estimado del vector de estado. //desviaciones tipicas
% esperadas
% Z: Vector de observación //Matriz estado 
% ¿w?: sensor error (normal scalar variable with variance sigmaw^2)
% GQG: Error del sistema al objetivo estimado. //Buscar en libro  
% El primer valor no nulo de X será K·Z
%% prediction
    X = F * X;
    P = F * P * F' + GQGt;
%% update
   %¿? Z = H * X + w;
    S = H * P * H' + R;
    K = P * H' * inv(S);
    X = X + K * (Z - H * X);
    %P = (eye(length(H(:,1))) - K * H) * P;
    P=P-K*H*P;
    %R 6x6 
    