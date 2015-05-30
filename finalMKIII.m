clear all;
clc;
%變數初始值
flag=0;
pic_num=26;
cut_value=10;cols=400;rows=400; 
pixel=(rows/cut_value)*(cols/cut_value);
% ii=zeros(rows/cut_value,cols/cut_value,3);
[filename,pathname]=uigetfile({'*.jpg';'*.tif';'*.png'},'Select an image');
query=double(filename);             %開圖檔檔名 query
file_name=0;
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
%--------------------------------------------------------------------------
%讀圖輸入至大矩陣
IB=zeros(rows,cols);
for w=1:pic_num
%     Img_matrixBIN=0;Img_matrixRGB=0;
    Name=[num2str(w) '.jpg'];       
    img=imread(Name);               %利用回圈讀圖檔
    img=imresize(img,[rows cols]);  %將讀進的圖檔修正維度
    I=rgb2gray(img);                %RGB轉gray
%     h1=fspecial('gaussian');
%     imgfilter=imfilter(I,h1);    
%     IB=edge(I);
     IB=gray2Bin(I,cut_value,rows,cols);%gray轉Binary
%     IB=double(edge(IB));
%     for j=1:cols
%         for i=1:rows
%             if IB(i,j)==0
%                 IB(i,j)=1;
%             else
%                 IB(i,j)=0;
%             end
%         end
%     end
%     h1=fspecial('unsharp');
%     imgfilter=imfilter(IB,h1);
%     [Fx,Fy]=gradient(double(imgfilter));
% 
%     Ix2 = abs(imfilter(Fx.*Fx,h1));
%     Iy2 = abs(imfilter(Fy.*Fy,h1));
%     IxIy = abs(imfilter(Fx.*Fy,h1));
%     TH=15;TL=0;
% 
%      for j=1:cols
%         for i=1:rows 
%             tensor=[Ix2(i,j) IxIy(i,j);IxIy(i,j) Iy2(i,j)];
%             eigv=eig(tensor)
%             if (eigv(1)>TH & eigv(2)>TH)
%                 IB(i,j)=0;
%             else
%                 IB(i,j)=1;
%             end
%          end
%      end
% 
%     figure;imshow(IB);
 if flag==0
     Img_matrix=IB;
     img_matrix=img;
     flag=1;
 else
     Img_matrix=[Img_matrix IB];       %將處理過的圖組合成大矩陣以便處理
     img_matrix=[img_matrix img];      %儲存原圖
 end
end

for network=1:pic_num
    In=thershold(double(Img_matrix(:,1+(file_name-1)*cols:cols+(file_name-1)*cols)));
    X=thershold(double(Img_matrix(:,1+(network-1)*cols:cols+(network-1)*cols)));%從大矩陣依序取出輸入圖樣
    diff(network,1)=abs(sum(sum(In-X)));
end
% imshow(diff);