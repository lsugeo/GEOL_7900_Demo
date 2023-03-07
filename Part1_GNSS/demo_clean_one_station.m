clear


%
% clean the data from one messy station
%

  % !curl http://geodesy.unr.edu/gps_timeseries/tenv3/plates/NA/BTON.NA.tenv3 > BTON.NA.tenv3

%
% Load the data
%
  fid=fopen('BTON.NA.tenv3');
  C=textscan(fid,'%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',1);
  fclose(fid);

  tyr=C{3}; % time in decimal year as before
  t=datenum(C{2},'yymmmdd'); % time in "Matlab time", sequential days
  x=C{9};
  y=C{11};
  z=C{13};

  stationlat=C{21}(1);
  stationlon=C{22}(1);

%
% Plot the data
%  - note the "datetick", since the x axis is now a date number
%
  figure(1),clf,
  subplot(311),plot(t,x,'.-'),datetick,grid,ylabel('east (m)'),title('original raw data')
  subplot(312),plot(t,y,'.-'),datetick,grid,ylabel('north (m)')
  subplot(313),plot(t,z,'.-'),datetick,grid,ylabel('elevation (m)')

%
% fill the gaps in the data with NaNs, and make a continuous time vector
%  - note how the time and data vectors get longer
%  - we'll save a copy of the old version, for our reference
%
  t_orig=t;
  x_orig=x;
  y_orig=y;
  z_orig=z;


  length(t_orig)

  dt=1; % samle interval: 1=daily

  [t,x]=filltimegap(t_orig,x_orig,dt);
  [t,y]=filltimegap(t_orig,y_orig,dt);
  [t,z]=filltimegap(t_orig,z_orig,dt);

  figure(2),clf,
  subplot(311),plot(t,x,'.-'),datetick,grid,ylabel('east (m)'),title('gaps filled with NaNs')
  subplot(312),plot(t,y,'.-'),datetick,grid,ylabel('north (m)')
  subplot(313),plot(t,z,'.-'),datetick,grid,ylabel('elevation (m)')

  t_NaNgaps=t;
  x_NaNgaps=x;
  y_NaNgaps=y;
  z_NaNgaps=z;


  length(t_NaNgaps)

%
% deal with the jump in the vertical component
%
  tjump=datenum([2011 1 1]); % jump happens ~ on this date
  iafter=find(t>tjump); % these are the points that we'll change
  jump_amount=0.25; % this is a guestimate based on the figures...
  z(iafter)=z(iafter)-jump_amount;

  figure(3),clf,
  subplot(311),plot(t,x,'.-'),datetick,grid,ylabel('east (m)'),title('vertical jump fixed')
  subplot(312),plot(t,y,'.-'),datetick,grid,ylabel('north (m)')
  subplot(313),plot(t,z,'.-'),datetick,grid,ylabel('elevation (m)')

%
% deal with outliers in the northings component
%
  ycutoff=0.3; % outliers seem to be below this level
  ibad=find(y<ycutoff); % these are the points we'll change
  y(ibad)=NaN; % replace with NaN

  figure(4),clf,
  subplot(311),plot(t,x,'.-'),datetick,grid,ylabel('east (m)'),title('northing outliers fixed')
  subplot(312),plot(t,y,'.-'),datetick,grid,ylabel('north (m)')
  subplot(313),plot(t,z,'.-'),datetick,grid,ylabel('elevation (m)')

%
% deal with outliers in the eastings component
%  - these are trickier to identify... need conditions on both t and x...
%
  xcutoff=0.74; % outliers seem to be below this level... but early data has legit values below this
  tcutoff=datenum([2008 1 1]); 
  ibad=find(x<xcutoff & t>tcutoff); % combine two different conditions using the "&"
  x(ibad)=NaN; % replace with NaN

  figure(5),clf,
  subplot(311),plot(t,x,'.-'),datetick,grid,ylabel('east (m)'),title('easting outliers fixed')
  subplot(312),plot(t,y,'.-'),datetick,grid,ylabel('north (m)')
  subplot(313),plot(t,z,'.-'),datetick,grid,ylabel('elevation (m)')

  t_cleaned=t;
  x_cleaned=x;
  y_cleaned=y;
  z_cleaned=z;

%
% now that we've got a "clean" time series, smooth and fill in the 
% small gaps with a moving median (tell it to ignore the existing NaNs)
% note the number of NaNs has decreased
%
  twindow=30; % how many data points should your window cover?  since our dt=1, this is the same as # of days

  [numel(find(isnan(x))),numel(find(isnan(y))),numel(find(isnan(z)))]

  x_smoothed=movmedian(x,twindow,'omitnan');
  y_smoothed=movmedian(y,twindow,'omitnan');
  z_smoothed=movmedian(z,twindow,'omitnan');

  figure(6),clf,
  subplot(311),plot(t,x_smoothed,'.-'),datetick,grid,ylabel('east (m)'),title('smoothed')
  subplot(312),plot(t,y_smoothed,'.-'),datetick,grid,ylabel('north (m)')
  subplot(313),plot(t,z_smoothed,'.-'),datetick,grid,ylabel('elevation (m)')
  
  [numel(find(isnan(x_smoothed))),numel(find(isnan(y_smoothed))),numel(find(isnan(z_smoothed)))]

%
% Still has some gaps! lots of options for how to deal with those, but that's enough for now
%

