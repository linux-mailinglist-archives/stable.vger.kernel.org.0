Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BDA41139B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 13:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbhITLeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 07:34:37 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34216 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237165AbhITLef (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 07:34:35 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EE2D62203C;
        Mon, 20 Sep 2021 11:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632137587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MirnV4XaCZRSzPuBlLYw5YJQD01O5bRFc0ZpCNmCdXI=;
        b=lvhIfWCNEM3+PbsVB/qJWG3fDirJOOl1VXEe8v30J2/tOEp5zmOjdETV3wC8twFcUtIxJF
        xEB29JHX4czWDOWbzkgRwFiF++afnPT8to0p1oa+yvwlFAOaU+y2P4lIudixiY2qbTqTHg
        SOb3ZD1YVHVYb+QCF18JyEoZcTvqabc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B09F13483;
        Mon, 20 Sep 2021 11:33:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KKfXI3NxSGGwDQAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 20 Sep 2021 11:33:07 +0000
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
To:     Mike Galbraith <efault@gmx.de>, Mike Rapoport <rppt@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        marmarek@invisiblethingslab.com, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, x86@kernel.org
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
 <YUdtm8hVH0ps18BK@linux.ibm.com>
 <fc21617d65338078366e70704eb55789a810e45e.camel@gmx.de>
 <YUhTwPhva5olB87d@linux.ibm.com>
 <65a61ffdb4c8090320ec98fe5004e6f7808fa4b9.camel@gmx.de>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <6499cba1-1f86-f793-a3a7-815a71296249@suse.com>
Date:   Mon, 20 Sep 2021 13:33:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <65a61ffdb4c8090320ec98fe5004e6f7808fa4b9.camel@gmx.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HGOSxBhvvKD3CTR2nXApYeLmZXYMdCGmJ"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HGOSxBhvvKD3CTR2nXApYeLmZXYMdCGmJ
Content-Type: multipart/mixed; boundary="sR76SZiWH70JVyavjhxL1zjS8lXQ29FZt";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Mike Galbraith <efault@gmx.de>, Mike Rapoport <rppt@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
 marmarek@invisiblethingslab.com, Borislav Petkov <bp@suse.de>,
 stable@vger.kernel.org, x86@kernel.org
Message-ID: <6499cba1-1f86-f793-a3a7-815a71296249@suse.com>
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
 <YUdtm8hVH0ps18BK@linux.ibm.com>
 <fc21617d65338078366e70704eb55789a810e45e.camel@gmx.de>
 <YUhTwPhva5olB87d@linux.ibm.com>
 <65a61ffdb4c8090320ec98fe5004e6f7808fa4b9.camel@gmx.de>
In-Reply-To: <65a61ffdb4c8090320ec98fe5004e6f7808fa4b9.camel@gmx.de>

--sR76SZiWH70JVyavjhxL1zjS8lXQ29FZt
Content-Type: multipart/mixed;
 boundary="------------27CF52266B77C1EE58768F16"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------27CF52266B77C1EE58768F16
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 20.09.21 13:25, Mike Galbraith wrote:
> On Mon, 2021-09-20 at 12:26 +0300, Mike Rapoport wrote:
>>
>> Can't say anything caught my eye, except the early microcode update.
>> Just to rule that out, can you try booting without the early microcode=

>> update?
>=20
> Nogo.
>=20
>> And, to check Juergen's suggestion about failure in
>> memblock_x86_reserve_range_setup_data(), can you try this patch on top=
 of
>> the failing tip:
>=20
> Yup, patchlet detoxified it for both boxen.

Yay!

Will respin my patch moving the call of early_reserve_memory() just
before the call of e820__memory_setup().

Thanks for reporting the issue and verifying my suspicion.


Juergen

--------------27CF52266B77C1EE58768F16
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

--------------27CF52266B77C1EE58768F16--

--sR76SZiWH70JVyavjhxL1zjS8lXQ29FZt--

--HGOSxBhvvKD3CTR2nXApYeLmZXYMdCGmJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmFIcXIFAwAAAAAACgkQsN6d1ii/Ey8Q
EQf+L0ksCIwO2zF9MmuEv2TmEkAN7xW6UI50V3sPaow6v4E0wqOG6fP+dXHr6AiZSMlHXHVhWD+Y
EiVCabtcp+drREf/sBMxpGk+V4W1NyFeWSfyompqOfPjgdCPG6bGPpKNwSzv8Ly+DFUk6tkkp6oj
XeXC5prqUuUVGxxFMm5bRE8oxAjH3RPe1Od3Y6SVtnaVt52gG4A67AtwxBktAwJcz3xS7ht5gZ2Y
Q12/bMg8YlbU3fd+s0AhXJJf+QxLA0wd2hRvKVjZS76eYMbV1dniiZtBvWWWYMoiS72bgI78xeoN
zNDdrG+5AzavL/x9bik4pd++K0J88i4kkdXkMgGfFA==
=xqsn
-----END PGP SIGNATURE-----

--HGOSxBhvvKD3CTR2nXApYeLmZXYMdCGmJ--
