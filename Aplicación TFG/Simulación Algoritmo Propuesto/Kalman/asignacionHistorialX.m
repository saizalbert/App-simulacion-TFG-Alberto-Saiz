function kalman=asignacionHistorialX(kalman,modF,j)
X=kalman{j}.X;
switch modF
    case 1
        kalman{j}.historialX(end+1,:)=[X(1) X(3) X(5)];
        kalman{j}.historialVel(end+1,:)=[X(2) X(4) X(6)];
        kalman{j}.historialAcc(end+1,:)=[0 0 0];
    case 2
        kalman{j}.historialX(end+1,:)=[X(1) X(4) X(7)];
        kalman{j}.historialVel(end+1,:)=[X(2) X(5) X(8)];
        kalman{j}.historialAcc(end+1,:)=[X(3) X(6) X(9)];
end
end