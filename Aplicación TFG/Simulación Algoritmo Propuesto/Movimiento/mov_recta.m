function [pos_recta]=mov_recta(pos,vectorVel, deltaK)
    pos_cart=esf2cart(pos); 
    pos_cart(1)=pos_cart(1)+vectorVel(1)*deltaK;
    pos_cart(2)=pos_cart(2)+vectorVel(2)*deltaK;
    pos_cart(3)=pos_cart(3)+vectorVel(3)*deltaK;
    pos_recta=cart2esf(pos_cart); 
    
end 