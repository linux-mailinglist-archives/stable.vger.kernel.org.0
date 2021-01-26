Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302C1304BD7
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbhAZVy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:54:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:54304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729460AbhAZFNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 00:13:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611637963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=49marjx9OVpCtWChzV71/n5GQNf3sqfNJ/GzhbLMboc=;
        b=XPbTaM10hujlC8lk1zwTwMr3KRTuMHfQyrJReGUJhJovmO4+UIGFxAGtlEvQmjgOSLxhJS
        7MUClVIjhk7oXphZGOv+d5IDLGOKbLbaW0jZ3WVXsJQ4/MN5vFInfQYPYqaXcl8wtRnXIo
        rKC52UY+uuYOi40cgQiqNklMEz+d2KE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 18429ABDA;
        Tue, 26 Jan 2021 05:12:43 +0000 (UTC)
Subject: Re: [PATCH] x86/xen: avoid warning in Xen pv guest with
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
References: <20210125140013.10198-1-jgross@suse.com>
 <e49727ce-80b6-9eb6-8bd7-a4ce63c693e0@citrix.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <aebac64f-a807-f3c6-1738-f14a4470efe3@suse.com>
Date:   Tue, 26 Jan 2021 06:12:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <e49727ce-80b6-9eb6-8bd7-a4ce63c693e0@citrix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XHVzGyfRUC0eXveO8Q9uFYbueNBdFtLAT"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XHVzGyfRUC0eXveO8Q9uFYbueNBdFtLAT
Content-Type: multipart/mixed; boundary="p6iUJ0v9Xpb5hIrz3itGqDsjdkeo2TL1K";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>,
 xen-devel@lists.xenproject.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
Message-ID: <aebac64f-a807-f3c6-1738-f14a4470efe3@suse.com>
Subject: Re: [PATCH] x86/xen: avoid warning in Xen pv guest with
 CONFIG_AMD_MEM_ENCRYPT enabled
References: <20210125140013.10198-1-jgross@suse.com>
 <e49727ce-80b6-9eb6-8bd7-a4ce63c693e0@citrix.com>
In-Reply-To: <e49727ce-80b6-9eb6-8bd7-a4ce63c693e0@citrix.com>

--p6iUJ0v9Xpb5hIrz3itGqDsjdkeo2TL1K
Content-Type: multipart/mixed;
 boundary="------------1803E39325F8E2E2391D0043"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------1803E39325F8E2E2391D0043
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 25.01.21 18:26, Andrew Cooper wrote:
> On 25/01/2021 14:00, Juergen Gross wrote:
>> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c=

>> index 4409306364dc..82948251f57b 100644
>> --- a/arch/x86/xen/enlighten_pv.c
>> +++ b/arch/x86/xen/enlighten_pv.c
>> @@ -583,6 +583,14 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
>>   		exc_debug(regs);
>>   }
>>  =20
>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>> +DEFINE_IDTENTRY_RAW(xenpv_exc_vmm_communication)
>> +{
>> +	/* This should never happen and there is no way to handle it. */
>> +	panic("X86_TRAP_VC in Xen PV mode.");
>=20
> Honestly, exactly the same is true of #VE, #HV and #SX.
>=20
> What we do in the hypervisor is wire up one handler for all unknown
> exceptions (to avoid potential future #DF issues) leading to a panic.
> Wouldn't it be better to do this unconditionally, especially as #GP/#NP=

> doesn't work for PV guests for unregistered callbacks, rather than
> fixing up piecewise like this?

I agree it would be better to have a "catch all unknown" handler.

I'll have a try how this would look like.


Juergen


--------------1803E39325F8E2E2391D0043
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

--------------1803E39325F8E2E2391D0043--

--p6iUJ0v9Xpb5hIrz3itGqDsjdkeo2TL1K--

--XHVzGyfRUC0eXveO8Q9uFYbueNBdFtLAT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmAPpMoFAwAAAAAACgkQsN6d1ii/Ey/n
IQf+KGDwniWU5Jgabvgu45feMNXYGsMKyS6GCjE9Vj+JBtWUrpbwj5OTMea7rJQ3qU4ZoiPUVZ3F
ZLkIrHL/4MGdCkgti42F6e+fzCkJGEqy35fG7XiBwrV9OQ98lSi36PEYEQiICHeKD7/jvPTMQDz/
kKD0arpB/ldL5cTuKZE+2rL9ZO6JAlJGAz5fhfPtDAe1eOi0zoPLfM5NCCqNuBKY/mWth+r9oQDM
UUsvcf8bjJjYC3BqPUGDGXJJh/ey0/fzl5z+jJBcWFA84IBi3J5l9UMFFeglqq5hE0FBHnbGcPYi
a1YiFiCWX5Rq7d/HIWs3fAu+k2iXfUrbFSa3ec1G/Q==
=yDae
-----END PGP SIGNATURE-----

--XHVzGyfRUC0eXveO8Q9uFYbueNBdFtLAT--
