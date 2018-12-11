function dy  = odefunction_lin(t, y, varargin)
%% Param�tres

% Invariants
nbr_entrees = 3;
nbr_var = 4;

% Variables
m = 2500;
l = 6;
c_y = 25;
c_theta = 300;
K = 1000;
w = 3;
A_par_def = 27500;

%% odefunction_lin

%   Description :

%   Calcule les d�riv�es directes d'une s�rie de variables � partir d'un syst�me d'�quations diff�rentielles.

%   Entr�e(s) :

%   # t est le temps donn�.
%   # y est la matrice de nbr_var lignes donn�e.
%     Elle contient [y; y'; theta; theta'].
%   # A (ou varargin{1}) est l'amplitude du vent donn�e.
%     Par d�faut, si elle n'est pas entr�e ou si elle est vide,
%     A = A_par_def.

%   Sortie(s) :

%   # dy est la matrice de nbr_var lignes sortie.
%     Elle contient [y'; y''; theta'; theta''].

%% V�rifications des entr�es

if (nargin > nbr_entrees)
    error('Trop d''entr�es');
end

if (nargin < nbr_entrees)
    A = A_par_def;
    if (nargin < nbr_entrees - 1)
        error('Trop peu d''entr�es');
    end
else
    A = varargin{1};
end

if (isempty(t) || isempty(y))
    error('Entr�e(s) n�cessaire(s) vide(s).');
end

if (size(y, 1) < nbr_var)
    error('Trop peu de lignes dans la seconde entr�e.');
end

% D�but - Normalisation de la taille des entr�es et valeurs par d�faut
t = t(1);
y = y(1:nbr_var, :);

if (isempty(A))
    A = A_par_def;
else
    A = A(1);
end
% Fin - Normalisation de la taille des entr�es et valeurs par d�faut

if (isnan(t) || isreal(t) == 0 || isnan(A) || isreal(A) == 0)
    warning('Entr�e(s) non r�elle(s).');
end

for i = 1:nbr_var
    for j = 1:size(y, 2)
        if (isnan(y(i, j)) || isreal(y(i, j)) == 0)
            warning('Entr�e(s) non r�elle(s).');
        end
    end
end

%% Syst�me

% Initialisation de dy
dy = zeros(nbr_var, size(y, 2));

% Le syst�me
dy(1, :) = y(2, :);
dy(2, :) = (A * sin(w * t) - 2 * K * y(1, :) - c_y * y(2, :)) / (m);
dy(3, :) = y(4, :);
dy(4, :) = (3 * K * l^2 * sin(2 * y(3, :)) + 3 * c_theta * y(4, :)) / (- m * l^2);

end

