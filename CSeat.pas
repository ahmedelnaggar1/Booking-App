{
   ____ ____             _   
  / ___/ ___|  ___  __ _| |_ 
 | |   \___ \ / _ \/ _` | __|
 | |___ ___) |  __/ (_| | |_ 
  \____|____/ \___|\__,_|\__|

This class will handle everything related to a seat.
This class shall be used by CShow.                         

}

unit CSeat;

interface

uses ShowFrame, Vcl.ExtCtrls, Vcl.Forms; // TShape, TFrame

type TSeat = class

    private
        id         : Integer; // The ID of the seat, ideally should be static and then iterated within this class for every instance,
                              // but that is not possible in delphi apparently
        taken      : Boolean;

        price      : Real; 
        _type      : Integer; // The type of seat, is it premium or normal
        

    published

        constructor create(id : Integer);

        function is_taken()                : Boolean;
        function get_num()                 : Integer; // Return the seat number
        function get_type()                : String;
        function get_price()               : Real;

        procedure set_price(price : Real);
        procedure set_id(id : Integer);
        procedure set_type(_type : Integer);
        procedure occupy(taken : Boolean);

end;

implementation

constructor TSeat.create(id : Integer);
begin
{
    Constructor of Seat
    Parameter:
      id (Integer): the ID of the seat
}

    self.id     := id;
    self.taken  := false;

end;

function Tseat.is_taken() : Boolean;
begin
{
    Returns whether the seat is taken or not
    Return:
        result (Boolean):
          true: seat is taken
          false: seat is not taken
}

    Result := self.taken;

end;

procedure TSeat.set_price(price : Real);
begin
{
    Sets the price of the seat
    Parameter:
      price (Real): price
}
  self.price := price
end;

procedure TSeat.set_type(_type : Integer);
begin
{
    Sets the seat type
    Parameter:
      _type (Integer): the seat type
                    1: Premium 
                    0: Normal
}
  self._type := _type;
end;


procedure TSeat.set_id(id : Integer);
begin
{
    Sets the ID of the seat
    Parameter:
      id (Integer): the ID
}
  self.id := id;
end;

procedure TSeat.occupy(taken : Boolean);
begin
{
    Sets whether the seat is occupied or not
    Parameter:
      taken (Boolean): is the seat taken or not
}
    self.taken := taken;

end;

function TSeat.get_num(): Integer;
begin
{
    Retrieves the ID of the seat
    Return:
        result (Integer): ID of seat
}
    Result := self.id;

end;

function TSeat.get_type(): String;
begin
{
    Retrieves the seat type
    Return:
        result (String): Regular or Premium
}
  
    if(self._type = 0) then 
        Result := 'Regular'
    else
        Result := 'Premium'

end;

function TSeat.get_price(): Real;
begin
{
    Retrieves the price of the seat
    Return:
        result (Real): price of seat
}
  
    Result := self.price;

end;

end.
