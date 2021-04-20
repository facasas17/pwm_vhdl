library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm is
	generic(
			pwm_resolution: integer := 8;  -- Resolucion máxima del pwm
			freq_resolution: integer :=16  -- Resolucion máxima de la frecuencia del pwm
	);
	port(
		clk_i: in std_logic;
		--rst_i: in std_logic;
		--duty_cycle_i: in unsigned(pwm_resolution-1 downto 0);
		--freq_divider_i: in unsigned(freq_resolution-1 downto 0);
		pwm_o: out std_logic
	);
end;

architecture pwm_arq of pwm is

	-- Señales del sistema
	signal clk_cnt: unsigned(freq_resolution-1 downto 0) := (others => '0');
	signal aux_clk_o: std_logic := '0';
	signal aux_cnt_o: unsigned(pwm_resolution-1 downto 0) := (others => '0');
	
	signal rst_i: std_logic_vector(0 downto 0);
    signal duty_cycle_i: std_logic_vector(pwm_resolution-1 downto 0);
    signal freq_divider_i: std_logic_vector(freq_resolution-1 downto 0);
    signal pwm_aux: std_logic_vector(0 downto 0);
	
	--Declaración de los componentes VIO e ILA
    component vio_0
          port (
            clk : in STD_LOGIC;
            probe_out0 : out STD_LOGIC_VECTOR(0 downto 0);
            probe_out1 : out STD_LOGIC_VECTOR(7 downto 0);
            probe_out2 : out STD_LOGIC_VECTOR(15 downto 0)
          );
        end component;	
        
     component ila_0
        port (
        	clk : in STD_LOGIC;
        	probe0 : in STD_LOGIC_VECTOR(0 downto 0)
        );
        end component  ;
	
begin
	--Declaración de VIO
    your_instance_name : vio_0
      port map (
        clk => clk_i,
        probe_out0 => rst_i,
        probe_out1 => duty_cycle_i,
        probe_out2 => freq_divider_i
      );	
	--Declaración de ILA
	ila_inst : ila_0
      port map (
      	clk => clk_i,
      	probe0 => pwm_aux
      );
    
	--Divisor de clock del sistema
	CLK_DIVIDER: process(clk_i)
	begin
		if rising_edge(clk_i) then
			clk_cnt <= clk_cnt + 1;
			if clk_cnt = unsigned(freq_divider_i) then
				aux_clk_o <= not aux_clk_o;
				clk_cnt <= (others => '0');
			end if;
		end if;
	end process;
	
	--Contador para duty cycle, cuenta 1 pulso por flanco ascendente
	CONTADOR: process(aux_clk_o,rst_i)
	begin
		if (rst_i = "1") then
			aux_cnt_o <= (others => '0');
		elsif rising_edge(aux_clk_o) then
			aux_cnt_o <= aux_cnt_o + 1;
		end if;
	end process;
	
	--Salida del pwm
	PWM: process(aux_cnt_o, rst_i)
	begin
		if (rst_i = "1") then
			pwm_aux(0) <= '0';
		elsif (aux_cnt_o <= unsigned(duty_cycle_i)) then
				pwm_aux(0) <= '1';
			else pwm_aux(0) <= '0';
		end if;
	end process;
	
	pwm_o <= pwm_aux(0);

end;