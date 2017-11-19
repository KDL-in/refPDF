
% demo�����ô��ű���д�ļ�ͼ���û����� (ͼ��ĻҶȱ任)

function myGUI_Demo_I()
%% main����myGUI_Demo_I����Ϊ��ں����͸�����Ĵ�������״̬�ĳ�ʼ��

clc;
close all;
clear all;
format compact;

%% S0��ȫ�ֱ��������������ڲ����㷨�Ͷ���Ļص�����֮�䴫�ݱ�����
% �����mainWin�ϵİ�ť�ͻ�ͼ����ϵ����
    global buttonOutput
    global axesI axesII

% ��ѡ�������uiPanel_I�ϵ���ض���
    global uiPanel_I
    global textShow_II textShow_II_L textShow_II_H textEdit_Low textEdit_High
    global radioBut_I radioBut_II radioButtonSelectionValue
 
% �˵����͹������е���ض���
    global menuI_1 menuI_2 toolbar_save
% 
% 
%% S1������������ͼ���û�����mainWin
mainWin             = figure();
mainWin.Name        = 'ͼ��Ҷȱ任ϵͳ (Demo)'; % �������ͼ�����
mainWin.NumberTitle = 'off';             % �Ƴ�������/���
mainWin.ToolBar     = 'none';            % �Ƴ�����Ĭ�ϵĹ�����
mainWin.MenuBar     = 'none';            % �Ƴ�����Ĭ�ϵĲ˵���
mainWin.Position    = [250 35 800 600];  % �ö���ĳ�ʼλ��
mainWin.Resize      = 'off';             % �ö���ߴ粻�ܱ����������
movegui(mainWin,'center');               % ������mainWin����
set(mainWin,'color',[.95 .95 .95]);      % ���øö����RGB��ɫ(ȡֵ��ΧΪ0��1)
% set(mainWin,'CloseRequestFcn',{@close_mainWin}); % ���رհ�ť����������Ӧ���ص�������
% 
% 
%% S2����mainWin�ϴ�������ť���ؼ�
% S2-1����������buttonInput����ִ�С��Ӵ�����ѡ������ͼ�񡱵Ĺ���
buttonInput          = uicontrol();
buttonInput.Parent   = mainWin;         % �ö���������mainWin��
buttonInput.Style    = 'pushbutton';    % ��������(�ؼ�����)Ϊ��ť
buttonInput.Position = [150 230 85 35]; % �ö�����mainWin�ϵ�λ��
buttonInput.String   = '����ͼ��';      % ��ť����
buttonInput.FontSize = 12;              % ���Ƶ������С
set(buttonInput,'Callback',{@buttonInput_Callback}); % �ö���Ļص�����������󴥷����ܣ��Ӵ�����ѡ������ͼ��
% 
% S2-2������������ִ�������mainWin(�ǲ˵�����)��ѡ���ͼ������
buttonOutput          = uicontrol();
buttonOutput.Parent   = mainWin;
buttonOutput.Style    = 'pushbutton';
buttonOutput.Position = [550 230 85 35];
buttonOutput.String   = 'ͼ����';
buttonOutput.FontSize = 12;
buttonOutput.Enable   = 'off'; % �ö���ĳ�ʼ״̬Ϊ�����ã����ر���ʹ��״̬(״̬'on'ʱ��ʾ����)
set(buttonOutput,'Callback',{@buttonOutput_Callback});
% 
% 
%% S3����������mainWin�ϴ�����ʾ��������ͼ�����ݵ�����ϵ����axesI��axesII
axesI   = axes( 'Position',[0 0.48 0.5 0.4]); % ����ϵ1
set(mainWin,'CurrentAxes',axesI);
axes(axesI);       % ��ָ��������ϵ�����ϣ���˴���axesI������ͼ��
temp    = imread('DIP3.JPG');
imshow(temp);
title('����ͼ��');
% 
axesII  = axes( 'Position',[0.5 0.48 0.5 0.4]); % ����ϵ2
set(mainWin,'CurrentAxes',axesII);
axes(axesII);
imshow(temp);
title('���ͼ��');
% 
axesIII = axes( 'Position',[0.45 0.58 0.1 0.2]);
set(mainWin,'CurrentAxes',axesIII);
axes(axesIII);
ArrowG  = imread('ArrowRight.JPG');
imshow(ArrowG);
% 
% 
%% S4����������mainWin�ϴ���ѡ��ͼ�����㷨���͵Ŀؼ�
% ���������������½ǣ��Ե�ѡ�����ʽѡ���㷨����
    % ��mainWin�ϴ�������panel���ؼ�(uiPanel_I)
    uiPanel_I          = uipanel();
    uiPanel_I.Parent   = mainWin;
    uiPanel_I.Title    = '��ѡ��ͼ�����㷨����ѡ��';
    uiPanel_I.FontSize = 12;
    uiPanel_I.Position = [.07 .05 .35 .3];
    uiPanel_I.Visible  = 'on'; % �ù�������δ��������ͼ��ǰ���ɼ�(������)
