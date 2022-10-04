%Este archivo genera archivos mat que contiene los promedios de cada mes
listdata = dir("salidas1_/*.mat");
[ndata,~] = size(listdata);

for file=1:ndata
    dataName = listdata(file).name;
    %Obtencion de el anio como numero
    year = regexp(dataName,"\d*","match");
    year = str2double(cell2mat(year));
    %Apertura del archivo
    path = strcat("salidas1_/",dataName);
    dataInterpolation = load(path,"interYear").interYear;
    %obtencion del num de dias por mes
    for month=1:12        
        days = max(calendar(year,month),[],'all');
        monthData = dataInterpolation(:,:,1:days);
        monthlyMean = mean(monthData,3);
        finales(:,:,month) = monthlyMean;
    end
    filenamepath = strcat("mensuales/meanMensual_",num2str(year));
    save(filenamepath,"finales");
    disp(strcat("fin de anio",num2str(year)));
end



% dailysInter = load("salidas1_/precipInterp_1961.mat","interYear").interYear;
% 
% %max(a,[],'all')
% 
% %ejemplo
% pathExample = listdata(1).name;
% year = regexp(pathExample,"\d*","match");
% year = str2double(cell2mat(year));