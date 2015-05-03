im = im2double(imread('/Users/rishabgargeya/Desktop/database/DRIVE/training/images/28_training.tif'));
green = im(:,:,2);
imshow(green)
median = medfilt2(green, [3 3]);
clahe = adapthisteq(median);
imshow(clahe)
se = strel('disk',7);
c = imclose(clahe, se);
bw = im2bw(c, 0.80);
imshow(bw)
[binary_label, n] = bwlabel(bw);
imshow(binary_label)
stats = regionprops(binary_label, 'Eccentricity');
idx = ( [stats.Eccentricity] < 0.9);
bw2 = ismember(binary_label,find(idx));
imshow(bw2)
[binary_label, n] = bwlabel(bw2);
imshow(binary_label)
stats2 = regionprops(binary_label);
areas = [stats2.Area];
[maxarea, index] = max(areas);
OP = (binary_label==index);
imshow(OP)
s = regionprops(OP, 'centroid');
centroids = cat(1, s.Centroid);
imshow(clahe)
hold on
plot(centroids(:,1), centroids(:,2), 'b*')
hold off
a = round(centroids(:,1));
b = round(centroids(:,2));

lab = rgb2lab(im);
f = 0.45;
wlab = reshape(bsxfun(@times,cat(3,1-f,f/2,f/2),lab),[],3);
[C,S] = pca(wlab);
S = reshape(S,size(lab));
S = S(:,:,1);
gray = (S-min(S(:)))./(max(S(:))-min(S(:)));

t = 0:pi/20:2*pi;
xc=a; 
yc=b;
r=100;
xcc = r*cos(t)+xc;
ycc =  r*sin(t)+yc;
roimaskcc = poly2mask(double(xcc),double(ycc), size(gray,1),size(gray,2));
roi=gray;
roi(~roimaskcc)=0;
imshow(roi)



gradient = imgradient(roi);
imshow(gradient)
gr = dip_image(gradient);
%pdf = stochastic_watershed(gr, 50, 5, 0, 'random');
pdf = stochastic_watershed(gr,a, b, 50, 5, 0, 'custom');
sz = imsize(gr);
s = [a,b];
s = [s; a+3,b];
s = [s; a,b+3];
s = [s; a+3,b+3];
s = [s; a,b-3];
s = [s; a-3,b-3];
s = [s; a-3,b];

%seeds = coord2image(s, sz);
%pdf = waterseed(seeds, gr, 2);
dipshow(pdf)


cont = dip_array(pdf);
imshow(cont*250)



