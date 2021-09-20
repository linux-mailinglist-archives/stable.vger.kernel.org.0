Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62C1410F69
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 08:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhITGCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 02:02:01 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41466 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbhITGCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 02:02:00 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 423E521FB3;
        Mon, 20 Sep 2021 06:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632117633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3KHY06EXntfrdLlsuPDnqc1uITHCd4Mhgz/rKiG/gk0=;
        b=S/dulnBN7pNaqsRC2YJ2DUYsdHpUrY1P0girCmAlwNwzfeTw2bMF8zYtNjzvnKhbr774LI
        C64n54Oq/K9wCdOIUXyVK0y/vXVhgC7Nq62EK84jsPmGn4kVudrFbNIk0w9lTMfZ8e/M2n
        of8Gdc1ax8Ef2wz4egvqOpGp25NjLXc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D72A113A4A;
        Mon, 20 Sep 2021 06:00:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JxZJL4AjSGHEVwAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 20 Sep 2021 06:00:32 +0000
To:     Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        marmarek@invisiblethingslab.com, Borislav Petkov <bp@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org,
        x86@kernel.org
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
 <YUdwMm9ncgNuuN4f@zn.tnic>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Message-ID: <d315decb-2c95-da81-e8e9-9e4a44252656@suse.com>
Date:   Mon, 20 Sep 2021 08:00:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YUdwMm9ncgNuuN4f@zn.tnic>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GyoDqZwN0UAqzbDRNDNZf5dVDfugQfkrT"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GyoDqZwN0UAqzbDRNDNZf5dVDfugQfkrT
Content-Type: multipart/mixed; boundary="o5oiGGEu8tO0xMxCbvHl7MsjjwRlioZxT";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
 marmarek@invisiblethingslab.com, Borislav Petkov <bp@suse.de>,
 Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org, x86@kernel.org
Message-ID: <d315decb-2c95-da81-e8e9-9e4a44252656@suse.com>
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
 <YUdwMm9ncgNuuN4f@zn.tnic>
In-Reply-To: <YUdwMm9ncgNuuN4f@zn.tnic>

--o5oiGGEu8tO0xMxCbvHl7MsjjwRlioZxT
Content-Type: multipart/mixed;
 boundary="------------AC36D1FFB597602A0A81AA2B"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------AC36D1FFB597602A0A81AA2B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 19.09.21 19:15, Borislav Petkov wrote:
> On Sun, Sep 19, 2021 at 06:55:16PM +0200, Mike Galbraith wrote:
>> On Thu, 2021-09-16 at 10:50 +0000, tip-bot2 for Juergen Gross wrote:
>>> The following commit has been merged into the x86/urgent branch of
>>> tip:
>>>
>>> Commit-ID:=C2=A0=C2=A0=C2=A0=C2=A0 1c1046581f1a3809e075669a3df0191869=
d96dd1
>>> Gitweb:
>>> https://git.kernel.org/tip/1c1046581f1a3809e075669a3df0191869d96dd1
>>> Author:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Juergen Gross <jgro=
ss@suse.com>
>>> AuthorDate:=C2=A0=C2=A0=C2=A0 Tue, 14 Sep 2021 11:41:08 +02:00
>>> Committer:=C2=A0=C2=A0=C2=A0=C2=A0 Borislav Petkov <bp@suse.de>
>>> CommitterDate: Thu, 16 Sep 2021 12:38:05 +02:00
>>>
>>> x86/setup: Call early_reserve_memory() earlier
>>
>> This commit rendered tip toxic to my i4790 desktop box and i5-6200U
>> lappy.  Boot for both is instantly over without so much as a twitch.
>>
>> Post bisect revert made both all better.
>=20
> I had a suspicion that moving stuff around like that would not just
> simply work in all cases, as our boot order is very lovely and fragile.=

>=20
> And it booted just fine on my machines here.
>=20
> ;-\
>=20
> Anyway, commit zapped from the x86/urgent lineup. We'll have to have a
> third try later.
>=20

How will that try look like? I'm seeing the following alternatives:

1. Just revert a799c2bd29d19c565 ("x86/setup: Consolidate early memory
    reservations").

2. Try to move the call of early_reserve_memory() just before the call
    of e820__memory_setup().

3. Split early_reserve_memory() into two parts, with the first part
    doing the memblock_reserve() calls for the kernel text, initrd and
    page 0 right at the start of setup_arch(), and the second part for
    the rest at the same place it is handled now.

4. Analyze why Mike's systems fail to boot and try to fix his issue(s)
    (probably via one of the above ways).

Looking at the calls done in early_reserve_memory() I have my doubts
that memblock_x86_reserve_range_setup_data() will work before
early_ioremap_init() has been called, as it is using early_memremap().
This would suggest variant 2 could be a working solution.

In case I'm wrong with my doubts I'd prefer variant 3.


Juergen

--------------AC36D1FFB597602A0A81AA2B
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

--------------AC36D1FFB597602A0A81AA2B--

--o5oiGGEu8tO0xMxCbvHl7MsjjwRlioZxT--

--GyoDqZwN0UAqzbDRNDNZf5dVDfugQfkrT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmFII38FAwAAAAAACgkQsN6d1ii/Ey/C
zgf/btJsiu2WmMH6Y9N+0R7LIgYer+Cd5vVVELfvfMpnws5171wdpu+OVq6q5C1URoLYCFrqTBud
wixCX5oxXGwVhNLdpUcNf8ETIg2VTUprF4MXJ08jsI1DnJwz20DuqyDUCPRg248aPTJ08tfGZZsz
dLiVP1DCQN3M+rWJEHeBVfPYCdKziasFHGMVepiCfQFxvwcJQWl7POTiSj8MXYQHPIwIyjo2SeN7
8flmWQEKY7t7ZW0vYT7TdUVOJH551qaffG2mbQtHuiwPjn5uIwpfFsCDQAbU57KFIG4Nsj9YrYTA
ys2jAHqwZnuXtlIecwlPeYuuLj81bR65silPAg95/A==
=BlQu
-----END PGP SIGNATURE-----

--GyoDqZwN0UAqzbDRNDNZf5dVDfugQfkrT--
