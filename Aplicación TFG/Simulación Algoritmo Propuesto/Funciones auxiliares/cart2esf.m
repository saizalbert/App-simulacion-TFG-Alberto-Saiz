function [pos_sph]=cart2esf(pos)
[azimuth, elevation,r]=cart2sph(pos(1),pos(2),pos(3));
pos_sph(1)=r;
pos_sph(2)=azimuth;
pos_sph(3)=pi/2-elevation;
end