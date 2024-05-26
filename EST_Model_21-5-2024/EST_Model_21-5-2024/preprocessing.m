% Pre-processing script for the EST Simulink model. This script is invoked
% before the Simulink model starts running (initFcn callback function).

%% Load the supply and demand data

timeUnit   = 's';

supplyFile = "Team49_supply.csv";
supplyUnit = "kW";
% load the supply data
Supply = loadSupplyData(supplyFile, timeUnit, supplyUnit);

demandFile = "Team49_demand.csv";
demandUnit = "kW";
% load the demand data
Demand = loadDemandData(demandFile, timeUnit, demandUnit);



%% Simulation settings

deltat = 5 * 60; % 5 minutes converted to seconds
stopt  = min([Supply.Timeinfo.End, Demand.Timeinfo.End]);

%% System parameters

% transport from supply
aSupplyTransport = 0.01; % Dissipation coefficient

% injection system
aInjection = 0.1; % Dissipation coefficient

% Parameters for the equation EStorageMax
P1 = 2757902.9173;  % Initial pressure (Output of the compressor in Pa)
V1 = 2.9;    % Initial volume (Vessel)
P2 = 21000000;   % Final pressure (Output of the expander in Pa)
V2 = 2.9;   % Final volume (example value, in some ppropriate unit)
gamma = 1.40167; % constant

% Calculate EStorageMax using the provided formula
Eformula = (P1 * V1 - P2 * V2) / (gamma - 1);

% storage system
EStorageMax     = Eformula.*unit("kWh"); % Maximum energy
EStorageMin     = 0.0*unit("kWh"); % Minimum energy
EStorageInitial = 2.0*unit("kWh"); % Initial energy
bStorage        = 1e-6/unit("s");  % Storage dissipation coefficient

%Heat exchanger
Inlet_compressed_air = 533.167*unit("K") 
Inlet_molten_salt = 298.0*unit("K");
Outlet_compressed_air = 298.0*unit("K");
Outlet_molten_salt = 533.167*unit("K")

% extraction system
aExtraction = 0.1; % Dissipation coefficient

% transport to demand
aDemandTransport = 0.01; % Dissipation coefficient