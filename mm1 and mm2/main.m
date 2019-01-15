%%%%ͳ������
coach_lambda = 14;
square_north_lambda = 14;
bus_lambda = 14;
square_south_lambda = 14;
train_lambda = 14;
simu_num = 60 * 12 * 2; %ģ����ʱ��

%%%������
coach = poissrnd(coach_lambda, 1, simu_num);
square_north = poissrnd(square_north_lambda, 1, simu_num);
bus = poissrnd(bus_lambda, 1, simu_num);
square_south = poissrnd(square_south_lambda, 1, simu_num);
train = poissrnd(train_lambda, 1, simu_num);
sum_passenger = sum(coach + square_north + bus + square_south + train); %�ܳ˿���
ser_time = exprnd(1/14, 1, sum_passenger); %ÿλ�˿ͷ���ʱ��

%%%%�ŶӼ�¼����

%mm1
finish_people1 = 0; 
service1 = 0; %ռ�����
finish_time1 = 1; %ÿ̨���������ʱ��
check_line1 = zeros(simu_num ,1); %ÿ��λʱ�䵽������
wait_line1 = zeros(simu_num + 1 ,1);
for i = 1:simu_num
    check_line1(i ,1) = 0.3 * sum(coach(1, i) + square_north(1, i) + bus(1, i) + square_south(1, i) + train(1, i));
end
passenger1 = zeros(sum_passenger, 2); %ÿλ�˿����� ��һ��Ϊ����ʱ�䣬�ڶ���Ϊ��������ʱ��

%mm2
finish_people2 = 0; 
finish_time2 = [1, 1]; %ÿ̨���������ʱ��
check_line2 = zeros(simu_num ,1); %ÿ��λʱ�䵽������
wait_line2 = zeros(simu_num + 1 ,1);
for i = 1:simu_num
    check_line2(i ,1) = 0.6 * sum(coach(1, i) + square_north(1, i) + bus(1, i) + square_south(1, i) + train(1, i));
end
passenger2 = zeros(sum_passenger, 2); %ÿλ�˿����� ��һ��Ϊ����ʱ�䣬�ڶ���Ϊ��������ʱ��


for i = 1:simu_num
    %mm1
    if finish_time1 < i
        finish_time1 = i;
    end
    wait_line1(i, 1) = wait_line1(i, 1) + check_line1(i ,1);
    for j = 1:check_line1(i ,1)
        finish_people1 = finish_people1 + 1;
        passenger1(finish_people1, 1) = i; %��¼����ʱ��
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
        passenger2(finish_people2, 1) = i; %��¼����ʱ��
        [passenger2, finish_time2, wait_line2] = mm2check_cost(finish_time2, finish_people2, ser_time, passenger2, i, wait_line2);
    end
    
end

ws_all1 = 0;
%%%%����ƽ���ȴ�ʱ��
for i = 1:finish_people1
    ws_per1 = passenger1(i, 2) - passenger1(i, 1);
    ws_all1 = ws_all1 + ws_per1;
end
w_s1 = ws_all1 / finish_people1;

%%%%����ƽ���ӳ�
ls1 = mean(wait_line1);

ws_all2 = 0;
%%%%����ƽ���ȴ�ʱ��
for i = 1:finish_people2
    ws_per2 = passenger2(i, 2) - passenger2(i, 1);
    ws_all2 = ws_all2 + ws_per2;
end
w_s2 = ws_all2 / finish_people2;

%%%%����ƽ���ӳ�
ls2 = mean(wait_line2);