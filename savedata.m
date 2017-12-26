function savedata(filename, original, lf, hf, window, comment, LFLB, LFUB, HFLB, HFUB)
    if exist(filename, 'file') == 2
        delete(filename);
    end
    xlswrite(filename, {'Comment', char(comment)}, 1, 'A1');
    xlswrite(filename, {'Window', char(window)}, 1, 'A2');
    xlswrite(filename, {'Low frequency', 'Lower bound', int2str(LFLB); '', 'Upper bound', int2str(LFUB)}, 1, 'A3');
    xlswrite(filename, {'High frequency', 'Lower bound', int2str(HFLB); '', 'Upper bound', int2str(HFUB)}, 1, 'A5');
    
    xlswrite(filename, {'Original', 'LF', 'HF'}, 1, 'A8');
    xlswrite(filename, original, 1, 'A9');
    xlswrite(filename, lf, 1, 'B9');
    xlswrite(filename, hf, 1, 'C9');
end