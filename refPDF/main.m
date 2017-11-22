
%% 段落划分
function main()
clc;
close all;
clear all;
%% 以下是全局参数说明,参数为结构体,包含各种子参数
global PAGE;
% PAGE 实际包含内容的页面信息, 左右边界以及实际内容宽度,包含
%--LX 实际内容左边界tag
%--LY 实际内容右边界
%--WIDTH 实际内容的宽度
global PARA;
% PARA 统计参数,经过统计得来的一些页面相关参数,包含
%--ONE_CHAR_WIDTH   一个中文字符的标准宽
%--ONE_TAB_WIDTH      一个首行缩进的标准宽
%--ONE_ROW_HEIGHT   一行的标准高
%--ROW_SPACING  行间隔
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
global properties;
% properties是行分割,段分割的相关信息, 包含
%--row:  行信息
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
global padding;


% imgs.o = imread('page.jpg');
% imgs.o = imread('test/MATLAB编程入门教程_页面_11.jpg');
imgs.o = imread('test/ita1 (3).jpg');
% imgs.o = imread('test/页面提取自－《算法（第四版）.中文版.图灵程序设计丛书》Algorithms_2.jpg');
imgs.g =imgs.o;
if (size(imgs.o,3) ~= 1)
    imgs.g = func_imgToGray(imgs.o);%转灰度图
end
imgs.b = func_imgToBin(imgs.g);%二值化
figure;imshow(imgs.g);set(gca,'position',[0,0,1,1]);%显示图像
getInteretingContentSize();%计算感兴趣区域页面宽度,左右边界
func_statisticalParameter();%基本参数统计求均值
initProperties();% 初始化水平方向和垂直方向的投影,以及行信息和段信息
padding = 10;
func_sectionReflow(1000,1000);%基于段切分的重排
% figure;imshow(imgs.output);
%% 初始化水平方向和垂直方向的投影,以及行信息和段信息
function initProperties()
global imgs;
global properties;
global projection;
projection.ver = func_projectTo(imgs.b,'vercial');%投影到垂直方向
% figure;plot(ver,1:M);title('垂直方向像素');set(gca,'ydir','reverse');
getRowProperty();
% func_showDivisiveImg(properties.row,'line');%显示行切割
getRowsProjection();%获得每一行水平方向的投影,保存到projection.allRows
getSectionProperty();%获得段切割信息
func_showDivisiveImg(properties.section,'rectangle');%显示段切割

%% 基于段落重排的切边
function func_sectionReflow(w,h)
global imgs;
global PAGE;
global PARA;
global properties;
global padding;%todo 用户设置参数集合
%新建图像
oh = h;ow=w;%含边距宽高
imgs.output = uint8(zeros(oh,ow));
imgs.output = 255-imgs.output;
p =1;
%指定分辨率
x = padding+1;
y= padding+1;
w = w -2*padding;
h = h -2*padding;
f=w/PAGE.WIDTH;
s = size(properties.section,1);
for i = 1:s
    if(h+padding < x+properties.section(i,4)*f)%另起一页
%         figure;imshow(imgs.output);title('section reflow');
        func_save(imgs.output,'output',strcat('p',num2str(p)),'jpg');
        p= p+1;
        imgs.output = uint8(zeros(oh,ow));
        imgs.output = 255-imgs.output;
        x=padding+1;
        y=padding+1;
    end

    if(properties.section(i,5)~=0)
        y = floor(y+f*PAGE.WIDTH*properties.section(i,5));
    elseif(properties.section(i,4)<2*PARA.ONE_ROW_HEIGHT)
        y = y+PARA.ONE_TAB_WIDTH*f;
    end
    [x,y]=func_append(x,y,properties.section(i,1:4),'section',f);
end
%% 将矩阵保存为图片
function func_save(img,url,name,type)
% 文件,地址, 文件名, 保存类型
if(url(length(url))=='/')
    url(length(url))=[];
end
imwrite(img,strcat(url,'/',name,'.',type),type);
%% 将图片的小部分添加到输出图片中
function[x,y]=func_append(x,y,position,type,f)
% @输入
% x,y为光标左上角坐标
% position[sx,sy,sw,sh]代表欲加图片的左上角坐标和宽高
% type为添加类型(文字或者段落)
% @return
% x,y, 添加图片后新光标位置
global PARA;
global imgs;
%!!!注意,properties.section里因为涉及到左上角x,y坐标,所以x是图片的x轴,即横轴,因此要倒过来用
sx=position(2);sy=position(1);sw=position(3);sh=position(4);
%线性缩放
imrs = imresize(imgs.g(sx:(sx+sh-1),sy:(sy+sw-1)),f);
% imrs = imgs.g(sx:(sx+sh-1),sy:(sy+sw-1));
[sh,sw]=size(imrs);
switch type
    case 'section'
        imgs.output(x:(x+sh-1),y:(y+sw-1))=imrs(:,:);
        x = round(x+PARA.ROW_SPACING*f);
        [x,y] = func_newline(x,y,sh);
    case 'char'%todo
