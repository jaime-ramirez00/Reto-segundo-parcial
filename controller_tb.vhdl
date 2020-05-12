library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.ALL;

entity controller_tb  is
end controller_tb; 
architecture behavior of controller_tb is 
component controller
port(clk, reset, rs, rw_data: in bit; instr: in std_logic_vector(7 downto 0); rs_signal, rw_signal, enable_signal: out bit; data: out std_logic_vector(7 downto 0));
end component;
signal clk,reset,rs,rw_data : std_logic;
signal instr: std_logic_vector(7 downto 0);
signal rs_signal,rw_signal,enable_signal: std_logic;
signal data: std_logic_vector (7 downto 0);
constant clk_period : time := 5 ns;
BEGIN
uut: controller port map(
clk => clk,
reset => reset,
rs => rs,
rw_data => rw_data,
instr => instr,
rs_signal => rs_signal,
rw_signal => rw_signal, 
enable_signal => enable_signal,
data => data);
stimulus : process 
file fin : TEXT open READ_MODE is "input_test.txt";
file fout : TEXT open WRITE_MODE is "output.txt"; 
variable current_read_line : line;
variable current_read_field1 : string(1 to 4);
variable current_read_field2 : std_logic;
variable current_read_field3 : std_logic_vector(7 downto 0);
variable current_write_line : line;
begin
while (not endfile(fin)) loop
readline(fin, current_read_line);
read(current_read_line, current_read_field1);
if (current_read_field1(1 to 3) = string'("SIGUIENTE")) then 
wait for 10 ns;
if enable_signal='1'  and rs_signal='0' then
write(current_line, string'("instr("));
write(current_line, to_integer(signed(data)));
write(current_line, string'(");"));
writeline(fout, current_line);
elsif (enable_signal='1' and rs_signal = '1') then
write(current_line, string'("data("));
write(current_line, to_integer(signed(data)));
write(current_line, string'(");"));  
writeline(fout, current_line);
end if;
wait for 10 ns;
else if current_read_field1(1 to 3) = string'("DATA") then 
read(current_read_line, current_read_field3);
instr <= current_read_field3;
else 
read(current_read_line, current_read_field2);
if (current_read_field1(1 to 3) = string'("RST")) then  
reset <= current_read_field2;
elsif  current_read_field1(1 to 3) = string'("RW")  then
rw_data <= current_read_field2;
elsif  (current_read_field1(1 to 2) = string'("RS"))  then
rs <= current_read_field2;
else null;           
end if;
end if;
end if;   
end loop;
wait;
end process; 
clk_process :process
begin
clk <= '0';
wait for CLK_period/2;
clk <= '1';
wait for CLK_period/2;
end process;
END;