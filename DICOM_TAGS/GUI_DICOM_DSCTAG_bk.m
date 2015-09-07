function varargout = GUI_DICOM_DSCTAG(varargin)
% GUI_DICOM_DSCTAG MATLAB code for GUI_DICOM_DSCTAG.fig
%      GUI_DICOM_DSCTAG, by itself, creates a new GUI_DICOM_DSCTAG or raises the existing
%      singleton*.
%
%      H = GUI_DICOM_DSCTAG returns the handle to a new GUI_DICOM_DSCTAG or the handle to
%      the existing singleton*.
%
%      GUI_DICOM_DSCTAG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DICOM_DSCTAG.M with the given input arguments.
%
%      GUI_DICOM_DSCTAG('Property','Value',...) creates a new GUI_DICOM_DSCTAG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_DICOM_DSCTAG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_DICOM_DSCTAG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_DICOM_DSCTAG

% Last Modified by GUIDE v2.5 26-Jan-2015 15:32:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_DICOM_DSCTAG_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_DICOM_DSCTAG_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before GUI_DICOM_DSCTAG is made visible.
function GUI_DICOM_DSCTAG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_DICOM_DSCTAG (see VARARGIN)

% Choose default command line output for GUI_DICOM_DSCTAG
handles.output = hObject;

% % % % % % % % % % % % % % % % % % % % % % % % % 
disp('::GUI_DICOM_DSCTAG_OpeningFcn()');

handles.numResAxes = 6;
handles.lstResAxes = {...
    handles.axesRes1,...
    handles.axesRes2,...
    handles.axesRes3,...
    handles.axesRes4,...
    handles.axesRes5,...
    handles.axesRes6};

handles.queryData=[];
handles.queryInfo=[];
handles.queryDsc=[];

handles.dbDir='./bioid';
% % handles.dbDir='./brodatz';
handles.isLoadedDB=false;
handles.lstDBImages={};
handles.arrDBDsc=[];
handles.numDBDsc=-1;

refreshDBList(hObject);

% % % % % % % % % % % % % % % % % % % % % % % % %


% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using GUI_DICOM_DSCTAG.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end
clearSearchResults(hObject);

% UIWAIT makes GUI_DICOM_DSCTAG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_DICOM_DSCTAG_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btnLoad.
function btnLoad_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile('*.dicom;*.dcm;*.DICOM;*.DCM','Select DICOM file');
disp(FileName);
FileNameFull=[PathName, '/', FileName];
if FileName~=0
    if exist(FileNameFull,'file')==2
        try
            tmpInfo=dicominfo(FileNameFull);
            handles.queryInfo=tmpInfo.PatientID;
            handles.queryDsc =eval(tmpInfo.StudyID)';
            handles.queryData=im2double(dicomread(FileNameFull));
            axes(handles.axesQuery);
            imshow(handles.queryData,[]);
            axes(handles.axesPlot);
            plot(handles.queryDsc);
            set(handles.textPatientID,'string',handles.queryInfo);
            set(handles.textStudyID,  'string',tmpInfo.StudyID);
        catch err
            handles.queryInfo=[];
            handles.queryDsc =[];
            handles.queryData=[];
            strError=sprintf('Cant load/read DICOM file [%s] (%s)', FileName, err.message);
            errordlg(strError);
            rethrow(err);
        end
    else
        strError=sprintf('Cant find file [%s]', FileName);
        errordlg(strError);
    end
end
guidata(hObject, handles);
return


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on button press in btnSearch.
function btnSearch_Callback(hObject, eventdata, handles)
% hObject    handle to btnSearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if ~isempty(handles.queryDsc)
        if handles.isLoadedDB
            querySearch(hObject);
        else
            errordlg('DICOM database is not loaded. Please load DB data!','Error','modal');
        end
    else
        errordlg('Query DICOM image is not loaded!','Error','modal');
    end
return

