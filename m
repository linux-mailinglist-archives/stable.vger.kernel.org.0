Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086AD459BDC
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 06:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhKWFpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 00:45:53 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:44084 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhKWFpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 00:45:52 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 169591FD5A;
        Tue, 23 Nov 2021 05:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637646164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WFfl91pRcKjqye/TMhEYh56wAOGqJAk6Y4WkR2sBiHI=;
        b=LFz7uY9myDNF/P+QQ6Hs6HK3+8yVcp3PQGdPWUU1dKi5MQHALG6WpCJc3uu0sEduunUbQw
        N575J4oAZyBCoU9KSPBDb2akvDy8+tXb1v8Ee0tTeUSkIeVOG+ld4QYOWM/VGh9ToSVatS
        ubhEyiuxRpsOGtthFZ8/rIswmXp9uak=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DEF6413CE1;
        Tue, 23 Nov 2021 05:42:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mlQ/NVN/nGF/PgAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 23 Nov 2021 05:42:43 +0000
Subject: Re: [PATCH v3] xen: detect uninitialized xenbus in xenbus_init
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, jbeulich@suse.com,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org
References: <20211122221625.1473164-1-sstabellini@kernel.org>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <2533e721-a01b-6659-71fa-24a8d2896e84@suse.com>
Date:   Tue, 23 Nov 2021 06:42:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211122221625.1473164-1-sstabellini@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bn1VCEjXOAIElom9Rm33lM2aD0v2rQP0n"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bn1VCEjXOAIElom9Rm33lM2aD0v2rQP0n
Content-Type: multipart/mixed; boundary="vgJhsb0FzDXqTZh0hVwNv70ek98hUO1L5";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Stefano Stabellini <sstabellini@kernel.org>
Cc: boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org, jbeulich@suse.com,
 Stefano Stabellini <stefano.stabellini@xilinx.com>, stable@vger.kernel.org
Message-ID: <2533e721-a01b-6659-71fa-24a8d2896e84@suse.com>
Subject: Re: [PATCH v3] xen: detect uninitialized xenbus in xenbus_init
References: <20211122221625.1473164-1-sstabellini@kernel.org>
In-Reply-To: <20211122221625.1473164-1-sstabellini@kernel.org>

--vgJhsb0FzDXqTZh0hVwNv70ek98hUO1L5
Content-Type: multipart/mixed;
 boundary="------------E19278278CC40697BA37CB60"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------E19278278CC40697BA37CB60
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 22.11.21 23:16, Stefano Stabellini wrote:
> From: Stefano Stabellini <stefano.stabellini@xilinx.com>
>=20
> If the xenstore page hasn't been allocated properly, reading the value
> of the related hvm_param (HVM_PARAM_STORE_PFN) won't actually return
> error. Instead, it will succeed and return zero. Instead of attempting
> to xen_remap a bad guest physical address, detect this condition and
> return early.
>=20
> Note that although a guest physical address of zero for
> HVM_PARAM_STORE_PFN is theoretically possible, it is not a good choice
> and zero has never been validly used in that capacity.
>=20
> Also recognize the invalid value of INVALID_PFN which is ULLONG_MAX.
>=20
> For 32-bit Linux, any pfn above ULONG_MAX would get truncated. Pfns
> above ULONG_MAX should never be passed by the Xen tools to HVM guests
> anyway, so check for this condition and return early.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
> ---
> Changes in v3:
> - improve in-code comment
> - improve check
>=20
> Changes in v2:
> - add check for ULLONG_MAX (unitialized)
> - add check for ULONG_MAX #if BITS_PER_LONG =3D=3D 32 (actual error)
> - add pr_err error message
> ---
>   drivers/xen/xenbus/xenbus_probe.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>=20
> diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xen=
bus_probe.c
> index 94405bb3829e..d3ca57d48a73 100644
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -951,6 +951,30 @@ static int __init xenbus_init(void)
>   		err =3D hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
>   		if (err)
>   			goto out_error;
> +		/*
> +		 * Uninitialized hvm_params are zero and return no error.
> +		 * Although it is theoretically possible to have
> +		 * HVM_PARAM_STORE_PFN set to zero on purpose, in reality it is
> +		 * not zero when valid. If zero, it means that Xenstore hasn't
> +		 * been properly initialized. Instead of attempting to map a
> +		 * wrong guest physical address return error.
> +		 *
> +		 * Also recognize the invalid value of INVALID_PFN which is
> +		 * ULLONG_MAX.

Adjust the comment, e.g. s/ULLONG_MAX/all bits set/ (in the commit
message, too)?

> +		 */
> +		if (!v || !(v + 1)) {

For me "if (!v || !~v)" would be more readable, but I don't really feel
strong here.


Juergen


--------------E19278278CC40697BA37CB60
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

--------------E19278278CC40697BA37CB60--

--vgJhsb0FzDXqTZh0hVwNv70ek98hUO1L5--

--bn1VCEjXOAIElom9Rm33lM2aD0v2rQP0n
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGcf1MFAwAAAAAACgkQsN6d1ii/Ey/E
6gf+KBrFH8z6V/OHebwAaADAOQDzdnV62qyE7RJ5xrZWLABS3KFF3gm3vWYbXv6Eh53+bwHaFhZ2
OMCd97N/XLqB1YhADGgyv7K3XOJ+CadS01ZD63+yDQK3amdmoEbLMxVITaR3uWZPc8mJDb4f2zFa
Xwjx1WNcqHgZw4XzPTfQi0fMfmI2doLE8/D8k85iJRPaABAqwTzr30UZRjzzY/eIocj0Qk/LDzDt
UgB65qJBTrx24NJjC/JNInNXuXEbNhoxVKyRx/EkmJtnTVTLeHvF/f8w9AlF8XssFx5ahfHVY5T/
G9o/RxanNAtMk3l8Tf/r6rwfg6B0z8pi0GeKDBggow==
=RCUE
-----END PGP SIGNATURE-----

--bn1VCEjXOAIElom9Rm33lM2aD0v2rQP0n--
