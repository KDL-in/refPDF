% I=imread('page.jpg');
% imshow(I);
% %��ͼ��
% h=imrect;%�����ʮ�֣�����ѡȡ����Ȥ����
% %ͼ�оͻ���ֿ����϶��Լ��ı��С�ľ��ο�ѡ��λ�ú�
% pos=getPosition(h);
% %pos���ĸ�ֵ���ֱ��Ǿ��ο�����½ǵ������ x y �� ��� ��Ⱥ͸߶�
% %����ѡȡͼƬ
% imCp = imcrop( I, pos );
% figure(2)
% imshow(imCp);
arr = zeros(1,4);
arr(1:4)=[1,2,3,4]