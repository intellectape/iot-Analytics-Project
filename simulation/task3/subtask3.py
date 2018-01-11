"""
Simulation Task - Sub Task 2
"""
__author__ = "Aditya Bhardwaj"
__email__ = "abhardw2@ncsu.edu"

import random
import sys
from math import *
import csv
from enum import Enum
import operator


# Device Class
# To save and manage IoT devices arriving the Server
class Device:
    updateId = 1
    def __init__(self, time):
        self.id = Device.updateId
        self.arrivalTime = time
        self.serviceTime = None
        self.retransmitTime = None
        Device.updateId += 1

class SimulationServer:
    meanRetransmissionTime = None
    meanInterArrivalTime = None
    meanServiceTime = None
    bufferSize = None
    totalExecution = 0

    mean_T = []
    mean_D = []
    T_95 = []
    D_95 = []
    PList = []

    def __init__(self, meanInterArrivalTime, meanRetransmissionTime, serviceTime, bufferSize):
        SimulationServer.bufferSize = bufferSize
        SimulationServer.meanInterArrivalTime = meanInterArrivalTime
        SimulationServer.meanRetransmissionTime = meanRetransmissionTime
        SimulationServer.meanServiceTime = serviceTime
        self.T = []
        self.D = []
        self.P = None
        self.MC = 0
        self.CLA = self.generateNextClock(SimulationServer.meanInterArrivalTime)
        self.CLS = 0
        self.CLR = list()
        self.queue = list()
    
    # Generating the next random number and the exponential variate
    def generateNextClock(self, clockTime):
        randomValue = self.generateRandomNumber()
        returnValue = -1 * (clockTime * log(1 - randomValue))
        return returnValue

    def generateRandomNumber(self):
        return random.random()
        
    def sortRetransmitQueue(self):
        self.CLR.sort(key=operator.attrgetter('retransmitTime'))

    def runSimulation(self):
        firstArrival = self.CLA
        deviceList = list()
        if self.MC < firstArrival:
            self.MC = self.CLA
            d = Device(self.CLA)
            #deviceList.append(d)
            self.CLA += self.generateNextClock(SimulationServer.meanInterArrivalTime)
            self.CLS = self.MC + self.meanServiceTime
            self.queue.append(d)
        while len(deviceList) < 1000:
            
            if len(self.CLR) == 0:
                self.MC = min(self.CLA, self.CLS)
            elif len(self.CLR) >0:
                self.MC = min(self.CLA, self.CLS, self.CLR[0].retransmitTime)

            if len(self.CLR) >0:
                if self.MC == self.CLR[0].retransmitTime:
                    if len(self.queue) >= SimulationServer.bufferSize:
                        updatedDevice = self.CLR.pop(0)
                        updatedDevice.retransmitTime += self.generateNextClock(self.meanRetransmissionTime)
                        self.CLR.append(updatedDevice)
                        self.sortRetransmitQueue()
                    else: 
                        appendingDevice = self.CLR.pop(0)
                        self.queue.append(appendingDevice)
                elif self.MC == self.CLA:
                    d = Device(self.CLA)
                    if len(self.queue) >= SimulationServer.bufferSize:
                        d.retransmitTime = d.arrivalTime + self.generateNextClock(SimulationServer.meanRetransmissionTime)
                        self.CLR.append(d)
                        self.sortRetransmitQueue()
                    else:
                        self.queue.append(d)
                    self.CLA += self.generateNextClock(SimulationServer.meanInterArrivalTime)
                elif self.MC == self.CLS:
                    if len(self.queue) is not 0:
                        devAdd = self.queue.pop(0)
                        devAdd.serviceTime = self.CLS
                        deviceList.append(devAdd)
                    self.CLS += SimulationServer.meanServiceTime
            else:
                if self.MC == self.CLA:
                    d = Device(self.CLA)
                    if len(self.queue) >= SimulationServer.bufferSize:
                        d.retransmitTime = d.arrivalTime + self.generateNextClock(SimulationServer.meanRetransmissionTime)
                        self.CLR.append(d)
                        self.sortRetransmitQueue()
                    else:
                        d = Device(self.CLA)
                        self.queue.append(d)
                    self.CLA += self.generateNextClock(self.meanInterArrivalTime)
                elif self.MC == self.CLS:
                    if len(self.queue) is not 0:
                        devAdd = self.queue.pop(0)
                        devAdd.serviceTime = self.CLS
                        deviceList.append(devAdd)
                    self.CLS += SimulationServer.meanServiceTime

        for i in deviceList:
            if i.retransmitTime is not None:
                self.D.append(-(i.arrivalTime - i.retransmitTime))
            else:
                i.retransmitTime = 0
            self.T.append(i.serviceTime-i.arrivalTime)
            
        self.P = deviceList[-1].serviceTime

        SimulationServer.totalExecution += 1
        SimulationServer.mean_D.append(self.meanCalc(self.D))
        SimulationServer.mean_T.append(self.meanCalc(self.T))
        SimulationServer.PList.append(self.P)
        SimulationServer.D_95.append(SimulationServer.percentile(self.D, 0.95))
        SimulationServer.T_95.append(SimulationServer.percentile(self.T, 0.95))


    ### This section contains all the static methodss being used in the code:
    @staticmethod
    def clearData():
        SimulationServer.totalExecution = 0
        SimulationServer.mean_D = list()
        SimulationServer.mean_T = list()
        SimulationServer.T_95 = list()
        SimulationServer.D_95 = list()
        SimulationServer.PList = list()

    @staticmethod
    def percentile(listData, percent):
        listData.sort()
        n = int(round(percent * len(listData) + 0.5))
        if n <= 0:
            if len(listData) == 0:
                return 0
            else:
                return listData[0]
        return listData[n - 1]
    
    @staticmethod
    def meanCalc(listData):
        mean = float(sum(listData)) / float(len(listData)) if len(listData) is not 0 else 0
        return mean

    @staticmethod
    def numberFormating(numberValue):
        return round(numberValue,2)

    @staticmethod
    def findConfidence(inputList):
        if inputList is not None:
            mean = SimulationServer.meanCalc(inputList)
            summation = sum([(x_i - mean)**2 for x_i in inputList])
            std_deviation = sqrt(summation/len(inputList))
            std_error = std_deviation/(sqrt(float(len(inputList))))
            confidence = 1.96 * std_error
            return confidence
        else:
            return None

    @staticmethod
    def printIteration(i):
        curr_mean_D = SimulationServer.numberFormating(SimulationServer.mean_D[i])
        curr_mean_T = SimulationServer.numberFormating(SimulationServer.mean_T[i])
        curr_P = SimulationServer.numberFormating(SimulationServer.PList[i])
    
        percentile_D = SimulationServer.numberFormating(SimulationServer.D_95[i])
        percentile_T = SimulationServer.numberFormating(SimulationServer.T_95[i])

        print("%d \t %f \t %f \t    %f \t %f \t %f"%(i, curr_mean_T, percentile_T, curr_mean_D, percentile_D,  curr_P))

    @staticmethod
    def printIterationData():
        print("N \t Mean_T\t\t95th_Percentile_T\tMean_D\t95th_Percentile_D\tP")
        for i in range(50):
            SimulationServer.printIteration(i)

    @staticmethod
    def printSimulationData(printIterData):
        curr_mean_D = SimulationServer.numberFormating(SimulationServer.meanCalc(SimulationServer.mean_D))
        curr_mean_T = SimulationServer.numberFormating(SimulationServer.meanCalc(SimulationServer.mean_T))
        curr_mean_P = SimulationServer.numberFormating(SimulationServer.meanCalc(SimulationServer.PList))
        
        percentile_D = SimulationServer.numberFormating(SimulationServer.percentile(SimulationServer.mean_D, 0.95))
        conf_per_D_1 = SimulationServer.numberFormating(SimulationServer.findConfidence(SimulationServer.D_95))
        conf_per_D = [SimulationServer.numberFormating(conf_per_D_1 + percentile_D), SimulationServer.numberFormating(-conf_per_D_1 + percentile_D)]

        percentile_T = SimulationServer.numberFormating(SimulationServer.percentile(SimulationServer.mean_T, 0.95))
        conf_per_T_1 = SimulationServer.numberFormating(SimulationServer.findConfidence(SimulationServer.T_95))
        conf_per_T = [SimulationServer.numberFormating(conf_per_T_1 + percentile_T), SimulationServer.numberFormating(-conf_per_T_1 + percentile_T)]


        conf_D = SimulationServer.numberFormating(SimulationServer.findConfidence(SimulationServer.mean_D))
        conf_T = SimulationServer.numberFormating(SimulationServer.findConfidence(SimulationServer.mean_T))
        conf_P = SimulationServer.numberFormating(SimulationServer.findConfidence(SimulationServer.PList))

        conf_met_D = [SimulationServer.numberFormating(conf_D + curr_mean_D), SimulationServer.numberFormating(curr_mean_D - conf_D)]
        conf_met_T = [SimulationServer.numberFormating(conf_T + curr_mean_T), SimulationServer.numberFormating(curr_mean_T - conf_T)]
        conf_met_P = [SimulationServer.numberFormating(conf_P + curr_mean_P), SimulationServer.numberFormating(curr_mean_P - conf_P)]

        # To print Iteration Data for the Device being processed.
        if printIterData:
            SimulationServer.printIterationData()

        print(" ")
        print("============================================================================================================")
        print("\t Mean:\t\tConfidence(+)\tConfidence(-)||\t95th_Percentile:\tConfidence(+)\tConfidence(-)")
        print("============================================================================================================")
        print("D value: %f \t %f \t %f || \t %f \t %f \t %f"%(curr_mean_D, conf_met_D[0], conf_met_D[1], percentile_D, conf_per_D[0], conf_per_D[1] ))
        print("T value: %f \t %f \t %f || \t %f \t %f \t %f"%(curr_mean_T, conf_met_T[0], conf_met_T[1], percentile_T, conf_per_T[0], conf_per_T[1] ))
        print("P value: %f \t %f \t %f || \t %s \t %s \t %s"%(curr_mean_P, conf_met_P[0], conf_met_P[1], "  -   ", "  -   ", "  -   "  ))
        SimulationServer.clearData()
    


