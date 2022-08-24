function energy_cal = energy_calculation_um(node, ads, Lpds, open_node, moving)

tan_node = tan_calculation_chain(node);
energy = zeros(1,length(tan_node)-1);

for i = 1:length(tan_node)-1
    
    if (open_node == 1 && i == moving-1)
        energy(i) = 0;
    elseif (acos(dot(tan_node(:,i),tan_node(:,i+1))) > pi/6)
        energy(i) = 0;
        energy(i) = min(Lpds/(2*ads)*acos(dot(tan_node(:,i),tan_node(:,i+1)))^2, 12+(acos(dot(tan_node(:,i),tan_node(:,i+1)))-0.3)^6);
    else
        energy(i) = Lpds/(2*ads)*acos(dot(tan_node(:,i),tan_node(:,i+1)))^2;
    end
end

energy_cal = energy;

end