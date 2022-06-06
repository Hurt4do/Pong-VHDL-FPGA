-------------- FSM_BALL------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-----------------------------------

ENTITY ball IS 
  PORT(rst          : IN  STD_LOGIC;
       clk          : IN  STD_LOGIC;  
       BallPosition : OUT INTEGER RANGE 0 TO 127);
END ENTITY;
-----------------------------------
ARCHITECTURE fsm OF ball IS 
  TYPE state IS (rght ,lft);
  
  SIGNAL pr_state, nx_state : state;
  SIGNAL max_tick_s         : STD_LOGIC;
  SIGNAL BallPosition_s     : INTEGER RANGE 0 TO 127;
  
    BEGIN 
  
      BallMovementSpeed : ENTITY work.Univ_Bin_Counter_Ball
                            PORT MAP( clk => clk,
							                 rst => rst,
								              ena => '1',
										        syn_clr => '0',
										        load => '0',
										        up => '1',
										        d =>"00000000000000000000000000",
										        max_tick => max_tick_s);

												   
		BallPosition <= BallPosition_s;
										
    ---------- sequential section: -----------------
	 PROCESS (rst, clk)
	   BEGIN
	     IF (rst = '1')THEN
		    pr_state <= rght;
		  ELSIF (rising_edge(clk))THEN 
		    pr_state <= nx_state;
			END IF;
	  END PROCESS;
	  
 ----------- combinational section: ------------
	PROCESS (pr_state, max_tick_s, BallPosition_s)
	  VARIABLE position : INTEGER RANGE 0 TO 127;
     BEGIN 
	    CASE pr_state IS 
			  
			 WHEN rght =>
			   BallPosition_s <= position;
            IF(max_tick_s = '1')THEN
				  position := position + 8;
				  BallPosition_s <= position;
				  IF(position = 123)THEN 
			       nx_state <= lft;
			       ELSE 
			         nx_state <= rght;
			     END IF;
				 ELSE
				   nx_state <= rght;
			   END IF;
			  
			 WHEN lft =>
			   BallPosition_s <= position;
            IF(max_tick_s = '1')THEN
				  position := position - 8;
				  BallPosition_s <= position;
				  IF(position = 3)THEN 
			       nx_state <= rght;
			       ELSE 
			         nx_state <= lft;
			     END IF;
				 ELSE
				   nx_state <= lft;
			   END IF;
			END CASE;
	  END PROCESS;
	END ARCHITECTURE fsm;