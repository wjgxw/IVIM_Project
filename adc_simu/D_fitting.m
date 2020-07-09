%simulate 
% diffusion d value fitting

% clc
% clear
% close all
bvalue=[0,20,40,60,80,100,150,200,400,600,800,1000];
b_num = 12;
indata = zeros(128,128,b_num);
WJG_order = 1;
for loopi=1:b_num
    filename = ['b_',num2str(bvalue(loopi)),'.mat'];
    load(filename)
    indata(:,:,WJG_order) = VImg.Mag;
    subplot(3,4,loopi);
    imshow( indata(:,:,WJG_order),[0,12]);colormap jet;title(num2str(bvalue(loopi)))
    WJG_order = WJG_order+1;
end
minimum = 0.01;
[Map] = ADCMap(indata, bvalue, minimum);

figure;imagesc(Map.* (indata(:,:,1)>0.2),[0.000,0.004]);colormap jet;title('D');colorbar
% ivim_mrilab = zeros(size(indata));
% ivim_mrilab(:,:,1:12) = indata(:,:,1:12)./indata(:,:,1).*(indata(:,:,1)>0.5);
% figure;imshow(ivim_mrilab(:,:,12),[]);colormap jet