end
%% 根据传入高度换行返回新的坐标
function[x,y]=func_newline(x,y,height)
global padding;
y=padding+1;
x=x+height;
%% 获得每一行水平方向的投影,保存到projection.allRows
function getRowsProjection()
global PAGE;
global projection;
global properties;
row = size(properties.row,1);
projection.allRows = cell(1,row);
for i = 1:row
    h = properties.row(i,2)-properties.row(i,1)-1;
    imp = func_getThePartOf(properties.row(i,1)+1,PAGE.LX+1,PAGE.WIDTH,h);
    projection.allRows{i}=func_projectTo(imp,'horizontal');
end
%% 根据左上角坐标和长宽取出图像的一部分
function[imp]=func_getThePartOf(x,y,w,h)
% 输入 todo x y逻辑上不太对,对于使用者来说,是图片xy,内部才是矩阵xy
% xy 左上角坐标
% wh 宽和高
global imgs;
x=uint64(x);y=uint64(y);w=uint64(w);h=uint64(h);%matlab中似乎没有自动取最大变量类型,预防万一
imp = imgs.b(x:x+h-1,y:y+w-1);
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
row =size(properties.row,1);
s = 1;
properties.section = zeros(row,8);
last_blank = 0;
for i = 1:row
    [head_blank,tail_blank] = trim(i);%计算开头的空白长度
    x = PAGE.LX+head_blank+1;
    y= properties.row(i,1)+1;
    h = properties.row(i,2)-properties.row(i,1)-1;
    w=tail_blank-head_blank+1;
%      if(i == 6)
%          s
%          figure;imshow(func_getThePartOf(y,x,w,h));
%      end
    if(isImgSection(i,x,y,w,h)==1)%是否为图片段
        properties.section(s,:)=[x,y,w,h,head_blank/PAGE.WIDTH,1,i,i];%新建一段
        s=s+1;
    else%非图片段
        if(head_blank> PARA.ONE_CHAR_WIDTH)%大于一个标准字符大小
            properties.section(s,:)=[x,y,w,h,0,0,i,i];%认为是新的一段
            if(head_blank>PARA.ONE_TAB_WIDTH)%大于一个标准缩进值
                properties.section(s,5)=head_blank/PAGE.WIDTH;%计算它相对缩减值
            end
            s=s+1;
        else%无空格, 那么这一行和上一段合并
            if(s==1 || properties.section(s-1,6)==1)%上一段是否为图片
                properties.section(s, :)=[x,y,w,h, head_blank/PAGE.WIDTH, 0, i, i];
                s=s+1;
            else%非图片,合并
                %宽度的更新
                if(last_blank>PARA.ONE_CHAR_WIDTH)%两行的情况
                    properties.section(s-1,3)=properties.section(s-1,3)+last_blank;
                end
                if(w>properties.section(s-1,3))%更新成最大的
                    properties.section(s-1,3)=w;
                end
                properties.section(s-1,5)=0;%计算它相对缩减值
                properties.section(s-1,1) = min([x,properties.section(s-1,1)]);%x的更新,更新成最小的
                properties.section(s-1, 4)=properties.row(i,2)-properties.section(s-1,2);
                properties.section(s-1,8) = i;
            end
        end
    end
    last_blank = head_blank;
end
properties.section(s:end,:)=[];
% s=s-1;
%% 计算行行首空格数
function [head_blank,tail_blank]=trim(row)
%todo debug hor取的是截取后的,而hb访问的却是全图的因此会出错
global projection;%每一行的水平投影
global PAGE;
hor = projection.allRows{row};
head_blank =1;
showRow(1);

while(hor(head_blank)==0)
    head_blank=1+head_blank;
end
i = size(hor,2);
while(hor(i)==0)
    i=i-1;
end
tail_blank=i;
%% 显示某一行,debug用
function showRow(i)
global properties;
global imgs;
x =1;
y= properties.row(i,1)+1;
h = properties.row(i,2)-properties.row(i,1)-1;
w=size(imgs.b,2);
figure;imshow(func_getThePartOf(y,x,w,h));
%% 判断某一行是否为图片
function [flag] =isImgSection(idx,x,y,w,h)
global PARA;
global projection;
flag = 0;
hor = projection.allRows{idx};
%从行的高度判断
if(h>PARA.ONE_ROW_HEIGHT*1.5) 
    flag = 1;
