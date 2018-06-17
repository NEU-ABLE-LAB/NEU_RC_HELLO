function fig = pDemoFigure()
%PDEMOFIGURE return a handle to a figure that can be used for 
%the Parallel Computing Toolbox demos.

%   Copyright 2007 The MathWorks, Inc.

tag = 'pctDemoFigure';

fig = findobj('Tag', tag); 
if isempty(fig)
    fig = figure;
    set(fig, 'Tag', tag);
end
