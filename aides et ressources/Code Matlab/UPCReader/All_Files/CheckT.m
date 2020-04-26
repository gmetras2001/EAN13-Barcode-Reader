function [k,g]=CheckT(s)
    k=1;
    for i=1:(length(s)-11)   
        
        rec=min([s(i) s(i+1) s(i+2) s(i+3) s(i+4) s(i+5) s(i+6) s(i+7) s(i+8) s(i+9) s(i+10) s(i+11)]);
        
        d=[round(s(i)/rec) round(s(i+1)/rec) round(s(i+2)/rec) round(s(i+3)/rec) round(s(i+4)/rec) round(s(i+5)/rec) round(s(i+6)/rec) round(s(i+7)/rec) round(s(i+8)/rec) round(s(i+9)/rec) round(s(i+10)/rec) round(s(i+11)/rec)];        
        if (max(d)-min(d)) > 4
            k=k+1;
        elseif (max(d)-min(d)) <= 4
            break;
        end
   end
    k=k;
    
    g=1;
    for i=length(s):-1:12        
        rec=min([s(i) s(i-1) s(i-2) s(i-3) s(i-4) s(i-5) s(i-6) s(i-7) s(i-8) s(i-9) s(i-10) s(i-11)]);
        d=[round(s(i)/rec) round(s(i-1)/rec) round(s(i-2)/rec) round(s(i-3)/rec) round(s(i-4)/rec) round(s(i-5)/rec) round(s(i-6)/rec) round(s(i-7)/rec) round(s(i-8)/rec) round(s(i-9)/rec) round(s(i-10)/rec) round(s(i-11)/rec)];       
        if (max(d)-min(d)) > 4
            g=g+1;
        elseif (max(d)-min(d)) <=4
            break;
        end
    end
    g=g;