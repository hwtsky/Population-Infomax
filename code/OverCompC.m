function [C, U, d, objhistory] = OverCompC(X, param, filestr)

[K, SampleNum] = size(X);

% Initializing X
xv = mean(X,2);
X = X - repmat(xv,1,SampleNum);
[U, D] = svd(X);%
d = diag(D)/sqrt(SampleNum-1);

if param.isrsvd %
    
    d2 = d.*d;
    dc = sqrt(cumsum(d2)./sum(d2));
    ind = find(dc <= param.rsvd);
    KX = length(ind);
    
    X = diag(1./(d(1:KX)+eps))*U(:,1:KX)'*X;%

else
    V = diag(1./(d+eps))*U';%
    X = V*X;%
    KX = size(X, 1);

end

%% Main Loop
P = param;

fprintf('\nStart update ...\n');

rng(param.seed,'twister');

C = randn(KX, P.KA);% 
    
r = sqrt(P.KA/KX);
cn = r*sqrt(sum(C.*C));
cn(cn < 1) = 1;
C = C./(ones(KX,1)*cn + eps);%

t_start = clock;
[C, objhistory] = feval(str2func(param.Algorithm), C, X, P);%

Time = etime(clock, t_start)/60;

fprintf(['Elapsed time is %.3f minutes ...\n'],Time);

%% ========================================================================

fname = ['../results/', filestr,'.mat'];
fprintf(['Saving file: ' fname,'\n']);

save(fname,'param', 'C', 'U', 'd', 'objhistory',  'filestr','Time');

end


