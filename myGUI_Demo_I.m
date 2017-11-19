
% demo：采用纯脚本编写的简单图形用户界面 (图像的灰度变换)

function myGUI_Demo_I()
%% main函数myGUI_Demo_I：作为入口函数和各对象的创建及其状态的初始化

clc;
close all;
clear all;
format compact;

%% S0：全局变量声明（用于在部分算法和对象的回调函数之间传递变量）
% 主面板mainWin上的按钮和绘图坐标系对象
    global buttonOutput
    global axesI axesII

% 单选框子面板uiPanel_I上的相关对象
    global uiPanel_I
    global textShow_II textShow_II_L textShow_II_H textEdit_Low textEdit_High
    global radioBut_I radioBut_II radioButtonSelectionValue
 
% 菜单栏和工具栏中的相关对象
    global menuI_1 menuI_2 toolbar_save
% 
% 
%% S1：创建主界面图像用户对象mainWin
mainWin             = figure();
mainWin.Name        = '图像灰度变换系统 (Demo)'; % 对象类型及名称
mainWin.NumberTitle = 'off';             % 移除对象编号/序号
mainWin.ToolBar     = 'none';            % 移除所有默认的工具栏
mainWin.MenuBar     = 'none';            % 移除所有默认的菜单栏
mainWin.Position    = [250 35 800 600];  % 该对象的初始位置
mainWin.Resize      = 'off';             % 该对象尺寸不能被调整或最大化
movegui(mainWin,'center');               % 主界面mainWin居中
set(mainWin,'color',[.95 .95 .95]);      % 设置该对象的RGB颜色(取值范围为0～1)
% set(mainWin,'CloseRequestFcn',{@close_mainWin}); % 『关闭按钮』触发的响应（回调函数）
% 
% 
%% S2：在mainWin上创建『按钮』控件
% S2-1：创建对象buttonInput，以执行“从磁盘中选择输入图像”的功能
buttonInput          = uicontrol();
buttonInput.Parent   = mainWin;         % 该对象依附在mainWin上
buttonInput.Style    = 'pushbutton';    % 对象类型(控件类型)为按钮
buttonInput.Position = [150 230 85 35]; % 该对象在mainWin上的位置
buttonInput.String   = '输入图像';      % 按钮名称
buttonInput.FontSize = 12;              % 名称的字体大小
set(buttonInput,'Callback',{@buttonInput_Callback}); % 该对象的回调函数，点击后触发功能：从磁盘中选择输入图像
% 
% S2-2：创建对象，以执行在面板mainWin(非菜单栏区)上选择的图像处理功能
buttonOutput          = uicontrol();
buttonOutput.Parent   = mainWin;
buttonOutput.Style    = 'pushbutton';
buttonOutput.Position = [550 230 85 35];
buttonOutput.String   = '图像处理';
buttonOutput.FontSize = 12;
buttonOutput.Enable   = 'off'; % 该对象的初始状态为不可用，即关闭其使能状态(状态'on'时表示可用)
set(buttonOutput,'Callback',{@buttonOutput_Callback});
% 
% 
%% S3：在主界面mainWin上创建显示输入和输出图像数据的坐标系对象axesI和axesII
axesI   = axes( 'Position',[0 0.48 0.5 0.4]); % 坐标系1
set(mainWin,'CurrentAxes',axesI);
axes(axesI);       % 在指定的坐标系对象上（如此处的axesI）绘制图像
temp    = imread('DIP3.JPG');
imshow(temp);
title('输入图像');
% 
axesII  = axes( 'Position',[0.5 0.48 0.5 0.4]); % 坐标系2
set(mainWin,'CurrentAxes',axesII);
axes(axesII);
imshow(temp);
title('输出图像');
% 
axesIII = axes( 'Position',[0.45 0.58 0.1 0.2]);
set(mainWin,'CurrentAxes',axesIII);
axes(axesIII);
ArrowG  = imread('ArrowRight.JPG');
imshow(ArrowG);
% 
% 
%% S4：在主界面mainWin上创建选择图像处理算法类型的控件
% 创建于主界面左下角：以单选框的形式选择算法类型
    % 在mainWin上创建对象『panel』控件(uiPanel_I)
    uiPanel_I          = uipanel();
    uiPanel_I.Parent   = mainWin;
    uiPanel_I.Title    = '请选择图像处理算法（单选框）';
    uiPanel_I.FontSize = 12;
    uiPanel_I.Position = [.07 .05 .35 .3];
    uiPanel_I.Visible  = 'on'; % 该功能区在未加载输入图像前不可见(不可用)
