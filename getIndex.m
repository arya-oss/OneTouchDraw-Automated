function i = getIndex(x,y,nodes, radius)
    radius = 2*radius;
    flag=0;
    for i=1:length(nodes)
        if nodes(i,1)+radius > x && nodes(i,1)-radius < x && nodes(i,2)+radius > y && nodes(i,2)-radius < y
            flag=1;
            break;
        end
    end
    if flag == 0
        i=0;
    end
end