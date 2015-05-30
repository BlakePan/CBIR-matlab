function [out]=S1(w,x,b)
    out=(w'*x)/(b+sum(w));
end