function [ivim_image_out,new_mask,ivim_effect_out] =  WJGshape_ivim(ivim_effect,ivim_image,b_start,b_end,mask,dirname,dirs,row,col,type,ratio)
%generate the random shapes, and add texture in the shapes

%mask: the generateed random shape mask
%dir: the directory of the images, which used for generating random textures
%2019.3.3
% created by Angus, wjtcw@hotmail.com
radius_limit = row;
mini_size = 3;% the minimum size
ivim_image_out = ivim_image;
ivim_effect_out = ivim_effect;
switch type 
    case 1    
        %circle
        mask1 = zeros(row,col);
        RADIUS = randi([mini_size,round(radius_limit/6)],1); 
        center = randi([5,row-5],1,2); 
        temp_mask = WJGgenCircle(row,RADIUS,center);
        if(sum(temp_mask(:))>5)    %prevent the small shape
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%prevent the overlap between the masks
        [ivim_image_out,ivim_effect_out] = Add_tex(ivim_effect,ivim_image,b_start,b_end,dirname,dirs,new_mask,ratio);  
        new_mask = abs(new_mask+mask)>0;  

    case 2
        %ring
        mask1 = zeros(row,col);
        RADIUS1 = randi([mini_size,round(radius_limit/4)],1);
        RADIUS2 = randi([mini_size,round(radius_limit/16)],1);
        center = randi([-5,5],1,2); 
        temp_mask = WJGgenRing( row,max(RADIUS1,RADIUS2),min(RADIUS1,RADIUS2),center );
        if(sum(temp_mask(:))>5)    
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask); 
        [ivim_image_out,ivim_effect_out] = Add_tex(ivim_effect,ivim_image,b_start,b_end,dirname,dirs,new_mask,ratio);  

        new_mask = abs(new_mask+mask)>0; 
    case 3
        %square
        mask1 = zeros(row,col);
        shape = randi([1,round(radius_limit/2)],2,2);  
        center = randi([5,row-row/8],2,1); 
        center = [center,center];
        shape = shape+center;
        x = min([sort(shape(1,:));row,row]);   
        y = min([sort(shape(2,:));col,col]);
        vx = [x(1),x(1),x(2),x(2),x(1)];
        vy = [y(1),y(2),y(2),y(1),y(1)];
        temp_mask = WJG_convex_S(row,vx,vy);
        if(sum(temp_mask(:))>5)   
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask); 
        [ivim_image_out,ivim_effect_out] = Add_tex(ivim_effect,ivim_image,b_start,b_end,dirname,dirs,new_mask,ratio); 
        new_mask = abs(new_mask+mask)>0;
    case 4 
        %triangle
        mask1 = zeros(row,col);
        shape = randi([1,round(radius_limit/2)],2,3);
        center = randi([5,row--row/8],2,1); 
        center = [center,center,center];
        shape = shape+center;
        x = min([sort(shape(1,:));row,row,row]);
        y = min([sort(shape(2,:));col,col,col]);
        vx = [x(1),x(2),x(3),x(1)];
        vy = [y(1),y(2),y(3),y(1)];
        temp_mask = WJG_convex_S(row,vx,vy);
        if(sum(temp_mask(:))>5)     
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask); 
        [ivim_image_out,ivim_effect_out] = Add_tex(ivim_effect,ivim_image,b_start,b_end,dirname,dirs,new_mask,ratio);  
        new_mask = abs(new_mask+mask)>0;
end
      
% imshow(mask1+mask2+mask3+mask4)

function [ivim_image_out,ivim_effect_out] =  Add_tex(ivim_effect,ivim_image,b_start,b_end,dirname,dirs,new_mask,ratio)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ivim_image_out = ivim_image;
[row,col,slice] = size(ivim_image);
samples = length(dirs);
frame_i = randi([1,samples],1); 
filename = [dirname,dirs(frame_i).name];
II1 = double(rgb2gray(imread(filename)))/255;% 
II1 = abs(imresize(II1,[row,col],'nearest'));
w = fspecial('gaussian',4,4);
II1 = imfilter(II1,w','replicate');
%%2
frame_i = randi([1,samples],1); 
filename = [dirname,dirs(frame_i).name];
II2 = double(rgb2gray(imread(filename)))/255;% 
II2 = abs(imresize(II2,[row,col],'nearest'));
w = fspecial('gaussian',4,4);
II2 = imfilter(II2,w','replicate');
%%3
frame_i = randi([1,samples],1); 
filename = [dirname,dirs(frame_i).name];
II3 = double(rgb2gray(imread(filename)))/255;% 
II3 = abs(imresize(II3,[row,col],'nearest'));
w = fspecial('gaussian',4,4);
II3 = imfilter(II3,w','replicate');
%%4
frame_i = randi([1,samples],1); 
filename = [dirname,dirs(frame_i).name];
II4 = double(rgb2gray(imread(filename)))/255;% 
II4 = abs(imresize(II4,[row,col],'nearest'));
w = fspecial('gaussian',4,4);
II4 = imfilter(II4,w','replicate');
decay = rand()*0.9+0.1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%b_group = [0,10,25,50,100,200,300,400,500];
b_group = [0,20,40,60,80,100,150,200,400,600,800,1000];

diffusion_D = (rand()*2+0.5)*10^-3;
diffusion_Dstar=(rand()*500+5)*10^-3;
perfusion_f=rand()*0.9+0.06;
diffusion_D = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*diffusion_D;
diffusion_Dstar = (new_mask.*II2*ratio+(new_mask*(1-ratio))).*diffusion_Dstar;
perfusion_f = (new_mask.*II3*ratio+(new_mask*(1-ratio))).*perfusion_f;

bi_exp = zeros(row,col,slice);
for loopi = 1:slice
    bi_exp(:,:,loopi) = perfusion_f.*exp(-b_group(loopi).*diffusion_Dstar)+(1-perfusion_f).*exp(-b_group(loopi).*diffusion_D);
end


%% input
for loopi = 1:slice 
    %select_b = floor(length(bvalue)/(slice-1))*(loopi-1)+1;
    temp_ivim= (new_mask.*II4*ratio+(new_mask*(1-ratio))).*bi_exp(:,:,loopi)*decay;
    ivim_image_out(:,:,loopi) = temp_ivim+ivim_image(:,:,loopi);
end


%% out 

ivim_effect_out(:,:,1) = diffusion_D+ivim_effect(:,:,1);
ivim_effect_out(:,:,2) = diffusion_Dstar+ivim_effect(:,:,2);
ivim_effect_out(:,:,3) = perfusion_f+ivim_effect(:,:,3);


