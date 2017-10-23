function drawBox( x,y,width,height )

startX = round(x - width/2 );
endX = round(x + width/2 );

startY = round(y - height/2 );
endY = round(y + height/2 );

lineX = [ startX, endX , endX , startX , startX ] ;
lineY = [ startY , startY, endY , endY , startY ] ;

line( lineX , lineY, 'Color', [0 0 1], 'LineWidth', 3 ) ;

