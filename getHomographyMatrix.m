function [hh] = getHomographyMatrix(point_ref, point_src, npoints)
% Use corresponding points in both images to recover the parameters of the transformation 
% Input:
% x_ref, x_src --- x coordinates of point correspondences
% y_ref, y_src --- y coordinates of point correspondences
% Output:
% h --- matrix of transformation

% NUMBER OF POINT CORRESPONDENCES
x_ref = point_ref(1,:)';
y_ref = point_ref(2,:)';
x_src = point_src(1,:)';
y_src = point_src(2,:)';

% COEFFICIENTS ON THE RIGHT SIDE OF LINEAR EQUATIONS
A = zeros(16,8);
padone=ones(8,1);
A(1:2:end,1:3) = [x_ref, y_ref, padone];
A(2:2:end,4:6) = [x_ref, y_ref, padone];
A(1:2:end,7:8) = [-x_ref.*x_src, -y_ref.*x_src];
A(2:2:end,7:8) = [-x_ref.*y_src, -y_ref.*y_src];

% COEFFICIENT ON THE LEFT SIDE OF LINEAR EQUATIONS
B = [x_src, y_src];
B = reshape(B',16,1);

% Solve systems of linear equations Ax = B for x
h =  mldivide(A,B);

hh = [h(1),h(2),h(3);h(4),h(5),h(6);h(7),h(8),1];
