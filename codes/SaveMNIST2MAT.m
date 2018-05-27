% SaveMNIST2MAT
% The MNIST database of handwritten digits, available from 
% http://yann.lecun.com/exdb/mnist/

clear all

filename = ['../data/train-images-idx3-ubyte'];
images = LoadMNISTImages(filename);

svfile = ['../data/train-images-idx3-ubyte.mat'];

K = size(images,1);

images = mat2gray(images); 

save(svfile, 'images');%




