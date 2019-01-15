function [passenger, finish_time, wait_line] = mm2check_cost(finish_time, finish_people, ser_time, passenger, i, wait_line, m)

a = finish_time(1, 1);
b = 0;
for j = 1:2
    if finish_time(1, j) <= a
        a = finish_time(1, j);
        b = j;
    end
end
finish_time(1, b) = finish_time(1, b) + ser_time(1, finish_people);
if finish_time >= i + 1
    wait_line(i + 1, 1) = wait_line(i + 1, 1) + 1;
end
passenger(finish_people, 2) = finish_time(1, b);
end