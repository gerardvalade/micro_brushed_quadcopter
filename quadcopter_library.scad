// quadcopter  - a OpenSCAD 
// Copyright (C) 2016  Gerard Valade

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

model_type=2;
full_view=0;

quad_size=95;
front_arm_angle = 45;
rear_arm_angle = 45;

// Battery size
battery_length = 60;
battery_width = 32;
battery_height = 11;

battery_length = 60;
battery_width = 32;
battery_height = 11;


// Motor tilt angle
motor_tilt_forward = 0;
motor_tilt_inside = 0;

camera_tilt=6;

// Motor size
motor_dia = 8.6;
motor_length = 20;

//propeller size
propeller_dia=55;
//propeller_dia=75;

// Flight control size
flight_control_length = 33;
flight_control_width = 22;
flight_control_extra_width = 26;
cover_height = 6;


// Receiver size
receiver_length = 23.8;
receiver_width = 11.8;


// Damper size
damper_holder_hole = 6.8;
damper_holder_dia = 10.5;
damper_holder_ext_dia = damper_holder_dia+2;


screw_dia=1.8;
screw_dia_hole=2.4;
screw_dia_pillar=5;
head_screw_dia=3.8;
head_screw_height=1.5;



$fn=30;

module motor(dia=motor_dia, height=motor_length, propeller_dia)
{
	module propeller(dia=propeller_dia)
	{
		//color("yellow", 0.3) cylinder(h=0.15, d=dia, center=true);
		color([0.8, 0.3, 0.1]) difference() {
			cylinder(h=0.15, d=dia, center=true);
			cylinder(h=0.5, d=dia-1.5, center=true);
		}
	}
	
	translate([0, 0, height/2]) rotate([0, 0, 0])  {
	  color([0.3, 0.7, 0.7]) cylinder(h=height, d=dia, center=true);
	  
	}
	translate([0, 0, (height)/2+5]) cylinder(h=height, d=1, center=true);
	translate([0, 0, height+3])  propeller();
	
}

module propeller_guard(angle=80, $fn=30)
{
	radius=(propeller_dia+5)/2;
	difference() {
		union() {
			translate([0, 0, 2]) cylinder(h=4, d=motor_dia+3, center=true);
			for(a=[0, -angle, angle]) {
				rotate([ 0, 0, a]) translate([radius/2, 0, 1.5]) cube([radius , 1.4, 3], center=true);
				rotate([ 0, 0, a]) translate([radius/2, 0, .5]) cube([radius , 3, 1.2], center=true);
			}
		}
		translate([0, 0, 2]) cylinder(h=6, d=motor_dia, center=true);
		rotate([ 0, 0, 180]) translate([motor_dia/2, 0, 2.5]) cube([5 , 3, 6], center=true);
		rotate([ 0, 0, 180-20]) translate([motor_dia/2, 0, 2.5]) cube([5 , 2, 6], center=true);
		rotate([ 0, 0, 180+20]) translate([motor_dia/2, 0, 2.5]) cube([5 , 2, 6], center=true);
		
	}
	difference() {
		translate([0, 0, 3]) cylinder(h=6, r=radius+1.5, center=true);
		translate([0, 0, 6+1.2]) cylinder(h=12, r=radius, center=true);
		translate([0, 0, 5]) cylinder(h=12, d=propeller_dia, center=true);
		rotate([ 0, 0, 90-angle-6]) translate([-radius, 0, 4]) cube([radius*2, radius*2, 10], center=true);
		rotate([ 0, 0, angle+90+6]) translate([radius, 0, 4]) cube([radius*2, radius*2, 10], center=true);
	}
	
}


module damper(height=13)
{
	color([0, 0, 0.9]) difference() {	
		union() {
			cylinder(d=6, h=height, center =true);
			cylinder(d=8.5, h=6.5, center =true);
			translate([0,0,(height-1.5)/2]) cylinder(d=8.5, h=1.5, center =true);
			translate([0,0,-(height-1.5)/2]) cylinder(d=8.5, h=1.5, center =true);
		}
		cylinder(d=5, h=height+0.1, center =true);
	}
}

damper_matrix_top=[[-23.5,-6], [23.5, 10], [23.5, -10]];
damper_matrix_bottom=[[damper_matrix_top[0][0], -damper_matrix_top[0][1]], damper_matrix_top[1], damper_matrix_top[2]];

module damper_holder(h, d, view_damper=0)
{
	if (view_damper)
		translate([0, 0, -5]) damper();
	else
		cylinder(h=h, d=d, center=true);
}

module damper_holders(damper_tin, view_damper, matrix)
{
	for(xy=matrix) {
		translate([xy[0], xy[1], damper_tin/2])  damper_holder(h=damper_tin, d=damper_holder_ext_dia, view_damper=view_damper);
	}
}
module damper_holders_holes(damper_tin, matrix)
{
	
	for(xy=matrix) {
		translate([xy[0], xy[1], damper_tin/2+2])  damper_holder(h=damper_tin, d=damper_holder_dia);
		translate([xy[0], xy[1], damper_tin/2-0.1])  damper_holder(h=damper_tin+1, d=damper_holder_hole);
	}
}

module damper_arms(tin)
{
	damper_tin = 2.5;
	difference() {
		union(){
			damper_holders(damper_tin, matrix=damper_matrix_top);
			for(xy=damper_matrix_top) {
				hull()
				{
					translate([xy[0], xy[1], 0])  cylinder(h=tin, d=damper_holder_dia);
					translate([xy[0]*0.5, xy[1], 0])  cylinder(h=tin, d=damper_holder_dia);
					
				}				
			}
		}
		damper_holders_holes(damper_tin, matrix=damper_matrix_top);
	}
}

