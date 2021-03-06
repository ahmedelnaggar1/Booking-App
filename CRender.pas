{
   ____ ____                _           
  / ___|  _ \ ___ _ __   __| | ___ _ __ 
 | |   | |_) / _ \ '_ \ / _` |/ _ \ '__|
 | |___|  _ <  __/ | | | (_| |  __/ |   
  \____|_| \_\___|_| |_|\__,_|\___|_|   
                                        
This class will handle the rendering of a TShow onto a TFrame

}

unit CRender;

interface

uses Vcl.Forms, Vcl.ExtCtrls, CShow, System.Generics.Collections, CSeat, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
     Vcl.Graphics, Vcl.Controls, Vcl.Dialogs; //TFrame, TShape

type
    TRender = class

    private

        main_frame  : TFrame; // The frame to render on to
        show        : TShow;  // The show to render

        shapes      : TObjectList<TShape>; // The shapes for the seats
        prev_shape  : Integer; // The id of the previously selected shape

        seat_height : Integer;
        seat_width  : Integer;

        stage       : TShape; // The actual "stage"

        current_seat : Integer; // Current seat for create_seat

        function create_seat(width : Integer; height : Integer; left : Integer; Top : Integer; taken : Boolean) : TShape;

        procedure on_mouse_up(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); // Handle the user clicking on a seat

    published

        constructor create(main_frame: TFrame; show : TShow);
        destructor destroy();

        function draw() : Boolean;
        function update() : Boolean;
        procedure highlight_seat(seat_num : Integer);

end;

implementation

constructor TRender.create(main_frame : TFrame; show : TShow);
begin

    self.main_frame := main_frame;
    self.main_frame.Tag    := -1; // Set the default tag to -1 as seats start number from 0
                                  // The 'Tag' attribute in the frame will hold the selected seat
    self.main_frame.Width  := 320;
    self.main_frame.Height := 240;

    self.show := show;

    self.shapes := TObjectList<Tshape>.Create();

    self.seat_height := 20;
    self.seat_width  := 20;
    self.prev_shape  := -1;

    self.current_seat := 0;
end;

destructor TRender.destroy();
var shapes : TShape;
begin
    //Free all shapes to prevent memory leak
    for shapes in self.shapes do
        shapes.Free();
end;


function TRender.draw() : Boolean;
{
    Renders the show to the frame main_frame
    Return:
        result (Boolean): was the rendering successful or not
}

var seats             : TObjectList<TSeat>;
var seat              : TSeat;
var count             : Integer;

var num_premium       : Integer; // Number of premium seats
var current_seat      : Integer;
var num_of_seats_per_side                : Integer; // The number of seats per side (number of guests / 3)
var vert_column_left, vert_column_right  : Integer; // The number of columns on left side of stage

var x_padding         : Real;
var iterator          : Integer;
var x, y              : Integer;
begin
  
    // Set the size of the frame to 320 x 240
    self.main_frame.Width  := 320;
    self.main_frame.Height := 240;

    //----------------------------------------------
    // Create the stage
    //----------------------------------------------
    self.stage := TShape.Create(main_frame);
    self.stage.Width     := 96;
    self.stage.Height    := 153;

    self.stage.Left      := 112;
    self.stage.Top       := 0;

    self.stage.Parent := main_frame;

    self.stage.Brush.Style := bsDiagCross;
    self.stage.Pen.Color   := clSilver;
    self.stage.Show();

    self.current_seat := 0;


    //----------------------------------------------
    //
    //      BEGIN CREATING SEATS
    //
    //----------------------------------------------
    seats := self.show.get_seats();

    count := 0;

    // Premium seats are those that are close to the stage
    // For the sides:
    // let h = height of seat, hs = height of stage
    // x: number of seats on one side
    // x = hs/h
    // Total seats on both sides = x * 2

    // Find premium seats : 23 seats
    // Sides
    // Left side

    self.current_seat := 0;

    //          | PREMIUM SEATS |

    iterator := 0;
    vert_column_left := 1;

    //-17 to compensate for stage boundary
    for count := 0 to 6 do
    begin

        if iterator = 7 then
        begin
          vert_column_left := vert_column_left + 1;
          iterator := 0;
        end;
        x := stage.Left - vert_column_left * 30;
        y := iterator * seat_height + 17; 
        //Left side
        self.shapes.Add( self.create_seat(seat_width, seat_height, x, y, seats[self.current_seat].is_taken()) );
       
        iterator := iterator + 1;

    end;

    // this is terribly done but it works
    
    iterator := 0;
    vert_column_right := 1;
    
    for count := 0 to 6 do
    begin
        if iterator = 7 then
        begin
          vert_column_right := vert_column_right + 1;
          iterator := 0;
        end;
        x := (stage.Left + 75) + vert_column_right * 30;
        y := iterator * seat_height + 17; 
        
        //Right side
        self.shapes.Add( self.create_seat(seat_width, seat_height, x, y, seats[self.current_seat].is_taken()) );

        iterator := iterator + 1;

    end;
    
    // Bottom side
    for iterator := 0 to 2 do
    begin
        for count := 0 to Round( (stage.Width * seat_height) / (self.seat_width * self.seat_width) )-1 do
            self.shapes.Add( self.create_seat(seat_width, seat_height, 90 + (count * seat_width) + 23, 
                            stage.Height + (iterator * 23), seats[self.current_seat].is_taken()) ); // +23 for padding from left
    end;

    //          | REGULAR SEATS |

    //Left side
    iterator := 0;
    vert_column_left := 2;
    for count := 0 to 6 do
    begin

        if iterator = 7 then
        begin
          vert_column_left := vert_column_left + 1;
          iterator := 0;
        end;
        x := stage.Left - vert_column_left * 30;
        y := iterator * seat_height + 17; 
        
        self.shapes.Add( self.create_seat(seat_width, seat_height, x, y, seats[self.current_seat].is_taken()) );
       
        iterator := iterator + 1;

    end;
    
    //Right side
    iterator := 0;
    vert_column_right := 2;
    for count := 0 to 6 do
    begin
        if iterator = 7 then
        begin
          vert_column_right := vert_column_right + 1;
          iterator := 0;
        end;
        x := (stage.Left + 75) + vert_column_right * 30;
        y := iterator * seat_height + 17; 
        
        self.shapes.Add( self.create_seat(seat_width, seat_height, x, y, seats[self.current_seat].is_taken()) );

        iterator := iterator + 1;

    end;


