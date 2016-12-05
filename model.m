clear       %no variables
close all   %no figures
clc         %empty command window 
%% 
ff = fullfile(pwd, '2.16.840.114421.80674.9357650136.9389186136');
files = dir(fullfile(ff, '*.dcm'));
fname = {files.name};
%% 

info = dicominfo(fullfile(ff, fname{1}));

voxel_size = [info.PixelSpacing; info.SliceThickness];

rd =  dicomread(fullfile(ff,fname{1}));
sz = size(rd);
num_image = length(fname);

ct = zeros(info.Rows, info.Columns, num_image, class(rd));

for i=length(fname):-1:1
    fname1 = fullfile(ff, fname{i});
    ct(:,:,i) = dicomread(fname1);
end
%%
cte = ct;
cte(:, :, 500:end) = 0;
cte(:, :, 1:40) = 0;
cte(400:end, :, :) = 0;
%% 
ctbone = cte;
ctbone(ctbone > 200) = 400;
ctbone(ctbone ~= 400) = -1000;
for z = 1:num_image
    for j = 1:768
        for i = 1:399
            if((ctbone(i,j,z) ~= 400) && (i < 400))
                ctbone(i,j,z) = -1000; 
            else 
                ctbone(i:400, j, z) = 400;
            end
        end
    end
end
%% 
bone_surf = isosurface(ctbone, 2.5);
modelbone = reducepatch(bone_surf,2000);
modelbone.normals = surfnorm(modelbone.vertices);
save modelbone.mat modelbone;
%% 
ctskin = cte;
ctskin(ctskin < -750) = 0;
ctskin(ctskin ~= 0) = 400;
%% 
skin_surf = isosurface(ctskin, 2.5);
modelskin = reducepatch(skin_surf,2000);
modelskin.normals = surfnorm(modelskin.vertices);
save modelskin.mat modelskin;
%% 
b.faces = modelbone.faces;
b.vertices = modelbone.vertices;
patch(b,'FaceColor',       'white', ...
         'EdgeColor',       'black',        ...
         'AmbientStrength', 0.15);
% Add a camera light, and tone down the specular highlighting
 %camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);
hold on;
%%
c.faces = modelskin.faces;
c.vertices = modelskin.vertices;
patch(c,'FaceColor',       'white', ...
         'EdgeColor',       'red',        ...
         'AmbientStrength', 0.15);
% Add a camera light, and tone down the specular highlighting
 %camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);
%% 

