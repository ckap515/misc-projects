choose <- function(x, y){
	result <- sample(1:(x+y), 1)
	print(result)
	if (x == y){
		if (result <= x){
			print("top team")
		}
		else{
			print("bottom team")
		}
	}
	else{
		if (result <= max(x,y)){
			print("higher seed")
		}
		else{
			print("lower seed")
		}
	}
}