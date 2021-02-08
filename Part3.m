clear

%% Constants %%

T =300;                  %Temp in K
K =1.38e-23;             %Boltsmann constant
Tmn =0.2e-12;            %mean time between collisions
Mo =9.11e-31;            %rest mass
Mn =0.26*Mo;             %effective mass of electrons
L =200e-09;               %Length of region
W =100e-09;               %Width of region
Pop =35;                %number of particles
Vth = sqrt((K*T)/(Mn));   %Thermal velocity    
Tstep = 15e-15;           %time step of 15ns
lengthE = 50;


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




%%%% NEW to Part 3 %%%%%%

% Need to assign position outside of Boundaries 

Bounds = ((Pos(:,1)>= L/3)&(Pos(:,1)<= 2*L/3)&(Pos(:,2)<= W/3)) | ((Pos(:,1)>= L/3)&(Pos(:,1)<= 2*L/3)& (Pos(:,2)>= 2*W/3));

 while (sum(Bounds)>1)
     
           initX(Bounds)=initX(Bounds) .*rand();                           %randomize the electrons initialized inside the box
           
           initY(Bounds)=initY(Bounds) .*rand();
           
           
           Bounds = (initX>=L/4 & initX <=2*L/3 & initY <= W/3) | (initX>=L/4 & initX <=2*L/3 & initY >= 2*W/3); %check once again for electrons initialized inside the box.
       end



for i = 1 : lengthE      % Main Loop of the Function 
    
    
    % Probability of scattering 
    
    P = rand(Pop,1) < Pscat;
    
    Pos(P,3:4) = random(probV, [sum(P),2]);
    
    
    % Finding velocity and Temperature 
    Velo = sqrt(sum(Pos(:,3).^2)/Pop + sum(Pos(:,4).^2)/Pop);
    
    newT = T + ((Mn * (Velo.^2) )/K/Pop/2);
    
    
    newX = initX + Pos(:,3)*Tstep;    % The next X position of the particle
    
    newY = initY + Pos(:,4)*Tstep;     % The next Y position of the particle
    
    
    
    %%%%% Check for Specular vs Diffusion %%%%%%%%%
    
     
    if rand () > 0.5   % Specular: Use Standard Code outside of boxes 
        
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
    
    
    
    % Checking for Box collisions 
    
    
    bCol = (newX>=L/3 & newX <=2*L/3 & newY <= W/3) | (newX>=L/3 & newX <=2*L/3 & newY >= 2*W/3); % Definition of the two boxes
    
    
    if sum(bCol) ~= 0       % if bCol contains a value, we have an electron at a barrier 
        
        if ((newX(bCol) >= L/3) & newX(bCol) <= 2*L/3);     % Checking X plane 
            Pos(bCol,4) = -Pos(bCol,4);
            
            
        else
            Pos(bCol,3) = -Pos(bCol,3);    % Checking Y plane 
            
            
        end
    end
    
        
       
          % Diffusive: Need to adjust for random velocity change 
    
    
    
    else
    
        % Checking for Top and Bottom bounds 
    
    Yhigh = newY > W;
    newY(Yhigh) = 2*W - newY(Yhigh); 
    Pos(Yhigh,3)=Vth*cos(randn()*2*pi);
    Pos(Yhigh,4)=Vth*sin(randn()*2*pi);
    
    
    
    
    Ylow = newY < 0;
    newY(Ylow) = -newY(Ylow);
    Pos(Ylow,3)=Vth*cos(randn()*2*pi);
    Pos(Ylow,4)=Vth*sin(randn()*2*pi);
    
    
    
    % Checking For Box Values 
    
        bCol = (newX>=L/3 & newX <=2*L/3 & newY <= W/3) | (newX>=L/3 & newX <=2*L/3 & newY >= 2*W/3); % Definition of the two boxes
    
    
    if sum(bCol) ~= 0       % if bCol contains a value, we have an electron at a barrier 
        
        if ((newX(bCol) >= L/3) & newX(bCol) <= 2*L/3);     % Checking X plane 
            Pos(bCol,4) = -Pos(bCol,4);
            Pos(bCol,3)=Vth*cos(randn()*2*pi);
            Pos(bCol,4)=Vth*sin(randn()*2*pi);
            
        else
            Pos(bCol,3) = -Pos(bCol,3);    % Checking Y plane 
            Pos(bCol,3)=Vth*cos(randn()*2*pi);
            Pos(bCol,4)=Vth*sin(randn()*2*pi);
            
        end
    end
        
        
        
    
    %Avg Temp Calc
    sumT = sumT + newT;
    
    avgT = sumT/i;
    
    

    % Plotting the movement of electrons
    
    figure(1)   
    
    scatter(initX,initY,Pop, colour,'x' );      
    hold on
    scatter(newX, newY,Pop, colour,'x' );          
    rectangle( 'Position', [L/3 0 L/3 W/3])
    rectangle('Position', [L/3 2*W/3 L/3 W/3])
    title 'Part 3'
    xlabel 'Length of Substrate'
    ylabel 'Width of Substrate'     
    axis([0 L 0 W]);
    
    
    
   
    
    %Re-initializing after 1 loop 
    initX = newX;
    initY = newY;
    initT = newT;
   
    
end


end


% Density Plot 

n = 10; % Number of grid points 

[X Y] = meshgrid(0:L/n:L,0:W/n:W);  % Create a Grid 

Den = zeros(n+1,n+1);
Temp = zeros(n+1,n+1);

countT = 0;
countD = 0;

for i = 1:n
    
    
    XP1 = X(1,i);       
    XP2 = X(1,i+1);
    
    for j = 1:n
        
        YP1 = Y(j,1);
        YP2 = Y(j+1, 1);
        
        
          %check each frame
            for k=1:Pop
                
                if((Pos(k,1)>XP1 & Pos(k,1)<XP2) & Pos(k,2)<YP2 & Pos(k,2)>YP1)
                    
                    countT = countT+1;    
                    
                    Den(i,j) = Den(i,j)+1;      
                    
                    countD = countD + sqrt(Pos(k,3)^2+Pos(k,4)^2);  
                    
                    
                    if(countT >0)
                        Temp(i,j)=Mn*(countD^2)/(countT)/K/2;         
                    end
                end
            end
            
          %  countD=0;
           % countT=0;
    end
        
    
end

%density map
    figure(3)
    surf(X,Y,Den)
    title 'Electron Density Map';
    zlabel 'Number of Electrons per Grid Point';
    ylabel 'Y Coordinate';
    xlabel 'X coordinate';
    
    
    
    %temperature map
    figure(4)
    surf(X,Y,Temp)
    title 'Temperature Density Map';
    zlabel 'Temperature per Grid Point';
    ylabel 'Y Coordinate';
    xlabel 'X coordinate';













