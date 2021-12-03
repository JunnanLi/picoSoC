# picoSoC项目
picoSoC整体架构如下图所示，处理器采用简化版的[picorv32i](https://github.com/YosysHQ/picorv32)（已裁减压缩指令处理逻辑）。同时，picoSoC并集成有一个以太网端口，用于配置指令与数据，以及显示打印信息。

<img src="https://github.com/JunnanLi/picoSoC/blob/main/docs/picoSoC.jpg" width="500">

## 目录
  * [picoSoC简介](#picoSoC项目)
  * [picoSoC硬件部分](#picoSoC硬件部分)
     * [硬件模块组成](#硬件模块组成)
     * [硬件模块连接关系](#硬件模块连接关系)
  * [picoSoC软件部分](#picoSoC软件部分)
  * [FPGA验证](#FPGA验证)
     * [生成CPU可运行的二进制文件](#生成CPU可运行的二进制文件)
     * [生成FPGA可运行的比特流文件](#生成FPGA可运行的比特流文件)
     * [与CPU交互](#与CPU交互)
     * [验证结果](#验证结果)
 

## picoSoC硬件部分
### 硬件模块组成
硬件文件夹包含12个文件，功能如下表所示

| 文件名                 | 包含的模块    | 功能描述 |
|:---------------------:|:-----------:|---------|
| picorv32_simplified.v |  picorv32i_core | 32位整数处理器（[picorv32i](https://github.com/YosysHQ/picorv32)） |
| Pico_top.v            |  pico_top   |CPU核顶层文件，连接CPU核和存储器 |
| memory.v              |  memory     |指令／数据存储器 |
| conf_mem.v            |  conf_mem   |配置模块，通过报文配置存储器，其中以太网协议字段为0x9001-0x9004，以及输出程序中的"printf"内容，以太网协议字段为0x9005 |
| um_for_cpu.v          |  um_for_cpu |项目为CPU建立的顶层文件，包含CPU核顶层和配置CPU的模块，即Pico_top.v和conf_mem.v |
| picoSoC_top.v         |  picoSoC_top|项目顶层模块，连接gmii输入／输出，UM模块 |
| asyn_recv_packet.v    |  asyn_recv_packet |rgmii收发（异步时钟域） |
| gmii_crc_check.v      |  gmii_crc_check|crc校验，并去除crc字段 |
| gmii_crc_cal.v        |  gmii_crc_cal|计算并添加crc字段 |
| gmii_to_134b_pkt.v    |  gmii_to_134b_pkt         |由8b数据组装成134b数据，高2b表示头尾（其中2'b01表示头，2'b10表示尾），中间4b表示16B数据有效数量，例如16B都有效则为4'hf，最后128b为数据 |
| pkt_134b_to_gmii.v   |  pkt_134b_to_gmii   |由134b数据拆分成16个8b数据 |
| util_gmii_to_rgmii.v |  util_gmii_to_rgmii|rgmii<->gmii转换 |

### 硬件模块连接关系
模块间的连接关系如下图所示。picoSoC硬件部分（UM.v）可以分成上下两层，上层为um_for_cpu，实现CPU相关功能，包括配置指令和数据、指令与数据存储单元、CPU核运行单元；下层报文收发，包含rgmii异步时钟域收发、rgmii<->gmii转换、CRC校验／计算、拼接／拆分数据模块。另外，基于RAM实现的指令／数据存储器其具有两个访问端口，一个供CPU使用，另一个用于配置。

<img src=https://github.com/JunnanLi/picoSoC/blob/main/docs/picoSoC_arc_new.jpg width="600">

## picoSoC软件部分
picoSoC软件部分请参考[iCore中的相关设计](https://github.com/JunnanLi/iCore)。

## FPGA验证
本项目已在Xilinx FPGA(zynq7020)上验证。

### 生成CPU可运行的二进制文件
请参考[iCore中的相关操作](https://github.com/JunnanLi/iCore)。

### 生成FPGA可运行的比特流文件
1) 首先，我们使用Vivado创建新工程，并加载其他的12个硬件模块文件，即`picorv32_simplified.v`，`Pico_top.v`，`memory.v`，`conf_mem.v`，`um_for_cpu.v`，`picoSoC_top.v`，`asyn_recv_packet.v`，`gmii_crc_check.v`，`gmii_crc_cal.v`，`gmii_to_134b_pkt.v`，`pkt_134b_to_gmii.v`，`util_gmii_to_rgmii.v`；
2) 其次，我们为该项目生成6个IP核，分别是clk_wiz_0（输入50MHz，输出125MHz），asfifo_8_1024（异步fifo），fifo_8b_512（同步fifo），fifo_64b_512（同步fifo），fifo_134b_512（同步fifo），ram_8_16384（双端口RAM）；
3) 第三，参考引脚约束文件[picoSoC.xdc](https://github.com/JunnanLi/iCore/blob/master/mcs%26hex/firmware.hex)分配引脚；
4）最后，运行`Generate Bitstream`，生成FPGA可运行的比特流文件，即picoSoC.bit；

### 与CPU交互
请参考iCore中software/controller文件夹中[README](https://github.com/JunnanLi/iCore/blob/master/software/Controller/README.md)实现与CPU的交互。

### 验证结果
1) 首先，代开`Hardware Manager`，并将比特流文件烧入FPGA中；
2) 使用根据iCore项目中software/controller文件夹中[README](https://github.com/JunnanLi/iCore/blob/master/software/Controller/README.md)配置CPU指令、数据内容，并开启运行.

## 更多

### 资源开销
| Module             | Slice LUTs | Slice Registers | Block Memory Tile |
|:------------------ | ----------:| ---------------:| -----------------:|
| conf_mem           |        258 |             149 |               1.5 |
| memory             |        128 |              47 |                16 |
| picorv32           |       1284 |             393 |                 0 |





