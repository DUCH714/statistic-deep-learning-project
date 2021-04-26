a=[];
b=[];
for i =1:62
    if tissues(i)>0
        a=[a ;i2000(i,:)];
    else
        b=[b ;i2000(i,:)];
    end
end
a=[a;b];
figure(1);
surf(a')
figure(2);
surf(i2000')
% for i=1:62
%     for j=1:2000
%         if a(i,j)<=0.1
%             a(i,j)=0;
%         elseif 0.1<a(i,j)<=1
%             a(i,j)=.1;
%         elseif 1<a(i,j)<=7
%             a(i,j)=.2;
%         
%         elseif 7<a(i,j)<=15
%             a(i,j)=.3;
%         
%         elseif 15<a(i,j)
%             a(i,j)=.4;
%         end
%     end
% end