function varargout = GUI2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI2_OutputFcn, ...
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

% --- my
function GUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for GUI2
handles.output = hObject;

%��ȡgui1������,���ڴ�ֵ
handles.g1obj = varargin{1};%���gui1����ָ��
hdl = varargin{2};
handles.g1h = hdl;%���gui1����б�

guidata(hObject, handles);
function varargout = GUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- my����ͼ��
function para_input_button_Callback(hObject, eventdata, handles)
global imgs;
clc;
[filename, pathname] = uigetfile({'*.PNG;*.jpg;*.tif',...
                  'Image Files (*.PNG,*.jpg,*.tif)'},'��ѡ������ͼ�� ...','on');
axes(handles.axes1); % ��ָ����ͼ������ϵ(��axes1)����ʾͼ��
imgs.o = imread([pathname,filename]);
imgs.g = imgs.o;
if (size(imgs.o,3) ~= 1)
    imgs.g = func_imgToGray(imgs.o);%ת�Ҷ�ͼ
end
imgs.b = func_imgToBin(imgs.g);%��ֵ��
imshow(imgs.g);
handles.h=imrect;%�����ʮ�֣�����ѡȡ����Ȥ����

handles.para_ensure_button.Enable = 'on';
guidata(hObject,handles);

function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- my
function para_ensure_button_Callback(hObject, eventdata, handles)
global PAGE;
global PARA;
getInteretingContentSize(handles);
func_statisticalParameter();
% ���µ�gui1
handle = handles.g1h;
obj = handles.g1obj;
handle.PAGE =PAGE;
handle.PARA =PARA;
 guidata(obj,handle);
close(gcbf);%�������,�˳�
% my
%% �����������ݵĿ���
function getInteretingContentSize(handles)
% �û���ȡ�ĸ���Ȥ����ͼ�񲿷�(todo)
global PAGE;
global imgs;
pos = [1,1,size(imgs.b,2),size(imgs.b,1)];

pos=getPosition(handles.h);%ͼ�оͻ���ֿ����϶��Լ��ı��С�ľ��ο�ѡ��λ�ú�
pos=uint16(pos);%pos���ĸ�ֵ���ֱ��Ǿ��ο�����½ǵ������ x y �� ��� ���Ⱥ͸߶�
%ע��������ͼ���x,y, �������Ҫ��Ӧ�ý���һ��

PAGE.SAFE =10;
 %  ����
hor = func_projectTo(imgs.b,'horizontal');
% figure;plot(1:length(hor),hor);title('��ֱ��������');
PAGE.LX=pos(1);
PAGE.RX=pos(1)+pos(3)-1;
while(hor(PAGE.LX)==0) 
    PAGE.LX=PAGE.LX+1;
end;
while(hor(PAGE.RX)==0) 
    PAGE.RX=PAGE.RX-1;
end;
PAGE.RX=PAGE.RX+1;
PAGE.LX = PAGE.LX-PAGE.SAFE;%�������ҵİ�ȫ����
PAGE.RX = PAGE.RX+PAGE.SAFE;%�������ҵİ�ȫ����
PAGE.WIDTH=double(PAGE.RX-PAGE.LX);
% �߶�
ver = func_projectTo(imgs.b,'vertical');
PAGE.UY=pos(2);
PAGE.DY=pos(2)+pos(4)-1;
while(ver(PAGE.UY)==0) 
    PAGE.UY=PAGE.UY+1;
end;
while(ver(PAGE.DY)==0) 
    PAGE.DY=PAGE.DY-1;
