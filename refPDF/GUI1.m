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

% Last Modified by GUIDE v2.5 28-Nov-2017 18:28:07

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
%% man以下是全局参数说明,参数为结构体,包含各种子参数
global PAGE;
% PAGE 感兴趣区域的实际有内容区域的信息, 左右边界以及宽度,包含
%--LX 左边界
%--LX 右边界
%--UY 上边界
%--DY 下边界
%--WIDTH 实际内容的宽度
%--SAFE预留切割的安全区域长度
global PARA;
% PARA 统计参数,经过统计得来的一些页面相关参数,包含
%--ONE_CHAR_WIDTH   一个中文字符的标准宽
%--ONE_TAB_WIDTH      一个首行缩进的标准宽
%--ONE_ROW_HEIGHT   一行的标准高
%--LINE_SPACING  行间隔
%--TFTOOL 一个3.5个字符宽的数组, 数组全为1, 检测连续像素点用
global projection;
% projection 垂直方向和水平方向的投影,包含
%--allRows 每一行的水平投影
%--ver        页面垂直方向的投影
global imgs;%灰度图像
% imgs  输入图像,它的灰度图像,它的二值图像,以及输出图像
%--imgs.o 原始图像
%--imgs.g 灰度图像
%--imgs.b 二值图像
%--imgs.output 输出图像
%--p 输出页面的序号
%--x,y用户保留上一页重排最后的xy
global properties;
% properties是行分割,段分割的相关信息, 包含
%--allRows:  行信息
%----------它是一个n行2列的数组,它的结构为
%----------[up, buttom],
%----------即第x行, 上边界为up,下边界为buttom
%--section: 段信息
%----------它是一个s行8列数组,结构如下
%----------[x,y,w,h,T,P,from,to]
%----------分别是
%----------position   :  x,y,w,h 左上角坐标,宽高
%----------flag          :  T 缩进保留   P 是否图片
%----------from-to    :  from  启始行      to 结束行
%--charsAtRows: 字符信息
%----------它是一个元胞数组, 共有n个元素,n为行数(图片行为空)
%----------每一个元素是一个m行4列的数组,记录m个字符的信息
%----------数组的结构是
%----------[x,y,w,h]
%----------x,y,w,h 左上角坐标,宽高
%--gapsAtRows: 字符间隔信息
%----------它是一个数组, 有n个元素,表示n+1个字符间的n个空白
%--lineSpacings 行距信息
%----------它是一个数组, 有n个元素,表示n+1行间的n个行距
global CONFIG;
% CONFIG  用户设定的参数
%--gap 字体间距
%--padding 新文档内边距
%--width 新文档宽
%--height 新文档高
%--Fy 字体放大倍数
%--line_spacing 行距
%--text_indent 缩进距离
%--以上是用户设置,有默认值,以下是通过上面计算得来
%--x 左上角x
%--y 左上角y
%--Fx 缩放因子 新文档宽/原文档宽
global UI;
% 界面上的设定数据
%--perview 是否显示预览
%--inURL 输入文件地址
%--names 输入文件名数组
%--index 当前文件下标
%--outURL 输出文件地址
%--isOutput 是否输出
%--n图片的数量
%--isEnd 图片读取结束标志

%% GUI回调函数
% ---输入图片
function input_button_Callback(hObject, eventdata, h)
global PAGE;
global imgs;
global PARA;
global CONFIG;
global UI;

%做一些初始化工作
PAGE =h.PAGE;
PARA=h.PARA;
initCONFIG();
UI.isOutput = 0;
UI.isEnd = 0;
UI.perview =0;
imgs.p=1;
imgs.perview=[];
[imgs.x,imgs.y]=func_newPage();

%打开图片
[filename, pathname, filterindex] = uigetfile({'*.PNG;*.jpg;*.tif',...
                  'Image Files (*.PNG,*.jpg,*.tif)'},'请选择输入图像 ...','MultiSelect','on');
UI.inURL = pathname;
UI.names = filename;
UI.index = filterindex;
func_nextImg();
axes(h.axes2);
imshow(imgs.g);
% 打开图片后更新界面. 设置默认值
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

% --- 是否显示预览
function perview_checkbox_Callback(hObject, eventdata, handles)
global UI
if (get(handles.perview_checkbox,'Value')==1)
    UI.perview = 1;
