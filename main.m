clear
load('predata.mat')
figure(1);
surf(I2000)%%%plot it as a three-dimentional surface
[~, ~, ~,I2000] = Cluster(I2000'/1000,4);%%arrange by gene
figure(2);
surf(I2000')%%%plot it as a three-dimentional surface
[Ord, Num, BetaVal,I2000] = Cluster(I2000'/10,2);%%arrange by tissues
figure(3);
surf(I2000)%%%plot it as a three-dimentional surface
%%%%%%%%%%%%%%%%%%%%%%calculate the accuracy%%%%%%%%%%%%%%%%%%%%%%%
correct=0;
for i=1:size(tissues,2)
    if Ord(i)<=Num(2,1) && tissues(i)>0
        correct=correct+1;
    elseif Ord(i)>Num(2,1) && tissues(i)<0
        correct=correct+1;
    end
end
accuracy=correct/size(tissues,2);