clear all;
clc;
%變數初始值
flag=0;
pic_num=218;
cut_value=4;cols=80;rows=80; 
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
Img_matrix=[];
img_matrix=[];
I_matrix=[];
for w=1:pic_num
%     Img_matrixBIN=0;Img_matrixRGB=0;
    Name=[num2str(w) '.jpg'];       
    img=imread(Name);               %利用回圈讀圖檔
    img=imresize(img,[rows cols]);  %將讀進的圖檔修正維度
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

   %----------------------------------------------------------------------% 
%     IB=rgb2gray(img);                   %RGB轉gray
%     h1=fspecial('disk',4);
%     imgfilter=imfilter(IB,h1);          %濾波 (柔化)
%    IB=edge(I);
%     IB=gray2Bin(IB,cut_value,rows,cols);%gray轉Binary
    IB=rgb2gray(hsv2rgb(I));        %RGB轉gray
%     h1=fspecial('disk',2.6);
%     imgfilter=imfilter(IB,h1);      %濾波 (柔化)    
    IB=double(edge(IB));
%     for j=1:cols
%         for i=1:rows
%             if IB(i,j)==0
%                 IB(i,j)=255;
%             else
%                 IB(i,j)=0;
%             end
%         end
%     end

%     figure;imshow(IB);
%     figure;imshow(hsv2rgb(I));    

     Img_matrix=[Img_matrix IB];       %將處理過的圖組合成大矩陣以便處理
     img_matrix=[img_matrix II];        %儲存HSV Model轉換後(未切割)
     I_matrix=[I_matrix I];            %儲存HSV Model轉換後(切割後)
end
%  imshow(Img_matrix);
%  figure;imshow(img_matrix);
%  figure;imshow(I_matrix);
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
% winner=zeros(pic_num,1);    
network_flag=0;
S2_flag=0;
P=0.34;                                 %vigilance parameter 警戒值
beta=0.1;
S1_struct=zeros(pic_num,1);
S2_struct=zeros(pic_num,1);
en_count=0;
% SSSSS=zeros(rows*cols,pic_num);
%--------------------------------------------------------------------------
for network=1:pic_num
    S2_flag=0;
    en_count=0;
    X=thershold(double(Img_matrix(1:rows,1+(network-1)*cols:cols+(network-1)*cols)));%從大矩陣依序取出輸入圖樣
%   figure;imshow(X);
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
%--------------------------------------------------------------------------    
    x1=imresize(XX,[rows,cols]);        %修改維度
    h2=fspecial('disk',1);
    x1=imfilter(x1,h2);                 %濾波 (柔化)    
%     x1=double(edge(x1));
    x=thershold(double(reshape(x1,(rows*cols),1)));%將圖轉成輸入向量  
%     SSSSS(:,network)=x;
%     figure;imshow(x1);
% network
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
% s1_count
                    j_num=win_index(s1_count);%找出得勝者屬於哪顆類神經元  
% j_num                    
                    s2=S2(w(:,j_num),x);%看相似度是否達到警戒值
% s2                    
                    if s2>=P            %若達到警戒值 將輸入分至得勝之類神經元 並修改鍵結值
                        w(:,j_num)=w(:,j_num).*x;%修改鍵結值
                        group(network,1)=j_num;%分群       
                        S2_flag=1;
                    end
                end
        end
% S2_flag
        if S2_flag==0                   %若沒達到警戒值 致能新的一個類神經元 並修改鍵結值
            enable=[1;enable];
            enable=enable(1:pic_num,1); %更新致能情況
            new_num=sum(enable);        %致能類神經元總數
            w(:,new_num)=w(:,new_num).*x;%修改鍵結值
            group(network,1)=new_num;   %分群
        end
% new_num        
    end
end
%--------------------------------------------------------------------------
diff=0;
Ave_Hue=zeros(pic_num,1);
Diff_hue=zeros(pic_num,1);
Diff_sat=zeros(pic_num,1);
Diff_value=zeros(pic_num,1);
Diff=zeros(pic_num,3);
for check=1:pic_num
    QUE=I_matrix(:,cols*(file_name-1)+1:cols*(file_name),:);%取出所選擇的圖(HSV)
%     imshow(QUE);
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

% [H_V H_I]=sort(Ave_Hue);
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
[hue_value hue_index]=sort(Diff(:,1));
[sat_value sat_index]=sort(Diff(:,2));
[value_value value_index]=sort(Diff(:,3));              %排序差異
% for Show=1:11
%     pic_NO=hue_index(Show);
% %     figure;imshow(img_matrix(:,cols*(pic_NO-1)+1:cols*(pic_NO),:));
% end
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
% buffer_order=[];
% color_order=[0 0 0];
% order_count=2;
% R=hue_index1(:,2);
% for j=1:pic_num
%     if j==1 & order_count<=3
%         color_order(1)=R(j);
%     elseif j>=2 & order_count<=3
%         if R(j-1)~=R(j) & color_order(1)~=R(j) & color_order(2)~=R(j)
%             color_order(order_count)=R(j);
%             order_count=order_count+1;
%         end
%     end
% end
% for j=1:3
%     for i=1:pic_num
%         if hue_index1(i,2)==color_order(j)
%             buffer_order=[buffer_order;hue_index1(i,:)];
%         end
%     end
% end
% hue_index1=buffer_order;
%--------------------------------------------------------------------------
break_count=0;
flag3=0;
area=0;
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
% if flag3==0
%     area=i;
% end
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
for t=2:11
    result=hue_index1(t,1);
    Name22=[num2str(result) '.jpg'];       
    img22=imread(Name22);               %利用回圈讀圖檔
    figure;imshow(img22);
end


