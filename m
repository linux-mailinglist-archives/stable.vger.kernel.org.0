Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F6B3A97BD
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 12:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhFPKkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 06:40:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38546 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbhFPKjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 06:39:43 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2B1DE21A44;
        Wed, 16 Jun 2021 10:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623839856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cUDp+bU8nGCF6IWL4hSqRX+diw04+4z08WiV4lCEuww=;
        b=cdJtvqI6DIqUaTm9tW3iM77vchjUaHIBtvLx66HqJgpSxhx0yu51xv91aqJRrZRd8KIMzY
        MIKviO/VCL57SzP0YfXxwJVe8J2gN/23y8c7UBn3YcJKN5PeeS8bMF40N/gNZzrCETcon2
        TPqnrWPu4r4j9cQ3/nBkely36ZmX+Jw=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id D9072118DD;
        Wed, 16 Jun 2021 10:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623839856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cUDp+bU8nGCF6IWL4hSqRX+diw04+4z08WiV4lCEuww=;
        b=cdJtvqI6DIqUaTm9tW3iM77vchjUaHIBtvLx66HqJgpSxhx0yu51xv91aqJRrZRd8KIMzY
        MIKviO/VCL57SzP0YfXxwJVe8J2gN/23y8c7UBn3YcJKN5PeeS8bMF40N/gNZzrCETcon2
        TPqnrWPu4r4j9cQ3/nBkely36ZmX+Jw=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 1+K+M2/UyWC/UgAALh3uQQ
        (envelope-from <jgross@suse.com>); Wed, 16 Jun 2021 10:37:35 +0000
Subject: Re: [PATCH 1/2] xen: fix setting of max_pfn in shared_info
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
References: <20210616073007.5215-1-jgross@suse.com>
 <20210616073007.5215-2-jgross@suse.com>
 <a3674ab9-40d8-c365-d48c-0e1c88814942@suse.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <97de842a-f095-3a12-ab16-beca0f97ba67@suse.com>
Date:   Wed, 16 Jun 2021 12:37:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <a3674ab9-40d8-c365-d48c-0e1c88814942@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KTsGTPJxuSc8B4hvJibcDyNolPqoBmQJN"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KTsGTPJxuSc8B4hvJibcDyNolPqoBmQJN
Content-Type: multipart/mixed; boundary="ap0P46W17IAWxsPrQZNj1vLtTBF2bl8UM";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 stable@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Message-ID: <97de842a-f095-3a12-ab16-beca0f97ba67@suse.com>
Subject: Re: [PATCH 1/2] xen: fix setting of max_pfn in shared_info
References: <20210616073007.5215-1-jgross@suse.com>
 <20210616073007.5215-2-jgross@suse.com>
 <a3674ab9-40d8-c365-d48c-0e1c88814942@suse.com>
In-Reply-To: <a3674ab9-40d8-c365-d48c-0e1c88814942@suse.com>

--ap0P46W17IAWxsPrQZNj1vLtTBF2bl8UM
Content-Type: multipart/mixed;
 boundary="------------807AE2AA9ED82DDA23942201"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------807AE2AA9ED82DDA23942201
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 16.06.21 11:52, Jan Beulich wrote:
> On 16.06.2021 09:30, Juergen Gross wrote:
>> Xen PV guests are specifying the highest used PFN via the max_pfn
>> field in shared_info. This value is used by the Xen tools when saving
>> or migrating the guest.
>>
>> Unfortunately this field is misnamed, as in reality it is specifying
>> the number of pages (including any memory holes) of the guest, so it
>> is the highest used PFN + 1. Renaming isn't possible, as this is a
>> public Xen hypervisor interface which needs to be kept stable.
>>
>> The kernel will set the value correctly initially at boot time, but
>> when adding more pages (e.g. due to memory hotplug or ballooning) a
>> real PFN number is stored in max_pfn. This is done when expanding the
>> p2m array, and the PFN stored there is even possibly wrong, as it
>> should be the last possible PFN of the just added P2M frame, and not
>> one which led to the P2M expansion.
>>
>> Fix that by setting shared_info->max_pfn to the last possible PFN + 1.=

>>
>> Fixes: 98dd166ea3a3c3 ("x86/xen/p2m: hint at the last populated P2M en=
try")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>=20
> The code change is fine, so
> Reviewed-by: Jan Beulich <jbeulich@suse.com>
>=20
> But I think even before the rename you would want to clarify the commen=
t
> next to the variable's definition, to make clear what it really holds.

It already says: "Number of valid entries in the p2m table(s) ..."
What do you think is unclear about that? Or do you mean another
variable?


Juergen

--------------807AE2AA9ED82DDA23942201
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

--------------807AE2AA9ED82DDA23942201--

--ap0P46W17IAWxsPrQZNj1vLtTBF2bl8UM--

--KTsGTPJxuSc8B4hvJibcDyNolPqoBmQJN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmDJ1G8FAwAAAAAACgkQsN6d1ii/Ey+H
Lwf+Ick3/mutcwbdkHo2Pofr1/gJNNwiHCi8f6Z2VRzm/Gs1+KKQRCyPbGYaZpETytNkWhobwgGf
MD7r0bIaVRXqPGO3poig7sW40S/3o7Aro8DkBCDg6fDspcGuFYsUIw5UtjlEjPEm1wa1b8poGDvO
qXm80V15BdTfhFc2dshqWnfl2qOmbK25OSRWVGd0JfxaqVZO4XiBDCHR4G+akozbAE/liMTOm5pk
itPHw03GTCdvhnlQAA0P4UK9WeD1Kfvq7D9pdYXtPoBq76LJeL6WaLGp3mGlOaqD9ey9E4NTqqVA
rp5MsHZ/zhIe67DTPT+ZCUjYrlrBGnOtfkTLtsv1mw==
=ND52
-----END PGP SIGNATURE-----

--KTsGTPJxuSc8B4hvJibcDyNolPqoBmQJN--
