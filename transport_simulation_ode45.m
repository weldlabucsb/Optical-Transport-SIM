function [times,psies] = transport_simulation_ode45(max_a,duration,omega,numstates)
%transport_simulations
%authors:Max Prichard
%purpose:to simulate the excitation of a quanutm particle in a harmonic 
%oscillator during ultracold atom transport
%this is quite a simple simulation, but is done to try and qualitatively
%compare the extiations to a quantum particle in the ground state of the
%harmonic oscillator so as to determine an optimal transport curve shape
%and perhaps duration. 
%hypothesis: longer transport durations will certainly help with
%excitations of lower-lying states, however in the actual experiments will
%have tradeoffs with the number of atoms lost during the transport process.
%transport shape is something that it more relevant for this simulation,
%and I think that the shape of the acceleration curve will be what matters
%most. The smoother that this curve can be the better.

%to best be able to compare the exitation, we want to find a metric that
%analyzes the occupation of the higher states. We coud do something like
%the inverse participation ratio? Or just treat it like stats and thermal
%physics and take a look at the partition function z (like the expectation
%value of the energy) This is a simple and intiuitive way of analyzing the
%situation

%typical values(?):
% numstates = 50;
% timesteps = 10000;
% max_a = 1;
% duration = 0.5;
% omega = 10;

%different acceleration profiles
% max_a; %units of sqrt(h*w^3/m) (?)
% duration; % s (?)

% linear_ramp
accel_linear = @(t) max_a - 2.*max_a.*t./duration; %linear ramp from max_a to -max_a in duration time

% %smooth_ramp
% accel_smooth = @(t) (t<(duration/4)).*(distance/duration.^2).*(-(7040/9).*(t/duration).^3+320.*(t/duration).^2)+...
%     ((duration/4)<t).*(t<(3.*duration/4)).*(distance/duration.^2).*((3200/9).*(t/duration).^3-(1600/3).*(t/duration).^2+(640/3).*(t/duration)-160/9)+...
%     (t>(3.*duration/4)).*(distance/duration.^2).*(-(7040/9).*(t/duration).^3+(6080/3).*(t/duration).^2-(5120/3).*(t/duration)+(4160/9));
%   

%note that this is the acceleration in an inertial frame. Namely the trap
%is accelerating in the positive direction, but in the frame of the trap
%the experienced force in the negative x direction
%also note that this a parameter (as should hopefully most things in this
%program) is unitless! It is literally just a number, meant to be in terms
%of other relevant parameters in the system

%first of all we have to create the time-dependent hamiltonian. We can
%construct the unperturbed hamiltonian by just using the basis states.
%Think H*psi = E*psi
%the number of basis sates of use (remeber that these are the hermite
%polynomials, plus some extra stuff)
% numstates;
%in units of frequency 
H_0 = zeros(numstates);
%unperturbed oscillator frequency 
% omega; %hz
for ii = 1:numstates
    for jj = 1:numstates
        if ii==jj
            H_0(ii,jj) = ii-(1./2);
        end
    end
end
%perturbing hamiltonian (just without dimensionfull parameters)
X = zeros(numstates);
for ii = 1:numstates
    for jj = 1:numstates
        if (ii == jj + 1)
            X(ii,jj) = sqrt(jj./2);
        end
        if (ii == jj - 1)
            X(ii,jj) = sqrt(ii./2);
        end
    end
end

%and now we have H/(hbar)

% linear_ramp:
H_t =@(t) omega.*(H_0 + accel_linear(t).*(X));

% smooth_ramp:



%yeah we did it! The hamiltonian in #natty(ish)units
%note here that w is not unitless, but a and the operators are

%now what we have is the time dependent hamiltonian, and we have to
%integrate the time dependent schrodinger equation to find psi at the end
%of the transport
%psi at time t = 0; as you can see it is the ground state of the harmonic
%oscillator
psi = zeros(numstates,1);
psi(1) = 1;

%how many images to have in the gif:
gifstates = 100;
tspan = linspace(0,duration,gifstates);

dpsidt = @(t,psi) -1i.*H_t(t)*psi;
[times,psies] = ode45(dpsidt,tspan,psi);
transport_bec(times,psies);
% histogram_gif(times,psies);

% disp(transpose(psies(end,:)))
% disp(conj(psies(end,:)).*psies(end,:))
% disp(norm(psies(end,:)))
% disp(norm(psi))
% eigenenergies = 1:2:(1+2*(numstates-1));
% disp(eigenenergies*((conj(psies(end,:)).*psies(end,:))'))

end_duration = 1;
end_timesteps = 100;
% post_accel_gif(psi,end_duration,omega,numstates,end_timesteps);
end

