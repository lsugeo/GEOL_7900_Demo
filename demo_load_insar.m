clear

filename='S1-GUNW-D-R-087-tops-20181219_20181201-161542-00157W_00019N-PP-c008-v2_0_6.nc';

% ncdisp(filename); % list the components include in the file

A=ncread(filename,'/science/grids/data/amplitude');
y=ncread(filename,'/science/grids/data/latitude');
x=ncread(filename,'/science/grids/data/longitude');
phase=ncread(filename,'/science/grids/data/unwrappedPhase');
coh=ncread(filename,'/science/grids/data/coherence');
concomp=ncread(filename,'/science/grids/data/connectedComponents');
wavelength=ncread(filename,'/science/radarMetaData/wavelength');


figure(1),clf
subplot(2,2,1),imagesc(x,y,A),axis xy,colorbar,title('amplitude'),caxis([0,1e4]),
subplot(2,2,2),imagesc(x,y,phase),axis xy,colorbar,title('phase'),%caxis([0,1e4]),
subplot(2,2,3),imagesc(x,y,coh),axis xy,colorbar,title('coherence'),%caxis([0,1e4]),
subplot(2,2,4),imagesc(x,y,concomp),axis xy,colorbar,title('connectedComponents'),%caxis([0,1e4]),

% convert from phase to line of sight displacement
LOSdisp=phase*wavelength/4/pi;

i_incoherent=find(concomp==0);
LOSdisp(i_incoherent)=NaN;
i_incoherent=find(coh<0.3);
LOSdisp(i_incoherent)=NaN;

figure(2),clf
imagesc(x,y,LOSdisp),axis xy,colorbar,title('LOS displacement'),
Colorscale=jet;
Colorscale(1,:)=[1 1 1]*0.7;
% colormap(jet)
colormap(Colorscale)
caxis([-0.2,0.2])