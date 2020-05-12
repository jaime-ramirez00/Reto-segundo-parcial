library IEEE;
use IEEE.std_logic_1164.all;
entity controller is 
port(clk, reset, rs, rw_data: in bit; instr: in std_logic_vector(7 downto 0); rs_signal, rw_signal, enable_signal: out bit; data: out std_logic_vector(7 downto 0));
end entity;
architecture behavior of controller is
type estado is(espera, listo);
signal actual: estado;
begin
process(clk)
variable tiempo: integer:=0;
begin
if clk'event and clk='1' then
case actual is
when espera=> if rw_data='1' and reset='0' then
rs_signal<=rs;
rw_signal<=rw_data;
data<=instr;
actual<=listo;
else
rs_signal<='0';
rw_signal<='0';
enable_signal<='0';
data<="00000000"; end if;
when listo=> 
if (tiempo <= 8) then tiempo := tiempo + 1;
enable_signal<='1';
else 
enable_signal <='0';
tiempo :=0;
actual<=espera;
end if;
end case;
end if;
end process;
end behavior;
