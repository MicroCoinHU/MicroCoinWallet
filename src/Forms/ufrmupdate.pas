unit UFRMUpdate;
{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, httpsend;

type

  { TUpdateForm }

  TUpdateForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  UpdateForm: TUpdateForm;

implementation

{$R *.lfm}

{ TUpdateForm }

procedure TUpdateForm.FormCreate(Sender: TObject);
begin
end;

end.

