.ORIG 	x3000
		LD		R0,NUM
		TRAP	x0026	
		HALT
NUM		.FILL		#-1999
.END