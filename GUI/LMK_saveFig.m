function varargout = LMK_saveFig(varargin)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% LMK_SAVEFIG M-file for LMK_saveFig.fig
%      LMK_SAVEFIG, by itself, creates a new LMK_SAVEFIG or raises the existing
%      singleton*.
%
% In this GUI the user can save the last measurement by chosing the target
% direcory, file name and whether the labSoft protocol (.ttcs format)
% should be saved, too.

% Last Modified by GUIDE v2.5 16-Dec-2010 13:48:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LMK_saveFig_OpeningFcn, ...
                   'gui_OutputFcn',  @LMK_saveFig_OutputFcn, ...
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


% --- Executes just before LMK_saveFig is made visible.
function LMK_saveFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LMK_saveFig (see VARARGIN)

% Choose default command line output for LMK_saveFig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% use last dir_name if exists:
exdir = evalin('base', 'exist(''dir_name'',''var'')');
if exdir == 0    
    dir_name = pwd;
    assignin('base', 'dir_name', dir_name);    
else
    dir_name = evalin('base', 'dir_name');
end
set(handles.pathText, 'String', dir_name);

% use last file_name if exists:
exfile = evalin('base', 'exist(''file_name'', ''var'')');
if exfile == 0
    file_name = 'measurement01';
    assignin('base', 'file_name', file_name);
else
    file_name = evalin('base', 'file_name');
end
set(handles.filenameText, 'String', file_name);

% pass the value of the protocol checkbox to workspace:
val_prot = get(handles.protocolCheckbox, 'Value');
assignin('base', 'val_prot', val_prot);


% --- Outputs from this function are returned to the command line.
function varargout = LMK_saveFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pathButton.
function pathButton_Callback(hObject, eventdata, handles)
% hObject    handle to pathButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% let the user chose the target directory with uigetdir:
dir_name = uigetdir('start_pfad', 'dialog_titel');
set(handles.pathText, 'String', dir_name);
assignin('base', 'dir_name', dir_name);



function filenameText_Callback(hObject, eventdata, handles)
% hObject    handle to filenameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% pass the user defined file name to workspace
file_name = get(handles.filenameText, 'String');
assignin('base', 'file_name', file_name);


% --- Executes during object creation, after setting all properties.
function filenameText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in protocolCheckbox.
function protocolCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to protocolCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% pass protocol value to workspace 
val_prot = get(handles.protocolCheckbox, 'Value');
assignin('base', 'val_prot', val_prot);

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% pass value to workspace and close this figure
has_cancelled = 0; % 0 = not cancelled, LMK_menu GUI will save measurement
assignin('base', 'has_cancelled', has_cancelled);
close(LMK_saveFig);


% --- Executes on button press in exitButton.
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% pass value to workspace and close this figure
has_cancelled = 1; % 1 = cancelled, LMK_menu GUI will not save measurement
assignin('base', 'has_cancelled', has_cancelled);
close(LMK_saveFig);


% --- Executes on button press in helpSaveButton.
function helpSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to helpSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% show help pop up window with predefined helpdlg
helpstring = ['Your last measurement will we saved in .mat format. Enable ',...
    '"Save LabSoft ttcs Protocol file" to save the LabSoft protocol in .ttcs format.'];
dlgname = 'Save help';
helpdlg(helpstring, dlgname);
