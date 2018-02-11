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

quad_size=110;
front_arm_angle = 48;
rear_arm_angle = 40;
damper_angle=front_arm_angle-11;//32;

// Battery size
battery_length = 60;
battery_width = 32;

// Motor tilt angle
motor_tilt_forward = 5;
motor_tilt_inside = 3;

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
damper_holder_ext_dia = damper_holder_dia+3;



pcb_holder_heigth = 2.5;


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

module XXXpropeller_guard(angle=80, $fn=30)
{
	radius=(propeller_dia+5)/2;
	difference() {
		union() {
			translate([0, 0, 2]) cylinder(h=4, d=motor_dia+3, center=true);
			for(a=[0, -angle, angle]) {
				rotate([ 0, 0, a]) translate([31/2, 0, 1.5]) cube([30 , 1.4, 3], center=true);
				rotate([ 0, 0, a]) translate([31/2, 0, .5]) cube([30 , 3, 1.2], center=true);
			}
		}
		translate([0, 0, 2]) cylinder(h=6, d=motor_dia, center=true);
		rotate([ 0, 0, 180]) translate([motor_dia/2, 0, 2.5]) cube([5 , 3, 6], center=true);
		rotate([ 0, 0, 180-20]) translate([motor_dia/2, 0, 2.5]) cube([5 , 2, 6], center=true);
		rotate([ 0, 0, 180+20]) translate([motor_dia/2, 0, 2.5]) cube([5 , 2, 6], center=true);
		
	}
	difference() {
		translate([0, 0, 3]) cylinder(h=6, d=61.2, center=true);
		translate([0, 0, 6+1.2]) cylinder(h=12, d=60, center=true);
		translate([0, 0, 5]) cylinder(h=12, d=58, center=true);
		rotate([ 0, 0, 90-angle-6]) translate([-30, 0, 4]) cube([62, 62, 10], center=true);
		rotate([ 0, 0, angle+90+6]) translate([30, 0, 4]) cube([62, 62, 10], center=true);
	}
	
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
		cylinder(d=4, h=height+0.1, center =true);
	}
}

module damper_holder(rr=32, h, d, view_damper=0)
{
	rotate([0, 0, rr]) translate([quad_size/3, 0,0]) {
		if (view_damper)
			translate([0, 0, 4]) damper();
		else
			cylinder(h=h, d=d, center=true);
	}
}

//
function get_back_damper_pos() = 62 - battery_length; 

module damper_holders(damper_tin, view_damper)
{
	rr=damper_angle;
	translate([get_back_damper_pos(), 0, damper_tin/2])  damper_holder(-180, h=damper_tin, d=damper_holder_ext_dia, view_damper=view_damper);
	for (i = [-1,1]) { 
		translate([0, 0, damper_tin/2])  damper_holder(rr=i*rr, h=damper_tin, d=damper_holder_ext_dia, view_damper=view_damper);
 	}
}
module damper_holders_holes(damper_tin)
{
	rr=damper_angle;
	translate([get_back_damper_pos(), 0, damper_tin/2+2])  damper_holder(-180, h=damper_tin, d=damper_holder_dia);
	translate([get_back_damper_pos(), 0, damper_tin/2])  damper_holder(-180, h=damper_tin*4, d=damper_holder_hole);

	for (i = [-1, 1]) { 
		translate([0, 0, damper_tin/2+2])  damper_holder(i*rr, h=damper_tin, d=damper_holder_dia);
		translate([0, 0,  damper_tin/2+2]) damper_holder(i*rr, h=damper_tin*4, d=damper_holder_hole);
	}
	
}