end;
PAGE.UY = PAGE.UY-PAGE.SAFE;%�������ҵİ�ȫ����
PAGE.DY = PAGE.DY+PAGE.SAFE;%�������ҵİ�ȫ����
PAGE.HEIGHT=double(PAGE.DY-PAGE.UY-1);
%��������Ȥ�����, imgs�и���
imgs.b = func_getThePartOf('binary',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
imgs.g = func_getThePartOf('gray',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
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
%% ͳ������,���������������ֵ
function func_statisticalParameter()
%todo ѡ������֮��̶���Щ����
global PARA;%ͳ�Ʋ���
global PAGE;
global imgs;
%page.jpg
% PARA.ONE_CHAR_WIDTH = 23;
% PARA.ONE_TAB_WIDTH =  round(PARA.ONE_CHAR_WIDTH*3.5);
% PARA.ONE_ROW_HEIGHT=32;
%test
% PARA.ONE_CHAR_WIDTH = 80;
% PARA.ONE_TAB_WIDTH =  round(PARA.ONE_CHAR_WIDTH*3.5);
% PARA.ONE_ROW_HEIGHT=100;
%��������������Ϣ
ver = func_projectTo(imgs.b,'vertical');
row = 0;
len = size(ver,1);
rp=zeros(len,2);
i = 1;
while (i<=len)
    if (ver(i)~=0)
        row = row+1;
        rp(row,1)=i-1;
        while(ver(i)~=0&&i<len) 
            i=i+1;
        end;
        rp(row,2)=i;
    end
    i=i+1;
end
rp(row+1:end,:)=[];

% �м�����֮һ��ƽ��ֵ��
% PARA.ONE_ROW_HEIGHT
tmp =rp(:,2)-rp(:,1)-1;
PARA.ONE_ROW_HEIGHT = round(func_getStatistcalAVG(tmp));
% PARA.ONE_CHAR_WIDTH
idx = find(tmp==uint32(median(tmp)));
i = idx(ceil(length(idx)/2));
% figure;imshow(func_getThePartOf('binary',PAGE.LX,rp(i,1)+1,PAGE.WIDTH,tmp(i)));
hor = func_projectTo(func_getThePartOf('binary',1,rp(i,1)+1,PAGE.WIDTH,tmp(i)),'horizontal');%�����һ�е�ˮƽͶӰ
%%% figure;plot(1:length(hor),hor);title('��ֱ��������');
i = 1;
num=1;
tmp = zeros(1,300);%��¼�ַ���
while(i<PAGE.WIDTH)
    if(hor(i)~=0)
        star=i;
        while(hor(i)~=0)
            i=i+1;
        end
        ed = i;
        tmp(num)=ed-star;
         num=num+1;
        continue;
    end
    i=i+1;
end
tmp(num:end)=[];
PARA.ONE_CHAR_WIDTH = ceil(func_getStatistcalAVG(tmp));
%PARA.ONE_TAB_WIDTH
PARA.ONE_TAB_WIDTH =  round(PARA.ONE_CHAR_WIDTH*2);
%PARA.ROW_properties.allRows_SPACING
row = size(rp,1);
tmp = zeros(1,row-1);
for i = 2:row
    tmp(i-1)=rp(i,1)-rp(i-1,2);
end
PARA.LINE_SPACING = floor(func_getStatistcalAVG(tmp));
% PARA.GAP ͳ��������
i = 1;
num=1;
tmp = zeros(1,300);%�հ׿�
while(hor(i)==0)
    i=i+1;
end
len =PAGE.WIDTH;
while(hor(len)==0)
    len=len-1;
end
while(i <=len)
    if(hor(i)==0)
        star = i;
        while(hor(i)==0)
            i=i+1;
        end
        ed = i;
        tmp(num) = ed-star;
        num=num+1;
        continue;
    end
    i=i+1;
end
tmp(num:end)=[];
avg = mean(tmp);
%ȡ��λ����֮һ����������ȡ��Ӣ��,�������ƽ��ֵɸѡ���ߵ���ֵ��ƽ��
PARA.GAP = mean(tmp(tmp>0.3*avg & tmp<0.7*avg));
% TFTOOL ���С����
PARA.TFTOOL = uint8(ones(1,floor(PARA.ONE_CHAR_WIDTH*3.5)));
%% ��һ�������м�����֮һ����ȡ�������ƽ��ֵ
function[result]=func_getStatistcalAVG(tmp)
n = length(tmp);
left = floor(n/3);right = ceil(n/3*2);
tmp =sort(tmp);
result = mean(tmp(left:right));
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