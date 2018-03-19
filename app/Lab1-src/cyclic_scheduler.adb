with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Real_Time;
use Ada.Real_Time;

with System_Function_Package;
use System_Function_Package;

procedure Cyclic_Scheduler is
   X : Integer := 0; -- Input
   Y : Integer := 0; -- Input

   task Source_X;
   task Source_Y;
   task Scheduler;

   task body Source_X is -- Generates Data for Input X
      Start : Time;
      Next_Release : Time;
      Release : Time_Span := Milliseconds(0);
      Period : Time_Span := Milliseconds(1000);
   begin
      Start := Clock;
      Next_Release := Start + Release;
      loop
         delay until Next_Release;
         Next_Release:= Next_Release + Period;
         X := X + 1;
	  end loop;
   end Source_X;

   task body Source_Y is -- Generated Data for Input Y
      Start : Time;
      Next_Release : Time;
      Release: Time_Span := Milliseconds(500);
      Period : Time_Span := Milliseconds(1000);
   begin
      Start := Clock;
      Next_Release := Start + Release;
      loop
         delay until Next_Release;
         Next_Release:= Next_Release + Period;
         Y := Y + 1;
	 end loop;
   end Source_Y;

   task body Scheduler is
     Z : Integer; -- Output
	  A : Integer; -- Output
	  B : Integer; -- Output
	  my_start_time : Time;
	  my_end_time : Time;
	  my_duration : Time_Span;
   begin
   endless_loop: loop
      -- Complete the code for the scheduler...
		 my_start_time := Clock;
		 A := System_Function_Package.System_A(X);
		 my_end_time := Clock;
		 my_duration := my_end_time - my_start_time;
 	     Put(Duration'Image(To_Duration(my_duration))); 
		 Put_Line(": X executed");
		 
		 my_start_time := Clock;
		 B := System_Function_Package.System_B(Y);
		 my_end_time := Clock;
		 my_duration := my_end_time - my_start_time;
 	     Put(Duration'Image(To_Duration(my_duration))); 
		 Put_Line(": Y executed");
		 
		 my_start_time := Clock;
		 Z := System_Function_Package.System_C(A,B);
		 my_end_time := Clock;
		 my_duration := my_end_time - my_start_time;
 	     Put(Duration'Image(To_Duration(my_duration))); 
		 Put_Line(": Z executed");
		 Put("Z = " & Integer'Image ( Z ));
		 Put_Line("");
	end loop endless_loop;
   end Scheduler;

   
   
   
   
begin
   null;
end Cyclic_Scheduler;

