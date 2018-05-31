%% Main, 
% -------------------------------------------------------------------------

clear all
% close all
clc
pause(1)

%% Algorithm options

Case = 'SquaredC'; % SquaredC OverCompC

switch Case,

 case 'SquaredC'% for squared C, K0 = K1
  param.Case = Case;%
  param.Algorithm  = ['SquaredCUpdate'];%

  param.MaxIter = 100; % maximum number of iterations

  param.dataset = 0; % 0 for Olshausen's images; otherwise for MNIST dataset
  param.samples = 2e+4;% 1e+5;% number of samples 
  param.cols = 12; % column size for images
  param.rows = 12; % row size for images
  param.K = param.cols*param.rows;% size for images

  param.isrsvd = 0; % whether denoising by SVD
  param.rsvd = .98;% for epsilon
    
  param.beta = 2.65;%
  param.mu = log(2);%
  param.eta = 1;

  param.nuInit = 1.0;%0.25;% initial nu
  param.nuFinal = 0.001;% minimum nu
  
  param.tao = .9;
  param.Jmax = 2;% maximum inner iteration for each iteration
  
  param.KA = param.K; % size for outputs

  param.seed = 1;

 case 'OverCompC' % for K0 <= K1
  param.Case = Case;%
  param.Algorithm  = ['OverCompCUpdate'];%

  param.MaxIter = 100; % maximum number of iterations

  param.dataset = 0; % 0 for Olshausen's images; otherwise for MNIST dataset
  param.samples = 2e+4;% 1e+5;% number of samples 
  param.cols = 12; % column size for images
  param.rows = 12; % row size for images
  param.K = param.cols*param.rows;% size for images

  param.isrsvd = 1;% whether denoising by SVD
  param.rsvd = .98;% for epsilon
    
  param.beta = 2.65;%
  param.mu = log(2);%
  param.eta = 1;

  param.nuInit = 0.25;%0.5;% initial nu
  param.nuFinal = 0.001;% minimum nu
  
  param.tao = .9;
  param.Jmax = 2;% maximum inner iteration for each iteration

  param.KA = 1024;% size for outputs
  
  param.seed = 1;
  
 otherwise,
  error('No such algorithm!');

end
% ---------------------------------------------------------------------
svd = round(param.isrsvd*param.rsvd*1000);

str = [num2str(param.rows),'x',num2str(param.cols), 'vs', num2str(param.KA), ...
    '_D', int2str(param.dataset),'M', int2str(param.samples/10000), 'S', num2str(svd), 'N', num2str(100*param.nuInit)];

filestr = [param.Case, '_', str];%

%% --- LEARNING ---------------------------------------------
% Sample image patches

if  param.dataset == 0 
   X = SampleImagesOlsh(param);
   X = CenterX(X);
else
   X = SampleImagesMNIST; 
   X = CenterX(X);
end

%% ---------------------------------------------------
fprintf(['Start "', filestr,'" ... \n']);
% Start the learning 

[C, U, d, objhistory] = feval(str2func(param.Case), X, param, filestr);

fprintf(['Done "', filestr,'"!\n']);

pause(1);
%% ========================================================================

% fname = ['../results/', filestr,'.mat'];  
% load([fname]);

%% Show filters fields ---------------------------------------------------- 

KX = size(C,1);
C1 =  U(:,1:KX)*C;%
B = U(:,1:KX)*diag(d(1:KX))*C;%% for basises  

% % ----------------------------------------------------------------------
issave = 0;
str = 'a';

fn1 = ['Fig1' str];
KA = size(B, 2);
r = 1;
len = round(r*KA);
ShowFiltersFields(B(:,1:len), 1, [], fn1, issave);% B C1

%% Display evolution of objective function --------------------------------
IsShowHist = 1;

fn2 = ['Fig2' str];

FontSize = 10;

if IsShowHist
  if exist('objhistory','var') && (length(objhistory)>1)

     HFig = figure('Name',[param.Algorithm,', Evolution of objhistory '], 'PaperUnits', 'inches','PaperSize', [10 10], 'PaperPosition',[0.0, 0.0, 10, 10]);
%      axes('Position',[0.15 0.15 .8 .8]);%[left bottom width height] 
     lh = length(objhistory);
     indx = [1:lh]';
     x = [1:length(indx)]';
     y = objhistory(indx);
     plot(x, y,'-ok','MarkerSize',3);%'-ok'
     box on
     set(gca, 'FontSize', FontSize,'LineWidth', 1.5);%'Fontname', 'Arial', , 'XColor', 'black','YColor', 'black''TickDir', 'in','XMinorTick', 'off', 'YMinorTick', 'off',  'TickLength', [TickLength,TickLength],'xtick',xtick, 'XTickLabel',xlab,

     xlim([x(1), x(end)]);
     ylim([min(y),max(y)]);
     xlabel('Number of Iterations', 'FontSize', FontSize)
     ylabel('Objective Value', 'FontSize', FontSize)
     if issave
         fileprint = ['../figures/',fn2];%
%              print(HFig, '-depsc2','-tiff', '-r600', [fileprint,'.eps']);
         print(HFig, '-painters',  '-dpdf', '-r600', [fileprint,'.pdf']);
     end
  end
end

pause(1);

%% ========================================================================