clear 
close all
clc
%% 
load bone.mat;
load modelbone.mat;
load modelskin.mat;
%%  
Options.useNormals = 1;
Options.plot = 1;
Options.ignoreBoundary = 0;
%% 
[vertsTransformed, x] = nricp(bone, modelbone, Options);
%% 
vn = surfnorm(vertsTransformed);
[M, N] = size(vertsTransformed);
DI = zeros(M, 1);
j = 1;
for i = 1:M
    Q1 = vertsTransformed(i,:);
    Q2 = Q1 + vn(i, :);
    line = createLine3d(Q1, Q2);
    [intr, pos, ind] = intersectLineMesh3d(line, modelskin.vertices, modelskin.faces);
    d = intr(2:end, 1:3);
    X = [Q1; d(1:end, 1), d(1:end, 2), d(1:end, 3)];
end
%% 
% IN = zeros(M, N);
% DI = zeros(M, 1);
% %% 
% skin = triangulation(modelskin.faces, modelskin.vertices);
% for i = 1: M
%     [vi, d] = nearestNeighbor(skin, vertsTransformed(i,:));
%     %TI = modelskin.vertices(vi,:);
%     tr = vertexAttachments(skin,vi);
%     ri = skin(tr{:},:); 
%     Q1 = vertsTransformed(i, :) + vn(i,:);
%     Q2 = vertsTransformed(i,:);
%     P1 = modelskin.vertices(ri(:, 1), :);
%     P2 = modelskin.vertices(ri(:, 2), :);
%     P3 = modelskin.vertices(ri(:, 3), :);
%     N = cross(P2-P1,P3-P1);
%     P0 = Q1 + dot(P1-Q1,N)/dot(Q2-Q1,N)*(Q2-Q1);
%     DI(i) = sqrt((P0(:,1) - Q2(:, 1))^2 + (P0(:,2) - Q2(:, 2))^2 + (P0(:,2)-Q2(:, 2))^2);
%     IN(i, :) = P0;

%     DI(i) = sqrt((X(4) - X(1))^2 + (X(5) - X(2))^2 + (X(6) - X(3))^2 );
% end
%% 
