function x = secante(f, x0, x1, varargin)
%% Param�tres

% Invariants
nbr_entrees = 5;

% Variables
img_par_def = 0;
tol_par_def_y = 1e-3;
crit_arret = 32;

%% secante

%   Description :

%   Trouve une abscisse dont l'image li�e par une fonction est relativement
%   proche d'une image vis�e.

%   Entr�e(s) :

%   # f est la fonction donn�e.
%   # x0 et x1 sont des abscisses donn�es.
%   # img (ou varargin{1}) est l'image vis�e.
%     Par d�faut, si elle n'est pas entr�e ou si elle est vide,
%     img = img_par_def.
%   # tol_y (ou varargin{2}) est la tol�rance sur les ordonn�es.
%     Elle vaut la distance maximale pouvant s�parer f(x), l'image li�e par
%     la fonction � x, de l'image vis�e.
%     Par d�faut, si elle n'est pas entr�e ou si elle est vide,
%     tol_y = tol_par_def_y.

%   Sortie(s) :

%   # x est l'abscisse trouv�e.

%% V�rifications des entr�es

if (nargin > nbr_entrees)
    error('Trop d''entr�es.');
end

if (nargin < nbr_entrees)
    tol_y = tol_par_def_y;
    if (nargin < nbr_entrees - 1)
        img = img_par_def;
        if (nargin < nbr_entrees - 2)
            error('Trop peu d''entr�es.');
        end
    else
        img = varargin{1};
    end
else
    img = varargin{1};
    tol_y = varargin{2};
end

if (isempty(f) || isempty(x0) || isempty(x1))
    error('Entr�e(s) n�cessaire(s) vide(s).');
end

if (isa(f, 'function_handle') == 0)
    error('Fonction non manipulable.');
end

% D�but - Normalisation de la taille des entr�es et valeurs par d�faut
x0 = x0(1);
x1 = x1(1);

if (isempty(img))
    img = img_par_def;
else
    img = img(1);
end

if (isempty(tol_y))
    tol_y = tol_par_def_y;
else
    tol_y = abs(tol_y(1));
end
% Fin - Normalisation de la taille des entr�es et valeurs par d�faut

if (isnan(x0) || isreal(x0) == 0 || isnan(x1) || isreal(x1) == 0 || isnan(img) || isreal(img) == 0 || isnan(tol_y) || isreal(tol_y) == 0)
    error('Entr�e(s) non r�elle(s).');
end

f_x0 = f(x0);
f_x1 = f(x1);

if (isnan(f_x0) || isreal(f_x0) == 0 || isnan(f_x1) || isreal(f_x1) == 0)
    error('Fonction non r�elle.');
end

if (f_x0 == f_x1)
    error('Les images li�es par la fonction aux abscisses donn�es sont �gales.');
end

%% Algorithme

% Initialisation de a, f_a, b, f_b et i
a = x0;
b = x1;
f_a = f_x0;
f_b = f_x1;
i = 1;

% Boucle
while (i < crit_arret + 1 && abs(f_b - img) > tol_y)
    c = b - (f_b - img) * (b - a) / (f_b - f_a);
    a = b;
    b = c;
    f_a = f_b;
    f_b = f(b);
    i = i + 1;
    if (f_b == f_a || isnan(f_b) || isreal(f_b) == 0)
        error('Valeur(s) calcul�e(s) non r�elle(s).');
    end
end

%% V�rification des sorties

if (i >= crit_arret + 1)
    error('Les valeurs ne convergent pas ou peu.');
end

x = b;

end