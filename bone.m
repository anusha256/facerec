clear       %no variables
close all   %no figures
clc         %empty command window 
%% 


ff = fullfile(pwd, '2.16.840.114421.80674.9357820679.9389356679');
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
bone = reducepatch(bone_surf,2000);
bone.normals = surfnorm(bone.vertices);
save bone.mat bone;
%% 
ctskin = cte;
ctskin(ctskin < -750) = 0;
ctskin(ctskin ~= 0) = 400;
%% 
skin_surf = isosurface(ctskin, 2.5);
skin = reducepatch(skin_surf,2000);
skin.normals = surfnorm(skin.vertices);
save skin.mat skin;
%% 
% TRI = triangulation(F,V);
% vn = vertexNormal(TRI);
% [M, N] = size(V);
% IN = zeros(size(V));
% DI = zeros(M, 1);
% %% 
% TR = triangulation(FV.faces, FV.vertices);
% for i = 1: size(V,1)
%     [vi, d] = nearestNeighbor(TR, V(i,:));
%     TI = FV.vertices(vi,:);
%     tr = vertexAttachments(TR,vi);
%     ri = TR(tr{:},:); 
%     Q1 = V(i, :) + vn(i,:);
%     Q2 = V(i,:);
%     P1 = FV.vertices(ri(:, 1), :);
%     P2 = FV.vertices(ri(:, 2), :);
%     P3 = FV.vertices(ri(:, 3), :);
%     N = cross(P2-P1,P3-P1);
%     P0 = Q1 + dot(P1-Q1,N)/dot(Q2-Q1,N)*(Q2-Q1);
%     DI(i) = sqrt((P0(:,1) - Q2(:, 1))^2 + (P0(:,2) - Q2(:, 2))^2 + (P0(:,2)-Q2(:, 2))^2);
%     IN(i, :) = P0;
% end
%% 
% b.faces = bone.faces;
% b.vertices = bone.vertices;
% patch(b,'FaceColor',       'white', ...
%          'EdgeColor',       'black',        ...
%          'AmbientStrength', 0.15);
% % Add a camera light, and tone down the specular highlighting
%  %camlight('headlight');
% material('dull');
% 
% % Fix the axes scaling, and set a nice view angle
% axis('image');
% view([-135 35]);
% hold on;
% %%
% b.faces = skin.faces;
% b.vertices = skin.vertices;
% p = patch(b,'FaceColor',       'white', ...
%          'EdgeColor',       'red',        ...
%          'AmbientStrength', 0.15);
% % Add a camera light, and tone down the specular highlighting
%  %camlight('headlight');
% material('dull');
% 
% % Fix the axes scaling, and set a nice view angle
% axis('image');
% view([-135 35]);
%% 