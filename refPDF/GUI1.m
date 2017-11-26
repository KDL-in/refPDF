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

% Last Modified by GUIDE v2.5 26-Nov-2017 20:07:28

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


% Choose default command line output for GUI1
handles.output = hObject;
% handles.input_button.Enable ='on';
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


%% �����÷���, ��������
function testInit(obj,h)
h.PAGE.SAFE = 10;
h.PAGE.LX = 174;
h.PAGE.RX = 1398;
h.PAGE.WIDTH = 1224;
h.PAGE.UY = 184;
h.PAGE.DY = 1706;
h.PAGE.HEIGHT = 1521;
h.PAGE.SAFE = 10;
h.PAGE.SAFE = 10;
h.PARA.ONE_ROW_HEIGHT = 29;
h.PARA.ONE_CHAR_WIDTH = 29;
h.PARA.ONE_TAB_WIDTH =58;
h.PARA.LINE_SPACING =20;
h.PARA.GAP = 2.5625;
h.PARA.TFTOOL=ones(1,101);
guidata(obj, h);
% ---����ͼƬ
function input_button_Callback(hObject, eventdata, h)
global PAGE;
global imgs;
global PARA;
global CONFIG;
global UI;

%��һЩ��ʼ������
PAGE =h.PAGE;
PARA=h.PARA;
UI.isOutput = 0;
UI.isEnd = 0;
UI.perview =0;
imgs.p=1;
initCONFIG();
%��ͼƬ
[filename, pathname, filterindex] = uigetfile({'*.PNG;*.jpg;*.tif',...
                  'Image Files (*.PNG,*.jpg,*.tif)'},'��ѡ������ͼ�� ...','MultiSelect','on');
UI.inURL = pathname;
UI.names = filename;
UI.index = filterindex;
func_nextImg();
axes(h.axes2);
imshow(imgs.g);
% ��ͼƬ����½���. ����Ĭ��ֵ
h.config_panel.Visible = 'on';
h.height_edit.String = CONFIG.height;
h.width_edit.String = CONFIG.width;        
h.gap_edit.String = CONFIG.gap;        
h.padding_edit.String = CONFIG.padding;        
h.linespacing_edit.String = CONFIG.line_spacing;        
h.text_indent_edit.String = CONFIG.text_indent; 
h.font_size_edit.String =CONFIG.Fy;

h.para_button.Enable = 'off';
h.perview_checkbox.Enable = 'on';
h.url_button.Enable = 'on';
% --- �Ƿ���ʾԤ��
function perview_checkbox_Callback(hObject, eventdata, handles)
global UI
if (get(handles.perview_checkbox,'Value')==1)
    UI.perview = 1;
else
    UI.perview = 0;
end
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ��������������������ҳ��
function para_button_Callback(hObject, eventdata, handles)
GUI2(hObject,handles);  %test
% testInit(hObject,handles);
handles.input_button.Enable ='on';
% --- ����·��
function url_button_Callback(hObject, eventdata, handles)
global UI;
outURL =uigetdir();
if(isempty(outURL)==0)
    UI.outURL = outURL;
    handles.output_button.Enable = 'on';
end
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


% --- ����ȷ����ť
function config_ensure_button_Callback(hObject, eventdata, h)
global CONFIG;
global PAGE;
global UI;
CONFIG.height=getValue(h.height_edit,hObject,h);
CONFIG.width =getValue(h.width_edit,hObject,h);        
CONFIG.gap=getValue(h.gap_edit,hObject,h);  
CONFIG.padding=getValue(h.padding_edit,hObject,h);    
CONFIG.line_spacing=getValue(h.linespacing_edit,hObject,h);        
CONFIG.text_indent=getValue(h.text_indent_edit,hObject,h);
CONFIG.Fy = getValue(h.font_size_edit,hObject,h);
w = CONFIG.width -2*CONFIG.padding;
CONFIG.Fx=w/double(PAGE.WIDTH);
CONFIG.y = CONFIG.padding+1+floor(PAGE.SAFE*CONFIG.Fx);
CONFIG.x = CONFIG.padding+1;
if(UI.perview==1)
    func_reflow();
