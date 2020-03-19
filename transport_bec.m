function transport_bec(times,psies)
%so here we are just taking the 
h = figure();
axis tight manual
filename = 'bec_plot.gif';
%The range over which we plot (xi is the scaled position space)
xi = linspace(-4,4,40);
%the range for the transverse direction
y_xi = linspace(-2,2,20);
numstates = length(psies(1,:)); %just the length of psi vector shows how large
%of a basis you are considering
ground_psi = zeros(numstates,1);
ground_psi(1) = 1;
y_prob = general_prob(ground_psi,y_xi);


for ii = 1:length(times)
    tic
    disp(length(times)-ii);
    psi = psies(ii,:);
    toc
    [X,Y] = meshgrid(xi,y_xi);%this 
    x_prob = general_prob(psi,xi);
    prob = (y_prob')*(x_prob);
    toc
    surf(X,Y,prob,'edgecolor','interp','facecolor','interp');
    xlabel('X Pos $\left[\left(\frac{\hbar}{m\omega_{x}}\right)^{1/2} \right]$'...
        ,'interpreter','latex','fontsize',16);
    ylabel('Y Pos $\left[\left(\frac{\hbar}{m\omega_{y}}\right)^{1/2} \right]$'...
        ,'interpreter','latex','fontsize',16);
    zlabel('Prob. Distr. $\left|\Psi\right|^{2}$','interpreter'...
        ,'latex','fontsize',16);
%     align_axislabel([],gca);
    toc
    zlim([0,0.4]);
    drawnow
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if ii == 1
        imwrite(imind,cm,filename,'gif','Loopcount',inf,'DelayTime',0.03);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.03);
    end
    toc
end

function eig_psi = eig_psi(n,x)%note!!! Here ground state is n = 1!!!
    eig_psi = (pi).^(-1/4).*(2.^(n-1).*factorial(n-1)).^(-1/2).*hermiteH(n-1,x).*exp(-x.^2/2);
end


function prob = general_prob(big_psi,x)
    psi_f = 0;
    for kk = 1:numstates
        psi_f = psi_f + big_psi(kk).*(eig_psi(kk,x));
    end
    prob = conj(psi_f).*psi_f;
end
end