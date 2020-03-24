NODE_ID = 1
PORT = $(shell expr $(NODE_ID) + 5000)

RAITO_LINE = 15
RAITO = 4

THREAD_NUM = 5
EVENT_NUM = 20

RMI_IP = $(shell ipconfig getifaddr en0)
TRACE_OUTPUT = DCatch-DAG/input

CP = ./JarCollection/Benchmark.jar:./JarCollection/PocketRacerImpl.jar

config:
	@echo PORT:$(PORT) THREAD:$(THREAD_NUM) EVENT:$(EVENT_NUM)

dcatch-setup: rmi-on compile-bench trace-bench

pocket-setup: rmi-on compile-bench pocketracer

rmi-on:
	cd JarCollection && nohup rmiregistry &

compile-bench:
	make -C Benchmark create-jar

trace-bench:
	make -C MapReduceTracer trace-bench
	mv MapReduceTracer/output/Benchmark.jar JarCollection/

pocketracer:
	cp Benchmark/out/jar/Benchmark.jar PocketRacer/input/
	make -C PocketRacer create-jar
	mv PocketRacer/output/Benchmark.jar JarCollection/

run-bench:
	java -classpath $(CP) benchmark.Master $(PORT) $(THREAD_NUM) $(EVENT_NUM) $(RMI_IP)\
		> $(TRACE_OUTPUT)/$(NODE_ID).log

run-bench-dcatch: 
	make run-bench TRACE_OUTPUT=DCatch-DAG/input

run-bench-pocketracer:
	make run-bench TRACE_OUTPUT=PocketRacer/log


dcatch:
	make -C DCatch-DAG convert-log
	make -C DCatch-DAG run
	
rmi-off:
	-pkill rmiregistry

view-graph:
	make -C DCatch-DAG view-graph

view-thread:
	make -C DCatch-DAG view-thread
