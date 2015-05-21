LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY count IS
	PORT(
		switch0 : in STD_LOGIC;
		switch1 : in STD_LOGIC;
		ledblink : BUFFER STD_LOGIC;
	
		ledgrp : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		ledgrpcount: buffer integer;
		seg1 : OUT STD_LOGIC_VECTOR(6 downto 0);
		seg2 : OUT STD_LOGIC_VECTOR(6 downto 0);
		seg3 : OUT STD_LOGIC_VECTOR(6 downto 0);
		seg4 : OUT STD_LOGIC_VECTOR(6 downto 0);
		seg5 : OUT STD_LOGIC_VECTOR(6 downto 0);
		seg6 : OUT STD_LOGIC_VECTOR(6 downto 0); 
		clk1 : IN STD_LOGIC
	);

END count;

ARCHITECTURE behavioral of count is
	signal h_ms_int : integer range 0 to 2;
    signal h_ls_int : integer range 0 to 9;
    signal m_ms_int : integer range 0 to 5;
    signal m_ls_int : integer range 0 to 9;
    signal s_ms_int : integer range 0 to 5;
    signal s_ls_int : integer range 0 to 9;
	signal clk : std_logic :='0';
    signal count : integer :=1;
    signal ledclk :std_logic := '0';
	signal secCount : integer :=1;
	signal blinkCount : integer := 0;
	signal sls :   STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal sms :   STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal mls :   STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal mms :   STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal hls :   STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal hms :   STD_LOGIC_VECTOR(1 DOWNTO 0);

	begin

		  --clk generation.For 50 MHz clock this generates 1 Hz clock.
			process(clk1)
				begin
					if(clk1'event and clk1='1') then
						count <= count+1;
						if(count = .; 25000000) then
							clk <= not clk;
							count <=1;
						end if;
					end if;
			end process;

		--clk generation for 50MHz clock to get it blink at 1/5 of a second (as fast as possible)
		process(clk1)
			begin
				if(clk1'event and clk1 = '1') then
					secCount <= secCount +1;
					if(secCount = 25000000) then
						ledclk <= not ledclk;
						secCount <=1;
					end if;
				end if;
		end process;
		
		-- Process that handles the project logic
		clk_proc : process(clk, switch0, switch1)
			variable ledcount : integer := 1;
			begin
				if (clk'event and clk ='1') then
					if switch0 = '1' then	
						 if s_ls_int = 9 then
                                if s_ms_int = 5 then
                                   if m_ls_int = 9 then
                                           if m_ms_int = 5 then
                                                    if (h_ls_int = 9 or (h_ls_int = 3 and h_ms_int = 2)) then
                                                             h_ls_int <= 0;
                                                        if (h_ls_int=3 and h_ms_int=2) then
                                                             h_ms_int <= 0;
                                                             h_ls_int <= 0;
															 m_ms_int <= 0;
                                                             m_ls_int <= 0;
                                                             s_ms_int <= 0;
                                                             s_ls_int <= 0;
                                                        else
                                                             h_ms_int <= h_ms_int + 1;
                                                                               
                                                        end if;
                                                             h_ls_int <= 0;
                                                    else
                                                         h_ls_int <= h_ls_int + 1;
                                                                        
                                                    end if;
														m_ms_int <= 0;
                                             else
                                                   m_ms_int <= m_ms_int + 1;
                                             end if;
                                                   m_ls_int <= 0;       
                                  else
									  m_ls_int <= m_ls_int + 1;
									  blinkCount <= blinkCount + 1;
                                  end if;
                                      s_ms_int <= 0;
                           else
                                s_ms_int <= s_ms_int + 1;
                               
                           end if;
                                s_ls_int <= 0;
                       else
                            s_ls_int <= s_ls_int + 1;
                       end if;
                        
				elsif switch1 = '1' then
					h_ms_int <= 0;
                    h_ls_int <= 0;
                    m_ms_int <= 0;
                    m_ls_int <= 0;
                    s_ms_int <= 0;
                    s_ls_int <= 0;
					blinkCount <= 0;
				end if;
			end if;
				  ledgrpcount <= blinkCount;
			      hms <= std_logic_vector(to_unsigned(h_ms_int, hms'length));
			      hls <= std_logic_vector(to_unsigned(h_ls_int, hls'length));
			      mms <= std_logic_vector(to_unsigned(m_ms_int, mms'length));
			      mls <= std_logic_vector(to_unsigned(m_ls_int, mls'length));
				  sms <= std_logic_vector(to_unsigned(s_ms_int, sms'length));
			      sls <= std_logic_vector(to_unsigned(s_ls_int, sls'length));
	
		end process clk_proc;
		
	PROCESS (ledgrpcount)
		BEGIN
			CASE ledgrpcount IS
				WHEN 0 => ledgrp <= "000000000000";
				WHEN 1 => ledgrp <= "000000000001";
				WHEN 2 => ledgrp <= "000000000011";
				WHEN 3 => ledgrp <= "000000000111";
				WHEN 4 => ledgrp <= "000000001111";
				WHEN 5 => ledgrp <= "000000011111";
				WHEN 6 => ledgrp <= "000000111111";
				WHEN 7 => ledgrp <= "000001111111";
				WHEN 8 => ledgrp <= "000011111111";
				WHEN 9 => ledgrp <= "000111111111";
				WHEN 10 => ledgrp <= "001111111111";
				WHEN 11 => ledgrp <= "011111111111";
				WHEN 12 => ledgrp <= "111111111111";
				WHEN 13 => ledgrp <= "000000000001";
				WHEN 14 => ledgrp <= "000000000011";
				WHEN 15 => ledgrp <= "000000000111";
				WHEN 16 => ledgrp <= "000000001111";
				WHEN 17 => ledgrp <= "000000011111";
				WHEN 18 => ledgrp <= "000000111111";
				WHEN 19 => ledgrp <= "000001111111";
				WHEN 20 => ledgrp <= "000011111111";
				WHEN 21 => ledgrp <= "000111111111";
				WHEN 22 => ledgrp <= "001111111111";
				WHEN 23 => ledgrp <= "011111111111";
				WHEN 24 => ledgrp <= "111111111111";
				WHEN OTHERS => ledgrp <= "000000000000";
			END CASE;
	END PROCESS;
				
	--- For the MS  of the Second
	--start: count_mod5 port map(sms1=> sms, seg21=> seg2);
	PROCESS (sms)
		BEGIN
			CASE sms IS 
				WHEN "000" => seg2 <= "1000000";
				WHEN "001" => seg2 <= "1111001";
				WHEN "010" => seg2 <= "0100100";
				WHEN "011" => seg2 <= "0110000";
				WHEN "100" => seg2 <= "0011001";
				WHEN "101" => seg2 <= "0010010";
				WHEN OTHERS => seg2 <= "1000000";
			END CASE;
	END PROCESS;
	-- For the LS of the second
	PROCESS (sls)
		BEGIN
			CASE sls IS 
				 WHEN "0000" => seg1  <= "1000000";
				 WHEN "0001" => seg1 <= "1111001";
				 WHEN "0010" => seg1 <= "0100100";
				 WHEN "0011" => seg1 <= "0110000";
				 WHEN "0100" => seg1 <= "0011001";
				 WHEN "0101" => seg1 <= "0010010";
				 WHEN "0110" => seg1 <= "0000010";
				 WHEN "0111" => seg1 <= "1011000";
				 WHEN "1000" => seg1 <= "0000000";
				 WHEN "1001" => seg1 <= "0011000";
				 WHEN OTHERS => seg1 <= "1000000";
			END CASE;
	END PROCESS;	
	
	--- For the MS of the Second
	PROCESS (mms)
		BEGIN
			CASE mms IS 
				WHEN "000" => seg4 <= "1000000";
				WHEN "001" => seg4 <= "1111001";
				WHEN "010" => seg4 <= "0100100";
				WHEN "011" => seg4 <= "0110000";
				WHEN "100" => seg4 <= "0011001";
				WHEN "101" => seg4 <= "0010010";
				WHEN OTHERS => seg4 <= "1000000";
			END CASE;
	END PROCESS;
	
	-- For the LS of the second
	PROCESS (mls)
		BEGIN
		CASE mls IS 
			 WHEN "0000" => seg3 <= "1000000";
			 WHEN "0001" => seg3 <= "1111001";
			 WHEN "0010" => seg3 <= "0100100";
			 WHEN "0011" => seg3 <= "0110000";
			 WHEN "0100" => seg3 <= "0011001";
			 WHEN "0101" => seg3 <= "0010010";
			 WHEN "0110" => seg3 <= "0000010";
			 WHEN "0111" => seg3 <= "1011000";
			 WHEN "1000" => seg3 <= "0000000";
			 WHEN "1001" => seg3 <= "0011000";
			 WHEN OTHERS => seg3 <= "1000000";		
		 END CASE;
	END PROCESS;	
	
	--For the MS of the hour hand
	PROCESS(hms)
		BEGIN
			CASE hls IS 
				WHEN "00" => seg6 <= "1000000";
				WHEN "01" => seg6 <= "1111001";
				WHEN "10" => seg6 <= "0100100";
				WHEN OTHERS => seg6 <= "1000000";
			END CASE;
	END PROCESS;
	
	-- For the LS of the hour hand
	PROCESS(hls)
		BEGIN
			CASE hls IS
				WHEN "00" => seg5 <= "1000000";
				WHEN "01" => seg5 <= "1111001";
				WHEN "10" => seg5 <= "0100100";
				WHEN "11" => seg5 <= "0110000";
				WHEN OTHERS => seg5 <= "1000000";
			END CASE;
	END PROCESS;
END behavioral;