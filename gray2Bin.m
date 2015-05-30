function [out]=gray2Bin(in,cut_value,rows,cols)
    for j=1:cut_value:cols
        for i=1:cut_value:rows
            block=0;count_w=0;count_b=0;
            block=in(i:i+cut_value-1,j:j+cut_value-1);
            
            for c=1:cut_value
                for r=1:cut_value
                    if block(r,c)>=100
                        count_w=count_w+1;
                    else
                        count_b=count_b+1;
                    end
                end
            end
            
            if count_b>=count_w
                major=255;
            else
                major=0;
            end
            
            for c=1:cut_value
                for r=1:cut_value
                    block(r,c)=major;
                end
            end         
            in(i:i+cut_value-1,j:j+cut_value-1)=block;
            
        end        
    end
    out=in;
end