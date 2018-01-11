=================================================================
Project 1: Simulation - Task: 3

Name: Aditya Bhardwaj
Unity ID: abhardw2

=================================================================

=================================================================
Output
=================================================================
Output for Task 1 containing Final Values: task1.txt
Output for Task 1 containing all iterations values: task1_full.txt

Output for Task 2 containing Final Values: task2.txt
Output for Task 2 containing all iterations values: task2_full.txt
=================================================================

=================================================================
Results Explanation:
=================================================================
I have included "conclusion_task3.pdf" file containing all the results data and explanation of graphs.
The file includes the Table, Graphs and explanation related to the graphs and simulation.
=================================================================

=================================================================
Graphs :
=================================================================
I have included 5 graphs each for Task 1 and Task 2 :
=================================================================
Task 1:
=================================================================
task1_mean_T.png - Graph for 'Grand Mean of T' vs 'Service Time'
task1_mean_D.png - Graph for 'Grand Mean of T' vs 'Service Time'
task1_percentile_T.png - Graph for 'Mean of 95th percentile of T' vs 'Service Time'
task1_percentile_D.png - Graph for 'Mean of 95th percentile of D' vs 'Service Time'
task1_mean_P.png - Graph for 'Mean P' vs 'Service Time'
=================================================================

=================================================================
Task 2:
=================================================================
task2_mean_T.png - Graph for 'Grand Mean of T' vs 'Buffer Size'
task2_mean_D.png - Graph for 'Grand Mean of D' vs 'Buffer Size'
task2_percentile_T.png - Graph for 'Mean of 95th percentile of T' vs 'Buffer Size'
task2_percentile_D.png - Graph for 'Mean of 95th percentile of D' vs 'Buffer Size'
task2_mean_P.png - Graph for 'Mean P' vs 'Buffer Size'
=================================================================

=================================================================
::Instructions to Run::
=================================================================

=================================================================
Command: 
=================================================================
python subtask3.py <mean-interarrival-time> <service-time: yes/value> <mean-retransmit-time> <buffer-size: yes/value> <number-of-repetition>
=================================================================

=================================================================
Task 1 :
=================================================================
Vary S from 11,12,13,14,15,16,17

 1. python subtask3.py <mean-interarrival-time> <yes> <mean-retransmit-time> <buffer-size: value> <number-of-repetition>

eg: python subtask3.py 17.98 yes 10 5 50

 2. Enter Service time list.
    Please input the list data: [Format for number input: <1 2 3 4> (Space separated values)] eg.'11 12 13 14 15 16 17'

 3. Enter whether to print 50 iteration data of the list or not.
    Do you want to print the 50 iteration data? (yes/no) eg.'no'

=================================================================

=================================================================
Task 2 :
=================================================================

Vary B for S = 16 [I have used Buffer Size range: 2, 4, 6, 8, 10, 12]

  1. python subtask3.py <mean-interarrival-time> <value> <mean-retransmit-time> <buffer-size: yes> <number-of-repetition>

eg: python subtask3.py 17.98 16 10 yes 50

 2. Enter Service time list.
    Please input the list data: [Format for number input: <1 2 3 4> (Space separated values)] eg.'2 4 6 8 10 12'

 3. Enter whether to print 50 iteration data of the list or not.
    Do you want to print the 50 iteration data? (yes/no) eg. 'no'
=================================================================


