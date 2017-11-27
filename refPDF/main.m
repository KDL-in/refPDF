
%% ���仮��
function main()
clc;
close all;
clear all;
%% ������ȫ�ֲ���˵��,����Ϊ�ṹ��,���������Ӳ���
global PAGE;
% PAGE ����Ȥ�����ʵ���������������Ϣ, ���ұ߽��Լ����,����
%--LX ��߽�
%--LX �ұ߽�
%--UY �ϱ߽�
%--DY �±߽�
%--WIDTH ʵ�����ݵĿ��
%--SAFEԤ���и�İ�ȫ���򳤶�
global PARA;
% PARA ͳ�Ʋ���,����ͳ�Ƶ�����һЩҳ����ز���,����
%--ONE_CHAR_WIDTH   һ�������ַ��ı�׼��
%--ONE_TAB_WIDTH      һ�����������ı�׼��
%--ONE_ROW_HEIGHT   һ�еı�׼��
%--LINE_SPACING  �м��
%--TFTOOL һ��3.5���ַ��������, ����ȫΪ1, ����������ص���
global projection;
% projection ��ֱ�����ˮƽ�����ͶӰ,����
%--allRows ÿһ�е�ˮƽͶӰ
%--ver        ҳ�洹ֱ�����ͶӰ
global imgs;%�Ҷ�ͼ��
% imgs  ����ͼ��,���ĻҶ�ͼ��,���Ķ�ֵͼ��,�Լ����ͼ��
%--imgs.o ԭʼͼ��
%--imgs.g �Ҷ�ͼ��
%--imgs.b ��ֵͼ��
%--imgs.output ���ͼ��
%--p ���ҳ������
%--x,y�û�������һҳ��������xy
global properties;
% properties���зָ�,�ηָ�������Ϣ, ����
%--allRows:  ����Ϣ
%----------����һ��n��2�е�����,���ĽṹΪ
%----------[up, buttom],
%----------����x��, �ϱ߽�Ϊup,�±߽�Ϊbuttom
%--section: ����Ϣ
%----------����һ��s��8������,�ṹ����
%----------[x,y,w,h,T,P,from,to]
%----------�ֱ���
%----------position   :  x,y,w,h ���Ͻ�����,���
%----------flag          :  T ��������   P �Ƿ�ͼƬ
%----------from-to    :  from  ��ʼ��      to ������
%--charsAtRows: �ַ���Ϣ
%----------����һ��Ԫ������, ����n��Ԫ��,nΪ����(ͼƬ��Ϊ��)
%----------ÿһ��Ԫ����һ��m��4�е�����,��¼m���ַ�����Ϣ
%----------����Ľṹ��
%----------[x,y,w,h]
%----------x,y,w,h ���Ͻ�����,���
global CONFIG;
% CONFIG  �û��趨�Ĳ���
%--gap ������
%--padding ���ĵ��ڱ߾�
%--width ���ĵ���
%--height ���ĵ���
%--Fy ����Ŵ���
%--line_spacing �о�
%--text_indent ��������
%--�������û�����,��Ĭ��ֵ,������ͨ������������
%--x ���Ͻ�x
%--y ���Ͻ�y
%--Fx �������� ���ĵ���/ԭ�ĵ���
global UI;
% �����ϵ��趨����
%--perview �Ƿ���ʾԤ��
%--inURL �����ļ���ַ
%--names �����ļ�������
%--index ��ǰ�ļ��±�
%--outURL ����ļ���ַ
%--isOutput �Ƿ����
%--nͼƬ������
%--isEnd ͼƬ��ȡ������־
% imgs.o = imread('page.jpg');
% imgs.o = imread('test/MATLAB������Ž̳�_ҳ��_03.jpg');
% imgs.o = imread('test/ita1 (3).jpg');
imgs.o = imread('test/ҳ����ȡ�ԣ����㷨�����İ棩.���İ�.ͼ�������ƴ��顷Algorithms_2.jpg');
imgs.g =imgs.o;
if (size(imgs.o,3) ~= 1)
    imgs.g = func_imgToGray(imgs.o);%ת�Ҷ�ͼ
