function varargout = PCD(varargin)
% PCD MATLAB code for PCD.fig
%      PCD, by itself, creates a new PCD or raises the existing
%      singleton*.
%
%      H = PCD returns the handle to a new PCD or the handle to
%      the existing singleton*.
%
%      PCD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCD.M with the given input arguments.
%
%      PCD('Property','Value',...) creates a new PCD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PCD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PCD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PCD

% Last Modified by GUIDE v2.5 23-Mar-2019 21:26:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PCD_OpeningFcn, ...
                   'gui_OutputFcn',  @PCD_OutputFcn, ...
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


% --- Executes just before PCD is made visible.
function PCD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PCD (see VARARGIN)

% Choose default command line output for PCD
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PCD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PCD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in RGBtoHSV.
function RGBtoHSV_Callback(hObject, eventdata, handles)
% hObject    handle to RGBtoHSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global input
R=input(:,:,1);
G=input(:,:,2);
B=input(:,:,3);
R = double(R);
G = double(G);
B = double(B);

if max(max(R)) > 1.0 || max(max(G)) > 1.0 || ...
   max(max(B)) > 1.0
    R = double(R) / 255;
    G = double(G) / 255;
    B = double(B) / 255;
end

[tinggi, lebar] = size(R);
for m=1: tinggi
    for n=1: lebar
        minrgb = min([R(m,n) G(m,n) B(m,n)]); 
        maxrgb = max([R(m,n) G(m,n) B(m,n)]); 
        V(m,n) = maxrgb;
        delta = maxrgb - minrgb;
        if maxrgb == 0
            S(m,n) = 0;
            H(m,n) = 0; 
        else
            S(m,n) = delta / maxrgb;
            if R(m,n) == maxrgb
                % Di antara kuning dan magenta
                H(m,n) = (G(m,n)-B(m,n)) / delta;
            elseif G(m,n) == maxrgb
                % Di antara cyan dan kuning
                H(m,n) = 2 + (B(m,n)-R(m,n)) / delta;
            else
                % Di antara magenta dan cyan
                H(m,n) = 4 + (R(m,n)-G(m,n)) / delta;
            end
            
            H(m,n) = H(m,n) * 60;
            if H(m,n) < 0
                H(m,n) = H(m,n)+360;
            end
        end
    end
end

% Konversikan ke jangkauan [0, 255] atau [0, 360]
H = uint8(H * 255/360);
S = uint8(S * 255);
V = uint8(V * 255);
img(:,:,1)=H;
img(:,:,2)=S;
img(:,:,3)=V;
axes(handles.axes1)
imshow(img);



% --- Executes on button press in openFigure.
function openFigure_Callback(hObject, eventdata, handles)
% hObject    handle to openFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global input
[namafile, alamatfile] = uigetfile('*.*','Buka Gambar');
input = imread([alamatfile,namafile]);
axes(handles.axes1);
imshow(input);
