function varargout = finalpro2(varargin)
% FINALPRO2 M-file for finalpro2.fig
%      FINALPRO2, by itself, creates a new FINALPRO2 or raises the existing
%      singleton*.
%
%      H = FINALPRO2 returns the handle to a new FINALPRO2 or the handle to
%      the existing singleton*.
%
%      FINALPRO2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALPRO2.M with the given input arguments.
%
%      FINALPRO2('Property','Value',...) creates a new FINALPRO2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before finalpro2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to finalpro2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help finalpro2

% Last Modified by GUIDE v2.5 15-Jun-2010 16:34:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @finalpro2_OpeningFcn, ...
                   'gui_OutputFcn',  @finalpro2_OutputFcn, ...
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


% --- Executes just before finalpro2 is made visible.
function finalpro2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to finalpro2 (see VARARGIN)

% Choose default command line output for finalpro2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes finalpro2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = finalpro2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global next pos;
 [filename,pathname]=uigetfile({'*.jpg';'*.tif';'*.png'},'Selectan image');
 imgName=[pathname filename];
 img1=imread(imgName); 
 totalpic=inputdlg('輸入張數','input');
 totalpic=str2num(totalpic{1});
 axes(handles.axes1);
 imshow(img1);
 axes(handles.axes2);
 
  rows1=640;
  cols1=640; 
  img1 = imresize(img1 ,[rows1 cols1]);
  I1=rgb2hsv(img1);

  cut_size = 80;     
  result = zeros(218,1);
  spec = zeros(rows1,cols1); 
  
for inputpic =1:totalpic
        imgName=[num2str(inputpic) '.jpg'];
        img2 = imread(imgName);
        img2 = imresize(img2 ,[rows1 cols1]);
        I2=rgb2hsv(img2);        
        for i=1:cut_size:rows1            
             for j=1:cut_size:cols1                  
                 [count_h1 h1] = imhist(I1(i:i+cut_size-1,j:j+cut_size-1,1));%Display histogram of image data , count為記數 h1%
                 [count_s1 s1] = imhist(I1(i:i+cut_size-1,j:j+cut_size-1,2));
                 [count_v1 v1] = imhist(I1(i:i+cut_size-1,j:j+cut_size-1,3));
                 [count_h2 h2] = imhist(I2(i:i+cut_size-1,j:j+cut_size-1,1));%Display histogram of image data , count為記數 h1%
                 [count_s2 s2] = imhist(I2(i:i+cut_size-1,j:j+cut_size-1,2));
                 [count_v2 v2] = imhist(I2(i:i+cut_size-1,j:j+cut_size-1,3));
                
                 [max_h1 index_h1]=sort(count_h1);
                 [max_s1 index_s1]=sort(count_s1);
                 [max_v1 index_v1]=sort(count_v1);
                 [max_h2 index_h2]=sort(count_h2);
                 [max_s2 index_s2]=sort(count_s2);
                 [max_v2 index_v2]=sort(count_v2);
                                  
                 main_h1=h1(index_h1(end));%找出主要顏色%      
                 main_s1=s1(index_s1(end));       
                 main_v1=v1(index_v1(end));
                 main_h2=h2(index_h2(end));%找出主要顏色%      
                 main_s2=s2(index_s2(end));       
                 main_v2=v2(index_v2(end));
                  
                 spec(i,j,1) = (main_h1-main_h2);
                 spec(i,j,2) = (main_s1-main_s2);
                 spec(i,j,3) = (main_v1-main_v2);
           end
        end               
       result(inputpic) = sum(sum(sum(abs(spec))));
 end

[error pos] = sort(result);

 axes(handles.axes2);
 imgName=[num2str(pos(2)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);

 axes(handles.axes3);
 imgName=[num2str(pos(3)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes4);
 imgName=[num2str(pos(4)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes5);
 imgName=[num2str(pos(5)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 axes(handles.axes6);
 imgName=[num2str(pos(6)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes7);
 imgName=[num2str(pos(7)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes8);
  imgName=[num2str(pos(8)) '.jpg'];
  img3 = imread(imgName);
  imshow(img3);
  
 axes(handles.axes9);   
 imgName=[num2str(pos(9)) '.jpg']; 
 img3 = imread(imgName); 
 imshow(img3);
 
 axes(handles.axes10);
 imgName=[num2str(pos(10)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes11);
 imgName=[num2str(pos(11)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 next=0;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global next pos;

 next = next+10;
 axes(handles.axes2);
 imgName=[num2str(pos(next+2)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);

 
 axes(handles.axes3);
 imgName=[num2str(pos(next+3)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 
 axes(handles.axes4);
 imgName=[num2str(pos(next+4)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes5);
 imgName=[num2str(pos(next+5)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 axes(handles.axes6);
 imgName=[num2str(pos(next+6)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes7);
 imgName=[num2str(pos(next+7)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes8);
  imgName=[num2str(pos(next+8)) '.jpg'];
  img3 = imread(imgName);
  imshow(img3);
  
 axes(handles.axes9);   
 imgName=[num2str(pos(next+9)) '.jpg']; 
 img3 = imread(imgName); 
 imshow(img3);
 
 axes(handles.axes10);
 imgName=[num2str(pos(next+10)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes11);
 imgName=[num2str(pos(next+11)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global next pos;

 next = next-10;
 axes(handles.axes2);
 imgName=[num2str(pos(next+2)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes3);
 imgName=[num2str(pos(next+3)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes4);
 imgName=[num2str(pos(next+4)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes5);
 imgName=[num2str(pos(next+5)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 axes(handles.axes6);
 imgName=[num2str(pos(next+6)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes7);
 imgName=[num2str(pos(next+7)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes8);
  imgName=[num2str(pos(next+8)) '.jpg'];
  img3 = imread(imgName);
  imshow(img3);
  
 axes(handles.axes9);   
 imgName=[num2str(pos(next+9)) '.jpg']; 
 img3 = imread(imgName); 
 imshow(img3);
 
 axes(handles.axes10);
 imgName=[num2str(pos(next+10)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
 
 axes(handles.axes11);
 imgName=[num2str(pos(next+11)) '.jpg'];
 img3 = imread(imgName);
 imshow(img3);
