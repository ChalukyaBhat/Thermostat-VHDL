library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity THERMOSTAT is
port (CURRENT_TEMP: in std_logic_vector(6 downto 0);
	  DESIRED_TEMP: in std_logic_vector(6 downto 0);
	  DISPLAY_SELECT: in std_ulogic;
	  HEAT : in std_ulogic;
	  COOL : in std_ulogic;
	  TEMP_DISPLAY: out std_logic_vector(6 downto 0);
	  AC_ON : out std_ulogic;
	  FAN_ON : out std_ulogic; --new
	  CLK : in std_ulogic;
	  FURNANCE_HOT : in std_ulogic; --new
	  AC_READY : in std_ulogic; --new
	  FURNACE_ON : out std_ulogic);
end TERMOSTAT;

architecture BEHAV of THERMOSTAT is 

type STATE is (IDLE,HEATON,FURNANCENOWHOT,FURNANCECOOL,COOLON,ACNOWREADY,ACDONE);

signal CURRENT_TEMP_REG,DESIRED_TEMP_REG: bit_vector(6 downto 0);
signal DISPLAY_SELECT_REG,HEAT_REG,COOL_REG: bit;
signal CURRENT_STATE : STATE;
signal NEXT_STATE : STATE;

begin
process(CLK)
begin
	if CLK'event and CLK='1' then
		CURRENT_TEMP_REG <= CURRENT_TEMP;
		DESIRED_TEMP_REG <= DESIRED_TEMP;
		DISPLAY_SELECT_REG <= DISPLAY_SELECT;
		HEAT_REG <= HEAT;
		COOL_REG <= COOL;
	end if;
end process;

process(CLK)
begin
	if CLK'event and CLK='1' then
		if DISPLAY_SELECT_REG = '0' then
			TEMP_DISPLAY <= CURRENT_TEMP_REG;
		else
			TEMP_DISPLAY <= DESIRED_TEMP_REG;
		end if;
	end if;
end process;

process(CLK,RESET)
begin
	if RESET = '1' then
		CURRENT_STATE <= IDLE;
	elsif CLK'event and CLk = '1' then
		CURRENT_STATE <= NEXT_STATE;
	end if;
end process;

process(CURRENT_STATE,CURRENT_TEMP,DESIRED_TEMP,HEAT,COOL,FURNANCE_HOT,AC_READY)
begin
case CURRENT_STATE is 
	when IDLE =>
		if HEAT and CURRENT_TEMP < DESIRED_TEMP then	
			NEXT_STATE <= HEATON;
		else if COOl and CURRENT_TEMP > DESIRED_TEMP then
			NEXT_STATE <= COOLON;
		else 	
			NEXT_STATE <= IDLE;
		end if
	when HEATON =>
		if FURNANCE_HOT = '1' then
			NEXT_STATE <= FURNANCENOWHOT;
		else
			NEXT_STATE <= HEATON;
		end if;
	when FURNANCENOWHOT =>
		if !(HEAT and CURRENT_TEMP < DESIRED_TEMP then) then
			NEXT_STATE <= FURNANCECOOL;
		else	
			NEXT_STATE <= FURNANCENOWHOT;
		end if;
	when FURNANCECOOL =>
		if FURNANCE_HOT = '0' then
			NEXT_STATE <= IDLE;
		else	
			NEXT_STATE <= FURNANCECOOL;
		end if;
	when COOLON =>
		if AC_READY = '1' then
			NEXT_STATE <= ACNOWREADY;
		else 
			NEXT_STATE <= COOLON;
		end if;
	when ACNOWREADY =>
		if !(COOl and CURRENT_TEMP > DESIRED_TEMP) then
			NEXT_STATE <= ACDONE;
		else 
			NEXT_STATE <= ACNOWREADY;
		end if;
	when ACDONE =>
		if AC_READY = '0' then
			NEXT_STATE <= IDLE;
		else
			NEXT_STATE <= ACDONE;
		end if;
	when others =>
			NEXT_STATE <= IDLE;
end case;
end process;

process(CLK)
begin
	if CLK'event and CLK='1' then
		if CURRENT_STATE = COOLON or CURRENT_STATE = ACNOWREADY then
			AC_ON <= '1';
		else
			AC_ON <= '0';
		end if;
		if CURRENT_STATE = HEATON or CURRENT_STATE = FURNANCENOWHOT then
			FURNACE_ON <= '1';
		else
			FURNACE_ON <= '0';
		end if;
		if CURRENT_STATE = ACNOWREADY or CURRENT_STATE = ACDONE or CURRENT_STATE = FURNANCENOWHOT or CURRENT_STATE = FURNANCECOOL then
			FAN_ON <= '1';
		else
			FAN_ON <= '0';
		end if;
	end if;
end process;
end BEHAV;
		
	
	  
