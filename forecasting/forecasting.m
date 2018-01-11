lag = 10;
p = .77 ;
N = size(X,1);  % total number of rows 
tf = false(N,1);   % create logical index vector
tf(1:round(p*N)) = true ;    
tf = tf(randperm(N));   % randomise order
dataTraining = X(tf,:); 
dataTesting = X(~tf,:); 

modelMA = tsmovavg(dataTraining, 's', lag, 1);

%plot(X, modelMA)