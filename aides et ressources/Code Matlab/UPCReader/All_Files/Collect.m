function s=Collect(c,td)
    ii=1;
    
    s=[1:td];
    
    for k=1:td
        j=0;
        
        if c(ii)==0
            while (c(ii)==0)
                j=j+1;
                ii=ii+1;
              %  s(k)=j;
            end
              s(k)=j;
        elseif c(ii)==1
            while (c(ii)==1)
            j=j+1;
            ii=ii+1;
            %s(k)=j;
            end
              s(k)=j;
        end
        
    end
    
    s=s;