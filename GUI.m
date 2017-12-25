function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 19-Dec-2017 17:21:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;
handles.selectedWindow = Window.None;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in importBtn.
function importBtn_Callback(hObject, eventdata, handles)
% hObject    handle to importBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear all
evalin('base', 'clear');
evalin('base', 'clc');
axes(handles.fftAxes); cla;
axes(handles.lowFreqAxes); cla;
axes(handles.highFreqAxes); cla;

filename = uigetfile('.xlsx');
[folder, baseFileName, extension] = fileparts(filename);
handles.baseFileName = baseFileName(~isspace(baseFileName));

uiimport(filename);
handles.F_s = xlsread(filename, '', 'A9');

% Save the changes to the structure
guidata(hObject, handles);


% --- Executes on button press in plotFftBtn.
function plotFftBtn_Callback(hObject, eventdata, handles)
rawData = getRawData(handles, hObject);
if rawData == -1
    msgbox({'The selected data contains values that are NaN or empty cells.','Please select valid data.'}, 'Invalid data');
    return;
end
    
axes(handles.fftAxes);
% averageData = sgolayfilt(rawData, 3, 31);
% diffData = rawData - averageData;
[fftFreqVector, P1] = getfft(rawData, handles.F_s, handles.selectedWindow);
% [f, P1] = getfft(diffData, handles.F_s, handles.selectedWindow);
plot(fftFreqVector, P1);
title('Complete spectrum');
xlabel('f [Hz]');
ylabel('|magnitude|');

%------ifft test------
axes(handles.highFreqAxes);
hold on;
time_data = getIfft(fftFreqVector, P1, handles.LFLB, handles.LFUB);
t = 1:2:length(time_data)*2;
plot(t, 275*time_data); % 275 is an arbitrary factor just so the amplitudes would match :(



% --- Executes on button press in plotRawDataBtn.
function plotRawDataBtn_Callback(hObject, eventdata, handles)
rawData = getRawData(handles, hObject);
if rawData == -1
    msgbox({'The selected data contains values that are NaN or empty cells.', 'Please select valid data.'}, 'Invalid data');
    return;
end

axes(handles.lowFreqAxes);
hold on;
sampleVector = 1:length(rawData);
rawTimeVector = sampleVector;
plot(rawTimeVector, rawData);
xlabel('Samples');
ylabel('Deviation [cm]');



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
str = get(hObject, 'String');
val = get(hObject, 'Value');
switch str{val}
    case 'None'
        handles.selectedWindow = Window.None;
    case 'Bartlett'
        handles.selectedWindow = Window.Bartlett;
    case 'Blackman'
        handles.selectedWindow = Window.Blackman;
    case 'Boxcar'
        handles.selectedWindow = Window.Boxcar;
    case 'Hamming'
        handles.selectedWindow = Window.Hamming;
    case 'Hann'
        handles.selectedWindow = Window.Hann;
    case 'Taylor'
        handles.selectedWindow = Window.Taylor;
    case 'Triangle'
        handles.selectedWindow = Window.Triang;
    otherwise
        handles.selectedWindow = Window.None;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LFLBound_Callback(hObject, eventdata, handles)
% hObject    handle to LFLBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LFLB = str2double(get(hObject, 'String'));
% Save the changes to the structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function LFLBound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LFLBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LFUBound_Callback(hObject, eventdata, handles)
% hObject    handle to LFUBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LFUB = str2double(get(hObject, 'String'));
% Save the changes to the structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LFUBound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LFUBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function HFLBound_Callback(hObject, eventdata, handles)
% hObject    handle to HFLBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.HFLB = str2double(get(hObject, 'String'));
% Save the changes to the structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function HFLBound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HFLBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function HLFUBound_Callback(hObject, eventdata, handles)
% hObject    handle to HLFUBound (see GCBO)
handles.HFUB = str2double(get(hObject, 'String'));
% Save the changes to the structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function HLFUBound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HLFUBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Gets the raw data in the correct format. If the data contains NaN
% values, -1 gets returned.
function [data] = getRawData(handles, hObject)
%     % Get the data from the base scope and convert it to an array (uiimport
%     % uses table as standard).
%     data = table2array(evalin('base', handles.baseFileName));
%     
%     % If the data contains NaN values, return -1.
%     if any(isnan(data) == 1)
%     data = -1;
    


    % SAMPLE DATA (two sines: 50Hz and 120Hz)
    Fs = 1000;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    L = 500;             % Length of signal
    t = (0:L-1)*T;        % Time vector
    window = 4;

    S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
    data = S;% + 2*randn(size(t));
    
    handles.F_s = 1000;
    guidata(hObject, handles);
% end