end
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


% --- ���Ų����
function output_button_Callback(hObject, eventdata, handles)
global UI;
global imgs;
UI.isOutput = 1;
imgs.p=1;
while(UI.isEnd==0)
    func_reflow();
    func_newPage();
    func_nextImg();%cur
end
handles.output_button.Enable ='off';
handles.url_button.Enable ='off';
% --- Executes on button press in section_reflow_checkbox.
function section_reflow_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to section_reflow_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of section_reflow_checkbox
%% my function
%% ��ʼ�� �û����ò���
function initCONFIG()
global CONFIG;
global PARA;
global PAGE;
CONFIG.gap =PARA.GAP;
CONFIG.padding = 0;
CONFIG.height = PAGE.HEIGHT;
CONFIG.width= PAGE.WIDTH;
w = CONFIG.width -2*CONFIG.padding;
CONFIG.Fx=w/double(PAGE.WIDTH);
CONFIG.Fy=1;
CONFIG.y = CONFIG.padding+1+floor(PAGE.SAFE*CONFIG.Fx);
CONFIG.x = CONFIG.padding+1;
CONFIG.line_spacing = PARA.LINE_SPACING *CONFIG.Fy ;
CONFIG.text_indent = PARA.ONE_TAB_WIDTH*CONFIG.Fx*CONFIG.Fy;
%% ��ȡedit�е�����
function i = getValue(obj,hObject,handles)
str = get(obj,'String');
if (isempty(str))
     set(hObject,'String','0')
     str = '0';
end
guidata(hObject, handles);
i = str2double(str);
%% ȡ�õ�ǰ����ͼƬ�����е���һ��ͼƬ
function func_nextImg()
global imgs;
global PAGE;
global UI;
UI.isEnd = 0;
if(iscell(UI.names)==1)
    UI.n = size(UI.names,2);
else
    UI.n = 1;
end
if(UI.index>UI.n)
    UI.isEnd = 1;
