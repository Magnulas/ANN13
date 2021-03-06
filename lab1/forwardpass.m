function [Oout, Hout] = forwardpass( X, W, V )

%Hin = H*
%Hout = H
%Oout = O

[dummy, ndata] = size(X);

%Hin = W * X; %W * X in papers
Hout = [rho(W * X); ones(1,ndata)];%[2 ./ (1+exp(-Hin)) - 1 ; ones(1,ndata)]; %rho(Hin)
%Oin = V * Hout;
Oout = rho(V * Hout);%2 ./ (1+exp(-Oin)) - 1; %rho(V*Hout)
end