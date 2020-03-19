function histogram_gif(times,psies)
h = figure();
axis tight manual
filename = 'barchart.gif';

for ii = 1:length(times)
    tic
    disp(length(times)-ii);
    psi = psies(ii,:);
    psi_square = conj(psi).*psi;
    bar(psi_square);
     xlabel('$N^{th}$ Basis State'...
        ,'interpreter','latex','fontsize',16);
    ylabel('$N^{th}$ Basis Cmpt. $| \langle \Psi_{n}|\Psi \rangle|^{2}$'...
        ,'interpreter','latex','fontsize',16);
    ylim([0,1]);
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


end