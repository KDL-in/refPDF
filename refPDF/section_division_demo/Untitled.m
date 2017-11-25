% I=imread('page.jpg');
% imshow(I);
% %画图后：
% h=imrect;%鼠标变成十字，用来选取感兴趣区域
% %图中就会出现可以拖动以及改变大小的矩形框，选好位置后：
% pos=getPosition(h);
% %pos有四个值，分别是矩形框的左下角点的坐标 x y 和 框的 宽度和高度
% %拷贝选取图片
% imCp = imcrop( I, pos );
% figure(2)
% imshow(imCp);
arr = zeros(1,4);
arr(1:4)=[1,2,3,4]