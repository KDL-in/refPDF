%% 段落划分
function secion_division_main()
global LX;% 页面左边界
global RX;% 页面右边界
global PWIDTH;% 页面宽
global ONE_CHAR_WIDTH;% 统计参数 一个中文字符的标准宽
global ONE_TAB_WIDTH;% 统计参数 一个首行缩进的标准宽
global ONE_ROW_HEIGHT;% 统计参数 一行的标准高
global rows_hor_projection;%每一行的水平投影
global img_g;%灰度图像
global img_output;%输出图像
img = imread('page.jpg');
[M,N] = size(img);
img_g =img;
if (size(img,3) ~= 1)
    img_g = func_imgToGray(img);%转灰度图
end
figure;imshow(img_g);set(gca,'position',[0,0,1,1]);%显示图像
imb = func_imgToBin(img_g);%二值化
func_getRealWidth(imb);%基本参数赋值
ver = func_projectTo(imb,'vercial');%投影到垂直方向
% figure;plot(ver,1:M);title('垂直方向像素');set(gca,'ydir','reverse');
[row,row_property]= func_getRowProperty(ver);%从垂直投影中获得行信息
% func_showDivisiveImg(img,row_property,'line');%显示行切割
func_getRowsProject(imb,row_property,row);%获得每一行水平方向的投影,保存到rows_hor_projection
func_statisticalParameter(row_property);%基本参数统计求均值
[s,section_property]=func_getSectionProperty(imb,row_property,row);
func_showDivisiveImg(img,section_property,'rectangle');%显示段切割
func_sectionReflow(section_property);
figure;imshow(img_output);title('section reflow');
%% 基于段落重排的切边
function func_sectionReflow(sp)
global img_output;
global img_g;
global PWIDTH;
[M,N]=size(img_g);
img_output = uint8(zeros(M,N));
x = 1;
y=1;%todo y应该等于设置的内边距
f=1;%缩放因子=缩放之后宽度/PWITDH
s = size(sp,1);
for i = 1:s
    %todo 缩放后大小的确定,换页的问题
    if(sp(i,5)~=0)
        y = floor(y+f*PWIDTH*sp(i,5));
    end
    [x,y]=func_append(x,y,sp(i,1:4),'section');
end
%% 将图片的小部分添加到输出图片中
function[x,y]=func_append(x,y,position,type)
% @输入
% x,y为光标左上角坐标
% position[sx,sy,sw,sh]代表欲加图片的左上角坐标和宽高
% type为添加类型(文字或者段落)
% @return
% x,y, 添加图片后新光标位置
global img_output;
global img_g;
%!!!注意,sp里因为涉及到左上角x,y坐标,所以x是图片的x轴,即横轴,因此要倒过来用
sx=position(2);sy=position(1);sw=position(3);sh=position(4);
switch type
    case 'section'
        xx=(x+sh-1);
        yy=y+sw-1;
        sxx=sx+sh-1;
        syy=sy+sw-1;
        img_output(x:(x+sh-1),y:(y+sw-1))=img_g(sx:(sx+sh-1),sy:(sy+sw-1));
        [x,y] = func_newline(x,y,sh);
    case 'char'%todo
