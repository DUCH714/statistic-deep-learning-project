n=49;
training=[];
testing=[];
for i=1:49
    training=[training,I2000(:,i)];
end

for i=50:62
    testing=[testing,I2000(:,i)];
end