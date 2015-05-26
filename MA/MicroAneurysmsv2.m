im = imread('/Users/rishabgargeya/Desktop/database/diaretdb1_v_1_1/resources/images/ddb1_fundusimages/image010.png');
green = im(:,:,2);
imshow(green)
reg_min = imregionalmin(green);
reg_min = im2uint8(reg_min);
imshow(reg_min)
reconstruct = imreconstruct(reg_min, green);
imshow(reconstruct)

clahe = adapthisteq(reconstruct);
%imshow(clahe)
img = clahe;
[m,n] = size(img);

%parameters                 
lambda  = 8;    
theta   = 0;    
psi     = [0 pi/2];    
gamma   = 0.5;    
bw      = 1;    
N       = 12;    
img_in = im2double(img);    

img_out = zeros(size(img_in,1), size(img_in,2), N);    
 
 for n=1:N         
        gb = gabor_fn(bw,gamma,psi(1),lambda,theta)...          
         + 1i * gabor_fn(bw,gamma,psi(2),lambda,theta);     
         % n-th gabor filter 
        img_out(:,:,n) = imfilter(img_in, gb, 'symmetric');                   
        theta = 15 * n; % for next orientation           
 end 

 figure(1);           
 imshow(img_in);                  
 title('input image');                    
 figure(2);            
 img_out_disp = sum(abs(img_out).^2, 3).^0.5;        
 %Euclidian-norm       
 img_out_disp = img_out_disp./max(img_out_disp(:));           
 % normalize
 imshow(img_out_disp);         
 title('gabor maximum response'); 

figure(3);
imshow(im2bw(img_out_disp, 0.3))

result = im2bw(img_out_disp, 0.3)

% Symmetric filter params
symmfilter = struct();
symmfilter.sigma     = 2.4;
symmfilter.len       = 8;
symmfilter.sigma0    = 3;
symmfilter.alpha     = 0.7;
% Asymmetric filter params
asymmfilter = struct();
asymmfilter.sigma     = 1.8;
asymmfilter.len       = 22;
asymmfilter.sigma0    = 2;
asymmfilter.alpha     = 0.1;

% Filters responses
% Tresholds values
% DB1 -> preprocessthresh = 0.5, thresh = 48

im = double(im)./ 255;
[resp segresp r1 r2] = BCOSFIRE(im, symmfilter, asymmfilter, 0.1, 40);
figure(4);
imshow(segresp);

result(segresp) = 0;

imshow(result)

