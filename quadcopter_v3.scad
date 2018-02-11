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
use <quadcopter_library.scad>
use <Ducted_Fan.scad>

model_type=2;
full_view=1;

quad_size=90;
front_arm_angle = 50;
rear_arm_angle = 44;

// nano-tech 2s 460mah
nanotech_460 = [60,32,11];
// battery JJRC H8D 2s 500mah
jjrc_h8d = [55, 25, 12.5];

battery=jjrc_h8d;
battery_length = battery[0];
battery_width = battery[1];
battery_height = battery[2];


// Motor tilt angle
motor_tilt_forward = 0;
motor_tilt_inside = 0;

camera_tilt=6;

// Motor size
motor_dia = 8.6;
motor_length = 20;

//propeller size
propeller_dia=46;
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


m2_screw_dia=1.8;
m2_screw_dia_hole=2.4;
m2_screw_dia_pillar=5;
m2_head_screw_dia=3.8;
m2_head_screw_height=1.5;

tuning =true;

$fn=30;

frame_heigth = 12.5;
function x1pos(rr) = quad_size/2 * cos(rr); 
function y1pos(rr) = quad_size/2 * sin(rr);

xpos_motor = x1pos(front_arm_angle);
ypos_motor = y1pos(front_arm_angle);

x1pos_motor = x1pos(front_arm_angle);
y1pos_motor = y1pos(front_arm_angle);

x2pos_motor = x1pos(rear_arm_angle);
y2pos_motor = y1pos(rear_arm_angle);
xpos_pillar = 25;
ypos_pillar = 14;//y1pos(front_arm_angle);

module duct_middle(prop_height=7) {
	
	resolution = full_view ? 20 : 30;
	module upper() {
		difference() {
			translate([0, 0, prop_height]) 	slice_extruded_middle($fn=resolution);
			
			translate([0, 0, -25-0.5]) cube([100, 100, 50], center=true);
		}
	}
	for(x=[x1pos_motor])
	{
		for(y=[y1pos_motor, -y1pos_motor])
		{
			translate([x, y, 0]) upper();
		}
	}
	for(x=[-x2pos_motor])
	{
		for(y=[y2pos_motor, -y2pos_motor])
		{
			translate([x, y, 0]) upper();
		}
	}
}

module duct_top(prop_height=7) {
	tin=1.5;
	
	resolution = full_view ? 20 : 30;
	module upper() {
		difference() {
			translate([0, 0, prop_height]) slice_extruded_hollow($fn=resolution);
			translate([0, 0, -25]) cube([100, 100, 50], center=true);
		}
	}
	module arms(h, w, dir){
		length=25;
		for(rr=[0, 120, -120])
		{
			rotate([0, 0, rr+45]) translate([length/2+2, 0, h/2]) {
				difference() {
					rotate([-dir*30, 0, 0]) difference() {
						translate([0, 0, -1]) cube([length, w, h+1], center=true);
						translate([length/2+3.8, 0, 1]) rotate([0, -10, 0]) cube([10, w*2, h+2], center=true);
					}
					translate([0, 0, -h])cube([length+5, 10, h], center=true);
				
				}
			}
		}
	}

	
	module motor_holder(holder_tin, dir)
	{
		translate([0, 0, 0]) difference()
		{
			motor_dia_xtra=motor_dia+3;
			union() {
				arms(4.4, 1, dir);
				cylinder(d=motor_dia_xtra, h=holder_tin, center=false);
				translate([0, 0, holder_tin]) difference() {
					cylinder(d=motor_dia_xtra, h=1, center=false);
					translate([0, 0, -0.1]) cylinder(d1=motor_dia, d2=motor_dia-2, h=2, center=false);
				}	
			
			}
			translate([0, 0, -0.05]) cylinder(d=motor_dia, h=holder_tin+1, center=false);
		}
	}
	
	module main(dir) {	
		upper();
		motor_holder(prop_height-2, dir=dir);
		if (full_view) {
			translate([0, 0, -22+prop_height]) {
				motor(dia=motor_dia, height=motor_length, propeller_dia=propeller_dia);
				translate([0, 0, -2]) mirror([1, 0, 0]) motor_housing(dia=motor_dia, height=motor_length);
			}
		}
	}
	
	for(y=[-1, 1])
	{
		translate([x1pos_motor, y*y1pos_motor, 0]) rotate([0, 0, 15+y*60]) main(0);
	}
	for(y=[-1, 1])
	{
		translate([-x2pos_motor, y*y2pos_motor, 0]) rotate([0, 0, 15]) main(0);
	}
	
}

