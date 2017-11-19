%% ���仮��
function secion_division_main()
global LX;% ҳ����߽�
global RX;% ҳ���ұ߽�
global PWIDTH;% ҳ���
global ONE_CHAR_WIDTH;% ͳ�Ʋ��� һ�������ַ��ı�׼��
global ONE_TAB_WIDTH;% ͳ�Ʋ��� һ�����������ı�׼��
global ONE_ROW_HEIGHT;% ͳ�Ʋ��� һ�еı�׼��
global rows_hor_projection;%ÿһ�е�ˮƽͶӰ
img = imread('test\MATLAB������Ž̳�_ҳ��_05.jpg');
[M,N] = size(img);
ima =img;
if (size(img,3) ~= 1)
    ima = func_imgToGray(img);%ת�Ҷ�ͼ
end
imb = func_imgToBin(ima);%��ֵ��
func_getRealWidth(imb);%����������ֵ
func_statisticalParameter();%����������ֵ
ver = func_projectTo(imb,'vercial');%ͶӰ����ֱ����
% figure;plot(ver,1:M);title('��ֱ��������');set(gca,'ydir','reverse');
[row,row_property]= func_getRowProperty(ver);%�Ӵ�ֱͶӰ�л������Ϣ
func_showDivisiveImg(img,row_property,'line');%��ʾ���и�
func_getRowsProject(imb,row_property,row);%���ÿһ��ˮƽ�����ͶӰ,���浽rows_hor_projection
[s,section_property]=getSectionProperty(imb,row_property,row);
func_showDivisiveImg(img,section_property,'rectangle');%��ʾ���и�
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
function [s,sp]=getSectionProperty(img,rp,row)
% @����
% imbͼ��
% rp����Ϣ
% row����
% @return
% s������
% sp: section_property����Ϣ
%                          ����һ��s��6������,�ṹ����
%                           �߽�          1:  �ϱ߽�      2:  �±߽�
%                           ��־          3:  ��������   4:  ͼƬ��־
%                           ������       5:  ��ʼ��      6:  ������
global PWIDTH;
global ONE_CHAR_WIDTH;
global ONE_TAB_WIDTH;
s = 1;
sp = zeros(row,6);
for i = 1:row
    if(isImgSection(rp(i,:))==1)%�Ƿ�ΪͼƬ��
        head_blank = calcuBlank(i,rp(i,:));
        sp(s,:)=[rp(i,1),rp(i,2),head_blank/PWIDTH,1,i,i];%�½�һ��
        s=s+1;
    else%��ͼƬ��
        head_blank = calcuBlank(i,rp(i,:));%���㿪ͷ�Ŀհ׳���
        if(head_blank> ONE_CHAR_WIDTH)%����һ����׼�ַ���С
            sp(s,:)=[rp(i,1),rp(i,2),0,0,i,i];%��Ϊ���µ�һ��
            if(head_blank>ONE_TAB_WIDTH)%����һ����׼����ֵ
                sp(s,3)=head_blank/PWIDTH;%�������������ֵ
            end
            s=s+1;
        else%�޿ո�, ��ô��һ�к���һ�κϲ�
            if(s==1 || sp(s-1,4)==1)%��һ���Ƿ�ΪͼƬ
                sp(i, :)=[rp(i,1), rp(i,2), 0, 0, i, i];
                s=s+1;
            else%��ͼƬ,�ϲ�
                sp(s-1, 2)=rp(i,2);
                sp(s-1,6) = i;
            end
        end
    end
end
sp(s:end,:)=[];
s=s-1;
%% ���������׿ո���
function [head_blank]=calcuBlank(row,up,bottom)
global rows_hor_projection;%ÿһ�е�ˮƽͶӰ
hor = rows_hor_projection{row};
head_blank =1;
while(hor(head_blank)==0)
    head_blank=1+head_blank;
end
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
function func_statisticalParameter()
%todo ��ʹ�ù̶�ֵ���
global ONE_CHAR_WIDTH;% ͳ�Ʋ��� һ�������ַ��ı�׼��
global ONE_TAB_WIDTH;% ͳ�Ʋ��� һ�����������ı�׼��
global ONE_ROW_HEIGHT;% ͳ�Ʋ��� һ�еı�׼��
ONE_CHAR_WIDTH = 23;
ONE_TAB_WIDTH =  round(ONE_CHAR_WIDTH*3.5);
ONE_ROW_HEIGHT=32;
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
%% ת�Ҷ�ͼ
function[im2]= func_imgToGray(img)
if (size(img,3) ~= 1)                % Ҫ������ͼ��Ϊ��ͨ���Ҷ�ͼ��
    im2        = rgb2gray(img);
end

%% ��ֵ��ͼ��
function[im2]= func_imgToBin(img)
img            = 255 - img;          % ��԰�ֽ���ֵ����
im2            = double(img);
trd            = 1.3 * mean(im2(:)); % �̶���ֵ
im2(im2 > trd) = 255;                % ��ֵ�ָ�
im2(im2 <=trd) = 0;
im2=uint8(im2);
    
    