%     
    % ��uiPanel_I�ϴ�������radiobutton���ؼ�I��II
    radioBut_I          = uicontrol();
    radioBut_I.Parent   = uiPanel_I;
    radioBut_I.Style    = 'radiobutton';
    radioBut_I.Position = [20 125 155 20];
    radioBut_I.String   = 'ֱ��ͼ���⻯';
    radioBut_I.FontSize = 11;
    radioBut_I.Value    = 1; % ��ʼ������ֵ(1��ʾ��ʼ״̬Ϊ��ѡ�У�0��ʾ��ѡ)
    set(radioBut_I,'Callback',{@radioBut_I_Callback});
    radioButtonSelectionValue = 'ֱ��ͼ���⻯'; % ��ʼ��ȱʡ���㷨����Ϊֱ��ͼ���⻯
% 
    radioBut_II          = uicontrol();
    radioBut_II.Parent   = uiPanel_I;
    radioBut_II.Style    = 'radiobutton';
    radioBut_II.Position = [20 95 155 20];
    radioBut_II.String   = '�Ҷȼ�����������';
    radioBut_II.FontSize = 11;
    set(radioBut_II,'Callback',{@radioBut_II_Callback});
% 
    % ���Ҷȼ����������졻�㷨��Ҫ��ʾ�Ҷȼ����������������
    % �˴����������ɱ༭�ı���ֱ��Ӧ�Ҷȼ�����С�����ֵ
    textShow_II          = uicontrol();
    textShow_II.Parent   = uiPanel_I;
    textShow_II.Style    = 'text'; % ��������Ϊ��̬�ı���
    textShow_II.Position = [32 65 220 20];
    textShow_II.String   = '������Ҷȼ���������ķ�Χ��';
    textShow_II.FontSize = 11;
    textShow_II.Enable   = 'off';
%     
    textShow_II_L = uicontrol();
    textShow_II_L.Parent   = uiPanel_I;
    textShow_II_L.Style    = 'text';
    textShow_II_L.Position = [65 35 85 20];
    textShow_II_L.String   = '��Сֵ��';
    textShow_II_L.FontSize = 11;
    textShow_II_L.Enable   = 'off';
% 
    textEdit_Low  = uicontrol();
    textEdit_Low.Parent   = uiPanel_I;
    textEdit_Low.Style    = 'edit'; % �ɱ༭�ı���
    textEdit_Low.Position = [145 35 55 20];
    textEdit_Low.String   = '200'; % Ĭ�ϲ���ֵ
    textEdit_Low.FontSize = 11;
    textEdit_Low.Enable   = 'off';
%     
    textShow_II_H          = uicontrol();
    textShow_II_H.Parent   = uiPanel_I;
    textShow_II_H.Style    = 'text';
    textShow_II_H.Position = [65 5 85 20];
    textShow_II_H.String   = '���ֵ��';
    textShow_II_H.FontSize = 11;
    textShow_II_H.Enable   = 'off';
