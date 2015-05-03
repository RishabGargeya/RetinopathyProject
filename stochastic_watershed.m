%STOCHASTIC_WATERSHED   Stochastic watershed
%
% SYNOPSIS:
%  pdf = stochastic_watershed(img,seeds,iter,noise,grid)
%
% PARAMETERS:
%  img:   Input image
%  seeds: Number of seeds
%  iter:  Number of iterations
%  noise: Noise strength
%  grid:  How the seeds are distributed. One of:
%    - 'random':    At random coordinates.
%    - 'poisson':   According to a Poisson process.
%    - 'square':    In a randomly rotated and translated square grid.
%    - 'hexagonal': In a randomly rotated and translated hexagonal grid.
%
% DEFAULTS:
%  iter = 100
%  noise = 0
%  grid = random
%
% LITERATURE:
%  K.B. Bernander, K. Gustavsson, B. Selig, I.-M. Sintorn, C.L. Luengo Hendriks,
%  "Improving the Stochastic Watershed", Pattern Recognition Letters, 2013.

% (C) Copyright 2012-2013, Cris Luengo, Karl B. Bernander, Kenneth Gustavsson
% Centre for Image Analysis, Uppsala, Sweden.

function out = stochastic_watershed(img, one, two, seeds,iter,noisestr,grid)
if nargin<5
   grid = 'random';
if nargin<4
   noisestr = 0;
if nargin<3
   iter = 100;
end;end;end
% Need to check input arguments:
% - seeds and iter must be integer scalars
% - noisestr must be scalar
% - grid must be string

sz = imsize(img);
if length(sz)~=2
   error('I''m too lazy to implement for non-2D images...');
end
out = newim(sz,'uint8');
for ii=1:iter
   switch grid
      case 'random'     % N random seeds (possibly fewer if they happen to overlap)
         s = random_seeds(seeds,sz);
      case 'poisson'    % random seeds using a Poisson process with density Area/N
         s = poisson_seeds(seeds,sz);
      case 'square'     % regular grid, square, with density Area/N
         s = square_seeds(seeds,sz);
      case 'hexagonal'  % regular grid, hexagonal, with density Area/N
         s = hexagonal_seeds(seeds,sz);
      case 'custom'
         s = custom_seeds(one, two, seeds, sz);
      otherwise
         error('Unknown GRID option')
   end
   if noisestr>0
      a = noise(img,'uniform',0,noisestr);
   else
      a = img;
   end
   
   out = out + waterseed(s,a,2);
end

function s = random_seeds(n,sz)
s = rand(n,2);
s = floor(bsxfun(@times,s,sz));
s = unique(s,'rows');
s = coord2image(s,sz);

function s = custom_seeds(a, b, n, sz)
s = [a,b];
for jj=1:n/4
    s = [s;a+rand*10,b+rand*10];
    s = [s;a-rand*10,b+rand*10];
    s = [s;a+rand*10,b-rand*10];
    s = [s;a-rand*10,b-rand*10];
end
s = floor(s);
s = unique(s,'rows');
s = coord2image(s,sz);



function s = poisson_seeds(n,sz)
s = noise(newim(sz),'uniform',0,1);
s = s>1-(n/prod(sz));

function s = square_seeds(n,sz)
d = sqrt(prod(sz)/n);
phi = (rand*pi/2)-(pi/4);
k = ceil(sz/d)*sqrt(2)/2;
[x,y] = ndgrid(-k(1):k(1),-k(2):k(2));
s = [x(:),y(:)];
s = s*[cos(phi),sin(phi);-sin(phi),cos(phi)];
s = bsxfun(@plus,s,rand(1,2))*d;
s = bsxfun(@plus,s,sz/2);
I = any( s<0 | bsxfun(@ge,s,sz) , 2 );
s(I,:) = [];
s = coord2image(s,sz);

function s = hexagonal_seeds(n,sz)
d = sqrt(prod(sz)/(n*sqrt(3)/2));
phi = (rand*pi/3)-(pi/6);
k = ceil(sz/d)*sqrt(2)/2;
k(2) = k(2)*2/sqrt(3);
[x,y] = ndgrid(-k(1):k(1),-k(2):k(2));
x = x + y/2;
y = y*sqrt(3)/2;
s = [x(:),y(:)];
s = s*[cos(phi),sin(phi);-sin(phi),cos(phi)];
s = bsxfun(@plus,s,rand(1,2).*[1,sqrt(3)/2])*d;
s = bsxfun(@plus,s,sz/2);
I = any( s<0 | bsxfun(@ge,s,sz) , 2 );
s(I,:) = [];
s = coord2image(s,sz);

%%% TESTING POINT DISTRIBUTIONS
%   sz = [500,500];
%   n = 50;
%   img = newim(sz);
%   for ii=1:200
%      if 0
%         d = sqrt(prod(sz)/n);
%         phi = (rand*pi/2)-(pi/4);
%         k = ceil(sz/d)*sqrt(2)/2;
%         [x,y] = ndgrid(-k(1):k(1),-k(2):k(2));
%         s = [x(:),y(:)];
%         s = s*[cos(phi),sin(phi);-sin(phi),cos(phi)];
%         s = bsxfun(@plus,s,rand(1,2))*d;
%         s = bsxfun(@plus,s,sz/2);
%         I = any( s<0 | bsxfun(@ge,s,sz) , 2 );
%         s(I,:) = [];
%         s = coord2image(s,sz);
%     elseif 1
%         d = sqrt(prod(sz)/(n*sqrt(3)/2));
%         phi = (rand*pi/3)-(pi/6);
%         k = ceil(sz/d)*sqrt(2)/2;
%         k(2) = k(2)*2/sqrt(3);
%         [x,y] = ndgrid(-k(1):k(1),-k(2):k(2));
%         x = x + y/2;
%         y = y*sqrt(3)/2;
%         s = [x(:),y(:)];
%         s = s*[cos(phi),sin(phi);-sin(phi),cos(phi)];
%         s = bsxfun(@plus,s,rand(1,2).*[1,sqrt(3)/2])*d;
%         s = bsxfun(@plus,s,sz/2);
%         I = any( s<0 | bsxfun(@ge,s,sz) , 2 );
%         s(I,:) = [];
%         s = coord2image(s,sz);
%      else
%         s = noise(newim(sz),'uniform',0,1);
%         s = s>1-(n/prod(sz));
%      end
%      img = img+s;
%   end
%   dipshow(img,'unit')