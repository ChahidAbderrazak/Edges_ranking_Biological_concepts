import matplotlib.pyplot as plt
import pandas
import matlab.engine

#%% Run matlab function: Ctrl+\ 

eng = matlab.engine.start_matlab()
eng.cd('Matlab_scripts')
Outputs = eng.Run_matlab_script(2);
eng.quit()
print(Outputs)

#%% Scripts 
