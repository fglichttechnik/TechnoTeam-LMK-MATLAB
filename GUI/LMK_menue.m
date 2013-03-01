function varargout = LMK_menue(varargin)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% LMK_MENUE M-file for LMK_menue.fig
%      LMK_MENUE, by itself, creates a new LMK_MENUE or raises the existing
%      singleton*.
%
% With this GUI the user can capture HighDyn camera images, show the
% dimensions of the image, select rectangles for evaluation and save all.

% Last Modified by GUIDE v2.5 25-May-2012 10:27:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @LMK_menue_OpeningFcn, ...
    'gui_OutputFcn',  @LMK_menue_OutputFcn, ...
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


% --- Executes just before LMK_menue is made visible.
function LMK_menue_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for LMK_menue
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% load preferences for latest integration times the user used
global path drMinTime drMaxTime border position1 fieldLength
load([path, '\preferences.mat']);
set(handles.maxTime, 'String', drMaxTime);
set(handles.minTime, 'String', drMinTime);
set(handles.borderEdit, 'String', border);
set(handles.fieldLength, 'String', fieldLength);

% pass text (info from LMK_initFig) from workspace to GUI
text = evalin('base', 'text');
set(handles.startInfo, 'String', text);

% get current position:
position1 = str2double(get(handles.distance, 'String'));
fieldLength = str2double(get(handles.fieldLength, 'String'));
% currentPosition = LMK_calcPosition(position1, fieldLength);
measPoints = str2double( get( handles.measPoints, 'String' ) );
diff = fieldLength / measPoints;
positionContents = cellstr(get(handles.positionPopup, 'String'));                
rectPosition = str2double(positionContents{get(handles.positionPopup, 'Value')});
if rectPosition < 0
    currentPosition = position1 + (round((diff * rectPosition + diff/2)*100)/100);
else
    currentPosition = position1 + (round((diff * rectPosition - diff/2)*100)/100);
end
set( handles.currentPositionText, 'String', num2str( currentPosition ) );
distance = str2double( get( handles.distance, 'String' ) );
relativePosition = currentPosition - distance;
set( handles.position, 'String', num2str( relativePosition ) );



% --- Outputs from this function are returned to the command line.
function varargout = LMK_menue_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
%function file_menue_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function save_menu_Callback(hObject, eventdata, handles)
% get infos of the last capture
str = get(handles.lastCaptureText, 'String');

% check if there is data to save
if isempty(str)
    % helpdialog when there is no data to save, nothing will be saved
    helpdlg(['Sorry, no data to save. Please first make a ',...
        'measurement before you save.'], 'No data!'),
