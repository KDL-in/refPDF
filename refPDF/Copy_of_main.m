
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




imshow(imgs.g);set(gca,'position',[0,0,1,1]);%显示图像
func_statisticalParameter();%基本参数统计求均值
initCONFIG();
initProperties();% 初始化水平方向和垂直方向的投影,以及行信息和段信息
% func_sectionReflow();%基于段切分的重排
func_charsReflow();
figure;imshow(imgs.output);
%% 文字回流(重排)
function func_charsReflow()
global properties;
global CONFIG;
global PARA;
global PAGE;
global imgs;
%新建图像
s_size = size(properties.section,1);
imgs.output = uint8(zeros(CONFIG.height,CONFIG.width));
imgs.output = 255-imgs.output;
x = CONFIG.x;
y= CONFIG.y;
p =1;%输出文件的编号
for i = 1:s_size%cur
    sp =properties.section(i,:);
    T = sp(5);
    %首行缩进
    if(T~=0)%缩进保留或是缩减两个字符
        y = floor(y+CONFIG.Fx*PAGE.WIDTH*sp(5));
    else
        y = floor(y+CONFIG.text_indent);%todo 提供设置
    end
    if(sp(6)==1)%如果是图片段
        if(CONFIG.height-CONFIG.padding < x+sp(4)*CONFIG.Fx)%另起一页
            %         figure;imshow(imgs.output);title('section reflow');
            [x,~,p]=func_newPage(p);
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
                    x = ceil(x+ CONFIG.line_spacing);
                end
                if(CONFIG.height-CONFIG.padding < x+chars(n,4)*CONFIG.Fx*CONFIG.Fy)%另起一页
                    [x,y,p]=func_newPage(p);
                end
                %非首行是否缩进保留
                if(y==CONFIG.y&&T~=0)% 新的一行,需不需要缩进保留
                    y = floor(y+CONFIG.Fx*PAGE.WIDTH*sp(5));
                    y = floor(y+PARA.ONE_CHAR_WIDTH*CONFIG.Fx*CONFIG.Fy);%再额外缩进一个字符
                end
                [x,y]=func_append(x,y,chars(n,1:4),'char');
            end
        end
    end
    % 换行, 图片换行以及段换行, 解决行距问题
    if(sp(6)==1)
        [x,y]=func_newline(x,y,sp(4)*CONFIG.Fx);
        x = floor(x+CONFIG.line_spacing*0.5);
    else%换行换的是最后一行的高度
        h = properties.allRows(sp(8),2)-properties.allRows(sp(8),1)-1;
        [x,y]=func_newline(x,y,h*CONFIG.Fx*CONFIG.Fy);
        x = ceil(x+ CONFIG.line_spacing);
    end
end



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
func_showDivisiveImg(properties.section,'rectangle');%显示段切割
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
% showRow(row);
temp = uint8(projection.allRows{row});
c = size(temp,2);

%% 输入
% 行投影(改255,0),行信息
result = zeros(1, c);
%获得字符左右边界[闭区间]
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
while (index < c)%英文字符之类的合并
    if (result(1, index) - result(1, index - 1) <= PARA.GAP)
        result(index - 1 : index) = [];
        c = c - 2;
    end
    index = index + 1;
end
%% 输出
% result 每对元素标记字符的左右边界
% 转换为charProperty
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
func_showDivisiveImg(properties.charsAtRows{row},'rectangle');%show

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
%% 另起一页
function[x,y,p] = func_newPage(p)
global imgs;
global CONFIG;
func_save('output',strcat('p',num2str(p)),'jpg');
p= p+1;
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
sx=position(2);sy=position(1);sw=position(3);sh=position(4);
%线性缩放
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
%% 根据传入高度换行返回新的坐标
function[x,y]=func_newline(x,~,height)
global CONFIG;
y= CONFIG.y;
x=x+height;
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
last_blank = 0;
for i = 1:row     
%     if(i == 3)
%          showRow(i);
% %          figure;imshow(func_getThePartOf('binary',x,y,w,h));
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
            if(head_blank-PAGE.SAFE>PARA.ONE_TAB_WIDTH*1.3)%大于一个标准缩进值
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
                    properties.section(s-1,3)=properties.section(s-1,3)+last_blank-head_blank;
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
    last_blank = head_blank;
end
properties.section(s:end,:)=[];
% s=s-1;
%% 计算行行首空格数
function [head_blank,tail_blank]=trim(row)
%todo debug hor取的是截取后的,而hb访问的却是全图的因此会出错
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
%% 显示某一行,debug用
function showRow(i)
global properties;
global imgs;
x =1;
y= properties.allRows(i,1)+1;
h = properties.allRows(i,2)-properties.allRows(i,1)-1;
w=size(imgs.b,2);
figure;imshow(func_getThePartOf('binary',x,y,w,h));
%% 判断某一行是否为图片
function [flag] =isImgSection(idx,x,~,~,h)
global PARA;
global projection;
flag = 0;
hor = projection.allRows{idx};
%从行的高度判断
if(h>PARA.ONE_ROW_HEIGHT*1.5) 
    flag = 1;
else
%     figure;imshow(func_getThePartOf('binary',x,y,w,h));
    hor = hor(1,x:x+size(PARA.TFTOOL,2)-1);
    tmp =and(hor,PARA.TFTOOL);
    blank = find(tmp==0);
    if(length(blank)<PARA.ONE_CHAR_WIDTH*0.05)
        flag=1;
    end
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
                rectangle('Position',position,'edgecolor','g');
            end
        end
end
%% 从垂直投影中获得行信息
function getRowProperty()
% properties.allRows 为每行的上下边界的位置
%                      它的结构为[up, buttom], 即第x行, 上边界为up,下边界为buttom
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
% idx = tmp<7;去躁点或者定筛选值???无需再考虑
% properties.allRows(idx,:)=[];

    
    