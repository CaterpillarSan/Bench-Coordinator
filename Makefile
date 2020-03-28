NODE_ID = 1
PORT = $(shell expr $(NODE_ID) + 50000)

RAITO_LINE = 15
RAITO = 4

THREAD_NUM = 5
EVENT_NUM = 20

RMI_IP = $(shell ipconfig getifaddr en0)
TRACE_OUTPUT = DCatch-DAG/input

TARGET = Benchmark.jar
MR = hadoop-core-2.0.0-mr1-cdh4.0.0.jar

CP = ./JarCollection/$(TARGET):./JarCollection/PocketRacerImpl.jar

SSH_TARGET = M0

config:
	@echo PORT:$(PORT) THREAD:$(THREAD_NUM) EVENT:$(EVENT_NUM)

dcatch-setup: rmi-off rmi-on compile-bench trace-bench

pocket-setup: rmi-off rmi-on compile-bench pocketracer

dcatch-mapreduce: trace-mapreduce send-remote

pocket-mapreduce: 
	make -C PocketRacer impl-mr
	make send-remote


rmi-on:
	cd JarCollection && nohup rmiregistry &

compile-bench:
	make -C Benchmark create-jar

trace-bench:
	make -C MapReduceTracer trace-bench
	mv MapReduceTracer/output/$(TARGET) JarCollection/

trace-mapreduce:
	make -C MapReduceTracer trace-mr
	mv MapReduceTracer/output/$(MR) JarCollection/

pocket-bench:
	cp Benchmark/out/jar/$(TARGET) PocketRacer/input/
	make -C PocketRacer impl-bench
	mv PocketRacer/output/$(TARGET) JarCollection/

run-bench:
	cd JarCollection && jar xf $(TARGET) 
	java -classpath $(CP) benchmark.Master $(PORT) $(THREAD_NUM) $(EVENT_NUM) $(RMI_IP)\
		> $(TRACE_OUTPUT)/$(NODE_ID).log

run-bench-dcatch: 
	make run-bench TRACE_OUTPUT=DCatch-DAG/input

run-bench-pocketracer:
	make run-bench TRACE_OUTPUT=PocketRacer/log


dcatch:
	make -C DCatch-DAG convert-log
	make -C DCatch-DAG run

send-remote:
	mv JarCollection/$(MR) sendfiles
	rsync -av -e ssh sendfiles $(SSH_TARGET):.
	
rmi-off:
	-pkill rmiregistry

view-graph:
	make -C DCatch-DAG view-graph

view-thread:
	make -C DCatch-DAG view-thread
