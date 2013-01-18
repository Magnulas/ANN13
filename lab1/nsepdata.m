ndata = 100;


classA = zeros(2,ndata);
classB = zeros(2,ndata);

classA(1,:) = [randn(1,ndata/2) .* 0.2 - 1.0, ...
            randn(1,ndata/2) .* 0.2 + 1.0];
classA(2,:) = randn(1,ndata) .* 0.2 + 0.3;
classB(1,:) = randn(1,ndata) .* 0.3 + 0.0;
classB(2,:) = randn(1,ndata) .* 0.3 - 0.1;

patterns = [classA, classB];
targets = [ones(1,ndata), ones(1,ndata).*-1];

permute = randperm(2*ndata);
patterns= patterns(:,permute);
targets = targets(:,permute);

plot(patterns(1,find(targets>0)), ...
    patterns(2,find(targets>0)), '*', ...
    patterns(1,find(targets<0)), ...
    patterns(2,find(targets<0)), '+')