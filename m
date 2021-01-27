Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4424305DBA
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 15:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhA0OBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 09:01:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:45056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232252AbhA0N76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 08:59:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611755949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ymCzo9mLRnx+klz2aLLGCvQekDkAL6VeU6kIAyQl5B8=;
        b=hHWmOpM0k8WAi/Bsk/2vC6moDWg6Ds5mr8r2/8rbfgCwVjBHQr/c0BJaUh1LhaeXdMjvJC
        m/+J0bvFJ8MvMbIoEoAXx8PYHICntzhz0gH+b6zNdvdaMrEAHP5Ch0HorWDH0Mqw2/5h3v
        mrGRqj+tGqUE4+fPvsdVxRym4pH78cI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 78AFBABDA;
        Wed, 27 Jan 2021 13:59:09 +0000 (UTC)
Subject: Re: [PATCH v2] x86/xen: avoid warning in Xen pv guest with
 CONFIG_AMD_MEM_ENCRYPT enabled
To:     Andrew Cooper <andrew.cooper3@citrix.com>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20210127093822.18570-1-jgross@suse.com>
 <fb2305a4-4741-c641-9639-5b17b63f2baf@citrix.com>
 <2dc49fae-bf35-7c7d-2d86-338665db27ca@suse.com>
 <6ca7dcf3-2588-3797-b90c-5eaca542a65d@citrix.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <27d2b0bb-3232-a99b-a577-e61014dd04bc@suse.com>
Date:   Wed, 27 Jan 2021 14:59:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <6ca7dcf3-2588-3797-b90c-5eaca542a65d@citrix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JvC1SoRQx9avNbPw1HwzDh8UEKM1mAMMI"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JvC1SoRQx9avNbPw1HwzDh8UEKM1mAMMI
Content-Type: multipart/mixed; boundary="p2AthCCs6u07wHRfE3QQqaMU5Ty8e0g49";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>,
 xen-devel@lists.xenproject.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
Message-ID: <27d2b0bb-3232-a99b-a577-e61014dd04bc@suse.com>
Subject: Re: [PATCH v2] x86/xen: avoid warning in Xen pv guest with
 CONFIG_AMD_MEM_ENCRYPT enabled
References: <20210127093822.18570-1-jgross@suse.com>
 <fb2305a4-4741-c641-9639-5b17b63f2baf@citrix.com>
 <2dc49fae-bf35-7c7d-2d86-338665db27ca@suse.com>
 <6ca7dcf3-2588-3797-b90c-5eaca542a65d@citrix.com>
In-Reply-To: <6ca7dcf3-2588-3797-b90c-5eaca542a65d@citrix.com>

--p2AthCCs6u07wHRfE3QQqaMU5Ty8e0g49
Content-Type: multipart/mixed;
 boundary="------------047F63F05DF2D09D19CC2609"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------047F63F05DF2D09D19CC2609
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 27.01.21 12:23, Andrew Cooper wrote:
> On 27/01/2021 10:26, J=C3=BCrgen Gro=C3=9F wrote:
>> On 27.01.21 10:43, Andrew Cooper wrote:
>>> On 27/01/2021 09:38, Juergen Gross wrote:
>>>> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv=
=2Ec
>>>> index 4409306364dc..ca5ac10fcbf7 100644
>>>> --- a/arch/x86/xen/enlighten_pv.c
>>>> +++ b/arch/x86/xen/enlighten_pv.c
>>>> @@ -583,6 +583,12 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exc_debug(re=
gs);
>>>>  =C2=A0 }
>>>>  =C2=A0 +DEFINE_IDTENTRY_RAW(exc_xen_unknown_trap)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 /* This should never happen and there is no way =
to handle it. */
>>>> +=C2=A0=C2=A0=C2=A0 panic("Unknown trap in Xen PV mode.");
>>>
>>> Looks much better.=C2=A0 How about including regs->entry_vector here,=
 just to
>>> short circuit the inevitable swearing which will accompany encounteri=
ng
>>> this panic() ?
>>
>> You are aware the regs parameter is struct pt_regs *, not the Xen
>> struct cpu_user_regs *?
>=20
> Yes, but I was assuming that they both contained the same information.
>=20
>>
>> So I have no idea how I should get this information without creating
>> a per-vector handler.
>=20
> Oh - that's dull.
>=20
> Fine then.=C2=A0 Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>=

>=20

I think I'll switch the panic() to printk(); BUG(); in order to have
more diagnostic data. Can I keep your R-b: with that modification?


Juergen

--------------047F63F05DF2D09D19CC2609
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

--------------047F63F05DF2D09D19CC2609--

--p2AthCCs6u07wHRfE3QQqaMU5Ty8e0g49--

--JvC1SoRQx9avNbPw1HwzDh8UEKM1mAMMI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmARcawFAwAAAAAACgkQsN6d1ii/Ey/S
+Qf/SDnP8YDLZOhMmc4iROihLCxWJ55OA9hJWAm0sH3GXU/Z2LG0yvfpO0+54XPic2HxvbInCiOs
Qxf/QTXTUtp8wuzcoP6DnODQ1bQnmON7IUxGaprzsvSdBEsVzhJKeuckliPwupFNqe0jwdi+Cx2r
hKHL+iFV56P5ePyNbLn46/x1avlumXLTKCM54xdbL4kU7u7Eg9MKU+lSh6JTEIMEsSvPmQoMwk1w
bxiUVBnH1C6xOJFYK0cfiZMMfweG/AyvMo9leXfSYqUPIBj7U7oGy/81I7iNk6qd0kq51I3I0D9s
Ip8s3jU1HFNUHLA3PrYCYJc7YJA+1pfWAid3aX1ldw==
=u/6S
-----END PGP SIGNATURE-----

--JvC1SoRQx9avNbPw1HwzDh8UEKM1mAMMI--