module micro_camera(width=8, length=20, height=14)
{
	translate([0, 0, 7])  {
		color([0, 0.5, 0]) cube([width, length, height], center=true);
	
		translate([6.5,0]) rotate([0, 90, 0]) {
			color([0.2, 0.2, 0.2]) cylinder(d=7.61, h=5.1, center =true);
			translate([0,0, (2.8+5.1)/2])  {
				color([0.2, 0.2, 0.2]) cylinder(d=10.16, h=2.8, center =true);
				color("LightYellow", 0.9) translate([0,0,0]) {
				 	cylinder(h=35, r1=0, r2=60, center=false);
				}
				
			}
		}
		color([0.9, 0.6, 0]) translate([0, 0, -height/2]) cylinder(d=2, h=25, center =false);
		color([0.9, 0.6, 0]) translate([0, 0, -height/2]) cylinder(d=1, h=25+6, center =false);
		translate([0,0,-height/2+25]) color("gray", 0.5)
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


camera_housing_height=14;	
module camera_housing(width=flight_control_extra_width, height=camera_housing_height, vertical_tin=2.5, dia=8, full_view=full_view)
{
	camera_length=8.3;
	camera_width=20;
	top_plate_tin=0.8;
	color("gray") difference() {
		union() {
			translate([0, 0, height/2]) {
				translate([-(vertical_tin+camera_length)/2, 0, 0]) cube([vertical_tin, width, height], center=true);
				translate([(vertical_tin+camera_length)/2, 0, 0]) cube([vertical_tin, width, height], center=true);
			}
			//#translate([(camera_length+vertical_tin)/2, 0, top_plate_tin/2]) cube([camera_length+vertical_tin*2, width, top_plate_tin], center=true);
			translate([0, 0, top_plate_tin/2]) cube([camera_length+vertical_tin*2, width, top_plate_tin], center=true);
			hh = 7;
			for(y=[-1,1]) {
				translate([0, y*((flight_control_extra_width-1.8)/2), height/2])  cube([camera_length+vertical_tin*2, 1.9, height], center=true);
			}
		}
		translate([(vertical_tin+camera_length)/2, 0, height/2]) hull() rotate([0, 90, 0]) {
			translate([2, 0, 0]) cylinder(h=vertical_tin*2, d=dia, center=true);
			translate([-10, 0, 0]) cylinder(h=vertical_tin*2, d=dia, center=true);
		}
		translate([-(vertical_tin+camera_length)/2, (width/2-vertical_tin)/2+0.65, height/2+top_plate_tin]) cube([vertical_tin+0.1, width/2-vertical_tin, height], center=true);
		for(y=[-1,1]) {
			translate([-vertical_tin, y*((flight_control_extra_width-1.8)/2), height-cover_height/2+0.5])  cube([camera_length+vertical_tin*2, 1.93, cover_height+1], center=true);
		}
		
	}
	if (full_view) translate([0, 0, 2])  micro_camera();
}


module bottom_plate()
{
	plate_tin=4;
	bottom_tin=0.6;
	wall_tin=1;
	
	module motor_holder(m, rr=0, dia=motor_dia, height=14, show_type=0)
	{
		if(model_type==1)
		motor_holder1(m, rr, dia, height, show_type);
		if(model_type==2)
		motor_holder2(m, rr, dia, height, show_type);
	}
	module motor_holder2(m, rr=0, dia=motor_dia, height=14, show_type=0)
	{
		hh=2.5;
		translate([0, 0, 0]) rotate([0, 0, rr]) translate([quad_size/2, 0, 0])
		{
			if (show_type==0) {
				translate([0, 0, plate_tin/2])  {
				  cylinder(h=plate_tin, d=18.5, center=true);
				  //translate([0, 0, hh+height/4]) cylinder(h=height, d=10.5, center=true);
				}
			
			}
			rotate([motor_tilt_inside, m*motor_tilt_forward, -rr]) {
				if (show_type==1) {
					translate([0, 0, 0]) {
				  		translate([0, 0, 0]) cylinder(h=height, d=10.5, center=true);
				  		translate([-0, 0, 0.8+1.4]) cylinder(h=height, d=16, center=false);
				  		translate([-0, 0, -height+0.8]) cylinder(h=height, d=16, center=false);
					}
				}
				if (show_type==2) {
					if(full_view) {
						translate([0, 0, -2.5]) motor();
						translate([0, 0, 16]) propeller_guard();
						
					}
				}
			}
		}
	}

	
	function x1pos(rr) =quad_size/2 * cos(rr); 
	function y1pos(rr) =quad_size/2 * sin(rr);
	function x2pos() =(battery_length-10)/2;
	function y2pos() =(battery_width-10)/2;
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
					translate([0, 0, hh]) motor();
					rotate([ 0, 0, 45]) translate([0, 0, 16]) propeller_guard();
				}
			}
		}
					
		
	}

	
	module motor_arm(rr, positive)
	{
		
		ext_dia=16;
		dia=7;
		int_dia=dia -2*wall_tin;
		

		
		if (positive) {
			hull() {
				translate([x1pos(rr), y1pos(rr), plate_tin/2]) cylinder(h=plate_tin, d=dia, center=true);
				translate([x2pos(rr), y2pos(rr), plate_tin/2])  cylinder(h=plate_tin, d=dia, center=true);
			}
			translate([x1pos(rr), y1pos(rr), plate_tin/2]) cylinder(h=plate_tin, d=motor_dia+3, center=true);
		} else {
			#translate([x1pos(rr), y1pos(rr), 11]) {
				//cylinder(h=20, d=motor_dia, center=true);
			}
			translate([0, 0, plate_tin/2+bottom_tin]) hull() {
				translate([x1pos(rr), y1pos(rr), 0]) cylinder(h=plate_tin, d=int_dia, center=true);
				translate([x2pos(rr), y2pos(rr), 0])  cylinder(h=plate_tin, d=int_dia, center=true);
			}
			translate([x1pos(rr), y1pos(rr), plate_tin/2-0.1]) hull() {
				cylinder(h=plate_tin, d=3, center=true);
				rotate([0, 0, uu(rr)-180]) translate([10, 0, 0]) cylinder(h=plate_tin, d=3, center=true);
			}

			
		}
	}
	
	
	
	module quater(m=0, arm_angle)
	{
	 	difference() {
	 		union() {
	 			translate([battery_length/4, battery_width/4, plate_tin/2]) cube([battery_length/2, battery_width/2, plate_tin], center=true);
	 			motor_holder(m, arm_angle, show_type=0);
	 			motor_arm(arm_angle, true);
	 			
	 		}
	 		translate([(battery_length/2-wall_tin)/2, (battery_width/2-wall_tin)/2, plate_tin/2+bottom_tin]) cube([(battery_length/2-wall_tin), (battery_width/2-wall_tin), plate_tin], center=true);
	 		//translate([0, 0, plate_tin/2+bottom_tin]) cube([battery_length-wall_tin*2, battery_width-wall_tin*2, plate_tin], center=true);
 			motor_arm(arm_angle, false);
	 		rotate([0, 0, arm_angle]) translate([quad_size/2, 0, 0]) cylinder(h=10, d=4, center=true);
	 		motor_holder(m, rr=arm_angle, show_type=1);
	 		
				 		
	 		//translate([0,0,plate_tin/2+bottom_tin]) hex(battery_length/2-wall_tin-17, battery_width/2-wall_tin, plate_tin, 2, 1);
	 	}
 		motor_holder(m, rr=arm_angle, show_type=2);
		
	}
	
	module half()
	{
		module battery_fixing()
		{
	 		translate([0, battery_width/2+2, 1]) cube([4, 6, 2], center=true);
	 		translate([0, (battery_width+8)/2, 2]) cube([4, 3, 4], center=true);
		}
		
		quater(1, front_arm_angle);
		mirror([1, 0, 0]) quater(-1, rear_arm_angle);
	 	translate([15, 0, 0]) battery_fixing();
	 	translate([-15, 0, 0]) battery_fixing();
	}
	

	module cross(length=30, width=22)
	{
		translate([0, 0, plate_tin/2]) {
			difference() 
			{
				union() 
				{
					for(x=[-1,1])
					{
						translate([x*length/2, 0, 0]) cube([wall_tin, battery_width,  plate_tin], center=true);
					}
				}
				translate([0, 0, bottom_tin]) cube([length-wall_tin*2, width-wall_tin*2, plate_tin], center=true);
				
			}
			
		}
	}
	
	module main() {
		difference() {
			union() {
				half();
				mirror([0, 1, 0]) half();
				//translate([0, 0, plate_tin/2]) cube([battery_length, battery_width, plate_tin], center=true);
				//
				//#translate([-battery_length/2+1, 0, plate_tin/2]) cube([damper_holder_ext_dia, damper_holder_ext_dia, plate_tin], center=true);
				translate([-(get_back_damper_pos()+quad_size/3)+damper_holder_ext_dia/2, 0, plate_tin/2]) cube([damper_holder_ext_dia/2, damper_holder_ext_dia, plate_tin], center=true);
				
				damper_holders(plate_tin);
				
				
		 	}
		 	//translate([0, 0, plate_tin/2+bottom_tin]) cube([battery_length-wall_tin*2, battery_width-wall_tin*2, plate_tin], center=true);
		 	//translate([0, 0, plate_tin/2+bottom_tin]) cube([battery_length-wall_tin*2, battery_width-wall_tin*2, plate_tin], center=true);
		 	//translate([0, 0, 0]) cube([battery_length-20, battery_width-20, plate_tin*5], center=true);
		 	
	 		damper_holders_holes(plate_tin);
			//motor_arm_plain(front_arm_angle);
		 	
		}
		cross();
	 	//translate([0, 0, plate_tin/2]) cube([5, battery_width, plate_tin], center=true);
	}
	
	module receiver()
	{
		boder_heigth=2;
		border_tin=2;
		difference() {
			union() {
				translate([0, 0, (boder_heigth+plate_tin)/2]) cube([receiver_length+border_tin, receiver_width+border_tin, boder_heigth+plate_tin], center=true);
			}	
			translate([0, 0, boder_heigth+plate_tin]) {
				cube([receiver_length, receiver_width, boder_heigth*2], center=true);
				cube([receiver_length+border_tin+0.1, receiver_width/2, boder_heigth*2], center=true);
				cube([receiver_length/1.5, receiver_width+border_tin+0.1, boder_heigth*2], center=true);
			}
		}
	}
	
	main();
	if (full_view) damper_holders(plate_tin, view_damper=1);
	 
}


