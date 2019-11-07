NODE_ID = 1
PORT = $(shell expr $(NODE_ID) + 5000)

RAITO_LINE = 15
RAITO = 4

THREAD_NUM = 5
EVENT_NUM = 20

RMI_IP = $(shell ipconfig getifaddr en0)
TRACE_OUTPUT = DCatch-DAG/input

CP = ./MapReduceTracer/output/Benchmark.jar

config:
	@echo PORT:$(PORT) THREAD:$(THREAD_NUM) EVENT:$(EVENT_NUM)

setup: rmi-on compile-bench trace-bench

rmi-on:
	make -C MapReduceTracer rmi-on

compile-bench:
	make -C Benchmark create-jar	

trace-bench:
	make -C MapReduceTracer trace-bench

run-bench:
	java -classpath $(CP) benchmark.Master $(PORT) $(THREAD_NUM) $(EVENT_NUM) $(RMI_IP)\
		> $(TRACE_OUTPUT)/$(NODE_ID).log

dcatch:
	make -C DCatch-DAG convert-log
	make -C DCatch-DAG run
	
rmi-off:
	make -C MapReduceTrace rmi-off


view-graph:
	make -C DCatch-DAG view-graph

view-thread:
	make -C DCatch-DAG view-thread
