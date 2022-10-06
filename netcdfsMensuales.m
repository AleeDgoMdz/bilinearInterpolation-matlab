listdata = dir("mensuales/*.nc");
[ndata,~] = size(listdata);

%Obtencion xgrid y ygrid (arrays) para generar la malla a interpolar
 longrid = -118.3651143520000062:0.018: -86.703114352000000;
 latgrid =  14.5386535700000010 :0.018:  32.7186535700000007;


for month=1:12
    for file=1:ndata
        path= strcat("mensuales/",listdata(file).name);
        data = ncread(path,"mean");
        monthly(:,:,file) = data(:,:,month);
    end

    %Creacion de netcdf
    netcdfName = strcat("monthlyMean/promedio_",num2str(month),".nc");
    nccreate(netcdfName,'longitudGrid', ...
        'Dimensions',{"r",1,"c",1760});
    ncwrite(netcdfName,"longitudGrid",longrid)
    %
    nccreate(netcdfName,'latitudGrid', ...
        'Dimensions',{"r",1,"c2",1011})
    ncwrite(netcdfName,"latitudGrid",latgrid)
    %
    nccreate(netcdfName,'mean', ...
        'Dimensions',{"r2",1760,"c2",1011,"year",58})
    ncwrite(netcdfName,"mean",monthly)
   
    disp(strcat("fin de creacion ",num2str(month)));
%     netcdfName = strcat("netcdfs_mensuales/promedio_",num2str(month),".nc");
%     nccreate(netcdfName,'longitud', ...
%         'Dimensions',{"r",1760,"c",1011});
%     ncwrite(netcdfName,"longitud",x)
%     %
%     nccreate(netcdfName,'latitud', ...
%         'Dimensions',{"r",1760,"c",1011})
%     ncwrite(netcdfName,"latitud",y)
%     %
%     nccreate(netcdfName,'mean', ...
%         'Dimensions',{"r",1760,"c",1011,"year",58})
%     ncwrite(netcdfName,"mean",monthly)
% 
%     disp(strcat("fin de creacion ",num2str(month)));
%     
end
