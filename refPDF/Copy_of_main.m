
%% 段落划分
function main()
clc;
close all;
clear all;
%% 以下是全局参数说明,参数为结构体,包含各种子参数
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
global CONFIG;
% CONFIG  用户设定的参数
%--gap 字体间距
%--padding 新文档内边距
%--width 新文档宽
%--height 新文档高
%--Fy 字体放大倍数
%--line_spacing 行距
%--text-indent 缩进距离
%--以上是用户设置,有默认值,以下是通过上面计算得来
%--x 左上角x
%--y 左上角y
%--Fx 缩放因子 新文档宽/原文档宽





% func_sectionReflow();%基于段切分的重排




%% 基于段落重排的切边
function func_sectionReflow()%cur
global imgs;
global PAGE;
global PARA;
global properties;
global CONFIG;% 用户设置参数集合
%新建图像
s = size(properties.section,1);
imgs.output = uint8(zeros(CONFIG.height,CONFIG.width));
imgs.output = 255-imgs.output;
x = CONFIG.x;
y = CONFIG.y;
p =1;%输出文件的编号
for i = 1:s
    if(CONFIG.height-CONFIG.padding < x+properties.section(i,4)*CONFIG.Fx)%另起一页
%         figure;imshow(imgs.output);title('section reflow');
        [x,y,p]=func_newPage(p);
    end
    if(properties.section(i,5)~=0)
        y = floor(y+CONFIG.Fx*PAGE.WIDTH*properties.section(i,5));
    elseif(properties.section(i,4)<2*PARA.ONE_ROW_HEIGHT)%一行成一段的情况
        y = floor(y+PARA.ONE_TAB_WIDTH*CONFIG.Fx);
    end
    [x,y]=func_append(x,y,properties.section(i,1:4),'section');
    [x,y]=func_newline(x,y,properties.section(i,4));
    x = round(x+PARA.LINE_SPACING*CONFIG.Fx);
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







    
    