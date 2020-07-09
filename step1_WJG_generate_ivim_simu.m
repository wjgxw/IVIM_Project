%generate ivim images
%2019.3.3
% created by Angus, wjtcw@hotmail.com
clc
clear 
close all
warning off
addpath('ivim_tool')
addpath('func')
row =256;
col = 256;
b_start = 0;
b_end = 1000;
%b_group = [0,10,25,50,100,200,300,400,500];
b_group = [0,20,40,60,80,100,150,200,400,600,800,1000];
slice = length(b_group);
num = 300;      %the number of mask
ratio = 0.2; %the ratio of texture
samplenum = 4; %the number of samples we want to generate
dirname = 'image/';
dirs=dir([dirname,'*.jpg']);
output_channel = 3; %D Dster f
temp_brain_mask = zeros(row,col);% 
temp_brain_mask(50:row-50,50:col-50) = 1;
temp_brain_mask = repmat(temp_brain_mask,1,1,slice+output_channel);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng('shuffle');%the seed of random
for loopj = 1:samplenum   
    ivim_image_out=zeros(row,col,slice);
    ivim_mask = zeros(row,col);
    ivim_effect = zeros(row,col,output_channel);
    for loopk = 1:num
        [ivim_image_out,ivim_mask,ivim_effect] =  WJGshape_ivim(ivim_effect,ivim_image_out,b_start,b_end,ivim_mask,dirname,dirs,row,col,1,ratio);
        [ivim_image_out,ivim_mask,ivim_effect] =  WJGshape_ivim(ivim_effect,ivim_image_out,b_start,b_end,ivim_mask,dirname,dirs,row,col,2,ratio);
        [ivim_image_out,ivim_mask,ivim_effect] =  WJGshape_ivim(ivim_effect,ivim_image_out,b_start,b_end,ivim_mask,dirname,dirs,row,col,3,ratio);
        [ivim_image_out,ivim_mask,ivim_effect] =  WJGshape_ivim(ivim_effect,ivim_image_out,b_start,b_end,ivim_mask,dirname,dirs,row,col,4,ratio);
        if (sum(ivim_mask(:))>row*col*0.9) 
            break;
        end
    end
%     WJG_show_cest(ivim_image_out,0)
    filenames =['gen_sample/',num2str(loopj),'.mat'];
    ivim_image_out(:,:,slice+1:slice+output_channel) = ivim_effect;
    ivim_image_out(:,:,13) = ivim_image_out(:,:,13)*1000;
    ivim_image_out(:,:,14) = ivim_image_out(:,:,14)*1000;
    ivim_image_out = ivim_image_out.*temp_brain_mask; 
    save(filenames,'ivim_image_out','-single');
    loopj
end


