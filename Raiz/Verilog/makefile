TARGET = sqrt
TOP = top_sqrt

OBJS+= top_sqrt.v
OBJS+= fsm_sqrt.v
OBJS+= cont.v
OBJS+= reg_n.v
OBJS+= reg_out.v
OBJS+= reg_rad.v
OBJS+= reg_rem.v
OBJS+= sub.v
OBJS+= trial.v

PER_OBJS = perip_sqrt_test.v $(OBJS)

BUILD_DIR = build

all: sim

sim: 
	rm -f a.out *.vcd
	iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 tb_$(TARGET).v $(OBJS)
	vvp a.out
	gtkwave tb_sqrt.vcd

sim_per:
	rm -f a.out *.vcd
	iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 perip_$(TARGET)_tb.v $(PER_OBJS)
	vvp a.out
	gtkwave perip_sqrt.vcd

svg: $(OBJS)
	yosys -p "prep -top ${TOP}; write_json ${TARGET}.json" ${OBJS}
	netlistsvg ${TARGET}.json -o ${TARGET}.svg 
	yosys -p "prep -top ${TOP} -flatten; write_json ${TARGET}_flat.json" ${OBJS}
	netlistsvg ${TARGET}_flat.json -o ${TARGET}_flat.svg


clean: 
	rm -rf *.out *.vcd *.svg *.json
	
