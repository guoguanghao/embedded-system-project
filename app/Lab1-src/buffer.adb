package body Buffer is
   protected body CircularBuffer is

		 
	  entry Write(X : in integer) when Count < N is
      begin
	    
		A(In_Ptr) := X;
		
		In_Ptr := In_Ptr  + 1;
		
		Count := Count + 1;
        
      end Write;
      
      entry Read (X : out integer) when Count > 0 is
	  
      begin

		X := A (Out_Ptr);
		
		Out_Ptr := Out_Ptr + 1;  
		
		Count := Count - 1;
		
      end Read;
   end CircularBuffer;
   
   
end Buffer;


