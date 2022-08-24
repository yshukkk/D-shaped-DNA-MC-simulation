syms lp;

N_sq = [26 28 30 34 38 40 42 50];
K_sq = [6 5 4 3 2 1 0];

for t = 1:7

N = 30;
ads = 0.34;
Lpds = 50;
kbT = 1.38066*10^(-5)*295;
K = K_sq(t); %for umbralla sampling E = K*(r-r_0)^2
r_0 = 0; %for umbralla sampling
open_p = 0; %open probability of a base pair
open_node = 0;
moving_node = 1;
y = 2*lp*(N-1)*0.34*(1-lp/((N-1)*0.34)*(1-exp(-(N-1)*0.34/lp))); 

N_monte = 1000000;
equilibrate = 1000000;
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

tic
for k = 1:20
    
    for i = 2:N %linear
        vec_node(1,i) = vec_node(1,i-1) + ads;
        vec_node(2,i) = 0;
    end
    
    vec_tan = tan_calculation_chain(vec_node);
    energy_bend = energy_calculation_um(vec_node, ads, Lpds, open_node, moving_node);
    
    energy_trace(1) = sum(energy_bend);
    EED_dye(1) = norm(vec_node(:,(N-24)/2+1)-vec_node(:,(N-24)/2+24));
    EED_end(1) = norm(vec_node(:,1)-vec_node(:,N));
    EED_end_test = norm(vec_node(:,1)-vec_node(:,N));
    vec_node_test = vec_node;
    vec_tan_test = vec_tan;
    energy_old = sum(energy_bend) + K*(EED_end_test-r_0);
    
    %open_p = 0.0003;
    open_p = 10^(k*0.1)/10^4;
    
    for i=1:equilibrate %equilibrate
        moving_node = randi(N-1);
        rotation_angle = (rand-0.5)*pi/9;
        open_test = rand();
        open_node = 0;
        
        if open_test < open_p
            open_node = 1;
            %rotation_angle = (rand-0.5)*pi;
            rotation_angle = pi/6;
        end
        
        vec_node_test = vec_node;
        
        new_node_test = pivot_node_2D(vec_node_test,moving_node,rotation_angle);
        EED_end_test = norm(new_node_test(:,1)-new_node_test(:,N));
        energy_bend_test = energy_calculation_um(new_node_test, ads, Lpds, open_node, moving_node);
        energy_trace_test = sum(energy_bend_test) + K*(EED_end_test-r_0);
        
        moving_test = moving_check(energy_old,energy_trace_test);
        if open_node == 1
            moving_test = 1;
        end
        
        if moving_test == 1
            vec_node = new_node_test;
            energy_old = energy_trace_test;
        end
    end
    
    for i=1:N_monte
        moving_node = randi(N-1);
        rotation_angle = (rand-0.5)*pi/9;
        open_node = 0;
        open_test = rand();

        if open_test < open_p
            open_node = 1;
            %rotation_angle = (rand-0.5)*pi;
            rotation_angle = pi/6;
        end        
        
        vec_node_test = vec_node;
        
        new_node_test = pivot_node(vec_node_test,moving_node,rotation_angle);
        EED_end_test = norm(new_node_test(:,1)-new_node_test(:,N));
        energy_bend_test = energy_calculation_um(new_node_test, ads, Lpds, open_node, moving_node);
        energy_trace_test = sum(energy_bend_test) + K*(EED_end_test-r_0);
        
        moving_test = moving_check(energy_old,energy_trace_test);
        if open_node == 1
            moving_test = 1;
        end
        
        if moving_test == 1
            vec_node = new_node_test;
            energy_old = energy_trace_test;
        end
        
        if mod(i,display_N) == 0
            disp(i)
            energy_trace(i/display_N+1) = energy_trace_test;
            EED_dye(i/display_N+1) = norm(vec_node_test(:,(N-24)/2+1)-vec_node_test(:,(N-24)/2+24));
            EED_end(i/display_N+1) = norm(vec_node_test(:,1)-vec_node_test(:,N));
        end
    end
    
    end_distance(k,t) = mean(EED_end(2:N_monte/display_N+1));
    end_std(k,t) = std(EED_end(2:N_monte/display_N+1));
    dye_distance(k,t) = mean(EED_dye(2:N_monte/display_N+1));
    dye_std(k,t) = std(EED_dye(2:N_monte/display_N+1));
    
    energy_ave(k,t) = mean(energy_trace(2:N_monte/display_N+1));
    persistence(k,t) = double(vpasolve(y-(end_distance(k,t))^2,[0 100]));
end
toc

end

plot(vec_node(1,:),vec_node(2,:),'-o');
axis equal
