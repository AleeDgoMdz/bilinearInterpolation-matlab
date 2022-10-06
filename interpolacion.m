path = "datos/CC_Temps_Vars_1972.nc";
data = netcdf.open(path);
long = -ncread(path,"Longitude");
lat = ncread(path,"Latitude");
precip = ncread(path,"PRECIP");
[time,~] = size(precip);

%Obtencion xgrid y ygrid (arrays) para generar la malla a interpolar
 xgrid = -118.3651143520000062:0.018: -86.703114352000000;
 ygrid =  14.5386535700000010 :0.018:  32.7186535700000007;
%Generacion de los ejes de la malla (x,y matrices)
[x,y]= ndgrid(xgrid,ygrid);

hannMat = [0 0.125 0; 0.125 0.5 0.125; 0 0.125 0 ];
for ntime=1:time

    data = [long lat precip(ntime,:)'];
    filData = data(sum(isnan(data),2)==0,:);
    filData = double(unique(filData(:,:),"rows","first"));
    f= scatteredInterpolant(filData(:,1:2),filData(:,3),"linear","linear");
    interData = f(x,y);
    %suavizado por dia
    interData = smoother(3,interData,hannMat);
    interYear(:,:,ntime) = interData;
    disp(strcat("fin de ",num2str(ntime)))
end
meanYear = mean(interYear,3);
sumYear = sum(interYear,3);

%Lectura del raster para cortar
[A,R] = readgeoraster("mx_2000.tif");
A = flipud(A); %acomodo de la matriz
A = double(A');
A = change(A,'==',0,NaN);

% Generacion de los datos acomulados y promedios
meanYear = meanYear.*A;
sumYear = sumYear.*A;

%Generacion del mat file
yearString = extractAfter(path,"Vars_");
yearString = extractBefore(yearString,".nc");
pathOutput = strcat("salidas/precipInterp_",yearString);
save(pathOutput,"sumYear","meanYear","interYear",'-v7.3')



%Generacion del netcdf
%yearString = extractAfter(path,"Vars_");
%pathOutput = strcat("precipiInterp_",yearString);
%nccreate(pathOutput,"PRECIPITACION");
%ncwrite(pathOutput,"PRECIPITACION",interYear);

%suavizado con una segunda interpolacion
%interMeanMil = interp2(meanYear,2);
%xgrid2 = -118.3651143520000062:0.0045: -86.703114352000000;
%ygrid2 =  14.5386535700000010 :0.0045:  32.7186535700000007;
%[x2,y2]= ndgrid(xgrid2,ygrid2);

% prueba de contorno de los datos
% levels = 0:20;
% contour(x,y,meanYear,levels)

