-- Package: Semaphores

-- package body Semaphores is
   -- protected body CountingSemaphore is
      -- entry Wait -- To be completed

      -- entry Signal -- To be completed
   -- end CountingSemaphore;
-- end Semaphores;

package body Semaphores is
   protected body CountingSemaphore is
      entry Wait when Count > 0 is
      begin
         Count := Count - 1;
      end Wait;

      entry Signal when Count < MaxCount is -- when Count < MaxCount is
      begin
			 Count := Count + 1;
	  end Signal;
   end CountingSemaphore;
end Semaphores;