%     
    textEdit_High          = uicontrol();
    textEdit_High.Parent   = uiPanel_I;
    textEdit_High.Style    = 'edit';
    textEdit_High.Position = [145 5 55 20];
    textEdit_High.String   = '190';
    textEdit_High.FontSize = 11;
    textEdit_High.Enable   = 'off';
% 
% 
%% S5����������mainWin�ϴ����˵���
% S5-1��һ���˵�
    menuI        = uimenu();
    menuI.Label  = '�Ҷȱ任';
    menuII       = uimenu();
    menuII.Label = '����任';
% 
% S5-2�������˵�
    menuI_1        = uimenu(menuI);
    menuI_1.Label  = '��ת�任';
    menuI_1.Enable = 'off';
    set(menuI_1,'Callback',{@menuI_1_Callback});

    menuI_2        = uimenu(menuI);
    menuI_2.Label  = '���ɱ任';
    menuI_2.Enable = 'off';
    set(menuI_2,'Callback',{@menuI_2_Callback});
% 
    menuII_1        = uimenu(menuII);
    menuII_1.Label  = 'ͼ����ת';
    menuII_1.Enable = 'off';
    % set(menuII_1,'Callback',{@menuII_1_Callback});

    menuII_2       = uimenu(menuII);
    menuII_2.Label = '���Բ�ֵ';
    menuII_2.Enable = 'off';
    % set(menuII_2,'Callback',{@menuII_2_Callback});
% 
% 
%% S6����������mainWin�ϴ���������
% ����������toolbarMain
    toolbarMain                = uitoolbar();
    toolbarMain.Parent         = mainWin;
% 
% ��toolbarMain�ϴ���һ����ť
    toolbar_save               = uipushtool();
    toolbar_save.Parent        = toolbarMain;
    icon_save                  = imread('save.png'); % ��������ť��ͼ��
    toolbar_save.CData         = icon_save; % �ð�ť��ͼ��ͼ��TooltipString
    toolbar_save.TooltipString = '����ͼ��';
    toolbar_save.Enable        = 'off';
    set(toolbar_save,'ClickedCallback',{@sava_Callback});


%%
%----------------------------------------------------%
%  ���¿�ʼΪ���ؼ��Ļص���������Ӧͼ�����㷨����  %
%----------------------------------------------------%


function buttonInput_Callback(obj,event)
%% ��ť������ͼ�񡻵Ļص�����
global ima axesI axesII buttonOutput menuI_1 menuI_2 uiPanel_I
clc;

[filelist,path] = uigetfile({'*.PNG;*.jpg;*.tif',...
                  'Image Files (*.PNG,*.jpg,*.tif)'},'��ѡ������ͼ�� ...');
if (filelist == 0)
    return;
end
axes(axesI); % ��ָ����ͼ������ϵ(��axesI)����ʾͼ��
ima = imread([path,filelist]);
imshow(ima);
title(['����ͼ��',filelist]);

%     ���ɹ���һ��������ͼ��󣬸ı����ͼ�����㷨��ʹ��״̬��
% ���ɳ�ʼ��'off'״̬���'on'״̬
buttonOutput.Enable = 'on'; % 'ͼ����'��ť����
menuI_1.Enable      = 'on'; % �˵�����ת�任����
menuI_2.Enable      = 'on'; % �˵������ɱ任����
uiPanel_I.Visible   = 'on'; % ������ϵ������uiPanel_I����������(�ɼ�)

axes(axesII);
temp = zeros(size(ima));
imshow(uint8(temp));


function buttonOutput_Callback(obj,event)
%% ��ť��ͼ�����Ļص�����
global ima radioButtonSelectionValue textEdit_Low textEdit_High
global axesII im2
global toolbar_save

clc;
if (size(ima,3) ~= 1)
    h      = warndlg('����ͼ�����Ϊ��ͨ���Ҷ�ͼ��','����');
    jframe = getJFrame(h);
    jframe.setAlwaysOnTop(1);
    return;
