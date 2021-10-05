Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5983D4227B8
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbhJEN00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:26:26 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39486 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbhJEN00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 09:26:26 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A2C521FE4D;
        Tue,  5 Oct 2021 13:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633440274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Xq+mB+5/sdzFmbpUXLpz40bQaDjGamZYR6uZmCEoL4=;
        b=PRB2483O6XZ9zte9Vx59V2txhm03QPFYvjLqfRrnBtLNmUJUufuln9YvXBZiTlx7cGmthR
        IS7WCSmtkOPuKGRR7Ly45DDtVlNFPdcCR2nPnljs4gLYOWftE23TXN3hhPjoBPsiTaDaUj
        cw8W6k0azLJKpoVVHl2H+zjo2RkkXFM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 723CD13C35;
        Tue,  5 Oct 2021 13:24:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5xWvGhJSXGHTCgAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 05 Oct 2021 13:24:34 +0000
Subject: Re: [PATCH v2] s390: Fix strrchr() implementation
To:     Heiko Carstens <hca@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Cc:     gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211005120836.60630-1-roberto.sassu@huawei.com>
 <YVxP0OoUWQvhmqkq@osiris>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <4eb4c1ea-d392-62fd-201f-472f24496f46@suse.com>
Date:   Tue, 5 Oct 2021 15:24:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YVxP0OoUWQvhmqkq@osiris>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="znTsKSH7eNoWkFxbfuwt9NK4ZchiHfkgJ"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--znTsKSH7eNoWkFxbfuwt9NK4ZchiHfkgJ
Content-Type: multipart/mixed; boundary="7T65fGBTD9NxKIWf7NPY43cyXSpJTYPFQ";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Heiko Carstens <hca@linux.ibm.com>,
 Roberto Sassu <roberto.sassu@huawei.com>
Cc: gor@linux.ibm.com, borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <4eb4c1ea-d392-62fd-201f-472f24496f46@suse.com>
Subject: Re: [PATCH v2] s390: Fix strrchr() implementation
References: <20211005120836.60630-1-roberto.sassu@huawei.com>
 <YVxP0OoUWQvhmqkq@osiris>
In-Reply-To: <YVxP0OoUWQvhmqkq@osiris>

--7T65fGBTD9NxKIWf7NPY43cyXSpJTYPFQ
Content-Type: multipart/mixed;
 boundary="------------DE5FEAE419042E8EA878C795"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------DE5FEAE419042E8EA878C795
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 05.10.21 15:14, Heiko Carstens wrote:
> On Tue, Oct 05, 2021 at 02:08:36PM +0200, Roberto Sassu wrote:
>> Fix two problems found in the strrchr() implementation for s390
>> architectures: evaluate empty strings (return the string address inste=
ad of
>> NULL, if '\0' is passed as second argument); evaluate the first charac=
ter
>> of non-empty strings (the current implementation stops at the second).=

>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Cc: stable@vger.kernel.org
>> Reported-by: Heiko Carstens <hca@linux.ibm.com> (incorrect behavior wi=
th empty strings)
>> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
>> ---
>>   arch/s390/lib/string.c | 15 +++++++--------
>>   1 file changed, 7 insertions(+), 8 deletions(-)
>=20
> Applied, thanks!
>=20

Really? I just wanted to write a response: len is unsigned (size_t)
and compared to be >=3D 0, which sounds like always true.


Juergen

--------------DE5FEAE419042E8EA878C795
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------DE5FEAE419042E8EA878C795--

--7T65fGBTD9NxKIWf7NPY43cyXSpJTYPFQ--

--znTsKSH7eNoWkFxbfuwt9NK4ZchiHfkgJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmFcUhEFAwAAAAAACgkQsN6d1ii/Ey9D
oAf/SQjfYoGHmd+LjtgjTGfPOxeFDmjiTb4fClGaWPSgDmDZizSWvBSDpaZP6nXPUkrgD4TjgyLT
QTYIYl1iNf78lIl6vbbvNPtYE/HO0WN1vzj9ClOQV1uPWBAWsO6cR/8rM4nMg+SZuo8S7xGHGXhl
ia93HaGH9K0P1ON7ciJBaRr5ZHcK583qcZCg6pfJ7g7iHNUqwrNQXyzAjDb+crpK/eIGUaYn+PD8
R4Sfh14Q2XMQ/x106dbBbgCrctLh5a6K7GZOIMaacofpBSRk5KprBB/G4WOu74Z5qwNVLMtthX4d
lP3aW8yYWLJp6YqNjjH1EY4VZgpPV1V52zpyzeGH3g==
=IdTX
-----END PGP SIGNATURE-----

--znTsKSH7eNoWkFxbfuwt9NK4ZchiHfkgJ--
