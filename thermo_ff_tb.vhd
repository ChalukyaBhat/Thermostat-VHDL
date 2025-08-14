entity T_THERMOSTAT is
end T_THERMOSTAT;

architecture TEST of T_THERMOSTAT is
component TERMOSTAT 
port (CURRENT_TEMP: in bit_vector(6 downto 0);
	  DESIRED_TEMP: in bit_vector(6 downto 0);
	  DISPLAY_SELECT : in bit;
	  HEAT : in bit;
	  COOL : in bit;
	  CLK : in bit;
	  TEMP_DISPLAY: out bit_vector(6 downto 0);
	  A_C_ON : out bit;
	  FURNACE_ON : out bit);
end component;

signal CURRENT_TEMP,DESIRED_TEMP : bit_vector(6 downto 0);
signal HEAT, COOL, A_C_ON, FURNACE_ON : bit;
signal DISPLAY_SELECT : bit;
signal TEMP_DISPLAY : bit_vector(6 downto 0);
signal CLK : bit := '0';

begin
CLK <= not CLK after 5ns;
DUT: TERMOSTAT port map (CURRENT_TEMP => CURRENT_TEMP,
			CLK => CLK,
			DESIRED_TEMP => DESIRED_TEMP,
			DISPLAY_SELECT => DISPLAY_SELECT,
			HEAT => HEAT,
			COOL => COOL,
			TEMP_DISPLAY => TEMP_DISPLAY,
			A_C_ON => A_C_ON,
			FURNACE_ON => FURNACE_ON);
						
process
begin
CURRENT_TEMP <= "0101010";
DESIRED_TEMP <= "1111000";
DISPLAY_SELECT <= '1';
wait for 50 ns;
DISPLAY_SELECT <= '0';
wait for 50 ns;
HEAT <= '1';
wait for 50 ns;
HEAT <= '0';
wait for 50 ns;
CURRENT_TEMP <= "1111111";
DESIRED_TEMP <= "0000000";
DISPLAY_SELECT <= '1';
wait for 50 ns;
DISPLAY_SELECT <= '0';
wait for 50 ns;
COOL <= '1';
wait for 50 ns;
COOL <= '0';
wait;
end process;
end TEST;