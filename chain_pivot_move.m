N = 30;
ads = 0.34;
Lpds = 50;
kbT = 1.38066*10^(-5)*295;
K = 0; %for umbralla sampling E = K*(r-r_0)^2
r_0 = 7; %for umbralla sampling
open_p = 0; %open probability of a base pair

N_monte = 10000000;
equilibrate = 100000;
display_N = 1000;

h = 12;
b = 0.3;
methyl_position = [];

vec_node = zeros(3,N);
vec_tan = zeros(3,N);
energy_bend = zeros(1,N);
energy_trace = zeros(N_monte/display_N+1,1);
EED_dye = zeros(N_monte/display_N+1,1);
EED_end = zeros(N_monte/display_N+1,1);

for i = 2:N %random sequence position
    
    theta= (rand-0.5)*pi;
    phi = rand*pi*2;

    vec_node(1,i) = vec_node(1,i-1) + ads*cos(theta)*cos(phi);
    vec_node(2,i) = vec_node(2,i-1) + ads*cos(theta)*sin(phi);
    vec_node(3,i) = vec_node(3,i-1) + ads*sin(theta);
end

vec_tan = tan_calculation_chain(vec_node);
energy_bend = energy_calculation_um(vec_node, ads, Lpds, K, r_0, open_node);

energy_trace(1) = sum(energy_bend);
EED_dye(1) = norm(vec_node(:,(N-24)/2+1)-vec_node(:,(N-24)/2+24));
EED_end(1) = norm(vec_node(:,1)-vec_node(:,N));
vec_node_test = vec_node;
vec_tan_test = vec_tan;
energy_old = sum(energy_bend);

tic
for i=1:equilibrate %equilibrate
    moving_node = randi(N)+1;
    rotation_angle = (rand-0.5)*pi/9;
    open_test = rand();
    open_node = 0;
    
    if open_test < open_p
        open_node = rand();
    end
    
    vec_node_test = vec_node;
    
    new_node_test = pivot_node(vec_node_test,moving_node,rotation_angle);
    energy_bend_test = energy_calculation_um(new_node_test, ads, Lpds, K, r_0, open_node);
    energy_trace_test = sum(energy_bend_test);
    
    moving_test = moving_check(energy_old,energy_trace_test);
    
    if moving_test == 1
        vec_node = new_node_test;
        energy_old = energy_trace_test;
    end
end

for i=1:N_monte
    moving_node = randi(N)+1;
    rotation_angle = (rand-0.5)*pi/9;
    
    vec_node_test = vec_node;
    
    new_node_test = pivot_node(vec_node_test,moving_node,rotation_angle);
    energy_bend_test = energy_calculation_um(new_node_test, ads, Lpds, K, r_0, open_node);
    energy_trace_test = sum(energy_bend_test);
    
    moving_test = moving_check(energy_old,energy_trace_test);
    
    if moving_test == 1
        vec_node = new_node_test;
        energy_old = energy_trace_test;
    end
    
    if mod(i,display_N) == 0
        disp(i)
        energy_trace(i/display_N+1) = energy_trace_test;
        EED_dye(i/display_N+1) = norm(vec_node(:,(N-24)/2+1)-vec_node(:,(N-24)/2+24));
        EED_end(i/display_N+1) = norm(vec_node(:,1)-vec_node(:,N));
    end
end
toc

plot3(vec_node(1,:),vec_node(2,:),vec_node(3,:));

