clear

%
% Make an okada model of displacement due to 
% disolocation on a plane embeded within an
% elastic halfspace, and calculate the modeled
% line-of-sight displacement for comparison 
% with unwrapped interferograms
%

%
% Define the grid of points where we'll sample the displacement field
% (units of km from center of dislocation at 0,0)
%
  xmodel=[-50:.1:50];
  ymodel=[-50:.1:50];
  [xmesh,ymesh]=meshgrid(xmodel,ymodel);

  % check that the grids have the x and y values, and that they're not backward
  figure(1),clf,
  subplot(121),imagesc(xmodel,ymodel,xmesh),axis xy,colorbar,title('x value of grid for calculating displacements')
  subplot(122),imagesc(xmodel,ymodel,ymesh),axis xy,colorbar,title('y value of grid for calculating displacements')

%
% Define the paramaters we'll use for our model
%
  % points to sample the surface displacement
  E=xmesh;
  N=ymesh;

  % fault/plane orientation info
  STRIKE=315; % degrees east of north
  DIP=35;     % degress down from horizontal

  % fault/plane dimensions and location
  DEPTH=3;    % center of plane, km below the surface
  LENGTH=70;  % along strike length, km
  WIDTH=5;    % along dip width, km

  % amount and direction of motion on fault/plane
  RAKE=90;    % direction of in-plane hanging wall motion, in deg CCW from strike
  SLIP=7;     % how much in-plane slip (m)
  OPEN=0.1;   % how much opening or closing of the plane (m)

%
% Use the Okada solutions to determine expected surface displacement
%  in East, North, and Vertical directions (m)
% Plot the displacements
%   Note: csym is a Karen subroutine that makes the colorscale symmetric
%
  [uE,uN,uZ] = okada85(E,N,DEPTH,STRIKE,DIP,LENGTH,WIDTH,RAKE,SLIP,OPEN);

  figure(2),clf
  subplot(131),imagesc(xmodel,ymodel,uE),axis xy,colorbar,csym,title('modeled east (m)')
  subplot(132),imagesc(xmodel,ymodel,uN),axis xy,colorbar,csym,title('modeled north (m)')
  subplot(133),imagesc(xmodel,ymodel,uZ),axis xy,colorbar,csym,title('modeled vertical (m)')
  colormap(jet)

%
% Resolve displacements from East/North/Vertical directions into 
% line-of-sight direction.
%  - Note: actual radar geometry varies a bit across the scene,
%    but using a single number is close enough for our purposes.
%
  % define radar geometry
  IncAngle=39;   % degrees from vertical - ranges from 32 - 46, so this is a good average number
  HeadAngle=-10; % degrees from north - ascending flight direction, in deg E of N
  % HeadAngle=-170; % degrees from north - descending flight direction, in deg E of N

  % unit vector components for the line-of-sight direction
  px=sind(IncAngle)*cosd(HeadAngle);
  py=-sind(IncAngle)*sind(HeadAngle);
  pz=-cosd(IncAngle);

  % displacement in LOS direction is dot product of 3D displacement with LOS unit vector
  uLOS=uE*px+uN*py+uZ*pz;

  % Just for fun (and learning/demonstration), convert the predicted displacement back to wrapped phase
  wavelength=0.05546576;
  uphase=mod(uLOS/wavelength*4*pi,2*pi);

  figure(3),clf
  subplot(121),imagesc(xmodel,ymodel,uLOS),axis xy,colorbar,csym,title('modeled line of sight displacement (m)')
  subplot(122),imagesc(xmodel,ymodel,uphase),axis xy,colorbar,title('modeled wrapped phase')
  colormap(jet)