function clearSearchResults(hObject)
    handles=guidata(hObject);
    rndImage=uint8(200*randn(100,100));
    %
    axes(handles.axesQuery);
    imshow(rndImage,[]);
    set(handles.axesQuery, 'XTickLabel','', 'YTickLabel','');
    %
    axes(handles.axesPlot);
    xx=-10:0.1:10;
    yy=sin(xx);
    plot(xx,yy)
% %     imagesc(rndImage);
% %     colormap(gray);
    plot(xx,yy);
    set(handles.axesPlot, 'XTickLabel','', 'YTickLabel','');
    %
    for ii=1:handles.numResAxes
        rndImage=uint8(200*randn(60,60));
        axes(handles.lstResAxes{ii});
        imshow(rndImage,[]);
    end
    guidata(hObject, handles);
return


% --- Executes on button press in btnLoadDB.
function btnLoadDB_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
disp(get(handles.popupListDB, 'string'));
idxPopup=get(handles.popupListDB,'Value');
handles.dbDir=get(handles.popupListDB,'string');
handles.dbDir=handles.dbDir{idxPopup};
if isdir(handles.dbDir)
    lstDICOM=dir([handles.dbDir,'/*.dicom']);
    numDICOM=numel(lstDICOM);
    if numDICOM>1
        handles.isLoadedDB=false;
        handles.lstDBImages={};
        handles.arrDBDsc=[];
        handles.numDBDsc=-1;
        numGood=0;
        h=waitbar(0, 'Loading DB...');
        tmpLstDsc={};
        for ii=1:numDICOM
            fn=[handles.dbDir, '/', lstDICOM(ii).name];
            waitbar(ii/numDICOM,h);
            try
% %                 data=dicomread(fn);
                dataInfo=dicominfo(fn);
                dsc=eval(dataInfo.StudyID);
                numGood=numGood+1;
                handles.lstDBImages{numGood}=fn;
                tmpLstDsc{numGood}=dsc;
            catch err
                rethrow(err);
            end     
        end
        if numGood>1
            waitbar(1.0,h,'One moment...');
            handles.arrDBDsc=zeros(numGood, size(tmpLstDsc{1},1));
            for ii=1:numGood
                handles.arrDBDsc(ii,:)=tmpLstDsc{ii};
            end
            handles.numDBDsc=numGood;
            handles.isLoadedDB=true;
            set(handles.textDBInfo, 'string', sprintf('loaded #%d DICOM images', numGood));
        else
            handles.lstDBImages={};
            strError=sprintf('Cant find valid DICOM in DB directory [%s/*.dicom]', handles.dbDir);
            errordlg(strError);
        end
        close(h);
    else
        strError=sprintf('Cant find DICOM data in DB directory [%s/*.dicom]', handles.dbDir);
        errordlg(strError);
    end
else
    strError=sprintf('Cant find DB directory [%s]', handles.dbDir);
    errordlg(strError);
end
guidata(hObject, handles);
return

function querySearch(hObject)
    handles=guidata(hObject);
    if ~isempty(handles.queryDsc) && handles.isLoadedDB
       dst=pdist2(handles.arrDBDsc, handles.queryDsc, 'cityblock');
       [BB,II]=sort(dst);
       h=waitbar(0,'wait query...');
       for ii=1:handles.numResAxes
           waitbar(ii/handles.numResAxes,h,'wait query...');
           try
                data=dicomread(handles.lstDBImages{II(ii)});
                axes(handles.lstResAxes{ii});
                imshow(data,[]);
           catch err
               fprintf('Error: %d/%d : %s\n', ii, handles.numResAxes, err.message);
           end
       end
       close(h);
    end
    guidata(hObject, handles);
return

function refreshDBList(hObject)
    handles=guidata(hObject);
    lstDir=dir('./db_*');
    numDir=numel(lstDir);
    lstDirGood={};
    cnt=1;
    for ii=1:numDir
        if lstDir(ii).isdir
            lstDirGood{cnt}=lstDir(ii).name;
            cnt=cnt+1;
        end
    end
    set(handles.popupListDB,'string',lstDirGood);
    guidata(hObject, handles);
return


% --- Executes during object creation, after setting all properties.
function popupListDB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupListDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% % refreshDBList(hObject);

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