%     
    % 在uiPanel_I上创建对象『radiobutton』控件I和II
    radioBut_I          = uicontrol();
    radioBut_I.Parent   = uiPanel_I;
    radioBut_I.Style    = 'radiobutton';
    radioBut_I.Position = [20 125 155 20];
    radioBut_I.String   = '直方图均衡化';
    radioBut_I.FontSize = 11;
    radioBut_I.Value    = 1; % 初始化参数值(1表示初始状态为被选中，0表示不选)
    set(radioBut_I,'Callback',{@radioBut_I_Callback});
    radioButtonSelectionValue = '直方图均衡化'; % 初始化缺省的算法类型为直方图均衡化
% 
    radioBut_II          = uicontrol();
    radioBut_II.Parent   = uiPanel_I;
    radioBut_II.Style    = 'radiobutton';
    radioBut_II.Position = [20 95 155 20];
    radioBut_II.String   = '灰度级的线性拉伸';
    radioBut_II.FontSize = 11;
    set(radioBut_II,'Callback',{@radioBut_II_Callback});
% 
    % 『灰度级的线性拉伸』算法需要表示灰度级区间的两个参数，
    % 此处创建两个可编辑文本框分别对应灰度级的最小和最大值
    textShow_II          = uicontrol();
    textShow_II.Parent   = uiPanel_I;
    textShow_II.Style    = 'text'; % 对象类型为静态文本框
    textShow_II.Position = [32 65 220 20];
    textShow_II.String   = '请输入灰度级线性拉伸的范围：';
    textShow_II.FontSize = 11;
    textShow_II.Enable   = 'off';
%     
    textShow_II_L = uicontrol();
    textShow_II_L.Parent   = uiPanel_I;
    textShow_II_L.Style    = 'text';
    textShow_II_L.Position = [65 35 85 20];
    textShow_II_L.String   = '最小值：';
    textShow_II_L.FontSize = 11;
    textShow_II_L.Enable   = 'off';
% 
    textEdit_Low  = uicontrol();
    textEdit_Low.Parent   = uiPanel_I;
    textEdit_Low.Style    = 'edit'; % 可编辑文本框
    textEdit_Low.Position = [145 35 55 20];
    textEdit_Low.String   = '200'; % 默认参数值
    textEdit_Low.FontSize = 11;
    textEdit_Low.Enable   = 'off';
%     
    textShow_II_H          = uicontrol();
    textShow_II_H.Parent   = uiPanel_I;
    textShow_II_H.Style    = 'text';
    textShow_II_H.Position = [65 5 85 20];
    textShow_II_H.String   = '最大值：';
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
%% S5：在主界面mainWin上创建菜单栏
% S5-1：一级菜单
    menuI        = uimenu();
    menuI.Label  = '灰度变换';
    menuII       = uimenu();
    menuII.Label = '仿射变换';
% 
% S5-2：二级菜单
    menuI_1        = uimenu(menuI);
    menuI_1.Label  = '反转变换';
    menuI_1.Enable = 'off';
    set(menuI_1,'Callback',{@menuI_1_Callback});

    menuI_2        = uimenu(menuI);
    menuI_2.Label  = '幂律变换';
    menuI_2.Enable = 'off';
    set(menuI_2,'Callback',{@menuI_2_Callback});
% 
    menuII_1        = uimenu(menuII);
    menuII_1.Label  = '图像旋转';
    menuII_1.Enable = 'off';
    % set(menuII_1,'Callback',{@menuII_1_Callback});

    menuII_2       = uimenu(menuII);
    menuII_2.Label = '线性插值';
    menuII_2.Enable = 'off';
    % set(menuII_2,'Callback',{@menuII_2_Callback});
% 
% 
%% S6：在主界面mainWin上创建工具栏
% 创建工具栏toolbarMain
    toolbarMain                = uitoolbar();
    toolbarMain.Parent         = mainWin;