else
    UI.perview = 0;
end

%--- 启动参数样本界面输入页面
function para_button_Callback(hObject, eventdata, handles)
GUI2(hObject,handles);  %test
% testInit(hObject,handles);
handles.input_button.Enable ='on';
% --- 设置路径
function url_button_Callback(hObject, eventdata, handles)
global UI;
outURL =uigetdir();
if(isempty(outURL)==0)
    UI.outURL = outURL;
    handles.output_button.Enable = 'on';
end
% --- 参数确定按钮
function config_ensure_button_Callback(hObject, eventdata, h)
global CONFIG;
global PAGE;
global imgs;
global UI;
[imgs.x,imgs.y]=func_newPage();
imgs.perview=[];
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
    h.show_division_button.Enable='on';
end

% --- 显示切割信息按钮
function show_division_button_Callback(hObject, eventdata, handles)
global imgs;
global properties;
figure;imshow(imgs.g);
% set(gca,'position',[0,0,1,1]);
func_showDivisiveImg(properties.section,'rectangle');
s = size(properties.section,1);
figure;imshow(imgs.g);
% set(gca,'position',[0,0,1,1]);
for i =1:s
    for j= properties.section(i,7):properties.section(i,8)
        if(properties.section(i,6)~=1)
            func_showDivisiveImg(properties.charsAtRows{j},'rectangle');
        end
    end   
end

% --- 重排并输出
function output_button_Callback(hObject, eventdata, handles)
global UI;
global imgs;
UI.isOutput = 1;
imgs.p=1;
[imgs.x,imgs.y]=func_newPage();
while(UI.isEnd==0)
    func_reflow();
    func_nextImg();
end
func_newPage()
handles.output_button.Enable ='off';
handles.url_button.Enable ='off';
% --- Executes on button press in section_reflow_checkbox.

%% 自定义函数

%% 初始化 用户配置参数
function initCONFIG()
global CONFIG;
global PARA;
global PAGE;
CONFIG.gap =1;
CONFIG.padding = 0;
CONFIG.height = PAGE.HEIGHT;
CONFIG.width= PAGE.WIDTH;
w = CONFIG.width -2*CONFIG.padding;
CONFIG.Fx=w/double(PAGE.WIDTH);
CONFIG.Fy=1;
CONFIG.y = CONFIG.padding+1+floor(PAGE.SAFE*CONFIG.Fx);
CONFIG.x = CONFIG.padding+1;
% CONFIG.line_spacing = PARA.LINE_SPACING *CONFIG.Fy ;
CONFIG.line_spacing = 1;
CONFIG.text_indent = PARA.ONE_TAB_WIDTH*CONFIG.Fx*CONFIG.Fy;
%% 获取edit中的数字
function i = getValue(obj,hObject,handles)
str = get(obj,'String');
if (isempty(str))
     set(hObject,'String','0')
     str = '0';
