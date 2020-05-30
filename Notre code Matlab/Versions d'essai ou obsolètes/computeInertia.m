function i = computeInertia(X,Y)
    ix = sum(Y.^2);
    iy = sum(X.^2);
    i=[ix,iy];
end