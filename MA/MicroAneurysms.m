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

gaborArray = gaborFilterBank(5, 4, 77, 77);
C1 = gaborArray(2,:);
C2 = gaborArray(5,:);

GW = cat(2, C1, C2);

img = im2double(img);


for i=1:length(GW)
    imgfilt{i} = conv2(img, GW{i}, 'same');
end


R = 39; C = 39;

pR = (R-1)/2;
pC = (C-1)/2;

[a,b] = size(imgfilt{1})

%# Maximum Response Image.
imgS = zeros(a,b);
for i=1:a
    for j=1:b
    arr = [imgfilt{1}(i,j), imgfilt{2}(i,j),imgfilt{3}(i,j),imgfilt{4}(i,j),imgfilt{5}(i,j),imgfilt{6}(i,j),imgfilt{7}(i,j),imgfilt{8}(i,j)];
    %arr
    imgS(i,j) = max(arr);
    end
end


figure('NumberTitle','Off','Name','Gabor Filter Response');

imagesc(abs(imgS))
colormap(gray(256));

img_out_disp = sum(abs(imgS).^2, 3).^0.5;        
 %default superposition method, L2-norm        
 img_out_disp = img_out_disp./max(img_out_disp(:));           
 % normalize        
figure;
imshow(img_out_disp);

figure;
imshow(im2bw(img_out_disp, 0.2))
