function data = importfile_fitbit_data(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   data = IMPORTFILE(FILENAME) Reads
%   data from text file FILENAME for the default selection.
%
%   data = IMPORTFILE(FILENAME, STARTROW,
%   ENDROW) Reads data from rows STARTROW through ENDROW of text file
%   FILENAME.
%
% Example:
%   data = importfile('treadmill_fitbit_september2020_step_8PCSZW.csv', 2, 1441);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2020/12/01 13:46:53

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column2: double (%f)
%	column3: double (%f)
%   column4: double (%f)
%	column5: double (%f)
%   column6: double (%f)
%	column7: double (%f)
%   column8: double (%f)
%	column9: double (%f)
%   column10: double (%f)
%	column11: double (%f)
%   column12: double (%f)
%	column13: double (%f)
%   column14: double (%f)
%	column15: double (%f)
%   column16: double (%f)
%	column17: double (%f)
%   column18: double (%f)
%	column19: double (%f)
%   column20: double (%f)
%	column21: double (%f)
%   column22: double (%f)
%	column23: double (%f)
%   column24: double (%f)
%	column25: double (%f)
%   column26: double (%f)
%	column27: double (%f)
%   column28: double (%f)
%	column29: double (%f)
%   column30: double (%f)
%	column31: double (%f)
%   column32: double (%f)
%	column33: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
data = table;
data.time = dataArray{:, 1};
data.d01 = dataArray{:, 2};
data.d02 = dataArray{:, 3};
data.d03 = dataArray{:, 4};
data.d04 = dataArray{:, 5};
data.d05 = dataArray{:, 6};
data.d06 = dataArray{:, 7};
data.d07 = dataArray{:, 8};
data.d08 = dataArray{:, 9};
data.d09 = dataArray{:, 10};
data.d10 = dataArray{:, 11};
data.d11 = dataArray{:, 12};
data.d12 = dataArray{:, 13};
data.d13 = dataArray{:, 14};
data.d14 = dataArray{:, 15};
data.d15 = dataArray{:, 16};
data.d16 = dataArray{:, 17};
data.d17 = dataArray{:, 18};
data.d18 = dataArray{:, 19};
data.d19 = dataArray{:, 20};
data.d20 = dataArray{:, 21};
data.d21 = dataArray{:, 22};
data.d22 = dataArray{:, 23};
data.d23 = dataArray{:, 24};
data.d24 = dataArray{:, 25};
data.d25 = dataArray{:, 26};
data.d26 = dataArray{:, 27};
data.d27 = dataArray{:, 28};
data.d28 = dataArray{:, 29};
data.d29 = dataArray{:, 30};
data.d30 = dataArray{:, 31};
data.d31 = dataArray{:, 32};

