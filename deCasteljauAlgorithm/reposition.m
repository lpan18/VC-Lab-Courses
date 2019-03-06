function cPoly = reposition(cPoly)
    % Select point
    [x, y] = ginput(1);
    point = [x y];
    [~, i] = min(vecnorm(cPoly - point,2,2));
    plot(cPoly(i,1),cPoly(i,2),'gs','MarkerFaceColor','g');
    
    % Select new pos
    [x, y] = ginput(1);
    cPoly(i,:) = [x y];
end