end
imgs.b = func_imgToBin(imgs.g);%��ֵ��
figure;imshow(imgs.g);set(gca,'position',[0,0,1,1]);%��ʾͼ��
getInteretingContentSize();%�������Ȥ����ҳ����,���ұ߽�
%��������Ȥ�����, imgs�и���
imgs.b = func_getThePartOf('binary',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
imgs.g = func_getThePartOf('gray',PAGE.LX,PAGE.UY,PAGE.WIDTH,PAGE.HEIGHT);
imshow(imgs.g);set(gca,'position',[0,0,1,1]);%��ʾͼ��
func_statisticalParameter();%��������ͳ�����ֵ
initCONFIG();
initProperties();% ��ʼ��ˮƽ����ʹ�ֱ�����ͶӰ,�Լ�����Ϣ�Ͷ���Ϣ
% func_sectionReflow();%���ڶ��зֵ�����
func_charsReflow();
figure;imshow(imgs.output);
%% ���ֻ���(����)
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
for i = 1:s_size%cur
    sp =properties.section(i,:);
    T = sp(5);
    %��������
    if(T~=0)%���������������������ַ�
        y = floor(y+CONFIG.Fx*PAGE.WIDTH*sp(5));
    else
        y = floor(y+CONFIG.text_indent);%todo �ṩ����
    end
    if(sp(6)==1)%�����ͼƬ��
        if(CONFIG.height-CONFIG.padding < x+sp(4)*CONFIG.Fx)%����һҳ
            %         figure;imshow(imgs.output);title('section reflow');
            [x,~,p]=func_newPage(p);
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
                    [x,y,p]=func_newPage(p);
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


%% ��ʼ�� �û����ò���
function initCONFIG()
global CONFIG;
global PARA;
global PAGE;
CONFIG.gap =PARA.GAP;%todo �ȴ�ͳ��
CONFIG.padding = 0;
CONFIG.height = PAGE.HEIGHT;
CONFIG.width= PAGE.WIDTH;
w = CONFIG.width -2*CONFIG.padding;
CONFIG.Fx=w/double(PAGE.WIDTH);
CONFIG.Fy=2;%todo Ĭ��1
CONFIG.y = CONFIG.padding+1+floor(PAGE.SAFE*CONFIG.Fx);
CONFIG.x = CONFIG.padding+1;
CONFIG.line_spacing = PARA.LINE_SPACING *CONFIG.Fy ;
CONFIG.text_indent = PARA.ONE_TAB_WIDTH*CONFIG.Fx*CONFIG.Fy;
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
func_showDivisiveImg(properties.section,'rectangle');%��ʾ���и�
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
% ��׼�ַ����
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
%% ���ڶ������ŵ��б�
function func_sectionReflow()%cur
global imgs;
global PAGE;
global PARA;
global properties;
global CONFIG;% �û����ò�������
%�½�ͼ��
s = size(properties.section,1);
imgs.output = uint8(zeros(CONFIG.height,CONFIG.width));
imgs.output = 255-imgs.output;
x = CONFIG.x;
y = CONFIG.y;
p =1;%����ļ��ı��
for i = 1:s
    if(CONFIG.height-CONFIG.padding < x+properties.section(i,4)*CONFIG.Fx)%����һҳ
%         figure;imshow(imgs.output);title('section reflow');
        [x,y,p]=func_newPage(p);
    end
    if(properties.section(i,5)~=0)
        y = floor(y+CONFIG.Fx*PAGE.WIDTH*properties.section(i,5));
    elseif(properties.section(i,4)<2*PARA.ONE_ROW_HEIGHT)%һ�г�һ�ε����
        y = floor(y+PARA.ONE_TAB_WIDTH*CONFIG.Fx);
    end
    [x,y]=func_append(x,y,properties.section(i,1:4),'section');
    [x,y]=func_newline(x,y,properties.section(i,4));
    x = round(x+PARA.LINE_SPACING*CONFIG.Fx);
end
%% ����һҳ
function[x,y,p] = func_newPage(p)
global imgs;
global CONFIG;
func_save('output',strcat('p',num2str(p)),'jpg');
p= p+1;
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
%% ��ͼƬ��С������ӵ����ͼƬ��
function[x,y]=func_append(x,y,position,type)
% @����
% x,yΪ������Ͻ�����
% position[sx,sy,sw,sh]��������ͼƬ�����Ͻ�����Ϳ��
% typeΪ�������(���ֻ��߶���)
% @return
% x,y, ���ͼƬ���¹��λ��
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
%% �������Ͻ�����ͳ���ȡ��ͼ���һ����
function[imp]=func_getThePartOf(type,x,y,w,h)
% ����
% type �ҶȻ��߶�ֵͼ
% xy ���Ͻ�����
% wh ��͸�
global imgs;
x=uint64(x);y=uint64(y);w=uint64(w);h=uint64(h);%matlab���ƺ�û���Զ�ȡ����������,Ԥ����һ
switch type
    case 'gray'
        imp = imgs.g(y:y+h-1,x:x+w-1);
    case 'binary'
        imp = imgs.b(y:y+h-1,x:x+w-1);
end
%% �����кϲ��ɶ�,ͼƬ�Գ�һ��
function getSectionProperty()
% s������
% properties.section: ����Ϣ
%---------- ����һ��s��8������,�ṹ����
%----------  [x,y,w,h,T,P,from,to]
%----------  �ֱ���
%----------  position   :  x,y,w,h ���Ͻ�����,���
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
%     if(i == row)
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
            if(head_blank-PAGE.SAFE>PARA.ONE_TAB_WIDTH*1.4)%����һ����׼����ֵ Ӣ�ĵĻ��������Ҫ��
                properties.section(s,5)=head_blank/PAGE.WIDTH;%�������������ֵ
%                 showRow(i);
            end
            s=s+1;
        else%�޿ո�, ��ô��һ�к���һ�κϲ�
            if(s==1 || properties.section(s-1,6)==1)%��һ���Ƿ�ΪͼƬ
                properties.section(s, :)=[x,y,w,h, 0, 0, i, i];
                s=s+1;
            else%��ͼƬ,�ϲ�
                %��ȵĸ���
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
%% ���������׿ո���
function [head_blank,tail_blank]=trim(row)
%todo debug horȡ���ǽ�ȡ���,��hb���ʵ�ȴ��ȫͼ����˻����
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
%% ��ʾĳһ��,debug��
function showRow(i)
global properties;
global imgs;
x =1;
y= properties.allRows(i,1)+1;
h = properties.allRows(i,2)-properties.allRows(i,1)-1;
w=size(imgs.b,2);
figure;imshow(func_getThePartOf('binary',x,y,w,h));
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
avg = mean(tmp);
%ȡ��λ����֮һ����������ȡ��Ӣ��,�������ƽ��ֵɸѡ������ֵ��ƽ��tag
PARA.ONE_CHAR_WIDTH = mean(tmp(tmp>avg));
% PARA.ONE_CHAR_WIDTH = ceil(func_getStatistcalAVG(tmp));
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
%% �����������ݵĿ��
function getInteretingContentSize()
% �û���ȡ�ĸ���Ȥ����ͼ�񲿷�(todo)
global PAGE;
global imgs;
pos = [1,1,size(imgs.b,2),size(imgs.b,1)];
h=imrect;%�����ʮ�֣�����ѡȡ����Ȥ����
%���ok֮�����todo gui��ʱ��Ҫ�޸�
pos=getPosition(h);%ͼ�оͻ���ֿ����϶��Լ��ı��С�ľ��ο�ѡ��λ�ú�
pos=uint16(pos);%pos���ĸ�ֵ���ֱ��Ǿ��ο�����½ǵ������ x y �� ��� ��Ⱥ͸߶�
%ע��������ͼ���x,y, �������Ҫ��Ӧ�ý���һ��

PAGE.SAFE =10;
 %  ���
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
% while(ver(PAGE.DY)==0) 
%     PAGE.DY=PAGE.DY-1;
% end;
PAGE.UY = PAGE.UY-PAGE.SAFE;%�������ҵİ�ȫ����
% PAGE.DY = PAGE.DY+PAGE.SAFE;%�������ҵİ�ȫ���� %�±߲���trim
PAGE.HEIGHT=double(PAGE.DY-PAGE.UY-1);
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
%% �Ӵ�ֱͶӰ�л������Ϣ
function getRowProperty()
% properties.allRows Ϊÿ�е����±߽��λ��
%                      ���ĽṹΪ[up, buttom], ����x��, �ϱ߽�Ϊup,�±߽�Ϊbuttom
global projection;
global properties;
global PARA;
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
%ȥ�����߶�ɸѡֵ???�����ٿ���
%��Ҫ����, ���������
tmp =properties.allRows(:,2)-properties.allRows(:,1);
idx = tmp<PARA.ONE_ROW_HEIGHT*0.1;
properties.allRows(idx,:)=[];
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
    
    