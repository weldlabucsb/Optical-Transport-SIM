function test_yeet(duration,distance)
%use this function for making a plot of the accel velocity and position
%versus time for the fancy acceleration curve.
accel = @(t) (t<(duration/4)).*(distance/duration.^2).*(-(7040/9).*(t/duration).^3+320.*(t/duration).^2)+...
    ((duration/4)<t).*(t<(3.*duration/4)).*(distance/duration.^2).*((3200/9).*(t/duration).^3-(1600/3).*(t/duration).^2+(640/3).*(t/duration)-160/9)+...
    (t>(3.*duration/4)).*(distance/duration.^2).*(-(7040/9).*(t/duration).^3+(6080/3).*(t/duration).^2-(5120/3).*(t/duration)+(4160/9));
ts = linspace(0,duration,500);
accels = arrayfun(accel,ts);
plot(ts,accels);
ylabel('Acceleration, m/s^2')
xlabel('Time, sec')
velocity = @(t) integral(accel,0,t);
position = @(t) integral(velocity,0,t,'ArrayValued',true);
v = arrayfun(velocity,ts);
% x = arrayfun(position,ts);
% subplot(1,3,2);
% plot(ts,v);
% ylabel('Velocity, m/s')
% xlabel('Time, sec')
% subplot(1,3,3);
% plot(ts,x);
% ylabel('Position, m')
% xlabel('Time, sec')
disp(max(accels)./9.8)
end