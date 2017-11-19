function mainFunc()
%% ����boundingBox
img = imread('text.jpg');
% ע����demo����δ��������ͼ�������Ӧ�ָ��㷨�������ǹ̶���ֵ����
if (size(img,3) ~= 1)                % Ҫ������ͼ��Ϊ��ͨ���Ҷ�ͼ��
    img        = rgb2gray(img);
end
img            = 255 - img;          % ��԰�ֽ���ֵ����
im2            = double(img);
trd            = 1.3 * mean(im2(:)); % �̶���ֵ
im2(im2 > trd) = 255;                % ��ֵ�ָ�
im2(im2 <=trd) = 0;
func_boundingBoxes(img,im2,'show',[4 4]);

%% ������С���κ���
function [BoundingBox,ROIs] = func_boundingBoxes(img,s_img,Type,para)%tag
% img ԭ�Ҷ�ͼ
% s_img ��ֵͼ
% Type �Ƿ�ɼ�
% para ��ͨ����
% function: return the bounding box of each petential connected regions 
%          from the binary imgge s_img and extract the imgge contents of 
%          the corresponding bounding boxes
% author: Steven Chong (jiajunzhuang@126.com)

[Label_img,num] = bwlabel(s_img,8);%����ͬ���ֱ����ͬ8��ͨ����,��������ͨ������
areaBB          = regionprops(Label_img,'BoundingBox');%���ز�ͬ��ͨ�������С����,areaBBΪnum���ṹ��Ϣ
[H,W]           = size(img);
j               = 0;
t               = zeros(1,num);%1άnum�еľ���,num���ַ���
a               = para(1);
b               = para(2);
for i = 1:num%ɸѡ,ͳ����ͨ��������������±�,����t��
    if (areaBB(i).BoundingBox(3)>=a) && (areaBB(i).BoundingBox(4)>=b) % 6 5 
        j    = j + 1;
        t(j) = i;
    end
end
t(j+1:end) = [];%ʣ�µ�ά�ȶ���

if strcmp(Type,'show')%��ʾԭͼ
    imshow(img);
end
BoundingBox = zeros(j,4);%j��4�е�����
ROIs        = cell(j,1);%j��1�е�Ԫ������
for i = 1:size(t,2)%����ÿ����ͨ����
    temp             = areaBB(t(i)).BoundingBox;%ȡ����ͨ�������Ϣ
    BoundingBox(i,:) = temp;%x y width height
    %%������Ϣ��������
    if strcmp(Type,'show')
        if (temp(3)<8) && (temp(4)<12)
        	rectangle('Position',temp,'LineWidth',2,...
                'LineStyle','-','edgecolor','m') % target?
        else
            rectangle('Position',temp,'LineWidth',2,...
                'LineStyle','-','edgecolor','b')%tag ������
        end
        %%%�������»����ϵ�С����
%         cc = [':',num2str(temp(3)),'��',num2str(temp(4))];
%         x = temp(1);
%         if mod(i,2)==0
%             y = temp(2) + temp(4) + 8;
%             text(x-8,y,num2str(i),'color','r','fontsize',10)
%         else
%             y = temp(2) - 8;
%             text(x-8,y,num2str(i),'color','r','fontsize',10)
%         end
    end
    %%����, ����ͨ������Ϣ��ȡ��ͼ�񲿷ַ���Ԫ��rols{i}��
    indx      = floor(temp(1));%������������ȡ��
    indy      = floor(temp(2));
    if (indx == 0)
        indx  = indx+1;
    end
    if (indy == 0)
        indy  = indy+1;
    end
    
    indwidth      = temp(3);%�������
    indheight     = temp(4);
    if (indy + indheight > H)
        indheight = indheight - 1;
    end
    if (indx + indwidth > W)
        indwidth  = indwidth - 1;
    end
    ROIs{i}       = img(indy:(indy+indheight),indx:(indx+indwidth));
end