module top_plate()
{
	damper_tin=2.4;
	//top_plate_tin=damper_tin-0.8;
	top_plate_tin=1.2;

	module damper_arms()
	{
		ext_dia=13;
		int_dia=10;
		
		damper_x = 8;
		module arms()
		{
			difference() {
				union() {
					translate([0, 0, top_plate_tin/2]) hull() {
						translate([0, 0, 0]) cylinder(h=top_plate_tin, d=ext_dia, center=true);
						translate([get_back_damper_pos(), 0, 0]) damper_holder(rr=-180, h=top_plate_tin, d=ext_dia);
					}
					for(i=[-1,1]) {
						translate([0, 0, top_plate_tin/2]) hull() {
							translate([damper_x, 0, 0]) cylinder(h=top_plate_tin, d=ext_dia, center=true);
							translate([0, 0, 0]) damper_holder(rr=i*damper_angle, h=top_plate_tin, d=ext_dia);
						}
					}
				}
				translate([0, 0, top_plate_tin-0.1]) hull() {
					translate([0, 0, 0]) cylinder(h=top_plate_tin*2, d=int_dia, center=true);
					translate([get_back_damper_pos(), 0, 0]) damper_holder(rr=-180, h=top_plate_tin*2, d=int_dia);
				}
				for(i=[-1,1]) {
					translate([0, 0, damper_tin-2]) hull() {
						translate([damper_x, 0, 0]) cylinder(h=damper_tin*2, d=int_dia, center=true);
						translate([0, 0, 0]) damper_holder(rr=i*damper_angle, h=4, d=int_dia);
					}
				}
				/*for(i=[-1,1]) {
					translate([damper_x, 0, damper_tin-2]) hull() {
						cylinder(h=damper_tin*2, d=int_dia, center=true);
						damper_holder(rr=i*damper_angle, h=4, d=int_dia);
					}
				
				}*/
			}
			
		}
		difference() {
			union() {
				arms();
				damper_holders(damper_tin);
			}
			translate([0, 0, 0]) damper_holders_holes(damper_tin*2);
		}
	}
	
