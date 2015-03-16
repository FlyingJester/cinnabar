:- module xlistfonts.
:- interface.

:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module xlib.
:- import_module bool.
:- import_module list.
:- import_module string.

:- pred write_font(string::in, io::di, io::uo) is det.

write_font(Font, !IO) :-
    io.write_string(Font, !IO),
    io.nl(!IO).

main(!IO) :-
    io.write_string("Enter Font pattern:\n", !IO),
    io.read_line_as_string(Result, !IO),
    xlib.open_display(0, Display, Success, !IO),
    (
        Success = yes,
        (
            io.ok(Pattern) = Result,
            xlib.font_names(Display, string.strip(Pattern), FontList),
            foldl(write_font, FontList, !IO)
        ;
            io.eof = Result,
            xlib.font_names(Display, "*", FontList),
            foldl(write_font, FontList, !IO)
        ;
            io.error(Error) = Result,
            io.write_string("Input Error", !IO),
            io.write_string(io.error_message(Error), !IO),
            io.nl(!IO)
        )     
    ;
        Success = no,
        io.write_string("Error opening X11 display.\n", !IO)
    ).
