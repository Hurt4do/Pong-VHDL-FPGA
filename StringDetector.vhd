------------Finite_State_Machine_Template----------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------

ENTITY StringDetector IS 
  PORT ( rst    : IN  STD_LOGIC;
         clk    : IN  STD_LOGIC;
			d      : IN  STD_LOGIC;
			q      : OUT STD_LOGIC);
END ENTITY StringDetector;
------------------------------------------------
ARCHITECTURE my_arch OF StringDetector IS 
  TYPE state IS (zero, one, two, three);
  SIGNAL pr_state, nx_state : state;
  
  BEGIN 
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
	PROCESS (d, pr_state)
     BEGIN 
	    CASE pr_state IS 
		   WHEN zero => 
			  q <= '0';
		     IF ( d = '1')THEN 
				 nx_state <= one;
			  ELSE
			    nx_state <= zero;
			  END IF;
			  
			WHEN one =>
			  q <= '0';
		     IF (d = '1')THEN 
				 nx_state <= two;
			  ELSE
			    nx_state <= zero;
			  END IF;
			  
			WHEN two => 
			  q <= '0';
	        IF (d = '1')THEN
			    nx_state <= three;
			  ELSE
			    nx_state <= zero;
			  END IF;
			  
			WHEN three => 
			  q <= '1';
	        IF (d = '0')THEN
			    nx_state <= zero;
			  ELSE
			    nx_state <= three;
			  END IF;
	    END CASE;
	  END PROCESS;
	END ARCHITECTURE;