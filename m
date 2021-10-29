Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A8643F648
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 06:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhJ2EvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 00:51:16 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56244 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhJ2EvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 00:51:14 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 836721FD5B;
        Fri, 29 Oct 2021 04:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635482925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LekG6juT/qIhlhdh8j12n+rCTq9RNjI+ZAat+L4EHPY=;
        b=GRz/yiiLwJU84YvKLceV15wuMO8revzGFneV19jTsfizwtQkEokuDCPpKTE/12Cx/ueXsJ
        CnJ6KxSZWrbHlNXloCVQJHc+GTaRnYj7d1IwsqrrjcbLkkRHHHohMVCCsxikaMeJ4UjxS5
        +c+qtQLqvBAcBcHw5i8cRY5lapaGSNc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 519EF13AED;
        Fri, 29 Oct 2021 04:48:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lWh1EC19e2GVQQAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 29 Oct 2021 04:48:45 +0000
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20211028105952.10011-1-jgross@suse.com>
 <YXsFO2TMRiJTQM2q@mail-itl>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Message-ID: <27e7619a-a797-5c46-9f9f-015ab488e31c@suse.com>
Date:   Fri, 29 Oct 2021 06:48:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YXsFO2TMRiJTQM2q@mail-itl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Au2NSnndHpyE9qEPooGU6Mr1TIE7Tl55C"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Au2NSnndHpyE9qEPooGU6Mr1TIE7Tl55C
Content-Type: multipart/mixed; boundary="8uodpGNBI7OueoVqXOiFPXcY7Col1GLWS";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
Message-ID: <27e7619a-a797-5c46-9f9f-015ab488e31c@suse.com>
Subject: Re: [PATCH] xen/balloon: add late_initcall_sync() for initial
 ballooning done
References: <20211028105952.10011-1-jgross@suse.com>
 <YXsFO2TMRiJTQM2q@mail-itl>
In-Reply-To: <YXsFO2TMRiJTQM2q@mail-itl>

--8uodpGNBI7OueoVqXOiFPXcY7Col1GLWS
Content-Type: multipart/mixed;
 boundary="------------4ACA8F1512DDA652B719B57A"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------4ACA8F1512DDA652B719B57A
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 28.10.21 22:16, Marek Marczykowski-G=C3=B3recki wrote:
> On Thu, Oct 28, 2021 at 12:59:52PM +0200, Juergen Gross wrote:
>> When running as PVH or HVM guest with actual memory < max memory the
>> hypervisor is using "populate on demand" in order to allow the guest
>> to balloon down from its maximum memory size. For this to work
>> correctly the guest must not touch more memory pages than its target
>> memory size as otherwise the PoD cache will be exhausted and the guest=

>> is crashed as a result of that.
>>
>> In extreme cases ballooning down might not be finished today before
>> the init process is started, which can consume lots of memory.
>>
>> In order to avoid random boot crashes in such cases, add a late init
>> call to wait for ballooning down having finished for PVH/HVM guests.
>>
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethings=
lab.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>=20
> It may happen that initial balloon down fails (state=3D=3DBP_ECANCELED)=
=2E In
> that case, it waits indefinitely. I think it should rather report a
> failure (and panic? it's similar to OOM before PID 1 starts, so rather
> hard to recover), instead of hanging.

Okay, I can add something like that. I'm thinking of issuing a failure
message in case of credit not having changed for 1 minute and panic()
after two more minutes. Is this fine?


Juergen

--------------4ACA8F1512DDA652B719B57A
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

--------------4ACA8F1512DDA652B719B57A--

--8uodpGNBI7OueoVqXOiFPXcY7Col1GLWS--

--Au2NSnndHpyE9qEPooGU6Mr1TIE7Tl55C
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmF7fSwFAwAAAAAACgkQsN6d1ii/Ey/M
ZQf9G3a7RxLRSsreeOp23xshh0hqFaa/1485PcGwIiqomUJzKTdYO0sPlt8iMUSgRkzN25Ty48+2
MZ+cDshVeh0hfrm7ilWevH6osOln9b2GUPByu0v7VsZlPHCkgUbGJArp1zEu948pdUPn9kfAxhYP
iq3IgncDd8U/KnIBu0WbAIbr1a0bkcjk44LNDmLwNp1jxfKAvPuSPcpBmCc7oR2cegAicocvxJ8D
taSA6v6jPfvbsei8uXTtuPX2+R613AagOGU0hSm+5M8IyTFIaEEjAq72K1zKT22Uwhvfoqd9VSBR
QmoDem9JBNZ1Fj7QPdZa8V3stf3DBNkErQSNwc38WQ==
=utb5
-----END PGP SIGNATURE-----

--Au2NSnndHpyE9qEPooGU6Mr1TIE7Tl55C--
