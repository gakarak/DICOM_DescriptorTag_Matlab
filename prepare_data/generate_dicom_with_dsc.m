close all;
clear all;

% % wdir='./db_bioid';
% % wdir='./db_brodatz';
wdir='./db_medical';
wdirIn=[wdir,'/data_png'];

lstPNG=dir([wdirIn,'/*.png']);

numPNG=numel(lstPNG);

dscType='p2i(16)[1,3,5]';
dscParam=getParamsCOO(dscType);

for ii=1:numPNG
    fn=lstPNG(ii).name;
    fnInp=sprintf('%s/%s', wdirIn, fn);
    [~,bn]=fileparts(fn);
    fnOut=sprintf('%s/%s.dicom', wdir,  bn);
    if exist(fnOut,'file') ~= 2
        data=imread(fnInp);
        dscData=calc_COO_PNIGAd(data, dscParam);
        %
        strPatientID=sprintf('%s{%s}', fn, dscType);
        strStudyID=mat2str(dscData);
        %
        dcmInfo=struct('PatientID',strPatientID, 'StudyID', strStudyID);
        dicomwrite(int16(data), fnOut, dcmInfo);
        disp(fnOut);
    end
end
