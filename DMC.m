function [u, y] = DMC(s, D, N, Nu, lambda, yzad, sim_time, u_prev)

% s - Dx4
% yzad - 1x2
% u_prev - 2x1
% y_prev = 1x2

%alokacja wektorów
y = zeros(sim_time, 2);
u = zeros(sim_time, 2);
Umin = [0;0];
Umax = [100; 100];

%Obiekt DMC
dmc = DMCRegMIMO(s, D, N, Nu, lambda, Umin, Umax);
dmc.reset(u_prev);
dmc.setValue(yzad);

figure;
%Symulacja
for i=1:sim_time
    measurements = readMeasurements([1,3]);
    y(i, :) = measurements;
    m = dmc.countValue(y(i, :));
    u(i, :) = m;
    sendControls([5,6], u(i, :)); 
    
    subplot(2,1,1);
    plot([(0:(i-1))', (0:(i-1))'], y(1:i,:));
    subplot(2,1,2);
    stairs([(0:(i-1))', (0:(i-1))'], u(1:i,:));
    ylim([-5,105]);
    drawnow;
    waitForNewIteration();
end
end

