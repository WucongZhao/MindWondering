function data = importfile_heartbeat_data(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   data = IMPORTFILE(FILENAME)
%   Reads data from text file FILENAME for the default selection.
%
%   data = IMPORTFILE(FILENAME,
%   STARTROW, ENDROW) Reads data from rows STARTROW through ENDROW of text
%   file FILENAME.
%
% Example:
%   data = importfile('treadmill_fitbit_september2020_heartbeat_7V2PDF.csv', 2, 1441);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2021/01/21 11:27:03

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';

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

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
data = table;
data.time = cell2mat(raw(:, 1));
data.d01 = cell2mat(raw(:, 2));
data.d02 = cell2mat(raw(:, 3));
data.d03 = cell2mat(raw(:, 4));
data.d04 = cell2mat(raw(:, 5));
data.d05 = cell2mat(raw(:, 6));
data.d06 = cell2mat(raw(:, 7));
data.d07 = cell2mat(raw(:, 8));
data.d08 = cell2mat(raw(:, 9));
data.d09 = cell2mat(raw(:, 10));
data.d10 = cell2mat(raw(:, 11));
data.d11 = cell2mat(raw(:, 12));
data.d12 = cell2mat(raw(:, 13));
data.d13 = cell2mat(raw(:, 14));
data.d14 = cell2mat(raw(:, 15));
data.d15 = cell2mat(raw(:, 16));
data.d16 = cell2mat(raw(:, 17));
data.d17 = cell2mat(raw(:, 18));
data.d18 = cell2mat(raw(:, 19));
data.d19 = cell2mat(raw(:, 20));
data.d20 = cell2mat(raw(:, 21));
data.d21 = cell2mat(raw(:, 22));
data.d22 = cell2mat(raw(:, 23));
data.d23 = cell2mat(raw(:, 24));
data.d24 = cell2mat(raw(:, 25));
data.d25 = cell2mat(raw(:, 26));
data.d26 = cell2mat(raw(:, 27));
data.d27 = cell2mat(raw(:, 28));
data.d28 = cell2mat(raw(:, 29));
data.d29 = cell2mat(raw(:, 30));
data.d30 = cell2mat(raw(:, 31));
data.d31 = cell2mat(raw(:, 32));

