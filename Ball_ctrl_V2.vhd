
-------------------BALL CONTROL V2---------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------

ENTITY Ball_ctrl_V2 IS 
    PORT(clk             : IN  STD_LOGIC;
	      rst             : IN  STD_LOGIC;
			--GOL_LFT         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
			--GOL_RGT         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
			NorIn           : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			NorIn2          : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			ballDisplay     : OUT STD_LOGIC_VECTOR(111 DOWNTO 0));
			
END ENTITY;
------------------------------------

ARCHITECTURE Control OF Ball_ctrl_V2 IS

  TYPE state IS (set, u_rght, u_lft, d_rght, d_lft);--, goalleft, goalrght);--(set, rght, lft, u_rght, u_lft, d_rght, d_lft)
  
  SIGNAL pr_state, nx_state   : state := set;
  SIGNAL max_tick_s           : STD_LOGIC;
  SIGNAL ball_s               : STD_LOGIC_VECTOR(111 DOWNTO 0) := (59 => '0', OTHERS => '1');
  SIGNAL ball_nx              : STD_LOGIC_VECTOR(111 DOWNTO 0) := (59 => '0', OTHERS => '1');
  SIGNAL racketPP1_s          : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL racketPP2_s          : STD_LOGIC_VECTOR(7 DOWNTO 0);
  --SIGNAL GOLLFT_COUNT         : INTEGER RANGE 0 TO 9 := 0;  --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
  --SIGNAL GOLRGHT_COUNT        : INTEGER RANGE 0 TO 9 := 0;  --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
  
  BEGIN 
    
	 ballDisplay <= ball_s;
	 --GOL_LFT <= STD_LOGIC_VECTOR(to_unsigned (GOLLFT_COUNT, 4)); --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
	 --GOL_RGT <= STD_LOGIC_VECTOR(to_unsigned (GOLRGHT_COUNT, 4)); --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
	 
	 
    BallSpeed : ENTITY work.Univ_Bin_Counter_Ball
                      PORT MAP( clk      => clk,
						              rst      => rst,
									     ena      => '1',
									     syn_clr  => '0',
									     load     => '0',
									     up       => '1',
									     d        =>"0000000000000000000000",
										  max_tick => max_tick_s);
										  

										  
    ----------sequential section: -----------------
	 PROCESS (rst, clk)
	   BEGIN
	     IF (rst = '1')THEN
		    pr_state <= set;----- agregar estado reset
		  ELSIF (rising_edge(clk))THEN 
		    pr_state   <= nx_state;
			 ball_s     <= ball_nx;
			END IF;
	  END PROCESS;
	 ----------- combinational section: ------------
	PROCESS (ball_s, ball_nx, max_tick_s, pr_state, NorIn, NorIn2)
     
	  	 -- VARIABLE GOL_LEFT : INTEGER RANGE 0 TO 9 := 0; --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
        --VARIABLE GOL_RGHT : INTEGER RANGE 0 TO 9 := 0; --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
		  
	  BEGIN 
	    CASE pr_state IS
	
	--******************* SET ********************************************	 n
		   WHEN set => 
			  ball_nx   <= (59 => '0', OTHERS => '1');
		     IF ( max_tick_s = '1')THEN 
				   nx_state <= u_rght; ------------------- falta estado inicial aleatorio, posición fija
				  ELSE 
				    nx_state <= set;
			  END IF;
	-----------------------------------------------------		  
			WHEN u_rght =>
	        ball_nx <= ball_s;
		     IF (max_tick_s = '1')THEN 
			    IF(   ball_s(8) = '0' OR ball_s(16) = '0' OR ball_s(24) = '0' OR ball_s(32) = '0'
				    OR ball_s(40) = '0' OR ball_s(48) = '0' OR ball_s(56) = '0' OR ball_s(64) = '0'
					 OR ball_s(72) = '0' OR ball_s(80) = '0' OR ball_s(88) = '0' OR ball_s(96) = '0')THEN
					 
					 nx_state <= d_rght;
					 
					ELSIF (   ball_s(105) = '0' OR ball_s(106) = '0' OR ball_s(107) = '0' OR ball_s(108) = '0'
				          OR ball_s(109) = '0' OR ball_s(110) = '0')THEN
							 
							 IF(NorIn = "00000000")THEN
							   ---GOL_LEFT := GOL_LEFT + 1; --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
							   --nx_state <= goalleft;  --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
							   nx_state <= set;
							 ELSE  

							 nx_state <= u_lft;
							 
							 END IF;
							 
					ELSIF ( ball_s(104) = '0')THEN
					
					       nx_state <= d_lft;
				   ELSE
					
			  	       ball_nx <= ball_s(104 DOWNTO 0) & "1111111";
				       nx_state <= u_rght;
						 
				 END IF; 
			  ELSE
			    nx_state <= u_rght;
			  END IF;
	--------------------------------------------------------	
 	
			WHEN d_rght =>
	        ball_nx <= ball_s;
		     IF (max_tick_s = '1')THEN 
			    IF(   ball_s(15) = '0' OR ball_s(23) = '0' OR ball_s(31)  = '0'  OR ball_s(39) = '0'
				    OR ball_s(47) = '0' OR ball_s(55) = '0' OR ball_s(63)  = '0'  OR ball_s(71) = '0'
					 OR ball_s(79) = '0' OR ball_s(87) = '0' OR ball_s(95) = '0' OR ball_s(103) = '0')THEN 
					 
					 nx_state <= u_rght;
					 
					ELSIF (   ball_s(105) = '0' OR ball_s(106) = '0' OR ball_s(107) = '0' OR ball_s(108) = '0'
				          OR ball_s(109) = '0' OR ball_s(110) = '0')THEN
							 
							 IF(NorIn = "00000000")THEN
							 
							   ---GOL_LEFT := GOL_LEFT + 1; --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
							   --nx_state <= goalleft;			--NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN		 
							   nx_state <= set;
							 ELSE

							 nx_state <= d_lft;
							 
							 END IF;
							 
					ELSIF ( ball_s(111) = '0')THEN
					
					       nx_state <= u_lft;
				   ELSE
					
			  	       ball_nx <= ball_s(102 DOWNTO 0) & "111111111";
				       nx_state <= d_rght;
						 
				 END IF; 
			  ELSE
			    nx_state <= d_rght;
			  END IF;
	--------------------------------------------------------------	

			WHEN u_lft =>
	        ball_nx <= ball_s;
		     IF (max_tick_s = '1')THEN 
			    IF(   ball_s(8) = '0' OR ball_s(16) = '0' OR ball_s(24) = '0' OR ball_s(32) = '0'
				    OR ball_s(40) = '0' OR ball_s(48) = '0' OR ball_s(56) = '0' OR ball_s(64) = '0'
					 OR ball_s(72) = '0' OR ball_s(80) = '0' OR ball_s(88) = '0' OR ball_s(96) = '0')THEN
					 
					 nx_state <= d_lft;
					 
					ELSIF (   ball_s(1) = '0' OR ball_s(2) = '0' OR ball_s(3) = '0' OR ball_s(4) = '0'
				          OR ball_s(5) = '0' OR ball_s(6) = '0')THEN
							 
							 IF(NorIn2 = "00000000")THEN
							   

							   --nx_state <= goalrght; --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
							   nx_state <= set;
							 ELSE 

							   nx_state <= u_rght;
								
							END IF;
							 
					ELSIF ( ball_s(0) = '0')THEN
					
					       nx_state <= d_rght;
				   ELSE
					
			  	       ball_nx <= "111111111" & ball_s(111 DOWNTO 9);
				       nx_state <= u_lft;
						 
				 END IF; 
			  ELSE
			    nx_state <= u_lft;
			  END IF;
	--------------------------------------------------------

			WHEN d_lft =>
	        ball_nx <= ball_s;
		     IF (max_tick_s = '1')THEN 
			    IF(   ball_s(15) = '0' OR ball_s(23) = '0' OR ball_s(31)  = '0'  OR ball_s(39) = '0'
				    OR ball_s(47) = '0' OR ball_s(55) = '0' OR ball_s(63)  = '0'  OR ball_s(71) = '0'
					 OR ball_s(79) = '0' OR ball_s(87) = '0' OR ball_s(95) = '0' OR ball_s(103) = '0')THEN
					 
					 nx_state <= u_lft;
					 
					ELSIF (   ball_s(1) = '0' OR ball_s(2) = '0' OR ball_s(3) = '0' OR ball_s(4) = '0'
				          OR ball_s(5) = '0' OR ball_s(6) = '0')THEN
							 
							 IF(NorIn2 = "00000000")THEN
							   

								--nx_state <= goalrght; --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
								nx_state <= set;
							 ELSE
							 

							 nx_state <= d_rght;
							 
							 END IF;
							 
					ELSIF ( ball_s(7) = '0')THEN
					
					       nx_state <= u_rght;
				   ELSE
					
			  	       ball_nx <= "1111111" & ball_s(111 DOWNTO 7);
				       nx_state <= d_lft;
						 
				 END IF; 
			  ELSE
			    nx_state <= d_lft;
			  END IF;
	--------------------------------------------------------------		
	    END CASE;
	  --GOLLFT_COUNT <= GOL_LEFT;  --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
	  --GOLRGHT_COUNT <= GOL_RGHT;  --NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
	  END PROCESS;
	END ARCHITECTURE;  