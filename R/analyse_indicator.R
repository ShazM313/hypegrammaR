

#' Complete  analysis for one hypothesis
#'
#' Produce summary statistics, hypothesis tests and plot objects for a 
#'
#' @param data 
#' @param dependent.var string with the column name in `data` of the dependent variable
#' @param independen.var string with the column name in `data` of the independent variable
#' @param hypothesis.type the type of hypothesis as a string. Allowed values are "direct_reporting", "group_difference", "limit", "correlation" or "change"
#' @param sampling.strategy.cluster set to TRUE if you used cluster sampling 
#' @param sampling.strategy.stratified set to TRUE if you used stratified sampling 
#' @param do.for.each.unique.value.in.var if you want to repeat the analysis for multiple subsets of the data, specify the column name in `data` by which to split the dataset 
#' @details this function takes the data, information about your variables of interest, hypothesis type and sampling strategy. It selects the appropriate summary statistics, hypothesis test and visualisation and applies them.
#' @return A list with 1. the summary.statistic, 2. the hypothesis.test.result, and 3. the visualisation as a ggplot object
#' @examples
#' plot_crayons()
#'
#' @export
analyse_indicator<-function(data,
                            dependent.var,
                            independent.var = NULL,
                            hypothesis.type,
                            sampling.strategy.cluster=FALSE,
                            sampling.strategy.stratified=FALSE,
                            do.for.each.unique.value.in.var = NULL){


  
    
        # sanitise input
            if(!is.null(do.for.each.unique.value.in.var)){stop("do.for.each.unique.value.in.var must be NULL (not yet implemented)")}
            if(cluster){stop("cluster must be FALSE (not yet implemented)")}

            # data <- data[!is.na(data[,dependent.var]),]
            if(nrow(data)==0){stop('provided data has no rows where dependent.var is not NA')}
            if(all(is.na(data[,dependent.var]))){stop(paste('variable', dependent.var, 'can\'t be all NA'))}

  
        # map from input to analysis case:
        case <- map_to_case(hypothesis.type = hypothesis.type,
                                   data = data,
                                   dependent.var = dependent.var,
                                   independent.var = independent.var,
                                   paired = NULL)
        
  
        # map from case to appropriate summary statistic, hypothesis test and visualisation:
            design <- map_to_design(data = data, cluster.var = NULL)
            summarise.result<- map_to_summary_statistic(case)
            test.hypothesis <- map_to_hypothesis_test(case)
            visualisation <- map_to_visualisation(case)
            
            
            
        # apply the ummary statistic, hypothesis test to the given data and survey design:  
            summary.result  <- summarise.result(dependent.var,independent.var, design)
        # do hypothesis test:
            hypothesis.test.result<- test.hypothesis(dependent.var,independent.var, design)
            
        # add results to the visualisation:
            # visualisation<-visualisation+ggplot()...
        return(list(
                    summary.statistic=summary.result,
                    hypothesis.test.result=hypothesis.test.result,
                    visualisation=visualisation
              ))
        
    }
  

