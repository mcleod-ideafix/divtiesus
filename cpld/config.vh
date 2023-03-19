//    This file is part of the ZXUNO Spectrum core.
//    Creation date is 18:39:21 2020-02-09 by Miguel Angel Rodriguez Jodar
//    (c)2014-2020 ZXUNO association.
//    ZXUNO official repository: http://svn.zxuno.com/svn/zxuno
//    Username: guest   Password: zxuno
//    Github repository for this core: https://github.com/mcleod-ideafix/zxuno_spectrum_core
//
//    ZXUNO Spectrum core is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    ZXUNO Spectrum core is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with the ZXUNO Spectrum core.  If not, see <https://www.gnu.org/licenses/>.
//
//    Any distributed copy of this file must keep this notice intact.

// ZXUNO address/data I/O ports for indirect access to ZXUNO registers
  localparam
    IOADDR = 16'hFC3B,
    IODATA = 16'hFD3B;

// ZXUNO registers for UART (wifi module) handling
  localparam UARTDATA = 8'hC6,
             UARTSTAT = 8'hC7;

// ZXUNO register for I2C master (bit-bang)
  localparam I2CREG = 8'hF8;
             

