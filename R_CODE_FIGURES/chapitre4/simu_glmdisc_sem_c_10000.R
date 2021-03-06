


library(glmdisc)

d=3

generate_data <- function(k,n) {
    set.seed(k)
    x = matrix(runif(d*n), nrow = n, ncol = d)
    cuts = seq(0,1,length.out= 4)
    xd = apply(x,2, function(col) as.numeric(cut(col,cuts)))
    theta = t(matrix(c(0,0,0,2,2,0,-2,-2,0),ncol=3,nrow=3))
    log_odd = rowSums(t(sapply(seq_along(xd[,1]), function(row_id) sapply(seq_along(xd[row_id,]),
                                                                          function(element) theta[xd[row_id,element],element]))))
    y = rbinom(n,1,1/(1+exp(-log_odd)))
    return(list(x=x,y=y,log_odd=log_odd))
}

list_levels = array(0,dim=100)

for (b in 1:100) {
    list2env(generate_data(b,10000),env=environment())
    
    sem_disc = tryCatch(glmdisc(x,y,iter=500,m_start=3,test=FALSE,validation=FALSE,criterion="bic",interact=FALSE), error = function(e) 0, finally = print("error"))
    
    list_levels[b] = nlevels(factor(sem_disc@disc.data[,3]))
}

summary(factor(list_levels))

# 1 : 30 // 2 : 48 // 3 : 22

