function vec_node_new = pivot_node_2D(node, node_number, angle)

node_rot = node;


for i = node_number+1:length(node)
    rotation_axis = [0; 0; 1];
    point_for_rot = [node(1,i)-node(1,node_number); node(2,i)-node(2,node_number); node(3,i)-node(3,node_number)];
    point_rot = (point_for_rot-dot(point_for_rot,rotation_axis)*rotation_axis)*cos(angle) + cross(rotation_axis,point_for_rot)*sin(angle) + dot(rotation_axis,point_for_rot)*rotation_axis;

    %quat = quaternion(cos(angle/2), sin(angle/2)*rotation_axis(1), sin(angle/2)*rotation_axis(2), sin(angle/2)*rotation_axis(3));
    %point_rot = rotatepoint(quat,[node(1,i+1)-node(1,node_number) node(2,i+1)-node(2,node_number) node(3,i+1)-node(3,node_number)]);
    
    node_rot(:,i) = point_rot + node(:,node_number);
end

vec_node_new = node_rot;

end