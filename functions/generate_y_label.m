function position = generate_y_label()
%% Description
% This function calculates the position of the y-label of the ERP plot

%% Function Code
figure;
h1=subplot(5,2,1);
h2=subplot(5,2,9);
p1=get(h1,'position');
p2=get(h2,'position');
height=p1(2)+p1(4)-p2(2);
position = [p2(1)-0.02 p2(2) p2(3) height];
h3=axes('position',[p2(1)-0.02 p2(2) p2(3) height],'visible','off');
h_label=ylabel('test','visible','on');
close

end