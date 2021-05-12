Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2534137B8BC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhELI7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:59:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:51126 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhELI7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 04:59:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620809902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JEJAAsKoE0eQiF5+PV8maq1zsojULuNLbEi3O1AKMDg=;
        b=ikOA9KwajAvJksUs8B6GDYRFCEDJxCIlsjlTMGl8bRShnvBHR+eXOI9k9tH4K59ZfP9GZ3
        Q/o3Xl6hWissygU2sNZqKTyHTDRBHhw+u4GqunrXtwYT/PQiZw9zf7AX+cotqixcMrnrrj
        NlETytXv3qpkn56hoKPjQZPmJQhPdXc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 37B7FAF83;
        Wed, 12 May 2021 08:58:22 +0000 (UTC)
Subject: Re: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
To:     'Joerg Roedel' <joro@8bytes.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Hyunwook Baek <baekhw@google.com>,
        Joerg Roedel <jroedel@suse.de>,
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
 <fcb2c501-70ca-1a54-4a75-8ab05c21ee30@suse.com> <YJuW4TtRJKZ+OIhj@8bytes.org>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <92244e37-4443-98bd-24aa-bf59548aab47@suse.com>
Date:   Wed, 12 May 2021 10:58:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YJuW4TtRJKZ+OIhj@8bytes.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Mwe7cqnRl5LMoKqZofkx6utlnEwQnFKIy"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Mwe7cqnRl5LMoKqZofkx6utlnEwQnFKIy
Content-Type: multipart/mixed; boundary="vVru1iItKcksFetZ4S5P4j44F1owgvmO4";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: 'Joerg Roedel' <joro@8bytes.org>
Cc: David Laight <David.Laight@aculab.com>, "x86@kernel.org"
 <x86@kernel.org>, Hyunwook Baek <baekhw@google.com>,
 Joerg Roedel <jroedel@suse.de>,
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
Message-ID: <92244e37-4443-98bd-24aa-bf59548aab47@suse.com>
Subject: Re: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
 <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
 <fcb2c501-70ca-1a54-4a75-8ab05c21ee30@suse.com> <YJuW4TtRJKZ+OIhj@8bytes.org>
In-Reply-To: <YJuW4TtRJKZ+OIhj@8bytes.org>

--vVru1iItKcksFetZ4S5P4j44F1owgvmO4
Content-Type: multipart/mixed;
 boundary="------------00DC2C3A42AE2C6F417F0B4A"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------00DC2C3A42AE2C6F417F0B4A
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12.05.21 10:50, 'Joerg Roedel' wrote:
> On Wed, May 12, 2021 at 10:16:12AM +0200, Juergen Gross wrote:
>> You want something like xen_safe_[read|write]_ulong().
>=20
>  From a first glance I can't see it, what is the difference between the=

> xen_safe_*_ulong() functions and __get_user()/__put_user()? The only
> difference I can see is that __get/__put_user() support different acces=
s
> sizes, but neither of those disables page-faults by itself, for example=
=2E
>=20
> Couldn't these xen-specific functions not also be replaces by
> __get_user()/__put_user()?

No, those were used before, but commit 9da3f2b7405440 broke Xen's use
case. That is why I did commit 1457d8cf7664f.


Juergen

--------------00DC2C3A42AE2C6F417F0B4A
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

--------------00DC2C3A42AE2C6F417F0B4A--

--vVru1iItKcksFetZ4S5P4j44F1owgvmO4--

--Mwe7cqnRl5LMoKqZofkx6utlnEwQnFKIy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmCbmKwFAwAAAAAACgkQsN6d1ii/Ey+T
agf/dgkxQzWwx9IxjzEN4UUlZqZclhyavYmiOz3heeucG8Cku/wXibw++S2EfQlqGEd0YoW3WW2k
xGHlodcv1QthdJvVrFOeqEvmd7uHHsrw7/6HKUqyxnpqDaGoU7BAq1dx5QenBL1XmQ0aK0tzJ3Fd
AztrTpez+F5Bfho3+OWeANu3n72Er/1iC6J7v+nZiwI/jjks+FvrhCxUlVz+0SKTQWZZIUUIHRT1
Tu+kGNOd5QCzhqEKAuR1cE7Q2w8/aFqMQ5BrDWUwIA9Z9dSnXX4eKiNim2392WuPdz0KFs1BWuCz
7DB1opX3uuDFpdrABnIz6Wv4naIJwtHA6R/YKXFfiA==
=ifSl
-----END PGP SIGNATURE-----

--Mwe7cqnRl5LMoKqZofkx6utlnEwQnFKIy--
