%% 段落划分
function secion_division_main()
global LX;% 页面左边界
global RX;% 页面右边界
global PWIDTH;% 页面宽
global ONE_CHAR_WIDTH;% 统计参数 一个中文字符的标准宽
global ONE_TAB_WIDTH;% 统计参数 一个首行缩进的标准宽
global ONE_ROW_HEIGHT;% 统计参数 一行的标准高
global rows_hor_projection;%每一行的水平投影
img = imread('test\MATLAB编程入门教程_页面_05.jpg');
[M,N] = size(img);
ima =img;
if (size(img,3) ~= 1)
    ima = func_imgToGray(img);%转灰度图
end
imb = func_imgToBin(ima);%二值化
func_getRealWidth(imb);%基本参数赋值
func_statisticalParameter();%基本参数赋值
ver = func_projectTo(imb,'vercial');%投影到垂直方向
% figure;plot(ver,1:M);title('垂直方向像素');set(gca,'ydir','reverse');
[row,row_property]= func_getRowProperty(ver);%从垂直投影中获得行信息
func_showDivisiveImg(img,row_property,'line');%显示行切割
func_getRowsProject(imb,row_property,row);%获得每一行水平方向的投影,保存到rows_hor_projection
[s,section_property]=getSectionProperty(imb,row_property,row);
func_showDivisiveImg(img,section_property,'rectangle');%显示段切割
%% 获得每一行水平方向的投影,保存到rows_hor_projection
function func_getRowsProject(img,rp,row)
global LX;
global PWIDTH;
global rows_hor_projection;
rows_hor_projection = cell(1,row);
for i = 1:row
    h = rp(i,2)-rp(i,1)-1;
    imp = func_getThePartOf(img,rp(i,1)+1,LX+1,PWIDTH,h);
    rows_hor_projection{i}=func_projectTo(imp,'horizontal');
end
%% 根据左上角坐标和长宽取出图像的一部分
function[imp]=func_getThePartOf(img,x,y,w,h)
% 输入
% img 原图
% xy 左上角坐标
% wh 宽和高
imp = img(x:x+h-1,y:y+w-1);
%% 把行中合并成段,图片自成一段
function [s,sp]=getSectionProperty(img,rp,row)
% @输入
% imb图像
% rp行信息
% row行数
% @return
% s段落数
% sp: section_property段信息
%                          它是一个s行6列数组,结构如下
%                           边界          1:  上边界      2:  下边界
%                           标志          3:  缩进保留   4:  图片标志
%                           包括行       5:  启始行      6:  结束行
global PWIDTH;
global ONE_CHAR_WIDTH;
global ONE_TAB_WIDTH;
s = 1;
sp = zeros(row,6);
for i = 1:row
    if(isImgSection(rp(i,:))==1)%是否为图片段
        head_blank = calcuBlank(i,rp(i,:));
        sp(s,:)=[rp(i,1),rp(i,2),head_blank/PWIDTH,1,i,i];%新建一段
        s=s+1;
    else%非图片段
        head_blank = calcuBlank(i,rp(i,:));%计算开头的空白长度
        if(head_blank> ONE_CHAR_WIDTH)%大于一个标准字符大小
            sp(s,:)=[rp(i,1),rp(i,2),0,0,i,i];%认为是新的一段
            if(head_blank>ONE_TAB_WIDTH)%大于一个标准缩进值
                sp(s,3)=head_blank/PWIDTH;%计算它相对缩减值
            end
            s=s+1;
        else%无空格, 那么这一行和上一段合并
            if(s==1 || sp(s-1,4)==1)%上一段是否为图片
                sp(i, :)=[rp(i,1), rp(i,2), 0, 0, i, i];
                s=s+1;
            else%非图片,合并
                sp(s-1, 2)=rp(i,2);
                sp(s-1,6) = i;
            end
        end
    end
end
sp(s:end,:)=[];
s=s-1;
%% 计算行行首空格数
function [head_blank]=calcuBlank(row,up,bottom)
global rows_hor_projection;%每一行的水平投影
hor = rows_hor_projection{row};
head_blank =1;
while(hor(head_blank)==0)
    head_blank=1+head_blank;
