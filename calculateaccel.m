function [max_a]= calculateaccel(duration)
%the purpose of this matlab script is to calculate numerically the required
%foci of the two tunable lenses in the telescope for a given beam waist and
%focus away from the final lens. Although I can find the focus and the
%waist in terms of the foci, I am not sure if it is possible to find an
%analytic expression going the other way. At least it is much more
%difficult. 
%this program is calculate the transport curve
%how long will transport take
transp_duration = duration; %seconds
%how far are we transporting the atoms
transp_distance = 150; %mm

starting_distance = 200; %mm
%using simple integration, find constant
%in kinematic equations to get above constants
c = 6*transp_distance./(transp_duration.^3);
%calculate velocity (parabolic)
velocity = @(t) c.*t.*(transp_duration-t);
%find position by integrating velocity
position = @(t) integral(velocity,0,t)+starting_distance;
%plot position v, and a
% subplot(2,2,2);
time = linspace(0,transp_duration,1000);
v = arrayfun(velocity,time);

x = arrayfun(position,time);
step = transp_duration/100;
a = diff(v)/step;
a = a/1000; %converting back into meters
a = a*600; %NOTE!!!: This is for the quantum simulation code. This is...
%scaled down by 900 because of the trap parameters. See presentation
max_a = a(1);
end