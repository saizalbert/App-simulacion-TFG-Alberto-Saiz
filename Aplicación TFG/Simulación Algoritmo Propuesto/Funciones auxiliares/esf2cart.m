function [pos_cart]=esf2cart(pos)
pos_cart=[pos(1)*sin(pos(3))*cos(pos(2)) pos(1)*sin(pos(3))*sin(pos(2)) pos(1)*cos(pos(3))];
end 