end

axes(axesII);
switch radioButtonSelectionValue % ����radioButtonSelectionValue��ֵȷ��Ӧִ�е��㷨
    case 'ֱ��ͼ���⻯'
        [im2, ~ ] = myHistogramEqualization(ima);
        imshow(im2);
        title('ֱ��ͼ���⻯���������ͼ��');
        
    case '�Ҷȼ�����������'
        lowerGray  = round(str2double(get(textEdit_Low, 'String')));
        HigherGray = round(str2double(get(textEdit_High,'String')));
        if (lowerGray < 0) || (HigherGray > 255)
            if (lowerGray < 0)
                h  = errordlg('��С�Ҷ�ֵӦΪ�Ǹ�����','����');
            else
                h  = errordlg('8����ͼ������Ҷ�ֵ���ܳ���255��','����');
            end
            jframe = getJFrame(h);
            jframe.setAlwaysOnTop(1);
            return;
        end
        if (lowerGray > HigherGray)
            h      = errordlg('��С�Ҷ�ֵ���ܳ������Ҷ�ֵ��','����');
            jframe = getJFrame(h);
            jframe.setAlwaysOnTop(1);
            return;
        end
        para       = [lowerGray,HigherGray];
        im2        = myGrayScaleTransform(ima, para);
        imshow(im2);
        title(['�Ҷȼ��������������ͼ��[',num2str(para(1))...
               ',',num2str(para(2)),']']);
end
h      = msgbox('ͼ������ϣ�','��ʾ');
jframe = getJFrame(h);
jframe.setAlwaysOnTop(1);

% ͼ��������󣬹������еġ����桯��ť����
toolbar_save.Enable = 'on';


function radioBut_I_Callback(obj,event)
%% ��ѡ��ť��ֱ��ͼ���⻯���Ļص�����
global radioBut_I radioBut_II radioButtonSelectionValue
global textShow_II textShow_II_L textShow_II_H textEdit_Low textEdit_High
clc;

radioButtonSelectionValue = 'ֱ��ͼ���⻯';
radioBut_I.Value          = 1;
radioBut_II.Value         = 0;
textShow_II.Enable        = 'off';
textShow_II_L.Enable      = 'off';
textShow_II_H.Enable      = 'off';
textEdit_Low.Enable       = 'off';
textEdit_High.Enable      = 'off';




function radioBut_II_Callback(obj,event)
%% ��ѡ��ť���Ҷȼ����������졻�Ļص�����
global radioBut_I radioBut_II radioButtonSelectionValue
global textShow_II textShow_II_L textShow_II_H textEdit_Low textEdit_High
clc;

radioButtonSelectionValue = '�Ҷȼ�����������';
radioBut_II.Value         = 1;
radioBut_I.Value          = 0;
textShow_II.Enable        = 'on';
textShow_II_L.Enable      = 'on';
textShow_II_H.Enable      = 'on';
textEdit_Low.Enable       = 'on';
textEdit_High.Enable      = 'on';


function menuI_1_Callback(obj,event)
%% �˵������Ҷȱ任���ж����˵�����ת�任���Ļص�����
global ima axesII im2 toolbar_save

im2 = uint8(255 - double(ima));
axes(axesII);
imshow(im2);
title('�Ҷȷ�ת�任');

toolbar_save.Enable = 'on';
h                   = msgbox('ͼ������ϣ�','��ʾ');
jframe              = getJFrame(h);
jframe.setAlwaysOnTop(1);


function menuI_2_Callback(obj,event)
%% �˵������Ҷȱ任���ж����˵������ɱ任���Ļص�����
global ima axesII im2 toolbar_save
clc;

if (size(ima,3) ~= 1)
    h      = warndlg('����ͼ�����Ϊ��ͨ���Ҷ�ͼ��','����');
    jframe = getJFrame(h);
    jframe.setAlwaysOnTop(1);
    return;
