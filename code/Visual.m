function Visual( B, mag, cols, bgblack, border, minrows )
% visual - display bases for image patches
%
% B        the bases, with patches as column vectors
% mag      magnification factor
% cols     number of columns (x-dimension of map)
% bgblack  [optional] if this flag is set the background is black
% border   [optional] border pixels (default is 0)
% minrows  [optional] minimum number of rows in plot
%
if ~exist('mag','var') || isempty(mag)
     mag = 1;
end    
if ~exist('cols','var') || isempty(cols)
     cols = ceil(sqrt(size(B,2)));%ceil
end 
if ~exist('bgblack') || isempty(bgblack), bgblack = 0; end
if ~exist('border') || isempty(border), border = 0; end

Bv = mean(B(:));
B = B - Bv;

maxi = max(abs(B(:)));
mini = -maxi;

Amin = min(B(:));

% This is the side of the window

[K, L] = size(B);

dim = round(sqrt(K));%ceil

% Helpful quantities
dimm = dim-1;
dimp = dim+1;
rows = ceil(L/cols);%
% rows = cols;
if exist('minrows','var') && rows<minrows,
  rows = minrows;
end

A = eye(dim);
A = A + fliplr(A);
A(A>0) = 2;
A(A==0) = 1;
A(A>1) = 0;

% Initialization of the image
if bgblack, bgval = mini; else bgval = maxi; end

A = bgval*A;
A(A==0) = Amin;%-bgval;%
I = bgval*ones(dim*rows+rows-1+(2*border),dim*cols+cols-1+(2*border));

for i = 0:rows-1
  for j = 0:cols-1
    k = sub2ind([rows, cols], i+1,j+1);% 
    if k <= L
        I(border+i*dimp+1:border+i*dimp+dim, border+j*dimp+1:border+j*dimp+dim) = ...
          reshape(B(:,k),[dim dim]);% 
    else
        I(border+i*dimp+1:border+i*dimp+dim, border+j*dimp+1:border+j*dimp+dim) = A;
    end
  end
end

imagesc(I,'CDataMapping','direct');

colormap(gray(256));

% cb_h = colorbar;
% set(cb_h,'LimitsMode','manual','FontSize', 8, 'Fontname', 'Arial','color','k'); %'LineWidth', LineWidth,'FontWeight', 'bold',
% set(cb_h, 'Limits',[-Imax,Imax]);
axis square %equal %
axis off


