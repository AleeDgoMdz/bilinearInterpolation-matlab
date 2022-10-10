path = "datos/CC_Temps_Vars_2000.nc"; 
disp(path);
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
    interData = change(interData,'<',0,0);
    %suavizado por dia
    interData = smoother(3,interData,hannMat);
    interYear(:,:,ntime) = interData;
    disp(strcat("fin de ",num2str(ntime)))
end
%Lectura del raster para cortar
[A,R] = readgeoraster("mx_2000.tif");
A = flipud(A); %acomodo de la matriz
A = double(A');
A = change(A,'==',0,NaN);

%Creacion de los productos
interYear= interYear.*A;
% meanYear = mean(interYear,3);
% sumYear = sum(interYear,3);
    
%Guardardo de datos en un archivo mat
%Obtencion de el anio como numero
year = regexp(path,"\d*","match");
year = str2double(cell2mat(year));
name = strcat("interpDiarias/interpb_",num2str(year));
save(name,"interYear",'-v7.3')
disp(strcat("FIN DE AÑO----------",num2str(year)))


%Para crear un netcdf, descomentar estas lineas  y verificar las
%variables

% nccreate(netcdfName,'longitudGrid', ...
%         'Dimensions',{"r",1,"c",1760});
% ncwrite(netcdfName,"longitudGrid",xgrid)
% %
% nccreate(netcdfName,'latitudGrid', ...
%         'Dimensions',{"r",1,"c2",1011})
% ncwrite(netcdfName,"latitudGrid",ygrid)
%     %
% nccreate(netcdfName,'interpolaciones', ...
%             'Dimensions',{"r2",1760,"c2",1011,"days",time})
% ncwrite(netcdfName,"interpolaciones",interYear)
% disp(strcat("FIN DE AÑO----------",num2str(year)))



% prueba de contorno de los datos
% levels = 0:20;
% contour(x,y,meanYear,levels)