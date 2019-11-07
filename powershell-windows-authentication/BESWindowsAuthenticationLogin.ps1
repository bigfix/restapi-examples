Param([parameter(Mandatory=$true,
   HelpMessage="Enter server url [ -server <server url> ]")]
   $serverUrl
   )
if(!$serverUrl){
return "Enter server url [ -server <server url> ]"
}
function GetBigFixToken {
    [CmdletBinding()]
     param($PN)
    $Signature = @"

public enum SecBufferType
{
    SECBUFFER_VERSION = 0,
    SECBUFFER_EMPTY = 0,
    SECBUFFER_DATA = 1,
    SECBUFFER_TOKEN = 2
}

[StructLayout(LayoutKind.Sequential)]
public struct SECURITY_INTEGER
{
    public uint LowPart;
    public int HighPart;
    public SECURITY_INTEGER(int dummy)
    {
    LowPart = 0;
    HighPart = 0;
    }
};

[StructLayout(LayoutKind.Sequential)]
public struct SecBuffer :  IDisposable
{
    public int cbBuffer;
    public int BufferType;
    public IntPtr pvBuffer;


    public SecBuffer(int bufferSize)
    {
    cbBuffer = bufferSize;
    BufferType = (int)SecBufferType.SECBUFFER_TOKEN;
    pvBuffer = Marshal.AllocHGlobal(bufferSize);
    }

    public SecBuffer(byte[] secBufferBytes)
    {
        cbBuffer = secBufferBytes.Length;
        BufferType = (int)SecBufferType.SECBUFFER_TOKEN;
        pvBuffer = Marshal.AllocHGlobal(cbBuffer);
        Marshal.Copy(secBufferBytes,0,pvBuffer,cbBuffer);
    }

    public SecBuffer(byte[] secBufferBytes,SecBufferType bufferType)
    {
        cbBuffer = secBufferBytes.Length;
        BufferType = (int)bufferType;
        pvBuffer = Marshal.AllocHGlobal(cbBuffer);
        Marshal.Copy(secBufferBytes,0,pvBuffer,cbBuffer);
    }

    public void Dispose()
    {
        if(pvBuffer != IntPtr.Zero)
        {
            Marshal.FreeHGlobal(pvBuffer);
            pvBuffer = IntPtr.Zero;
        }
    }
}

public struct MultipleSecBufferHelper
{
    public byte[] Buffer;
    public SecBufferType BufferType;

    public MultipleSecBufferHelper(byte[] buffer,SecBufferType bufferType)
    {
        if(buffer == null || buffer.Length == 0)
        {
            throw new ArgumentException("buffer cannot be null or 0 length");
        }

        Buffer = buffer;
        BufferType = bufferType;
    }
};

[StructLayout(LayoutKind.Sequential)]
public struct SecBufferDesc : IDisposable
{

    public int ulVersion;
    public int cBuffers;
    public IntPtr pBuffers; //Point to SecBuffer

    public SecBufferDesc(int bufferSize)
    {
    ulVersion = (int)SecBufferType.SECBUFFER_VERSION;
    cBuffers = 1;
        SecBuffer ThisSecBuffer = new SecBuffer(bufferSize);
    pBuffers = Marshal.AllocHGlobal(Marshal.SizeOf(ThisSecBuffer));
    Marshal.StructureToPtr(ThisSecBuffer,pBuffers,false);
    }

    public SecBufferDesc(byte[] secBufferBytes)
    {
        ulVersion = (int)SecBufferType.SECBUFFER_VERSION;
        cBuffers = 1;
        SecBuffer ThisSecBuffer = new SecBuffer(secBufferBytes);
        pBuffers = Marshal.AllocHGlobal(Marshal.SizeOf(ThisSecBuffer));
        Marshal.StructureToPtr(ThisSecBuffer,pBuffers,false);
    }

    public SecBufferDesc(MultipleSecBufferHelper[] secBufferBytesArray)
    {
        if(secBufferBytesArray == null || secBufferBytesArray.Length == 0)
        {
            throw new ArgumentException("secBufferBytesArray cannot be null or 0 length");
        }

        ulVersion = (int)SecBufferType.SECBUFFER_VERSION;
        cBuffers = secBufferBytesArray.Length;

        pBuffers = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(SecBuffer)) * cBuffers);

        for(int Index = 0;Index < secBufferBytesArray.Length;Index++)
        {
            SecBuffer ThisSecBuffer = new SecBuffer(secBufferBytesArray[Index].Buffer,secBufferBytesArray[Index].BufferType);

            int CurrentOffset = Index*Marshal.SizeOf(typeof(SecBuffer));
            Marshal.WriteInt32(pBuffers,CurrentOffset,ThisSecBuffer.cbBuffer);
            Marshal.WriteInt32(pBuffers,CurrentOffset + Marshal.SizeOf(ThisSecBuffer.cbBuffer),ThisSecBuffer.BufferType);
            Marshal.WriteIntPtr(pBuffers,CurrentOffset + Marshal.SizeOf(ThisSecBuffer.cbBuffer)+Marshal.SizeOf(ThisSecBuffer.BufferType),ThisSecBuffer.pvBuffer);
        }
    }

    public void Dispose()
    {
        if(pBuffers != IntPtr.Zero)
        {
            if(cBuffers == 1)
            {
                SecBuffer ThisSecBuffer = (SecBuffer)Marshal.PtrToStructure(pBuffers,typeof(SecBuffer));
                ThisSecBuffer.Dispose();
            }
            else
            {
                for(int Index = 0;Index < cBuffers;Index++)
                {
                    int CurrentOffset = Index*Marshal.SizeOf(typeof(SecBuffer));
                    IntPtr SecBufferpvBuffer = Marshal.ReadIntPtr(pBuffers,CurrentOffset + Marshal.SizeOf(typeof(int))+Marshal.SizeOf(typeof(int)));
                    Marshal.FreeHGlobal(SecBufferpvBuffer);
                }
            }

            Marshal.FreeHGlobal(pBuffers);
            pBuffers = IntPtr.Zero;
        }
    }

    public byte[] GetSecBufferByteArray()
    {
        byte[] Buffer = null;

        if(pBuffers == IntPtr.Zero)
        {
            throw new InvalidOperationException("Object has already been disposed!!!");
        }

        if(cBuffers == 1)
        {
            SecBuffer ThisSecBuffer = (SecBuffer)Marshal.PtrToStructure(pBuffers,typeof(SecBuffer));

            if(ThisSecBuffer.cbBuffer > 0)
            {
                Buffer = new byte[ThisSecBuffer.cbBuffer];
                Marshal.Copy(ThisSecBuffer.pvBuffer,Buffer,0,ThisSecBuffer.cbBuffer);
            }
        }
        else
        {
            int BytesToAllocate = 0;

            for(int Index = 0;Index < cBuffers;Index++)
            {
                int CurrentOffset = Index*Marshal.SizeOf(typeof(SecBuffer));
                BytesToAllocate += Marshal.ReadInt32(pBuffers,CurrentOffset);
            }

            Buffer = new byte[BytesToAllocate];

            for(int Index = 0,BufferIndex = 0;Index < cBuffers;Index++)
            {
                int CurrentOffset = Index*Marshal.SizeOf(typeof(SecBuffer));
                int BytesToCopy = Marshal.ReadInt32(pBuffers,CurrentOffset);
                IntPtr SecBufferpvBuffer = Marshal.ReadIntPtr(pBuffers,CurrentOffset + Marshal.SizeOf(typeof(int))+Marshal.SizeOf(typeof(int)));
                Marshal.Copy(SecBufferpvBuffer,Buffer,BufferIndex,BytesToCopy);
                BufferIndex += BytesToCopy;
            }
        }

        return(Buffer);
    }

    public SecBuffer GetSecBuffer()
    {
        if(pBuffers == IntPtr.Zero)
        {
            throw new InvalidOperationException("Object has already been disposed!!!");
        }

        return((SecBuffer)Marshal.PtrToStructure(pBuffers,typeof(SecBuffer)));
    }
}

