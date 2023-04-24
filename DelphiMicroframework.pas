unit Microframework;

interface

uses
  IdHTTPServer, IdCustomHTTPServer, IdSSL, IdSSLOpenSSL, System.Classes;

type
  TMicroframework = class
  private
    FPort: Integer;
    FServer: TIdHTTPServer;
    procedure HandleGetRequest(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure HandlePostRequest(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  public
    constructor Create(APort: Integer);
    procedure Start;
  end;

implementation

constructor TMicroframework.Create(APort: Integer);
begin
  FPort := APort;
  FServer := TIdHTTPServer.Create(nil);
  FServer.OnCommandGet := HandleGetRequest;
  FServer.OnCommandOther := HandlePostRequest;

  // Create SSL context and server certificate
  FServer.IOHandler := TIdServerIOHandlerSSLOpenSSL.Create(FServer);
  with TIdServerIOHandlerSSLOpenSSL(FServer.IOHandler) do
  begin
    SSLOptions.Mode := sslmServer;
    SSLOptions.Method := sslvTLSv1_2;
    SSLOptions.CertFile := 'server.crt';
    SSLOptions.KeyFile := 'server.key';
    SSLOptions.RootCertFile := 'ca.crt';
  end;
end;

procedure TMicroframework.Start;
begin
  FServer.DefaultPort := FPort;
  FServer.Active := True;
end;

procedure TMicroframework.HandleGetRequest(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if (ARequestInfo.URI = '/') and (ARequestInfo.Method = 'GET') then
  begin
    AResponseInfo.ResponseNo := 200;
    AResponseInfo.ContentType := 'text/plain';
    AResponseInfo.ContentText := 'Hello, World!';
  end
  else
  begin
    AResponseInfo.ResponseNo := 404;
    AResponseInfo.ContentType := 'text/plain';
    AResponseInfo.ContentText := 'Not Found';
  end;
end;

procedure TMicroframework.HandlePostRequest(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if (ARequestInfo.URI = '/') and (ARequestInfo.Method = 'POST') then
  begin
    AResponseInfo.ResponseNo := 200;
    AResponseInfo.ContentType := 'text/plain';
    AResponseInfo.ContentText := 'Received POST request';
  end
  else
  begin
    AResponseInfo.ResponseNo := 404;
    AResponseInfo.ContentType := 'text/plain';
    AResponseInfo.ContentText := 'Not Found';
  end;
end;

end.
