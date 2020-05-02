function [y, u]= MakeJump(G1, G2)

global k;
y = zeros(k,2);
u = zeros(k,2);
figure;
for i = 1:k
    measurements = readMeasurements([1,3]); % read measurements 1 and 3
    controls = [G1, G2];
    sendControls([5,6], controls);  % new corresponding control values
    y(i,:) = measurements;
    u(i,:) = controls;
    subplot(2,1,1);
    plot([(0:(i-1))', (0:(i-1))'], y(1:i,:));
    subplot(2,1,2);
    stairs([(0:(i-1))', (0:(i-1))'], u(1:i,:));
    ylim([-5,105]);
    drawnow;
    waitForNewIteration(); % wait for new batch of measurements to be ready
end
subplot(2,1,1);
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$T[\circ C]$", 'interpreter', 'latex');
legend("$T_1$", "$T_3$", 'interpreter', 'latex', 'location', 'southeast');
subplot(2,1,2);
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$\%$", 'interpreter', 'latex');
legend("$G_1$", "$G_2$", 'interpreter', 'latex');
end