clear


%
% Download the data directly from the source 
% (note the station name and reference frame in the URL)
%
% If your computer doesn't like the "curl" command, skip this line and just
% use a file you downloaded from the website by right-click SaveAs as before.
%

  % !curl http://geodesy.unr.edu/gps_timeseries/tenv3/plates/OK/J175.OK.tenv3 > J175.OK.tenv3
  % !curl http://geodesy.unr.edu/gps_timeseries/tenv3/plates/NA/P404.NA.tenv3 > P404.NA.tenv3

%
% Load the data
%
  fid=fopen('P404.NA.tenv3');
  C=textscan(fid,'%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',1);
  fclose(fid);

  t=C{3};
  x=C{9};
  y=C{11};
  z=C{13};

  stationlat=C{21}(1);
  stationlon=C{22}(1);

%
% Plot the data
%
  figure(1),clf,
  subplot(311),plot(t,x,'.-'),grid,ylabel('east (m)'),
    % title('J175 in fixed Okhotsk reference frame')
  subplot(3,1,2),plot(t,y,'.-'),grid,ylabel('north (m)')
  subplot(3,1,3),plot(t,z,'.-'),grid,ylabel('elevation (m)')

%
% Calculate the velocity of each component
%
  pX=polyfit(t,x,1);
  pY=polyfit(t,y,1);
  pZ=polyfit(t,z,1);

  vX=pX(1);
  vY=pY(1);
  vZ=pZ(1);

%
% Add the best fit line to the original plot
%
  subplot(311),hold on,plot(t,polyval(pX,t),'linewidth',3)
  subplot(312),hold on,plot(t,polyval(pY,t),'linewidth',3)
  subplot(313),hold on,plot(t,polyval(pZ,t),'linewidth',3)

%
% Plot the residuals! (what's left after you subtract the trend)
%
  figure(2),clf
  subplot(311),plot(t,x-polyval(pX,t),'linewidth',3)
  subplot(312),plot(t,y-polyval(pY,t),'linewidth',3)
  subplot(313),plot(t,z-polyval(pZ,t),'linewidth',3)

%
% Load the lazy map data and make a simple velocity plot
%
  c=load('coastfile.xy');
  b=load('politicalboundaryfile.xy');

  figure(3),clf
  plot(c(:,1),c(:,2))
  hold on
  plot(b(:,1),b(:,2),'color',[1 1 1]*0.75)
  plot(stationlon,stationlat,'^k')
  quiver(stationlon,stationlat,vX,vY,1e2)
  scatter(stationlon,stationlat,50,vZ*1000,'filled')
  colorbar
  caxis([-1,1])
  colormap(jet)
  xlim([-127,-115])
  ylim([41,50])

