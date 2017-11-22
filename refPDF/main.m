
%% ���仮��
function main()
clc;
close all;
clear all;
%% ������ȫ�ֲ���˵��,����Ϊ�ṹ��,���������Ӳ���
global PAGE;
% PAGE ʵ�ʰ������ݵ�ҳ����Ϣ, ���ұ߽��Լ�ʵ�����ݿ��,����
%--LX ʵ��������߽�tag
%--LY ʵ�������ұ߽�
%--WIDTH ʵ�����ݵĿ��
global PARA;
% PARA ͳ�Ʋ���,����ͳ�Ƶ�����һЩҳ����ز���,����
%--ONE_CHAR_WIDTH   һ�������ַ��ı�׼��
%--ONE_TAB_WIDTH      һ�����������ı�׼��
%--ONE_ROW_HEIGHT   һ�еı�׼��
%--ROW_SPACING  �м��
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
global properties;
% properties���зָ�,�ηָ�������Ϣ, ����
%--row:  ����Ϣ
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
global padding;


% imgs.o = imread('page.jpg');
% imgs.o = imread('test/MATLAB������Ž̳�_ҳ��_11.jpg');
imgs.o = imread('test/ita1 (3).jpg');
% imgs.o = imread('test/ҳ����ȡ�ԣ����㷨�����İ棩.���İ�.ͼ�������ƴ��顷Algorithms_2.jpg');
imgs.g =imgs.o;
if (size(imgs.o,3) ~= 1)
    imgs.g = func_imgToGray(imgs.o);%ת�Ҷ�ͼ
end
imgs.b = func_imgToBin(imgs.g);%��ֵ��
figure;imshow(imgs.g);set(gca,'position',[0,0,1,1]);%��ʾͼ��
getInteretingContentSize();%�������Ȥ����ҳ����,���ұ߽�
func_statisticalParameter();%��������ͳ�����ֵ
initProperties();% ��ʼ��ˮƽ����ʹ�ֱ�����ͶӰ,�Լ�����Ϣ�Ͷ���Ϣ
padding = 10;
func_sectionReflow(1000,1000);%���ڶ��зֵ�����
% figure;imshow(imgs.output);
%% ��ʼ��ˮƽ����ʹ�ֱ�����ͶӰ,�Լ�����Ϣ�Ͷ���Ϣ
function initProperties()
global imgs;
global properties;
global projection;
projection.ver = func_projectTo(imgs.b,'vercial');%ͶӰ����ֱ����
% figure;plot(ver,1:M);title('��ֱ��������');set(gca,'ydir','reverse');
getRowProperty();
% func_showDivisiveImg(properties.row,'line');%��ʾ���и�
getRowsProjection();%���ÿһ��ˮƽ�����ͶӰ,���浽projection.allRows
getSectionProperty();%��ö��и���Ϣ
func_showDivisiveImg(properties.section,'rectangle');%��ʾ���и�

%% ���ڶ������ŵ��б�
function func_sectionReflow(w,h)
global imgs;
global PAGE;
global PARA;
global properties;
global padding;%todo �û����ò�������
%�½�ͼ��
oh = h;ow=w;%���߾���
imgs.output = uint8(zeros(oh,ow));
imgs.output = 255-imgs.output;
p =1;
%ָ���ֱ���
x = padding+1;
y= padding+1;
w = w -2*padding;
h = h -2*padding;
f=w/PAGE.WIDTH;
s = size(properties.section,1);
for i = 1:s
    if(h+padding < x+properties.section(i,4)*f)%����һҳ
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
%% �����󱣴�ΪͼƬ
function func_save(img,url,name,type)
% �ļ�,��ַ, �ļ���, ��������
if(url(length(url))=='/')
    url(length(url))=[];
