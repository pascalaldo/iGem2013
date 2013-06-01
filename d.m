function d(message)
%d Simple debug function
try
    DEBUG = evalin('base', 'DEBUG');
    if DEBUG
        disp(message);
    end
end

end

