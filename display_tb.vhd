--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*********  Copyright 2017, Rochester Institute of Technology  ***************
--*****************************************************************************
--
--  DESIGNER NAME:  Jeanne Christman
--
--       LAB NAME:  Binary to 7-segment Display
--
--      FILE NAME:  display_tb.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This test bench will provide input to test an eight bit binary to 
--    seven-segment display driver.  The input is an 8-bit binary number.
--    There are four outputs which go to the 7-segment displays to display the 
--    signed decimal equivalence of the 8-bit binary number.
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 09/27/17 | JWC  | 1.0 | Created
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;            

ENTITY display_tb IS
END ENTITY display_tb;

ARCHITECTURE test OF display_tb IS

--the component name MUST match the entity name of the VHDL module being tested   
    COMPONENT Lab6	
        PORT ( In_num    : 		in   STD_LOGIC_VECTOR(7 downto 0);                  --8-bit input
               HEX0,HEX1,HEX2,HEX3    : 	    out  STD_LOGIC_VECTOR(6 downto 0));     --ssd outputs
    END COMPONENT;
    
	constant ZERO:  std_logic_vector(6 downto 0) := "1000000";
	constant ONE:   std_logic_vector(6 downto 0) := "1111001";
	constant TWO:   std_logic_vector(6 downto 0) := "0100100";
	constant THREE: std_logic_vector(6 downto 0) := "0110000";
	constant FOUR:  std_logic_vector(6 downto 0) := "0011001";
	constant FIVE:  std_logic_vector(6 downto 0) := "0010010";
	constant SIX:   std_logic_vector(6 downto 0) := "0000010"; 
	constant SEVEN: std_logic_vector(6 downto 0) := "1111000";
	constant EIGHT: std_logic_vector(6 downto 0) := "0000000";
	constant NINE:  std_logic_vector(6 downto 0) := "0010000";
	constant A:     std_logic_vector(6 downto 0) := "0001000";
	constant B:     std_logic_vector(6 downto 0) := "0000011";
	constant C:     std_logic_vector(6 downto 0) := "1000110"; 
	constant D:     std_logic_vector(6 downto 0) := "0100001";
	constant E:     std_logic_vector(6 downto 0) := "0000110";
	constant F:     std_logic_vector(6 downto 0) := "0001110";
	constant DASH:  std_logic_vector(6 downto 0) := "0111111";
	constant blank: std_logic_vector(6 downto 0) := "1111111";

    TYPE ssd_array_type IS ARRAY (0 TO 17) OF std_logic_vector(6 downto 0);
    CONSTANT ssd_array_C : ssd_array_type:= (
        ZERO,  ONE,  TWO, THREE, FOUR, FIVE, SIX, SEVEN,
        EIGHT, NINE, A,   B,     C,    D,    E,   F,   
        DASH,  blank );

    -- testbench signals.  These do not need to be modified
    SIGNAL In_num_tb        : std_logic_vector(7 DOWNTO 0);
    --
    SIGNAL HEX0_tb          : std_logic_vector(6 DOWNTO 0);
    SIGNAL HEX1_tb          : std_logic_vector(6 DOWNTO 0); 
    SIGNAL HEX2_tb          : std_logic_vector(6 DOWNTO 0);
    SIGNAL HEX3_tb          : std_logic_vector(6 DOWNTO 0);
   
    -- converts a std_logic_vector into a hex string. Taken from txt_util package. Package obtained from http://www.stefanvhdl.com/
   function hstr(slv: std_logic_vector) return string is
       variable hexlen: integer;
       variable longslv : std_logic_vector(67 downto 0) := (others => '0');
       variable hex : string(1 to 16);
       variable fourbit : std_logic_vector(3 downto 0);
     begin
       hexlen := (slv'left+1)/4;
       if (slv'left+1) mod 4 /= 0 then
         hexlen := hexlen + 1;
       end if;
       longslv(slv'left downto 0) := slv;
       for i in (hexlen -1) downto 0 loop
         fourbit := longslv(((i*4)+3) downto (i*4));
         case fourbit is
           when "0000" => hex(hexlen -I) := '0';
           when "0001" => hex(hexlen -I) := '1';
           when "0010" => hex(hexlen -I) := '2';
           when "0011" => hex(hexlen -I) := '3';
           when "0100" => hex(hexlen -I) := '4';
           when "0101" => hex(hexlen -I) := '5';
           when "0110" => hex(hexlen -I) := '6';
           when "0111" => hex(hexlen -I) := '7';
           when "1000" => hex(hexlen -I) := '8';
           when "1001" => hex(hexlen -I) := '9';
           when "1010" => hex(hexlen -I) := 'A';
           when "1011" => hex(hexlen -I) := 'B';
           when "1100" => hex(hexlen -I) := 'C';
           when "1101" => hex(hexlen -I) := 'D';
           when "1110" => hex(hexlen -I) := 'E';
           when "1111" => hex(hexlen -I) := 'F';
           when "ZZZZ" => hex(hexlen -I) := 'z';
           when "UUUU" => hex(hexlen -I) := 'u';
           when "XXXX" => hex(hexlen -I) := 'x';
           when others => hex(hexlen -I) := '?';
         end case;
       end loop;
       return hex(1 to hexlen);
     end hstr;
BEGIN
--this must match component above
    UUT : Lab6 PORT MAP (  
        In_num         => In_num_tb,
        
        HEX0           => HEX0_tb,
        HEX1           => HEX1_tb,
        HEX2           => HEX2_tb,
        HEX3           => HEX3_tb
        );

    ---------------------------------------------------------------------------
    -- NAME: Stimulus
    --
    -- DESCRIPTION:
    --    This process will apply the stimulus to the UUT
    ---------------------------------------------------------------------------
    stimulus : PROCESS
        VARIABLE r_tb_high : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE r_tb_mid  : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE r_tb_low  : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE r_tb_signed  : SIGNED(7 DOWNTO 0);
        VARIABLE ones_dig : INTEGER;
        VARIABLE tens_dig : INTEGER;
        VARIABLE huns_dig : INTEGER;
        VARIABLE sign : INTEGER;


    BEGIN
            -- create a loop to run through all the combinations of R
          FOR j IN 0 TO 255 LOOP
                    -- Assign the R input value
                    In_num_tb <= STD_LOGIC_VECTOR(to_unsigned(j,8));
                    -- Create the expected numeric digits.
                    IF (j>127) THEN
                        sign := j-255-1; --to_integer(to_signed(j,8));
                    ELSE sign := j;
                    END IF;
                    huns_dig := sign / 100;
                    tens_dig := (sign rem 100) / 10;
                    ones_dig := (sign rem 100) rem 10;
                    WAIT FOR 10 ns;
            
                   
                        --IF to_signed(j,8) < 0 THEN
                        IF (j>127) THEN  --treat it like a negative number
                            ASSERT HEX3_tb = DASH
                                REPORT "HEX3 Incorrect. Should be Dash" & LF SEVERITY ERROR;
                        ELSE
                            ASSERT HEX3_tb = BLANK
                                REPORT "HEX3 Incorrect. Should be Blank" & LF SEVERITY ERROR;
                        END IF;
                        ASSERT HEX2_tb = ssd_array_C(abs(huns_dig))
                            REPORT "HEX2 Incorrect. Should be "& integer'image(huns_dig) & LF SEVERITY ERROR;
                        ASSERT HEX1_tb = ssd_array_C(abs(tens_dig))
                            REPORT "HEX1 Incorrect. Should be "& integer'image(tens_dig) & LF SEVERITY ERROR;
                        ASSERT HEX0_tb = ssd_array_C(abs(ones_dig))
                            REPORT "HEX0 Incorrect. Should be "& integer'image(ones_dig) & LF SEVERITY ERROR;
                 
                END LOOP; 

        Report LF& "**************************" &LF&
        					 "Simulation Complete" &LF&
        					 "**************************" SEVERITY NOTE;    
        -----------------------------------------------------------------------
        -- This last WAIT statement needs to be here to prevent the PROCESS
        -- sequence from restarting.
        -----------------------------------------------------------------------
        WAIT;
    END PROCESS stimulus;


END ARCHITECTURE test;