module motor_housing(dia=motor_dia, heigth=17)
{
	difference() {
		
	
		cylinder(d=dia+2.5, heigth);
		translate([0, 0, 2.5]) cylinder(d=dia+1, heigth);
		translate([0, 0, -0.1]) cylinder(d=dia, heigth+1);
		//translate([0, 0, heigth/2]) cube([20, 5, heigth-5], center=true);
		translate([0, 0, heigth/2]) rotate([90, 0, 0]) hull() {
			translate([0, -4, 0]) cylinder(d=5, heigth+1, center=true);
			translate([0, 4, 0]) cylinder(d=5, heigth+1, center=true);
		}
	}
}


module pillar_pos(d=m2_screw_dia_pillar, h)
{
	w= 1;
	for(x=[-xpos_pillar,xpos_pillar])
	{
		translate([x, 0, 0]) cylinder(d=d, h=h, center=false);
	}
	for(y=[-ypos_pillar,ypos_pillar])
	{
		translate([0, y, 0]) cylinder(d=d, h=h, center=false);
	}
}

module pillars(h)
{
	difference() {
		union() {
			pillar_pos(d=m2_screw_dia_pillar, h=h);
			for(x=[-1, 1])
			{
				translate([x*xpos_pillar, 0, h/2]) cube([1, 30, h], center=true);
				translate([x*(xpos_motor+8.5), 0, h/4]) cube([0.6, 30, h/2], center=true);
			}
			for(y=[-1, 1])
			{
				translate([0, y*ypos_pillar, h/2]) cube([30, 1, h], center=true);
				translate([0, y*(ypos_motor+8.5), h/4]) cube([30, 0.6, h/2], center=true);
			}
		
		}
		translate([0, 0, -0.05]) pillar_pos(d=m2_screw_dia, h=h+1);
	
	}
}

module main_frame()
{

	xpos_fixing_camera=50;
	module main() {	
		//half(front_arm_angle);
		//mirror([0, 1, 0])  half(rear_arm_angle);
		duct_top();
		difference() {
			union() {
				pillars(h=frame_heigth);
				translate([xpos_fixing_camera, 0, 0]) fixing_camera2(false);
			}
			duct_middle();
		}
	}
	difference()
	{
		main();
			translate([0, 0, frame_heigth]) {
			//translate([0, 0, -1.5/2]) cube([flight_control_length, flight_control_width, 1.5], center=true);
		}
		translate([0, 0, frame_heigth-1.5]) fc_plate(tin=3, cute_frame = true);
	}
	translate([xpos_fixing_camera, 0, 1.2]) camera_housing2(full_view=full_view);
	
	//translate([0, 0, 13.5]) color("orange") cube([flight_control_width, flight_control_length, 1], center=true);
	if (full_view) {
		translate([0, 0, -5]) rotate([90, 0, 0]) color("red", 0.5) cube([battery_length, battery_width, battery_height], center=true);
		translate([0, 0, frame_heigth-1.5])  fc_plate();
		//translate([45, 0, 0]) fixing_camera();
	}
	
}

module fc_plate(tin = 1.5, cute_frame=false)
{
	
	xpos = x1pos(front_arm_angle);
	ypos = y1pos(front_arm_angle);
	module main() {	
		translate([0, 0, tin/2]) cube([xpos_pillar*2+6, ypos_pillar*2+6, tin], center=true);
	}
	
	color("green", 0.9) translate([0, 0, tin/2+0.4]) cube([flight_control_length, flight_control_width, tin], center=true);
	color("orange", 0.9)  difference()
	{
		main();
		if (!cute_frame) translate([0, 0, -0.1]) pillar_pos(d=m2_screw_dia_hole, h=tin+1);
		dia_cut =  cute_frame ? 51.5: 52;
		
		for(x=[x1pos_motor])
		{
			for(y=[y1pos_motor, -y1pos_motor])
			{
				translate([x, y, tin/2-0.1]) cylinder(d=dia_cut, h=tin+1, center=true);
			}
		}
		for(x=[-x2pos_motor])
		{
			for(y=[y2pos_motor, -y2pos_motor])
			{
				translate([x, y, tin/2-0.1]) cylinder(d=dia_cut, h=tin+1, center=true);
			}
		}
		
	}
	
}
xy_camera_fixing=[8, (flight_control_width/2+2.5)];
module camera_fixing_hole(h, dia=m2_screw_dia)
{
	for(x=[-1,1]) {
		for(y=[-1,1]) {
			translate([x*xy_camera_fixing[0], y*xy_camera_fixing[1], (h)/2]) cylinder(d=dia, h=h, center=true);
			
		}
	}
}

