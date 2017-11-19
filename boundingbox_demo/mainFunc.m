function mainFunc()
%% 测试boundingBox
img = imread('text.jpg');
% 注：本demo中尚未采用输入图像的自适应分割算法，以下是固定阈值方法
if (size(img,3) ~= 1)                % 要求输入图像为单通道灰度图像
    img        = rgb2gray(img);
end
img            = 255 - img;          % 针对白纸黑字的情况
im2            = double(img);
trd            = 1.3 * mean(im2(:)); % 固定阈值
im2(im2 > trd) = 255;                % 阈值分割
im2(im2 <=trd) = 0;
func_boundingBoxes(img,im2,'show',[4 4]);

%% 画出最小矩形函数
function [BoundingBox,ROIs] = func_boundingBoxes(img,s_img,Type,para)%tag
% img 原灰度图
% s_img 二值图
% Type 是否可见
% para 连通区域
% function: return the bounding box of each petential connected regions 
%          from the binary imgge s_img and extract the imgge contents of 
%          the corresponding bounding boxes
% author: Steven Chong (jiajunzhuang@126.com)

[Label_img,num] = bwlabel(s_img,8);%用相同数字标记相同8连通区域,并返回连通块数量
areaBB          = regionprops(Label_img,'BoundingBox');%返回不同连通区域的最小矩阵,areaBB为num个结构信息
[H,W]           = size(img);
j               = 0;
t               = zeros(1,num);%1维num列的矩阵,num是字符数
a               = para(1);
b               = para(2);
for i = 1:num%筛选,统计连通区域的数量及其下标,放在t里
    if (areaBB(i).BoundingBox(3)>=a) && (areaBB(i).BoundingBox(4)>=b) % 6 5 
        j    = j + 1;
        t(j) = i;
    end
end
t(j+1:end) = [];%剩下的维度丢掉

if strcmp(Type,'show')%显示原图
    imshow(img);
end
BoundingBox = zeros(j,4);%j行4列的数组
ROIs        = cell(j,1);%j行1列的元胞数组
for i = 1:size(t,2)%遍历每个连通区域
    temp             = areaBB(t(i)).BoundingBox;%取出连通区域的信息
    BoundingBox(i,:) = temp;%x y width height
    %%根据信息画出矩形
    if strcmp(Type,'show')
        if (temp(3)<8) && (temp(4)<12)
        	rectangle('Position',temp,'LineWidth',2,...
                'LineStyle','-','edgecolor','m') % target?
        else
            rectangle('Position',temp,'LineWidth',2,...
                'LineStyle','-','edgecolor','b')%tag 画矩形
        end
        %%%矩形左下或左上的小数字
%         cc = [':',num2str(temp(3)),'×',num2str(temp(4))];
%         x = temp(1);
%         if mod(i,2)==0
%             y = temp(2) + temp(4) + 8;
%             text(x-8,y,num2str(i),'color','r','fontsize',10)
%         else
%             y = temp(2) - 8;
%             text(x-8,y,num2str(i),'color','r','fontsize',10)
%         end
    end
    %%以下, 从连通区域信息中取出图像部分放于元胞rols{i}中
    indx      = floor(temp(1));%左上坐标向下取整
    indy      = floor(temp(2));
    if (indx == 0)
        indx  = indx+1;
    end
    if (indy == 0)
        indy  = indy+1;
    end
    
    indwidth      = temp(3);%长宽调整
    indheight     = temp(4);
    if (indy + indheight > H)
        indheight = indheight - 1;
    end
    if (indx + indwidth > W)
        indwidth  = indwidth - 1;
    end
    ROIs{i}       = img(indy:(indy+indheight),indx:(indx+indwidth));
end
