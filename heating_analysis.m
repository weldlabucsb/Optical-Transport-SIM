%this method is calculate the heating of the cloud as a function of the
%time that is spent on transport. Basically after changing the amount of
%time over the transport, which will increase the max acceleration and the
%jerk, then I take a look at the expectation value of the hamiltonian. Then
%plot this versus the transport duration. most of the heavy lifting is done
%by the transport_simulation_ode45...

numsteps = 150;
numstates = 150;
omega = 12;
eigenenergies = 1:2:(1+2*(numstates-1));
durations = linspace(0.1,10,numsteps); %seconds
% max_as = arrayfun(@(x) calculateaccel(x),durations);
av_energies = zeros(1,numsteps);
for ii = 1:numsteps
    disp(ii)
%     [times,psies] = transport_simulation_ode45(max_as(ii),durations(ii),omega,numstates);
    [times,psies] = smooth_transport_simulation_ode45(0.15,durations(ii),omega,numstates);
    final_psi = psies(end,:);
    psi_square = conj(final_psi).*final_psi;
    avg_energy = eigenenergies*(psi_square');
    av_energies(ii) = avg_energy;
end
figure(1);
plot(durations,av_energies);
xlabel('Transport Duration [t]=seconds'...
    ,'interpreter','latex','fontsize',18);
ylabel('Avg. Energy, $\langle H \rangle, (\frac{\hbar \omega}{2})$'...
    ,'interpreter','latex','fontsize',18);
title('Average Energy vs. Transport Duration','interpreter','latex',...
    'fontsize',20);