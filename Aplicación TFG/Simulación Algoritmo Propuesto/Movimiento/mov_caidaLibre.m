function [pos_recta]=mov_caidaLibre(pos_ini, deltaK)
    pos_inicart=esf2cart(pos_ini); 
    pos_cart(1)=pos_inicart(1);
    pos_cart(2)=pos_inicart(2);
    z=pos_inicart(3)-9.8/2*deltaK^2;
    if z>=0
        pos_cart(3)=z; 
    else 
        pos_cart(3)=0; 
    end 
    pos_recta=cart2esf(pos_cart); 
    
end 
