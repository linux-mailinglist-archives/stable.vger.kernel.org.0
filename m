Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB3C455766
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244821AbhKRI5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:57:11 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:55468 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244914AbhKRI4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 03:56:13 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B01551FD35;
        Thu, 18 Nov 2021 08:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637225591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kb4waLBtBGSXHBRlUIyKFLdUUKY/+94sspf4DGh5uNQ=;
        b=QY+YOrdxtpHrGcCGhkhih+HiCvAEBJoMyKspFVIHYod3K9u1/U2wsVq0W6Q2rFa98WDnaz
        lTdmfLpr7cAOnfSDRrJMdtJCcyjn1tSTHLFyr+rwP/ACrllPWoc9DrlkOoU/1jQ/EoCgDD
        VmVPN/Lb9MT8UV38B+dNLpzZJflncvQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7BBDC13CF6;
        Thu, 18 Nov 2021 08:53:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ItXeHHcUlmEQYQAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 18 Nov 2021 08:53:11 +0000
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
To:     Jan Beulich <jbeulich@suse.com>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>
References: <20211117021145.3105042-1-sstabellini@kernel.org>
 <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com>
 <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop>
 <44403efe-a850-b53b-785f-6f5c73eb2b96@suse.com>
 <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <b0cd6af9-66c4-3a73-734a-3a51d052fac2@suse.com>
Date:   Thu, 18 Nov 2021 09:53:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xzOlgh1CbAovcTzGLiZmCHxZ9bARs5goq"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xzOlgh1CbAovcTzGLiZmCHxZ9bARs5goq
Content-Type: multipart/mixed; boundary="5BnwnPOSA5BhoJPL6QLfBvrjsgylFqXtS";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org,
 Stefano Stabellini <stefano.stabellini@xilinx.com>, stable@vger.kernel.org,
 Stefano Stabellini <sstabellini@kernel.org>
Message-ID: <b0cd6af9-66c4-3a73-734a-3a51d052fac2@suse.com>
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
References: <20211117021145.3105042-1-sstabellini@kernel.org>
 <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com>
 <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop>
 <44403efe-a850-b53b-785f-6f5c73eb2b96@suse.com>
 <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>
In-Reply-To: <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>

--5BnwnPOSA5BhoJPL6QLfBvrjsgylFqXtS
Content-Type: multipart/mixed;
 boundary="------------D1D8945FCC5D2D680FE05F6A"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------D1D8945FCC5D2D680FE05F6A
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 18.11.21 09:47, Jan Beulich wrote:
> On 18.11.2021 06:32, Juergen Gross wrote:
>> On 18.11.21 03:37, Stefano Stabellini wrote:
>>> --- a/drivers/xen/xenbus/xenbus_probe.c
>>> +++ b/drivers/xen/xenbus/xenbus_probe.c
>>> @@ -951,6 +951,28 @@ static int __init xenbus_init(void)
>>>    		err =3D hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
>>>    		if (err)
>>>    			goto out_error;
>>> +		/*
>>> +		 * Return error on an invalid value.
>>> +		 *
>>> +		 * Uninitialized hvm_params are zero and return no error.
>>> +		 * Although it is theoretically possible to have
>>> +		 * HVM_PARAM_STORE_PFN set to zero on purpose, in reality it is
>>> +		 * not zero when valid. If zero, it means that Xenstore hasn't
>>> +		 * been properly initialized. Instead of attempting to map a
>>> +		 * wrong guest physical address return error.
>>> +		 */
>>> +		if (v =3D=3D 0) {
>>
>> Make this "if (v =3D=3D ULONG_MAX || v=3D=3D 0)" instead?
>> This would result in the same err on a new and an old hypervisor
>> (assuming we switch the hypervisor to init params with ~0UL).
>>
>>> +			err =3D -ENOENT;
>>> +			goto out_error;
>>> +		}
>>> +		/*
>>> +		 * ULONG_MAX is invalid on 64-bit because is INVALID_PFN.
>>> +		 * On 32-bit return error to avoid truncation.
>>> +		 */
>>> +		if (v >=3D ULONG_MAX) {
>>> +			err =3D -EINVAL;
>>> +			goto out_error;
>>> +		}
>>
>> Does it make sense to continue the system running in case of
>> truncation? This would be a 32-bit guest with more than 16TB of RAM
>> and the Xen tools decided to place the Xenstore ring page above the
>> 16TB boundary. This is a completely insane scenario IMO.
>>
>> A proper panic() in this case would make diagnosis of that much
>> easier (me having doubts that this will ever be hit, though).
>=20
> While I agree panic() may be an option here (albeit I'm not sure why
> that would be better than trying to cope with 0 and hence without

I could imagine someone wanting to run a guest without Xenstore access,
which BTW will happen in case of a guest created by the hypervisor at
boot time.

> xenbus), I'd like to point out that the amount of RAM assigned to a
> guest is unrelated to the choice of GFNs for the various "magic"
> items.

Yes, but this would still be a major tools problem which probably
would render the whole guest rather unusable.


Juergen

--------------D1D8945FCC5D2D680FE05F6A
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

--------------D1D8945FCC5D2D680FE05F6A--

--5BnwnPOSA5BhoJPL6QLfBvrjsgylFqXtS--

--xzOlgh1CbAovcTzGLiZmCHxZ9bARs5goq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGWFHYFAwAAAAAACgkQsN6d1ii/Ey9d
JAgAnAF6cjuPVg8/8DKqxz85cpVZJInLAjkVHghSLrOBHNBooBXCWWBKqPzBjLo40e1ggpexrB1S
mxAjTUPLej1P5wBPesPwQAf8Mvin9qwWe4fnKk/fVq/dtD0M8hXuJg6p6jNb4j6rsvMMAA50Ba91
vxQ1kfwW/bi1r3hxEEYHvMpZOfUOVvBN2nTsLVavX5uh6T/TZSwii60ByRUDjeh/fHTs3FnQKpnH
Z67XW3lMHevdBpMYmp5raimRlObeZmMbwg9I+FYl5SaSGzCBB0LE/MD5/srpe+U9gbWRXUOox6wE
M2Wpl2KdW8Zf+9iLWtVwdhad7ZfggMqQEqxuh7ueBw==
=McP0
-----END PGP SIGNATURE-----

--xzOlgh1CbAovcTzGLiZmCHxZ9bARs5goq--