else
    prompt = {'���������ɱ任ָ����'};
    tips   = '���ɱ任';
    gamma  = inputdlg(prompt,tips,1,{'3'});
    if isempty(gamma)
        return;
    end
end

temp = mat2gray(double(ima));
temp = temp .^ str2double(gamma);
im2  = im2uint8(temp);

axes(axesII);
imshow(im2);
title('���ɱ任');

toolbar_save.Enable = 'on';
h                   = msgbox('ͼ������ϣ�','��ʾ');
jframe              = getJFrame(h);
jframe.setAlwaysOnTop(1);


function sava_Callback(obj,event)
%% ����sava_Callback����������toolbar_save��ť�Ļص�����
global im2

[filename, ~ ] = uiputfile({'*.jpg','JEPGͼ���ļ� (*.jpg)'},...
                             '���洦����ͼ��','��ͼ��.jpg');
if (filename==0)
    return;
else
    imwrite(im2,filename,'jpg');
end


function close_mainWin(src,evnt)
%% ����close_mainWinΪ�ر�������mainWinʱ���õĺ���

value = questdlg('Ҫ�˳���Demo��','�˳�','��','��','��');
switch value 
    case '��'
        clc;
        delete(gcf);
        close all;
        clear all;
    otherwise
        return;
end


function [im2,func_T] = myHistogramEqualization(im1)
%% ������myHistogramEqualization
% �������ܣ�������ͼ�����ֱ��ͼ���⻯
%      im1����СΪr��c��1�ĵ�ͨ���Ҷ�ͼ��
%      im2��ֱ��ͼ���⻯���������ͼ��
%   func_T���任����

[r,c]  = size(im1);
im1    = double(im1(:));
im2    = zeros(r*c,1);
L      = 256;
H1     = zeros(1,L);           % ����ͼ��im1�ĻҶ�ֱ��ͼ
H_sum  = 0;
func_T = H1;

for k = 1 : L                  % �Ҷȼ�ӳ��
    rk        = k - 1;         % ��k���Ҷȼ�
    ind       = find(im1==rk);
    H1(k)     = length(ind)/(r*c);
    H_sum     = H_sum + H1(k); % CDF
    func_T(k) = (L-1)*H_sum;
    im2(ind)  = round(func_T(k));
end

im2 = uint8(reshape(im2,r,c));


function img2 = myGrayScaleTransform(img1, para)
%% ����myGrayScaleTransform
% �������ܣ�������ͼ��img1�ĻҶȼ���Χ����������[para(1), para(2)]

img1  = double(img1);
[r,c] = size(img1);
imgv  = img1(:);
imgv  = para(1) + (para(2) - para(1)) * (imgv - min(imgv)) / (max(imgv) - min(imgv));
img2  = reshape(imgv,r,c);
img2  = uint8(img2);


function JFrame = getJFrame(hfig)
%% ����getJFrame��ͼ�δ�������
% hfig�Ǿ��
error(nargchk(1,1,nargin));
if ~ishandle(hfig) && ~isequal(get(hfig,'Type'),'figure')
    error('The input argument must be a Figure handle.');
end

if isequal(get(hfig,'NumberTitle'),'off') && isempty(get(hfig,'Name'))
    figTag = 'junziyang';
    set(hfig,'Name',figTag);
elseif isequal(get(hfig,'NumberTitle'),'on') && isempty(get(hfig,'Name'))
    figTag = ['Figure ',num2str(hfig)];
elseif isequal(get(hfig,'NumberTitle'),'off') && ~isempty(get(hfig,'Name'))
    figTag = get(hfig,'Name');
else
    figTag = ['Figure ',num2str(hfig),': ',get(hfig,'Name')];
end

drawnow;
mde        = com.mathworks.mde.desk.MLDesktop.getInstance;
jfig       = mde.getClient(figTag);
JFrame     = jfig.getRootPane.getParent();
if isequal(get(hfig,'Name'),'junziyang')
    set(hfig,'Name','');
end