else
    % get picture format
    picfor = str{2};
    % get date and time of the last measurement
    date_time = str{10};
    % check whether file already exists
    checkfilename = 1;
    while checkfilename == 1
        % get target directory with LMK_savefig GUI
        LMK_saveFig;
        uiwait(LMK_saveFig);
        has_cancelled = evalin('base', 'has_cancelled');
        dir_name = evalin('base', 'dir_name');
        % save only when user has not cancelled saving
        if has_cancelled == 0
            % get the value whether to save protocoll, too
            val_prot = evalin('base', 'val_prot');
            % get camera image and file name from workspace
            cameraImage = evalin('base', 'cameraImage');
            file_name = evalin('base', 'file_name');
            % check image
            if strmatch('Single Luminance Picture', picfor)
                luminanceImage = evalin('base', 'luminanceImage');
            end
            if strmatch('HighDyn Color Picture', picfor)
                colorImageRGB = evalin('base', 'colorImageRGB');
                colorImageXYZ = evalin('base', 'colorImageXYZ');
            end
            if strmatch('HighDyn for each filter position', picfor)
                highDynImageXYZL = evalin('base', 'highDynImageXYZL');
            end
            % get relevant image data
            measurementMetaDataS = evalin('base', 'lastInfo');
            for i = 1 : 9
                measurementMetaData{i} = measurementMetaDataS{i};
            end
            measurementMetaData{10} = measurementMetaDataS{11};
            measurementMetaData{11} = measurementMetaDataS{12};
            
            % convert image matrices into structs
            if exist('luminanceImage', 'var')
                dataImage.L = luminanceImage; %2D-Matrix
            else
                if exist('colorImageXYZ', 'var')
                    dataImage.X = colorImageXYZ(:, :, 1); %colorImageXYZ = 3D-Matrix, 3rd Dim.: XYZ or RGB
                    dataImage.Y = colorImageXYZ(:, :, 2);
                    dataImage.Z = colorImageXYZ(:, :, 3);
                else
                    dataImage.X = highDynImageXYZL(:, :, 1);
                    dataImage.YL = highDynImageXYZL(:, :, 2); % Y = L
                    dataImage.Z = highDynImageXYZL(:, :, 3);
                    dataImage.LS = highDynImageXYZL(:, :, 4);
                end
            end
            %create LMK_Measurement object:
            LMK_measurements = LMK_Measurement(date_time, cameraImage, ...
                dataImage, measurementMetaData);
            imageNames = properties(LMK_measurements.measurementMetaData);            
            LMK_measurements.comments = get(handles.commentsEdit, 'String');
            LMK_measurements.lightSource = get(handles.lightSourceEdit, 'String');
            
            % check file name
            filename = [dir_name, '\', file_name];
            if ~exist([filename, '.mat'], 'file')   
                disp('file does not exist');
                checkfilename = 0               
            else
                % handle case if file already exists in target directory
                disp('Sorry, file already exists');
                % Construct a questdlg with two options
                choice = questdlg('File already exists. Overwrite?', ...
                    'Save Menu', ...
                    'YES','NO, type in another filename', 'NO, type in another filename');
                % Handle response
                switch choice
                    case 'YES'
                        checkfilename = 0;
                    case 'NO, type in another filename'
                        checkfilename = 1;
                        continue
                    otherwise
                        checkfilename = 1;
                        continue
                end
            end  
            
            % save .mat file              
            save(filename, 'LMK_measurements');
            text = '.mat has been saved!';
            set(handles.singlePicInfo, 'String', text);
            disp(text);
            drawnow;

            % save protocol
            disp(['val_prot: ', num2str(val_prot)])
            if val_prot == 1
                text = LMK_saveProtocol(filename);
                set(handles.singlePicInfo, 'String' , text);
                disp(text);
                drawnow;
            end
            
            % write .xml & .dtd file to target directory for data evaluation
            if evalin('base', 'exist(''rect'')') == 1
                % create LMK_image_Metadata object
                evaluatedData = LMK_Image_Metadata();                
                evaluatedData.sceneTitle = get( handles.title, 'String' );
                evaluatedData.focalLength = str2double( get( handles.FL, 'String' ) );
                evaluatedData.dataSRCMat = [file_name, '.mat'];
                evaluatedData.dataTypeMat = '.mat';
                evaluatedData.rect = evalin('base', 'rect');
                relativePosition = str2double( get( handles.position, 'String' ) );
                evaluatedData.rectPosition = relativePosition;
                evaluatedData.border = str2num( get( handles.borderEdit, 'String' ) );
                evaluatedData.dataImagePhotopic = dataImage.YL;
                evaluatedData.dataImageScotopic = dataImage.LS;
                evaluatedData.comments = get(handles.commentsEdit, 'String');
                evaluatedData.lightSource = get(handles.lightSourceEdit, 'String' );
                evaluatedData.viewPointDistance = str2double( get( handles.distance, 'String' ) );
                evaluatedData.targetSize = str2double( get( handles.targetSize, 'String' ) );
                evaluatedData.SPRatio = str2double( get( handles.SPRatio, 'String' )  );
                evaluatedData.numPoleFields = str2num( get( handles.NumPoleFields, 'String' ) );
                
                % write .dtd file
                dtd_path = [dir_name, '\', evaluatedData.Name, '.dtd'];
                if ~exist(dtd_path, 'file')
                    writeDTD(evaluatedData.Name, dir_name);
                end
                % write .xml file
                LMK_saveXMLData(evaluatedData, dir_name);
                assignin('base', 'evaluatedData', evaluatedData);
            end   
        else
            checkfilename = 0;
        end
    end
end


% --------------------------------------------------------------------
%function evaluate_menue_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function analyze_data_menue_Callback(hObject, eventdata, handles)
disp('analyzing')

% --------------------------------------------------------------------
function exit_menue_Callback(hObject, eventdata, handles)
global path
% ask user with predefined question dialog
user_response = questdlg('Close LMK menu and terminate connection?',...
    'Close Request Function',...
    'Yes','No','No');
switch user_response
    case {'No'}
        % take no action
    case 'Yes'
        % Prepare to close GUI application window
        border = str2num(get(handles.borderEdit, 'String'));
        position1 = str2double(get(handles.distance, 'String'));
        fieldLength = str2double(get(handles.fieldLength, 'String'));
        save([path, '\preferences.mat'], 'border', 'position1', 'fieldLength', '-append');
        guidata(hObject, handles);
        pause(1);
        % close application
        [~] = LMK_terminateApp();
        pause(1);
        % close this figure
        delete(handles.figure1)
end


% --- Executes on selection change in showModeMenue.
%function showModeMenue_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function showModeMenue_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in measureButton.
function measureButton_Callback(hObject, eventdata, handles)
global path COLOR_MAP drMaxTime drMinTime himage

COLOR_MAP = get( gcf, 'Colormap');
set(handles.singlePicInfo, 'String', '');

% take camera image:
[text, cameraImage] = LMK_grab();
assignin('base', 'cameraImage', cameraImage);
himage = imshow(cameraImage, 'parent', handles.measAxes, 'DisplayRange', []);
colormap('gray'); % instrument captures black and white camera images
set(handles.singlePicInfo, 'String', text);
[lastInfo, lastInfoName] = LMK_getLastInfo;
assignin('base', 'lastInfo', lastInfo);
set(handles.lastInfoText, 'String', lastInfoName);
set(handles.lastCaptureText, 'String', lastInfo);

% auto scan time?
if (get(handles.autoScanTimeBox,'Value') == ...
        get(handles.autoScanTimeBox,'Max'))
    text = LMK_autoScanTime();
    set(handles.singlePicInfo, 'String', text);
    pause(0.1);
    [dIntegrationTime, drMinTime, drMaxTime] = LMK_getIntegrationTime();
else
    dIntegrationTime = str2double(get(handles.integrationTime,'String'));
    drMinTime = str2double(get(handles.minTime,'String'));
    drMaxTime = str2double(get(handles.maxTime,'String'));
    save([path, '\preferences.mat'], 'drMinTime', 'drMaxTime', '-append');
end
iSmear = str2double(get(handles.smearCorrection,'String'));
dModFrequency = str2double(get(handles.modulationFrequency,'String'));

% take high dyn picture (only VL or VL&VS)
set(handles.singlePicInfo, 'String', 'Capturing...');
pause(0.1);
val = get(handles.picturePopupmenu,'Value')
if val == 1 || val == 2
    disp('huhu')
    for i = 1 : val
       dFactor = str2double( get( handles.factor, 'String' ) );
       LMK_setFilterWheel( i+3 ); 
       [ dump, filterName ] = LMK_getFilterWheel;
       set( handles.singlePicInfo, 'String', [ 'Capturing with filter  ', filterName, '...' ] );
       drawnow;
       message = LMK_highDynPic( drMinTime, drMaxTime, dFactor, iSmear, dModFrequency );
       set( handles.singlePicInfo, 'String', message );
       drawnow;
       [ lastInfo, dump ] = LMK_getLastInfo( );

       % save image temporarily
        file_name = '_meas';
        date_time = lastInfo{ 10 };
        val_date = 0;
        picformat = '.pf';    
        dir_name = [path, '\Temp'];    
        [ message2, filepath ] = LMK_saveImage( dir_name, file_name, val_date, date_time,...
            picformat );
        set( handles.singlePicInfo, 'String', message2 );
        drawnow;

        % read image into array:
        highDyn = LMK_readPfImage( filepath );
        highDynXYZL( :, :, i*2 ) = highDyn;        
    end
end
if val == 1 %only VL
    highDynXYZL( :, :, 4 ) = zeros; %no VS pic
end

if val == 3 % high dyn pics
    dFactor = str2double(get(handles.factor, 'String'));
    
    % capture 5 images = for filter X1, X2, Z, VL, VS:
    %highDynImage( :, :, 1:5 ) = zeros;
    for i = 1 : 5
        % set filter wheel X1...VS:
        LMK_setFilterWheel(i);
        [~, filterName] = LMK_getFilterWheel;
        set(handles.singlePicInfo, 'String', ['Capturing with filter  ', filterName, '...']);
        drawnow;
        
        % take high dyn picture for current filter wheel:
        text = LMK_highDynPic(drMinTime, drMaxTime, dFactor, iSmear, dModFrequency);
        set(handles.singlePicInfo, 'String', text);
        drawnow;
        [lastInfo, ~] = LMK_getLastInfo();
        
        % save image temporarily
        dir_name = [path, '\Temp'];
        switch i
            case 1
                file_name = '_x1';
            case 2
                file_name = '_x2';
            case 3
                file_name = '_z';
            case 4
                file_name = '_vl';
            case 5
                file_name = '_vs';
        end
        date_time = lastInfo{10};
        val_date = 0;
        picformat = '.pf'; 
        [text, filepath] = LMK_saveImage(dir_name, file_name, val_date, date_time,...
            picformat);
        set(handles.singlePicInfo, 'String', text);
        drawnow;
        
        % read image into array:
        highDyn = LMK_readPfImage(filepath);
        highDynImage(:,:,i) = highDyn;
    end
    
    % filter correction:
    highDynXYZL = LMK_highDynFilterCorrection(highDynImage);
    % highDynXYZL is only 4-dimensional (:, :, 1-4);
    
    % load filter corrected images into labSoft:
    for j = 1 : 4
        switch j
            case 1
                slide = 'X';
                LMK_newLabSoftSlide(slide);
                imageTemp = highDynXYZL(:, :, j);
            case 2
                slide = 'Z';
                LMK_newLabSoftSlide(slide);
                imageTemp = highDynXYZL(:, :, j+1);
            case 3
                slide = 'LS';
                LMK_newLabSoftSlide(slide);
                imageTemp = highDynXYZL(:, :, j+1);
            case 4
                slide = 'Leuchtdichtebild'; %must be the last one to load
                imageTemp = highDynXYZL(:, :, j-2);
        end
        LMK_writePfImage(dir_name, imageTemp);
        pf_path = [dir_name, '\tempImage.pf'];
        LMK_loadImageIntoSlide(pf_path, slide);
        LMK_executeMenuPoint('Bildansicht|Palette|Lmk1');
    end
end


% get infos:
[lastInfo, lastInfoName] = LMK_getLastInfo();
if val == 3
    lastInfo{2} = 'HighDyn for each filter position';
    lastInfo{4} = 'X1 X2 Z VL VS';
end
assignin('base', 'lastInfo', lastInfo);
set(handles.lastInfoText, 'String', lastInfoName);
set(handles.lastCaptureText, 'String', lastInfo);
drawnow;


% save image temporarily (luminance and color pics only):
str = get(handles.lastCaptureText, 'String');
date_time = str{10};

% show image in gui
set( handles.text46, 'Visible', 'on' );
set( handles.text47, 'Visible', 'on' );
set( handles.coloreditorButton, 'Visible', 'on' );
set( handles.colorbarMax, 'Visible', 'on' );
set( handles.colorbarMin, 'Visible', 'on' );
if val == 1 || 2
    set(handles.colorspacePopupmenu, 'Visible', 'off');
    set(handles.highDynColorPopupmenu, 'Visible', 'off');
    highDynImageYL = highDynXYZL(:, :, 2);
    assignin('base', 'highDynImageXYZL', highDynXYZL);
    himage = imshow(highDynImageYL, []);
    COLOR_MAP = 'jet';
    colormap(COLOR_MAP);
    colorbar('location', 'eastoutside');
    set(handles.colorbarMax, 'String', num2str(max(max(highDynImageYL))));
    set(handles.colorbarMin, 'String', num2str(min(min(highDynImageYL))));
    set(handles.singlePicInfo, 'String', 'Showing Y / photopic luminance dimension of the image.');
    set( handles.highDynMesPopupmenu, 'Visible' , 'off' );
    set( handles.highDynLumPopupmenu, 'Visible' , 'on' );
    set( handles.highDynLumPopupmenu, 'Enable' , 'inactive' );
end  
if val == 2
    set( handles.highDynLumPopupmenu, 'Enable' , 'on' );
end
if val == 3
    % to do: calc mesopic luminance in class (make obj before)!!!!
    % calc mesopic lumaninance picture: 
    set(handles.singlePicInfo, 'String', 'Calculating...');
    drawnow;
    set(handles.colorspacePopupmenu, 'Visible', 'off');
    Lp = highDynXYZL(:, :, 2);
    Ls = highDynXYZL(:, :, 4);
    [Lmes, imgVisualization] = mesopicLuminance_recommended(Lp, Ls);
    assignin('base', 'Lmes', Lmes);
    assignin('base', 'imgVisualization', imgVisualization);
    set(handles.highDynColorPopupmenu, 'Visible', 'off');
    set(handles.highDynMesPopupmenu, 'Visible', 'on');
    set(handles.highDynMesPopupmenu, 'Value', 5);
    set(handles.singlePicInfo, 'String', 'Mesopic Luminance has been calculated.');
    drawnow;
    % show photopic luminance picture at first in GUI:
    highDynImageYL = highDynXYZL(:, :, 2);
    assignin('base', 'highDynImageXYZL', highDynXYZL);
    himage = imshow(highDynImageYL, []);
    colormap(COLOR_MAP);
    colorbar('location', 'eastoutside');
    set(handles.colorbarMax, 'String', num2str(max(max(highDynImageYL))));
    set(handles.colorbarMin, 'String', num2str(min(min(highDynImageYL))));
    set( handles.highDynMesPopupmenu, 'Visible' , 'on' );
    set( handles.highDynMesPopupmenu, 'Enable' , 'on' );
    set( handles.highDynLumPopupmenu, 'Visible' , 'off' );
    set(handles.highDynMesPopupmenu, 'Value', 2);
    set(handles.singlePicInfo, 'String', 'Showing Y / photopic luminance dimension of the image.');
end

%create LMK_Measurement object:
measurementMetaDataS = evalin('base', 'lastInfo');
for i = 1 : 9
    measurementMetaData{i} = measurementMetaDataS{i};
end
measurementMetaData{10} = measurementMetaDataS{11};
measurementMetaData{11} = measurementMetaDataS{12};

dataImage.X = highDynXYZL(:, :, 1);
dataImage.YL = highDynXYZL(:, :, 2); % Y = L
dataImage.Z = highDynXYZL(:, :, 3);
dataImage.LS = highDynXYZL(:, :, 4);

LMK_measurements = LMK_Measurement(date_time, cameraImage, ...
    dataImage, measurementMetaData);
imageNames = properties(LMK_measurements.measurementMetaData);
LMK_measurements.comments = get(handles.commentsEdit, 'String');
LMK_measurements.lightSource = get(handles.lightSourceEdit, 'String');
save([path, '\Temp\measurements'], 'LMK_measurements');


%function integrationTime_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function integrationTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function smearCorrection_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function smearCorrection_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function modulationFrequency_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function modulationFrequency_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autoScanTimeBox.
function autoScanTimeBox_Callback(hObject, eventdata, handles)
global drMaxTime drMinTime
if get(handles.autoScanTimeBox, 'Value') == ...
        get(handles.autoScanTimeBox, 'Max');
    set(handles.integrationTime, 'String', 'auto');
    set(handles.integrationTime, 'Enable', 'off');
    val = get(handles.picturePopupmenu, 'Value');
    if val == 2 || 3
        set(handles.maxTime, 'String', 'auto');
        set(handles.maxTime, 'Enable', 'off');
        set(handles.minTime, 'String', 'auto');
        set(handles.minTime, 'Enable', 'off');
    end
end

if get(handles.autoScanTimeBox, 'Value') == ...
        get(handles.autoScanTimeBox, 'Min');
    val = get(handles.picturePopupmenu, 'Value');
    set(handles.integrationTime, 'String', ' ');
    set(handles.integrationTime, 'Enable', 'on');
    if val == 2 || 3
        set(handles.maxTime, 'String', drMaxTime);
        set(handles.maxTime, 'Enable', 'on');
        set(handles.minTime, 'String', drMinTime);
        set(handles.minTime, 'Enable', 'on');
    end
    
end


% --- Executes on button press in smearCorrectionBox.
function smearCorrectionBox_Callback(hObject, eventdata, handles)
if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.smearCorrection, 'String', '0');
end


% --- Executes on button press in modulationFrequencyBox.
function modulationFrequencyBox_Callback(hObject, eventdata, handles)
if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.modulationFrequency, 'String', '0');
end


