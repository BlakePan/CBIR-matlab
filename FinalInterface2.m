function varargout = FinalInterface2(varargin)
% FINALINTERFACE2 M-file for FinalInterface2.fig
%      FINALINTERFACE2, by itself, creates a new FINALINTERFACE2 or raises the existing
%      singleton*.
%
%      H = FINALINTERFACE2 returns the handle to a new FINALINTERFACE2 or the handle to
%      the existing singleton*.
%
%      FINALINTERFACE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALINTERFACE2.M with the given input arguments.
%
%      FINALINTERFACE2('Property','Value',...) creates a new FINALINTERFACE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FinalInterface2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FinalInterface2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FinalInterface2

% Last Modified by GUIDE v2.5 17-Jun-2010 15:03:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FinalInterface2_OpeningFcn, ...
                   'gui_OutputFcn',  @FinalInterface2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FinalInterface2 is made visible.
function FinalInterface2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FinalInterface2 (see VARARGIN)

% Choose default command line output for FinalInterface2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FinalInterface2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FinalInterface2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%選圖檔

global file_name
global page
[filename,pathname]=uigetfile({'*.jpg';'*.tif';'*.png'},'Select an image');
query=double(filename);             %開圖檔檔名 query
file_name=0;
page=0;
axes(handles.axes1);
img1=imread(filename);
imshow(img1);
T=1;
for i=1:1000
    if query(i)==46
        dot=i;
        for j=1:dot-1
        file_name=file_name+10^(dot-j-1)*(query(j)-48);%ASCII 轉換
        end
        break;
    end
end
set(handles.edit1,'String',num2str([pathname filename]));
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%search
%讀圖輸入至大矩陣
global file_name
global page
global hue_index1
flag=0;
pic_num=str2num(get(handles.edit3,'String'));
cut_value=4;cols=80;rows=80; 
pixel=(rows/cut_value)*(cols/cut_value);
IB=zeros(rows,cols);
Img_matrix=[];
img_matrix=[];
I_matrix=[];
 h = waitbar(0,'Please wait...');
 steps=pic_num;
for w=1:pic_num
%     Img_matrixBIN=0;Img_matrixRGB=0;
    Name=[num2str(w) '.jpg'];       
    img=imread(Name);               %利用回圈讀圖檔
    img=imresize(img,[rows cols]);  %將讀進的圖檔修正維度

%--------------------------------------------------------------------------
    I_block=0;
    II=rgb2hsv(img);
    I_hue=II(:,:,1);
    I_sat=II(:,:,2);
    I_value=II(:,:,3);           %分三層取主要色調 HSV

     for j=1:cut_value:cols
         for i=1:cut_value:rows
            I_block=I_hue(i:i+cut_value-1,j:j+cut_value-1);
            [counts x]=imhist(I_block,16);
            [C index]=max(counts);
            major=x(index);
            I_block(1:cut_value,1:cut_value)=major;
            I_hue(i:i+cut_value-1,j:j+cut_value-1)=I_block;
         end
     end
      for j=1:cut_value:cols
         for i=1:cut_value:rows
            I_block=I_sat(i:i+cut_value-1,j:j+cut_value-1);
            [counts x]=imhist(I_block,16);
            [C index]=max(counts);
            major=x(index);
            I_block(1:cut_value,1:cut_value)=major;
            I_sat(i:i+cut_value-1,j:j+cut_value-1)=I_block;
         end
      end
      for j=1:cut_value:cols
         for i=1:cut_value:rows
            I_block=I_value(i:i+cut_value-1,j:j+cut_value-1);
            [counts x]=imhist(I_block,16);
            [C index]=max(counts);
            major=x(index);
            I_block(1:cut_value,1:cut_value)=major;
            I_value(i:i+cut_value-1,j:j+cut_value-1)=I_block;
         end
     end
    I(:,:,1)=I_hue;
    I(:,:,2)=I_sat;
    I(:,:,3)=I_value;
%--------------------------------------------------------------------------
    IB=rgb2gray(hsv2rgb(I));        %RGB轉gray
%     figure;imshow(IB)
    IB=double(edge(IB));
