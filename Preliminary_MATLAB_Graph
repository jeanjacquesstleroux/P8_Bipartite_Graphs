m = 5 

n = 7 

a = rand(m,n)>.25; 

 

big_a = [zeros(m,m), a; 

a', zeros(n,n)];  

g = graph(big_a); 

h = plot(g); 


% formatting the graph 

h.XData(1:m) = 1; 

h.XData((m+1):end) = 2; 

h.YData(1:m) = linspace(0,1,m); 

h.YData((m+1):end) = linspace(0,1,n); 

 
