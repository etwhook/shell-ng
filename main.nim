import cligen, std/[enumerate, strutils, strformat, os]
proc main(format : string = "nim" , key : string , representation : string = "array" , args : seq[string]) =
    if args.len() <= 0:
        echo("[-] Specify a Valid File Path.")
        return
    let filePath = args[0]
    if not os.fileExists(filePath):
        echo("[-] File not Found.")
    let keylen = key.len()
    let content = readFile(filePath)
    let length = content.len()
    var final : string
    
    echo("""
     _          _ _                  
 ___| |__   ___| | |          _ __   __ _ 
/ __| '_ \ / _ \ | |  _____  | '_ \ / _` |
\__ \ | | |  __/ | | |_____| | | | | (_| |
|___/_| |_|\___|_|_|         |_| |_|\__, |
                                    |___/ 
""")
    echo(fmt"Size of Shellcode is {length} Bytes.")
    case representation:
    of "array":
        for (i, character) in enumerate(content):
                let hexbyte = "0x" & strutils.to_lower(strutils.to_hex(ord(character) xor ord(key[i mod keylen]))).replace("00000000000000" , "") & ", "
                add(final , hexbyte)
    of "string":
        for (i, character) in enumerate(content):
                let hexbyte = "\\x" & strutils.to_lower(strutils.to_hex(ord(character) xor ord(key[i mod keylen]))).replace("00000000000000" , "")
                add(final , hexbyte)
    else:
        echo("[-] Representation is not Valid.")
    case format:
    of "nim" , "nimlang":
        case representation:
        of "array":
            echo(fmt"var shellcode : array[{$length},byte] = [byte {final}]")
        of "string":
            echo("var shellcode : string = \"" & final & "\"")
    of "c" , "cpp":
        case representation:
        of "array":
            echo(fmt"unsigned char shellcode[] = {{{final}}};")
        of "string":
            echo("char* shellcode = \"" & final & "\"")
    of "rust":
        case representation:
        of "array":
            echo(fmt"let shellcode = [{final}];")
        of "string":
            echo("let shellcode : &str = \"" & final & "\"")
    of "go" , "golang":
        case representation:
        of "array":
            echo(fmt"shellcode := []byte{{{final}}};")
        of "string":
            echo("shellcode := \"" & final & "\"")
when isMainModule:
    dispatch main