% 
% 在toolbarMain上创建一个按钮
    toolbar_save               = uipushtool();
    toolbar_save.Parent        = toolbarMain;
    icon_save                  = imread('save.png'); % 工具栏按钮的图标
    toolbar_save.CData         = icon_save; % 该按钮的图案图标TooltipString
    toolbar_save.TooltipString = '保存图像';
    toolbar_save.Enable        = 'off';
    set(toolbar_save,'ClickedCallback',{@sava_Callback});


%%
%----------------------------------------------------%
%  以下开始为各控件的回调函数和相应图像处理算法函数  %
%----------------------------------------------------%


function buttonInput_Callback(obj,event)
%% 按钮『输入图像』的回调函数
global ima axesI axesII buttonOutput menuI_1 menuI_2 uiPanel_I
clc;

[filelist,path] = uigetfile({'*.PNG;*.jpg;*.tif',...
                  'Image Files (*.PNG,*.jpg,*.tif)'},'请选择输入图像 ...');
if (filelist == 0)
    return;
end
axes(axesI); % 在指定的图像坐标系(即axesI)上显示图像
ima = imread([path,filelist]);
imshow(ima);
title(['输入图像：',filelist]);

%     当成功打开一幅待处理图像后，改变相关图像处理算法的使能状态，
% 即由初始的'off'状态变成'on'状态
buttonOutput.Enable = 'on'; % '图像处理'按钮可用
menuI_1.Enable      = 'on'; % 菜单：反转变换可用
menuI_2.Enable      = 'on'; % 菜单：幂律变换可用
uiPanel_I.Visible   = 'on'; % 主面板上的字面板uiPanel_I功能区可用(可见)

axes(axesII);
temp = zeros(size(ima));
imshow(uint8(temp));


function buttonOutput_Callback(obj,event)
%% 按钮『图像处理』的回调函数
global ima radioButtonSelectionValue textEdit_Low textEdit_High
global axesII im2
global toolbar_save

clc;
if (size(ima,3) ~= 1)
    h      = warndlg('输入图像必须为单通道灰度图像','警告');
    jframe = getJFrame(h);
    jframe.setAlwaysOnTop(1);
    return;
end

axes(axesII);
switch radioButtonSelectionValue % 根据radioButtonSelectionValue的值确定应执行的算法
    case '直方图均衡化'
        [im2, ~ ] = myHistogramEqualization(ima);
        imshow(im2);
        title('直方图均衡化处理后的输出图像');
        
    case '灰度级的线性拉伸'
        lowerGray  = round(str2double(get(textEdit_Low, 'String')));
        HigherGray = round(str2double(get(textEdit_High,'String')));
        if (lowerGray < 0) || (HigherGray > 255)
            if (lowerGray < 0)
                h  = errordlg('最小灰度值应为非负数！','错误');
            else
                h  = errordlg('8比特图像的最大灰度值不能超过255！','错误');
            end
            jframe = getJFrame(h);
            jframe.setAlwaysOnTop(1);
            return;
        end
        if (lowerGray > HigherGray)
            h      = errordlg('最小灰度值不能超过最大灰度值！','错误');
            jframe = getJFrame(h);
            jframe.setAlwaysOnTop(1);
            return;
        end
        para       = [lowerGray,HigherGray];
        im2        = myGrayScaleTransform(ima, para);
        imshow(im2);
        title(['灰度级线性拉伸后的输出图像：[',num2str(para(1))...
               ',',num2str(para(2)),']']);
end
h      = msgbox('图像处理完毕！','提示');
jframe = getJFrame(h);
jframe.setAlwaysOnTop(1);

% 图像处理结束后，工具栏中的‘保存’按钮可用
toolbar_save.Enable = 'on';


function radioBut_I_Callback(obj,event)
%% 单选按钮『直方图均衡化』的回调函数
global radioBut_I radioBut_II radioButtonSelectionValue
global textShow_II textShow_II_L textShow_II_H textEdit_Low textEdit_High
clc;

