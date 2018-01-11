"""
Simulation Task - Sub Task 1
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
        self.total_devices = deviceCount
        self.inter_arrival_time = interArrival
        self.retransmit_time = retransmit
        self.service_time = service
        self.request_time = self.MC
        self.buffer = bufferSize
        self.queue = 0
        self.printingList = []
        

    def retransmitRequest(self, req):
        self.CLR.append(req)
        self.CLR.sort()

    def runSimulation(self):
        self.CLA = self.first_arrival
        printCLR = [str(i) for i in self.CLR]
        self.printingList.append([self.MC, self.CLA, self.CLS, self.queue, '()'])
        print(self.MC, self.CLA, self.CLS, self.queue, ",".join(printCLR))
        if self.MC < self.first_arrival:
                self.MC = self.CLA
                self.CLA += self.inter_arrival_time
                self.CLS = self.MC + self.service_time
                self.queue += 1
                printCLR = [str(i) for i in self.CLR]
                self.printingList.append([self.MC, self.CLA, self.CLS, self.queue, '(' + " ".join(printCLR) + ')'])
                print(self.MC, self.CLA, self.CLS, self.queue, ",".join(printCLR))

        while self.MC <= self.total_devices:
            if len(self.CLR) == 0:
                self.MC = min(self.CLA, self.CLS)
            elif len(self.CLR) > 0:
                self.MC = min(self.CLA, self.CLS, self.CLR[0])

            if len(self.CLR) > 0:
                if self.MC == self.CLR[0]:
                        if self.queue >= self.buffer:
                            updatedCLR = self.CLR.pop(0) + 5
                            self.CLR.append(updatedCLR)
                        else:
                            self.queue += 1
                            self.CLR.pop(0)
                elif self.MC == self.CLA:
                    if self.queue >= self.buffer:
                        updatedCLR = self.CLA + 5
                        self.CLR.append(updatedCLR)
                    else:
                        self.queue += 1 
                    self.CLA += self.inter_arrival_time
                elif self.MC == self.CLS:
                    self.queue -= 1
                    self.CLS += self.service_time
            else:
                if self.MC == self.CLA:
                    if self.queue >= self.buffer:
                        updatedCLR = self.CLA + 5
                        self.CLR.append(updatedCLR)
                    else:
                        self.queue += 1 
                    self.CLA += self.inter_arrival_time
                elif self.MC == self.CLS:
                    self.queue -= 1
                    self.CLS += self.service_time

            printCLR = [str(i) for i in self.CLR]
            self.printingList.append([self.MC, self.CLA, self.CLS, self.queue, '(' + " ".join(printCLR) + ')'])
            print(self.MC, self.CLA, self.CLS, self.queue, ",".join(printCLR))
    
    def saveInCSV(self, filename):
        with open(filename, 'w', newline='') as csvfile:
            spamwriter = csv.writer(csvfile, delimiter=',', quotechar='|', quoting=csv.QUOTE_NONE, escapechar='\\')
            for i in self.printingList:
                spamwriter.writerow(i)

def main():
    sim1 = TaskSimulation(2, 200, 6, 5, 10, 2)
    sim1.runSimulation()
    sim1.saveInCSV('Simulation1.csv')


if __name__ == "__main__":
    main()