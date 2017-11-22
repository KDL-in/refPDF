function section_division_main()
%% 测试段落切分
clc
close all
clear all
img = imread('page.jpg');
[M N] = size(img);
%二值化
if (size(img,3) ~= 1)                % 要求输入图像为单通道灰度图像
    img        = rgb2gray(img);
end
img            = 255 - img;          % 针对白纸黑字的情况
im2            = double(img);
trd            = 1.3 * mean(im2(:)); % 固定阈值
im2(im2 > trd) = 255;                % 阈值分割
im2(im2 <=trd) = 0;
im2=uint8(im2);
figure;imshow(im2);
%水平投影(维度压缩)
tmp=zeros(M,1);
for i = 1:M
    tmp(i) = sum(im2(i,:));
end
figure;plot(tmp,1:M);title('垂直方向像素');set(gca,'ydir','reverse');
%原图上画切分线
img  = 255 - img;
figure;imshow(img);
for i = 1:M
    if(tmp(i)==0)
        line([1,N],[i,i]);
    end;
end