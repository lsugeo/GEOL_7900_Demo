clear

filename='ridgecrest_after.tif';

[array,metadata]=geotiffread(filename);
x=metadata.XWorldLimits;
y=metadata.YWorldLimits;
z=flipud(array);
z(find(z==-9999))=NaN;

figure(1),clf
imagesc(x/1e3,y/1e3,z)
axis xy
colorbar

dz_x=diff(z);
dz_y=diff(z,1,2);
dz_2=-sqrt(dz_x(:,2:end).^2+dz_y(2:end,:).^2);

figure(2),clf
imagesc(x/1e3,y/1e3,dz_x)
axis xy
axis equal
colorbar
caxis([-1,1])
colormap(gray)

figure(3),clf
imagesc(x/1e3,y/1e3,dz_y)
axis xy
axis equal
colorbar
caxis([-1,1])
colormap(gray)

figure(4),clf
imagesc(x/1e3,y/1e3,dz_2)
axis xy
axis equal
colorbar
caxis([-1,1])
colormap(gray)



