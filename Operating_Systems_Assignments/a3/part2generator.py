import matplotlib.pyplot as pyplot
import subprocess

qlengths=[50,100,250,500]
dcosts=[0,5,10,15,20,25]

data={}

sim_in=subprocess.run(["./simgen", "1000", "912353"], stdout=subprocess.PIPE, universal_newlines=True)

for i in qlengths:
    for j in dcosts:
        print("The qlength is ", i, "and the dcost is", j)
        sim_out=subprocess.run(["./rrsim", "--quantum", str(i), "--dispatch", str(j)], input=sim_in.stdout, stdout=subprocess.PIPE, universal_newlines=True)
        listoflines=sim_out.stdout.split('\n')
        output=[]
        for line in listoflines:
            if "EXIT" in line:
                output.append(line)
        numtasks=float(len(output))
        waits=[]
        turnarounds=[]
        for line in output:
            temp = line.split()
            for string in temp:
                if "w=" in string:
                    waits.append(float(string[2:]))
                if "ta" in string:
                    turnarounds.append(float(string[3:]))
        totalwait=0.00
        totalturnaround=0.00
        for x in waits:
            totalwait=totalwait+x
        for y in turnarounds:
            totalturnaround=totalturnaround+y
        avgwait=totalwait/numtasks
        avgturnaround=totalturnaround/numtasks
        data[(i,j)]=(avgwait,avgturnaround)

parseddatawait={}
for pair in data:
    parseddatawait[pair[0]]=[]
    for i in data:
        if pair[0]==i[0]:
            parseddatawait[pair[0]].append(data[i][0])

for entry in parseddatawait:
    pyplot.plot(dcosts,parseddatawait[entry],label="q"+str(entry))
    pyplot.xlabel("Dispatch Cost")
    pyplot.ylabel("Average Waiting Time")
    pyplot.legend()
pyplot.savefig("graph_waiting.pdf")

parseddataturnaround={}
for pair in data:
    parseddataturnaround[pair[0]]=[]
    for i in data:
        if pair[0]==i[0]:
            parseddataturnaround[pair[0]].append(data[i][1])

for entry in parseddataturnaround:
    pyplot.plot(dcosts,parseddataturnaround[entry],label="q"+str(entry))
    pyplot.xlabel("Dispatch Cost")
    pyplot.ylabel("Average Turnaround Time")
    pyplot.legend()
pyplot.savefig("graph_turnaround.pdf")