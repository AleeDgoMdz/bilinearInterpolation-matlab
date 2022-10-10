%Este archivo genera archivos mat que contiene los promedios de cada mes
files = dir("interpDiarias/*.mat");
[numData,~] = size(files);

%Obtencion xgrid y ygrid (arrays) para generar la malla a interpolar
%  longrid = -118.3651143520000062:0.018: -86.703114352000000;
%  latgrid =  14.5386535700000010 :0.018:  32.7186535700000007;


for file=59:numData
    firstDay=0;
    lastDay=0;
    dataName = files(file).name;
    %Obtencion de el anio como numero
    year = regexp(dataName,"\d*","match");
    year = str2double(cell2mat(year));
    
    %Apertura del archivo
    path = strcat("interpDiarias/",dataName);
    dataInterpolation = load(path,"interYear").interYear;
    %obtencion del num de dias por mes
    for month=1:12        
%         days = max(calendar(year,month),[],'all');
        if month ==1
            disp(strcat("firstDay----",num2str(firstDay)));
            lastDay = max(calendar(year,month),[],'all');
            monthData = dataInterpolation(:,:,1:lastDay);
            firstDay =lastDay;
            disp(strcat("lastDay----",num2str(lastDay)));
            disp("SALTO---------")
        else
            lastDay = lastDay + max(calendar(year,month),[],'all');
            monthData = dataInterpolation(:,:,firstDay+1:lastDay);
            disp(strcat("firstDay----",num2str(firstDay)));
            disp(strcat("lastDay----",num2str(lastDay)));
            disp("SALTO---------")
            firstDay= lastDay;
        end
        monthlyMean = mean(monthData,3);
        finales(:,:,month) = monthlyMean;
    end
    path = strcat("meanMensual/meanMensualb_",num2str(year));
    save(path,"finales",'-v7.3')
    disp(strcat("fin de año ",num2str(year)))

    
%----DESCOMENTEAR PARA CREAR LOS NETCDF
%     netcdfName = strcat("mensuales/promedio_",num2str(year),".nc");
%     nccreate(netcdfName,'longitudGrid', ...
%         'Dimensions',{"r",1,"c",1760});
%     ncwrite(netcdfName,"longitudGrid",longrid)
%     %
%     nccreate(netcdfName,'latitudGrid', ...
%         'Dimensions',{"r",1,"c2",1011})
%     ncwrite(netcdfName,"latitudGrid",latgrid)
%     %
%     nccreate(netcdfName,'mean', ...
%         'Dimensions',{"r2",1760,"c2",1011,"month",12})
%     ncwrite(netcdfName,"mean",finales)
%    
%     disp(strcat("fin de creacion ",num2str(year)));
%     
%     filenamepath = strcat("mensuales/meanMensual_",num2str(year));
%     save(filenamepath,"finales");
%     disp(strcat("fin de anio",num2str(year)));
end
