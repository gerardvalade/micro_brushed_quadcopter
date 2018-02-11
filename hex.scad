e = 0.02;

module hexp(h,s) { linear_extrude(height=h) scale(s/2)
    polygon([[2,0],[1,-sqrt(3)],[-1,-sqrt(3)],[-2,0],[-1,sqrt(3)],[1,sqrt(3)]]);
}

module hex(l,w,h,s,t) {
  for (i=[0:3*s+sqrt(3)*t:l+2*s]) for (j=[0:sqrt(3)*s+t:w+s]) {
    translate([i,j,0]) cylinder(h=h, r=s, $fn=6);
    translate([i+(3*s+sqrt(3)*t)/2,j+(sqrt(3)*s+t)/2,0]) cylinder(h=h, r=s, $fn=6);
  }
}

module hex2(l,w,h,s,t) {
  module s() { translate([-e,-t/2,0]) cube([s+t/sqrt(3)+2*e,t,h]); }
  for (i=[0:3*s+sqrt(3)*t:l+2*s]) for (j=[0:sqrt(3)*s+t:w+s]) {
    translate([i,j,0]) { s(); rotate(120) s(); rotate(240) s(); }
    translate([i+(3*s+sqrt(3)*t)/2,j+(sqrt(3)*s+t)/2,0]) { s(); rotate(120) s(); rotate(240) s(); }
  }
}

module hex1(l,w,h,s,t) {
  for (i=[0:3*s+sqrt(3)*t:l+2*s]) for (j=[0:sqrt(3)*s+t:w+s]) {
    translate([i,j,0]) hexp(h,s);
    translate([i+(3*s+sqrt(3)*t)/2,j+(sqrt(3)*s+t)/2,0]) hexp(h,s);
  }
}


hex1(78,78,5,8,1.5);
//hex2(78,78,2,8,1.5);