	module camera_holder(width=flight_control_extra_width, height=16, vertical_tin=2.5, dia=8)
	{
		cte_l=23;
		difference() 
		{
			union() {
				for(y=[-1,1]) {
					translate([-0, y*((flight_control_extra_width-1.8)/2), cover_height/2])  cube([cte_l, 1.8, cover_height], center=true);
				}
			}
		
		}
		if (full_view) translate([7.5, 0, -camera_housing_height+cover_height]) camera_housing();
	}

	module main()
	{	
		difference() {
			union() {	
				translate([0, 0, top_plate_tin/2]) cube([flight_control_length+15, flight_control_extra_width, top_plate_tin], center=true);
				damper_arms();
				translate([flight_control_length/2+17, 0, 0]) camera_holder();
				translate([flight_control_length/2+9+5, 0, cover_height/2]) cube([2, flight_control_extra_width, cover_height], center=true);
				translate([flight_control_length/2+9+5, 0, (receiver_length-6)/2]) cube([2, receiver_width, receiver_length-6], center=true);
				
				
				h1=4;
				for(xy=[[flight_control_length/2, 0], [-flight_control_length/2, -5], [0, flight_control_width/2], [0, -flight_control_width/2]]) {
					translate([xy[0], xy[1], (top_plate_tin+h1)/2]) cube([3, 3.5, top_plate_tin+h1], center=true);
				}
				
			}
			for(y=[-1,1]) {
				translate([-(flight_control_length+15)/2, y*(flight_control_width+5)/2, ]) rotate([0, 0, 45]) cube([10, 10, 4], center=true);
			}
			translate([0, 0, top_plate_tin+2+2]) cube([flight_control_length, flight_control_width, 4], center=true);
			//#translate([0, 0, damper_tin-0.1]) cube([flight_control_length-10, flight_control_width-10, damper_tin*2], center=true);
		}
	}
	difference() {
		union(){
			main();
			cover_holes(h=cover_height, d=5, $fn=30);
		}
		cover_holes(h=cover_height+10, d=1.5, $fn=30);
	}
	if (full_view) translate([0, 0, cover_height]) cover(); 
}

