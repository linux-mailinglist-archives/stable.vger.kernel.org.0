Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFB044A623
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 06:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhKIF1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 00:27:48 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:56170 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhKIF1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 00:27:48 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 501BA21B00;
        Tue,  9 Nov 2021 05:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636435501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6qZ2ecLipwkjea22RjvngCag5b7N6mh9K6o75bhKVAQ=;
        b=ZmAHsnxetzDVEILFPVQSus1SPBiL8uqgSJNoqvP1LRUTCk1uMo0V0klSofaXkEsl0wYtak
        L2Wo0SxJGqZLigMP7dYkWZ5QfgZ8bGZc40dCQPfkJScIay0mPM6bIDg6nCMVkkVQ9A+Mt0
        54rJBtFU8GvGmIcrzN5OHKV4obJ1E88=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0C2213A9D;
        Tue,  9 Nov 2021 05:25:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5uwbOSwGimHEcAAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 09 Nov 2021 05:25:00 +0000
Subject: Re: [PATCH 1/2] MAINTAINERS: Update maintainers for paravirt ops and
 VMware hypervisor interface
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, x86@kernel.org,
        pv-drivers@vmware.com
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <50de7150-2f5f-302e-6181-a542e5df9deb@suse.com>
Date:   Tue, 9 Nov 2021 06:25:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9dqCZhv4Xu8LCUrKXl5rinN1qWdhqtoPh"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9dqCZhv4Xu8LCUrKXl5rinN1qWdhqtoPh
Content-Type: multipart/mixed; boundary="fxtyyotnuEemsZMYf6iU1sZZXS8Caq110";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, x86@kernel.org,
 pv-drivers@vmware.com
Cc: Alexey Makhalov <amakhalov@vmware.com>, Deep Shah <sdeep@vmware.com>,
 stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
 keerthanak@vmware.com, srivatsab@vmware.com, anishs@vmware.com,
 vithampi@vmware.com, linux-kernel@vger.kernel.org
Message-ID: <50de7150-2f5f-302e-6181-a542e5df9deb@suse.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: Update maintainers for paravirt ops and
 VMware hypervisor interface
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
In-Reply-To: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>

--fxtyyotnuEemsZMYf6iU1sZZXS8Caq110
Content-Type: multipart/mixed;
 boundary="------------0E16175F2C2C8FD9C19D3F29"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------0E16175F2C2C8FD9C19D3F29
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.11.21 21:29, Srivatsa S. Bhat wrote:
> From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
>=20
> Deep has decided to transfer maintainership of the VMware hypervisor
> interface to Srivatsa, and the joint-maintainership of paravirt ops in
> the Linux kernel to Srivatsa and Alexey. Update the MAINTAINERS file
> to reflect this change.
>=20
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> Acked-by: Alexey Makhalov <amakhalov@vmware.com>
> Acked-by: Deep Shah <sdeep@vmware.com>
> Cc: stable@vger.kernel.org

Acked-by: Juergen Gross <jgross@suse.com>


Juergen

--------------0E16175F2C2C8FD9C19D3F29
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

--------------0E16175F2C2C8FD9C19D3F29--

--fxtyyotnuEemsZMYf6iU1sZZXS8Caq110--

--9dqCZhv4Xu8LCUrKXl5rinN1qWdhqtoPh
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGKBiwFAwAAAAAACgkQsN6d1ii/Ey9H
dgf+IB8im0PQ++8RG9WQQ7qwygQQ+9S/EIhbCs3Bwv1b2oYvF13+YuBOYzdwmqgiubww1RR7Ugjg
DIka5n+NWsGQSyG875SY8VK0VsfBJVh5mHV6896Fvbmy9hEjgV2kypvxz6WZiUZTQfkJAGATR10y
KHZMFt0VZCjhwFs5W/kWHfx0tv1Pv/1kXVstBMWTlRUOm17I407QMwvzHI/05aqu0smJpI7FORKi
jDoztJeVrTOtsc61vtisz9ahZvet/VMEswLuHdRLzZcZEU2JjufmvbSp+1rLqMZtjvAsVJLnrVTB
x/Srjc0AI3p0mH3xjjsfB/o+LDuqvlek3f+B59Ru7Q==
=4Jzb
-----END PGP SIGNATURE-----

--9dqCZhv4Xu8LCUrKXl5rinN1qWdhqtoPh--
