function x = bissection(f, x0, x1, varargin)
%% Param�tres

% Invariants
nbr_entrees = 6;

% Variables
img_par_def = 0;
tol_par_def_y = 1e-3;
tol_par_def_x = 1e-3;
crit_arret = floor(log2(abs(x0 - x1)/eps)) + 1;

%% bissection

%   Description :

%   Trouve une abscisse dont l'image li�e par une fonction est relativement
%   proche d'une image vis�e.

%   Entr�e(s) :

%   # f est la fonction donn�e.
%   # x0 et x1 sont des abscisses donn�es.
%     Les images li�es par la fonction � ces abscisses doivent se trouver
%     de part et d'autre de l'image vis�e.
%   # img (ou varargin{1}) est l'image vis�e.
%     Par d�faut, si elle n'est pas entr�e ou si elle est vide,
%     img = img_par_def.
%   # tol_y (ou varargin{2}) est la tol�rance sur les ordonn�es.
%     Elle vaut la distance maximale pouvant s�parer f(x), l'image li�e par
%     la fonction � x, de l'image vis�e.
%     Par d�faut, si elle n'est pas entr�e ou si elle est vide,
%     tol_y = tol_par_def_y.
%   # tol_x (ou varargin{3}) est la tol�rance sur les abscisses.
%     Elle vaut la distance maximale pouvant s�parer x de la "v�ritable"
%     racine.
%     Par d�faut, si elle n'est pas entr�e ou si elle est vide,
%     tol_x = tol_par_def_x.

%   Sortie(s) :

%   # x est l'abscisse trouv�e.

%% V�rifications des entr�es

if (nargin > nbr_entrees)
    error('Trop d''entr�es');
end

if (nargin < nbr_entrees)
    tol_x = tol_par_def_x;
    if (nargin < nbr_entrees - 1)
        tol_y = tol_par_def_y;
        if (nargin < nbr_entrees - 2)
            img = img_par_def;
            if (nargin < nbr_entrees - 3)
                error('Trop peu d''entr�es.');
            end
        else
            img = varargin{1};
        end
    else
        img = varargin{1};
        tol_y = varargin{2};
    end
else
    img = varargin{1};
    tol_y = varargin{2};
    tol_x = varargin{3};
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

if (isempty(tol_x))
    tol_x = tol_par_def_x;
else
    tol_x = abs(tol_x(1));
end
% Fin - Normalisation de la taille des entr�es et valeurs par d�faut

if (isnan(x0) || isreal(x0) == 0 || isnan(x1) || isreal(x1) == 0 || isnan(img) || isreal(img) == 0 || isnan(tol_y) || isreal(tol_y) == 0 || isnan(tol_x) || isreal(tol_x) == 0)
    error('Entr�e(s) non r�elle(s).');
end

f_x0 = f(x0);
f_x1 = f(x1);

if (isnan(f_x0) || isreal(f_x0) == 0 || isnan(f_x1) || isreal(f_x1) == 0)
    error('Fonction non r�elle.');
end

if ((f_x0 - img) * (f_x1 - img) > 0)
    error('Les images li�es par la fonction aux abscisses donn�es ne sont pas de part et d''autre de l''image vis�e.');
end

%% Algorithme

% Initialisation de a, f_a, b, f_b et i
if ((f_x0 - img) < 0)
    a = x0;
    b = x1;
    f_a = f_x0;
    f_b = f_x1;
else
    a = x1;
    b = x0;
    f_a = f_x1;
    f_b = f_x0;
end
i = 0;

% Boucle
while (i < crit_arret + 1 && (abs(f_b - img) > tol_y || abs(f_a - img) > tol_y || abs((a - b) / 2) > tol_x))
    xi = (a + b) / 2;
    f_xi = f(xi);
    if (isnan(f_xi) || isreal(f_xi) == 0)
        error('Valeur(s) calcul�e(s) non r�elle(s).');
    else
        if (f_xi - img <= 0)
            a = xi;
            f_a = f_xi;
        else
            b = xi;
            f_b = f_xi;
        end
    end
    i = i + 1;
end

%% V�rification des sorties

if (i >= crit_arret + 1)
    error('Les valeurs ne convergent pas ou peu.');
end

if (abs(f_a - img) < abs(f_b - img))
    x = a;
else
    x = b;
end

end