=xml
<document title="Hashing Functions">
    <synopsis>
        Functions related to hashing data.
    </synopsis>
=cut

package hash;

=xml
    <function name="fast">
        <synopsis>
            Returns a hashed value of a string, and is hopefully pretty quick about it
        </synopsis>
        <note>
            Hashes are curently 9-10 characters long with this algorithm.
        </note>
        <note>
            This is used primarily to create fixed-length, database-indexable hashes
            for quick url lookups.
        </note>
        <note>
            This function automatically reverts to SHA1 (truncated to 10 characters)
            if JHash is not available, -HOWEVER- you should -NEVER- switch between
            using both.
            
            This can be problematic if your production enviroment has JHash and your
            development environment does not.  Eventually I will get around to
            writing a pure-perl JHash algorithm for use where C versions are not
            available.
            
            On nix you should have no trouble installing JHash via:
                perl -MCPAN -e "install Digest::JHash"
            For Windows using ActivePerl, see the extras directory for a .ppd.  To
            install it: cd to the directory containing the .ppd file and type:
                ppm install Digest-JHash.ppd
        </note>
        <prototype>
            string = hash::fast(string)
        </prototype>
        <todo>
            pad to 10 chars? -- Pg will need this if you use char(10)!
        </todo>
        <todo>
            pure-perl JHash
        </todo>
    </function>
=cut

eval { require Digest::JHash };
if ($@) {
    eval q~
        sub fast {
            return substr(Digest::SHA::sha1_hex(shift), 0, 10);
        }
    ~;
} else {
    eval q~
        sub fast {
            return Digest::JHash::jhash(shift);
        }
    ~;
}

=xml
    <function name="secure">
        <synopsis>
            Returns a hashed value of a string, and is hopefully pretty hard to crack
        </synopsis>
        <note>
            Hashes are curently 128 characters long with this algorithm (SHA512).
        </note>
        <note>
            If the Digest::SHA module is not installed, a pure-perl version will be
            used instead.  It is pretty slow, but fine for most purposes, since
            hash_secure is not used often.
        </note>
        <note>
            If you are using the pure-perl SHA module, you should DEFINITELY have
            JHash installed, since hash::fast() is called quite often.
        </note>
        <prototype>
            string = hash::secure(string)
        </prototype>
    </function>
=cut

eval { require Digest::SHA };
require Digest::SHA::PurePerl if $@;

sub secure {
    return Digest::SHA::sha512_hex(shift);
}

=xml
    <function name="md5">
        <synopsis>
            Returns a hashed md5 value of a string
        </synopsis>
        <note>
            Hashes are 32 characters long.
        </note>
        <note>
            MD5 hashing is optional and will only be loaded if MD5 is installed.
        </note>
        <prototype>
            string = hash::md5(string)
        </prototype>
    </function>
=cut

eval { require Digest::MD5 };
unless ($@) {
   sub md5 {
       return Digest::MD5::md5_hex(shift);
   }
}

=xml
    <function name="rot13">
        <synopsis>
            Returns a ciphered rot13 value of a string
        </synopsis>
        <note>
            The returned value is equal length to the input.
        </note>
        <note>
            This should /NEVER/ be used for encryption. 
        </note>
        <prototype>
            string = hash::rot13(string)
        </prototype>
    </function>
=cut

sub rot13 {
    my $string = shift;
       $string =~ tr/A-Za-z/N-ZA-Mn-za-m/;
    
    return $string;
}

# Copyright BitPiston 2008
1;
=xml
</document>
=cut