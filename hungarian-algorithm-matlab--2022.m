
function [matching, numPerfectMatchings] = HungarianAlgorithm(adjacencyMatrix)
    % Check if adjacency matrix is square and bipartite
    [numRows, numCols] = size(adjacencyMatrix);
    if numRows ~= numCols
        error('Input matrix is not square; it should be a bipartite graph adjacency matrix.');
    end

    % Check if matrix is binary (contains only 0s and 1s)
    if ~all(ismember(adjacencyMatrix(:), [0, 1]))
        error('Input matrix should contain only 0s and 1s');
    end

    % Initialize the cost matrix for the Hungarian algorithm
    costMatrix = ones(numRows, numCols) * max(adjacencyMatrix(:)) - adjacencyMatrix;

    % Step 1: Row reduction
    costMatrix = rowReduction(costMatrix);

    % Step 2: Column reduction
    costMatrix = colReduction(costMatrix);

    % Step 3: Find initial feasible solution, build star matrix
    [starMatrix, primeMatrix] = findInitialFeasibleSolution(costMatrix);

    while any(starMatrix(:))
        % Step 4: prime non covered zeroes
        [row, col] = find(starMatrix);
        row = row(1);
        col = col(1);
        primeMatrix(row, col) = 1;
        starCol = find(starMatrix(row, :), 1);
        if isempty(starCol)
            break;
        else
            starMatrix(row, starCol) = 0;
        end

        % Step 5: Construct an augmenting path
        path = constructAugmentingPath(primeMatrix, row);
        primeMatrix(:) = 0;
        starMatrix(:) = 0;
        path(:, 2) = 1;
        starMatrix(path(:, 1), path(:, 2)) = 1;
        primeZeros = find(path(:, 1), 1);
        primeMatrix(primeZeros, path(primeZeros, 2)) = 1;

        % Go back to Step 4
    end

    % Step 6: Find the minimum cover and calculate the number of perfect matchings
    numPerfectMatchings = sum(costMatrix(:) .* (primeMatrix == 1));
    
    % Construct the matching
    matching = find(starMatrix);

    function costMatrix = rowReduction(costMatrix)
        % Row reduction: Subtract the minimum value in each row from that row.
        rowMin = min(costMatrix, [], 2);
        costMatrix = costMatrix - rowMin;
    end

    function costMatrix = colReduction(costMatrix)
        % Column reduction: Subtract the minimum value in each column from that column.
        colMin = min(costMatrix, [], 1);
        costMatrix = costMatrix - colMin;
    end

    function [starMatrix, primeMatrix] = findInitialFeasibleSolution(costMatrix)
        starMatrix = zeros(size(costMatrix));
        primeMatrix = zeros(size(costMatrix));
        for row = 1:numRows
            [~, col] = find(costMatrix(row, :) == 0 & sum(starMatrix, 1) == 0, 1);
            if ~isempty(col)
                starMatrix(row, col) = 1;
                primeMatrix(row, col) = 1;
            end
        end
    end

    function path = constructAugmentingPath(primeMatrix, row)
        path = zeros(numRows, 2);
        path(1, 1) = row;
        path(1, 2) = find(primeMatrix(row, :));
        for i = 2:numRows
            prevRow = path(i - 1, 2);
            path(i, 1) = find(starMatrix(prevRow, :));
            path(i, 2) = prevRow;
        end
    end
end

disp('Hungarian Algorithm for Bipartite Graph Matching');

enterGraph = 'Enter the adjacency matrix for the bipartite graph (each row separated by spaces):\n';
adjacencyMatrix = input(enterGraph);
[matching, numPerfectMatchings] = HungarianAlgorithm(adjacencyMatrix);

% Display the matching and the number of perfect matchings
disp('Matching:');
disp(matching);
fprintf('Number of Perfect Matchings: %d\n', numPerfectMatchings);

G = graph(adjacencyMatrix);

% Plot the bipartite graph
figure;
h = plot(G, 'Layout', 'force', 'NodeLabel', {});
highlight(h, matching(:, 1), matching(:, 2), 'EdgeColor', 'r', 'LineWidth', 2);

title('Bipartite Graph with Perfect Matching');
xlabel('Side A');
ylabel('Side B');