def main():
    if len(sys.argv) < 6:
        print("Please enter the input in following format: python subtask2.py <mean-interarrival-time> <service-time: yes/no/value> <mean-retransmit-time> <buffer-size: yes/no/value> <number-of-repetition>")
    else:
        meanInterArrivalTime = float(sys.argv[1])
        serviceTime = sys.argv[2]
        meanRetransmissionTime = float(sys.argv[3])
        bufferSize = sys.argv[4]
        repetitions = int(sys.argv[5])
        if serviceTime == 'yes':
            serviceTimeList = [int(x) for x in input("Please input the list data: [Format for number input: <1 2 3 4>] ").split()]
            iterData = True if input("Do you want to print the 50 iteration data for every Service Time? (yes/no) ") == "yes" else False
            bufferSize = float(bufferSize)
            for i in serviceTimeList:
                print("============================================================================================================")
                print("Simulation Data for Service Time:", i)
                print("============================================================================================================")
                for j in range(repetitions):
                    sim1 = SimulationServer(meanInterArrivalTime, meanRetransmissionTime, i, bufferSize)
                    sim1.runSimulation()
                SimulationServer.printSimulationData(iterData)
                print("============================================================================================================")
                print(" ")
        elif bufferSize == 'yes':
            bufferSizeList = [int(x) for x in input("Please input the list data: [Format for number input: <1 2 3 4>] ").split()]
            iterData = True if input("Do you want to print the 50 iteration data for every Service Time? (yes/no) ") == "yes" else False
            serviceTime = float(serviceTime)
            for i in bufferSizeList:
                print("============================================================================================================")
                print("Simulation Data for Buffer Size:", i)
                print("============================================================================================================")
                for j in range(repetitions):
                    sim1 = SimulationServer(meanInterArrivalTime, meanRetransmissionTime, serviceTime, i)
                    sim1.runSimulation()
                SimulationServer.printSimulationData(iterData)
                print("============================================================================================================")
                print(" ")
        else:
            print("Wrong input!")

# arg1: mean interarrival time
# arg2: service time
# arg3: mean retransmission time
# arg4: buffer space
# arg5: number of Repetitions

if __name__ == "__main__":
    main()