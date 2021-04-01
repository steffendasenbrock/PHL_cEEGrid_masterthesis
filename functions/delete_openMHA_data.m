function [streams] = delete_openMHA_data(streams)

if(numel(streams.time_stamps)*streams.block_size*streams.buffer_size<numel(streams.time_series))


target_samples = numel(streams.time_stamps)*streams.buffer_size*streams.block_size;
streams.time_series(target_samples+1:end) = [];

elseif(numel(streams.time_stamps)*streams.block_size*streams.buffer_size>numel(streams.time_series))

    target_samples = numel(streams.time_series)/(streams.buffer_size*streams.block_size);
    streams.time_stamps(target_samples+1:end) = [];
    streams.clock_corrections(target_samples+1:end) = [];


end


end
