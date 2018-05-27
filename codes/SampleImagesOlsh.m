function X = SampleImagesOlsh(param)
% sampleimages - gathers image patches from Olshausen's raw (unwhitened) images.
% http://redwood.berkeley.edu/bruno/sparsenet/

load ../data/IMAGES_RAW;

Images = IMAGESr;
cols = param.cols;
samples = param.samples;

num_images = size(Images,3);
image_size = size(Images,1);

% This will hold the patches
X = zeros(cols^2, samples);
totalsamples = 0;
BUFF = 4;
getsample = floor(samples/num_images);

rng(param.seed,'twister');

for i = 1:num_images
  
  % Choose an image for this batch
  this_image = Images(:,:,i);% 
  this_image = mat2gray(this_image);

  % Determine how many patches to take
  
  if i == num_images, 
      getsample = samples - totalsamples; 
  end
  
  M1 = image_size - cols - 2*BUFF;
  N1 = image_size - cols - 2*BUFF;
  L = M1*N1;
  
  % Extract patches at random from this image to make data vector X
  for j=1:getsample
      [r, c] = ind2sub([M1, N1], randi(L));
      r = BUFF + r;
      c = BUFF + c;
      totalsamples = totalsamples + 1;
      X(:,totalsamples) = reshape( this_image(r:r+cols-1, c:c+cols-1), cols^2, 1);
  end
  
end  
