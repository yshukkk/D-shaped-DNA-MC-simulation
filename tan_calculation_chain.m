function tan_cal = tan_calculation_chain(node)

vec_node_mod = zeros(3,length(node)-1);

for i = 1:length(node)-1
    vec_node_mod(1,i) = node(1,i+1) - node(1,i);
    vec_node_mod(2,i) = node(2,i+1) - node(2,i);
    vec_node_mod(3,i) = node(3,i+1) - node(3,i);
    
    vec_length = norm(vec_node_mod(:,i));
    
    vec_node_mod(1,i) = vec_node_mod(1,i)/vec_length;
    vec_node_mod(2,i) = vec_node_mod(2,i)/vec_length;
    vec_node_mod(3,i) = vec_node_mod(3,i)/vec_length;
end

tan_cal = vec_node_mod;

end