function section_division_main()
%% ���Զ����з�
clc
close all
clear all
img = imread('page.jpg');
[M N] = size(img);
%��ֵ��
if (size(img,3) ~= 1)                % Ҫ������ͼ��Ϊ��ͨ���Ҷ�ͼ��
    img        = rgb2gray(img);
end
img            = 255 - img;          % ��԰�ֽ���ֵ����
im2            = double(img);
trd            = 1.3 * mean(im2(:)); % �̶���ֵ
im2(im2 > trd) = 255;                % ��ֵ�ָ�
im2(im2 <=trd) = 0;
im2=uint8(im2);
figure;imshow(im2);
%ˮƽͶӰ(ά��ѹ��)
tmp=zeros(M,1);
for i = 1:M
    tmp(i) = sum(im2(i,:));
end
figure;plot(tmp,1:M);title('��ֱ��������');set(gca,'ydir','reverse');
%ԭͼ�ϻ��з���
img  = 255 - img;
figure;imshow(img);
for i = 1:M
    if(tmp(i)==0)
        line([1,N],[i,i]);
    end;
end