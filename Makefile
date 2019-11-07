NODE_ID = 1

RAITO_LINE = 15
RAITO = 4

THREAD_NUM = 5
EVENT_NUM = 20

RMI_IP = $(shell ipconfig getifaddr en0)
TRACE_OUTPUT = DCatch-DAG/input

CP = ./Benchmark.jar


compile-bench:
	make -C Benchmark create-jar	

trace-bench:
	make -C MapReduceTracer trace-bench

run-bench:
	java -classpath $(CP) benchmark.Master $(NODE_ID) $(THREAD_NUM) $(EVENT_NUM) $(RMI_IP)\
		> $(TRACE_OUTPUT)/$(NODE_ID).log
	
rmi-on:
	-pkill rmiregistry
	rmiregistry &
