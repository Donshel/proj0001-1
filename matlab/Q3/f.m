function tens = f(A, alpha)
%% Param�tres

% Invariants
nbr_entrees = 2;

% Variables
t = [0 1000];
y0 = [0 0 0.002 0];
nbr_pt = 2;
RelTol = 1e-7;
AbsTol = 1e-6;
K = 1000;
l = 6;

%% f

%   Description :

%   Trouve la tension maximale dans les cables associ�e � une amplitude du vent et un
%   param�tre du mod�le du c�ble.

%   Entr�e(s) :

%   # A est l'amplitude du vent donn�e.
%   # alpha est le param�tre du mod�le du c�ble.

%   Sortie(s) :

%   # tens est la tension maximale sortie.

%% V�rifications des entr�es

if (nargin < nbr_entrees)
    error('Trop peu d''entr�es.');
end

if (isempty(A) || isempty(alpha))
    error('Entr�e(s) n�cessaire(s) vide(s).');
end

% D�but - Normalisation de la taille des entr�es
A = A(:, 1);
alpha = alpha(1);
% Fin - Normalisation de la taille des entr�es

if (isnan(A) || isreal(A) == 0 || isnan(alpha) || isreal(alpha) == 0)
    warning('Entr�e(s) non r�elle(s).');
end

%% Calculs et sortie

% Calcul des positions
OdeSet = odeset('RelTol', RelTol, 'AbsTol', AbsTol);
[T, Y] = ode15s(@(t, y)odefunction_nl(t, y, A, alpha), t, y0, OdeSet);

% Initialisation de val_1 et val_2
val_1 = alpha * Y(:, 1);
val_2 = alpha * sin(Y(:, 3)) * l;

% Calcul des tensions
f_y_plus = abs(K / alpha * (exp(val_1 + val_2) - 1));
f_y_moins = abs(K / alpha * (exp(val_1 - val_2) - 1));

% S�lection de la plus grande tension
[a, i] = max(f_y_plus);
[b, j] = max(f_y_moins);

if(a > b)
    if (i > nbr_pt)
        k = i;
        tabl = f_y_plus(k - nbr_pt:k + nbr_pt);
    else
        tens = a;
        return;
    end
else
    if (j > nbr_pt)
        k = j;
        tabl = f_y_moins(k - nbr_pt:k + nbr_pt);
    else
        tens = b;
        return;
    end
end

x = T(k - nbr_pt):1e-3:T(k + nbr_pt);

if (x(end) < T(k + nbr_pt))
    x = [x(:); T(k + nbr_pt)];
end

spline_x = spline(T(k - nbr_pt:k + nbr_pt), tabl, x);
tens = max(spline_x);

end