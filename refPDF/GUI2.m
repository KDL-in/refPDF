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
%% GUI回调
% --- 传值
function GUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for GUI2
handles.output = hObject;

%获取gui1的引用,用于传值
handles.g1obj = varargin{1};%获得gui1对象指针
hdl = varargin{2};
handles.g1h = hdl;%获得gui1句柄列表

guidata(hObject, handles);

% --- 输入图像
function para_input_button_Callback(hObject, eventdata, handles)
global imgs;
clc;
[filename, pathname] = uigetfile({'*.PNG;*.jpg;*.tif',...
                  'Image Files (*.PNG,*.jpg,*.tif)'},'请选择输入图像 ...','on');
axes(handles.axes1); % 在指定的图像坐标系(即axes1)上显示图像
imgs.o = imread([pathname,filename]);
imgs.g = imgs.o;
if (size(imgs.o,3) ~= 1)
    imgs.g = func_imgToGray(imgs.o);%转灰度图
end
imgs.b = func_imgToBin(imgs.g);%二值化
imshow(imgs.g);
handles.h=imrect;%鼠标变成十字，用来选取感兴趣区域

handles.para_ensure_button.Enable = 'on';
guidata(hObject,handles);

% --- 确认
function para_ensure_button_Callback(hObject, eventdata, handles)
global PAGE;
global PARA;
getInteretingContentSize(handles);
func_statisticalParameter();
% 更新到gui1
handle = handles.g1h;
obj = handles.g1obj;
handle.PAGE =PAGE;
handle.PARA =PARA;
 guidata(obj,handle);
close(gcbf);%设置完毕,退出

%% 自定义函数
%% 计算正文内容的宽高
function getInteretingContentSize(handles)
% 用户截取的感兴趣区域图像部分(todo)
global PAGE;
global imgs;
pos = [1,1,size(imgs.b,2),size(imgs.b,1)];

pos=getPosition(handles.h);%图中就会出现可以拖动以及改变大小的矩形框，选好位置后：
pos=uint16(pos);%pos有四个值，分别是矩形框的左下角点的坐标 x y 和 框的 宽度和高度
%注意上面是图像的x,y, 下面矩阵要用应该交换一下
PAGE.SAFE =10;
 %  宽度
hor = func_projectTo(imgs.b,'horizontal');
% figure;plot(1:length(hor),hor);title('垂直方向像素');
PAGE.LX=pos(1);
PAGE.RX=pos(1)+pos(3)-1;
while(hor(PAGE.LX)==0) 
    PAGE.LX=PAGE.LX+1;
end;
while(hor(PAGE.RX)==0) 
    PAGE.RX=PAGE.RX-1;
end;
PAGE.RX=PAGE.RX+1;
PAGE.LX = PAGE.LX-PAGE.SAFE;%上下左右的安全区域
PAGE.RX = PAGE.RX+PAGE.SAFE;%上下左右的安全区域
PAGE.WIDTH=double(PAGE.RX-PAGE.LX);
% 高度
ver = func_projectTo(imgs.b,'vertical');
PAGE.UY=pos(2);
PAGE.DY=pos(2)+pos(4)-1;
% while(ver(PAGE.UY)==0) 
%     PAGE.UY=PAGE.UY+1;
% end;
% while(ver(PAGE.DY)==0) 
%     PAGE.DY=PAGE.DY-1;
% end;
% PAGE.UY = PAGE.UY-PAGE.SAFE;%上下左右的安全区域
% PAGE.DY = PAGE.DY+PAGE.SAFE;%上下左右的安全区域 %上下边不该trim
PAGE.HEIGHT=double(PAGE.DY-PAGE.UY-1);