end;


function TRender.create_seat(width: Integer; height: Integer; left: Integer; top: Integer; taken : Boolean): TShape;
{
    Creates the seat to be rendered
    Parameters:
        width       (Integer): The width of the seat
        height      (Integer): The height of the seat
        left        (Integer): Position from the left, x units
        top         (Integer): Position from the top, x units
        taken       (Boolean): Is the seat taken by a Guest
    Return:
        temp_shape (TShape): The final shape object
}
var temp_shape : TShape;
begin
    temp_shape                  := TShape.Create(self.main_frame);
    temp_shape.Width            := width;
    temp_shape.Height           := height;
    temp_shape.Parent           := self.main_frame;
    temp_shape.Shape            := stRectangle;

    temp_shape.Left             := left;
    temp_shape.Top              := top;

    temp_shape.OnMouseUp        := self.on_mouse_up;
    temp_shape.Tag              := self.current_seat;

    temp_shape.Pen.Style        := psClear;
    temp_shape.ParentShowHint   := False;
    temp_shape.Hint             := IntToStr( self.current_seat );

    temp_shape.ShowHint         := True;


    if (taken) then temp_shape.Brush.Color := clMaroon
    else temp_shape.Cursor  := crHandPoint;
    
    temp_shape.Show();

    self.current_seat := self.current_seat + 1;

    Result := temp_shape;
end;

procedure TRender.on_mouse_up(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var shape : TShape;
var seat  : TSeat;
var form  : TForm;
begin
{
    Handles the clicking of a seat
}
    shape := Sender as Tshape;
    seat := self.show.get_seat(shape.Tag);

    // Check if seat is taken because we don't want the user to be able to choose already taken seats
    if (not seat.is_taken()) then
    begin

        // Check if the selected seat is the same as the already selected one
        // Basically, toggle the seat whether its selected or not
        if (self.prev_shape = shape.Tag) then
        begin
            self.main_frame.Tag := -1;
            self.prev_shape     := -1;
            shape.Brush.Color := clWhite;
        end
        else
        begin

          self.main_frame.Tag := shape.Tag;

          // Highlight the seat
          shape.Brush.Color := clGreen;

          // De-select the previously selected seat ( if any )
          if(self.prev_shape <> -1) then
              self.shapes[prev_shape].Brush.Color := clWhite;

          self.prev_shape := shape.Tag;
        end;

    end;

end;

procedure TRender.highlight_seat(seat_num : Integer);
begin
    // Highlights a specific seat

    self.shapes[seat_num].Brush.Color := clBlue;

end;

function TRender.update() : Boolean;
var seat  : TSeat;
var id    : Integer;
begin
{
    Updates the Render
    Return:
        result (Boolean): whether or not the operation was succesful
}
    // Loop through all seats and make sure that their colours are correct
    for seat in self.show.get_seats() do
    begin
        id := seat.get_num();

        if(seat.is_taken()) then
        begin

            // Set seat to red
            self.shapes[id].Brush.Color := clMaroon;
            self.shapes[id].Cursor      := crDefault;

        end
        else
            self.shapes[id].Brush.Color := clWhite;
    end;
    self.main_frame.Tag := -1;
    self.prev_shape     := -1;

    Result := true;

end;

end.