%     figure;imshow(IB)
     Img_matrix=[Img_matrix IB];       %將處理過的圖組合成大矩陣以便處理
     img_matrix=[img_matrix II];        %儲存HSV Model轉換後(未切割)
     I_matrix=[I_matrix I];            %儲存HSV Model轉換後(切割後)
      step=w;
      waitbar(step / pic_num);
end
close(h);

%--------------------------------------------------------------------------
%從大矩陣將資料輸入至ART1網路 
%輸入層類神經元數量 = (rows*cols) 
%輸出層最多與輸入資料筆數相同 <= pic_num
first_lay=(rows*cols);
second_lay=pic_num;
j_num=0;
w=ones(first_lay,second_lay);           %權重值初始為1;
group=zeros(pic_num,2);                 %記錄輸入的圖被分類到哪一群
enable=zeros(pic_num,1);                %標記哪些類神經元曾被致能 enable=1 disable=0
network_flag=0;
S2_flag=0;
nocut_flag=0;
P=0.34;                                 %vigilance parameter 警戒值
beta=0.1;
S1_struct=zeros(pic_num,1);
S2_struct=zeros(pic_num,1);
en_count=0;
%--------------------------------------------------------------------------
 h = waitbar(0,'Please wait...');
 steps=pic_num;
for network=1:pic_num
    S2_flag=0;
    en_count=0;
    X=thershold(double(Img_matrix(1:rows,1+(network-1)*cols:cols+(network-1)*cols)));%從大矩陣依序取出輸入圖樣
    XX=X;
    cut=0;cut2=0;
%--------------------------------------------------------------------------    
%將圖中空白區域切除 取出重點的部位
    for i=1:rows
            if X(i,:)==zeros(1,cols) 
                cut_row=i-cut;
                XX(cut_row,:)=[];
                cut=cut+1;
            end
    end
    X=XX;
    
    for j=1:cols
        if X(:,j)==zeros(rows-cut,1)
            cut_col=j-cut2;
            XX(:,cut_col)=[];
            cut2=cut2+1;
        end
    end    
    if abs(cut-cut2)>60
        XX=X;
        nocut_flag=1;                   %圖中'主角'不明顯者 不切(nocut_flag=1)
    end