[StructLayout(LayoutKind.Sequential)]
public struct SECURITY_HANDLE
{
    public uint LowPart;
    public uint HighPart;
    public SECURITY_HANDLE(int dummy)
    {
    LowPart = HighPart = 0;
    }
};


[DllImport("secur32.dll", SetLastError=true)]
static extern int AcquireCredentialsHandle(
    string pszPrincipal, //SEC_CHAR*
    string pszPackage, //SEC_CHAR* //"Kerberos","NTLM","Negotiative"
    int fCredentialUse,
    IntPtr PAuthenticationID,//_LUID AuthenticationID,//pvLogonID, //PLUID
    IntPtr pAuthData,//PVOID
    int pGetKeyFn, //SEC_GET_KEY_FN
    IntPtr pvGetKeyArgument, //PVOID
    ref SECURITY_HANDLE phCredential, //SecHandle //PCtxtHandle ref
    ref SECURITY_INTEGER ptsExpiry //PTimeStamp //TimeStamp ref
);

[DllImport("secur32.dll", SetLastError=true)]
static extern int InitializeSecurityContext(
    ref SECURITY_HANDLE phCredential,//PCredHandle
    IntPtr phContext, //PCtxtHandle
    string pszTargetName,
    int fContextReq,
    int Reserved1,
    int TargetDataRep,
    IntPtr pInput, //PSecBufferDesc SecBufferDesc
    int Reserved2,
    out SECURITY_HANDLE phNewContext, //PCtxtHandle
    out SecBufferDesc pOutput, //PSecBufferDesc SecBufferDesc
    out uint pfContextAttr, //managed ulong == 64 bits!!!
    out SECURITY_INTEGER ptsExpiry //PTimeStamp
);

