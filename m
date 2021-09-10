Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037FD40679F
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 09:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhIJH3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 03:29:15 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49282 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhIJH3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 03:29:12 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 59FF12229F;
        Fri, 10 Sep 2021 07:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631258880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7tCaeYZC58tBDrJqNk0nn5PtnnlNlX6dAF2RgPaH35k=;
        b=OCx6QAPj+yLpBTeSc+Q6mflKHsCfICjBqBV8asbgkLw/zOU7OQRMnN2v0wT82dQJfwfZ+T
        CT5QKygIuWcBllQbtfsWmQ/uvXyOS5fyLkoiF1NhwO0Y6WTR+qTJ+yct3Yc13vnfWtaKiF
        gqTLgO6zZD3tz5vFt9waWB2xZLILkg0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F318213D1D;
        Fri, 10 Sep 2021 07:27:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PCE8Of8IO2GBMwAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 10 Sep 2021 07:27:59 +0000
Subject: Re: [PATCH 2/2] xen: reset legacy rtc flag for PV domU
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
References: <20210903084937.19392-1-jgross@suse.com>
 <20210903084937.19392-3-jgross@suse.com>
 <b2cd2936-7ec4-e0b2-458e-51c12a3f56aa@oracle.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <8385702d-aeb2-5898-a4ea-00991dd7bca9@suse.com>
Date:   Fri, 10 Sep 2021 09:27:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b2cd2936-7ec4-e0b2-458e-51c12a3f56aa@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="e1YgqMDepsa4po08haHcuF4n97TgpYtNd"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e1YgqMDepsa4po08haHcuF4n97TgpYtNd
Content-Type: multipart/mixed; boundary="YOevWxiq2bQARiqYFjXPhUWKFLWRRLAL4";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 stable@vger.kernel.org
Message-ID: <8385702d-aeb2-5898-a4ea-00991dd7bca9@suse.com>
Subject: Re: [PATCH 2/2] xen: reset legacy rtc flag for PV domU
References: <20210903084937.19392-1-jgross@suse.com>
 <20210903084937.19392-3-jgross@suse.com>
 <b2cd2936-7ec4-e0b2-458e-51c12a3f56aa@oracle.com>
In-Reply-To: <b2cd2936-7ec4-e0b2-458e-51c12a3f56aa@oracle.com>

--YOevWxiq2bQARiqYFjXPhUWKFLWRRLAL4
Content-Type: multipart/mixed;
 boundary="------------87B7477B304C177D84C82456"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------87B7477B304C177D84C82456
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.09.21 16:54, Boris Ostrovsky wrote:
>=20
> On 9/3/21 4:49 AM, Juergen Gross wrote:
>> A Xen PV guest doesn't have a legacy RTC device, so reset the legacy
>> RTC flag. Otherwise the following WARN splat will occur at boot:
>>
>> [    1.333404] WARNING: CPU: 1 PID: 1 at /home/gross/linux/head/driver=
s/rtc/rtc-mc146818-lib.c:25 mc146818_get_time+0x1be/0x210
>> [    1.333404] Modules linked in:
>> [    1.333404] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W      =
   5.14.0-rc7-default+ #282
>> [    1.333404] RIP: e030:mc146818_get_time+0x1be/0x210
>> [    1.333404] Code: c0 64 01 c5 83 fd 45 89 6b 14 7f 06 83 c5 64 89 6=
b 14 41 83 ec 01 b8 02 00 00 00 44 89 63 10 5b 5d 41 5c 41 5d 41 5e 41 5f=
 c3 <0f> 0b 48 c7 c7 30 0e ef 82 4c 89 e6 e8 71 2a 24 00 48 c7 c0 ff ff
>> [    1.333404] RSP: e02b:ffffc90040093df8 EFLAGS: 00010002
>> [    1.333404] RAX: 00000000000000ff RBX: ffffc90040093e34 RCX: 000000=
0000000000
>> [    1.333404] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000000=
000000000d
>> [    1.333404] RBP: ffffffff82ef0e30 R08: ffff888005013e60 R09: 000000=
0000000000
>> [    1.333404] R10: ffffffff82373e9b R11: 0000000000033080 R12: 000000=
0000000200
>> [    1.333404] R13: 0000000000000000 R14: 0000000000000002 R15: ffffff=
ff82cdc6d4
>> [    1.333404] FS:  0000000000000000(0000) GS:ffff88807d440000(0000) k=
nlGS:0000000000000000
>> [    1.333404] CS:  10000e030 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [    1.333404] CR2: 0000000000000000 CR3: 000000000260a000 CR4: 000000=
0000050660
>> [    1.333404] Call Trace:
>> [    1.333404]  ? wakeup_sources_sysfs_init+0x30/0x30
>> [    1.333404]  ? rdinit_setup+0x2b/0x2b
>> [    1.333404]  early_resume_init+0x23/0xa4
>> [    1.333404]  ? cn_proc_init+0x36/0x36
>> [    1.333404]  do_one_initcall+0x3e/0x200
>> [    1.333404]  kernel_init_freeable+0x232/0x28e
>> [    1.333404]  ? rest_init+0xd0/0xd0
>> [    1.333404]  kernel_init+0x16/0x120
>> [    1.333404]  ret_from_fork+0x1f/0x30
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>=20
>=20
> Fixes: 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs") ?

I don't think so. Its rather:

Fixes: 8d152e7a5c7537 ("x86/rtc: Replace paravirt rtc check with=20
platform legacy quirk")

as this was the commit leading to domUs having the rtc capability being
set.

> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Thanks,

Juergen


--------------87B7477B304C177D84C82456
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

--------------87B7477B304C177D84C82456--

--YOevWxiq2bQARiqYFjXPhUWKFLWRRLAL4--

--e1YgqMDepsa4po08haHcuF4n97TgpYtNd
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmE7CP8FAwAAAAAACgkQsN6d1ii/Ey8R
+gf/aas2jxgmhjzaKLPpJMPjSpGxMOUtXZOXgTTYIX6vH+eLWVZAJQ8wJXesZGeJSQtgwT6K4wOD
tUSP0nGwBCinQQSLGt0Wzk3myQk/EvbKQ9u7Ch+V7Vg7uZkbkqZN1yz9bzqN3J/fbB4D4qj+75dF
ugkVQ7srpbdCmlu1hxJLurZ/R1JDfYBZwP53XoqeP4f61zLD0euDm3P7K3TCRmFs6GzlzcruPR+d
K9zw7qV+tSQW95k4qHprEAry1a8PdGAd66cj39V4DbuRotIIuiQCkyNA3oNUgtRz35ckX5jYyGOl
pVxQOC0FgeLpPtt3uQO1r9iF25H7fL5CkYTqqzxHVg==
=oXCQ
-----END PGP SIGNATURE-----

--e1YgqMDepsa4po08haHcuF4n97TgpYtNd--
