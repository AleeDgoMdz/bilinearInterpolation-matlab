files = dir("meanMensual/*.mat");
[numData,~] = size(files);

%Obtencion xgrid y ygrid (arrays) para generar la malla a interpolar
%  longrid = -118.3651143520000062:0.018: -86.703114352000000;
%  latgrid =  14.5386535700000010 :0.018:  32.7186535700000007;


for month=1:12
    for file=1:numData
        path= strcat("meanMensual/",files(file).name); %abrir archivo
        data = load(path,"finales").finales;
%         data = ncread(path,"mean");
        monthly(:,:,file) = data(:,:,month);
    end
    path = strcat("meanAgrupado/agrupado_",num2str(month));
    save(path,"monthly",'-v7.3')
    disp(strcat("fin de creacion ",num2str(month)));


%     %Creacion de netcdf
%     netcdfName = strcat("monthlyMean/promedio_",num2str(month),".nc");
%     nccreate(netcdfName,'longitudGrid', ...
%         'Dimensions',{"r",1,"c",1760});
%     ncwrite(netcdfName,"longitudGrid",longrid)
%     %
%     nccreate(netcdfName,'latitudGrid', ...
%         'Dimensions',{"r",1,"c2",1011})
%     ncwrite(netcdfName,"latitudGrid",latgrid)
%     %
%     nccreate(netcdfName,'mean', ...
%         'Dimensions',{"r2",1760,"c2",1011,"year",58})
%     ncwrite(netcdfName,"mean",monthly)
   
end
