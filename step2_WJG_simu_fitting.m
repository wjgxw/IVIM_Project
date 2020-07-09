% fitting the simu data
% validate the syn data
clc
clear 
close all
warning off
addpath('ivim_tool')
%% parameters
b_group = [0,20,40,60,80,100,150,200,400,600,800,1000];
slice = length(b_group);

load('gen_sample/sample1/2.mat')

par_fit = WJG_ivim_effect(ivim_image_out(:,:,1:slice),b_group);
dot_fit = WJG_biexponential(par_fit,b_group);