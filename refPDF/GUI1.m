function varargout = GUI1(varargin)
% GUI1 MATLAB code for GUI1.fig
%      GUI1, by itself, creates a new GUI1 or raises the existing
%      singleton*.
%
%      H = GUI1 returns the handle to a new GUI1 or the handle to
%      the existing singleton*.
%
%      GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI1.M with the given input arguments.
%
%      GUI1('Property','Value',...) creates a new GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI1

% Last Modified by GUIDE v2.5 26-Nov-2017 08:30:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI1_OutputFcn, ...
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


% --- Executes just before GUI1 is made visible.
function GUI1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI1 (see VARARGIN)

% Choose default command line output for GUI1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ---输入图片cur
function input_button_Callback(hObject, eventdata, handles)
global PAGE;
global imgs;
global PARA;
global CONFIG;
%做一些初始化工作
PAGE =handles.PAGE;
PARA=handles.PARA;
initCONFIG();

%打开图片
[filename, pathname, filterindex] = uigetfile({'*.PNG;*.jpg;*.tif',...
                  'Image Files (*.PNG,*.jpg,*.tif)'},'请选择输入图像 ...','MultiSelect','on');


% --- Executes on button press in perview_button.
function perview_button_Callback(hObject, eventdata, handles)
% hObject    handle to perview_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% 启动参数样本界面输入页面
function para_button_Callback(hObject, eventdata, handles)
GUI2(hObject,handles);%todo等待更新
handles.input_button.Enable ='on';
% --- Executes on button press in url_button.
function url_button_Callback(hObject, eventdata, handles)
% hObject    handle to url_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function gap_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gap_edit as text
%        str2double(get(hObject,'String')) returns contents of gap_edit as a double


% --- Executes during object creation, after setting all properties.
function gap_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in config_ensure_button.
function config_ensure_button_Callback(hObject, eventdata, handles)
% hObject    handle to config_ensure_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function height_edit_Callback(hObject, eventdata, handles)
% hObject    handle to height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height_edit as text
%        str2double(get(hObject,'String')) returns contents of height_edit as a double


% --- Executes during object creation, after setting all properties.
function height_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_edit_Callback(hObject, eventdata, handles)
% hObject    handle to width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_edit as text
%        str2double(get(hObject,'String')) returns contents of width_edit as a double


% --- Executes during object creation, after setting all properties.
function width_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function padding_edit_Callback(hObject, eventdata, handles)
% hObject    handle to padding_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of padding_edit as text
%        str2double(get(hObject,'String')) returns contents of padding_edit as a double


% --- Executes during object creation, after setting all properties.
function padding_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to padding_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function linespacing_edit_Callback(hObject, eventdata, handles)
% hObject    handle to linespacing_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linespacing_edit as text
%        str2double(get(hObject,'String')) returns contents of linespacing_edit as a double


% --- Executes during object creation, after setting all properties.
function linespacing_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linespacing_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_indent_edit_Callback(hObject, eventdata, handles)
% hObject    handle to text_indent_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_indent_edit as text
%        str2double(get(hObject,'String')) returns contents of text_indent_edit as a double


% --- Executes during object creation, after setting all properties.
function text_indent_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_indent_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in output_button.
function output_button_Callback(hObject, eventdata, handles)
% hObject    handle to output_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in section_reflow_checkbox.
function section_reflow_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to section_reflow_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of section_reflow_checkbox
%% my function
%% 初始化 用户配置参数
function initCONFIG()
global CONFIG;
global PARA;
global PAGE;
CONFIG.gap =PARA.GAP;
CONFIG.padding = 0;
CONFIG.height = PAGE.HEIGHT;
CONFIG.width= PAGE.WIDTH*0.50;
w = CONFIG.width -2*CONFIG.padding;
CONFIG.Fx=w/double(PAGE.WIDTH);
CONFIG.Fy=1.5;%todo 默认1
CONFIG.y = CONFIG.padding+1+floor(PAGE.SAFE*CONFIG.Fx);
CONFIG.x = CONFIG.padding+1;
CONFIG.line_spacing = PARA.LINE_SPACING *CONFIG.Fy ;
CONFIG.text_indent = PARA.ONE_TAB_WIDTH*CONFIG.Fx*CONFIG.Fy;