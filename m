Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6977538F9D0
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 07:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhEYFMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 01:12:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:35662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230290AbhEYFMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 01:12:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621919482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vQy9Yy3gw7RKGoFrMrPZDj3krJ5l5n052HEA+hQR2hs=;
        b=a1G9rQhrkw7MVyqaginby6ymmKEuEKd0ouu/js+Fmk+E0aMMkLQSdIVIQN6TIYd/8E5oPg
        xaXF/EUp2y/mgUKcoMGjkjG/U6Ofj9cN7qj9zCecBuN/ul/QI7nJLJH9u/n5Ho+Oc9z3Lm
        k2fueyzU0S+pzEpyg2N4wvbJJrpfUqQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2AF59AE04;
        Tue, 25 May 2021 05:11:22 +0000 (UTC)
Subject: Re: [PATCH 4.19 49/49] x86/Xen: swap NX determination and GDT setup
 on BSP
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Jan Beulich <jbeulich@suse.com>
References: <20210524152324.382084875@linuxfoundation.org>
 <20210524152325.958181984@linuxfoundation.org>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <bdadfa45-0496-9d47-cca0-b0839b811ae9@suse.com>
Date:   Tue, 25 May 2021 07:11:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210524152325.958181984@linuxfoundation.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ATH5QzO71TNqzvpwWdCjpiDfHFPpuWRfK"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ATH5QzO71TNqzvpwWdCjpiDfHFPpuWRfK
Content-Type: multipart/mixed; boundary="uEevRINPBpsFTVLNmx6wseFe669HMgse2";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
 Jan Beulich <jbeulich@suse.com>
Message-ID: <bdadfa45-0496-9d47-cca0-b0839b811ae9@suse.com>
Subject: Re: [PATCH 4.19 49/49] x86/Xen: swap NX determination and GDT setup
 on BSP
References: <20210524152324.382084875@linuxfoundation.org>
 <20210524152325.958181984@linuxfoundation.org>
In-Reply-To: <20210524152325.958181984@linuxfoundation.org>

--uEevRINPBpsFTVLNmx6wseFe669HMgse2
Content-Type: multipart/mixed;
 boundary="------------C8F10F2D5F5C1F8416CDE582"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------C8F10F2D5F5C1F8416CDE582
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 24.05.21 17:26, Greg Kroah-Hartman wrote:
> From: Jan Beulich <jbeulich@suse.com>
>=20
> commit ae897fda4f507e4b239f0bdfd578b3688ca96fb4 upstream.
>=20
> xen_setup_gdt(), via xen_load_gdt_boot(), wants to adjust page tables.
> For this to work when NX is not available, x86_configure_nx() needs to
> be called first.
>=20
> [jgross] Note that this is a revert of 36104cb9012a82e73 ("x86/xen:
> Delay get_cpu_cap until stack canary is established"), which is possibl=
e
> now that we no longer support running as PV guest in 32-bit mode.
>=20
> Cc: <stable.vger.kernel.org> # 5.9

Sorry for messing up the stable link, but please don't include this
patch in stable kernels before 5.9


Juergen

> Fixes: 36104cb9012a82e73 ("x86/xen: Delay get_cpu_cap until stack canar=
y is established")
> Reported-by: Olaf Hering <olaf@aepfle.de>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> Link: https://lore.kernel.org/r/12a866b0-9e89-59f7-ebeb-a2a6cec0987a@su=
se.com
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>   arch/x86/xen/enlighten_pv.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> --- a/arch/x86/xen/enlighten_pv.c
> +++ b/arch/x86/xen/enlighten_pv.c
> @@ -1246,16 +1246,16 @@ asmlinkage __visible void __init xen_sta
>   	/* Get mfn list */
>   	xen_build_dynamic_phys_to_machine();
>  =20
> +	/* Work out if we support NX */
> +	get_cpu_cap(&boot_cpu_data);
> +	x86_configure_nx();
> +
>   	/*
>   	 * Set up kernel GDT and segment registers, mainly so that
>   	 * -fstack-protector code can be executed.
>   	 */
>   	xen_setup_gdt(0);
>  =20
> -	/* Work out if we support NX */
> -	get_cpu_cap(&boot_cpu_data);
> -	x86_configure_nx();
> -
>   	/* Determine virtual and physical address sizes */
>   	get_cpu_address_sizes(&boot_cpu_data);
>  =20
>=20
>=20


--------------C8F10F2D5F5C1F8416CDE582
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

--------------C8F10F2D5F5C1F8416CDE582--

--uEevRINPBpsFTVLNmx6wseFe669HMgse2--

--ATH5QzO71TNqzvpwWdCjpiDfHFPpuWRfK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmCshvkFAwAAAAAACgkQsN6d1ii/Ey93
jQf+L9Qtt5dITB1jtO/7lJYyWwpc1kUg0YhPmRn3hMOCchjGLb9ewXIvt+avEtNdlQtTVhT3Wui2
wPsq9vlnEtT/w8jUIx2ySIOHwJUY2la0Q1R+rDFBq1UYXyzqEeJKhGHTKEDc5Mtwsps3PJKpjGyI
GfB8Bo0JmE5XpwJ9ENMlQGrh2QM2w0Jvmz+UyOY8GXEikoJi5wxp+bJrBh+KQSVllMEM6rstJqi6
Y9ObqvplyisCASk2NY1SiQL5tsKJ++tqAYnmDX9flDApdosdHrl3bei/JS4VT+R0PsnaDYlmu15P
SFjxH/GyakwFTBgiuk4KlVvpiowDgDPP/W9qgXsIcA==
=gWP4
-----END PGP SIGNATURE-----

--ATH5QzO71TNqzvpwWdCjpiDfHFPpuWRfK--
