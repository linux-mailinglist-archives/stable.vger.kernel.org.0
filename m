Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF1437B7AA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhELIRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:17:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:47662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhELIRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 04:17:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620807374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HUnpVbCTH5F/KaAkcNn6xVOQ+wt0J3foWrNjYt7Xy1M=;
        b=ko8BTsU8R5AwA61qHaGbyvzizA43/2TtbuzmyRvINFFrF2qpY0VhNPBDrNFe4b/xcc1YP3
        5QS3x5de9lwJjLcE6xxfi6lYW/S3SVxuGlktB40/kvOXvkAhxsWT18Chw9LU42k4Go1czg
        xGlrt4OUjue+X3ZR8cnemyPBVnvSp6c=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6EE87AED6;
        Wed, 12 May 2021 08:16:14 +0000 (UTC)
Subject: Re: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
To:     David Laight <David.Laight@ACULAB.COM>,
        'Joerg Roedel' <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Hyunwook Baek <baekhw@google.com>
Cc:     Joerg Roedel <jroedel@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
 <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <fcb2c501-70ca-1a54-4a75-8ab05c21ee30@suse.com>
Date:   Wed, 12 May 2021 10:16:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XAwr03qss2a103tN7AL7D4OXOkbO2QD54"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XAwr03qss2a103tN7AL7D4OXOkbO2QD54
Content-Type: multipart/mixed; boundary="XvCYu7ZLldBYN7eNFsrtwbZr0ILzAAdo3";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: David Laight <David.Laight@ACULAB.COM>, 'Joerg Roedel' <joro@8bytes.org>,
 "x86@kernel.org" <x86@kernel.org>, Hyunwook Baek <baekhw@google.com>
Cc: Joerg Roedel <jroedel@suse.de>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jslaby@suse.cz>,
 Dan Williams <dan.j.williams@intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>,
 David Rientjes <rientjes@google.com>, Cfir Cohen <cfir@google.com>,
 Erdem Aktas <erdemaktas@google.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mike Stunes <mstunes@vmware.com>, Sean Christopherson <seanjc@google.com>,
 Martin Radev <martin.b.radev@gmail.com>,
 Arvind Sankar <nivedita@alum.mit.edu>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>
Message-ID: <fcb2c501-70ca-1a54-4a75-8ab05c21ee30@suse.com>
Subject: Re: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
 <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
In-Reply-To: <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>

--XvCYu7ZLldBYN7eNFsrtwbZr0ILzAAdo3
Content-Type: multipart/mixed;
 boundary="------------D9FF4C828E20416E9A72DEE6"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------D9FF4C828E20416E9A72DEE6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12.05.21 10:04, David Laight wrote:
> From: Joerg
>> Sent: 12 May 2021 08:55
>>
>> From: Joerg Roedel <jroedel@suse.de>
>>
>> The put_user() and get_user() functions do checks on the address which=
 is
>> passed to them. They check whether the address is actually a user-spac=
e
>> address and whether its fine to access it. They also call might_fault(=
)
>> to indicate that they could fault and possibly sleep.
>>
>> All of these checks are neither wanted nor required in the #VC excepti=
on
>> handler, which can be invoked from almost any context and also for MMI=
O
>> instructions from kernel space on kernel memory. All the #VC handler
>> wants to know is whether a fault happened when the access was tried.
>>
>> This is provided by __put_user()/__get_user(), which just do the acces=
s
>> no matter what.
>=20
> That can't be right at all.
> __put/get_user() are only valid on user addresses and will try to
> fault in a missing page - so can sleep.
>=20
> At best this is abused the calls.

You want something like xen_safe_[read|write]_ulong().


Juergen

--------------D9FF4C828E20416E9A72DEE6
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

--------------D9FF4C828E20416E9A72DEE6--

--XvCYu7ZLldBYN7eNFsrtwbZr0ILzAAdo3--

--XAwr03qss2a103tN7AL7D4OXOkbO2QD54
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmCbjswFAwAAAAAACgkQsN6d1ii/Ey/+
tQf/Xw/5BQ/WCvzCYqlHFxcqFgqgCYIzwwVO14DHHCtcqaspLA8x7JC2i/HFe6G0aHu9umdXtLf2
wLUWX1i7DQRoI66pE1SZi4V8kpgmKd4/LjB1Dtsmo//hs3wL310hratO/vMbp/dYfF92jzBnRUhH
RrcPo/Mk9hiB8qn+5b0Z7/NfBqY2uwrv5bxDzopJmC4Wq3/CETP5cFqOGMhdawfp1CjzoJN9aLZO
BsrEm7yitvFLUN571j25VdjFilLJdCAtqcoQT2r/tSiZltGc6k+JpbHvqtCo2RuFLhboMvO3A9RZ
Q7H1jRUk1KWe2tnEAFECz+0NjZj17fgRLd/oaIz8jQ==
=vWa2
-----END PGP SIGNATURE-----

--XAwr03qss2a103tN7AL7D4OXOkbO2QD54--
