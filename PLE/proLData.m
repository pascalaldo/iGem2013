clear data texp ydata;

data = [
0 1.0538
2.0000 1.0021
4.0000 0.4457
6.0000 0.6357
8.0000 0.4818
10.0000 0.2378
12.0000 0.2579
14.0000 0.2813
16.0000 0.5600
18.0000 0.4425
20.0000 0.0006
22.0000 0.4143
24.0000 0.1634
26.0000 0.0681
28.0000 0.1324
30.0000 0.0294
32.0000 0.0284
34.0000 0.1824
36.0000 0.1683
38.0000 0.1641
40.0000 0.0855
42.0000 -0.1058
44.0000 0.0840
46.0000 0.1731
48.0000 0.0571
50.0000 0.1102];

texp = data(:,1);
ydata = data(:,2);

clear data