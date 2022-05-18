function [pos_recta]=mov_rectaAcelerado(pos_ini,vectorVel,vectorAcc, t)
    pos_inicart=esf2cart(pos_ini); 
    pos_cart(1)=pos_inicart(1)+vectorVel(1)*t+ 1/2*vectorAcc(1)*t^2;
    pos_cart(2)=pos_inicart(2)+vectorVel(2)*t+ 1/2*vectorAcc(2)*t^2;
    pos_cart(3)=pos_inicart(3)+vectorVel(3)*t+ 1/2*vectorAcc(3)*t^2;
    pos_recta=cart2esf(pos_cart); 
    
end 