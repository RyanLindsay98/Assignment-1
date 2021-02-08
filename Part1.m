%% Constants %%

T =300;                  %Temp in K

K =1.38e-23;             %Boltsmann constant
Tmn =0.2e-12;            %mean time between collisions
Mo =9.11e-31;            %rest mass
Mn =0.26*Mo;             %effective mass of electrons
L =200e-09;               %Length of region
W =100e-09;               %Width of region
Pop =10;                %number of particles
Vth = sqrt((K*T)/(Mn));   %Thermal velocity    
Tstep = 15e-15;           %time step of 15ns
lengthE = 250;
Tv = 300 + zeros(lengthE);

%% Electron Modelling 

MFP = Tmn *Vth;

Ang = rand(Pop,1)*2*pi;  % Defines a random angle 

Pos = [rand(Pop,1)*L rand(Pop,1)*W Vth*cos(Ang) Vth*sin(Ang)];  %Creates an Array of particles with random X & Y positions and velocities 

initX = Pos(:,1); %The Initial X positions 

initY = Pos(:,2); % The initial Y positions 

colour = rand(Pop,1); % Ensures each electron will have its own colour 




for i = 1 : lengthE      % Main Loop of the Function 
    
    newX = initX + Pos(:,3)*Tstep;    % The next X position of the particle
    
    newY = initY + Pos(:,4)*Tstep;     % The next Y position of the particle
    
    
    % Checking for Top and Bottom bounds 
    
    Yhigh = newY > W;
    newY(Yhigh) = 2*W - newY(Yhigh); 
    Pos(Yhigh,4) = -Pos(Yhigh,4);
    
    Ylow = newY < 0;
    newY(Ylow) = -newY(Ylow);
    Pos(Ylow,4) = -Pos(Ylow,4);
    
    
    
    % Checking for Left and Right Bounds 
    
    
    Xright = newX > L;
    newX(Xright) = newX(Xright) -L;
    
    
    Xleft = newX < 0;
    newX(Xleft) = newX(Xleft) + L;
    
    
    
    
    
    
    % Plotting the movement of electrons
    
    figure(1)   
    
    scatter(initX,initY,Pop, colour,'x' );      
    hold on
    scatter(newX, newY,Pop, colour,'x' );      
    title 'Part 1: Electron Modelling'
    xlabel 'Length of Substrate'
    ylabel 'Width of Substrate' 
    
    axis([0 L 0 W]);
    
    
    
     
    
    
    
    hold on 
    
    %Re-initializing after 1 loop 
    initX = newX;
    initY = newY;
    
    
    
end
hold off 

figure(2)
    
plot(Tv)
title ' Avg Temperature '



