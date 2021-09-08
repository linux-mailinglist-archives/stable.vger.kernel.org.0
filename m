Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4478A403AC0
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 15:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbhIHNdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 09:33:54 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48266 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241128AbhIHNdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 09:33:53 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 12AAD1FD84;
        Wed,  8 Sep 2021 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631107964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F/Ui6vmGrOMpzxKSJA2nBowgoVyDEDRCsNzbizaCewY=;
        b=sBa2NeLXe//BoVtuNhFB+2kAt6omI0Pss7VxJGa9WMI20GVCH1+KOeu4fa5yiByRaHNHZJ
        AMBZH99scIdEm9bpFqMT4ZWL6Ky4sx8plPcK7VPL75q0iT56DEaJ+wD1LM4keC0SkCnZsq
        GH8bu5+yOScwZDK5/5xiQTx6yxzvZOY=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id AE3B313A8F;
        Wed,  8 Sep 2021 13:32:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id s+biKHu7OGF3JgAAGKfGzw
        (envelope-from <jgross@suse.com>); Wed, 08 Sep 2021 13:32:43 +0000
Subject: Re: [PATCH] xen: fix usage of pmd/pud_poplulate in mremap for pv
 guests
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Sander Eikelenboom <linux@eikelenboom.it>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20210908073640.11299-1-jgross@suse.com>
 <5a4859db-d173-88dd-5ea9-dd5fd893d934@suse.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <34afed98-5072-c563-5d29-97e09a0b4ebd@suse.com>
Date:   Wed, 8 Sep 2021 15:32:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5a4859db-d173-88dd-5ea9-dd5fd893d934@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mhQytEXpU9tCTCQw6oBk6yPm459sptWLZ"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mhQytEXpU9tCTCQw6oBk6yPm459sptWLZ
Content-Type: multipart/mixed; boundary="oMRl6C4CSjiTQpTvwN6zP8AdTyooWJhjq";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 stable@vger.kernel.org, Sander Eikelenboom <linux@eikelenboom.it>,
 xen-devel@lists.xenproject.org, x86@kernel.org, linux-kernel@vger.kernel.org
Message-ID: <34afed98-5072-c563-5d29-97e09a0b4ebd@suse.com>
Subject: Re: [PATCH] xen: fix usage of pmd/pud_poplulate in mremap for pv
 guests
References: <20210908073640.11299-1-jgross@suse.com>
 <5a4859db-d173-88dd-5ea9-dd5fd893d934@suse.com>
In-Reply-To: <5a4859db-d173-88dd-5ea9-dd5fd893d934@suse.com>

--oMRl6C4CSjiTQpTvwN6zP8AdTyooWJhjq
Content-Type: multipart/mixed;
 boundary="------------9FF5BF531CFAD049E5474674"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------9FF5BF531CFAD049E5474674
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 08.09.21 13:07, Jan Beulich wrote:
> On 08.09.2021 09:36, Juergen Gross wrote:
>> Commit 0881ace292b662 ("mm/mremap: use pmd/pud_poplulate to update pag=
e
>> table entries") introduced a regression when running as Xen PV guest.
>=20
> The description of that change starts with "pmd/pud_populate is the
> right interface to be used to set the respective page table entries."
> If this is deemed true, I don't think pmd_populate() should call
> paravirt_alloc_pte(): The latter function, as its name says, is
> supposed to be called for newly allocated page tables only (aiui).

In theory you are correct, but my experience with reality tells me that
another set of macros for this case will not be appreciated.

>=20
>> Today pmd/pud_poplulate() for Xen PV assumes that the PFN inserted is
>> referencing a not yet used page table. In case of move_normal_pmd/pud(=
)
>> this is not true, resulting in WARN splats like:
>=20
> I agree for the PMD part, but is including PUD here really correct?
> While I don't know why that is, xen_alloc_ptpage() pins L1 tables
> only. Hence a PUD update shouldn't be able to find a pinned L2
> table.

I agree that I should drop mentioning PUD here.

I will do that change when committing in case no other changes are
required.


Juergen

--------------9FF5BF531CFAD049E5474674
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

--------------9FF5BF531CFAD049E5474674--

--oMRl6C4CSjiTQpTvwN6zP8AdTyooWJhjq--

--mhQytEXpU9tCTCQw6oBk6yPm459sptWLZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmE4u3sFAwAAAAAACgkQsN6d1ii/Ey80
Hgf/f8asQXvDRoEpJZ+a4PWY1tqLCbOIKQQg0umYtg4m+BhRu9vTv/3cRga8vRQaW4Sr2eCccOuS
yfiX/2GfX0QRtl25kB4javG4Sl0Vt044CtkXW1Cq+OtrLngf+F3VpByoONFaMEk17IDsaAL11jak
26TGrdjCD5PT3BmXObcYv5wSvr4dv0DTN5FP8x2Mol2OQJEsD8COUZwj7SfnDADDNUsv4l4q0K/o
M9sDGm7dk42bZwpexON7r9ZUaO9xgCjeUVhXVMDu1sjb8nLCgB969PdUiwFHKW0inXpWGYpV4Gg1
cdLZGYndrihUI69KGSI61JDdPsp3YOoBCt4s9deFSw==
=BJw2
-----END PGP SIGNATURE-----

--mhQytEXpU9tCTCQw6oBk6yPm459sptWLZ--
