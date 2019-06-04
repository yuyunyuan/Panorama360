function [hh, inliers] = ransacfithomography(ref_P, dst_P, npoints, threshold)

% Input:
% ref_P - match points from image A
% dst_P - match points from image B
% npoints - number of samples
% threshold - distance threshold
% 
% 1. Randomly select minimal subset of points
% 2. Hypothesize a model
% 3. Computer error function
% 4. Select points consistent with model
% 5. Repeat hypothesize-and-verify loop
% 
    ninlier = 0;
    for i=1:1000
        rd = randi([1 npoints],1,8);
        x_ref = ref_P(1,rd)';
        y_ref = ref_P(2,rd)';
        x_des = dst_P(1,rd)';
        y_des = dst_P(2,rd)';

        % 8 dof
        A = zeros(16,8);
        B = [x_des, y_des];
        B = reshape(B',16,1);
        padone=ones(8,1);
        A(1:2:end,1:3) = [x_ref, y_ref, padone];
        A(2:2:end,4:6) = [x_ref, y_ref, padone];
        A(1:2:end,7:8) = [-x_ref.*x_des, -y_ref.*x_des];
        A(2:2:end,7:8) = [-x_ref.*y_des, -y_ref.*y_des];
        % Solve systems of linear equations Ax = B for x
        h =  mldivide(A,B);
        h = [h(1),h(2),h(3);h(4),h(5),h(6);h(7),h(8),1];
        %transform
        n_ref_P = h*ref_P;
        n_ref_P(1,:) = n_ref_P(1,:)./n_ref_P(3,:);
        n_ref_P(2,:) = n_ref_P(2,:)./n_ref_P(3,:);
        error = (n_ref_P(1,:) - dst_P(1,:)).^2 + (n_ref_P(2,:) - dst_P(2,:)).^2;
        %Number of nonzero matrix elements
        nonzero = nnz(error<threshold);
        if(nonzero >= npoints*.95)
            hh=h;
            inliers = find(error<threshold);
        elseif(nonzero>ninlier)
            ninlier = nonzero;
            hh=h;
            inliers = find(error<threshold);
        end 
    end
end