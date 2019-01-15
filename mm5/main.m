coach_lambda = 14;
square_north_lambda = 14;
bus_lambda = 14;
square_south_lambda = 14;
train_lambda = 14;

simu_num = 60 * 12 * 200; %ģ����ʱ��

%%%������
coach = poissrnd(coach_lambda, 1, simu_num);
square_north = poissrnd(square_north_lambda, 1, simu_num);
bus = poissrnd(bus_lambda, 1, simu_num);
square_south = poissrnd(square_south_lambda, 1, simu_num);
train = poissrnd(train_lambda, 1, simu_num);
sum_passenger = sum(coach + square_north + bus + square_south + train); %�ܳ˿���
ser_time = exprnd(1/14, 1, sum_passenger); %ÿλ�˿ͷ���ʱ��

%%%%�ŶӼ�¼����
finish_people = 0; 
finish_time = [1, 1, 1, 1, 1]; %ÿ̨���������ʱ��
check_line = zeros(simu_num ,1); %ÿ��λʱ�䵽������
wait_line = zeros(simu_num + 1 ,1);
for i = 1:simu_num
    check_line(i ,1) = sum(coach(1, i) + square_north(1, i) + bus(1, i) + square_south(1, i) + train(1, i));
end
passenger = zeros(sum_passenger, 2); %ÿλ�˿����� ��һ��Ϊ����ʱ�䣬�ڶ���Ϊ��������ʱ��

for i = 1:simu_num
    for h = 1:5
        if finish_time(1, h) < i
            finish_time(1, h) = i;
        end
    end
    wait_line(i, 1) = wait_line(i, 1) + check_line(i ,1);
    for j = 1:check_line(i ,1)
        finish_people = finish_people + 1;
        passenger(finish_people, 1) = i; %��¼����ʱ��
        [passenger, finish_time, wait_line] = check_cost(finish_time, finish_people, ser_time, passenger, i, wait_line);
    end
end

ws_all = 0;
%%%%����ƽ���ȴ�ʱ��
for i = 1:finish_people
    ws_per = passenger(i, 2) - passenger(i, 1);
    ws_all = ws_all + ws_per;
end
w_s = ws_all / finish_people;

%%%%����ƽ���ӳ�
ls = mean(wait_line);