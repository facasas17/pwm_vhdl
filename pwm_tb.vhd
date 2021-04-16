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
				pwm_resolution: integer := 8   -- Resolucion máxima del pwm
		);
		port(
			clk_i: in std_logic;
			rst_i: in std_logic;
			duty_cycle_i: in unsigned(pwm_resolution-1 downto 0);
			divider_cnt_i: in unsigned(15 downto 0);
			pwm_o: out std_logic
		);
	end component;
	
	constant duty_cycle_aux: integer := 122;
	constant pwm_resolution_tb: integer := 8;

	-- Señales de prueba
	signal clk_i_tb: std_logic := '0';
	signal rst_i_tb: std_logic := '0';
	signal duty_cycle_i_tb: unsigned(pwm_resolution_tb-1 downto 0) := to_unsigned(122,pwm_resolution_tb);
	signal divider_cnt_i_tb: unsigned(15 downto 0) := to_unsigned(2500,16);
	signal pwm_o_tb: std_logic;
	
begin
	-- Señales de excitacion
	clk_i_tb <= not clk_i_tb after 10 ns;		
	--rst_i_tb <= '0' after 10 ns;
	duty_cycle_i_tb <= 	to_unsigned(duty_cycle_aux,pwm_resolution_tb);
	
	-- Instanciacion del componente a probar
	DUT: pwm
		generic map (
			pwm_resolution => pwm_resolution_tb
		)
		port map(
			clk_i => clk_i_tb,
			rst_i => rst_i_tb,
			duty_cycle_i => duty_cycle_i_tb,
			divider_cnt_i => divider_cnt_i_tb,
			pwm_o => pwm_o_tb
		);
	
end;