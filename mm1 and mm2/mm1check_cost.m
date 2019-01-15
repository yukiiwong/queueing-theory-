function [passenger, finish_time, wait_line] = mm1check_cost(finish_time, finish_people, ser_time, passenger, i, wait_line)

finish_time = finish_time + ser_time(1, finish_people);
if finish_time >= i + 1
    wait_line(i + 1, 1) = wait_line(i + 1, 1) + 1;
end
passenger(finish_people, 2) = finish_time;
end