%--------------------------------------------------------------------------    
    x1=imresize(XX,[rows,cols]);        %修改維度
    h2=fspecial('sobel');
    x1=imfilter(x1,h2);                 %濾波 
    x1=imfilter(x1,h2');                 %濾波     
    x=thershold(double(reshape(x1,(rows*cols),1)));%將圖轉成輸入向量  
    if network_flag==0                  
        j_num=1;                        %第一張圖樣輸入 令第一個類神經元為得勝者
        w(:,j_num)=w(:,j_num).*x;       %修正鍵結值
        group(network,1)=j_num;         %分群
        enable(j_num)=1;                %使第一個類神經元致能
        network_flag=1;                 
        new_num=1;                      %已被致能的類神經元數目
    else                                %從第二張開始 找出曾經得勝的類神經元 如無一符合 致能新的類神經元
        for j_num=1:second_lay          %檢索已被致能過的類神經元
            if enable(j_num)==1 
            S1_struct(j_num)=S1(w(:,j_num),x,beta);%選出得勝者
            en_count=en_count+1;
            end
        end
        
        [winner,win_index]=sort(S1_struct,'descend');%排序得勝者 由大到小
        for s1_count=1:en_count
                if S2_flag==0
                    j_num=win_index(s1_count);%找出得勝者屬於哪顆類神經元  
                    s2=S2(w(:,j_num),x);%看相似度是否達到警戒值
                    if s2>=P            %若達到警戒值 將輸入分至得勝之類神經元 並修改鍵結值
                        w(:,j_num)=w(:,j_num).*x;%修改鍵結值
                        group(network,1)=j_num;%分群       
                        S2_flag=1;
                    end
                end
        end

        if S2_flag==0                   %若沒達到警戒值 致能新的一個類神經元 並修改鍵結值
            enable=[1;enable];
            enable=enable(1:pic_num,1); %更新致能情況
            new_num=sum(enable);        %致能類神經元總數
            w(:,new_num)=w(:,new_num).*x;%修改鍵結值
            group(network,1)=new_num;   %分群
        end
    end
 step=network;
 waitbar(step / steps);    
end
close(h);
%--------------------------------------------------------------------------
diff=0;
Ave_Hue=zeros(pic_num,1);
Diff_hue=zeros(pic_num,1);
Diff_sat=zeros(pic_num,1);
Diff_value=zeros(pic_num,1);
Diff=zeros(pic_num,3);
for check=1:pic_num
    if file_name<=pic_num
    QUE=I_matrix(:,cols*(file_name-1)+1:cols*(file_name),:);%取出所選擇的圖(HSV)
    else
    Name33=[num2str(file_name) '.jpg'];       
    img33=imread(Name33);               %利用回圈讀圖檔
    img33=imresize(img33,[rows cols]);  %將讀進的圖檔修正維度
    I_block=0;
    QUE=rgb2hsv(img33);
    I_hue=QUE(:,:,1);
    I_sat=QUE(:,:,2);
    I_value=QUE(:,:,3);           %分三層取主要色調 HSV

     for j=1:cut_value:cols
         for i=1:cut_value:rows
            I_block=I_hue(i:i+cut_value-1,j:j+cut_value-1);
            [counts x]=imhist(I_block,16);
            [C index]=max(counts);
            major=x(index);
            I_block(1:cut_value,1:cut_value)=major;
            I_hue(i:i+cut_value-1,j:j+cut_value-1)=I_block;
         end
     end
      for j=1:cut_value:cols
         for i=1:cut_value:rows
            I_block=I_sat(i:i+cut_value-1,j:j+cut_value-1);
            [counts x]=imhist(I_block,16);
            [C index]=max(counts);
            major=x(index);
            I_block(1:cut_value,1:cut_value)=major;
            I_sat(i:i+cut_value-1,j:j+cut_value-1)=I_block;
         end
      end
      for j=1:cut_value:cols
         for i=1:cut_value:rows
            I_block=I_value(i:i+cut_value-1,j:j+cut_value-1);
            [counts x]=imhist(I_block,16);
            [C index]=max(counts);
            major=x(index);
            I_block(1:cut_value,1:cut_value)=major;
            I_value(i:i+cut_value-1,j:j+cut_value-1)=I_block;
         end
     end
    QUE(:,:,1)=I_hue;
    QUE(:,:,2)=I_sat;
    QUE(:,:,3)=I_value;
    end     
     

    Hue=I_matrix(:,cols*(check-1)+1:cols*(check),1);
    Ave_Hue(check)=sum(sum(Hue))/(rows*cols);               %紀錄平均色調
    
    diff_hue=abs(QUE(:,:,1)-I_matrix(:,cols*(check-1)+1:cols*(check),1));%計算差異
    diff_sat=abs(QUE(:,:,2)-I_matrix(:,cols*(check-1)+1:cols*(check),2));
    diff_value=abs(QUE(:,:,3)-I_matrix(:,cols*(check-1)+1:cols*(check),3));

    Diff_hue(check)=sum(sum(diff_hue));
    Diff_sat(check)=sum(sum(diff_sat));
    Diff_value(check)=sum(sum(diff_value));
    Diff(check,1:3)=[Diff_hue(check) Diff_sat(check) Diff_value(check)];%紀錄差異
end
%--------------------------------------------------------------------------
%HSV 依角度分區域 0~60&300~360>>紅 60~180>>綠 180~300>>藍 
%同除360
%0<=R & 0.1667>R   0.8333<=R & 1>R...1
%0.1667<=G & 0.5>G..................2
%0.5<=B & 0.8333>B...................3

for w=1:pic_num
    ah=Ave_Hue(w);
        if  (0<=ah & 0.1667>ah)|(0.8333<=ah & 1>ah)
            group(w,2)=1;
        elseif 0.1667<=ah & 0.5>ah
            group(w,2)=2;            
        elseif 0.5<=ah & 0.8333>ah
            group(w,2)=3;
        else
            group(w,2)=0;               
        end
end
%--------------------------------------------------------------------------
Total_diff=zeros(pic_num,1);
% QUE_hue=sum(sum(QUE(:,:,1)));
% QUE_sat=sum(sum(QUE(:,:,2)));
% QUE_value=sum(sum(QUE(:,:,3)));
for y=1:pic_num
    th=Diff(y,1)*100;
    ts=Diff(y,2)*10;
    tv=Diff(y,3)*80;
    Total_diff(y)=th+ts+tv;
end
% [hue_value hue_index]=sort(Diff(:,1));
% [sat_value sat_index]=sort(Diff(:,2));
% [value_value value_index]=sort(Diff(:,3));              %排序差異
[hue_value hue_index]=sort(Total_diff);
%--------------------------------------------------------------------------
hue_index1=[hue_index zeros(pic_num,1) zeros(pic_num,1)];
for i=1:pic_num
    k=hue_index1(i);                     
    G1=group(k,2);                                  %依色調分群
    hue_index1(i,2)=G1;
    G2=group(k,1);                                  %依外型分群
    hue_index1(i,3)=G2;
end
%--------------------------------------------------------------------------
%找出搜尋圖的色調範圍 將其中外型相同的提升名次
color=hue_index1(1,2);%搜尋圖的色調群
looks=hue_index1(1,3);%搜尋圖的外型群
%--------------------------------------------------------------------------
break_count=0;
flag3=0;
area=0;
% nocut_flag=0;
if nocut_flag==0
    for i=2:pic_num
        if flag3==0
           if hue_index1(i,2)~=color
               break_count=break_count+1;%若有兩個以上不同色調群混入 停止擴展區域
               if break_count>=2 
                   flag3=1;
                   area=i-2;%區域大小  
               end
           else
               break_count=0;
           end
        end   
    end

    buffer=[];
    cut3=0;
    reset=hue_index1(2:area,:);

    for i=1:area-1
        if hue_index1(i+1,3)==looks
            buffer=[buffer;hue_index1(i+1,:)];
            reset(i-cut3,:)=[];
            cut3=cut3+1;
        end
    end

    buffer=[buffer;reset];
    hue_index1(2:area,:)=buffer;
end
%寫排名至q.txt檔
[rr cc]=size(hue_index1);
fid = fopen('q.txt','wb');
for wr=2:11
    if wr<=rr
    fprintf(fid,'%d\n',hue_index1(wr,1));
    end
end
st=fclose(fid);

%--------------------------------------------------------------------------
axes(handles.axes2);
[bond,q]=size(hue_index1);
if bond>=2
result=hue_index1(2+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit4,'String',num2str(2+page-1));
%--------------------------------------------------------------------------
axes(handles.axes3);
[bond,q]=size(hue_index1);
if bond>=3
result=hue_index1(3+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit5,'String',num2str(3+page-1));
%--------------------------------------------------------------------------
axes(handles.axes4);
[bond,q]=size(hue_index1);
if bond>=4
result=hue_index1(4+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit6,'String',num2str(4+page-1));
%--------------------------------------------------------------------------
axes(handles.axes5);
[bond,q]=size(hue_index1);
if bond>=5
result=hue_index1(5+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit7,'String',num2str(5+page-1));
%--------------------------------------------------------------------------
axes(handles.axes6);
[bond,q]=size(hue_index1);
if bond>=6
result=hue_index1(6+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit8,'String',num2str(6+page-1));
%--------------------------------------------------------------------------
axes(handles.axes7);
[bond,q]=size(hue_index1);
if bond>=7
result=hue_index1(7+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit9,'String',num2str(7+page-1));
%--------------------------------------------------------------------------
axes(handles.axes8);
[bond,q]=size(hue_index1);
if bond>=8
result=hue_index1(8+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit10,'String',num2str(8+page-1));
%--------------------------------------------------------------------------
axes(handles.axes9);
[bond,q]=size(hue_index1);
if bond>=9
result=hue_index1(9+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit11,'String',num2str(9+page-1));
%--------------------------------------------------------------------------
axes(handles.axes10);
[bond,q]=size(hue_index1);
if bond>=10
result=hue_index1(10+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit12,'String',num2str(10+page-1));
%--------------------------------------------------------------------------
axes(handles.axes11);
[bond,q]=size(hue_index1);
if bond>=11
result=hue_index1(11+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit13,'String',num2str(11+page-1));
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%previous
global page
global hue_index1
page=page-10;
if page<0
    page=0;
end
%--------------------------------------------------------------------------
axes(handles.axes2);
[bond,q]=size(hue_index1);
if bond>=2+page
result=hue_index1(2+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit4,'String',num2str(2+page-1));
%--------------------------------------------------------------------------
axes(handles.axes3);
[bond,q]=size(hue_index1);
if bond>=3+page
result=hue_index1(3+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit5,'String',num2str(3+page-1));
%--------------------------------------------------------------------------
axes(handles.axes4);
[bond,q]=size(hue_index1);
if bond>=4+page
result=hue_index1(4+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit6,'String',num2str(4+page-1));
%--------------------------------------------------------------------------
axes(handles.axes5);
[bond,q]=size(hue_index1);
if bond>=5+page
result=hue_index1(5+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit7,'String',num2str(5+page-1));
%--------------------------------------------------------------------------
axes(handles.axes6);
[bond,q]=size(hue_index1);
if bond>=6+page
result=hue_index1(6+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit8,'String',num2str(6+page-1));
%--------------------------------------------------------------------------
axes(handles.axes7);
[bond,q]=size(hue_index1);
if bond>=7+page
result=hue_index1(7+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit9,'String',num2str(7+page-1));
%--------------------------------------------------------------------------
axes(handles.axes8);
[bond,q]=size(hue_index1);
if bond>=8+page
result=hue_index1(8+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit10,'String',num2str(8+page-1));
%--------------------------------------------------------------------------
axes(handles.axes9);
[bond,q]=size(hue_index1);
if bond>=9+page
result=hue_index1(9+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit11,'String',num2str(9+page-1));
%--------------------------------------------------------------------------
axes(handles.axes10);
[bond,q]=size(hue_index1);
if bond>=10+page
result=hue_index1(10+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit12,'String',num2str(10+page-1));
%--------------------------------------------------------------------------
axes(handles.axes11);
[bond,q]=size(hue_index1);
if bond>=11+page
result=hue_index1(11+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit13,'String',num2str(11+page-1));
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%next
global page
global hue_index1
page=page+10;

%--------------------------------------------------------------------------
axes(handles.axes2);
[bond,q]=size(hue_index1);
if bond>=2+page
result=hue_index1(2+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit4,'String',num2str(2+page-1));
%--------------------------------------------------------------------------
axes(handles.axes3);
[bond,q]=size(hue_index1);
if bond>=3+page
result=hue_index1(3+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit5,'String',num2str(3+page-1));
%--------------------------------------------------------------------------
axes(handles.axes4);
[bond,q]=size(hue_index1);
if bond>=4+page
result=hue_index1(4+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit6,'String',num2str(4+page-1));
%--------------------------------------------------------------------------
axes(handles.axes5);
[bond,q]=size(hue_index1);
if bond>=5+page
result=hue_index1(5+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit7,'String',num2str(5+page-1));
%--------------------------------------------------------------------------
axes(handles.axes6);
[bond,q]=size(hue_index1);
if bond>=6+page
result=hue_index1(6+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit8,'String',num2str(6+page-1));
%--------------------------------------------------------------------------
axes(handles.axes7);
[bond,q]=size(hue_index1);
if bond>=7+page
result=hue_index1(7+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit9,'String',num2str(7+page-1));
%--------------------------------------------------------------------------
axes(handles.axes8);
[bond,q]=size(hue_index1);
if bond>=8+page
result=hue_index1(8+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit10,'String',num2str(8+page-1));
%--------------------------------------------------------------------------
axes(handles.axes9);
[bond,q]=size(hue_index1);
if bond>=9+page
result=hue_index1(9+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit11,'String',num2str(9+page-1));
%--------------------------------------------------------------------------
axes(handles.axes10);
[bond,q]=size(hue_index1);
if bond>=10+page
result=hue_index1(10+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit12,'String',num2str(10+page-1));
%--------------------------------------------------------------------------
axes(handles.axes11);
[bond,q]=size(hue_index1);
if bond>=11+page
result=hue_index1(11+page,1);
Name22=[num2str(result) '.jpg'];       
img22=imread(Name22);               
imshow(img22);
else
Name22=['0.jpg'];       
img22=imread(Name22);               
imshow(img22);
end
set(handles.edit13,'String',num2str(11+page-1));
%--------------------------------------------------------------------------



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit6.
function edit6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