else
    if(UI.n==1)
        imgs.o=imread([UI.inURL,UI.names]);
    else
        imgs.o = imread([UI.inURL,UI.names{UI.index}]);
    end
    imgs.g=imgs.o;
    if (size(imgs.o,3) ~= 1)
    imgs.g = func_imgToGray(imgs.o);%ת�Ҷ�ͼ
    end
    imgs.b = func_imgToBin(imgs.g);%��ֵ��
    imgs.b = func_getThePartOf('binary',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
    imgs.g = func_getThePartOf('gray',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
    UI.index=UI.index+1;
end
%% �������Ͻ�����ͳ���ȡ��ͼ���һ����
function[imp]=func_getThePartOf(type,x,y,w,h)
% ����
% type �ҶȻ��߶�ֵͼ
% xy ���Ͻ�����
% wh ���͸�
global imgs;
x=uint64(x);y=uint64(y);w=uint64(w);h=uint64(h);%matlab���ƺ�û���Զ�ȡ����������,Ԥ����һ
switch type
    case 'gray'
        imp = imgs.g(y:y+h-1,x:x+w-1);
    case 'binary'
        imp = imgs.b(y:y+h-1,x:x+w-1);
end
%% ת�Ҷ�ͼ
function[im2]= func_imgToGray(img)
if (size(img,3) ~= 1)                % Ҫ������ͼ��Ϊ��ͨ���Ҷ�ͼ��
    im2        = rgb2gray(img);
end
%% ��ֵ��ͼ��
function[im2]= func_imgToBin(img)
img            = 255 - img;          
im2            = double(img);
%����trd, ����trd���㷽ʽ,��pdf�ĵ���Ч
trd            = 0.5*mean(im2(im2>0)); 
im2(im2 > trd) = 255;                
im2(im2 <=trd) = 0;
im2=uint8(im2);
%% ִ������
function func_reflow()
global imgs;
initProperties();% ��ʼ��ˮƽ����ʹ�ֱ�����ͶӰ,�Լ�����Ϣ�Ͷ���Ϣ
func_charsReflow();
imshow(imgs.output);
%% ���ֻ���(����) cur
function func_charsReflow()
global properties;
global CONFIG;
global PARA;
global PAGE;
global imgs;
%�½�ͼ��
s_size = size(properties.section,1);
imgs.output = uint8(zeros(ceil(CONFIG.height),ceil(CONFIG.width)));
imgs.output = 255-imgs.output;
x = CONFIG.x;
y= CONFIG.y;
p =1;%����ļ��ı��
for i = 1:s_size
    sp =properties.section(i,:);
    T = sp(5);
    %��������
    if(T~=0)%���������������������ַ�
        y = floor(y+CONFIG.Fx*PAGE.WIDTH*sp(5));
    else
        y = floor(y+CONFIG.text_indent);
    end
    if(sp(6)==1)%�����ͼƬ��
        if(CONFIG.height-CONFIG.padding < x+sp(4)*CONFIG.Fx)%����һҳ
            %         figure;imshow(imgs.output);title('section reflow');
            [x,~]=func_newPage();
        end
        [x,y]=func_append(x,y,sp(1:4),'section');
    else
        %����ÿ���ַ�
        for row =sp(7):sp(8)%����ÿһ��
            chars = properties.charsAtRows{row};
            c_size = size(chars,1);
            for n = 1:c_size%���������ַ�
                %���л�ҳ
                if(y+chars(n,3)*CONFIG.Fx*CONFIG.Fy > CONFIG.width-CONFIG.padding)%�Ƿ���Ҫ����
                    [x,y] = func_newline(x,y,chars(n,4)*CONFIG.Fx*CONFIG.Fy);
                    x = ceil(x+ CONFIG.line_spacing);
                end
                if(CONFIG.height-CONFIG.padding < x+chars(n,4)*CONFIG.Fx*CONFIG.Fy)%����һҳ
                    [x,y]=func_newPage();
                end
                %�������Ƿ���������
                if(y==CONFIG.y&&T~=0)% �µ�һ��,�費��Ҫ��������
                    y = floor(y+CONFIG.Fx*PAGE.WIDTH*sp(5));
                    y = floor(y+PARA.ONE_CHAR_WIDTH*CONFIG.Fx*CONFIG.Fy);%�ٶ�������һ���ַ�
                end
                [x,y]=func_append(x,y,chars(n,1:4),'char');
            end
        end
    end
    % ����, ͼƬ�����Լ��λ���, ����о�����
    if(sp(6)==1)
        [x,y]=func_newline(x,y,sp(4)*CONFIG.Fx);
        x = floor(x+CONFIG.line_spacing*0.5);
    else%���л��������һ�еĸ߶�
        h = properties.allRows(sp(8),2)-properties.allRows(sp(8),1)-1;
        [x,y]=func_newline(x,y,h*CONFIG.Fx*CONFIG.Fy);
        x = ceil(x+ CONFIG.line_spacing);
    end
end
%% ����һҳ
function[x,y] = func_newPage()
global imgs;
global CONFIG;
global UI;
if(UI.isOutput==1)
    func_save(UI.outURL,strcat('p',num2str(imgs.p)),'jpg');
    imgs.p= imgs.p+1;
end
imgs.output = uint8(zeros(CONFIG.height,CONFIG.width));
imgs.output = 255-imgs.output;
x=CONFIG.x;
y=CONFIG.y;
%% �����󱣴�ΪͼƬ
function func_save(url,name,type)
global imgs;
% �ļ�,��ַ, �ļ���, ��������
if(url(length(url))=='/')
    url(length(url))=[];
end
imwrite(imgs.output,strcat(url,'/',name,'.',type),type);
%% ��ͼƬ��С�������ӵ����ͼƬ��
function[x,y]=func_append(x,y,position,type)
% @����
% x,yΪ������Ͻ�����
% position[sx,sy,sw,sh]��������ͼƬ�����Ͻ�����Ϳ���
% typeΪ��������(���ֻ��߶���)
% @return
% x,y, ����ͼƬ���¹��λ��
global CONFIG;
global imgs;
%!!!ע��,properties.section����Ϊ�漰�����Ͻ�x,y����,����x��ͼƬ��x��,������,���Ҫ��������
sx=position(2);sy=position(1);sw=position(3);sh=position(4);
%��������
switch type
    case 'section'
        imrs = imresize(imgs.g(sx:(sx+sh-1),sy:(sy+sw-1)),CONFIG.Fx);
        % imrs = imgs.g(sx:(sx+sh-1),sy:(sy+sw-1));
        [sh,sw]=size(imrs);
        imgs.output(x:(x+sh-1),y:(y+sw-1))=imrs(:,:);
        x =x;
        y=y+sw;
    case 'char'
        imrs = imresize(imgs.g(sx:(sx+sh-1),sy:(sy+sw-1)),CONFIG.Fx*CONFIG.Fy);
        [sh,sw]=size(imrs);
        imgs.output(x:(x+sh-1),y:(y+sw-1))=imrs(:,:);
        x =x;
        y = ceil(y+sw+CONFIG.gap);
end
%% ���ݴ���߶Ȼ��з����µ�����
function[x,y]=func_newline(x,~,height)
global CONFIG;
y= CONFIG.y;
x=x+height;

%% ��ʼ��ˮƽ����ʹ�ֱ�����ͶӰ,�Լ�����Ϣ�Ͷ���Ϣ
function initProperties()
global imgs;
global properties;
global projection;
% figure;imshow(imgs.b);
% figure;imshow(func_getThePartOf(PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT));
projection.ver = func_projectTo(imgs.b,'vercial');%ͶӰ����ֱ����
% figure;plot(projection.ver,1:length(projection.ver));title('��ֱ��������');set(gca,'ydir','reverse');
getRowProperty();
% func_showDivisiveImg(properties.allRows,'line');%��ʾ���и�
getRowsProjection();%���ÿһ��ˮƽ�����ͶӰ,���浽projection.allRows
getSectionProperty();%��ö��и���Ϣ
% func_showDivisiveImg(properties.section,'rectangle');%��ʾ���и�
getCharsProperty();
%% ���ÿ���ַ�����Ϣ
function getCharsProperty()
global properties;
s = size(properties.section,1);
for i =1:s
    sp =properties.section(i,:);
    for row = sp(7):sp(8)
        if(sp(6)~=1)
           split(row);
        end
    end
end
%% �Ե�row�н����и�
function split(row)
global projection;
global properties;

global PARA;
% showRow(row);
temp = uint8(projection.allRows{row});
c = size(temp,2);

%% ����
% ��ͶӰ(��255,0),����Ϣ
result = zeros(1, c);
%����ַ����ұ߽�[������]
index = 1;
for y = 1 : c - 1
    if (temp(1, y) == 0 && temp(1, y + 1) == 255)
        result(1, index) = y + 1;
        index = index + 1;
    elseif (temp(1, y) == 255 && temp(1, y + 1) == 0)
        result(1, index) = y;
        index = index + 1;
    end
end

result(index : c) = [];
result = fixChars(result);

[~, c] = size(result);
index = 2;
while (index < c)%Ӣ���ַ�֮��ĺϲ�
    if (result(1, index) - result(1, index - 1) <= PARA.GAP)
        result(index - 1 : index) = [];
        c = c - 2;
    end
    index = index + 1;
end
%% ���
% result ÿ��Ԫ�ر���ַ������ұ߽�
% ת��ΪcharProperty
n = size(result,2);
properties.charsAtRows{row}=zeros(n/2,4);
c = 1;
for i=1:2:n-1
    x = result(i);
    y = properties.allRows(row,1);
    w = result(i+1)-x+1;
    h = properties.allRows(row,2)-properties.allRows(row,1)-1;
    properties.charsAtRows{row}(c,:)=[x,y,w,h];
    c=c+1;
end
% func_showDivisiveImg(properties.charsAtRows{row},'rectangle');%show

%% �޸��ַ�֮��Ķ���, ����˵ �� ��
function[arr] = fixChars(arr)
global PARA;

%% ����
% ��׼�ַ�����
% �ϲ�������  ��  ��  ��Щ��
[~, c] = size(arr);
x = 2;
while (x < c - 2)%�ϲ����ԸĽ�
    if (arr(1, x) - arr(1, x - 1) < PARA.ONE_CHAR_WIDTH*0.6)
         if (arr(1, x + 2) - arr(1, x + 1) < PARA.ONE_CHAR_WIDTH*0.6)
            if(arr(1,x+1)-arr(1,x)<2*PARA.GAP)
               arr(x : x + 1) = [];
                 c = c - 2;
            end
         end
    end
    x = x + 2;
end

%% ͼ������ʾ���ַָ���
function  func_showDivisiveImg(properties,type)
% ����
% img            ����ͼ��
% properties  ͼ����صķָ���Ϣ
% type           ��ʾ����
global PAGE;
% [M,N,O]=size(img);
n = size(properties,1);
switch type
    case 'line'
        line([PAGE.LX,PAGE.RX],[properties(:,1),properties(:,1)]);
        line([PAGE.LX,PAGE.RX],[properties(:,2),properties(:,2)]);
    case 'rectangle'
        %rectangle('Position',temp,'LineWidth',2,'LineStyle','-','edgecolor','b')
        if(size(properties,2)==8)%����
            for i=1:n
                color ='g';
                if(properties(i,6)~=0)
                   color = 'r';
                elseif(properties(i,5)~=0)
                   color = 'b';
                end
                position=properties(i,1:4);%ע��,�����x�������ͼ���x�Ǻ�
                rectangle('Position',position,'edgecolor',color);
            end
        else
             for i=1:n%�ַ�
                position=properties(i,1:4);%ע��,�����x�������ͼ���x�Ǻ�
                rectangle('Position',position,'edgecolor','g');
            end
        end
end
%% ���������׿ո���
function [head_blank,tail_blank]=trim(row)
global projection;%ÿһ�е�ˮƽͶӰ

hor = projection.allRows{row};
head_blank =1;
% showRow(1);
% if(row==31)
%     row
% end
while(hor(head_blank)==0)
    head_blank=1+head_blank;
end
head_blank = head_blank-1;
i = size(hor,2);
while(hor(i)==0)
    i=i-1;
end
tail_blank=i+1;
%% �����кϲ��ɶ�,ͼƬ�Գ�һ��
function getSectionProperty()
% s������
% properties.section: ����Ϣ
%---------- ����һ��s��8������,�ṹ����
%----------  [x,y,w,h,T,P,from,to]
%----------  �ֱ���
%----------  position   :  x,y,w,h ���Ͻ�����,����
%----------  flag          :  T ��������   P �Ƿ�ͼƬ
%----------  from-to    :  from  ��ʼ��      to ������
global PAGE;
global PARA;
global properties;
row =size(properties.allRows,1);
s = 1;
properties.section = zeros(row,8);
last_blank = 0;
for i = 1:row     
%     if(i == 3)
%          showRow(i);
% %          figure;imshow(func_getThePartOf('binary',x,y,w,h));
%      end
    [head_blank,tail_blank] = trim(i);%���㿪ͷ�Ŀհ׳���
    x = head_blank+1;
    y= properties.allRows(i,1)+1;
    h = properties.allRows(i,2)-properties.allRows(i,1)-1;
    w=tail_blank-head_blank-1;
    if(isImgSection(i,x,y,w,h)==1)%�Ƿ�ΪͼƬ��
        properties.section(s,:)=[x,y,w,h,head_blank/PAGE.WIDTH,1,i,i];%�½�һ��
        s=s+1;
    else%��ͼƬ��
        if(head_blank-PAGE.SAFE> PARA.ONE_CHAR_WIDTH)%����һ����׼�ַ���С
            properties.section(s,:)=[x,y,w,h,0,0,i,i];%��Ϊ���µ�һ��
            if(head_blank-PAGE.SAFE>PARA.ONE_TAB_WIDTH*1.3)%����һ����׼����ֵ
                properties.section(s,5)=head_blank/PAGE.WIDTH;%�������������ֵ
            end
            s=s+1;
        else%�޿ո�, ��ô��һ�к���һ�κϲ�
            if(s==1 || properties.section(s-1,6)==1)%��һ���Ƿ�ΪͼƬ
                properties.section(s, :)=[x,y,w,h, head_blank/PAGE.WIDTH, 0, i, i];
                s=s+1;
            else%��ͼƬ,�ϲ�
                %���ȵĸ���
                if(last_blank>PARA.ONE_CHAR_WIDTH)%���е����
                    properties.section(s-1,3)=properties.section(s-1,3)+last_blank-head_blank;
                end
                if(w>properties.section(s-1,3))%���³�����
                    properties.section(s-1,3)=w;
                end
                properties.section(s-1,5)=0;%�������������ֵ
                properties.section(s-1,1) = min([x,properties.section(s-1,1)]);%x�ĸ���,���³���С��
                properties.section(s-1, 4)=properties.allRows(i,2)-properties.section(s-1,2);
                properties.section(s-1,8) = i;
            end
        end
    end
    last_blank = head_blank;
end
properties.section(s:end,:)=[];
% s=s-1;

%% ���ÿһ��ˮƽ�����ͶӰ,���浽projection.allRows
function getRowsProjection()
global PAGE;
global projection;
global properties;
row = size(properties.allRows,1);
projection.allRows = cell(1,row);
for i = 1:row
    h = properties.allRows(i,2)-properties.allRows(i,1)-1;
    imp = func_getThePartOf('binary',1,properties.allRows(i,1)+1,PAGE.WIDTH,h);
    projection.allRows{i}=func_projectTo(imp,'horizontal');
end

%% �Ӵ�ֱͶӰ�л������Ϣ
function getRowProperty()
% properties.allRows Ϊÿ�е����±߽��λ��
%                      ���ĽṹΪ[up, buttom], ����x��, �ϱ߽�Ϊup,�±߽�Ϊbuttom
global projection;
global properties;
row = 0;
len = size(projection.ver,1);
properties.allRows=zeros(len,2);
i = 1;
while (i<=len)
    if (projection.ver(i)~=0)
        row = row+1;
        properties.allRows(row,1)=i-1;
        while(projection.ver(i)~=0&&i<len) 
            i=i+1;
        end;
        properties.allRows(row,2)=i;
    end
    i=i+1;
end
properties.allRows(row+1:end,:)=[];
% tmp =properties.allRows(:,2)-properties.allRows(:,1);
% idx = tmp<7;ȥ�����߶�ɸѡֵ???�����ٿ���
% properties.allRows(idx,:)=[];
%% ˮƽ�����ֱ�����ͶӰ
function[arr]=func_projectTo(img,type)
% @����
% imb    ͼ��
% type   ͶӰ����
% @����
% arr      ͶӰ���
if(strcmp(type,'horizontal'))
    arr =sum(img(:,:));
else
    img = img';
    arr = sum(img(:,:));
    arr=arr';
end
%% �ж�ĳһ���Ƿ�ΪͼƬ
function [flag] =isImgSection(idx,x,~,~,h)
global PARA;
global projection;
flag = 0;
hor = projection.allRows{idx};
%���еĸ߶��ж�
if(h>PARA.ONE_ROW_HEIGHT*1.7) 
    flag = 1;
else
%     figure;imshow(func_getThePartOf('binary',x,y,w,h));
    len = min(size(hor,2),x+size(PARA.TFTOOL,2)-1);
    hor = hor(1,x:len);
    tmp =and(hor,PARA.TFTOOL);
    blank = find(tmp==0);
    if(length(blank)<PARA.ONE_CHAR_WIDTH*0.05)
        flag=1;
    end
end



function font_size_edit_Callback(hObject, eventdata, handles)
% hObject    handle to font_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of font_size_edit as text
%        str2double(get(hObject,'String')) returns contents of font_size_edit as a double


% --- Executes during object creation, after setting all properties.
function font_size_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to font_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_division_checkbox.
function show_division_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to show_division_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_division_checkbox