%main program for trible des encryption

fid = fopen('c:\encryptedfile.txt','r+');%open the file
f = fread(fid,8);%read from the file
fclose(fid);
asci=double(f);%convert from char to asciicode
for i=1:8
    Data((i-1)*8+1:i*8)=bitget(asci(i),8:-1:1);
end

y=input('input 8 charachters key1','s')
asci=double(y);%convert from char to asciicode
for i=1:8
    key1((i-1)*8+1:i*8)=bitget(asci(i),8:-1:1);
end
y=key1;
xl=[y(57) y(49) y(41) y(33) y(25) y(17) y(9) y(1) y(58) y(50) y(42) y(34) y(26) y(18) y(10) y(2) y(59) y(51) y(43) y(35) y(27) y(19) y(11) y(3) y(60) y(52) y(44) y(36)];
xr=[y(63) y(55) y(47) y(39) y(31) y(23) y(15) y(7) y(62) y(54) y(46) y(38) y(30) y(22) y(14) y(6) y(61) y(53) y(45) y(37) y(29) y(21) y(13) y(5) y(28) y(20) y(12) y(4)];
kf1=kg(xl,xr);


q=input('input 8 charachters key2','s')
asci=double(y);%convert from char to asciicode
for i=1:8
    key2((i-1)*8+1:i*8)=bitget(asci(i),8:-1:1);
end
e=key2;
xl=[e(57) e(49) e(41) e(33) e(25) e(17) e(9) e(1) e(58) e(50) e(42) e(34) e(26) e(18) e(10) e(2) e(59) e(51) e(43) e(35) e(27) e(19) e(11) e(3) e(60) e(52) e(44) e(36)];
xr=[e(63) e(55) e(47) e(39) e(31) e(23) e(15) e(7) e(62) e(54) e(46) e(38) e(30) e(22) e(14) e(6) e(61) e(53) e(45) e(37) e(29) e(21) e(13) e(5) e(28) e(20) e(12) e(4)];
kf2=kg(xl,xr);

temp=Data;
C=trible_dec(temp,kf1);
temp=C;
B=trible_enc(temp,kf2);
temp=B;
A=trible_dec(temp,kf1);
w=A;
DecryptedCharacters=[];
for i=1:8
    BinaryCode=w((i-1)*8+1:8*i);
    T=BinaryCode;
    %convert from binary to decimal
    DecimalValue=T(8)*1+T(7)*2+T(6)*4+T(5)*8+T(4)*16+T(3)*32+T(2)*64+T(1)*128;
    DecryptedCharacters=[DecryptedCharacters char(DecimalValue)];
end
file = fopen('c:\decryptedfile.txt','w+');%create and open file
f = fwrite(file,DecryptedCharacters);%write in file
fclose(file);
