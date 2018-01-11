"""
Simulation Task - Sub Task 2
"""
__author__ = "Aditya Bhardwaj"
__email__ = "abhardw2@ncsu.edu"

import random
import sys
from math import *
import csv

class TaskSimulation:
    def __init__(self, firstArrival, deviceCount, interArrival, retransmit, service, bufferSize):
        self.MC = 0
        self.CLA = self.MC # Setting arrival time to the Master Clock
        self.first_arrival = firstArrival
        self.CLS = 0 # Setting Service time to 0
        self.CLR = list() # Creating list for the Retransmission time
        self.mean_retransmit = retransmit
        self.total_devices = deviceCount
        self.inter_arrival_time = interArrival
        self.service_time = service
        self.buffer = bufferSize
        self.queue = 0
        self.printingList = []
    
    def generateNextClock(self, clockTime):
        randomValue = self.generateRandomNumber()
        returnValue = -1 * (clockTime * log(1 - randomValue))
        return returnValue

    def generateRandomNumber(self):
        return random.random()

    def retransmitRequest(self, req):
        self.CLR.append(req)
        self.CLR.sort()

    def runSimulation(self):
        self.CLA = self.first_arrival
        printCLR = [str(round(i, 2)) for i in self.CLR]
        self.printingList.append([self.MC, self.CLA, self.CLS, self.queue, '()'])
        print(self.MC, self.CLA, self.CLS, self.queue, ",".join(printCLR))
        if self.MC < self.first_arrival:
                self.MC = self.CLA
                self.CLA += self.generateNextClock(self.inter_arrival_time)
                self.CLS = self.MC + self.service_time
                self.queue += 1
                printList = [str(round(i, 2)) for i in self.CLR]
                self.printingList.append([self.MC, self.CLA, self.CLS, self.queue, '(' + " ".join(printCLR) + ')'])
                print(self.MC, self.CLA, self.CLS, self.queue, printList)

        while self.MC <= self.total_devices:
            if len(self.CLR) == 0:
                self.MC = min(self.CLA, self.CLS)
            elif len(self.CLR) > 0:
                self.MC = min(self.CLA, self.CLS, self.CLR[0])

            if len(self.CLR) > 0:
                if self.MC == self.CLR[0]:
                        if self.queue >= self.buffer:
                            updatedCLR = self.CLR.pop(0) + self.generateNextClock(self.mean_retransmit)
                            self.CLR.append(updatedCLR)
                            self.CLR.sort()
                        else:
                            self.queue += 1
                            self.CLR.pop(0)
                elif self.MC == self.CLA:
                    if self.queue >= self.buffer:
                        updatedCLR = self.CLA + self.generateNextClock(self.mean_retransmit)
                        self.CLR.append(updatedCLR)
                        self.CLR.sort()
                    else:
                        self.queue += 1 
                    self.CLA += self.generateNextClock(self.inter_arrival_time)
                elif self.MC == self.CLS:
                    self.queue -= 1
                    self.CLS += self.service_time
            else:
                if self.MC == self.CLA:
                    if self.queue >= self.buffer:
                        updatedCLR = self.CLA + self.generateNextClock(self.mean_retransmit)
                        self.CLR.append(updatedCLR)
                        self.CLR.sort()
                    else:
                        self.queue += 1 
                    self.CLA += self.generateNextClock(self.inter_arrival_time)
                elif self.MC == self.CLS:
                    self.queue -= 1
                    self.CLS += self.service_time

            printCLR = [str(round(i, 2)) for i in self.CLR]
            self.printingList.append([self.MC, self.CLA, self.CLS, self.queue, '(' + " ".join(printCLR) + ')'])
            print(round(self.MC, 2), round(self.CLA, 2), round(self.CLS, 2), self.queue, " ".join(printCLR))
        
        for i in self.printingList:
            print(i)

    def saveInCSV(self, filename):
        with open(filename, 'w', newline='') as csvfile:
            spamwriter = csv.writer(csvfile, delimiter=',', quotechar='|', quoting=csv.QUOTE_NONE, escapechar='\\')
            for i in self.printingList:
                spamwriter.writerow(i)

def main():
    if len(sys.argv) < 7:
        print("Please enter the input in following format: python subtask2.py <first-arrival> <clock-count> <inter-arrival> <re-transmit> <service-time> <buffer>")
    else:
        firstArrival = float(sys.argv[1])
        clockCount = float(sys.argv[2])
        interArrival = float(sys.argv[3])
        retransmit = float(sys.argv[4])
        service = float(sys.argv[5])
        buffer = float(sys.argv[6])
        #sim1 = TaskSimulation(2, 200, 6, 5, 10, 2)
        sim1 = TaskSimulation(firstArrival, clockCount, interArrival, retransmit, service, buffer)
        sim1.runSimulation()
        sim1.saveInCSV('Simulation3.csv')


# arg1: first arrival time
# arg2: final clock count
# arg3: interarrival time
# arg4: retransmission time
# arg5: service time
# arg6: buffer space

if __name__ == "__main__":
    main()