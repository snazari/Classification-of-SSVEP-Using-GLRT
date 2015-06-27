%Sam Nazari
%May 2014

function y=cpow(DS,f,tf,win)

    rang = find(f>(tf-win/2) & f<(tf+win/2));
    startP=rang(1);
    endP=rang(end);
    
    if ((endP-startP+1)>0)%normalization
        y = sum(DS(startP:endP))/(endP-startP+1);
    else
        y = sum(DS(startP:endP));
    end