cvx_begin
      variables x y u v z
      
% a)
        x+2*y==0;
        x-y==0;
      
% b)
      square_pos( square( x + y ) ) <= x - y
% OR
      variable t
      square( x+y ) <= t;
      square( t ) <= x - y
% OR
      ( x + y )^4 <= x - y;

% c)

      inv_pos(x) + inv_pos(y)  <= 1;
      
% d)
      norm( [ u ; v ] ) <= 3*x + y;
      max( x , 1 ) <= u;
      max( y , 2 ) <= v;
      
% e)
      x >= inv_pos(y);
      x >= 0;
      y >= 0;
      
% OR
      geomean([x,y])>=1
% OR
      [ x 1; 1 y ] == semidefinite(2)

% f)
      
      quad_over_lin(x + y , sqrt(y)) <= x - y + 5;

% g)

      pow_pos(x,3) + pow_pos(y,3) <= 1;
      x>=0;
      y>=0;

% h)
      x+z <= 1+geo_mean([x-quad_over_lin(z,y),y]);
      x>=0;
      y>=0;
      
cvx_end