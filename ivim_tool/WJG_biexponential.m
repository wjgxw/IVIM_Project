function bi_exp=WJG_biexponential(par0,bvalue)
    diffusion_D = par0(1);
    diffusion_Dstar = par0(2);
    perfusion_f = par0(3);
    bi_exp = perfusion_f*exp(-bvalue*diffusion_Dstar/1000)+(1-perfusion_f)*exp(-bvalue*diffusion_D/1000);
    