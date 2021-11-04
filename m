Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618D544572F
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 17:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhKDQYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 12:24:33 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37214 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhKDQYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 12:24:33 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 084071FD3F;
        Thu,  4 Nov 2021 16:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636042914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RyW5Wt/bfDet9n989u3PUHzkl4L+NrHrgmkaQ6ot2hU=;
        b=L92SKm06c/K/noNaQ0Z0+pat7K6xDrEy2Wn9WB8070x+MZT2MLOxJpTacYZxt8NfGexzWd
        mr+KdTjauTiBwOu6ApzjX9WyAtBPGFzBQBz+5/M3GAmli8x9F98uY/+4AEdeNQMQuvETvz
        YdWmVfKh3SSIYoL1FmIeHNaJ0fnoQ84=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C88EF13DA2;
        Thu,  4 Nov 2021 16:21:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5+7UL6EIhGEJDAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 04 Nov 2021 16:21:53 +0000
Subject: Re: [PATCH v4] xen/balloon: add late_initcall_sync() for initial
 ballooning done
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20211102091944.17487-1-jgross@suse.com>
 <f986a7c4-3032-fecd-2e19-4d63a2ee10c7@oracle.com>
 <f8e52acc-2566-1ed0-d2a3-21e2d468fab7@oracle.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <3b1f1771-0a96-1f71-9c9d-9fb1a53a266e@suse.com>
Date:   Thu, 4 Nov 2021 17:21:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <f8e52acc-2566-1ed0-d2a3-21e2d468fab7@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JzKPLG1VYmIxPCVCcWc1VenFHq5kAdOeC"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JzKPLG1VYmIxPCVCcWc1VenFHq5kAdOeC
Content-Type: multipart/mixed; boundary="2vIdrc1xpWVHwJMCuVJCcJZ1hc8yPTd8m";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= <marmarek@invisiblethingslab.com>
Message-ID: <3b1f1771-0a96-1f71-9c9d-9fb1a53a266e@suse.com>
Subject: Re: [PATCH v4] xen/balloon: add late_initcall_sync() for initial
 ballooning done
References: <20211102091944.17487-1-jgross@suse.com>
 <f986a7c4-3032-fecd-2e19-4d63a2ee10c7@oracle.com>
 <f8e52acc-2566-1ed0-d2a3-21e2d468fab7@oracle.com>
In-Reply-To: <f8e52acc-2566-1ed0-d2a3-21e2d468fab7@oracle.com>

--2vIdrc1xpWVHwJMCuVJCcJZ1hc8yPTd8m
Content-Type: multipart/mixed;
 boundary="------------EA8676FA21E0F3DD37BD799B"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------EA8676FA21E0F3DD37BD799B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 04.11.21 16:55, Boris Ostrovsky wrote:
>=20
> On 11/3/21 9:55 PM, Boris Ostrovsky wrote:
>>
>> On 11/2/21 5:19 AM, Juergen Gross wrote:
>>> When running as PVH or HVM guest with actual memory < max memory the
>>> hypervisor is using "populate on demand" in order to allow the guest
>>> to balloon down from its maximum memory size. For this to work
>>> correctly the guest must not touch more memory pages than its target
>>> memory size as otherwise the PoD cache will be exhausted and the gues=
t
>>> is crashed as a result of that.
>>>
>>> In extreme cases ballooning down might not be finished today before
>>> the init process is started, which can consume lots of memory.
>>>
>>> In order to avoid random boot crashes in such cases, add a late init
>>> call to wait for ballooning down having finished for PVH/HVM guests.
>>>
>>> Warn on console if initial ballooning fails, panic() after stalling
>>> for more than 3 minutes per default. Add a module parameter for
>>> changing this timeout.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Reported-by: Marek Marczykowski-G=C3=B3recki=20
>>> <marmarek@invisiblethingslab.com>
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>
>>
>>
>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>=20
>=20
> This appears to have noticeable effect on boot time (and boot experienc=
e=20
> in general).
>=20
>=20
> I have
>=20
>=20
>  =C2=A0 memory=3D1024
>  =C2=A0 maxmem=3D8192
>=20
>=20
> And my boot time (on an admittedly slow box) went from 33 to 45 seconds=
=2E=20
> And boot pauses in the middle while it is waiting for ballooning to=20
> complete.
>=20
>=20
> [=C2=A0=C2=A0=C2=A0 5.062714] xen:balloon: Waiting for initial ballooni=
ng down having=20
> finished.
> [=C2=A0=C2=A0=C2=A0 5.449696] random: crng init done
> [=C2=A0=C2=A0 34.613050] xen:balloon: Initial ballooning down finished.=


This shows that before it was just by chance that the PoD cache wasn't
exhausted.

> So at least I think we should consider bumping log level down from info=
=2E

Which level would you prefer? warn?

And if so, would you mind doing this while committing (I have one day
off tomorrow)?


Juergen

--------------EA8676FA21E0F3DD37BD799B
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

--------------EA8676FA21E0F3DD37BD799B--

--2vIdrc1xpWVHwJMCuVJCcJZ1hc8yPTd8m--

--JzKPLG1VYmIxPCVCcWc1VenFHq5kAdOeC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGECKEFAwAAAAAACgkQsN6d1ii/Ey+P
BggAh6jDDygwPd1B1MxUqCUOGK7SQYdbqJnusvOH0yW8JyzIZXMriK8FS9A2KIaUTGoVZal7LsqD
L241gvpZq4mIP+QJR088u2IOzfYNJ3VoWRqAn4SZFw4EFMu/DIVi5CZem0Lu0fCwn0SqBjdYwhCX
4aHeSlOQi9nigZbA+VJRGPZfg+u4tq60OwyJT62ZyWzn7QveDHCpia0Bg8scrF/ClMF1QRtWG8en
QHvYw9aIfmuCDHP1rojzjiMMvqanZyUOFLNXwmnfxmORJXFB9pfytBWkxhGA6DU0pRtPTsdb1gwQ
a1x3VdrfLEtLQ7MJZOqcYKENNMxby6ovMdA9uWpCEg==
=saKu
-----END PGP SIGNATURE-----

--JzKPLG1VYmIxPCVCcWc1VenFHq5kAdOeC--