end
head_blank=head_blank-1;
%% 判断某一行是否为图片
function [flag] =isImgSection(rp)
global ONE_ROW_HEIGHT;
up = rp(1);
bottom=rp(2);
flag = 0;
%从行的高度判断
h = bottom-up-1;
if(h>ONE_ROW_HEIGHT*1.5) 
    flag = 1;
end;
%从行的连续性判断todo
%% 统计样本,计算出基本参数的值
function func_statisticalParameter()
%todo 先使用固定值替代
global ONE_CHAR_WIDTH;% 统计参数 一个中文字符的标准宽
global ONE_TAB_WIDTH;% 统计参数 一个首行缩进的标准宽
global ONE_ROW_HEIGHT;% 统计参数 一行的标准高
ONE_CHAR_WIDTH = 23;
ONE_TAB_WIDTH =  round(ONE_CHAR_WIDTH*3.5);
ONE_ROW_HEIGHT=32;
%% 查找合适的页面宽
function func_getRealWidth(imb)
% @输出
% LX,RX为左右边界的x坐标
% width为左右的宽度(这里取最大值)
global LX;% 页面左边界
global RX;% 页面右边界
global PWIDTH;% 页面宽
hor = func_projectTo(imb,'horizontal');
% figure;plot(1:length(hor),hor);title('垂直方向像素');
LX=1;
RX=length(hor);
while(hor(LX)==0) LX=LX+1;end;
while(hor(RX)==0) RX=RX-1;end;
LX =LX-1;
RX=RX-1;
PWIDTH=RX-LX-1;
%% 图像中显示各种分割线
function  func_showDivisiveImg(img,properties,type)
% 输入
% img            输入图像
% properties  图像相关的分割信息
% type           显示类型
global LX;
global RX;
global PWIDTH;
figure;imshow(img);set(gca,'position',[0,0,1,1]);
% [M,N,O]=size(img);
n = size(properties,1);
switch type
    case 'line'
        line([LX,RX],[properties(:,1),properties(:,1)]);
        line([LX,RX],[properties(:,2),properties(:,2)]);
    case 'rectangle'
        %rectangle('Position',temp,'LineWidth',2,'LineStyle','-','edgecolor','b')
        for i=1:n
            x = LX+1;
            y = properties(i,1)+1;
            width = PWIDTH;
            height=properties(i,2)-properties(i,1)-1;
            position=[x,y,width,height];
            rectangle('Position',position,'edgecolor','g');
        end
end
%% 从垂直投影中获得行信息
function[row,row_property]=func_getRowProperty(ver)
% @return
% row                为实际行数
% row_property 为每行的上下边界的位置
%                      它的结构为[up, buttom], 即第x行, 上边界为up,下边界为buttom
row = 0;
len = size(ver,1);
row_property=zeros(len,2);
i = 1;
while (i<=len)
    if (ver(i)~=0)
        row = row+1;
        row_property(row,1)=i-1;
        while(ver(i)~=0) 
            i=i+1;
        end;
        row_property(row,2)=i;
    end
    i=i+1;
end
row_property(row+1:end,:)=[];

%% 水平方向或垂直方向的投影
function[arr]=func_projectTo(img,type)
% @输入
% imb    图像
% type   投影类型
% @返回
% arr      投影结果
if(strcmp(type,'horizontal'))
    img = img';
end
M=size(img,1);
arr=zeros(M,1);
for i = 1:M
     arr(i) = sum(img(i,:));
end
if(strcmp(type,'horizontal'))
    arr=arr';
end
%% 转灰度图
function[im2]= func_imgToGray(img)
if (size(img,3) ~= 1)                % 要求输入图像为单通道灰度图像
    im2        = rgb2gray(img);
end

%% 二值化图像
function[im2]= func_imgToBin(img)
img            = 255 - img;          % 针对白纸黑字的情况
im2            = double(img);
trd            = 1.3 * mean(im2(:)); % 固定阈值
im2(im2 > trd) = 255;                % 阈值分割
im2(im2 <=trd) = 0;
im2=uint8(im2);
    
    