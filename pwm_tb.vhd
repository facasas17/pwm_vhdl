library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_tb is
end;

architecture pwm_tb_arq of pwm_tb is

	-- Declaracion de componente
	component pwm is
		generic(
				pwm_resolution: integer := 8;   -- Resolucion máxima del pwm
				freq_resolution: integer :=16	-- Resolucion máxima de la frecuencia del pwm
		);
		port(
			clk_i: in std_logic;	-- Clock base
			rst_i: in std_logic;	-- Reset
			duty_cycle_i: in unsigned(pwm_resolution-1 downto 0);		-- Duty cycle
			freq_divider_i: in unsigned(freq_resolution-1 downto 0);	-- Valor del dividor de frecuencia
			pwm_o: out std_logic
		);
	end component;
	
	constant pwm_resolution_tb: integer := 8;
	constant freq_resolution_tb: integer := 16;

	-- Señales de prueba
	signal clk_i_tb: std_logic := '0';
	signal rst_i_tb: std_logic := '0';
	signal duty_cycle_i_tb: unsigned(pwm_resolution_tb-1 downto 0) := to_unsigned(50,pwm_resolution_tb);
	signal freq_divider_i_tb: unsigned(freq_resolution_tb-1 downto 0) := to_unsigned(98,freq_resolution_tb);
	signal pwm_o_tb: std_logic;
	
begin
	-- Señales de excitacion
	clk_i_tb <= not clk_i_tb after 10 ns;		
	rst_i_tb <= '1' after 5 ms, '0' after 10 ms;
	duty_cycle_i_tb <= to_unsigned(122,pwm_resolution_tb) after 10 ms, to_unsigned(200,pwm_resolution_tb) after 15 ms, to_unsigned(255,pwm_resolution_tb) after 25 ms;
	freq_divider_i_tb <= to_unsigned(200,freq_resolution_tb) after 20 ms;
	
	-- Instanciacion del componente a probar
	DUT: pwm
		generic map (
			pwm_resolution => pwm_resolution_tb,
			freq_resolution => freq_resolution_tb
		)
		port map(
			clk_i => clk_i_tb,
			rst_i => rst_i_tb,
			duty_cycle_i => duty_cycle_i_tb,
			freq_divider_i => freq_divider_i_tb,
			pwm_o => pwm_o_tb
		);
end;