function [trazas]=asignaTrazas(X,modF,trazas,j)
switch modF
    case 1
        trazas{j}.x(end)=X(1);
        trazas{j}.y(end)=X(3);
        trazas{j}.z(end)=X(5);
    case 2
        trazas{j}.x(end)=X(1);
        trazas{j}.y(end)=X(4);
        trazas{j}.z(end)=X(7);
end
end