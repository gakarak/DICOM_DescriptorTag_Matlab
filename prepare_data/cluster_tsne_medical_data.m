close all;
clear all;


fnDSC='data_dsc_medical_dat.csv';
fnIDX='data_dsc_medical_idx.csv';

% % % dirDB='./db_medical';
% % % lstDB=dir([dirDB, '/*.dicom']);
% % % numDB=numel(lstDB);
% % % arrDsc=[];
% % % for ii=1:numDB
% % %     fn=[dirDB,'/',lstDB(ii).name];
% % %     dcmInfo=dicominfo(fn);
% % %     dsc=eval(dcmInfo.StudyID);
% % %     dsc=dsc/sum(dsc(:));
% % %     if isempty(arrDsc)
% % %         arrDsc=zeros(numDB,size(dsc,1));
% % %     end
% % %     arrDsc(ii,:) = dsc;
% % %     disp(ii);
% % % end
% % % csvwrite(fnDSC,arrDsc);

dataDsc=csvread(fnDSC);
dataIdx=csvread(fnIDX);

dataXY=tsne(dataDsc, dataIdx, 2);
