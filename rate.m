a=0;
for i=1:62
    if Ord(i)<=Num(2,1) && tissues(i)>0
        a=a+1;
    elseif Ord(i)>Num(2,1) && tissues(i)<0
        a=a+1;
    end
end
accr=a/62
z=zeros(62,1);
for i=1:62
    z(Ord(i))=tissues(i);
end
plot(z)