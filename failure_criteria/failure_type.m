function [ft] = failure_type(type, varargin)
% define the failure tyoe in fiber / matrix or transverse failure

% INPUT(S)
% type : failure criterion ('strs' for maximum stress / 'strn' for maximum strain)
% for maximum stress criterion varargin : 's', [s11, s22, s__x, s__y]
% for maximum strain criterion varargin : 'e', [e11, e22, e__x, e__y]

% originally coded by Amir Baharvand (08-20)

% parsing the output
p = inputParser;
addRequired(p,'type',@ischar);
addOptional(p,'e', [])
addOptional(p,'s', [])
parse(p, type, varargin{:})

switch p.Results.type
    case 'strs'
        
        s11 = p.Results.s(1);
        s22 = p.Results.s(2);
        s__x = p.Results.s(3);
        s__y = p.Results.s(4);
        
        if ( abs(s11) >= s__x )
            ft = 'Fiber';
        elseif ( abs(s22) >= s__y )
            ft = 'Matrix';
        else
            ft = 'Transverse';
        end
        
    case 'strn'
        
        e11 = p.Results.e(1);
        e22 = p.Results.e(2);
        e__x = p.Results.e(3);
        e__y = p.Results.e(4);
        
        if ( abs(e11) >= e__x )
            ft = 'Fiber';
        elseif ( abs(e22) >= e__y )
            ft = 'Matrix';
        else
            ft = 'Transverse';
        end
end