%划出感兴趣区域后, imgs中更新
imgs.b = func_getThePartOf('binary',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
imgs.g = func_getThePartOf('gray',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
%% 转灰度图
function[im2]= func_imgToGray(img)
if (size(img,3) ~= 1)                % 要求输入图像为单通道灰度图像
    im2        = rgb2gray(img);
end
%% 二值化图像
function[im2]= func_imgToBin(img)
img            = 255 - img;          
im2            = double(img);
%计算trd, 这种trd计算方式,对pdf文档神效
trd            = 0.5*mean(im2(im2>0)); 
im2(im2 > trd) = 255;                
im2(im2 <=trd) = 0;
im2=uint8(im2);
%% 水平方向或垂直方向的投影
function[arr]=func_projectTo(img,type)
% @输入
% imb    图像
% type   投影类型
% @返回
% arr      投影结果
if(strcmp(type,'horizontal'))
    arr =sum(img(:,:));
else
    img = img';
    arr = sum(img(:,:));
    arr=arr';
end
%% 统计样本,计算出基本参数的值
function func_statisticalParameter()
%todo 选择样本之后固定这些参数
global PARA;%统计参数
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
%计算样本的行信息
ver = func_projectTo(imgs.b,'vertical');
% row = 0;
% len = size(ver,1);
% rp=zeros(len,2);
% i = 1;
% while (i<=len)
%     if (ver(i)~=0)
%         row = row+1;
%         rp(row,1)=i-1;
%         while(ver(i)~=0&&i<len) 
%             i=i+1;
%         end;
%         rp(row,2)=i;
%     end
%     i=i+1;
% end
% rp(row+1:end,:)=[];
[left,right]= func_getEdge(ver','段落');%求出所有段的边界坐标

% 中间三分之一求平均值法
% PARA.ONE_ROW_HEIGHT
tmp =right-left;
rel = median(tmp);
PARA.ONE_ROW_HEIGHT = round(func_getStatistcalAVG(tmp(tmp>0.5*rel&tmp<1.5*rel)));
% PARA.ONE_CHAR_WIDTH
idx = find(tmp==uint32(rel));
i = idx(ceil(length(idx)/2));
% figure;imshow(func_getThePartOf('binary',PAGE.LX,rp(i,1)+1,PAGE.WIDTH,tmp(i)));
hor = func_projectTo(func_getThePartOf('binary',1,left(i),PAGE.WIDTH,tmp(i)),'horizontal');%获得这一行的水平投影
%%% figure;plot(1:length(hor),hor);title('垂直方向像素');
% i = 1;
% num=1;
% tmp = zeros(1,300);%记录字符宽
% while(i<PAGE.WIDTH)
%     if(hor(i)~=0)
%         star=i;
%         while(hor(i)~=0)
%             i=i+1;
%         end
%         ed = i;
%         tmp(num)=ed-star;
%          num=num+1;
%         continue;
%     end
%     i=i+1;
% end
% tmp(num:end)=[];
[left,right] = func_getEdge(hor,'字符');
tmp= right-left;
avg = mean(tmp);
%取中位三分之一可能能容易取到英文,因此利用平均值筛选掉低数值求平均tag
PARA.ONE_CHAR_WIDTH = mean(tmp(tmp>avg));%update
% PARA.ONE_CHAR_WIDTH = ceil(func_getStatistcalAVG(tmp));
%PARA.ONE_TAB_WIDTH
PARA.ONE_TAB_WIDTH =  round(PARA.ONE_CHAR_WIDTH*2);
%PARA.ROW_properties.allRows_SPACING
% row = size(rp,1);
% tmp = zeros(1,row-1);
% for i = 2:row
%     tmp(i-1)=rp(i,1)-rp(i-1,2);
% end
[left,right]=func_getEdge(ver','空格');
tmp = right-left;
rel = median(tmp);
PARA.LINE_SPACING = ceil(func_getStatistcalAVG(tmp(tmp>0.5*rel&tmp<1.5*rel)));
% PARA.GAP 统计字体间距
% i = 1;
% num=1;
% tmp = zeros(1,300);%空白宽
% while(hor(i)==0)
%     i=i+1;
% end
% len =PAGE.WIDTH;
% while(hor(len)==0)
%     len=len-1;
% end
% while(i <=len)
%     if(hor(i)==0)
%         star = i;
%         while(hor(i)==0)
%             i=i+1;
%         end
%         ed = i;
%         tmp(num) = ed-star;
%         num=num+1;
%         continue;
%     end
%     i=i+1;
% end
% tmp(num:end)=[];
[left,right] = func_getEdge(hor,'空格');%cur
tmp = right-left;
avg = mean(tmp);
%取中位三分之一可能能容易取到英文,因此利用平均值筛选掉高低数值求平均
PARA.GAP = mean(tmp(tmp>0.3*avg & tmp<0.7*avg));
% TFTOOL 检测小工具
PARA.TFTOOL = uint8(ones(1,floor(PARA.ONE_CHAR_WIDTH*3.5)));
%% 取得连续1或连续0的左右坐标
function[left,right]=func_getEdge(arr,type)%tag
len = size(arr,2);
A = zeros(1,len+1);
B = zeros(1,len+1);
A(1:len) = arr(:)&1;
B(2:len+1)=arr(:)&1;
R = A-B;
left = find(R==1);
right = find(R==-1);
if(strcmp(type,'空格')==1)
   tmp=right(1:end);
   right=left(2:end);
   left =tmp(1:end-1);
end
%% 求一个数组中间三分之一上下取整区间的平均值
function[result]=func_getStatistcalAVG(tmp)
n = length(tmp);
left = floor(n/3);right = ceil(n/3*2);
tmp =sort(tmp);
result = mean(tmp(left:right));
%% 根据左上角坐标和长宽取出图像的一部分
function[imp]=func_getThePartOf(type,x,y,w,h)
% 输入
% type 灰度或者二值图
% xy 左上角坐标
% wh 宽和高
global imgs;
x=uint64(x);y=uint64(y);w=uint64(w);h=uint64(h);%matlab中似乎没有自动取最大变量类型,预防万一
switch type
    case 'gray'
        imp = imgs.g(y:y+h-1,x:x+w-1);
    case 'binary'
        imp = imgs.b(y:y+h-1,x:x+w-1);
end

%% 没用的方法
function varargout = GUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

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

