/*


Mutation( options: MutationOptions(   
  document: gql(addCounter),
   update: (GraphQLDataProxy cache, QueryResult result)
    {  
       return cache;   },  
      onCompleted: (dynamic resultData) {

    print(resultData);   
    }, ),
     builder: (
    RunMutation runMutation,   QueryResult result, ) 
    {
    return FlatButton(     
        onPressed: () => runMutation({ 
      'counterId': 21,           }),       
     child: Text('Add Counter')); 
     },);

*/