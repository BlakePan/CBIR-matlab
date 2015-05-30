function [out]=thershold(in)
    [rows cols]=size(in);
    for j=1:cols
        for i=1:rows
            if in(i,j)>0
                in(i,j)=1;
            else
                in(i,j)=0;
            end
        end
    end
    out=in;
end