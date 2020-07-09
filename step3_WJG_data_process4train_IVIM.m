%sampling the cest images with propeller scheme
%2019.3.3
%modified 2019.6.22
% created by Angus, wjtcw@hotmail.com
%%%%%%%%%%%%%%%%%%%%%norm1
clc
clear 
close all
addpath('../ivim_tool')
row =256;
col = 256;
b_group = [0,20,40,60,80,100,150,200,400,600,800,1000];
slice = length(b_group);
output_channel = 3; %D Dster f
sigma = 1e-2;
dirname = 'gen_sample/';
sample_dir = [dirname,'sample1/'];
output_dir = ['data4train1/'];
fid_dir_all = dir([sample_dir,'*.mat']);       %list all files
for loopj = 1:length(fid_dir_all)
    fid_file = [sample_dir,fid_dir_all(loopj).name];
    load(fid_file);
    for loopi = 1:slice
        ivim_image_out(:,:,loopi) = ivim_image_out(:,:,loopi)+normrnd(0,sigma,row,col);
    end    
    ivim_image_out = permute(ivim_image_out,[3,1,2]);
    filename1=[output_dir, num2str(loopj),'.Charles'];
    [fid,msg]=fopen(filename1,'wb');
    fwrite(fid, ivim_image_out,'single');
    fclose(fid); 
    loopj
end    

