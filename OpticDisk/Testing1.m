im = im2double(imread('/Users/rishabgargeya/Desktop/database/DRIVE/training/images/22_training.tif'));

im2 = dip_image(im);
lab = rgb2lab(im);
f = 0.45;
wlab = reshape(bsxfun(@times,cat(3,1-f,f/2,f/2),lab),[],3);
[C,S] = pca(wlab);
S = reshape(S,size(lab));
S = S(:,:,1);
gray = (S-min(S(:)))./(max(S(:))-min(S(:)));
se = strel('disk',7);
c = imclose(gray, se);
bw = colfilt(c,[5 5],'sliding',@std);
imshow(imadjust(bw))
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
imshow(gray)
hold on
plot(centroids(:,1), centroids(:,2), 'b*')
hold off
a = round(centroids(:,1));
b = round(centroids(:,2));

% MASK OUT / SELECT ROI

t = 0:pi/20:2*pi;
xc=a; 
yc=b;
r=100;
xcc = r*cos(t)+xc;
ycc =  r*sin(t)+yc;
roimaskcc = poly2mask(double(xcc),double(ycc), size(gray,1),size(gray,2));
roi=c;
roi(~roimaskcc)=0;
imshow(roi)


gradient = imgradient(c);
%gr = dip_image(gradient);
%pdf = stochastic_watershed(gr, 50, 5, 0, 'random');
%cont = dip_array(pdf);
%imshow(cont)

s = rand(10,2);
s = floor(bsxfun(@times,s,size(gradient)));
s = unique(s,'rows');
mu = 0;
sigma = 1;
pd = makedist('Normal',mu,sigma);
y = cdf(pd,gradient);
[a,b] = size(gradient);
tmp = y(1,1);
for jj=1:a
    for kk=1:b
        if y(jj,kk) < tmp
            tmp = y(jj,kk);
        end
    end
end
y

