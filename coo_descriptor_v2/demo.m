close all;
clear all;

lstfn = dir(sprintf('img/*.jpg'));

numfn = numel(lstfn);

lstParams = {'p2i(8)', 'p2i(8)g(8)', 'p3i(8)a(8)'};
numprm = numel(lstParams);

cnt = 1;
figure,
for ii=1:numfn
    fimg = sprintf('img/%s', lstfn(ii).name);
    img = imread(fimg);
    if ~ismatrix(img)
        img = rgb2gray(img);
    end
    subplot(numfn, numprm+1, cnt), imshow(img);
    cnt = cnt+1;
    for kk=1:numprm
        paramDscStr = lstParams{kk};
        paramDsc = getParamsCOO_V2(paramDscStr);
        dsc = calc_COO_PNIGAd_V2(img, paramDsc);
        dsc = dsc/sum(dsc(:));
        subplot(numfn, numprm+1, cnt), plot(dsc);
        grid on;
        title(paramDscStr);
        cnt = cnt+1;
    end
end