public static SECURITY_HANDLE phCredential;
public static SECURITY_INTEGER ptsExpiry;

public const int ISC_REQ_DELEGATE      =     0x00000001;
public const int ISC_REQ_MUTUAL_AUTH       =     0x00000002;
public const int ISC_REQ_CONFIDENTIALITY   =     0x00000010;
public const int ISC_REQ_ALLOCATE_MEMORY    =    0x00000100;
public const int ISC_REQ_CONNECTION     =    0x00000800;
public const int ISC_REQ_INTEGRITY      =    0x00010000;


public const int STANDARD_CONTEXT_ATTRIBUTES = ISC_REQ_CONNECTION | ISC_REQ_MUTUAL_AUTH | ISC_REQ_DELEGATE | ISC_REQ_CONFIDENTIALITY | ISC_REQ_INTEGRITY | ISC_REQ_ALLOCATE_MEMORY ;
public const int SECURITY_NETWORK_DREP = 0x00000000;

public const int SEC_E_OK = 0;
public const int SECPKG_CRED_BOTH = 3;

const int MAX_TOKEN_SIZE = 12288;

public static SecBufferDesc ClientToken = new SecBufferDesc(MAX_TOKEN_SIZE);
public static uint ContextAttributes = 0;
public static SECURITY_HANDLE _hClientContext = new SECURITY_HANDLE(0);
public static SECURITY_INTEGER ptsexp;


public static int GetPrincipalName() {
    return AcquireCredentialsHandle(
        "",
        "Kerberos",
        SECPKG_CRED_BOTH,
        IntPtr.Zero,
        IntPtr.Zero,
        0,
        IntPtr.Zero,
        ref phCredential,
        ref ptsExpiry);
}

public static string GetToken(string pn) {
    if( GetPrincipalName() != SEC_E_OK ) {
        throw new Exception("Unable to get PrincipleName");
    }

    InitializeSecurityContext(
                        ref phCredential,
                        IntPtr.Zero,
                        pn,
                        STANDARD_CONTEXT_ATTRIBUTES,
                        0,
                        SECURITY_NETWORK_DREP,
                        IntPtr.Zero,
                        0,
                        out _hClientContext,
                        out ClientToken,
                        out ContextAttributes,
                        out ptsexp
                        );

    byte[] token_a = ClientToken.GetSecBufferByteArray();

    return  "Kerberos " + Convert.ToBase64String(token_a);
}
"@

Add-Type -MemberDefinition $Signature -Name WindowsAuthentication -Namespace Secure32
    [Secure32.WindowsAuthentication]::GetToken($PN)
}

#if the server certificate is self signed we need set Powershell to skip SSL certificate checks
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy




$PrincipleName = "";

#The first request is needed to retrieve the principle name. It can be skipped if you already know it.
try
{
    Invoke-WebRequest -Uri ('https://'+$serverUrl+':52311/api/login') -Headers @{'PrincipalName' = ''}
}
catch [System.Net.WebException]
{
    if($_.Exception.Response.StatusCode.value__ -and $_.Exception.Response.StatusCode.value__ -eq 401){

        $PrincipleName = $_.Exception.Response.Headers['PrincipalName']
        #The returned token from GetBigFixToken is already in the requested form "Kerberos <token value>"
        $token = GetBigFixToken $PrincipleName

        #You can ask for a session token using the login api or you can ask directly other information
        # example: Invoke-WebRequest -Uri 'http://localhost:52311/api/sites' -Headers @{'Authorization' = $token}
        $response = Invoke-WebRequest -Uri ('https://'+$serverUrl+':52311/api/login') -Headers @{'Authorization' = $token}

        if( $response.StatusCode -eq 200){
            Write-Output "Login successful. Session Token received."
            #We should now keep the session token returned and use it in the next requests
            #Write-Output ("{0} {1}" -f 'SessionToken: ', $response.Headers["SessionToken"])
            #Invoke-WebRequest -Uri ('https://'+$serverUrl+':52311/api/sites') -Headers @{'SessionToken' = $response.Headers["SessionToken"]} -OutFile ./result.xml

        }
        else {
            Write-Output ("Unable to complete login.")
        }
    }
    else{
        Write-Output ("Something went wrong contacting the BigFix Server $serverUrl.")
    }
}



