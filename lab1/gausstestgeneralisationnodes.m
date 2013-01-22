x=[-5:1:5]';
y=x;
%theta = 0:0.01:2*pi;
%r = 0:0.1:5;

%for r=0:0.1:5,
   % for theta = 0:0.01:2*pi,
  %      targets
 %   end
%end

%x = r * cos(theta);
%y = r * sin(theta);


z=exp(-x.*x*0.1) * exp(-y.*y*0.1)' - 0.4;

epochs = 100;

targets = reshape (z, 1, size(z,1)*size(z,2));
[xx, yy] = meshgrid (x, y);
patterns = [reshape(xx, 1, size(xx,1)*size(xx,2)); reshape(yy, 1, size(yy,1)*size(yy,2))];

%nPoints = 10:2:size(targets,2)*0.8;
%trainingError = zeros(1,size(nPoints));

allPatterns = patterns;
allTargets = targets;

permute = randperm(size(allPatterns,2));
allPatterns = allPatterns(:,permute);
allTargets = allTargets(:,permute);
%nPoint = round(size(allTargets,2)*0.2);
%nPoint = 10;
%nPoint = 25;
nPoint = 60;

%layersArray = [1:1:50,60:20:400];
layersArray = [1:1:30];

%Generalization test
patterns = allPatterns(:,1:nPoint);
targets = allTargets(:,1:nPoint);
%%%%%

trainingError = zeros(1,size(layersArray,2));
validationError = zeros(1,size(layersArray,2));

for runs=1:100,
    
    j = 1;
    for nHiddenLayers = layersArray,

    [insize, ndata] = size(patterns);
    [outsize, ndata] = size(targets);
    X = [patterns ; ones(1,ndata)];
    W = randn(nHiddenLayers, insize + 1); %hmm, size correct? size and bias
    V = randn(outsize, nHiddenLayers + 1); %hmm, size correct? Add one for bias?
    dW = zeros(size(W,1),size(W,2));
    dV = zeros(size(V,1),size(V,2));

    eta=0.01;
    momentum=0.9;

        for i=1:epochs,
        [Oout, Hout] = forwardpass(X, W, V);
        [delta_H, delta_O] = backwardpass(Oout, Hout, V, targets, nHiddenLayers);
        [W, V, dW, dV] = weightupdate(delta_H, delta_O, Hout, momentum, eta, dW, dV, W, V, X);

           % zz = reshape(Oout, sqrt(ndata), sqrt(ndata));
           % mesh(x,y,zz-z);
           % axis([-5 5 -5 5 -0.7 0.7]);
           % drawnow;

        end
        %trainingError = [trainingError, 0.5 * sum(sum((Oout-targets).^2))];
        trainingError(j) = trainingError(j) + 0.5 * sum(sum((Oout-targets).^2));
        
        [ValOout, ValHout] = forwardpass([allPatterns; ones(1,size(allTargets,2))], W, V);
        %validationError = [validationError, 0.5 * sum(sum((ValOout-allTargets).^2))];
        validationError(j) = validationError(j) + 0.5 * sum(sum((ValOout-allTargets).^2));
        j = j + 1;
    end
end

trainingError = trainingError./numel(trainingError);
validationError = validationError./numel(validationError);

plot(layersArray,trainingError, '-ro', layersArray,validationError, '-bo');
title(['Number of training points ', int2str(nPoint)])
legend('Training error','Validation error');

