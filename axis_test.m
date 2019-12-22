% Script for testing the centeraxes.m function

clear
clf
clc
%subplot(211)
plot(-8:8, sqrt(5:21));

xlabel('t');
ylabel('y(t)')

set(gca,'ylim',[-4 5],'xlim',[-8 8],'xtick',-8:8,'ytick',-4:5)
opt.fontname = 'helvetica';
opt.fontsize = 8;

centeraxes(gca,opt);
