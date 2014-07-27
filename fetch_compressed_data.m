%% Description 
% The fetch_compressed_data.m downloads complressed data from the site at the 
% "site_address" and uncompress them at the local folder defined by
% "data_dest". The supported compressed files are the following:
% (1)*.zip, (2)*.tar, (3)*.gz and (4) By defining the "data_suffix" any 
% file with the specific suffix will be downloaded but also you have to 
% define what you want to do with the specific dataset.
%
%% Input 
% # data_source   : web address                                   string
% # data_dest     : local folder                                  string
% # data_suffix   : suffix of the data that you want to download  cell
% # stations      : station names                                 cell
% # period        : [starting year, end year]                     2X1 array
%
% The only necessary information is the data_source, at this case all the
% zip, tar and gz files of the data_source will be uncompressed at you
% actual matlab path... Hoho. 
%% Example
% Poor student wants to download the historical dataset of NDBC buoy 41002 
% for the years 2001-2004. He has done his homework and he knows that the
% website with the data is:
% "http://www.ndbc.noaa.gov/data/historical/stdmet/"
% the datasets are compressed with gzip (.gz) and his working path is: 
% "D:\Users\poor_student\Documents\another_crappy_task\"
% So he use his matlab command window and types the following:
%
% fetch_compressed_data('http://www.ndbc.noaa.gov/data/historical/stdmet/','D:\Users\poor_student\Documents\another_crappy_task\', {'.gz'}, {'41002'},[2001,2004])
%% Credits
% Author        : Stylianos -Stelios- Flampouris
% Comunication  : stylianos.flampouris@gmail.com
% version       : 0.99
% Date          : 26th Jul 2014
%
% Copyright (C) 2014 Flampouris
% Stylianos Flampouris
%
% SSC, MS, USA, Earth
%       
% This library is free software: you can redistribute it and/or
% modify it under the terms of the GNU Lesser General Public
% License as published by the Free Software Foundation, either
% version 2.1 of the License, or (at your option) any later version.
%
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Lesser General Public License for more details.
%
% For a copy of the GNU Lesser General Public License, 
% see <http://www.gnu.org/licenses/>.
%% The Code
function fetch_compressed_data (data_source, data_dest, data_suffix, station, period)
tic;
% # Check the input arguments
narg = nargin;
if narg == 0;
    error('You have to define the website with the data')
elseif narg == 1
    data_dest = pwd;
    data_suffix = {'.zip','.tar','.gz'};
    station{1} = [];
    period =[];
elseif narg == 2
    data_suffix = {'.zip','.tar','.gz'};
    station{1} = [];
    period =[];
elseif narg == 3
    data_suffix{1} = data_suffix(1:end);
    station{1} = [];
    period =[];
elseif narg == 4
    period = [];
elseif narg == 5
    period = period(1):period(2);
end
 disp(['Data of the following types: ', data_suffix{1:end}, ' will be uncompressed at ', data_dest])
%
% # Download data_source content to MATLAB string
str = urlread(data_source);
%
% # Check which kind and how many files exist 
cnt = 1;
for i1 = 1:1:length(data_suffix)
    for i2 = 1:1:length(station)
        for i3 = 1:1:length(period)
%             fn{i1,i2,i3} = regexpi(str,[station{i2},'[A-Z_0-9]+',num2str(period(i3)),'+.txt',data_suffix{i1}],'match')
            fn{cnt} = regexpi(str,[station{i2},'[A-Z_0-9]+',num2str(period(i3)),'+.txt',data_suffix{i1}],'match');
            fn{cnt} = unique(fn{cnt});
            cnt = cnt + 1;
        end
    end
end
fn = fn';
for i1 = 1:1:length(fn)
    for i2 = 1:1:length(fn{i1})
        file = fn{i1,i2};  
        file = [data_source,file{1}];
         if ~isempty(strfind(file,'.gz'))
              gunzip(file,data_dest)
         elseif ~isempty(strfind(file,'.zip'))
              unzip(file,data_dest)
         elseif ~isempty(strfind(file,'.tar'))
              untar(file,data_dest)
         else
             error('I don''t know what to do with these data, please modify this line and I will serve you. Thank you.')
         end
    end
end
end

