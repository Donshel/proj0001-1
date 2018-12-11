function y = f(x, tabl)
%% Param�tres

% Invariants
nbr_entrees = 2;

%% f

%   Description :

%   Lie � une abscisse donn�e une image "probable" calcul�e par
%   interpolation sur les valeurs d'un tableau.

%   Entr�e(s) :

%   # x est l'abscisse donn�e.
%   # tabl est le tableau de valeurs donn�.

%   Sortie(s) :

%   # y est l'image trouv�e.

%% V�rifications des entr�es

if (nargin < nbr_entrees)
    error('Pas assez d''entr�es.');
end

if (isempty(x) || isempty(tabl))
    error('Entr�e(s) n�cessaire(s) vide(s).');
end

if (size(tabl, 2) < 2)
    error('Trop peu de colonnes dans la seconde entr�es.');
end

% D�but - Normalisation de la taille des entr�es
x = x(:);
tabl = tabl(:, 1:2);
% Fin - Normalisation de la taille des entr�es

for i = 1:size(x, 1)
    if (isnan(x(i)) || isreal(x(i)) == 0)
        warning('Entr�e(s) non r�elle(s).');
    end
end

for i = 1:size(tabl, 1)
    for j = 1:2
        if (isnan(tabl(i, j)) || isreal(tabl(i, j)) == 0)
            warning('Entr�e(s) non r�elle(s).');
        end
    end
end

%% Interpolation

y = spline(tabl(:, 1), tabl(:, 2), x);

end