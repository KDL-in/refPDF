%% ���仮��
function secion_division_main()
global LX;% ҳ����߽�
global RX;% ҳ���ұ߽�
global PWIDTH;% ҳ���
global ONE_CHAR_WIDTH;% ͳ�Ʋ��� һ�������ַ��ı�׼��
global ONE_TAB_WIDTH;% ͳ�Ʋ��� һ�����������ı�׼��
global ONE_ROW_HEIGHT;% ͳ�Ʋ��� һ�еı�׼��
global rows_hor_projection;%ÿһ�е�ˮƽͶӰ
global img_g;%�Ҷ�ͼ��
global img_output;%���ͼ��
img = imread('page.jpg');
[M,N] = size(img);
img_g =img;
if (size(img,3) ~= 1)
    img_g = func_imgToGray(img);%ת�Ҷ�ͼ
end
figure;imshow(img_g);set(gca,'position',[0,0,1,1]);%��ʾͼ��
imb = func_imgToBin(img_g);%��ֵ��
func_getRealWidth(imb);%����������ֵ
ver = func_projectTo(imb,'vercial');%ͶӰ����ֱ����
% figure;plot(ver,1:M);title('��ֱ��������');set(gca,'ydir','reverse');
[row,row_property]= func_getRowProperty(ver);%�Ӵ�ֱͶӰ�л������Ϣ
% func_showDivisiveImg(img,row_property,'line');%��ʾ���и�
func_getRowsProject(imb,row_property,row);%���ÿһ��ˮƽ�����ͶӰ,���浽rows_hor_projection
func_statisticalParameter(row_property);%��������ͳ�����ֵ
[s,section_property]=func_getSectionProperty(imb,row_property,row);
func_showDivisiveImg(img,section_property,'rectangle');%��ʾ���и�
func_sectionReflow(section_property);
figure;imshow(img_output);title('section reflow');
%% ���ڶ������ŵ��б�
function func_sectionReflow(sp)
global img_output;
global img_g;
global PWIDTH;
[M,N]=size(img_g);
img_output = uint8(zeros(M,N));
x = 1;
y=1;%todo yӦ�õ������õ��ڱ߾�
f=1;%��������=����֮����/PWITDH
s = size(sp,1);
for i = 1:s
    %todo ���ź��С��ȷ��,��ҳ������
    if(sp(i,5)~=0)
        y = floor(y+f*PWIDTH*sp(i,5));
    end
    [x,y]=func_append(x,y,sp(i,1:4),'section');
end
%% ��ͼƬ��С������ӵ����ͼƬ��
function[x,y]=func_append(x,y,position,type)
% @����
% x,yΪ������Ͻ�����
% position[sx,sy,sw,sh]��������ͼƬ�����Ͻ�����Ϳ��
% typeΪ�������(���ֻ��߶���)
% @return
% x,y, ���ͼƬ���¹��λ��
global img_output;
global img_g;
%!!!ע��,sp����Ϊ�漰�����Ͻ�x,y����,����x��ͼƬ��x��,������,���Ҫ��������
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
%% ���ݴ���߶Ȼ��з����µ�����
function[x,y]=func_newline(x,y,height)
y=1;%todo yӦ�õ������õ��ڱ߾�
x=x+height;
%% ���ÿһ��ˮƽ�����ͶӰ,���浽rows_hor_projection
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
%% �������Ͻ�����ͳ���ȡ��ͼ���һ����
function[imp]=func_getThePartOf(img,x,y,w,h)
% ����
% img ԭͼ
% xy ���Ͻ�����
% wh ��͸�
imp = img(x:x+h-1,y:y+w-1);
%% �����кϲ��ɶ�,ͼƬ�Գ�һ��
function [s,sp]=func_getSectionProperty(img,rp,row)
% @����
% imbͼ��
% rp����Ϣ
% row����
% @return
% s������
% sp: section_property����Ϣ
%                          ����һ��s��6������,�ṹ����
%                           [x,y,w,h,T,P,from,to]
%                           position    : x,y,w,h ���Ͻ�����,���
%                           flag          : T ��������   P �Ƿ�ͼƬ
%                           from-to    : from  ��ʼ��      to ������
global PWIDTH;
global ONE_CHAR_WIDTH;
global ONE_TAB_WIDTH;
global LX;
s = 1;
sp = zeros(row,8);
last_blank = 0;
for i = 1:row
    [head_blank,tail_blank] = trim(i,rp(i,:));%���㿪ͷ�Ŀհ׳���
    x = LX+head_blank+1;
    y= rp(i,1)+1;
    h = rp(i,2)-rp(i,1)-1;
    w=tail_blank-head_blank+1;
    if(isImgSection(rp(i,:))==1)%�Ƿ�ΪͼƬ��
        sp(s,:)=[x,y,w,h,head_blank/PWIDTH,1,i,i];%�½�һ��
        s=s+1;
    else%��ͼƬ��
        if(head_blank> ONE_CHAR_WIDTH)%����һ����׼�ַ���С
            sp(s,:)=[x,y,w,h,0,0,i,i];%��Ϊ���µ�һ��
            if(head_blank>ONE_TAB_WIDTH)%����һ����׼����ֵ
                sp(s,5)=head_blank/PWIDTH;%�������������ֵ
            end
            s=s+1;
        else%�޿ո�, ��ô��һ�к���һ�κϲ�
            if(s==1 || sp(s-1,4)==1)%��һ���Ƿ�ΪͼƬ
                sp(i, :)=[x,y,w,h, 0, 0, i, i];
                s=s+1;
            else%��ͼƬ,�ϲ�
                %��ȵĸ���
                if(last_blank>ONE_CHAR_WIDTH)%���е����
                    sp(s-1,3)=sp(s-1,3)+last_blank;
                end
                if(w>sp(s-1,3))%���³�����
                    sp(s-1,3)=w;
                end
                sp(s-1,5)=0;%�������������ֵ
                sp(s-1,1) = min([x,sp(s-1,1)]);%x�ĸ���,���³���С��
                sp(s-1, 4)=rp(i,2)-sp(s-1,2);
                sp(s-1,8) = i;
            end
        end
    end
    last_blank = head_blank;
