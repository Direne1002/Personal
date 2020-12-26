LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY TOP_LEVEL_MIPS IS
	PORT(
		clk			:	IN STD_LOGIC;
		ALU_result	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		PCoutTest	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		PCinTest	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		SignImmTest : 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		instrTest 	: 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		srcATest 	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		lwTest		:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		swTest		:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		BrTest		:	OUT STD_LOGIC;
		JTest		:	OUT STD_LOGIC
		);
	END;
	
ARCHITECTURE structure OF TOP_LEVEL_MIPS IS

	COMPONENT multiplexer5
		PORT(	S 	: IN STD_LOGIC;
				W0 	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
				W1 	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
				F 	: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT multiplexer8
		PORT(	S 	: IN STD_LOGIC;
				W0 	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				W1 	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				F 	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT multiplexer32
		PORT(	S 	: IN STD_LOGIC;
				W0 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				W1 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				F 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT register32
		PORT(	Clock	: IN STD_LOGIC;
				DIN		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				DOUT	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT inst_mem
		PORT(	address : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
				clock   : IN STD_LOGIC;
				q    	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT reg_file
		PORT(	clk, WE3 	: IN STD_LOGIC;
				A1, A2, A3	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
				WD3  		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				RD1, RD2 	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT ALU
		PORT(	ALUin1, ALUin2 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				ALUCtrl 		: IN STD_LOGIC;
				ALUOut 			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT sign_ext
		PORT(	inst_immed 	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				sign_extend : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT data_mem
		PORT(	address  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				memwrite, memread, clock : IN STD_LOGIC;
				read_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				write_data  : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT shifter28
		PORT(	DIN	: IN STD_LOGIC_VECTOR (25 DOWNTO 0);
				DOUT: OUT STD_LOGIC_VECTOR (27 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT shifter32
		PORT(	DIN	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				DOUT: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT komparator32
		PORT(	A, B: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				C	: OUT STD_LOGIC
			);
	END COMPONENT;
	
	COMPONENT busmerging
		PORT(	D0	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
				D1	: IN STD_LOGIC_VECTOR (27 DOWNTO 0);
				DOUT: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT adder32
		PORT(	CIN 	: IN STD_LOGIC;
				X, Y 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0) ;
				S 		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
				COUT	: OUT STD_LOGIC
			);
	END COMPONENT;
	
	COMPONENT Controller
		PORT(	op, funct	: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
				Bne			: OUT STD_LOGIC;
				Branch		: OUT STD_LOGIC;
				MemtoReg	: OUT STD_LOGIC;
				MemWrite	: OUT STD_LOGIC;
				RegDest		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				RegWrite	: OUT STD_LOGIC;
				Jump		: OUT STD_LOGIC;
				ALUSrc		: OUT STD_LOGIC;
				ALUControl	: OUT STD_LOGIC
			);
	END COMPONENT;
	
SIGNAL toPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL toinstmem : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL PC_PLUS_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL muxout : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL instr : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL regwrite : STD_LOGIC;
SIGNAL address_reg : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL datatowrite : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL datatowrite2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL readdata1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL readdata2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL SignImm : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL srcB : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ALUsrc : STD_LOGIC;
SIGNAL ALUControl : STD_LOGIC;
SIGNAL ALUresult : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL readmem : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL MemtoReg : STD_LOGIC;
SIGNAL memwrite: STD_LOGIC;
SIGNAL outshift2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL tomux1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL BranchResult : STD_LOGIC;
SIGNAL outBusMer : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Jump : STD_LOGIC;
SIGNAL outshift1 : STD_LOGIC_VECTOR(27 DOWNTO 0);
SIGNAL outeq : STD_LOGIC;
SIGNAL RegDest : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL bnesig : STD_LOGIC;
SIGNAL brsig: STD_LOGIC;

BEGIN
	BranchResult <= (bnesig AND NOT brsig AND NOT outeq) OR (NOT bnesig AND brsig AND outeq);
	datatowrite2 <= "000000000000000000000000" & datatowrite;
	mux32_1 : multiplexer32
	PORT MAP(
		S => BranchResult,
		W0 => PC_PLUS_4,
		W1 => tomux1,
		F => muxout
	);
	mux32_2 : multiplexer32
	PORT MAP(
		S => Jump,
		W0 => muxout,
		W1 => outBusMer,
		F => toPC
	);
	mux32_3 : multiplexer32
	PORT MAP(
		S => ALUsrc,
		W0 => readdata2,
		W1 => SignImm,
		F => srcB
	);
	mux8 : multiplexer8
	PORT MAP(
		S => MemtoReg,
		W0 => ALUresult(7 DOWNTO 0),
		W1 => readmem,
		F => datatowrite
	);
	mux5 : multiplexer5
	PORT MAP(
		S => RegDest(0),
		W0 => instr(20 DOWNTO 16),
		W1 => instr(15 DOWNTO 11),
		F => address_reg
	);
	PC : register32
	PORT MAP(
		Clock	=> clk,
		DIN		=> toPC,
		DOUT	=> toinstmem
	);
	PCadder : adder32
	PORT MAP(
		CIN => '0',
		X 	=> toinstmem,
		Y	=> "00000000000000000000000000000100",
		S 	=> PC_PLUS_4
	);
	instmem : inst_mem
	PORT MAP(
		address => toinstmem(15 DOWNTO 0),
		clock   => clk,
		q    	=> instr
	);
	regfile : reg_file
	PORT MAP(
		clk => clk,
		WE3 => regwrite,
		A1 => instr (25 DOWNTO 21),
		A2 => instr (20 DOWNTO 16),
		A3 => address_reg,
		WD3 => datatowrite2, 
		RD1 => readdata1,
		RD2 => readdata2
	);
	ALUC : ALU
	PORT MAP(
		ALUin1	=> readdata1,
		ALUin2 	=> srcB,
		ALUCtrl => ALUControl,
		ALUOut 	=> ALUresult
	);
	datamem : data_mem
	PORT MAP(
		address => ALUresult (7 DOWNTO 0), 
		memwrite => memwrite, 
		memread => '0',
		clock => clk,
		read_data  => readmem,
		write_data => readdata2(7 DOWNTO 0) 
	);
	signext : sign_ext
	PORT MAP(
		inst_immed => instr(15 DOWNTO 0),
		sign_extend => SignImm
	);
	Immshift : shifter32
	PORT MAP(	
		DIN	=> SignImm,
		DOUT => outshift2
	);
	Immadder : adder32
	PORT MAP(	
		CIN => '0',
		X	=> outshift2, 
		Y 	=> PC_PLUS_4,
		S 	=> tomux1
		);
	Jumpshift : shifter28
	PORT MAP(	
		DIN	=> instr(25 DOWNTO 0),
		DOUT => outshift1
	);
	busmer : busmerging
	PORT MAP(	
		D0	=> PC_PLUS_4(31 DOWNTO 28),
		D1	=> outshift1,
		DOUT => outBusMer
	);
	komp32 : komparator32
	PORT MAP(	
		A => readdata1,
		B => readdata2,
		C => outeq
	);
	ContUnit : Controller
	PORT MAP(	
		op => instr(31 DOWNTO 26),
		funct => instr(5 DOWNTO 0),
		Bne	=> bnesig,
		Branch => brsig,	
		MemtoReg => memtoreg,
		MemWrite => memwrite,
		RegDest => RegDest,
		RegWrite => regwrite,
		Jump => Jump,
		ALUSrc => ALUsrc,
		ALUControl => ALUControl
	);
	ALU_result <= ALUresult;
	SignImmTest <= SignImm;
	srcATest <= readdata1;
	PCoutTest <= toinstmem;
	PCinTest <= toPC;
	instrTest <= instr;
	lwTest <= datatowrite2;
	swTest <= readdata2(7 DOWNTO 0);
	BrTest <= BranchResult;
	JTest <= Jump;
END Structure ;
