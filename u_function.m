function [out]=u_function(in1,in2)
table=[0.09 0.24 0.5 0.7 0.8]; 
switch in1
    case 1
        if in2>=table(1) & in2<=table(2)
            out=(table(2)-in2)/(table(2)-table(1));
        elseif in2<table(1)
            out=1;
        else
            out=0;
        end         
    case 2
        if in2>=table(1) & in2<=table(2)
            out=(in2-table(1))/(table(2)-table(1));
        elseif in2>table(2) & in2<=table(3)
            out=(table(3)-in2)/(table(3)-table(2));
        else
            out=0;
        end        
   case 3
        if in2>=table(2) &in2<=table(3)
            out=(in2-table(2))/(table(3)-table(2));
        elseif in2>table(3) &in2<=table(4)
            out=(table(4)-in2)/(table(4)-table(3));
        else
            out=0;
        end
    case 4
        if in2>=table(3) &in2<=table(4)
            out=(in2-table(3))/(table(4)-table(3));
        elseif in2>table(4) &in2<=table(5)
            out=(table(5)-in2)/(table(5)-table(4));
        else
            out=0;
        end        
    case 5
        if in2>=table(4) &in2<=table(5)
            out=(in2-table(4))/(table(5)-table(4));
        elseif in2>table(5)
            out=1;
        else
            out=0;
        end        

    otherwise
        out=0;       
end
    
end