module camera_housing2(width=camera_housing_width(), height=camera_housing_height()+2, vertical_tin=2., lens_dia=8.5, full_view=false, camera_tilt=6 )
{
	housing_plate_tin=1.2;
	difference() {
		union() {
			translate([0, 0, -1]) rotate([0, -camera_tilt, 0])  {
				translate([(vertical_tin+micro_camera_width()+0.9)/2, 0, height/2-.5])  cube([vertical_tin, width, height], center=true);
				translate([-(vertical_tin+micro_camera_width()+0.9)/2, -5, 8/2]) cube([vertical_tin, 10, 8], center=true);
				
				for(y=[-1:1])
					translate([0, y*6, (camera_housing_height()-micro_camera_height()-2)/2]) cube([micro_camera_width()+vertical_tin*2, 2, camera_housing_height()-micro_camera_height()+2], center=true);
			}
			if (camera_housing_height()>150)
				for(y=[-1:1])
					translate([0, y*6, 1/2]) cube([micro_camera_width()+2, 2, 1], center=true);
			
		}
		translate([0, 0, -10/2]) cube([micro_camera_width()+vertical_tin*2+5, width, 10], center=true);
		translate([(vertical_tin+micro_camera_width())/2, 0, height/2]) hull() rotate([0, 90-camera_tilt, 0]) {
			translate([2, 0, 0]) cylinder(h=vertical_tin*2, d=lens_dia, center=true);
			translate([-10, 0, 0]) cylinder(h=vertical_tin*2, d=lens_dia, center=true);
		}
	}
	if (full_view)	
	{
		translate([0, 0, 0]) rotate([0, -camera_tilt, 0])  translate([0, 0, 1]) micro_camera_tx03();
	}
}

module fixing_camera2(full_view)
{
	
	length=camera_holder_length();
	height=5;
	tin=1.6;
	//translate([-4.5, 0, tin/2]) cube([length, camera_housing_width(), tin], center=true);
//	translate([-4.5, camera_housing_width()/2, height/2]) cube([length, 2, height], center=true);
//	translate([-4.5, -camera_housing_width()/2, height/2]) cube([length, 2, height], center=true);
	translate([-0, 0, tin/2]) {
		translate([-14, 0, 0]) cube([length, camera_housing_width(), tin], center=true);
		translate([-3.8, 0, 0]) cylinder(d=30, h=tin, center=true);//cube([length, 2, height], center=true);
	}
}
module fixing_camera(full_view)
{
	
	length=camera_holder_length();
	height=1.6;
	translate([0, 0, height/2]) cube([length, camera_housing_width(), height], center=true);
	/* 
	difference() {
		for(i=[-1,1]) {
			translate([i*xy_camera_fixing[0], 0,0]) hull() {
				translate([0, (xy_camera_fixing[1]), height/2]) cylinder(d=6, h=height, center=true);
				translate([0, -(xy_camera_fixing[1]), height/2]) cylinder(d=6, h=height, center=true);
			}
			ww = 6;
			hh = 8+m2_head_screw_height;
			ll = 15;
			difference() {
				union() {
					translate([0, i*(camera_housing_width())/2-i*ww/2, hh/2]) cube([length, ww, hh], center=true);
				}
				translate([1.5-0.4, 0, height]) rotate([0, -camera_tilt, 0]) translate([0, 0, camera_housing_height()/2-.5])  cube([micro_camera_length()+5.2, camera_housing_width()+0.1, camera_housing_height()], center=true);
				
				for(i=camera_guard_matrix) {
					translate([-length/2+i, 0, (height+7)/2+m2_head_screw_height]) rotate([90, 0, 0]) {
					 	cylinder(d=m2_screw_dia, h=length, center=true);
					 }
				 }

			}
		
		}
	 	translate([0, 0, -0.1]) camera_fixing_hole(height+1, dia=m2_screw_dia_hole);
	 	translate([0, 0, +2]) camera_fixing_hole(10, dia=m2_head_screw_dia);
			
	 	
	}*/
	//translate([4.5, 0, height]) camera_housing2();
	if (full_view)	
	{
		translate([-11.5, 0, height+m2_head_screw_height]) rotate([0, 0, 180])  rotate([0, -90, 0])  color("orange") camera_guard(length);
		translate([11.5, 0, height+m2_head_screw_height]) rotate([0, 0, 0])  rotate([0, -90, 0])  color("red") camera_guard(length);
	}
	 
}


if (full_view) {
	main_frame();
} else {
	translate([0, 0, 0]) main_frame();
	translate([100, 0, 0]) fc_plate();
	for(i=[1:4])
	translate([i*15, 90, 0]) motor_housing();
}