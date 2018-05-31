function images = SampleImagesMNIST()
% gathers image patches from MNIST database.
% first, you need to ran 'SaveMNIST2MAT' to get train-images-idx3-ubyte.mat

filename = ['../data/train-images-idx3-ubyte.mat'];

load(filename, 'images');

end
