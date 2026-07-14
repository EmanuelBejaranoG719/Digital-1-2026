TARGET = multiplier
TOP = multiplier

OBJS= multiplier.v
OBJS+= control_unit.v
OBJS+= shift_register.v
OBJS+= accumulator.v

PER_OBJS = perip_mult_test.v $(OBJS)

BUILD_DIR = build

all: sim

sim: 
    rm -f a.out *.vcd
    iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 $tb_(TARGET).v $(OBJS)
    vvp a.out
    gtkwave multiplier.vcd

sim_per:
    rm -f a.out *.vcd
    iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 perip_$(TARGET)_tb.v $(PER_OBJS)
    vvp a.out
    gtkwave perip_mult.vcd

svg: $(OBJS)
    yosys -p "prep -top ${TOP}; write_json ${TARGET}.json" ${OBJS}
    netlistsvg ${TARGET}.json -o ${TARGET}.svg 
    yosys -p "prep -top ${TARGET} -flatten; write_json ${TARGET]_flat.json" ${OBJS}
    netlistsvg ${TARGET}_flat.json -o ${TARGET}_flat.svg


clean: rm -rf *.out *.vcd *.svg *.json
    