end
%% 根据传入高度换行返回新的坐标
function[x,y]=func_newline(x,y,height)
y=1;%todo y应该等于设置的内边距
x=x+height;
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
function [s,sp]=func_getSectionProperty(img,rp,row)
% @输入
% imb图像
% rp行信息
% row行数
% @return
% s段落数
% sp: section_property段信息
%                          它是一个s行6列数组,结构如下
%                           [x,y,w,h,T,P,from,to]
%                           position    : x,y,w,h 左上角坐标,宽高
%                           flag          : T 缩进保留   P 是否图片
%                           from-to    : from  启始行      to 结束行
global PWIDTH;
global ONE_CHAR_WIDTH;
global ONE_TAB_WIDTH;
global LX;
s = 1;
sp = zeros(row,8);
last_blank = 0;
for i = 1:row
    [head_blank,tail_blank] = trim(i,rp(i,:));%计算开头的空白长度
    x = LX+head_blank+1;
    y= rp(i,1)+1;
    h = rp(i,2)-rp(i,1)-1;
    w=tail_blank-head_blank+1;
    if(isImgSection(rp(i,:))==1)%是否为图片段
        sp(s,:)=[x,y,w,h,head_blank/PWIDTH,1,i,i];%新建一段
        s=s+1;
    else%非图片段
        if(head_blank> ONE_CHAR_WIDTH)%大于一个标准字符大小
            sp(s,:)=[x,y,w,h,0,0,i,i];%认为是新的一段
            if(head_blank>ONE_TAB_WIDTH)%大于一个标准缩进值
                sp(s,5)=head_blank/PWIDTH;%计算它相对缩减值
            end
            s=s+1;
        else%无空格, 那么这一行和上一段合并
            if(s==1 || sp(s-1,4)==1)%上一段是否为图片
                sp(i, :)=[x,y,w,h, 0, 0, i, i];
                s=s+1;
            else%非图片,合并
                %宽度的更新
                if(last_blank>ONE_CHAR_WIDTH)%两行的情况
                    sp(s-1,3)=sp(s-1,3)+last_blank;
                end
                if(w>sp(s-1,3))%更新成最大的
                    sp(s-1,3)=w;
                end
                sp(s-1,5)=0;%计算它相对缩减值
                sp(s-1,1) = min([x,sp(s-1,1)]);%x的更新,更新成最小的
                sp(s-1, 4)=rp(i,2)-sp(s-1,2);
                sp(s-1,8) = i;
            end
        end
    end
    last_blank = head_blank;
end
sp(s:end,:)=[];
s=s-1;
%% 计算行行首空格数
function [head_blank,tail_blank]=trim(row,up,bottom)
global rows_hor_projection;%每一行的水平投影
hor = rows_hor_projection{row};
head_blank =1;
while(hor(head_blank)==0)
    head_blank=1+head_blank;
end
i = size(hor,2);
while(hor(i)==0)
    i=i-1;
end
tail_blank=i+1;
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
function func_statisticalParameter(rp)
%todo 
global ONE_CHAR_WIDTH;% 统计参数 一个中文字符的标准宽
global ONE_TAB_WIDTH;% 统计参数 一个首行缩进的标准宽
global ONE_ROW_HEIGHT;% 统计参数 一行的标准高
global rows_hor_projection;%每一行的水平投影
global PWIDTH;% 页面宽
%page.jpg
% ONE_CHAR_WIDTH = 23;
% ONE_TAB_WIDTH =  round(ONE_CHAR_WIDTH*3.5);
% ONE_ROW_HEIGHT=32;
%test
% ONE_CHAR_WIDTH = 80;
% ONE_TAB_WIDTH =  round(ONE_CHAR_WIDTH*3.5);
% ONE_ROW_HEIGHT=100;
% 中间三分之一求平均值法
% ONE_ROW_HEIGHT
row = size(rp,1);
tmp=zeros(1,row);
tmp =rp(:,2)-rp(:,1)-1;
ONE_ROW_HEIGHT = round(func_getStaticAVG(tmp));
% ONE_CHAR_WIDTH
idx = find(tmp==median(tmp));
i = idx(floor(length(idx)/2));
hor = rows_hor_projection{i};
i = 1;
star=0;
ed=0;
num=1;
tmp = zeros(1,200);%记录字符宽
while(i<PWIDTH)
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
ONE_CHAR_WIDTH = ceil(func_getStaticAVG(tmp));
ONE_TAB_WIDTH =  round(ONE_CHAR_WIDTH*2.6);
%% 求一个数组中间三分之一上下取整区间的平均值
function[result]=func_getStaticAVG(tmp)
n = length(tmp);
left = floor(n/3);right = ceil(n/3*2);
tmp =sort(tmp);
result = sum(tmp(left:right))/(right-left+1);
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
% [M,N,O]=size(img);
n = size(properties,1);
switch type
    case 'line'
        line([LX,RX],[properties(:,1),properties(:,1)]);
        line([LX,RX],[properties(:,2),properties(:,2)]);
    case 'rectangle'
        %rectangle('Position',temp,'LineWidth',2,'LineStyle','-','edgecolor','b')
        for i=1:n
            position=properties(i,1:4);%注意,矩阵的x是竖轴和图像的x是横
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
img            = 255 - img;          % 针对白纸黑字的情况
im2            = double(img);
trd            = mean(im2(:)); % 固定阈值
im2(im2 > trd) = 255;                % 阈值分割
im2(im2 <=trd) = 0;
im2=uint8(im2);
    
    