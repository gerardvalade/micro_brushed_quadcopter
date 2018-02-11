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
full_view=1;

quad_size=90;
front_arm_angle = 45;
rear_arm_angle = 45;

//propeller size
propeller_dia=46;
//propeller_dia=75;


// nano-tech 2s 460mah
nanotech_460 = [60,32,11];
// battery JJRC H8D 2s 500mah
jjrc_h8d = [43.6,23,12.5];

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

module motor(dia=motor_dia, height=motor_length)
{
	module propeller(dia=propeller_dia)
	{
		difference() {
			cylinder(h=0.15, d=dia, center=true);
			cylinder(h=0.5, d=dia-1.5, center=true);
		}
	}
	
	translate([0, 0, height/2]) rotate([0, 0, 0])  {
	  color([0.3, 0.7, 0.7]) cylinder(h=height, d=dia, center=true);
	  
	}
	translate([0, 0, (height)/2+5]) cylinder(h=height, d=1, center=true);
	translate([0, 0, height+3])  color([0.8, 0.3, 0.1]) propeller();
	
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

camera_length=8.3;
camera_width=20;

camera_housing_size=[13, camera_width+2, 16, 23];
function camera_housing_length() = camera_housing_size[0];
function camera_housing_width() = camera_housing_size[1];
function camera_housing_height() = camera_housing_size[2];
function camera_holder_length() = camera_housing_size[3];
camera_guard_matrix=[2.5, camera_holder_length()-2.5];

module camera_housing(width=camera_housing_width(), height=camera_housing_height()+2, vertical_tin=2.5, lens_dia=8.5, full_view=full_view,camera_tilt=6 )
{
	housing_plate_tin=1.2;
	difference() {
		union() {
			translate([0, 0, -1]) rotate([0, -camera_tilt, 0])  {
				translate([0, 0, height/2-.5])  {
					translate([(vertical_tin+camera_length+0.8)/2, 0, 0])  cube([vertical_tin, width, height], center=true);
					translate([-(vertical_tin+camera_length+0.8)/2, -5, 0]) cube([vertical_tin, 10, height], center=true);
				}
				for(y=[-1:1])
					translate([0, y*6, (camera_housing_height()-micro_camera_height()-2)/2]) cube([micro_camera_width()+vertical_tin*2, 2, camera_housing_height()-micro_camera_height()+2], center=true);
			}
			if (camera_housing_height()>150)
				for(y=[-1:1])
					translate([0, y*6, 1/2]) cube([micro_camera_width()+2, 2, 1], center=true);
			
		}
		translate([0, 0, -10/2]) cube([camera_length+vertical_tin*2+5, width, 10], center=true);
		translate([(vertical_tin+camera_length)/2, 0, height/2]) hull() rotate([0, 90-camera_tilt, 0]) {
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

xy_battery_fixing=[flight_control_length/2+0.5, battery_width/2-1+2.5];
module battery_holder_holes(h, dia=screw_dia)
{
	//width=flight_control_width;
	//width=battery_width-2;
	for(x=[-1,1]) {
		for(y=[-1,1]) {
			//#translate([x*(flight_control_length/2+0.5), y*(width/2+2.5), (h)/2]) cylinder(d=dia, h=h, center=true);
			translate([x*xy_battery_fixing[0], y*xy_battery_fixing[1], (h)/2]) cylinder(d=dia, h=h, center=true);
		}
	}
}

xy_camera_fixing=[8, (flight_control_width/2+2.5)];
module camera_fixing_hole(h, dia=screw_dia)
{
	for(x=[-1,1]) {
		for(y=[-1,1]) {
			translate([x*xy_camera_fixing[0], y*xy_camera_fixing[1], (h)/2]) cylinder(d=dia, h=h, center=true);
			
		}
	}
}


module fixing_camera()
{
	
	length=camera_holder_length();
	height=1.6;
	translate([0, 0, height/2]) cube([length, camera_housing_width()+2, height], center=true);
	difference() {
		for(i=[-1,1]) {
			translate([i*xy_camera_fixing[0], 0,0]) hull() {
				//xy_camera_fixing
//				#translate([0, (battery_width/2-2), height/2]) cylinder(d=6, h=height, center=true);
//				translate([0, -(battery_width/2-2), height/2]) cylinder(d=6, h=height, center=true);
				//camera_fixing_hole
				translate([0, (xy_camera_fixing[1]), height/2]) cylinder(d=6, h=height, center=true);
				translate([0, -(xy_camera_fixing[1]), height/2]) cylinder(d=6, h=height, center=true);
			}
			ww = 6;
			hh = 8+head_screw_height;
			ll = 15;
			difference() {
				union() {
					translate([0, i*(camera_housing_width())/2-i*ww/2, hh/2]) cube([length, ww, hh], center=true);
				}
				translate([1.5-0.4, 0, height]) rotate([0, -camera_tilt, 0]) translate([0, 0, camera_housing_height()/2-.5])  cube([camera_length+5.2, camera_housing_width()+0.1, camera_housing_height()], center=true);
				
				for(i=camera_guard_matrix) {
					translate([-length/2+i, 0, (height+7)/2+head_screw_height]) rotate([90, 0, 0]) {
					 	cylinder(d=screw_dia, h=length, center=true);
					 }
				 }

			}
		
		}
	 	translate([0, 0, -0.1]) camera_fixing_hole(height+1, dia=screw_dia_hole);
	 	translate([0, 0, +2]) camera_fixing_hole(10, dia=head_screw_dia);
			
	 	
	}
	translate([1.5, 0, height]) camera_housing();
	if (full_view)	
	{
		translate([-11.5, 0, height+head_screw_height]) rotate([0, 0, 180])  rotate([0, -90, 0])  color("orange") camera_guard(length);
		translate([11.5, 0, height+head_screw_height]) rotate([0, 0, 0])  rotate([0, -90, 0])  color("red") camera_guard(length);
	}
	 
}



module camera_holder(width=flight_control_extra_width, height=16, vertical_tin=2.5, dia=8, plate_tine)
{
	difference() 
	{
		union() {
			for(y=[-1,1]) {
				translate([camera_housing_length()/2-8.8, y*((battery_width-1.8)/2), cover_height/2])  cube([camera_housing_length(), 1.8, cover_height], center=true);
			}
		}
	
	}
	translate([-1, 0, 0]) camera_housing();
}

module bottom_plate()
{
	plate_tin=5;
	bottom_tin=0.6;
	wall_tin=1;
	
	module motor_holder(m, rr=0, dia=motor_dia, height=14, show_type=0)
	{
		if(model_type==1)
			motor_holder1(-m, rr, dia, height, show_type);
		if(model_type==2)
			motor_holder2(-m, rr, dia, height, show_type);
	}
	
	module motor_holder2(m, rr=0, dia=motor_dia, height=14, show_type=0)
	{
		hh=2.5;
		translate([0, 0, 0]) rotate([0, 0, rr]) translate([quad_size/2, 0, 0])
		{
			if (show_type==0) {
				translate([0, 0, plate_tin/2])  {
				  cylinder(h=plate_tin, d=18.5, center=true);
				}
			
			}
			rotate([motor_tilt_inside, m*motor_tilt_forward, -rr]) {
				if (show_type==1) {
					translate([0, 0, 0]) {
				  		translate([0, 0, 0]) cylinder(h=height, d=10.7, center=true);
				  		translate([-0, 0, 1.4]) cylinder(h=height, d=16, center=false);
					}
				}
				if (show_type==2) {
					if(full_view) {
						rotate([0, 180, 0]) {
							translate([0, 0, -8]) {
								motor();
								if (full_view>1) {
									translate([0, 0, 18]) rotate([0, 0, 90+45]) propeller_guard();
								}
							}
						}
						
					}
				}
			}
		}
	}
	
	
	function x1pos(rr) =quad_size/2 * cos(rr); 
	function y1pos(rr) =quad_size/2 * sin(rr);
	function x2pos() =(battery_length-10)/2;
	function y2pos() =(battery_width-8)/2;
	
	function x2len(rr) =x1pos(rr)-x2pos();
	function y2len(rr) =y1pos(rr)-y2pos();
	function len2(rr) = sqrt(pow(y2len(rr),2) + pow(x2len(rr),2)  );
	function uu(rr) = acos( x2len(rr)/len2(rr));
	
	module motor_holder1(m, rr=0, dia=motor_dia, height=14, show_type=0)
	{
		hh=1;
		translate([0, 0, plate_tin/2]) translate([x1pos(rr), y1pos(rr), 0]) rotate([motor_tilt_inside, m*motor_tilt_forward, 0]) {  
			if (show_type==0) {
				
				translate([0, 0, 0]) {
					difference() {
						translate([0, 0, height/2]) cylinder(h=height, d=dia+3, center=true);
						translate([0, 0, hh+height/2]) cylinder(h=height, d=dia, center=true);
						translate([0, 0, 5/2+hh]) cylinder(h=5, d=dia+0.4, center=true);
						translate([0, 0, 0]) cylinder(h=10, d=7, center=true);
						
					}
				}
			}
			if (show_type==1) {
				
				translate([0,0, 10-0.1]) hull() {
					cylinder(h=20, d=3, center=true);
					rotate([0, 0, uu(rr)-180]) translate([10, 0, 0]) cylinder(h=20, d=3, center=true);
				}
			}
			if (show_type==2) {
				if(full_view) {
					rotate(0, 0, 0) {
					translate([0, 0, hh]) motor();
					if (full_view>1)
					rotate([ 0, 0, 45]) translate([0, 0, 16]) propeller_guard();
					
					}
				}
			}
		}
					
		
	}
	module motor_arm(rr, positive)
	{
		
		dia = 4;
		int_dia=dia -2*wall_tin;
		
		if (positive) {
			hull() {
				translate([x1pos(rr), y1pos(rr), plate_tin/2]) cylinder(h=plate_tin, d=dia, center=true);
				translate([x2pos(rr), y2pos(rr), plate_tin/2])  cylinder(h=plate_tin, d=dia, center=true);
			}
			translate([x1pos(rr), y1pos(rr), plate_tin/2]) cylinder(h=plate_tin, d=motor_dia+3, center=true);
		} else {
			translate([0, 0, plate_tin/2+bottom_tin]) hull() {
				translate([x1pos(rr), y1pos(rr), 0]) cylinder(h=plate_tin, d=int_dia, center=true);
				translate([x2pos(rr), y2pos(rr), 0])  cylinder(h=plate_tin, d=int_dia, center=true);
			}
			dd=1.5;
			translate([x1pos(rr), y1pos(rr), plate_tin/2-0.1]) hull() {
				cylinder(h=plate_tin, d=dd, center=true);
				rotate([0, 0, uu(rr)-180]) translate([12, 0, 0]) cylinder(h=plate_tin, d=dd, center=true);
			}

			
		}
	}
	

	
	module quater(m=0, arm_angle)
	{
	 	difference() {
	 		union() {
	 			translate([battery_length/4, battery_width/4, plate_tin/2]) cube([battery_length/2, battery_width/2, plate_tin], center=true);
	 			motor_arm(arm_angle, true);
 			motor_holder(m, arm_angle, show_type=0);
	 			
	 		}
	 		translate([(battery_length/2-wall_tin)/2, (battery_width/2-wall_tin)/2, plate_tin/2+bottom_tin]) cube([(battery_length/2-wall_tin), (battery_width/2-wall_tin), plate_tin], center=true);
 			motor_arm(arm_angle, false);
	 		rotate([0, 0, arm_angle]) translate([quad_size/2, 0, 0]) cylinder(h=10, d=4, center=true);
	 		motor_holder(m, rr=arm_angle, show_type=1);
	 	}
	 	difference() {
	 	}
	 	
 		motor_holder(m, rr=arm_angle, show_type=2);
		
	}
	
	module half()
	{
		module battery_fixing()
		{
	 		translate([0, battery_width/2+2, 1]) cube([4, 6, 2], center=true);
		}
		
		quater(1, front_arm_angle);
		mirror([1, 0, 0]) quater(-1, rear_arm_angle);
	 	translate([15, 0, 0]) battery_fixing();
	 	translate([-15, 0, 0]) battery_fixing();
	}
	

	module cross(length=30, width=22)
	{
		difference() 
		{
			union() 
			{
				for(x=[0:5])
				{
					translate([x*8.5-23, 0, 0.7]) cube([wall_tin, battery_width,  1.4], center=true);
				}
			}
		}
	}
	
	module main() {
		difference() {
			union() {
				half();
				mirror([0, 1, 0]) half();
				cross();
				
				battery_holder_holes(plate_tin, dia=screw_dia_pillar);
				damper_holders(plate_tin, matrix=damper_matrix_bottom);
				
				for(i=[-1,1]) {
					// camera guard fixing
		 			translate([0, i*(battery_width-7)/2, plate_tin/2]) cube([10, 5, plate_tin], center=true);
		 			
		 		}
	 			//led fixing
	 			translate([-(battery_length-5)/2, 0, plate_tin/2]) cube([5, 5, plate_tin], center=true);
		 		// led front hole
	 			translate([(battery_length-5)/2, 0, plate_tin/2]) cube([5, 5, plate_tin], center=true);
				
		 	}
			
			translate([0, 0, plate_tin+2.1]) cube([flight_control_length, flight_control_width, 4], center=true);
			translate([0, 0, -0.1]) battery_holder_holes(plate_tin*2, dia=screw_dia);
		 	damper_holders_holes(plate_tin, matrix=damper_matrix_bottom);
		 	
			for(i=[-1,1]) {
				// camera guard hole
		 		translate([i*3, 0, plate_tin/2]) rotate([90,0,0]) cylinder(d=screw_dia, h=battery_width+5, center=true);
		 		
		 	}
	 		// led back hole
	 		translate([-battery_length/2+2, 0, plate_tin/2]) rotate([0,90,0]) cylinder(d=screw_dia, h=10, center=true);
	 		// led front hole
	 		translate([battery_length/2-2, 0, plate_tin/2]) rotate([0,90,0]) cylinder(d=screw_dia, h=10, center=true);
		}
	}
	
	main();
	
	if (full_view) damper_holders(plate_tin, matrix=damper_matrix_bottom, view_damper=1);
}



xpos_batt_holder = 23;
module battery_holder_part2()
{
	tin=1;
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
	tin=1.5;
	width=battery_width+2*tin+2;
	height=tin+5.5;
	height = battery_height +tin+0.5;//-5.8 + tin +tin/2 +battery_height;//tin/2 - 3.5 + battery_height;//battery_height-3.5+tin;
	heigth2= battery_height-2;
	color( "LemonChiffon") 
	translate([5.8-height-1, 0, 7/2])  rotate([0, 90, 0]) translate([0, 0, tin/2]) {
		cube([7, width, tin], center=true);

		for(x=[-1,1]) {
			translate([0, x*(width-tin)/2, heigth2/2-tin/2]) cube([7, tin, heigth2], center=true);
			difference() {
				translate([0, x*(width+tin+0.5)/2, heigth2]) cube([7, tin+0.5, 6], center=true);
				translate([0, x*(width-tin-0.5)/2, heigth2+3.7]) cube([7.5, tin, 10], center=true);
			}
		}
	
	}
}

module battery_holder()
{
	
	tuning=false;
	
	module fixing_tuning(h, dia=screw_dia, matrix=[[1,  1], [-1, 1], [1, -1], [-1, -1]])
	{
		module make_hull(x1, y1, x2, y2)
		{
				difference() {
					hull() {
						translate([x1, y1, (h)/2]) cylinder(d=dia+dia/2, h=h, center=true);
						translate([x2, y2, (h)/2]) cylinder(d=dia+dia/2, h=h, center=true);
					
					}
					translate([x1, y1, (h)/2]) cylinder(d=dia, h=h+1, center=true);
					translate([x2, y2, (h)/2]) cylinder(d=dia, h=h+1, center=true);
				
				}
			
		}
		for(x=[-1:1]) {
			y=battery_width/2+5; 
			make_hull(x*5, y, x*5, -y);
		}
		x=battery_length/2+5;
		for(y=[-1:1]) {
			make_hull(x, y*5, -x, y*5);
			
		}
	}
	
	
	top_plate_tin=head_screw_height+0.8;
	offset=0;
	length=battery_length-offset-15;//flight_control_length+20;
	width=battery_width+1;
	wall_tin=2.5;
	
	
	height=battery_height+top_plate_tin+0.5;
	//height=top_plate_tin+5;
	hh=top_plate_tin+5;
	translate([0, 0, 0])  difference() {
		union() {
			translate([offset/2, 0, 0.8/2]) cube([length, width, 0.8], center=true);
			for(y=[-2:2]) {
//				translate([offset/2, y*13.5/2, top_plate_tin/2]) cube([length, 3, top_plate_tin], center=true);
			}
			for(x=[-1:1])
				translate([x*(length-10-offset)/2, 0, top_plate_tin/2]) cube([3, width, top_plate_tin], center=true);

			for(x=[-1,1]) {
				for(y=[-1,1]) {
					translate([x*(xpos_batt_holder)/2,0, 0]) {
						
						translate([0, y*width/2, top_plate_tin/2]) cube([7, 6, top_plate_tin], center=true);
						translate([0, y*(width+wall_tin)/2, hh/2]) cube([7, wall_tin, hh], center=true);
					}
				}
			}
			
			translate([0, 0, 0]) battery_holder_holes(top_plate_tin, dia=screw_dia_pillar);
			if (tuning) {
				fixing_tuning(2, 4);
			}
			
		}
		
		translate([0, 0, -0.1]) battery_holder_holes(top_plate_tin+10, dia=screw_dia_hole);
		translate([0, 0, top_plate_tin-head_screw_height+0]) battery_holder_holes(10, dia=head_screw_dia);
		
		// Battery
		
		if (full_view) #translate([0, 0, battery_height/2+2.5]) cube([battery_length, battery_width, battery_height], center=true);
	}
	if (full_view) {
		for(i=[-1,1]) {
			translate([i*(xpos_batt_holder)/2 - 3.5,0, top_plate_tin+6]) rotate([0, 90, 0]) battery_holder_part1();
			if (battery_width>=25)
			translate([0, i*(battery_width-21), battery_height+2.8]) battery_holder_part2();
		}
		if (battery_width<25) { //>
			translate([0, 0, battery_height+2.8]) battery_holder_part2();
		}
		
	}
	
}

module top_plate()
{
	
	top_plate_tin=1.2;
	damper_tin = 2.1;
	camera_height=8;
	
	module fixing_bloc(h=4)
	{
		for(xy=[[flight_control_length/2, 0], [-flight_control_length/2, -5], [0, flight_control_width/2], [0, -flight_control_width/2]]) {
			translate([xy[0], xy[1], h/2+top_plate_tin]) cube([3.5, 3.5, h], center=true);
		}
	}
	module main()
	{	
		difference() {
			union() {	
				translate([0, 0, top_plate_tin/2]) cube([flight_control_length+3, flight_control_width+7, top_plate_tin], center=true);

				for(i=[-1,1])
					translate([0, i*(flight_control_length-6)/2, 3.5/2]) cube([flight_control_length+3, 2, 3.5], center=true);
				
				fixing_bloc();
	 			translate([0, 0, 0]) camera_fixing_hole(top_plate_tin+camera_height, dia=screw_dia_pillar);
				damper_arms(top_plate_tin);
			}
			translate([0, 0, top_plate_tin+2.01]) cube([flight_control_length, flight_control_width, 4], center=true);
			translate([0, 0, -0.1]) camera_fixing_hole(top_plate_tin+camera_height+1, dia=screw_dia);
		}
	}
	main();
	if(full_view) translate([0, 0, top_plate_tin+camera_height]) fixing_camera();
}


module camera_guard_big()
{
	width=battery_width;
	length=30;
	height=12;
	tin=2;
	
	translate([width/2, 0, 0]) difference() {
		union() {
			//translate([0, 0, plate_tin/2]) cube([width, length, plate_tin], center=true);
			translate([0, 0,0]) hull() {
				translate([-width/2, 0, height/2]) cylinder(d=width+tin, h=height, center=true);
				translate([length, 0, height/2]) cylinder(d=width+tin, h=height, center=true);
			}
		}
			translate([0, 0,0]) hull() {
				translate([-(width/2), 0, height/2]) cylinder(d=width, h=height+1, center=true);
				translate([length, 0, height/2]) cylinder(d=width, h=height+1, center=true);
			}
		translate([-width, 0, 0]) cube([width+1, length+20,  30], center=true);
		for(i=[-1,1]) {
			// camera guard hole
		 	translate([-12, 0,  height/2+i*3]) rotate([90,0,0]) cylinder(d=screw_dia, h=battery_width+5, center=true);
		 		
		}
		
	}
	
}
module camera_guard()
{
	width=32;//battery_width;
	length=19+7;
	height=5;
	tin=1.5;
	cube_tin=4;
	holder_length=camera_holder_length()-5;
	
	difference() {
		union() {
			for(i=[-1,1]) {
				translate([10/2, i*(camera_width+2+cube_tin)/2, holder_length/2]) cube([10, cube_tin, holder_length], center=true);
				hh=length-9;
				translate([hh/2, i*(camera_width+2+cube_tin)/2, height/2]) cube([hh, cube_tin, height], center=true);
				translate([hh, i*(camera_width+6.8)/2, height/2]) rotate([0, 0, -i*80]) cube([4, 4, height], center=true);
			}
			translate([length, 0, height/2]) cylinder(d=width+tin*2, h=height, center=true);
		
		}
		for(i=[-1,1]) {
			translate([10/2, i*(camera_width+2+cube_tin)/2+cube_tin/2, camera_holder_length()/2+5]) cube([10.5, cube_tin+1, holder_length+0.1], center=true);
			//translate([4/2, i*(camera_width+2+cube_tin)/2+cube_tin/2, holder_length/2]) cube([4.5, cube_tin+1, holder_length+0.1], center=true);
		}
		
		for(i=camera_guard_matrix) 
		{
			// camera guard hole
		 	translate([2.6, 0,  i]) rotate([90,0,0]) {
		 		cylinder(d=screw_dia_hole, h=battery_width+5, center=true);
		 		translate([0, 0, 10/2+11+2]) cylinder(d=head_screw_dia, h=10, center=true);
		 		translate([0, 0, -(10/2+11+2)]) cylinder(d=head_screw_dia, h=10, center=true);
		 	}
		 		
		}
		translate([length, 0, 24/2]) cylinder(d=width+tin, h=24+1, center=true);
		translate([15/2, 0, camera_holder_length()/4]) cube([15, camera_width+2, camera_holder_length()/2+1], center=true);
	
	}
	
}


module calibration_plate()
{
	width=32;
	length=50;
	plate_tin=3;
	
	difference() {
		union() {
			translate([0, 0, plate_tin/2]) cube([length, width, plate_tin], center=true);
			translate([(length+plate_tin)/2, 0, 20/2]) cube([plate_tin, width, 20], center=true);
			translate([-(length+plate_tin)/2, 0, 20/2]) cube([plate_tin, width, 20], center=true);
		}
		translate([0, 0, 25]) rotate([0, -motor_tilt_forward, 0]) cube([length+20, width+1, 30], center=true);
	}
}

if (full_view) {
	
	translate([0, 0, 7.5]) rotate([0, -motor_tilt_forward, 0]){
		rotate([180, 0, 0]) {
			bottom_plate(1);
			translate([0, 0, 5]) battery_holder();
		}
		translate([0, 0, 6]) top_plate();
	}
	if (motor_tilt_forward>0) translate([0, 0, -15])  calibration_plate();
	

} else {
	translate([0, 0, 0]) bottom_plate();
	translate([0, 35, 0]) rotate([0, 0, 90]) fixing_camera();
	translate([0, -55, 0]) rotate([0, 0, 90]) top_plate();
	translate([-100, 20, 0]) rotate([0, 0, 0])  camera_guard();
	translate([-100, -20, 0]) rotate([0, 0, 0])  camera_guard();
//	if (motor_tilt_forward>0) translate([150, 90, 0]) calibration_plate();
//	for(n=[0:3]) {
//		translate([ n*40-40, 90, 0]) rotate([0, 0, 0]) propeller_guard();
//	}
	translate([85, 50, 0]) rotate([0, 0, 0])  battery_holder();
	translate([90, 0, 0]) battery_holder_part1();
	translate([115, 0, 0]) battery_holder_part1();
	translate([160, 10, 0]) battery_holder_part2();
	if (battery_width>=25)
	translate([160, -10, 0]) battery_holder_part2();
}

