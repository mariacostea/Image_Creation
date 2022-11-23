function R = bicubic_resize(I, p, q)
    % =========================================================================
    % Se scaleaza imaginea folosind algoritmul de Interpolare Bicubic?.
    % Transforma imaginea I din dimensiune m x n in dimensiune p x q.
    % =========================================================================

    [m n nr_colors] = size(I);

    I = cast(I, 'double');
    
    % TODO: Initializeaza matricea finala drept o matrice nula.
    
    R = zeros(p, q);

    % daca imaginea e alb negru, ignora
    if nr_colors > 1
        R = -1;
        return
    endif

    % Obs:
    % Atunci cand se aplica o scalare, punctul (0, 0) al imaginii nu se va deplasa.
    % In Octave, pixelii imaginilor sunt indexati de la 1 la n.
    % Daca se lucreaza in indici de la 1 la n si se inmulteste x si y cu s_x
    % respectiv s_y, atunci originea imaginii se va deplasa de la (1, 1) la (sx, sy)!
    % De aceea, trebuie lucrat cu indici in intervalul [0, n - 1]!


    % TODO: Calculeaza factorii de scalare
    % Obs: Daca se lucreaza cu indici in intervalul [0, n - 1], ultimul pixel
    % al imaginii se va deplasa de la (m - 1, n - 1) la (p, q).
    % s_x nu va fi q ./ n
    
    s_x = (q-1) ./ (n-1);
    s_y = (p-1) ./ (m-1);

    % TODO: Defineste matricea de transformare pentru redimensionare.
    
    trans = [s_x, 0; 0 s_y];

    % TODO: Calculeaza inversa transformarii.

    inversa = inv(trans);
    
    % TODO: Precalculeaza derivatele.
    
    [Ix, Iy, Ixy] = precalc_d(I); 

    % Parcurge fiecare pixel din imagine.
    for y = 0 : p - 1
        for x = 0 : q - 1
            % TODO: Aplica transformarea inversa asupra (x, y) si calculeaza x_p si y_p
            % din spatiul imaginii initiale.

            b = [x, y];
            b = b * inversa;
            
            % TODO: Trece (xp, yp) din sistemul de coordonate 0, n - 1 in
            % sistemul de coordonate 1, n pentru a aplica interpolarea.
            
            b = b + [1, 1];

            % TODO: Gaseste cele 4 puncte ce inconjoara punctul x, y

            d = b(1);
            e = b(2);
            x1 = floor(d);
            x2 = floor(d) + 1;
            y1 = floor(e);
            y2 = floor(e) + 1;

            if y2 > m
              y2 = m;
            endif

            if x2 > n
              x2 = n;
            endif
            
            % TODO: Calculeaza coeficientii de interpolare A.
            
             A = bicubic_coef(I, Ix, Iy, Ixy, x1, y1, x2, y2);

            % TODO: Trece coordonatele (xp, yp) in patratul unitate, scazand (x1, y1).
            
            b(1) = b(1) - x1;
            b(2) = b(2) - y1;

            % TODO: Calculeaza valoarea interpolata a pixelului (x, y).
            % Obs: Pentru scrierea in imagine, x si y sunt in coordonate de
            % la 0 la n - 1 si trebuie aduse in coordonate de la 1 la n.
            
            R(y + 1, x + 1) = [1 b(2) b(2)^2 b(2)^3] * A' * [1; b(1); b(1)^2; b(1)^3];

        endfor
    endfor

    % TODO: Transforma matricea rezultata �n uint8 pentru a fi o imagine valida.
    
    R = uint8(R);
    
endfunction





