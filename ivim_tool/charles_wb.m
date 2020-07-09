filepath = '/data2/lxd/ivim_data_test500/brain/';
filenames =[filepath,'Dstar_500','.charles'];
[fid,msg]=fopen(filenames,'wb');
fwrite(fid,Dstar_500,'double');
fclose(fid);