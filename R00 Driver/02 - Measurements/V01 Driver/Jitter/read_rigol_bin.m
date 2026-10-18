function wave = read_rigol_bin(filename)
% READ_RIGOL_BIN  Parse a Rigol scope .bin waveform export (RG03 format)
    fid = fopen(filename, 'r', 'l');  % little-endian
    if fid == -1
        error('Could not open file: %s', filename);
    end
    cleanupObj = onCleanup(@() fclose(fid));

    % --- File header ---
    cookie   = fread(fid, 4, '*char')';    % 'RG03'
    fileSize = fread(fid, 1, 'int64');     % 8 bytes, not 4!
    nWaves   = fread(fid, 1, 'int32');

    fprintf('Cookie: %s | FileSize: %d | Waveforms: %d\n', cookie, fileSize, nWaves);

    wave = struct([]);
    for w = 1:nWaves
        hdrStart = ftell(fid);

        headerSize     = fread(fid, 1, 'int32');
        waveformType   = fread(fid, 1, 'int32');
        nBuffers       = fread(fid, 1, 'int32');
        nPoints        = fread(fid, 1, 'int32');
        avgCount       = fread(fid, 1, 'int32');
        xDisplayRange  = fread(fid, 1, 'double');  % was float32 -- this was the bug
        xDisplayOrigin = fread(fid, 1, 'double');
        xIncrement     = fread(fid, 1, 'double');
        xOrigin        = fread(fid, 1, 'double');
        xUnits         = fread(fid, 1, 'int16');
        yUnits         = fread(fid, 1, 'int16');
        dateStr        = strtrim(fread(fid, 16, '*char')');
        timeStr        = strtrim(fread(fid, 16, '*char')');
        frameStr       = strtrim(fread(fid, 24, '*char')');   % model:serial
        labelStr       = strtrim(fread(fid, 16, '*char')');   % e.g. CH1

        % Jump to the declared end of this header -- covers ~12 bytes
        % after 'label' that I can't identify yet (likely yIncrement/
        % yOrigin/yResolution or padding), so no need to guess them.
        fseek(fid, hdrStart + headerSize, 'bof');

        % --- Buffer header ---
        bufHeaderSize = fread(fid, 1, 'int32');
        bufType       = fread(fid, 1, 'int16');
        bytesPerPoint = fread(fid, 1, 'int16');
        bufSize       = fread(fid, 1, 'int64');  % bytes of sample data

        nSamples = bufSize / bytesPerPoint;
        y = fread(fid, nSamples, 'float32=>double');
        t = xOrigin + (0:double(nSamples)-1)' * xIncrement;

        wave(w).channel    = labelStr;
        wave(w).model      = frameStr;
        wave(w).date       = dateStr;
        wave(w).time       = timeStr;
        wave(w).nPoints    = nPoints;
        wave(w).xIncrement = xIncrement;
        wave(w).xOrigin    = xOrigin;
        wave(w).t = t;
        wave(w).y = y;
    end
end