% --- Executes on button press in grabButton = 'Show preview'-Button.
function grabButton_Callback(hObject, eventdata, handles)
global himage
[text, cameraImage] = LMK_grab();
himage = imshow(cameraImage, 'parent', handles.measAxes, 'DisplayRange', []);
colormap('gray');
set(handles.singlePicInfo, 'String', text);
[lastInfo, lastInfoName] = LMK_getLastInfo;
set(handles.lastInfoText, 'String', lastInfoName);
set(handles.lastCaptureText, 'String', lastInfo);


% --- Executes on selection change in filterWheelPopupmenu.
function filterWheelPopupmenu_Callback(hObject, eventdata, handles)
filterPosition = get(hObject,'Value');
filterPosition = (filterPosition-1);
LMK_setFilterWheel(filterPosition);
[~, filterName] = LMK_getFilterWheel;
set(handles.singlePicInfo, 'String', ['current Filter: ', filterName]);


% --- Executes during object creation, after setting all properties.
function filterWheelPopupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in picturePopupmenu.
function picturePopupmenu_Callback(hObject, eventdata, handles)
val = get( handles.picturePopupmenu, 'Value' );
if  val == 1 || 2 || 3
    set(handles.integrationTime, 'Visible', 'off');
    set(handles.staticMaxText, 'Visible', 'on');
    set(handles.maxTime, 'Visible', 'on');
    set(handles.staticMinText, 'Visible', 'on');
    set(handles.minTime, 'Visible', 'on');
    set(handles.staticFactorText, 'Visible', 'on');
    set(handles.factor, 'Visible', 'on');
    set(handles.filterWheelPopupmenu, 'Visible', 'off');
    set(handles.staticWheelText, 'Visible', 'off');
