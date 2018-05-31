function X = CenterX(images)
% 01/29/2016

K = size(images,1);

X = images - ones(K,1)*mean(images);

end


