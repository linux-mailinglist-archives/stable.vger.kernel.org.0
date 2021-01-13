Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5EB2F4A4C
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 12:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbhAMLdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 06:33:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:47688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbhAMLdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 06:33:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610537557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RoB7qojee6lEruIFDaOraJpH/Owsm0jB//ECJa6okI4=;
        b=M6kKuJfD6E9JWGQ5yJTayskvOlo/gpE2pAo7pc8G4WsOcclVvzdAl3FV1wHT3Hv/W2IUJr
        jazLP1hgphxpL7CxyaRx8JaIJGHEwpZou6K+s08XUTibghtnhYnDXT3HsC4AE78C4rHu6Z
        8rXk7Y/a5JdPqXMJhRbn6/TXtL2iC6A=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4C1ADAF0D;
        Wed, 13 Jan 2021 11:32:37 +0000 (UTC)
Subject: Re: [PATCH v2] xen/privcmd: allow fetching resource sizes
To:     Roger Pau Monne <roger.pau@citrix.com>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul.durrant@citrix.com>, amc96@cam.ac.uk,
        andrew.cooper3@citrix.com, xen-devel@lists.xenproject.org
References: <20210112115358.23346-1-roger.pau@citrix.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <f9c1d458-40c2-5b16-3eb9-8fd0ff48a175@suse.com>
Date:   Wed, 13 Jan 2021 12:32:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210112115358.23346-1-roger.pau@citrix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pihdqaB0pJw4HCmmSyvH2wJqDe3rNPx4f"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pihdqaB0pJw4HCmmSyvH2wJqDe3rNPx4f
Content-Type: multipart/mixed; boundary="Duji9fveTOk6ai2o4nlA5d9jcc5JeZBQa";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Roger Pau Monne <roger.pau@citrix.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Paul Durrant <paul.durrant@citrix.com>, amc96@cam.ac.uk,
 andrew.cooper3@citrix.com, xen-devel@lists.xenproject.org
Message-ID: <f9c1d458-40c2-5b16-3eb9-8fd0ff48a175@suse.com>
Subject: Re: [PATCH v2] xen/privcmd: allow fetching resource sizes
References: <20210112115358.23346-1-roger.pau@citrix.com>
In-Reply-To: <20210112115358.23346-1-roger.pau@citrix.com>

--Duji9fveTOk6ai2o4nlA5d9jcc5JeZBQa
Content-Type: multipart/mixed;
 boundary="------------8F2473964E221FAF140E9818"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------8F2473964E221FAF140E9818
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12.01.21 12:53, Roger Pau Monne wrote:
> Allow issuing an IOCTL_PRIVCMD_MMAP_RESOURCE ioctl with num =3D 0 and
> addr =3D 0 in order to fetch the size of a specific resource.
>=20
> Add a shortcut to the default map resource path, since fetching the
> size requires no address to be passed in, and thus no VMA to setup.
>=20
> This is missing from the initial implementation, and causes issues
> when mapping resources that don't have fixed or known sizes.
>=20
> Signed-off-by: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
> Cc: stable@vger.kernel.org # >=3D 4.18

Pushed to xen/tip.git for-linus-5.11


Juergen

--------------8F2473964E221FAF140E9818
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
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

--------------8F2473964E221FAF140E9818--

--Duji9fveTOk6ai2o4nlA5d9jcc5JeZBQa--

--pihdqaB0pJw4HCmmSyvH2wJqDe3rNPx4f
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAl/+2lMFAwAAAAAACgkQsN6d1ii/Ey+S
bggAmM/+LYxBWzsG+km1sxALr88H4hOd44eTDHEUOfpK7XShyFUjICiYSGuBW0hxkFDPBeo99ljC
EkhblgCAhAQXwAR5UuuazLDZ35rtNHy7OB/zDG1g1L4b4wc8/6kUm5sR4ZdPceIOpnlgJMf6DP2N
aPgOSHc/PQ62XsF0yoC4sHPmTIyg8M3lPv4t8qt+BQYDXojYIZychVpe7GLdjlTwtwm/aHh4pBBD
NYBdu01/NjC7nVYQH7atbJ+VxKErqf1EyE1sNx/kXySMhRX+TRDLylPCo1EMWmlaMq2eov9PyKky
6qmM8PghAEBNfqOENFeZrR8g8QowevvPBm8HemEccQ==
=n40h
-----END PGP SIGNATURE-----

--pihdqaB0pJw4HCmmSyvH2wJqDe3rNPx4f--
