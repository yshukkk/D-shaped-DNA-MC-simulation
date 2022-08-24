function moving_test = moving_check(energy_before, energy_after)

test = 0;
check = rand();
denergy_check = exp(energy_before-energy_after);

if check < denergy_check
    test = 1;
end

moving_test = test;

end