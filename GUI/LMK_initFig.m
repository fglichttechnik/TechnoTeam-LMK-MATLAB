function varargout = LMK_initFig(varargin)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% LMK_INITFIG M-file for LMK_initFig.fig
%      LMK_INITFIG, by itself, creates a new LMK_INITFIG or raises the existing
%      singleton*.
%
% In this GUI the user has to chose the application show-mode and the lens
% path.

% Last Modified by GUIDE v2.5 26-Nov-2010 12:22:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LMK_initFig_OpeningFcn, ...
                   'gui_OutputFcn',  @LMK_initFig_OutputFcn, ...
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


% --- Executes just before LMK_initFig is made visible.
function LMK_initFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LMK_initFig (see VARARGIN)

% Choose default command line output for LMK_initFig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% load preferences (last lens path used)
global path LENS_PATH;
load([path, '\preferences.mat']);
set(handles.lensPathText, 'String', LENS_PATH{2});
set(handles.lensPathPopupmenu, 'String', LENS_PATH);

% UIWAIT makes LMK_initFig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LMK_initFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in showModeMenue.
function showModeMenue_Callback(hObject, eventdata, handles)
% hObject    handle to showModeMenue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns showModeMenue contents as cell array
%        contents{get(hObject,'Value')} returns selected item from showModeMenue


% --- Executes during object creation, after setting all properties.
function showModeMenue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showModeMenue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in KameraStartenButton.
function KameraStartenButton_Callback(hObject, eventdata, handles)
% hObject    handle to KameraStartenButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get application show mode and lens path
val = get(handles.showModeMenue, 'Value');
lenspath = get(handles.lensPathText, 'String');
% initiate application
text = LMK_initApp(val, lenspath);
assignin('base', 'text', text);
% close this figure
close(LMK_initFig);


% --- Executes on selection change in lensPathPopupmenu.
function lensPathPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to lensPathPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path LENS_PATH
% show currently chosen lens path
contents = cellstr(get(hObject,'String'));
lenspath = contents{get(handles.lensPathPopupmenu, 'Value')};
set(handles.lensPathText, 'String', lenspath);

% specify a new lens path with uigetdir
val = get(handles.lensPathPopupmenu, 'Value');
if val == 5
   lenspath = uigetdir('start_pfad', 'dialog_titel');
   set(handles.lensPathText, 'String', lenspath); 
end

% save latest lens pathes in prefences
lenscmp = strcmp(LENS_PATH{2}, lenspath);
if lenscmp ~= 1
    LENS_PATH{4} = LENS_PATH{3};
    LENS_PATH{3} = LENS_PATH{2};
    LENS_PATH{2} = lenspath;
    save([path, '\preferences.mat'], 'LENS_PATH');
end


% --- Executes during object creation, after setting all properties.
function lensPathPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lensPathPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
