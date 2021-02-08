clear

%% Constants %%

T =300;                  %Temp in K
K =1.38e-23;             %Boltsmann constant
Tmn =0.2e-12;            %mean time between collisions
Mo =9.11e-31;            %rest mass
Mn =0.26*Mo;             %effective mass of electrons
L =200e-09;               %Length of region
W =100e-09;               %Width of region
Pop =50;                %number of particles
Vth = sqrt((K*T)/(Mn));   %Thermal velocity    
Tstep = 15e-15;           %time step of 15ns
lengthE = 25;


%% Electron Modelling 

MFP = Tmn *Vth;

Ang = rand(Pop,1)*2*pi;  % Defines a random angle 

Pos = [rand(Pop,1)*L rand(Pop,1)*W Vth*cos(Ang) Vth*sin(Ang)];  %Creates an Array of particles with random X & Y positions and velocities 

initX = Pos(:,1); %The Initial X positions 

initY = Pos(:,2); % The initial Y positions 

colour = rand(Pop,1); % Ensures each electron will have its own colour 



%%%%% NEW to Part 2 %%%%%%%%%


initT = T; 

Pscat = 1- exp(-Tstep/Tmn);

Velo = sqrt(sum(Pos(:,3).^2)/Pop + sum(Pos(:,4).^2)/Pop);

probV = makedist('Normal', 'mu', 0, 'sigma', sqrt(K*T/Mn));

sumT = 0;



for i = 1 : lengthE      % Main Loop of the Function 
    
    
    % Probability of scattering 
    
    P = rand(Pop,1) < Pscat;
    
    Pos(P,3:4) = random(probV, [sum(P),2]);
    
    
    % Finding velocity and Temperature 
    Velo = sqrt(sum(Pos(:,3).^2)/Pop + sum(Pos(:,4).^2)/Pop);
    
    newT = T + ((Mn * (Velo.^2) )/K/Pop/2);
    
   
    
    
    %Avg Temp Calc
    sumT = sumT + newT;
    
    avgT = sumT/i;
    
    
    
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
    
    
    
    
    
    avgV=mean(sqrt(Pos(:,3).^2 + Pos(:,4).^2));
    MFP=(avgV*i)/1000000;
    
    
    % Plotting the movement of electrons
    
    figure(1)   
    
    scatter(initX,initY,Pop, colour,'o' );      
    hold on
    scatter(newX, newY,Pop, colour,'o' );          
     title (['Part 2: avg MFP= ', num2str(MFP),'e^-6'])
    xlabel 'Length of Substrate'
    ylabel 'Width of Substrate' 
    axis([0 L 0 W]);
    
    
    
    
    
    
    %Re-initializing after 1 loop 
    initX = newX;
    initY = newY;
    initT = newT;
    
    
    
    figure (2)
    
    scatter(i, initT, 'k')
    hold on
    scatter(i, newT, 'k')
    hold on 
    title (['Average Temperature ', num2str(avgT),'K'])
    
    axis([0 lengthE 200 400])
end

    %Histogram X velocity
    figure(3)
    histogram(Pos(:,3),Pop);
    title ('Velocity in X Plane');
    xlabel 'Velocity'
    ylabel 'Number of Electrons'
    ylim([0 20])
    
    
    % Histogram Y velocity 
    figure(4)
    histogram(Pos(:,4), Pop);
    title ('Velocities in Y Plane');
    xlabel 'Velocity'
    ylabel 'Number of Electrons'
    ylim([0 20])







hold off 