end
guidata(hObject, handles);
i = str2double(str);
%% 取得当前处理图片集合中的下一张图片
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
    imgs.g = func_imgToGray(imgs.o);%转灰度图
    end
    imgs.b = func_imgToBin(imgs.g);%二值化
    imgs.b = func_getThePartOf('binary',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
    imgs.g = func_getThePartOf('gray',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
    UI.index=UI.index+1;
end
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
%% 执行重排
function func_reflow()
global imgs;
initProperties();% 初始化水平方向和垂直方向的投影,以及行信息和段信息
func_charsReflow();
imshow(imgs.perview);
%% 文字回流(重排)
function func_charsReflow()
global properties;
global CONFIG;
global PARA;
global PAGE;
global imgs;
%新建图像
s_size = size(properties.section,1);
% imgs.output = uint8(zeros(ceil(CONFIG.height),ceil(CONFIG.width)));
% imgs.output = 255-imgs.output;
% x = CONFIG.x;
% y= CONFIG.y;
x = imgs.x;%上一次保留的x y
y = imgs.y;
for i = 1:s_size
    sp =properties.section(i,:);
    T = sp(5);
    %首行缩进
    if(T~=0)%缩进保留或是缩减两个字符
        y = floor(y+CONFIG.Fx*PAGE.WIDTH*sp(5));
    else
        y = floor(y+CONFIG.text_indent);
    end
    if(sp(6)==1)%如果是图片段
        if(CONFIG.height-CONFIG.padding < x+sp(4)*CONFIG.Fx)%另起一页
            %         figure;imshow(imgs.output);title('section reflow');
            [x,~]=func_newPage();
        end
        [x,y]=func_append(x,y,sp(1:4),'section');
    else
        %遍历每个字符
        for row =sp(7):sp(8)%遍历每一行
            chars = properties.charsAtRows{row};
            c_size = size(chars,1);
            for n = 1:c_size%遍历所有字符
                %换行或换页
                if(y+chars(n,3)*CONFIG.Fx*CONFIG.Fy > CONFIG.width-CONFIG.padding)%是否需要换行
                    [x,y] = func_newline(x,y,chars(n,4)*CONFIG.Fx*CONFIG.Fy);
                    x = ceil(x+ PARA.LINE_SPACING*CONFIG.Fx*CONFIG.line_spacing);
                end
                if(CONFIG.height-CONFIG.padding < x+chars(n,4)*CONFIG.Fx*CONFIG.Fy)%另起一页
                    [x,y]=func_newPage();
                end
                %非首行是否缩进保留
                if(y==CONFIG.y&&T~=0)% 新的一行,需不需要缩进保留
                    y = floor(y+CONFIG.Fx*PAGE.WIDTH*sp(5));
%                     y = floor(y+PARA.ONE_CHAR_WIDTH*CONFIG.Fx*CONFIG.Fy);%再额外缩进一个字符
                end
                [x,y]=func_append(x,y,chars(n,1:4),'char');%cur
                y = ceil(y+chars(n,3)*CONFIG.Fx*CONFIG.Fy++CONFIG.gap*properties.gapsAtRows{row}(n)*CONFIG.Fx);%字体间隔
            end
        end
    end

    % 换行, 图片换行以及段换行, 解决行距问题
    if(sp(6)==1)
        [x,y]=func_newline(x,y,sp(4)*CONFIG.Fx);
%         x = floor(x+CONFIG.line_spacing*0.5);
    else%换行换的是最后一行的高度
        h = properties.allRows(sp(8),2)-properties.allRows(sp(8),1)-1;
        [x,y]=func_newline(x,y,h*CONFIG.Fx*CONFIG.Fy);
%         x = ceil(x+ CONFIG.line_spacing);
    end
    to = sp(8);
    x = ceil(x+properties.lineSpacings(to)*CONFIG.Fx*CONFIG.line_spacing);
end
 imgs.x = x;
 imgs.y = y;
%% 另起一页
function[x,y] = func_newPage()
global imgs;
global CONFIG;
global UI;
if(isfield(imgs,'output')&&isempty(imgs.perview)==1)
     imgs.perview = imgs.output;
end
if(UI.isOutput==1)
    func_save(UI.outURL,strcat('p',num2str(imgs.p)),'jpg');
    imgs.p= imgs.p+1;
end
imgs.output = uint8(zeros(CONFIG.height,CONFIG.width));
imgs.output = 255-imgs.output;
x=CONFIG.x;
y=CONFIG.y;
%% 将矩阵保存为图片
function func_save(url,name,type)
global imgs;
% 文件,地址, 文件名, 保存类型
if(url(length(url))=='/')
    url(length(url))=[];
end
imwrite(imgs.output,strcat(url,'/',name,'.',type),type);
%% 将图片的小部分添加到输出图片中
function[x,y]=func_append(x,y,position,type)
% @输入
% x,y为光标左上角坐标
% position[sx,sy,sw,sh]代表欲加图片的左上角坐标和宽高
% type为添加类型(文字或者段落)
% @return
% x,y, 添加图片后新光标位置
global CONFIG;
global imgs;
%!!!注意,properties.section里因为涉及到左上角x,y坐标,所以x是图片的x轴,即横轴,因此要倒过来用
% sx=uint16(ceil(position(2)));sy=uint16(ceil(position(1)));sw=uint16(ceil(position(3)));sh=uint16(ceil(position(4)));
sx=position(2);sy=position(1);sw=position(3);sh=position(4);

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
%         y = ceil(y+sw+CONFIG.gap);
end
%% 根据传入高度换行返回新的坐标
function[x,y]=func_newline(x,~,height)
global CONFIG;
y= CONFIG.y;
x=x+height;

%% 初始化水平方向和垂直方向的投影,以及行信息和段信息
function initProperties()
global imgs;
global properties;
global projection;
% figure;imshow(imgs.b);
% figure;imshow(func_getThePartOf(PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT));
projection.ver = func_projectTo(imgs.b,'vercial');%投影到垂直方向
% figure;plot(projection.ver,1:length(projection.ver));title('垂直方向像素');set(gca,'ydir','reverse');
getRowProperty();
% func_showDivisiveImg(properties.allRows,'line');%显示行切割
getRowsProjection();%获得每一行水平方向的投影,保存到projection.allRows
getSectionProperty();%获得段切割信息
% func_showDivisiveImg(properties.section,'rectangle');%显示段切割
getCharsProperty();
%% 获得每个字符的信息
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
%% 对第row行进行切割
function split(row)
global projection;
global properties;
global PARA;
hor =projection.allRows{row};
[left,right] = func_getEdge(hor,'字符');
w= right-left;
n = size(left,2);
blank = zeros(1,n);
blank(2:n) = left(2:n)-right(1:end-1);
i =2;
while(i<=n)
    if(w(i)<PARA.ONE_CHAR_WIDTH&&blank(i)<PARA.GAP*0.8)
        left(i)=0;
        right(i-1)=0;
    end
    i=i+1;
end
left(left==0)=[];
right(right==0)=[];
w = right-left;

% 转换为charProperty
n = size(w,2);
properties.charsAtRows{row}=zeros(n,4);
properties.charsAtRows{row}(:,1) = left(:);
properties.charsAtRows{row}(:,2) = properties.allRows(row,1);
properties.charsAtRows{row}(:,3) = w(:);
properties.charsAtRows{row}(:,4) = properties.allRows(row,2)-properties.allRows(row,1)-1;
% 记录空白
properties.gapsAtRows{row} = zeros(1,size(left,2));
properties.gapsAtRows{row}(1:end-1) = left(2:end)-right(1:end-1);
% showRow(row);

% 
% temp = uint8(projection.allRows{row});
% c = size(temp,2);
% 
% % 输入
% 行投影(改255,0),行信息
% result = zeros(1, c);
% 获得字符左右边界[闭区间]
% index = 1;
% for y = 1 : c - 1
%     if (temp(1, y) == 0 && temp(1, y + 1) == 255)
%         result(1, index) = y + 1;
%         index = index + 1;
%     elseif (temp(1, y) == 255 && temp(1, y + 1) == 0)
%         result(1, index) = y;
%         index = index + 1;
%     end
% end
% 
% result(index : c) = [];
% result = fixChars(result);
% 
% [~, c] = size(result);
% index = 2;
% while (index < c)%英文字符之类的合并
%     if (result(1, index) - result(1, index - 1) <= PARA.GAP)
%         result(index - 1 : index) = [];
%         c = c - 2;
%     end
%     index = index + 1;
% end
% % 输出
% result 每对元素标记字符的左右边界
% 转换为charProperty
% n = size(result,2);
% properties.charsAtRows{row}=zeros(n/2,4);
% c = 1;
% for i=1:2:n-1
%     x = result(i);
%     y = properties.allRows(row,1);
%     w = result(i+1)-x+1;
%     h = properties.allRows(row,2)-properties.allRows(row,1)-1;
%     properties.charsAtRows{row}(c,:)=[x,y,w,h];
%     c=c+1;
% end
% func_showDivisiveImg(properties.charsAtRows{row},'rectangle');%show

%% 修复字符之间的断裂, 比如说 如 比
function[arr] = fixChars(arr)
global PARA;

%% 输入
% 标准字符宽度
% 合并，例如  如  即  这些字
[~, c] = size(arr);
x = 2;
while (x < c - 2)%合并可以改进
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

%% 图像中显示各种分割线
function  func_showDivisiveImg(properties,type)
% 输入
% img            输入图像
% properties  图像相关的分割信息
% type           显示类型
global PAGE;
% [M,N,O]=size(img);
n = size(properties,1);
switch type
    case 'line'
        line([PAGE.LX,PAGE.RX],[properties(:,1),properties(:,1)]);
        line([PAGE.LX,PAGE.RX],[properties(:,2),properties(:,2)]);
    case 'rectangle'
        %rectangle('Position',temp,'LineWidth',2,'LineStyle','-','edgecolor','b')
        if(size(properties,2)==8)%段落
            for i=1:n
                color ='g';
                if(properties(i,6)~=0)
                   color = 'r';
                elseif(properties(i,5)~=0)
                   color = 'b';
                end
                position=properties(i,1:4);%注意,矩阵的x是竖轴和图像的x是横
                rectangle('Position',position,'edgecolor',color);
            end
        else
             for i=1:n%字符
                position=properties(i,1:4);%注意,矩阵的x是竖轴和图像的x是横
                rectangle('Position',position,'edgecolor',[rand,rand,rand]);
            end
        end
end
%% 计算行行首空格数
function [head_blank,tail_blank]=trim(row)
global projection;%每一行的水平投影

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
%% 把行中合并成段,图片自成一段
function getSectionProperty()
% s段落数
% properties.section: 段信息
%---------- 它是一个s行8列数组,结构如下
%----------  [x,y,w,h,T,P,from,to]
%----------  分别是
%----------  position   :  x,y,w,h 左上角坐标,宽高
%----------  flag          :  T 缩进保留   P 是否图片
%----------  from-to    :  from  启始行      to 结束行
global PAGE;
global PARA;
global properties;
row =size(properties.allRows,1);
s = 1;
properties.section = zeros(row,8);
properties.tableFlag = 0;
last_head_blank = 0;
last_tail_blank = 0;
last_buttom = 0;
for i = 1:row     
%     if(i == 21)
%          showRow(i);
% % % %          figure;imshow(func_getThePartOf('binary',x,y,w,h));
%      end
    [head_blank,tail_blank] = trim(i);%计算开头的空白长度
    x = head_blank+1;
    y= properties.allRows(i,1)+1;
    h = properties.allRows(i,2)-properties.allRows(i,1)-1;
    w=tail_blank-head_blank-1;
    if(isImgSection(i,x,y,w,h)==1)%是否为图片段
        properties.section(s,:)=[x,y,w,h,head_blank/PAGE.WIDTH,1,i,i];%新建一段
        s=s+1;
    else%非图片段
        if(head_blank-PAGE.SAFE> PARA.ONE_CHAR_WIDTH)%大于一个标准字符大小
            properties.section(s,:)=[x,y,w,h,0,0,i,i];%认为是新的一段
            if(head_blank-PAGE.SAFE>PARA.ONE_TAB_WIDTH*1.4)%大于一个标准缩进值update 英文的话这里可能要改
                properties.section(s,5)=head_blank/PAGE.WIDTH;%计算它相对缩减值
                if(properties.tableFlag==1)%表格标记,全部标记图片
                    properties.section(s,6)=1;
                end
                %                 showRow(i); tag
            else%知道遇到正常缩进, 表格标记结束
                properties.tableFlag=0;
            end
            s=s+1;
        else%无空格, 那么这一行和上一段合并
            if(isClassTitle(w,h,last_tail_blank,y-last_buttom)==1)%小标题判断
                properties.section(s, :)=[x,y,w,h, 0, 0, i, i];
                s=s+1;  
                properties.tableFlag = 0;
            elseif(s==1 || properties.section(s-1,6)==1)%上一段是否为图片update
                if(properties.tableFlag==1)
                   properties.section(s,:)=[x,y,w,h,head_blank/PAGE.WIDTH,1,i,i];
                else
                    properties.section(s, :)=[x,y,w,h, 0, 0, i, i];
                end
                s=s+1;%tag
%             elseif(isClassTitle(w,h,last_tail_blank,y-last_buttom)==1)%小标题判断
%                 properties.section(s, :)=[x,y,w,h, 0, 0, i, i];
%                 s=s+1;                    
            else%非图片,合并
                %宽度的更新
                if(last_head_blank>PARA.ONE_CHAR_WIDTH)%两行的情况
                    properties.section(s-1,3)=properties.section(s-1,3)+last_head_blank-head_blank;
                end
                if(w>properties.section(s-1,3))%更新成最大的
                    properties.section(s-1,3)=w;
                end
                properties.section(s-1,5)=0;%计算它相对缩减值
                properties.section(s-1,1) = min([x,properties.section(s-1,1)]);%x的更新,更新成最小的
                properties.section(s-1, 4)=properties.allRows(i,2)-properties.section(s-1,2);
                properties.section(s-1,8) = i;
            end
        end
    end
    last_head_blank = head_blank;
    last_tail_blank = PAGE.WIDTH-tail_blank-PAGE.SAFE+1;
    last_buttom = properties.allRows(i,2);
end
properties.section(s:end,:)=[];
%% 获得每一行水平方向的投影,保存到projection.allRows
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

%% 从垂直投影中获得行信息
function getRowProperty()
% properties.allRows 为每行的上下边界的位置
%                      它的结构为[up, buttom], 即第x行, 上边界为up,下边界为buttom
global projection;
global properties;
global PARA;
% row = 0;
% len = size(projection.ver,1);
% 
% properties.allRows=zeros(len,2);
% i = 1;
% while (i<=len)
%     if (projection.ver(i)~=0)
%         row = row+1;
%         properties.allRows(row,1)=i-1;
%         while(projection.ver(i)~=0&&i<len) 
%             i=i+1;
%         end;
%         properties.allRows(row,2)=i;
%     end
%     i=i+1;
% end
% properties.allRows(row+1:end,:)=[];
[left,right]=func_getEdge(projection.ver','行');
% properties.allRows(:,1)=left(:)-1;
% properties.allRows(:,2) =right(:);
%去躁点或者定筛选值???无需再考虑
%需要考虑, 有亮点存在update  再考虑ver
w =right-left;
idx =w<PARA.ONE_ROW_HEIGHT*0.1;
n =size(idx,2);
for i=1:n
    if(idx(i)&&sum(projection.ver(left(i):right(i)))>255*PARA.ONE_TAB_WIDTH*2)
        idx(i)=0;
    end
end
right(idx) =[];
left(idx) =[];
properties.allRows=zeros(size(left,2),2);
properties.allRows(:,1)=left(:)-1;
properties.allRows(:,2) =right(:);
properties.lineSpacings= zeros(1,size(left,2));
properties.lineSpacings(1:end-1)=left(2:end)-right(1:end-1);
%% 水平方向或垂直方向的投影
function[arr]=func_projectTo(img,type)
% @输入
% imb    图像
% type   投影类型
% @返回
% arr      投影结果
if(strcmp(type,'horizontal'))
    arr =sum(img(:,:));%二重循环投影的矩阵运算
else
    img = img';
    arr = sum(img(:,:));
    arr=arr';
end
%% 判断某一行是否为图片
function [flag] =isImgSection(idx,x,~,~,h)
global PARA;
global projection;
global properties;
flag = 0;
hor = projection.allRows{idx};
%从行的高度判断
if(h>PARA.ONE_ROW_HEIGHT*1.7) 
    flag = 1;
else
%     figure;imshow(func_getThePartOf('binary',x,y,w,h));
    len = min(size(hor,2),x+size(PARA.TFTOOL,2)-1);
    hor = hor(1,x:len);
    tmp =and(hor,PARA.TFTOOL);
    blank = find(tmp==0);
%     if(length(blank)<PARA.ONE_CHAR_WIDTH*0.05)%tag
    if(length(blank)<PARA.GAP)
        flag=1;
        properties.tableFlag =1;%表格开始标记 tag
    end
end
%% 判断是否是小标题
function[flag] =isClassTitle(w,h,last_tail_blank,last_spacing)
% w行宽
% h行高度
% last_tail_blank上一行末空白
% last_spacing 和上一行的行距
global PARA;
global PAGE;
rel =PAGE.WIDTH-PAGE.SAFE-PARA.ONE_TAB_WIDTH;
if(w>rel)
    flag = 0;
elseif(h>PARA.ONE_ROW_HEIGHT*1.25)
    flag = 1;
elseif(last_spacing>PARA.LINE_SPACING*1.9)
    flag =1;
elseif(last_tail_blank>PARA.ONE_TAB_WIDTH)
    flag =1;
else
    flag = 0;
end
%% 取得连续1或连续0的左右坐标
function[left,right]=func_getEdge(arr,type)
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
%% 显示某一行,debug用
function showRow(i)
global properties;
global imgs;
x =1;
y= properties.allRows(i,1)+1;
h = properties.allRows(i,2)-properties.allRows(i,1)-1;
w=size(imgs.b,2);
figure;imshow(func_getThePartOf('binary',x,y,w,h));
%% 测试用方法, 读入数据
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

%% 没用的方法

function gap_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
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
function section_reflow_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to section_reflow_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of section_reflow_checkbox
