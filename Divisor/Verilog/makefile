TARGET = div
TOP = top_div

OBJS= top_div.v
OBJS+= Control_div.v
OBJS+= div_sh_reg.v
OBJS+= div_comp.v
OBJS+= acm_reg.v
OBJS+= reg_c.v

PER_OBJS = perip_div_test.v $(OBJS)

BUILD_DIR = build

all: sim

sim: 
    rm -f a.out *.vcd
    iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 $tb_(TARGET).v $(OBJS)
    vvp a.out
    gtkwave div.vcd

sim_per:
    rm -f a.out *.vcd
    iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 perip_$(TARGET)_tb.v $(PER_OBJS)
    vvp a.out
    gtkwave perip_div.vcd

svg: $(OBJS)
    yosys -p "prep -top ${TOP}; write_json ${TARGET}.json" ${OBJS}
    netlistsvg ${TARGET}.json -o ${TARGET}.svg 
    yosys -p "prep -top ${TARGET} -flatten; write_json ${TARGET]_flat.json" ${OBJS}
    netlistsvg ${TARGET}_flat.json -o ${TARGET}_flat.svg


clean: rm -rf *.out *.vcd *.svg *.json
    