module cover_holes(h, d, $fn)
{
	for(y=[-1,1]) {
		translate([(flight_control_length+23-5)/2, y*(flight_control_width)/2, h/2]) cylinder(h=h, d=d, center=true);
		//translate([0, y*(flight_control_extra_width+2)/2, h/2]) cylinder(h=h, d=d, center=true);
		
	}
	//translate([-(flight_control_length+8)/2, -5, h/2]) cylinder(h=h, d=d, center=true);
}


module cover()
{
	cover_tin=1.4;
	wall_tin=2;
	module half()
	{
		module round(xy)
		{
			translate([0, 0, cover_tin/2]) hull()
			{
				translate([xy[0],xy[1],0]) cylinder(h=cover_tin, d=wall_tin, center=true);		
				translate([xy[2],xy[3],0]) cylinder(h=cover_tin, d=wall_tin, center=true);		
			}
		}
		
		round([(flight_control_length+20)/2, (flight_control_extra_width)/2, -flight_control_length/2-3, (flight_control_extra_width)/2]);
		//for(x=[0, 15, 29, 44])
		for(x=[15, 29, 42.5])
			translate([x, 0, 0]) round([-(flight_control_length)/2, (flight_control_extra_width)/2, -(flight_control_length)/2, 0]);
		translate([-3, 0, 0]) round([-(flight_control_length)/2, (flight_control_extra_width)/2, -(flight_control_length)/2, 0]);

		//translate([2, (flight_control_extra_width-receiver_width)/2, (cover_tin)/4]) rotate([0, 0, 0]) cube([receiver_length, receiver_width, cover_tin/2], center=true);
		a=[[-22.5, 0], [-17, 13.8], [28.8, 13.8], [23.5, 0]];
		//color("blue") linear_extrude(height = 0.4, center = false, convexity = 10) polygon(a);
		
	}
	
	difference() {
		union() {
			half();
			mirror([0, 1, 0]) half();
			cover_holes(h=cover_tin+0.5, d=5, $fn=30);
			//translate([-7,0,cover_tin/2]) cube([receiver_length+2, flight_control_extra_width, cover_tin], center=true);
			
		}
		translate([0, 0, -0.1]) cover_holes(h=cover_tin*2, d=2, $fn=30);
		//#translate([0,0,cover_tin/2+2])  cube([receiver_length, receiver_width, cover_tin], center=true);
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
	translate([0, 0, 15]) rotate([0, -motor_tilt_forward, 0]){
		bottom_plate();
		translate([0, 0, 9]) top_plate();
		
		//translate([0, 0, 22]) rotate([180, 0, 0]) receiver_holder();
		//translate([0, 0, 32]) receiver_holderxx();
	}
	if (motor_tilt_forward>0) calibration_plate();
	
	translate([0, 100, 0])  camera_housing(full_view=false);

} else {
	translate([0, 0, 0]) bottom_plate();
	translate([90, 0, 0]) top_plate();
	//translate([100, 80, 0]) receiver_holder();
	//translate([80, 70, 0]) cover();
	if (motor_tilt_forward>0) translate([150, 90, 0]) calibration_plate();
	translate([150, 0, 0])  camera_housing(full_view=false);
	for(n=[0:3])
		translate([ n*40-40, 90, 0]) rotate([0, 0, 0]) propeller_guard();
}

