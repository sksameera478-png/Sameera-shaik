library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_uart is
end tb_uart;

architecture sim of tb_uart is
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    signal tx_start : STD_LOGIC := '0';
    signal tx_data : STD_LOGIC_VECTOR(7 downto 0) := x"41"; -- 'A'
    signal tx, rx : STD_LOGIC;
    signal tx_busy : STD_LOGIC;
    signal rx_data : STD_LOGIC_VECTOR(7 downto 0);
    signal rx_done : STD_LOGIC;
    
    constant CLK_PERIOD : time := 20ns; -- 50MHz
begin
    uut: entity work.uart 
    Generic map (CLK_FREQ => 50000000, BAUD_RATE => 9600)
    Port map (clk, rst, tx_start, tx_data, tx, tx_busy, rx, rx_data, rx_done);
    
    rx <= tx; -- Loopback: connect TX to RX
    
    clk_process: process begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;
    
    stim_proc: process begin
        wait for 100ns; rst <= '0';
        wait for 100ns;
        
        -- Test 1: Send 'A' = 0x41 = 01000001
        tx_data <= x"41"; tx_start <= '1'; wait for 20ns; tx_start <= '0';
        wait until rx_done = '1';
        report "RX Received: " & integer'image(to_integer(unsigned(rx_data)));
        assert rx_data = x"41" report "Test 1 Failed" severity error;
        
        -- Test 2: Send 'B' = 0x42 at different baud would need new sim
        tx_data <= x"42"; tx_start <= '1'; wait for 20ns; tx_start <= '0';
        wait until rx_done = '1';
        assert rx_data = x"42" report "Test 2 Failed" severity error;
        
        report "All Tests Passed";
        wait;
    end process;
end sim;
