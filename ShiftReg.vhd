
----- SHIFT REGISTER ----------

LIBRARY  IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
-------------------------------
ENTITY ShiftReg IS 
  PORT( clk   : IN  STD_LOGIC;
        rst   : IN  STD_LOGIC;
		  ena   : IN  STD_LOGIC;
		  d     : IN  STD_LOGIC;
		  q0    : OUT STD_LOGIC;
		  q1    : OUT STD_LOGIC;
		  q2    : OUT STD_LOGIC;
		  q3    : OUT STD_LOGIC;
		  q4    : OUT STD_LOGIC;
		  q5    : OUT STD_LOGIC;
		  q6    : OUT STD_LOGIC;
		  q7    : OUT STD_LOGIC;
		  q8    : OUT STD_LOGIC;
		  q9    : OUT STD_LOGIC;
		  q10   : OUT STD_LOGIC;
		  q11   : OUT STD_LOGIC;
		  q12   : OUT STD_LOGIC;
		  q13   : OUT STD_LOGIC;
		  q14   : OUT STD_LOGIC;
		  q15   : OUT STD_LOGIC);
END ENTITY;
-------------------------------

ARCHITECTURE  behaviour OF ShiftReg IS 
  SIGNAL buffer_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL ena_s    : STD_LOGIC;
  
  BEGIN 

  ShiftEnable : ENTITY work.Univ_Bin_Counter
                  PORT MAP(clk      => clk,
	                        rst      => rst,
				               ena      => '1',
				               syn_clr  => '0',
				               load     => '0',
				               up       => '1',
				               d        => "00000000000000000000000000",
				               max_tick => ena_s);
				 
    PROCESS( clk, rst, ena_s, d)
	   BEGIN 
		  IF (rst = '0')THEN 
		    buffer_s <= "0000000000000000";
		  ELSIF(rising_edge(clk))THEN 
		    IF(ena_s = '1')THEN 
			   buffer_s(0)  <= buffer_s(1);
				buffer_s(1)  <= buffer_s(2);
				buffer_s(2)  <= buffer_s(3);
				buffer_s(3)  <= buffer_s(4);
				buffer_s(4)  <= buffer_s(5);
				buffer_s(5)  <= buffer_s(6);
				buffer_s(6)  <= buffer_s(7);
				buffer_s(7)  <= buffer_s(8);
				buffer_s(8)  <= buffer_s(9);
				buffer_s(9)  <= buffer_s(10);
				buffer_s(10) <= buffer_s(11);
				buffer_s(11) <= buffer_s(12);
				buffer_s(12) <= buffer_s(13);
				buffer_s(13) <= buffer_s(14);
				buffer_s(14) <= buffer_s(15);
				buffer_s(15) <= d; -- buffer_s(0);
		    END IF;
		  END IF;
    END PROCESS;
	 
  q0  <= buffer_s(0);
  q1  <= buffer_s(1);
  q2  <= buffer_s(2);
  q3  <= buffer_s(3);
  q4  <= buffer_s(4);
  q5  <= buffer_s(5);
  q6  <= buffer_s(6);
  q7  <= buffer_s(7);
  q8  <= buffer_s(8);
  q9  <= buffer_s(9);
  q10 <= buffer_s(10);
  q11 <= buffer_s(11);
  q12 <= buffer_s(12);
  q13 <= buffer_s(13);
  q14 <= buffer_s(14);
  q15 <= buffer_s(15);
  
END ARCHITECTURE;