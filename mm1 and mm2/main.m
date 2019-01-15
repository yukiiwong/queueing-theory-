%%%%统计数据
coach_lambda = 14;
square_north_lambda = 14;
bus_lambda = 14;
square_south_lambda = 14;
train_lambda = 14;
simu_num = 60 * 12 * 2; %模拟总时长

%%%输入流
coach = poissrnd(coach_lambda, 1, simu_num);
square_north = poissrnd(square_north_lambda, 1, simu_num);
bus = poissrnd(bus_lambda, 1, simu_num);
square_south = poissrnd(square_south_lambda, 1, simu_num);
train = poissrnd(train_lambda, 1, simu_num);
sum_passenger = sum(coach + square_north + bus + square_south + train); %总乘客数
ser_time = exprnd(1/14, 1, sum_passenger); %每位乘客服务时间

%%%%排队记录数据

%mm1
finish_people1 = 0; 
service1 = 0; %占用情况
finish_time1 = 1; %每台安检仪完成时间
check_line1 = zeros(simu_num ,1); %每单位时间到达人数
wait_line1 = zeros(simu_num + 1 ,1);
for i = 1:simu_num
    check_line1(i ,1) = 0.3 * sum(coach(1, i) + square_north(1, i) + bus(1, i) + square_south(1, i) + train(1, i));
end
passenger1 = zeros(sum_passenger, 2); %每位乘客属性 第一列为到达时间，第二列为结束安检时间

%mm2
finish_people2 = 0; 
finish_time2 = [1, 1]; %每台安检仪完成时间
check_line2 = zeros(simu_num ,1); %每单位时间到达人数
wait_line2 = zeros(simu_num + 1 ,1);
for i = 1:simu_num
    check_line2(i ,1) = 0.6 * sum(coach(1, i) + square_north(1, i) + bus(1, i) + square_south(1, i) + train(1, i));
end
passenger2 = zeros(sum_passenger, 2); %每位乘客属性 第一列为到达时间，第二列为结束安检时间


for i = 1:simu_num
    %mm1
    if finish_time1 < i
        finish_time1 = i;
    end
    wait_line1(i, 1) = wait_line1(i, 1) + check_line1(i ,1);
    for j = 1:check_line1(i ,1)
        finish_people1 = finish_people1 + 1;
        passenger1(finish_people1, 1) = i; %记录到达时间
        [passenger1, finish_time1, wait_line1] = mm1check_cost(finish_time1, finish_people1, ser_time, passenger1, i, wait_line1);
    end
    
    %mm2
    for h = 1:2
        if finish_time2(1, h) < i
            finish_time2(1, h) = i;
        end
    end
    wait_line2(i, 1) = wait_line2(i, 1) + check_line2(i ,1);
    for j = 1:check_line2(i ,1)
        finish_people2 = finish_people2 + 1;
        passenger2(finish_people2, 1) = i; %记录到达时间
        [passenger2, finish_time2, wait_line2] = mm2check_cost(finish_time2, finish_people2, ser_time, passenger2, i, wait_line2);
    end
    
end

ws_all1 = 0;
%%%%计算平均等待时间
for i = 1:finish_people1
    ws_per1 = passenger1(i, 2) - passenger1(i, 1);
    ws_all1 = ws_all1 + ws_per1;
end
w_s1 = ws_all1 / finish_people1;

%%%%计算平均队长
ls1 = mean(wait_line1);

ws_all2 = 0;
%%%%计算平均等待时间
for i = 1:finish_people2
    ws_per2 = passenger2(i, 2) - passenger2(i, 1);
    ws_all2 = ws_all2 + ws_per2;
end
w_s2 = ws_all2 / finish_people2;

%%%%计算平均队长
ls2 = mean(wait_line2);