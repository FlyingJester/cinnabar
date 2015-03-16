:- module foo.
 
:- interface.
 
:- import_module io.
 
:- pred main(io::di, io::uo) is det.
 
:- implementation.
 
:- import_module list.
 
main(!IO) :-
    foldl(write_string, my_list, !IO).
 
:- func my_list = list(string).
 
my_list = ["a", "list", "of", "strings."].
