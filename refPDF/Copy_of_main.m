
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
%--text-indent ��������
%--�������û�����,��Ĭ��ֵ,������ͨ������������
%--x ���Ͻ�x
%--y ���Ͻ�y
%--Fx �������� ���ĵ���/ԭ�ĵ���





% func_sectionReflow();%���ڶ��зֵ�����




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


%% ��ʾĳһ��,debug��
function showRow(i)
global properties;
global imgs;
x =1;
y= properties.allRows(i,1)+1;
h = properties.allRows(i,2)-properties.allRows(i,1)-1;
w=size(imgs.b,2);
figure;imshow(func_getThePartOf('binary',x,y,w,h));







    
    