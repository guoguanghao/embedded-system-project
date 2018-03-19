with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Real_Time;
use Ada.Real_Time;

with Buffer;
use Buffer;

with Ada.Numerics.Discrete_Random;

procedure ProducerConsumer is

   X : Integer; -- Shared Variable
   N : constant Integer := 40; -- Number of produced and comsumed variables

   pragma Volatile(X); -- For a volatile object all reads and updates of
                       -- the object as a whole are performed directly
                       -- to memory (Ada Reference Manual, C.6)

   -- Random Delays
   subtype Delay_Interval is Integer range 50..250;
   package Random_Delay is new Ada.Numerics.Discrete_Random (Delay_Interval);
   use Random_Delay;
   G : Generator;

   task type CircularBuffer is
      entry Write(X : in Integer);
      entry Read(X : out Integer);
   end CircularBuffer;
   
   task body CircularBuffer is
      N: constant Integer := 4;
	  subtype Item is Integer;
	  type Index is mod N;
	  type Item_Array is array(Index) of Item;
	  A: Item_Array;
      In_Ptr, Out_Ptr: Index := 0;
      Count: Integer range 0..N := 0;

   begin
      loop
         select
            when Count < N  =>
               accept Write(X : in Integer) do
                  	A(In_Ptr) := X;
		
					In_Ptr := In_Ptr  + 1;
		
					Count := Count + 1;
               end Write;
         or
            when Count > 0 =>
               accept Read(X : out Integer) do
                  	X := A (Out_Ptr);
		
					Out_Ptr := Out_Ptr + 1;  
		
					Count := Count - 1;
               end Read;
         or
            terminate;
         end select;
      end loop;
   end CircularBuffer;

   
   My_buffer : CircularBuffer;
   
   task Producer;

   task Consumer;

   task body Producer is
      Next : Time;
   begin
      Next := Clock;
      for I in 1..N loop
         -- Write to X
         X := I;
		 My_buffer.Write(X);
         -- Next 'Release' in 50..250ms
         Next := Next + Milliseconds(Random(G));
         delay until Next;
      end loop;
   end;

   task body Consumer is
      Next : Time;
	  My_out_var : Integer;
   begin
      Next := Clock;
      for I in 1..N loop
         -- Read from X
		 My_buffer.Read(My_out_var);
         Put_Line(Integer'Image(My_out_var));
         Next := Next + Milliseconds(Random(G));
         delay until Next;
      end loop;
   end;

begin -- main task
   null;
end ProducerConsumer;


