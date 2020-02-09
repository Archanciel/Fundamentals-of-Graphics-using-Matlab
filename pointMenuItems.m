menuItemCellArray = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12'}
itemNumber = length(menuItemCellArray);
extendedMenuItemCellArray = cell(1, itemNumber);
n = 0;
skipItem = 0;

for i = 1:itemNumber
    if i == 1
        n = i;
        extendedMenuItemCellArray{n} = 'Start slope';
        n = n + 1;
        extendedMenuItemCellArray{n} = menuItemCellArray{i};
        n = n + 1;
    elseif i == itemNumber
        extendedMenuItemCellArray{n} = menuItemCellArray{i};
        n = n + 1;
        extendedMenuItemCellArray{n} = 'End slope';
    elseif mod(i, 4) == 0
        extendedMenuItemCellArray{n} = sprintf('Point %d-%d slope', i, i + 1);
        n = n + 1;
        skipItem = 1;
    else
        if skipItem == 0
            extendedMenuItemCellArray{n} = menuItemCellArray{i};
            n = n + 1;
        else
            skipItem = 0;
        end
    end
end

extendedMenuItemCellArray

    