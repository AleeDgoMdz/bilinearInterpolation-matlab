function new = smoother(number,matrix,kernel)
smoothed = matrix;
for i=1:number  
    smoothed = conv2(smoothed,kernel,"same");
end
new = smoothed;
end