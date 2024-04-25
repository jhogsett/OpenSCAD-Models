// Spy Gear Spy Trakr Replacement Track Belt
// jerry hogsett 4/8/2024 github.com/jhogsett

$fa = 1;
$fs = 0.4;

belt_diameter  = 136.0;
belt_width     = 10.0;
belt_thickness = 1.5;
tooth_count    = 75;
tooth_height   = 3.3;
tread_descent  = 0.7;
tip_length     = 6.5;

module belt(diameter, thickness, width) {
    outer_dia = diameter;
    inner_dia = outer_dia - (2 * thickness);
    difference() {
        cylinder(width, d=outer_dia);
        cylinder(width + 1, d=inner_dia);
    }
}

module tooth(centering_length, tooth_height, tip_length, tread_descent) {
    base_length = 9;
    base_width = 3;
    base_height = 1.5;
    ceil_length = tip_length;
    ceil_width = 1;
    ceil_height = tooth_height;
    tread_length = 10;
    tread_height = 4;
    tread_width = 2;
    tread_rotation = 0.0;
    tread_offset = 1;

    half_bl = base_length / 2;
    half_bw = base_width / 2;
    half_cl = ceil_length / 2;
    half_cw = ceil_width / 2;
    half_tl = tread_length / 2;
    half_tw = tread_width / 2;
    half_th = tread_height / 2;

    // center tooth in vertical axis
    translate([0, 0, centering_length / 2]) {

        // stand up, put teeth on the inside
        rotate([0, 90, 180]) {
 
            // tread
            cube([tread_length, tread_width, tread_height], center=true);
            
            // sloped-sided tent-shaped tooth
            translate([0, 0, base_height]) {
                polyhedron(
                  points=[ 
                    // base
                    [half_bl, half_bw, 0] ,
                    [half_bl, -half_bw, 0],
                    [-half_bl, -half_bw, 0],
                    [-half_bl, half_bw, 0], 

                    // ceiling
                    [half_cl, half_cw, ceil_height], 
                    [half_cl, -half_cw, ceil_height], 
                    [-half_cl, half_cw, ceil_height], 
                    [-half_cl, -half_cw, ceil_height]],

                  faces=[
                    // base
                    [1, 0, 3] , [2, 1, 3],

                    // sides
                    [0, 1, 4], 
                    [1, 5, 4],
                    [2, 3, 6], 
                    [2, 6, 7],
                    [2, 5, 1], 
                    [2, 7, 5],
                    [3, 0, 6], 
                    [0, 4, 6],

                    // ceiling
                    [4, 5, 6], [7, 6, 5]]);}}}}

// arrange teeth around a belt diameter
module teeth(diameter, width, height, length, descent, count) {
    r = diameter / 2;
    step = 360 / count;
    for (i = [0 : step : 359]) {
        angle = i;
        dx = r * cos(angle);
        dy = r * sin(angle);
        translate([dx, dy, 0])
            rotate([0, 0 , angle])
                tooth(centering_length = width, 
                      tooth_height = height, 
                      tip_length = length, 
                      tread_descent = descent);}}

color("silver") belt(
    diameter = belt_diameter, 
    thickness = belt_thickness,
    width = belt_width);

color("gold") teeth(
    diameter = belt_diameter, 
    width = belt_width,
    height = tooth_height,
    length = tip_length,
    descent = tread_descent,
    count = tooth_count);
