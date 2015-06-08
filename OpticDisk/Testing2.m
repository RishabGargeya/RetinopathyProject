im = im2double(imread('/Users/rishabgargeya/Desktop/database/DRIVE/training/images/24_training.tif'));
im2 = dip_image(im);
lab = rgb2lab(im);
%lab = rgb2ntsc(im); % not really lab but similar idea
f = 0.45;
wlab = reshape(bsxfun(@times,cat(3,1-f,f/2,f/2),lab),[],3);
[C,S] = pca(wlab);
S = reshape(S,size(lab));
S = S(:,:,1);
gray = (S-min(S(:)))./(max(S(:))-min(S(:)));
gray = adapthisteq(gray);
se = strel('disk',7);
c = imclose(gray, se);
J = colfilt(c,[5 5],'sliding',@std);
imshow(imadjust(J))