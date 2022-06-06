------------ball_V2----------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
------------------------------------------------

ENTITY ball_V2 IS 
  PORT ( rst           : IN  STD_LOGIC;
         clk           : IN  STD_LOGIC;
			buffDisplay   : OUT STD_LOGIC_VECTOR(111 DOWNTO 0)); --buffDisplay_s <= (5 DOWNTO 3 => '0', 125 DOWNTO 123 => '0', 20 => '0', OTHERS => '1');
			
END ENTITY ball_V2;
------------------------------------------------
ARCHITECTURE my_arch OF ball_V2 IS 
  TYPE state IS (zero, one, two);
  
  SIGNAL pr_state, nx_state  : state;
  SIGNAL max_tick_s          : STD_LOGIC;
  SIGNAL buffDisplay_s       : STD_LOGIC_VECTOR(127 DOWNTO 0);
  SIGNAL BallPos             : INTEGER RANGE 0 TO 127 := 60 ;
  
  
  BEGIN 
  
    BallSpeed : ENTITY work.Univ_Bin_Counter_Ball
                      PORT MAP( clk => clk,
							           rst => rst,
										  ena => '1',
										  syn_clr => '0',
										  load => '0',
										  up => '1',
										  d =>"00000000000000000000000000",
										  max_tick => max_tick_s);
										  
	--buffDisplay_s <= (5 DOWNTO 3 => '0', 125 DOWNTO 123 => '0', BallPosINT => '0', OTHERS => '1');
	
	buffDisplay <= buffDisplay_s;
										  								  
    ----------sequential section: -----------------
	 PROCESS (rst, clk)
	   BEGIN
	     IF (rst = '1')THEN
		    pr_state <= zero;
		  ELSIF (rising_edge(clk))THEN 
		    pr_state <= nx_state;
			END IF;
	  END PROCESS;
	 ----------- combinational section: ------------
	PROCESS (max_tick_s, pr_state, buffDisplay_s)
	 VARIABLE Position_v       : NATURAL RANGE 0 TO 127 := 60; 
	 --VARIABLE PrevPosition_v   : NATURAL RANGE 0 TO 127 := 0;
     BEGIN 
	    CASE pr_state IS 
		   WHEN zero => 
			 -- buffDisplay_s <= (5 DOWNTO 3 => '0', 125 DOWNTO 123 => '0', OTHERS => '1');
		     IF ( max_tick_s = '1')THEN
			  --buffDisplay_s <= (5 DOWNTO 3 => '0', 125 DOWNTO 123 => '0', OTHERS => '1');
				 nx_state <= one;
			  ELSE
			 -- buffDisplay_s <= (5 DOWNTO 3 => '0', 125 DOWNTO 123 => '0', OTHERS => '1');
			    nx_state <= zero;
			  END IF;
			  
			WHEN one =>
			  --Position_v := Position_v + 8;
			 -- buffDisplay_s <= (Position_v => '0', OTHERS => '1');
			  --revPosition_v := Position_v;
           --buffDisplay_s (60) <= '0';
			  --buffDisplay_s (68) <= '1';
			  --buffDisplay_s <= (Position_v => '0', (OTHERS => '1');
		     IF (max_tick_s = '1')THEN
			    --buffDisplay_s (60) <= '0';
			    --buffDisplay_s (68) <= '1';
				 --buffDisplay_s <= (Position_v => '0', OTHERS => '1');
				 --Position_v := Position_v + 8;
			    nx_state <= two;
			  ELSE
			    --buffDisplay_s (60) <= '0';
			    --buffDisplay_s (68) <= '1';
				 --buffDisplay_s <= (Position_v => '0', OTHERS => '1');
			    nx_state <= one;
			  END IF;
			  
			WHEN two =>
			  --Position_v := 68;
			  --buffDisplay_s <= (Position_v => '0', OTHERS => '1');
			  --buffDisplay_s (68) <= '0';
			  --buffDisplay_s (60) <= '1';
		     IF (max_tick_s = '1')THEN
			    --buffDisplay_s (68) <= '0';
			    --buffDisplay_s (60) <= '1';
				 --buffDisplay_s <= (Position_v => '0', OTHERS => '1');
				 --Position_v := Position_v - 8;
				 nx_state <= one;
			  ELSE
			    --buffDisplay_s (68) <= '0';
			    --buffDisplay_s (60) <= '1';
				 --buffDisplay_s <= (Position_v => '0', OTHERS => '1');
			    nx_state <= two;
			  END IF;
			  
	    END CASE;
	--	buffDisplay_s(TempPos) <='1'; --buffDisplay_s <= (5 DOWNTO 3 => '0', 125 DOWNTO 123 => '0', BallPos => '0', OTHERS => '1');
	  END PROCESS;
	END ARCHITECTURE;