radioButtonSelectionValue = '直方图均衡化';
radioBut_I.Value          = 1;
radioBut_II.Value         = 0;
textShow_II.Enable        = 'off';
textShow_II_L.Enable      = 'off';
textShow_II_H.Enable      = 'off';
textEdit_Low.Enable       = 'off';
textEdit_High.Enable      = 'off';




function radioBut_II_Callback(obj,event)
%% 单选按钮『灰度级的线性拉伸』的回调函数
global radioBut_I radioBut_II radioButtonSelectionValue
global textShow_II textShow_II_L textShow_II_H textEdit_Low textEdit_High
clc;

radioButtonSelectionValue = '灰度级的线性拉伸';
radioBut_II.Value         = 1;
radioBut_I.Value          = 0;
textShow_II.Enable        = 'on';
textShow_II_L.Enable      = 'on';
textShow_II_H.Enable      = 'on';
textEdit_Low.Enable       = 'on';
textEdit_High.Enable      = 'on';


function menuI_1_Callback(obj,event)
%% 菜单栏『灰度变换』中二级菜单『反转变换』的回调函数
global ima axesII im2 toolbar_save

im2 = uint8(255 - double(ima));
axes(axesII);
imshow(im2);
title('灰度反转变换');

toolbar_save.Enable = 'on';
h                   = msgbox('图像处理完毕！','提示');
jframe              = getJFrame(h);
jframe.setAlwaysOnTop(1);


function menuI_2_Callback(obj,event)
%% 菜单栏『灰度变换』中二级菜单『幂律变换』的回调函数
global ima axesII im2 toolbar_save
clc;

if (size(ima,3) ~= 1)
    h      = warndlg('输入图像必须为单通道灰度图像','警告');
    jframe = getJFrame(h);
    jframe.setAlwaysOnTop(1);
    return;
else
    prompt = {'请输入幂律变换指数：'};
    tips   = '幂律变换';
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
title('幂律变换');

toolbar_save.Enable = 'on';
h                   = msgbox('图像处理完毕！','提示');
jframe              = getJFrame(h);
jframe.setAlwaysOnTop(1);


function sava_Callback(obj,event)
%% 函数sava_Callback：工具栏上toolbar_save按钮的回调函数
global im2

[filename, ~ ] = uiputfile({'*.jpg','JEPG图像文件 (*.jpg)'},...
                             '保存处理后的图像','新图像.jpg');
if (filename==0)
    return;
else
    imwrite(im2,filename,'jpg');
end


function close_mainWin(src,evnt)
%% 函数close_mainWin为关闭主界面mainWin时调用的函数

value = questdlg('要退出本Demo？','退出','是','否','是');
switch value 
    case '是'
        clc;
        delete(gcf);
        close all;
        clear all;
    otherwise
        return;
end


function [im2,func_T] = myHistogramEqualization(im1)
%% 函数：myHistogramEqualization
% 函数功能：对输入图像进行直方图均衡化
%      im1：大小为r×c×1的单通道灰度图像
%      im2：直方图均衡化处理后的输出图像
%   func_T：变换函数

[r,c]  = size(im1);
im1    = double(im1(:));
im2    = zeros(r*c,1);
L      = 256;
H1     = zeros(1,L);           % 输入图像im1的灰度直方图
H_sum  = 0;
func_T = H1;

for k = 1 : L                  % 灰度级映射
    rk        = k - 1;         % 第k个灰度级
    ind       = find(im1==rk);
    H1(k)     = length(ind)/(r*c);
    H_sum     = H_sum + H1(k); % CDF
    func_T(k) = (L-1)*H_sum;
    im2(ind)  = round(func_T(k));
end

im2 = uint8(reshape(im2,r,c));


function img2 = myGrayScaleTransform(img1, para)
%% 函数myGrayScaleTransform
% 函数功能：将输入图像img1的灰度级范围线性拉伸至[para(1), para(2)]

img1  = double(img1);
[r,c] = size(img1);
imgv  = img1(:);
imgv  = para(1) + (para(2) - para(1)) * (imgv - min(imgv)) / (max(imgv) - min(imgv));
img2  = reshape(imgv,r,c);
img2  = uint8(img2);


function JFrame = getJFrame(hfig)
%% 函数getJFrame：图形窗口属性
% hfig是句柄
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