end
sp(s:end,:)=[];
s=s-1;
%% ���������׿ո���
function [head_blank,tail_blank]=trim(row,up,bottom)
global rows_hor_projection;%ÿһ�е�ˮƽͶӰ
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
%% �ж�ĳһ���Ƿ�ΪͼƬ
function [flag] =isImgSection(rp)
global ONE_ROW_HEIGHT;
up = rp(1);
bottom=rp(2);
flag = 0;
%���еĸ߶��ж�
h = bottom-up-1;
if(h>ONE_ROW_HEIGHT*1.5) 
    flag = 1;
end;
%���е��������ж�todo
%% ͳ������,���������������ֵ
function func_statisticalParameter(rp)
%todo 
global ONE_CHAR_WIDTH;% ͳ�Ʋ��� һ�������ַ��ı�׼��
global ONE_TAB_WIDTH;% ͳ�Ʋ��� һ�����������ı�׼��
global ONE_ROW_HEIGHT;% ͳ�Ʋ��� һ�еı�׼��
global rows_hor_projection;%ÿһ�е�ˮƽͶӰ
global PWIDTH;% ҳ���
%page.jpg
% ONE_CHAR_WIDTH = 23;
% ONE_TAB_WIDTH =  round(ONE_CHAR_WIDTH*3.5);
% ONE_ROW_HEIGHT=32;
%test
% ONE_CHAR_WIDTH = 80;
% ONE_TAB_WIDTH =  round(ONE_CHAR_WIDTH*3.5);
% ONE_ROW_HEIGHT=100;
% �м�����֮һ��ƽ��ֵ��
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
tmp = zeros(1,200);%��¼�ַ���
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
%% ��һ�������м�����֮һ����ȡ�������ƽ��ֵ
function[result]=func_getStaticAVG(tmp)
n = length(tmp);
left = floor(n/3);right = ceil(n/3*2);
tmp =sort(tmp);
result = sum(tmp(left:right))/(right-left+1);
%% ���Һ��ʵ�ҳ���
function func_getRealWidth(imb)
% @���
% LX,RXΪ���ұ߽��x����
% widthΪ���ҵĿ��(����ȡ���ֵ)
global LX;% ҳ����߽�
global RX;% ҳ���ұ߽�
global PWIDTH;% ҳ���
hor = func_projectTo(imb,'horizontal');
% figure;plot(1:length(hor),hor);title('��ֱ��������');
LX=1;
RX=length(hor);
while(hor(LX)==0) LX=LX+1;end;
while(hor(RX)==0) RX=RX-1;end;
LX =LX-1;
RX=RX-1;
PWIDTH=RX-LX-1;
%% ͼ������ʾ���ַָ���
function  func_showDivisiveImg(img,properties,type)
% ����
% img            ����ͼ��
% properties  ͼ����صķָ���Ϣ
% type           ��ʾ����
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
            position=properties(i,1:4);%ע��,�����x�������ͼ���x�Ǻ�
            rectangle('Position',position,'edgecolor','g');
        end
end
%% �Ӵ�ֱͶӰ�л������Ϣ
function[row,row_property]=func_getRowProperty(ver)
% @return
% row                Ϊʵ������
% row_property Ϊÿ�е����±߽��λ��
%                      ���ĽṹΪ[up, buttom], ����x��, �ϱ߽�Ϊup,�±߽�Ϊbuttom
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
img            = 255 - img;          % ��԰�ֽ���ֵ����
im2            = double(img);
trd            = mean(im2(:)); % �̶���ֵ
im2(im2 > trd) = 255;                % ��ֵ�ָ�
im2(im2 <=trd) = 0;
im2=uint8(im2);
    
    