function single_exp=WJG_exponential(par0,bvalue)
diffusion_D = par0(1);
perfusion_f = par0(2);
single_exp = (1-perfusion_f)*exp(-bvalue*diffusion_D/1000);