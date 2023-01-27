clear


%
% Download the data directly from the source 
% (note the station name and reference frame in the URL)
%
% If your computer doesn't like the "curl" command, skip this line and just
% use a file you downloaded from the website by right-click SaveAs as before.
%

  !curl http://geodesy.unr.edu/gps_timeseries/tenv3/plates/OK/J175.OK.tenv3 > J175.OK.tenv3

%
% Load the data
%
  fid=fopen('J175.OK.tenv3');
  C=textscan(fid,'%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',1);
  fclose(fid);

  t=C{3};
  x=C{9};
  y=C{11};
  z=C{13};

%
% Plot the data
%
  figure(1),clf,
  subplot(311),plot(t,x,'.-'),grid,ylabel('east (m)'),
    title('J175 in fixed Okhotsk reference frame')
  subplot(312),plot(t,y,'.-'),grid,ylabel('north (m)')
  subplot(313),plot(t,z,'.-'),grid,ylabel('elevation (m)')
