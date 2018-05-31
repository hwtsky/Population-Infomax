function ShowFiltersFields(B, mag, cols, name, issave)

	if ~exist('mag','var') || isempty(mag)
        mag = 1;
    end
    
	if ~exist('cols','var') || isempty(cols)
        cols = ceil(sqrt(size(B,2)));
    end

    if ~exist('name','var') || isempty(name)
        name = 'Filters';
    end
    if ~exist('issave','var') || isempty(issave)
        issave = 0;
    end

    HFig = figure('Name',[name], 'PaperUnits', 'inches','PaperSize', [10 10], 'PaperPosition',[0.0, 0.0, 10, 10]);%normalized
    axes('Position',[0.008 0.008 .984 .984]);%[left bottom width height] 
    
    Visual(B, mag, cols ); 
    if issave
        fileprint = ['../figures/',name];
        print(HFig, '-painters',  '-dpdf', '-r600', [fileprint,'.pdf']);%'-tiff',-depsc2 .eps
    end
end