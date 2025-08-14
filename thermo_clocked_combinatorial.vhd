entity TERMOSTAT is
port (CURRENT_TEMP: in bit_vector(6 downto 0);
	  DESIRED_TEMP: in bit_vector(6 downto 0);
	  DISPLAY_SELECT: in bit;
	  HEAT : in bit;
	  COOL : in bit;
	  TEMP_DISPLAY: out bit_vector(6 downto 0);
	  A_C_ON : out bit;
	  CLK : in bit;
	  FURNACE_ON : out bit);
end TERMOSTAT;

architecture RTL of TERMOSTAT is

signal CURRENT_TEMP_REG,DESIRED_TEMP_REG,TEMP_DISPLAY_REG: bit_vector(6 downto 0);
signal DISPLAY_SELECT_REG,HEAT_REG,COOL_REG,A_C_ON_REG,FURNACE_ON_REG : bit;

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

process(CURRENT_TEMP_REG,DESIRED_TEMP_REG,DISPLAY_SELECT_REG)
begin
	--if CLK'event and CLK='1' then
		if DISPLAY_SELECT_REG = '0' then
			TEMP_DISPLAY_REG <= CURRENT_TEMP_REG;
		else
			TEMP_DISPLAY_REG <= DESIRED_TEMP_REG;
		end if;
	--end if;
end process;

process(CURRENT_TEMP_REG,DESIRED_TEMP_REG,HEAT_REG,COOL_REG)
begin
	--if CLK'event and CLK='1' then
		if CURRENT_TEMP_REG > DESIRED_TEMP_REG and COOL_REG = '1' then
			A_C_ON_REG <= '1';
		else
			A_C_ON_REG <= '0';
		end if;
		if CURRENT_TEMP_REG < DESIRED_TEMP_REG and HEAT_REG = '1' then
			FURNACE_ON_REG <= '1';
		else
			FURNACE_ON_REG <= '0';
		end if;
	--end if;
end process;
process (CLK)
begin
	if CLK'event and CLK='1' then
		A_C_ON <= A_C_ON_REG;
		FURNACE_ON <= FURNACE_ON_REG;
		TEMP_DISPLAY <= TEMP_DISPLAY_REG;
	end if;
end process;
end RTL;