library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

entity pwm_tb is
end;

architecture pwm_tb_arq of pwm_tb is

	-- Declaracion de componente
	component pwm is
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
	end component;
	
	constant divider_cnt_tb: integer := 25000;
	constant pwm_resolution_tb: integer := 4;

	-- Señales de prueba
	signal clk_i_tb: std_logic := '0';
	signal rst_i_tb: std_logic := '0';
	signal duty_cycle_i_tb: unsigned(pwm_resolution_tb-1 downto 0) := to_unsigned(0,pwm_resolution_tb);
	signal cnt_o_tb: unsigned(pwm_resolution_tb-1 downto 0);
	signal clk_o_tb: std_logic;
	signal pwm_o_tb: std_logic;
	
begin
	-- Señales de excitacion
	clk_i_tb <= not clk_i_tb after 10 ns;		
	--rst_i_tb <= '0' after 10 ns;
	duty_cycle_i_tb <= 	to_unsigned(8,pwm_resolution_tb);
	
	-- Instanciacion del componente a probar
	DUT: pwm
		generic map (
			divider_cnt => divider_cnt_tb,
			pwm_resolution => pwm_resolution_tb
		)
		port map(
			clk_i => clk_i_tb,
			rst_i => rst_i_tb,
			duty_cycle_i => duty_cycle_i_tb,
			cnt_o => cnt_o_tb,
			clk_o => clk_o_tb,
			pwm_o => pwm_o_tb
		);
	
end;