end

if val == 4 % currently not in use
    set(handles.integrationTime, 'Visible', 'on');
    set(handles.staticMaxText, 'Visible', 'off');
    set(handles.maxTime, 'Visible', 'off');
    set(handles.staticMinText, 'Visible', 'off');
    set(handles.minTime, 'Visible', 'off');
    set(handles.staticFactorText, 'Visible', 'off');
    set(handles.factor, 'Visible', 'off');
    set(handles.filterWheelPopupmenu, 'Visible', 'on');
    set(handles.staticWheelText, 'Visible', 'on');
    [filterposition, ~] = LMK_getFilterWheel;
    set(handles.filterWheelPopupmenu, 'Value', filterposition+1);
end

if val == 5 % currently not in use
    set(handles.integrationTime, 'Visible', 'off');
    set(handles.staticMaxText, 'Visible', 'on');
    set(handles.maxTime, 'Visible', 'on');
    set(handles.staticMinText, 'Visible', 'on');
    set(handles.minTime, 'Visible', 'on');
    set(handles.staticFactorText, 'Visible', 'on');
    set(handles.factor, 'Visible', 'on');
    set(handles.filterWheelPopupmenu, 'Visible', 'off');
    set(handles.staticWheelText, 'Visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function picturePopupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
global COLOR_MAP himage
[filename, pathname] = uigetfile('start_pfad', 'dialog_titel');
dir_name = [pathname, filename];
luminanceImage = LMK_readPfImage(dir_name);
himage = imshow(luminanceImage, []);
colormap(COLOR_MAP);
set(handles.colorspacePopupmenu, 'Visible', 'off');


% --- Executes on button press in loadPcfButton.
function loadPcfButton_Callback(hObject, eventdata, handles)
global himage
[filename, pathname] = uigetfile('start_pfad', 'dialog_titel');
dir_name = [pathname, filename];
[colorImageRGB, colorImageBGR, columns, lines] = LMK_readPcfImage(dir_name);
colorImageXYZ = LMK_RGBtoXYZ(colorImageRGB, colorImageBGR, columns, lines);
assignin('base', 'colorImageBGR', colorImageBGR);
assignin('base', 'colorImageRGB', colorImageRGB);
assignin('base', 'colorImageXYZ', colorImageXYZ);
assignin('base', 'columns', columns);
assignin('base', 'lines', lines);
himage = imshow(colorImageRGB, 'parent', handles.measAxes, 'DisplayRange', [ ]);
set(handles.colorspacePopupmenu, 'Visible', 'on');


%function maxTime_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function maxTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function minTime_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function minTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function factor_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function factor_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in colorspacePopupmenu.
function colorspacePopupmenu_Callback(hObject, eventdata, handles)
global COLOR_MAP himage
val = get(handles.colorspacePopupmenu, 'Value');
colorImageRGB = evalin('base', 'colorImageRGB');
colorImageXYZ = evalin('base', 'colorImageXYZ');
switch val
    case 1
        himage = imshow(colorImageRGB, 'parent', handles.measAxes, 'DisplayRange', [ ]);
    case 2
        himage = imshow(colorImageXYZ, 'parent', handles.measAxes, 'DisplayRange', [ ]);
    case 3
        colorImageX = colorImageXYZ(:, :, 1);
        himage = imshow(colorImageX, 'parent', handles.measAxes, 'DisplayRange', [ ]);
        colormap(COLOR_MAP);
    case 4
        colorImageY = colorImageXYZ(:, :, 2);
        himage = imshow(colorImageY, 'parent', handles.measAxes, 'DisplayRange', [ ]);
        colormap(COLOR_MAP);
    case 5
        colorImageZ = colorImageXYZ(:, :, 2);
        himage = imshow(colorImageZ, 'parent', handles.measAxes, 'DisplayRange', [ ]);
        colormap(COLOR_MAP);
    otherwise
        disp('error showing color space');
end


% --- Executes during object creation, after setting all properties.
function colorspacePopupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function commentsEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function commentsEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function lightSourceEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function lightSourceEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in highDynColorPopupmenu.
function highDynColorPopupmenu_Callback(hObject, eventdata, handles)
global COLOR_MAP himage
highDynImageXYZL = evalin('base', 'highDynImageXYZL');
val_high = get(handles.highDynColorPopupmenu, 'Value');
switch val_high
    case 1
        highDynImageX = highDynImageXYZL(:, :, 1);
        himage = imshow(highDynImageX, []);
    case 2
        highDynImageYL = highDynImageXYZL(:, :, 2);
        himage = imshow(highDynImageYL, []);
    case 3
        highDynImageZ = highDynImageXYZL(:, :, 3);
        himage = imshow(highDynImageZ, []);
    case 4
        highDynImageLS = highDynImageXYZL(:, :, 4);
        himage = imshow(highDynImageLS, []);
    otherwise
        disp('error');
end
colormap(COLOR_MAP);
colorbar('location', 'eastoutside');



% --- Executes during object creation, after setting all properties.
function highDynColorPopupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on highDynColorPopupmenu and none of its controls.
%function highDynColorPopupmenu_KeyPressFcn(hObject, eventdata, handles)


% --- Executes on button press in helpButton.
function helpButton_Callback(hObject, eventdata, handles)
pic_val = get(handles.picturePopupmenu, 'Value');
switch pic_val
    case 1
        helpstring = ['Chose  "Luminance picture" and the programm will ',...
            'first make a camera picture and then a single ',...
            'luminance picture with the filter wheel ',...
            'which is chosen. You can type in the integration time ',...
            'or set automatic integration time.'];
    case 2
        helpstring = ['Chose "Color picture" and the programm will first ',...
            'make a camera picture and then a high dyn color picture ',...
            'where every filter wheel is used. You can type in minimum ',...
            'and maxiumum integration times and the factor between to ',...
            'times or set automatic integration time. After that you can ',...
            'chose between color spaces RGB and XYZ.'];
    case 3
        helpstring = ['Chose "X1, X2, Z, VL & VS High dyn picture" and the ',...
            'programm will first make a camera picture and then a ',...
            'single high dyn picture with filter ',...
            'wheels X1, X2, Z, VL & VS. You can type in minimum ',...
            'and maxiumum integration times and the factor between to ',...
            'times or set automatic integration time.',...
            'Then the programm will evaluate the X, Y, Z, L, LS ',...
            'parameters of the picture.'];
end
dlgname = 'Measurement help';
helpdlg(helpstring, dlgname);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
global path
user_response = questdlg('Close LMK menu and terminate connection?',...
    'Close Request Function',...
    'Yes','No','No');
switch user_response
    case {'No'}
        % take no action
    case 'Yes'
        % Prepare to close GUI application window
        border = str2num(get(handles.borderEdit, 'String'));
        position1 = str2double(get(handles.distance, 'String'));
        fieldLength = str2double(get(handles.fieldLength, 'String'));
        save([path, '\preferences.mat'], 'border', 'position1', 'fieldLength', '-append');
        %guidata(hObject, handles);
        pause(1);
        [~] = LMK_terminateApp();
        pause(1);
        delete(handles.figure1)
end


% --- Executes on button press in rectangleButton.
function rectangleButton_Callback(hObject, eventdata, handles)
global himage hrect
% delete old rectangles:
set(handles.singlePicInfo, 'String', ' ');
set( handles.text50, 'Visible', 'off' );
set( handles.text51, 'Visible', 'off' );
set( handles.rectLength, 'String', '' );
set( handles.rectHeight, 'String', '' );
b = get(handles.measAxes,'Children');
if length(b) > 1
    for i = 1 : length(b)
        if b(i) ~= himage
            delete(b(i));
        end
    end
end
set(handles.singlePicInfo, 'String', ' ');
% create draggable recangle:
hrectangle = imrect;
set(handles.singlePicInfo, 'String', 'Double click inside the rectangle to finish selection.');
% get position of rectangle:
accepted_pos = wait(hrectangle); % waits until user double clicks inside the rectangle
accepted_pos = round(accepted_pos);
% draw static rectangle:
delete(hrectangle);
%warning off last;
if ~isempty(accepted_pos)
    hrect = rectangle('position', accepted_pos);
    point1 = struct('x',accepted_pos(1),'y',accepted_pos(2));
    point2 = struct('x',accepted_pos(1) + accepted_pos(3),'y',accepted_pos(2) + accepted_pos(4));
    rect = struct('upperLeft',point1,'lowerRight',point2);
    assignin('base', 'rect', rect);
    set(handles.singlePicInfo, 'String', 'Save picture and the rectangle position will be saved, too. ');
    set( handles.text50, 'Visible', 'on' );
    set( handles.rectLength, 'String', accepted_pos( 3 ) );
    set( handles.text51, 'Visible', 'on' );
    set( handles.rectHeight, 'String', accepted_pos( 4 ) );
end


% --- Executes on button press in deleteRectangleButton.
function deleteRectangleButton_Callback(hObject, eventdata, handles)
global himage
b = get(handles.measAxes,'Children');
if length(b) > 1
    for i = 1 : length(b)
        if b(i) ~= himage
            delete(b(i));
        end
    end
    if evalin('base', 'exist(''rect'')') == 1
        evalin('base', 'clear rect');
    end
end
set(handles.singlePicInfo, 'String', ' ');
set( handles.text50, 'Visible', 'off' );
set( handles.text51, 'Visible', 'off' );
set( handles.rectLength, 'String', '' );
set( handles.rectHeight, 'String', '' );


function measurementNameEdit_Callback(hObject, eventdata, handles)
series_name = get(handles.measurementNameEdit,'String');
assignin('base', 'series_name', series_name);


% --- Executes during object creation, after setting all properties.
function measurementNameEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function positionPopup_Callback(hObject, eventdata, handles)
% get current position:
position1 = str2double(get(handles.distance, 'String'));
fieldLength = str2double(get(handles.fieldLength, 'String'));
% currentPosition = LMK_calcPosition(position1, fieldLength);
measPoints = str2double( get( handles.measPoints, 'String' ) );
diff = fieldLength / measPoints;
positionContents = cellstr(get(handles.positionPopup, 'String'));                
rectPosition = str2double(positionContents{get(handles.positionPopup, 'Value')});
if rectPosition < 0
    currentPosition = position1 + (round((diff * rectPosition + diff/2)*100)/100);
else
    currentPosition = position1 + (round((diff * rectPosition - diff/2)*100)/100);
end
set( handles.currentPositionText, 'String', num2str( currentPosition ) );
distance = str2double( get( handles.distance, 'String' ) );
relativePosition = currentPosition - distance;
set( handles.position, 'String', num2str( relativePosition ) );



% --- Executes during object creation, after setting all properties.
function positionPopup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function borderEdit_Callback(hObject, eventdata, handles)
global himage hrect
border = str2double(get(handles.borderEdit, 'String'));
if evalin('base', 'exist(''rect'')')    
    % delete old rectangles:
    b = get(handles.measAxes,'Children');
    if length(b) > 1
        for i = 1 : length(b)
            if b(i) ~= himage && b(i) ~= hrect
                delete(b(i));
            end
        end
    end
    % draw new border rectangle:
    rect = evalin('base', 'rect');   
    x = rect.upperLeft.x - border;
    y = rect.upperLeft.y - border;
    w = (rect.lowerRight.x - rect.upperLeft.x) + 2*border;
    h = (rect.lowerRight.y - rect.upperLeft.y) + 2*border;
    rectangle('position', [x y w h]);
end



% --- Executes during object creation, after setting all properties.
function borderEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in highDynMesPopupmenu.
function highDynMesPopupmenu_Callback(hObject, eventdata, handles)
global COLOR_MAP himage counter
highDynImageXYZL = evalin('base', 'highDynImageXYZL');
val_high = get(handles.highDynMesPopupmenu, 'Value');
counter = 1;
switch val_high
    case 1
        highDynImage = highDynImageXYZL(:, :, 1);        
        set(handles.singlePicInfo, 'String', 'Showing X dimension of the image.');
    case 2
        highDynImage = highDynImageXYZL(:, :, 2);
        set(handles.singlePicInfo, 'String', 'Showing Y / photopic luminance dimension of the image.');
    case 3
        highDynImage = highDynImageXYZL(:, :, 3);
        set(handles.singlePicInfo, 'String', 'Showing Z dimension of the image.');
    case 4
        highDynImage = highDynImageXYZL(:, :, 4);
        set(handles.singlePicInfo, 'String', 'Showing scotopic luminance dimension of the image.');
    case 5        
        Lmes = evalin('base', 'Lmes');
        highDynImage = Lmes;
        set(handles.singlePicInfo, 'String', 'Showing mesopic luminance dimension of the image.');
    case 6
        COLOR_MAP = [1.0,0,0;0,1.0,0;0,0,1.0];
        imgVisualization = evalin('base', 'imgVisualization');
        highDynImage = imgVisualization;
        colorbar('YTick',[1;2;3],'YTickLabel',...
            {'Photopic','Mesopic','Scotopic'});
        set(handles.singlePicInfo, 'String', 'Showing luminance levels of the image.');
end
himage = imshow(highDynImage, []);
colormap(COLOR_MAP);
colorbar('location', 'eastoutside');
set(handles.colorbarMin, 'String', num2str(min(min(highDynImage))));
set(handles.colorbarMax, 'String', num2str(max(max(highDynImage))));
COLOR_MAP = 'jet';
if evalin('base', 'exist(''rect'')') == 1
    rect = evalin('base', 'rect');
    x = rect.upperLeft.x;
    y = rect.upperLeft.y;
    w = rect.lowerRight.x - rect.upperLeft.x;
    h = rect.lowerRight.y - rect.upperLeft.y;
    rectangle('position', [x,y,w,h]);
end


% --- Executes during object creation, after setting all properties.
function highDynMesPopupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
%function evaluate_menu_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function analyze_data_menu_Callback(hObject, eventdata, handles)
disp('analyzing')
if evalin('base', 'exist(''series_name'')') == 1
    filename = evalin('base', 'series_name');
else
    filename = 'LMKSet';
end
dir_name = evalin('base', 'dir_name');
evaluateDatasetHack(filename,dir_name);


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% get infos of the last capture
str = get(handles.lastCaptureText, 'String');

% check if there is data to save
if isempty(str)
    % helpdialog when there is no data to save, nothing will be saved
    helpdlg(['Sorry, no data to save. Please first make a ',...
        'measurement before you save.'], 'No data!'),
else
    % get date and time of the last measurement
    date_time = str{10};
    series_name = 'LMKSetMat';
    % check whether file already exists      
        file_name = [series_name, '_', get(handles.currentPositionText, 'String'), 'm'];
        assignin('base', 'file_name', file_name);
            
        % get target directory with LMK_savefig GUI
    checkfilename = 1;
    while checkfilename == 1 
        LMK_saveFig;
        uiwait(LMK_saveFig);
        has_cancelled = evalin('base', 'has_cancelled');
        dir_name = evalin('base', 'dir_name');
        % save only when user has not cancelled saving
        if has_cancelled == 0
            % get the value whether to save protocoll, too
            val_prot = evalin('base', 'val_prot');
            % get camera image and file name from workspace
            cameraImage = evalin('base', 'cameraImage');
            file_name = evalin('base', 'file_name');
            % check image
            highDynImageXYZL = evalin('base', 'highDynImageXYZL');
            % get relevant image data
            measurementMetaDataS = evalin('base', 'lastInfo');
            for i = 1 : 9
                measurementMetaData{i} = measurementMetaDataS{i};
            end
            measurementMetaData{10} = measurementMetaDataS{11};
            measurementMetaData{11} = measurementMetaDataS{12};
            
            % convert image matrices into structs
            dataImage.X = highDynImageXYZL(:, :, 1);
            dataImage.YL = highDynImageXYZL(:, :, 2); % Y = L
            dataImage.Z = highDynImageXYZL(:, :, 3);
            dataImage.LS = highDynImageXYZL(:, :, 4);

            %create LMK_Measurement object:
            LMK_measurements = LMK_Measurement(date_time, cameraImage, ...
                dataImage, measurementMetaData);
            imageNames = properties(LMK_measurements.measurementMetaData);            
            LMK_measurements.comments = get(handles.commentsEdit, 'String');
            LMK_measurements.lightSource = get(handles.lightSourceEdit, 'String');
            
            
            
            % check file name
            filename = [dir_name, '\', file_name];
               
                if ~exist([filename, '.mat'], 'file')   
                    disp('file does not exist');
                    checkfilename = 0;                
                else

                    % handle case if file already exists in target directory
                    disp('Sorry, file already exists');
                    % Construct a questdlg with two options
                    choice = questdlg('File already exists. Overwrite?', ...
                        'Save Menu', ...
                        'YES','NO, type in another filename', 'NO, type in another filename');
                        % Handle response
                        switch choice
                            case 'YES'
                                checkfilename = 0;
                            case 'NO, type in another filename'
                                checkfilename = 1;
                                continue
                            otherwise
                                checkfilename = 1;
                                continue
                        end 
                end
            % save .mat file              
            save([filename, '.mat'], 'LMK_measurements')
            text = '.mat has been saved!';
            set(handles.singlePicInfo, 'String', text);
            disp(text);
            drawnow;

            % save protocol
            if val_prot == 1
                text = LMK_saveProtocol(filename);
                set(handles.singlePicInfo, 'String' , text);
                disp(text);
                drawnow;
            end
            
            % write .xml & .dtd file to target directory for data
            % evaluation
            if evalin('base', 'exist(''rect'')') == 1
                % create LMK_image_Metadata object
                evaluatedData = LMK_Image_Metadata();                
                evaluatedData.sceneTitle = get( handles.title, 'String' );
                evaluatedData.focalLength = str2double( get( handles.FL, 'String' ) );
                evaluatedData.dataSRCMat = [file_name, '.mat'];
                evaluatedData.dataTypeMat = '.mat';
                evaluatedData.rect = evalin('base', 'rect'); 
                evaluatedData.rectPosition = str2double( get( handles.position, 'String' ) );
                evaluatedData.border = str2num( get( handles.borderEdit, 'String' ) );
                evaluatedData.dataImagePhotopic = dataImage.YL;
                evaluatedData.dataImageScotopic = dataImage.LS;
                evaluatedData.comments = get(handles.commentsEdit, 'String');
                evaluatedData.lightSource = get(handles.lightSourceEdit, 'String' );
                evaluatedData.viewPointDistance = str2double( get( handles.distance, 'String' ) );
                evaluatedData.targetSize = str2double( get( handles.targetSize, 'String' ) );
                evaluatedData.SPRatio = str2double( get( handles.SPRatio, 'String' )  );
                evaluatedData.numPoleFields = str2num( get( handles.NumPoleFields, 'String' ) );

                % write .dtd file
                dtd_path = [dir_name, '\', 'LMKSetMat', '.dtd'];
                if ~exist(dtd_path, 'file')
                    writeDTD('LMKSetMat', dir_name);
                end
                % write .xml file
                LMK_saveXMLData(evaluatedData, dir_name);
                assignin('base', 'evaluatedData', evaluatedData);
                text = 'XML file has been saved.';

            else
                text = 'Sorry, there is no rectangle. No LMKData saved to XML file!';                
            end   
            set(handles.singlePicInfo, 'String' , text);
            disp(text);
            drawnow;

            % set next value for position popupmenu:
            pos_val = get(handles.positionPopup, 'Value');
            set(handles.positionPopup, 'Value', pos_val + 1);
            position1 = str2double(get(handles.distance, 'String'));
            fieldLength = str2double(get(handles.fieldLength, 'String'));
%             currentPosition = LMK_calcPosition(position1, fieldLength);
            measPoints = str2double( get( handles.measPoints, 'String' ) );
            diff = fieldLength / measPoints;
            positionContents = cellstr(get(handles.positionPopup, 'String'));                
            rectPosition = str2double(positionContents{get(handles.positionPopup, 'Value')});
            if rectPosition < 0
                currentPosition = position1 + (round((diff * rectPosition + diff/2)*100)/100);
            else
                currentPosition = position1 + (round((diff * rectPosition - diff/2)*100)/100);
            end
            set( handles.currentPositionText, 'String', num2str( currentPosition ) );  
            distance = str2double( get( handles.distance, 'String' ) );
            relativePosition = currentPosition - distance;
            set( handles.position, 'String', num2str( relativePosition ) );
            
            % add new information string for status text:    
            status_str = cellstr(get(handles.saveStatus, 'String'));
            n = length(status_str);
            status_str{n+1} = [datestr(now), ' : File "', file_name, '" has been ',...
                'saved in ', dir_name];
            set(handles.saveStatus, 'String', status_str);
            set(handles.saveStatus, 'ListboxTop', n+1);
        else
            checkfilename = 0;
        end
    end
end


%function saveStatus_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function saveStatus_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function position1_Callback(hObject, eventdata, handles)
% get position of measurement
position1 = str2double(get(handles.distance, 'String'));
fieldLength = str2double(get(handles.fieldLength, 'String'));
% currentPosition = LMK_calcPosition(position1, fieldLength);
measPoints = str2double( get( handles.measPoints, 'String' ) );
diff = fieldLength / measPoints;
positionContents = cellstr(get(handles.positionPopup, 'String'));                
rectPosition = str2double(positionContents{get(handles.positionPopup, 'Value')});
if rectPosition < 0
    currentPosition = position1 + (round((diff * rectPosition + diff/2)*100)/100);
else
    currentPosition = position1 + (round((diff * rectPosition - diff/2)*100)/100);
end
set( handles.currentPositionText, 'String', num2str( currentPosition ));
distance = str2double( get( handles.distance, 'String' ) );
relativePosition = currentPosition - distance;
set( handles.position, 'String', num2str( relativePosition ) );


% --- Executes during object creation, after setting all properties.
function position1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fieldLength_Callback(hObject, eventdata, handles)
position1 = str2double(get(handles.distance, 'String'));
fieldLength = str2double(get(handles.fieldLength, 'String'));
% currentPosition = LMK_calcPosition(position1, fieldLength);
measPoints = str2double( get( handles.measPoints, 'String' ) );
diff = fieldLength / measPoints;
positionContents = cellstr(get(handles.positionPopup, 'String'));                
rectPosition = str2double(positionContents{get(handles.positionPopup, 'Value')});
if rectPosition < 0
    currentPosition = position1 + (round((diff * rectPosition + diff/2)*100)/100);
else
    currentPosition = position1 + (round((diff * rectPosition - diff/2)*100)/100);
end
set( handles.currentPositionText, 'String', num2str( currentPosition ) );
distance = str2double( get( handles.distance, 'String' ) );
relativePosition = currentPosition - distance;
set( handles.position, 'String', num2str( relativePosition ) );


% --- Executes during object creation, after setting all properties.
function fieldLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function FL_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function FL_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function distance_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function distance_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function targetSize_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function targetSize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function SPRatio_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function SPRatio_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function NumPoleFields_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function NumPoleFields_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function title_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function title_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in colorPopup.
%function colorPopup_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function colorPopup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in logPopup.
function logPopup_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
logValue = 2^( str2double( contents{get(hObject,'Value')} ) );
col = hot(64); tmp = linspace(0,1,64)';
for n = 1:3, col(:,n) = interp1( logValue.^tmp, col(:,n), 1+(logValue-1)*tmp, 'linear'); end
colormap(col);

% --- Executes during object creation, after setting all properties.
function logPopup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measPoints_Callback(hObject, eventdata, handles)
position1 = str2double(get(handles.distance, 'String'));
fieldLength = str2double(get(handles.fieldLength, 'String'));
% currentPosition = LMK_calcPosition(position1, fieldLength);
measPoints = str2double( get( handles.measPoints, 'String' ) );
diff = fieldLength / measPoints;
positionContents = cellstr(get(handles.positionPopup, 'String'));                
rectPosition = str2double(positionContents{get(handles.positionPopup, 'Value')});
if rectPosition < 0
    currentPosition = position1 + (round((diff * rectPosition + diff/2)*100)/100);
else
    currentPosition = position1 + (round((diff * rectPosition - diff/2)*100)/100);
end
set( handles.currentPositionText, 'String', num2str( currentPosition ) );
distance = str2double( get( handles.distance, 'String' ) );
relativePosition = currentPosition - distance;
set( handles.position, 'String', num2str( relativePosition ) );


% --- Executes during object creation, after setting all properties.
function measPoints_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function position_Callback(hObject, eventdata, handles)
relativePosition = str2double( get( handles.position , 'String' ) );
position1 = str2double( get( handles.distance, 'String' ) );
currentPosition = position1 + relativePosition;
set( handles.currentPositionText, 'String', num2str( currentPosition ) );


% --- Executes during object creation, after setting all properties.
function position_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in coloreditorButton.
function coloreditorButton_Callback(hObject, eventdata, handles)
global himage counter
im = getimage(himage);
jetmap = colormap(hsv);
newmap = zeros(size(jetmap));
newmap(1:end-counter, :) = jetmap((counter+1):end, :);
newmap(end-counter+1:end, :) = jetmap(1:counter, :);
counter = counter +1;
colorbarMin = get(handles.colorbarMin, 'String');
if isempty(colorbarMin)
    colorbarMin = min(min(im));
else
    colorbarMin = str2double(colorbarMin);
end
colorbarMax = get(handles.colorbarMax, 'String');
if isempty(colorbarMax)
    colorbarMax = min(min(im));
else
    colorbarMax = str2double(colorbarMax);
end    
caxis([colorbarMin colorbarMax])
colormap(newmap); 
colorbar; 



function colorbarMax_Callback(hObject, eventdata, handles)
global himage
im = getimage(himage);
colorbarMin = get(handles.colorbarMin, 'String');
if isempty(colorbarMin)
    colorbarMin = min(min(im));
else
    colorbarMin = str2double(colorbarMin);
end
colorbarMax = get(handles.colorbarMax, 'String');
if isempty(colorbarMax)
    colorbarMax = min(min(im));
else
    colorbarMax = str2double(colorbarMax);
end    
caxis([colorbarMin colorbarMax])


% --- Executes during object creation, after setting all properties.
function colorbarMax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function colorbarMin_Callback(hObject, eventdata, handles)
global himage
colorbarMin = get(handles.colorbarMin, 'String');
if isempty(colorbarMin)
    colorbarMin = min(min(im));
else
    colorbarMin = str2double(colorbarMin);
end
colorbarMax = get(handles.colorbarMax, 'String');
if isempty(colorbarMax)
    colorbarMax = min(min(im));
else
    colorbarMax = str2double(colorbarMax);
end    
caxis([colorbarMin colorbarMax])


% --- Executes during object creation, after setting all properties.
function colorbarMin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in highDynLumPopupmenu.
function highDynLumPopupmenu_Callback(hObject, eventdata, handles)
global COLOR_MAP himage counter
highDynImageXYZL = evalin('base', 'highDynImageXYZL');
val_high = get(handles.highDynLumPopupmenu, 'Value');
counter = 1;
switch val_high
    case 1
        highDynImage = highDynImageXYZL(:, :, 2);        
        set(handles.singlePicInfo, 'String', 'Showing Lp dimension of the image.');
    case 2
        highDynImage = highDynImageXYZL(:, :, 4);
        set(handles.singlePicInfo, 'String', 'Showing Ls dimension of the image.');
end
himage = imshow(highDynImage, []);
colormap(COLOR_MAP);
colorbar('location', 'eastoutside');
set(handles.colorbarMin, 'String', num2str(min(min(highDynImage))));
set(handles.colorbarMax, 'String', num2str(max(max(highDynImage))));
COLOR_MAP = 'jet';
if evalin('base', 'exist(''rect'')') == 1
    rect = evalin('base', 'rect');
    x = rect.upperLeft.x;
    y = rect.upperLeft.y;
    w = rect.lowerRight.x - rect.upperLeft.x;
    h = rect.lowerRight.y - rect.upperLeft.y;
    rectangle('position', [x,y,w,h]);
end


% --- Executes during object creation, after setting all properties.
function highDynLumPopupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
