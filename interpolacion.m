%data = netcdf.open("datos/CC_Temps_Vars_2000.nc");
long = -ncread("datos/CC_Temps_Vars_2000.nc","Longitude");
lat = ncread("datos/CC_Temps_Vars_2000.nc","Latitude");
precip = ncread("datos/CC_Temps_Vars_2000.nc","PRECIP");
[time,~] = size(precip);

%Obtencion xgrid y ygrid (arrays) para generar la malla a interpolar
 xgrid = -118.3651143520000062:0.018: -86.703114352000000;
 ygrid =  14.5386535700000010 :0.018:  32.7186535700000007;
%Generacion de los ejes de la malla (x,y matrices)
[x,y]= ndgrid(xgrid,ygrid);


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
meanJan = mean(interYear,3);

%Lectura del raster
[A,R] = readgeoraster("mx_2000.tif");

A1 = double(A1);
A1 = flipud(A)
A2 = change(A1,'==',0,NaN  );
pcolor(A2)
shading flat,colorbar


meanMask_01 = A2.*meanJan';
pcolor(meanMask_01)
shading flat,colorbar