else
%     figure;imshow(func_getThePartOf(y,x,w,h));
    hor = hor(1,x:x+size(PARA.TFTOOL,2)-1);
    tmp =and(hor,PARA.TFTOOL);%cur
    blank = find(tmp==0);
    if(length(blank)<PARA.ONE_CHAR_WIDTH*0.05)
        flag=1;
    end
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
row = 0;
len = size(ver,1);
rp=zeros(len,2);
i = 1;
while (i<=len)
    if (ver(i)~=0)
        row = row+1;
        rp(row,1)=i-1;
        while(ver(i)~=0) 
            i=i+1;
        end;
        rp(row,2)=i;
    end
    i=i+1;
end
rp(row+1:end,:)=[];

% 中间三分之一求平均值法
% PARA.ONE_ROW_HEIGHT
tmp =rp(:,2)-rp(:,1)-1;
PARA.ONE_ROW_HEIGHT = round(func_getStatistcalAVG(tmp));
% PARA.ONE_CHAR_WIDTH
idx = find(tmp==uint32(median(tmp)));
i = idx(ceil(length(idx)/2));
%%% figure;imshow(func_getThePartOf(rp(i,1)+1,PAGE.LX,PAGE.WIDTH,tmp(i)));
hor = func_projectTo(func_getThePartOf(rp(i,1)+1,PAGE.LX,PAGE.WIDTH,tmp(i)),'horizontal');%获得这一行的水平投影
%%% figure;plot(1:length(hor),hor);title('垂直方向像素');
i = 1;
num=1;
tmp = zeros(1,200);%记录字符宽
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
PARA.ONE_TAB_WIDTH =  round(PARA.ONE_CHAR_WIDTH*2.6);
%PARA.ROW_properties.ROW_SPACING
row = size(rp,1);
tmp = zeros(1,row-1);
for i = 2:row
    tmp(i-1)=rp(i,1)-rp(i-1,2);
end
PARA.ROW_SPACING = floor(func_getStatistcalAVG(tmp));
% TFTOOL 检测小工具
PARA.TFTOOL = uint8(ones(1,floor(PARA.ONE_CHAR_WIDTH*3.5)));
%% 求一个数组中间三分之一上下取整区间的平均值
function[result]=func_getStatistcalAVG(tmp)
n = length(tmp);
left = floor(n/3);right = ceil(n/3*2);
tmp =sort(tmp);
result = mean(tmp(left:right));
%% 计算正文内容的宽高
function getInteretingContentSize()
% 用户截取的感兴趣区域图像部分(todo)
global PAGE;
global imgs;
pos = [1,1,size(imgs.b,2),size(imgs.b,1)];
h=imrect;%鼠标变成十字，用来选取感兴趣区域
%点击ok之后继续todo gui的时候要修改
pos=getPosition(h);%图中就会出现可以拖动以及改变大小的矩形框，选好位置后：
pos=uint16(pos);%pos有四个值，分别是矩形框的左下角点的坐标 x y 和 框的 宽度和高度
%注意上面是图像的x,y, 下面矩阵要用应该交换一下

 %  宽度tag
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
PAGE.LX = PAGE.LX-20;%上下左右20px的安全区域
PAGE.RX = PAGE.RX+20;%上下左右20px的安全区域
PAGE.WIDTH=PAGE.RX-PAGE.LX-1;
% 高度
ver = func_projectTo(imgs.b,'vertical');
PAGE.UY=pos(2);
PAGE.DY=pos(2)+pos(4)-1;
while(ver(PAGE.UY)==0) 
    PAGE.UY=PAGE.UY+1;
end;
while(ver(PAGE.DY)==0) 
    PAGE.DY=PAGE.DY-1;
end;
PAGE.UY = PAGE.UY-20;%上下左右20px的安全区域
PAGE.DY = PAGE.DY+20;%上下左右20px的安全区域
PAGE.HEIGHT=PAGE.DY-PAGE.UY-1;
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
                color ='g';%cur
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
                rectangle('Position',position,'edgecolor','g');
            end
        end
end
%% 从垂直投影中获得行信息
function getRowProperty()
% properties.row 为每行的上下边界的位置
%                      它的结构为[up, buttom], 即第x行, 上边界为up,下边界为buttom
global projection;
global properties;
row = 0;
len = size(projection.ver,1);
properties.row=zeros(len,2);
i = 1;
while (i<=len)
    if (projection.ver(i)~=0)
        row = row+1;
        properties.row(row,1)=i-1;
        while(projection.ver(i)~=0) 
            i=i+1;
        end;
        properties.row(row,2)=i;
    end
    i=i+1;
end
properties.row(row+1:end,:)=[];
% tmp =properties.row(:,2)-properties.row(:,1);
% idx = tmp<7;去躁点或者定筛选值???无需再考虑
% properties.row(idx,:)=[];
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
    
    