end
imwrite(img,strcat(url,'/',name,'.',type),type);
%% ��ͼƬ��С������ӵ����ͼƬ��
function[x,y]=func_append(x,y,position,type,f)
% @����
% x,yΪ������Ͻ�����
% position[sx,sy,sw,sh]��������ͼƬ�����Ͻ�����Ϳ��
% typeΪ�������(���ֻ��߶���)
% @return
% x,y, ���ͼƬ���¹��λ��
global PARA;
global imgs;
%!!!ע��,properties.section����Ϊ�漰�����Ͻ�x,y����,����x��ͼƬ��x��,������,���Ҫ��������
sx=position(2);sy=position(1);sw=position(3);sh=position(4);
%��������
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
%% ���ݴ���߶Ȼ��з����µ�����
function[x,y]=func_newline(x,y,height)
global padding;
y=padding+1;
x=x+height;
%% ���ÿһ��ˮƽ�����ͶӰ,���浽projection.allRows
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
%% �������Ͻ�����ͳ���ȡ��ͼ���һ����
function[imp]=func_getThePartOf(x,y,w,h)
% ���� todo x y�߼��ϲ�̫��,����ʹ������˵,��ͼƬxy,�ڲ����Ǿ���xy
% xy ���Ͻ�����
% wh ��͸�
global imgs;
x=uint64(x);y=uint64(y);w=uint64(w);h=uint64(h);%matlab���ƺ�û���Զ�ȡ����������,Ԥ����һ
imp = imgs.b(x:x+h-1,y:y+w-1);
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
row =size(properties.row,1);
s = 1;
properties.section = zeros(row,8);
last_blank = 0;
for i = 1:row
    [head_blank,tail_blank] = trim(i);%���㿪ͷ�Ŀհ׳���
    x = PAGE.LX+head_blank+1;
    y= properties.row(i,1)+1;
    h = properties.row(i,2)-properties.row(i,1)-1;
    w=tail_blank-head_blank+1;
%      if(i == 6)
%          s
%          figure;imshow(func_getThePartOf(y,x,w,h));
%      end
    if(isImgSection(i,x,y,w,h)==1)%�Ƿ�ΪͼƬ��
        properties.section(s,:)=[x,y,w,h,head_blank/PAGE.WIDTH,1,i,i];%�½�һ��
        s=s+1;
    else%��ͼƬ��
        if(head_blank> PARA.ONE_CHAR_WIDTH)%����һ����׼�ַ���С
            properties.section(s,:)=[x,y,w,h,0,0,i,i];%��Ϊ���µ�һ��
            if(head_blank>PARA.ONE_TAB_WIDTH)%����һ����׼����ֵ
                properties.section(s,5)=head_blank/PAGE.WIDTH;%�������������ֵ
            end
            s=s+1;
        else%�޿ո�, ��ô��һ�к���һ�κϲ�
            if(s==1 || properties.section(s-1,6)==1)%��һ���Ƿ�ΪͼƬ
                properties.section(s, :)=[x,y,w,h, head_blank/PAGE.WIDTH, 0, i, i];
                s=s+1;
            else%��ͼƬ,�ϲ�
                %��ȵĸ���
                if(last_blank>PARA.ONE_CHAR_WIDTH)%���е����
                    properties.section(s-1,3)=properties.section(s-1,3)+last_blank;
                end
                if(w>properties.section(s-1,3))%���³�����
                    properties.section(s-1,3)=w;
                end
                properties.section(s-1,5)=0;%�������������ֵ
                properties.section(s-1,1) = min([x,properties.section(s-1,1)]);%x�ĸ���,���³���С��
                properties.section(s-1, 4)=properties.row(i,2)-properties.section(s-1,2);
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
%% ��ʾĳһ��,debug��
function showRow(i)
global properties;
global imgs;
x =1;
y= properties.row(i,1)+1;
h = properties.row(i,2)-properties.row(i,1)-1;
w=size(imgs.b,2);
figure;imshow(func_getThePartOf(y,x,w,h));
%% �ж�ĳһ���Ƿ�ΪͼƬ
function [flag] =isImgSection(idx,x,y,w,h)
global PARA;
global projection;
flag = 0;
hor = projection.allRows{idx};
%���еĸ߶��ж�
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
        while(ver(i)~=0) 
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
%%% figure;imshow(func_getThePartOf(rp(i,1)+1,PAGE.LX,PAGE.WIDTH,tmp(i)));
hor = func_projectTo(func_getThePartOf(rp(i,1)+1,PAGE.LX,PAGE.WIDTH,tmp(i)),'horizontal');%�����һ�е�ˮƽͶӰ
%%% figure;plot(1:length(hor),hor);title('��ֱ��������');
i = 1;
num=1;
tmp = zeros(1,200);%��¼�ַ���
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

 %  ���tag
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
PAGE.LX = PAGE.LX-20;%��������20px�İ�ȫ����
PAGE.RX = PAGE.RX+20;%��������20px�İ�ȫ����
PAGE.WIDTH=PAGE.RX-PAGE.LX-1;
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
PAGE.UY = PAGE.UY-20;%��������20px�İ�ȫ����
PAGE.DY = PAGE.DY+20;%��������20px�İ�ȫ����
PAGE.HEIGHT=PAGE.DY-PAGE.UY-1;
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
                color ='g';%cur
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
% properties.row Ϊÿ�е����±߽��λ��
%                      ���ĽṹΪ[up, buttom], ����x��, �ϱ߽�Ϊup,�±߽�Ϊbuttom
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
% idx = tmp<7;ȥ�����߶�ɸѡֵ???�����ٿ���
% properties.row(idx,:)=[];
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
    
    