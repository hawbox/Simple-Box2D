package couk.psyked.box2d.utils.library
{
    import couk.psyked.box2d.utils.shape.CurveToArray;
    
    import flash.geom.Point;
    
    import wumedia.parsers.swf.Data;
    import wumedia.parsers.swf.Edge;
    import wumedia.parsers.swf.ShapeRecord;

    public class ShapeRecord extends wumedia.parsers.swf.ShapeRecord
    {

        public function ShapeRecord( data:Data, tagType:uint )
        {
            super( data, tagType );
        }

        static public function getPoints( shape:wumedia.parsers.swf.ShapeRecord, scale:Number = 1.0, levelOfDetail:uint = 30 ):Vector.<Vector.<Point>>
        {
            var rtn:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
            var shapes:Vector.<Point> = new Vector.<Point>();
            var elems:Array = shape.elements;
            var elemNum:int = -1;
            var elemLen:int = elems.length;
            var dx:int = 0;
            var dy:int = 0;
            scale *= .05;
            while ( ++elemNum < elemLen )
            {
                if ( elems[ elemNum ] is Edge )
                {
                    var edge:Edge = elems[ elemNum ];
                    if ( dx != edge.sx || dy != edge.sy )
                    {
                        if ( shapes.length > 0 )
                        {
                            rtn.push( shapes );
                        }
                        shapes = new Vector.<Point>();
                    }
                    if ( edge.type == Edge.CURVE )
                    {
                        // use the CurveToArray function...
                        var pointsArray:Array = CurveToArray.getCurveArray( edge.sx, edge.sy, edge.cx, edge.cy, edge.x, edge.y, levelOfDetail );
                        for ( var i:int = 1; i < pointsArray.length; i++ )
                        {
                            var pt:Array = pointsArray[ i ];
                            shapes.push( new Point( pt[ 0 ] * scale, pt[ 1 ] * scale ));
                        }
                    }
                    else
                    {
                        //trace( "Adding point: ", edge.x * scale, edge.y * scale );
                        shapes.push( new Point( edge.x * scale, edge.y * scale ));
                    }
                    dx = edge.x;
                    dy = edge.y;
                }
            }
            rtn.push( shapes );
            return rtn;
        }
    }
}