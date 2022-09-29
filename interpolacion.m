%data = netcdf.open("datos/CC_Temps_Vars_2000.nc");
long = -ncread("datos/CC_Temps_Vars_2000.nc","Longitude");
lat = ncread("datos/CC_Temps_Vars_2000.nc","Latitude");
precip = ncread("datos/CC_Temps_Vars_2000.nc","PRECIP");

%Limpieza de datos (eliminacion de nan data y datos)
data = [long lat precip(1,:)'];
filData = data(sum(isnan(data),2)==0,:);
filData = double(unique(filData(:,:),"rows","first"));

%Obtencion xgrid y ygrid para el meshgrid
xgrid = -117.12512:0.018: -86.74157;
ygrid =  14.54628 :0.018:  32.71284;

%[xq,yq] = meshgrid(xgrid,ygrid); grid data para el metodo griddata
%interpolation = griddata(xdata,ydata,zdata,xq,yq); Opcion relativamente
%lenta para interpolar

[x,y]= ndgrid(xgrid,ygrid);
f= scatteredInterpolant(filData(:,1:2),filData(:,3),"linear","linear");
interData = f(x,y);
