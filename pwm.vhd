library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--use ieee.math_real.all;
--use IEEE.std_logic_arith.all;

entity pwm is
	generic(
			divider_cnt: integer := 25000; -- Definicion de frecuencia
			pwm_resolution: integer := 8   -- Resolucion máxima del pwm
	);
	port(
		clk_i: in std_logic;
		rst_i: in std_logic;
		duty_cycle_i: in unsigned(pwm_resolution-1 downto 0);
		cnt_o: out unsigned(pwm_resolution-1 downto 0);
		clk_o: out std_logic;
		pwm_o: out std_logic
	);
end;

architecture pwm_arq of pwm is

	signal clk_cnt: integer := 0;
	signal aux_clk_o: std_logic := '0';
	signal aux_cnt_o: unsigned(pwm_resolution-1 downto 0) := to_unsigned(0,pwm_resolution);
	
begin
	
	CLK_DIVIDER: process(clk_i,rst_i)
	begin
		if (rst_i = '1') then
			clk_cnt <= 1;
			aux_clk_o <= '0';
		elsif rising_edge(clk_i) then
			clk_cnt <= clk_cnt + 1;
			if clk_cnt = divider_cnt then
				aux_clk_o <= not aux_clk_o;
				clk_cnt <= 0;
			end if;
		end if;
		clk_o <= aux_clk_o;
	end process;

	CONTADOR: process(aux_clk_o,rst_i)
	begin
		if (rst_i = '1') then
			aux_cnt_o <= to_unsigned(0,pwm_resolution);
		elsif rising_edge(aux_clk_o) then
			aux_cnt_o <= aux_cnt_o + to_unsigned(1,pwm_resolution);
		end if;
		cnt_o <= aux_cnt_o;
	end process;
	
	pwm_o <= '1' when (to_integer(aux_cnt_o) < to_integer(duty_cycle_i))
	else '0';
	

	
end;