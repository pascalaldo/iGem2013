function d(message)
%D Simple debug function
try
    DEBUG = evalin('base', 'DEBUG');
    if DEBUG
        disp(message);
    end
end

end

