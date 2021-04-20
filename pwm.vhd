library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm is
	generic(
			pwm_resolution: integer := 8;  	-- Resolucion máxima del pwm
			freq_resolution: integer :=16	-- Resolucion máxima de la frecuencia del pwm
	);
	port(
		clk_i: in std_logic;
		rst_i: in std_logic;
		duty_cycle_i: in unsigned(pwm_resolution-1 downto 0);
		freq_divider_i: in unsigned(freq_resolution-1 downto 0);
		pwm_o: out std_logic
	);
end;

architecture pwm_arq of pwm is

	--Señales auxiliares
	signal clk_cnt: unsigned(freq_resolution-1 downto 0) := (others => '0');
	signal aux_clk_o: std_logic := '0';
	signal aux_cnt_o: unsigned(pwm_resolution-1 downto 0) := (others => '0');
	
begin
	
	--Divisor de clock del sistema
	CLK_DIVIDER: process(clk_i)
	begin
		if rising_edge(clk_i) then
			clk_cnt <= clk_cnt + 1;
			if clk_cnt = freq_divider_i then
				aux_clk_o <= not aux_clk_o;
				clk_cnt <= (others => '0');
			end if;
		end if;
	end process;

	--Contador para duty cycle, cuenta 1 pulso por flanco ascendente
	CONTADOR: process(aux_clk_o,rst_i)
	begin
		if (rst_i = '1') then
			aux_cnt_o <= (others => '0');
		elsif rising_edge(aux_clk_o) then
			aux_cnt_o <= aux_cnt_o + 1;
		end if;
	end process;
	
	--Salida del pwm
	PWM: process(aux_cnt_o, rst_i)
	begin
		if (rst_i = '1') then
			pwm_o <= '0';
		elsif (aux_cnt_o <= duty_cycle_i) then
				pwm_o <= '1';
			else pwm_o <= '0';
		end if;
	end process;

end;