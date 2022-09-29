%data = netcdf.open("datos/CC_Temps_Vars_2000.nc");
long = -ncread("datos/CC_Temps_Vars_2000.nc","Longitude");
lat = ncread("datos/CC_Temps_Vars_2000.nc","Latitude");
precip = ncread("datos/CC_Temps_Vars_2000.nc","PRECIP");
[time,~] = size(precip);


%Limpieza de datos (eliminacion de nan data y datos)
%data = [long lat precip(1,:)'];
%filData = data(sum(isnan(data),2)==0,:);
%filData = double(unique(filData(:,:),"rows","first"));

%Obtencion xgrid y ygrid para la interpolacion
 xgrid = -117.12512:0.018: -86.74157;
 ygrid =  14.54628 :0.018:  32.71284;

%Generacion de la malla interpolada f
[x,y]= ndgrid(xgrid,ygrid);
%f= scatteredInterpolant(filData(:,1:2),filData(:,3),"linear","linear");
%interData = f(x,y); %Interpolacion y extrapolacion a partir de la malla f



%Lectura del shpfile y deliminatacion de la malla interpolada
%mx = shaperead("shpMx/mx.shp","UseGeoCoords",true);

for ntime=1:time
    if ntime ==32
        break
    end
    data = [long lat precip(ntime,:)'];
    filData = data(sum(isnan(data),2)==0,:);
    filData = double(unique(filData(:,:),"rows","first"));
    f= scatteredInterpolant(filData(:,1:2),filData(:,3),"linear","linear");
    interData = f(x,y);
    interYear(:,:,ntime) = interData;
    disp(strcat("fin de ",num2str(ntime)))
end