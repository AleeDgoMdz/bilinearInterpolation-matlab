listdata = dir("mensuales/*.mat");
[ndata,~] = size(listdata);

%Obtencion xgrid y ygrid (arrays) para generar la malla a interpolar
 xgrid = -118.3651143520000062:0.018: -86.703114352000000;
 ygrid =  14.5386535700000010 :0.018:  32.7186535700000007;
%Generacion de los ejes de la malla (x,y matrices)
[x,y]= ndgrid(xgrid,ygrid);



for month=1:12
    for file=1:ndata
        path= strcat("mensuales/",listdata(file).name);
        data = load(path,"finales").finales;
        monthly(:,:,file) = data(:,:,month);
    end
    %Creacion de netcdf

    netcdfName = strcat("netcdfs_mensuales/promedio_",num2str(month),".nc");
    nccreate(netcdfName,'longitud', ...
        'Dimensions',{"r",1760,"c",1011});
    ncwrite(netcdfName,"longitud",x)
    %
    nccreate(netcdfName,'latitud', ...
        'Dimensions',{"r",1760,"c",1011})
    ncwrite(netcdfName,"latitud",y)
    %
    nccreate(netcdfName,'mean', ...
        'Dimensions',{"r",1760,"c",1011,"year",58})
    ncwrite(netcdfName,"mean",monthly)

    disp(strcat("fin de creacion ",num2str(month)));
    
end
