clear all;
clc;
%變數初始值
flag=0;
pic_num=1;
cut_value=40; 
rows=400;cols=400;
pixel=(rows/cut_value)*(cols/cut_value);
ii=zeros(rows/cut_value,cols/cut_value,3);
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
%讀圖取hisogram 
for w=1:pic_num
    
    Name=[num2str(w) '.jpg'];       
    img=imread(Name);               %利用回圈讀圖檔
    img=imresize(img,[rows cols]);  %將讀進的圖檔修正維度
    I=rgb2hsv(img);                 %RGB轉HSV
%   I=img;
    I_block=0;                      %取hist時暫存變數
    I_hue=I(:,:,1);
    I_sat=I(:,:,2);
    I_value=I(:,:,3);               %分別將HSV三層取出
                                    %分三層取hisogram:H
    i_con=1;j_con=1;
 for j=1:cut_value:cols
     for i=1:cut_value:rows
        I_block=I_hue(i:i+cut_value-1,j:j+cut_value-1);%切割圖
        [counts x]=imhist(I_block,16);
        [C index]=max(counts);      
        major=x(index);             %將最多counts的色調的索引值找出
        i_hue(i_con,j_con)=major;   %將major組合成小矩陣
        i_con=i_con+1;
        I_block(1:cut_value,1:cut_value)=major;
        I_hue(i:i+cut_value-1,j:j+cut_value-1)=I_block;
     end
     i_con=1;
     j_con=j_con+1;
 end
                                     %分三層取hisogram:S
     i_con=1;j_con=1;
  for j=1:cut_value:cols
     for i=1:cut_value:rows
        I_block=I_sat(i:i+cut_value-1,j:j+cut_value-1);%切割圖
        [counts x]=imhist(I_block,16);
        [C index]=max(counts);
        major=x(index);             %將最多counts的色調的索引值找出
        i_sat(i_con,j_con)=major;   %將major組合成小矩陣     
        i_con=i_con+1;
        I_block(1:cut_value,1:cut_value)=major;
        I_sat(i:i+cut_value-1,j:j+cut_value-1)=I_block;
     end
     i_con=1;
     j_con=j_con+1;
  end
                                      %分三層取hisogram:V
      i_con=1;j_con=1;
  for j=1:cut_value:cols
     for i=1:cut_value:rows
        I_block=I_value(i:i+cut_value-1,j:j+cut_value-1);%切割圖
        [counts x]=imhist(I_block,16);
        [C index]=max(counts);
        major=x(index);               %將最多counts的色調的索引值找出
        i_value(i_con,j_con)=major;   %將major組合成小矩陣       
        i_con=i_con+1;        
        I_block(1:cut_value,1:cut_value)=major;
        I_value(i:i+cut_value-1,j:j+cut_value-1)=I_block;
     end
     i_con=1;
     j_con=j_con+1;     
  end
  
    I(:,:,1)=I_hue;
    I(:,:,2)=I_sat;
    I(:,:,3)=I_value;                  %ii=處理過的小圖
%    Img=hsv2rgb(I);
   Img=I;
 if flag==0
     Img_matrix=Img;
     flag=1;
 else
     Img_matrix=[Img_matrix Img];       %將處理過的圖組合成大矩陣以便處理
 end
end

%--------------------------------------------------------------------------
% table=[0.09 0.24 0.5 0.7 0.8];  %前鑑部歸屬函數:三角形 
% w_table=[1 1 1 1 1];       %後鑑部歸屬函數:單值 (weight)
% x=0;alpha=0;flag2=0;
% for w=1:cols/cut_value:pic_num*cols/cut_value
%     Img_cut=Img_matrix(1:rows/cut_value,w:w+cols/cut_value-1,:);
%     for j=1:cols/cut_value 
%         for i=1:rows/cut_value
%             x=Img_cut(i,j,1);     %使每個pixel為輸入     (hue)       
%             for a=1:5
%             A(a)=u_function1(a,x);%模糊推論
%             end
%             
%             if flag2==0
%                 struct_hue=A;
%                 flag2=1;
%             else
%                 struct_hue=[struct_hue;A];%將結果存於一矩陣
%             end
%             
%         end
%     end
% 
% end
% for i=1:pixel*pic_num
% struct_hue(i,6)=struct_hue(i,1:5)*w_table';
% end
% J=1;
% HSV_vector=zeros(pic_num,pixel*3);
% for i=1:pixel:pixel*pic_num
%     HSV_vector(J,1:pixel)=struct_hue(i:i+pixel-1,6)';
%     J=J+1;
% end
% %--------------------------------------------------------------------------
% x=0;alpha=0;flag2=0;
% for w=1:cols/cut_value:pic_num*cols/cut_value
%     Img_cut=Img_matrix(1:rows/cut_value,w:w+cols/cut_value-1,:);
%      for j=1:cols/cut_value 
%         for i=1:rows/cut_value
%             x=Img_cut(i,j,2);     %使每個pixel為輸入     (sat)       
%             for a=1:5
%             B(a)=u_function1(a,x);%模糊推論
%             end
%             
%             if flag2==0
%                 struct_sat=B;
%                 flag2=1;
%             else
%                 struct_sat=[struct_sat;B];%將結果存於一矩陣
%             end
%             
%         end
%      end
% 
% end
% for i=1:pixel*pic_num
% struct_sat(i,6)=struct_sat(i,1:5)*w_table';
% end
% J=1;
% % sat_vector=zeros(pic_num,pixel);
% for i=1:pixel:pixel*pic_num
%     HSV_vector(J,pixel+1:pixel*2)=struct_sat(i:i+pixel-1,6)';
%     J=J+1;
% end
% %--------------------------------------------------------------------------
% x=0;alpha=0;flag2=0;
% for w=1:cols/cut_value:pic_num*cols/cut_value
%     Img_cut=Img_matrix(1:rows/cut_value,w:w+cols/cut_value-1,:);
%      for j=1:cols/cut_value 
%         for i=1:rows/cut_value
%             x=Img_cut(i,j,3);     %使每個pixel為輸入     (value)       
%             for a=1:5
%             C(a)=u_function1(a,x);%模糊推論
%             end
%             
%             if flag2==0
%                 struct_value=C;
%                 flag2=1;
%             else
%                 struct_value=[struct_value;C];%將結果存於一矩陣
%             end
%             
%         end
%      end
% 
% end
% for i=1:pixel*pic_num
% struct_value(i,6)=struct_value(i,1:5)*w_table';
% end
% J=1;
% % value_vector=zeros(pic_num,pixel);
% for i=1:pixel:pixel*pic_num
%     HSV_vector(J,pixel*2+1:pixel*3)=struct_value(i:i+pixel-1,6)';
%     J=J+1;
% end
%--------------------------------------------------------------------------
% diff=zeros(pic_num,1);
% diff_v=0;
% for i=1:pic_num
%     diff_v=(HSV_vector(file_name,:)-HSV_vector(i,:));
%     diff(i)=sum(diff_v.*diff_v);
% end