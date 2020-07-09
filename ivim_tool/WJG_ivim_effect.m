% created by WJ angus
%  wjtcw@hotmail.com
%modified 
%output paramaters
function [ivim_effect_out] = WJG_ivim_effect(ivim,b_group)
[row,col,~] = size(ivim);
b_group_high = b_group(5:end);
ivim_effect_out = zeros(row,col,3);
mask = ivim(:,:,1);
mask = mask/max(mask(:));
level = graythresh(mask)/4;
mask = im2bw(mask,level);
%figure();imshow(mask,[]);
%ivim = ivim.*mask;
parfor loopi = 1:row
    for loopj = 1:col
        if(mask(loopi,loopj)~=0)
        temp_ivim = squeeze(ivim(loopi,loopj,:));
        temp_ivim = temp_ivim./(max(temp_ivim(:))+eps);        
        %par0=[1*10^-3,40*10^-3,0.2];
        %LB = [0.45*10^-3,4.5*10^-3,0.05];   %amp, offset, width, maximum
        %UB = [1.5*10^-3,80*10^-3,0.35];
        %par_1 = [0.2,0.5];
        par_1 = [1,0.5];
        LB = [0,0];   %amp, offset, width, maximum
        UB = [2,1];
        %kp_temp=lsqcurvefit('WJG_exponential',par_1,b_group_high,temp_ivim(6:end)',LB,UB);
        kp_temp=lsqcurvefit('WJG_exponential',par_1,b_group_high,temp_ivim(5:end)',LB,UB);
        
        par0=[kp_temp(1),250,kp_temp(2)];
        %par0=[0.2,40,0.5];
        %LB = [0,5,0.05];   %amp, offset, width, maximum
        %UB = [1.5,80,0.35];
        LB = [0,0,0];   %amp, offset, width, maximum
        UB = [2,500,1];
        kp=lsqcurvefit('WJG_biexponential',par0,b_group,temp_ivim(1:end)',LB,UB);
        %kp=lsqnonlin('WJG_biexponential',par0,b_group,temp_ivim(1:end-3)',LB,UB);
        kp(1) = kp_temp(1);
        kp(3) = kp_temp(2);
        
        ivim_effect_out(loopi,loopj,:) = [kp(1),kp(2),kp(3)];  
        end
    end
end
subplot(221);imagesc(ivim_effect_out(:,:,1),[0,2]);colormap jet
subplot(222);imagesc(ivim_effect_out(:,:,2),[0,300]);colormap jet
subplot(223);imagesc(ivim_effect_out(:,:,3),[0,1]);colormap jet