micro_camera_size=[8, 20, 14];
function micro_camera_width() = micro_camera_size[0];
function micro_camera_length() = micro_camera_size[1];
function micro_camera_height() = micro_camera_size[2];

module micro_camera_tx03(width=micro_camera_width(), length=micro_camera_length(), height=micro_camera_height())
{
	total_height=38;
	translate([0, 0, 7])  {
		color([0, 0.5, 0]) cube([width, length, height], center=true);
	
		translate([6.5,0]) rotate([0, 90, 0]) {
			color([0.2, 0.2, 0.2]) cylinder(d=7.61, h=5.1, center =true);
			translate([0,0, (2.8+5.1)/2])  {
				color([0.2, 0.2, 0.2]) cylinder(d=10.16, h=2.8, center =true);
				if (full_view>2)
					color("LightYellow", 0.9) translate([0,0,0]) {
					 	cylinder(h=35, r1=0, r2=60, center=false);
					}
				
			}
		}
		color([0.9, 0.6, 0]) translate([0, 0, -height/2]) cylinder(d=2, h=25, center =false);
		color([0.9, 0.6, 0]) translate([0, 0, -height/2]) cylinder(d=1, h=25+6, center =false);
		color([0.9, 0.6, 0]) translate([0, 0, -height/2]) cylinder(d=0.21, h=total_height, center =false);
		translate([0,0,-15+total_height]) color("gray", 0.5)
		{
		 	difference() 
		 	{
				translate([0, 0, -10])sphere(r=18, center=false);
				translate([0, 0, -20]) cube(size=40, center=true);
			}	
		}

		translate([-width/2-1, (length-6.8)/2-0.5, (height-7.88)/2-1.6]) color("white") cube([2, 6.80, 7.88], center=true);
	
	}
}

function camera_length()=8.3;
function camera_width()=20;

camera_housing_size=[13, camera_width()+2, 16, 23];
function camera_housing_length() = camera_housing_size[0];
function camera_housing_width() = camera_housing_size[1];
function camera_housing_height() = camera_housing_size[2];
function camera_holder_length() = camera_housing_size[3];
camera_guard_matrix=[2.5, camera_holder_length()-2.5];

module camera_housing(width=camera_housing_width(), height=camera_housing_height()+2, vertical_tin=2.5, lens_dia=8.5, full_view=false, camera_tilt=6 )
{
	housing_plate_tin=1.2;
	difference() {
		union() {
			translate([0, 0, -1]) rotate([0, -camera_tilt, 0])  {
				translate([0, 0, height/2-.5])  {
					translate([(vertical_tin+camera_length()+0.8)/2, 0, 0])  cube([vertical_tin, width, height], center=true);
					translate([-(vertical_tin+camera_length()+0.8)/2, -5, 0]) cube([vertical_tin, 10, height], center=true);
				}
				for(y=[-1:1])
					translate([0, y*6, (camera_housing_height()-micro_camera_height()-2)/2]) cube([micro_camera_width()+vertical_tin*2, 2, camera_housing_height()-micro_camera_height()+2], center=true);
			}
			if (camera_housing_height()>150)
				for(y=[-1:1])
					translate([0, y*6, 1/2]) cube([micro_camera_width()+2, 2, 1], center=true);
			
		}
		translate([0, 0, -10/2]) cube([camera_length()+vertical_tin*2+5, width, 10], center=true);
		translate([(vertical_tin+camera_length())/2, 0, height/2]) hull() rotate([0, 90-camera_tilt, 0]) {
			translate([2, 0, 0]) cylinder(h=vertical_tin*2, d=lens_dia, center=true);
			translate([-10, 0, 0]) cylinder(h=vertical_tin*2, d=lens_dia, center=true);
		}
	}
	if (full_view)	
	{
		translate([0, 0, 0]) rotate([0, -camera_tilt, 0])  translate([0, 0, 1]) micro_camera_tx03();
	}
}

module camera_holder_plate(height)
{
	translate([0, 0, height/2]) cube([camera_housing_length(), camera_housing_width(), height], center=true);
}



xpos_batt_holder = 23;
module battery_holder_part2()
{
	tin=1.5;
	width=10;
	height=tin+5.5;
	height=tin+2;
	
	color("Moccasin") {
		translate([0, 0, tin/2])  cube([battery_length, width, tin], center=true);
		for(x1=[-1,1]) {
			for(x2=[-1,1]) {
				translate([x1*(xpos_batt_holder+x2*10.5)/2,0, height/2]) cube([tin+1, width, height], center=true);
			}
		}
	}
}
module battery_holder_part1()
{
	tin=2;
	width=battery_width+2*tin+2+1;
	height=tin+5.5;
	height=battery_height-3.5+1.5;

	color( "LemonChiffon") 
	translate([-height, 0, 7/2])  rotate([0, 90, 0]) translate([0, 0, tin/2]) {
		cube([7, width, tin], center=true);

		for(x=[-1,1]) {
			translate([0, x*(width-tin-1)/2, height/2]) cube([7, tin+1, height], center=true);
			difference() {
				translate([0, x*(width+tin+0.5)/2, height]) cube([7, tin+0.5, 6], center=true);
				translate([0, x*(width-tin-0.5)/2, height+5]) cube([7.5, tin+1, 10], center=true);
			}
		}
	
	}
}
