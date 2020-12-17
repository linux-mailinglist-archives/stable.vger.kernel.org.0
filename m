Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067A82DD344
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 15:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgLQOvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 09:51:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:34590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgLQOvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 09:51:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1608216636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YogHC27dUfdxMyB22ud/NJqrAhXEpWbGzc1AtvrRMlw=;
        b=PHV83dhaP+aTMkKJl0013KHSZ71xxPmZwkeT7qualG09NoQLG7Qmiqqjq0RXYcn1OKC4eq
        dEZdO1vhDnMsZ17m2cQepTmw9K06IGMxWY2/QF3mYRRiO7K0TEONCxAURVHQONOekwqCut
        NhkWXH4cdJYhx02TyriUichjjkjK4jQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EE897AE91;
        Thu, 17 Dec 2020 14:50:35 +0000 (UTC)
Subject: Re: [PATCH 4/5] xen/xenbus: Count pending messages for each watch
To:     SeongJae Park <sjpark@amazon.com>, stable@vger.kernel.org
Cc:     SeongJae Park <sjpark@amazon.de>, doebel@amazon.de, aams@amazon.de,
        mku@amazon.de, julien@xen.org, wipawel@amazon.de,
        linux-kernel@vger.kernel.org, Author Redacted <security@xen.org>
References: <20201217081727.8253-1-sjpark@amazon.com>
 <20201217081727.8253-5-sjpark@amazon.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <76711b5d-4166-19ff-e817-694675051f90@suse.com>
Date:   Thu, 17 Dec 2020 15:50:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201217081727.8253-5-sjpark@amazon.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BTFEMFwHXxBd5wmigQYtzuEXr1td99gpv"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BTFEMFwHXxBd5wmigQYtzuEXr1td99gpv
Content-Type: multipart/mixed; boundary="SQpQFETUAy8uNs8fWFqgHqcxQAkJt9N2F";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: SeongJae Park <sjpark@amazon.com>, stable@vger.kernel.org
Cc: SeongJae Park <sjpark@amazon.de>, doebel@amazon.de, aams@amazon.de,
 mku@amazon.de, julien@xen.org, wipawel@amazon.de,
 linux-kernel@vger.kernel.org, Author Redacted <security@xen.org>
Message-ID: <76711b5d-4166-19ff-e817-694675051f90@suse.com>
Subject: Re: [PATCH 4/5] xen/xenbus: Count pending messages for each watch
References: <20201217081727.8253-1-sjpark@amazon.com>
 <20201217081727.8253-5-sjpark@amazon.com>
In-Reply-To: <20201217081727.8253-5-sjpark@amazon.com>

--SQpQFETUAy8uNs8fWFqgHqcxQAkJt9N2F
Content-Type: multipart/mixed;
 boundary="------------CA64A13DB928E42B8023DDC0"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------CA64A13DB928E42B8023DDC0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 17.12.20 09:17, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
>=20
> This commit adds a counter of pending messages for each watch in the
> struct.  It is used to skip unnecessary pending messages lookup in
> 'unregister_xenbus_watch()'.  It could also be used in 'will_handle'
> callback.
>=20
> This is part of XSA-349
>=20
> This is upstream commit 3dc86ca6b4c8cfcba9da7996189d1b5a358a94fc
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> Reported-by: Michael Kurth <mku@amazon.de>
> Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
> Signed-off-by: Author Redacted <security@xen.org>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>   drivers/xen/xenbus/xenbus_xs.c | 30 ++++++++++++++++++------------
>   include/xen/xenbus.h           |  2 ++
>   2 files changed, 20 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus=
_xs.c
> index 0ea1c259f2f1..420d478e1708 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -701,6 +701,8 @@ int register_xenbus_watch(struct xenbus_watch *watc=
h)
>  =20
>   	sprintf(token, "%lX", (long)watch);
>  =20
> +	watch->nr_pending =3D 0;
> +

I'm missing the incrementing of nr_pending, which was present in the
upstream patch.


Juergen

>   	down_read(&xs_state.watch_mutex);
>  =20
>   	spin_lock(&watches_lock);
> @@ -750,12 +752,15 @@ void unregister_xenbus_watch(struct xenbus_watch =
*watch)
>  =20
>   	/* Cancel pending watch events. */
>   	spin_lock(&watch_events_lock);
> -	list_for_each_entry_safe(msg, tmp, &watch_events, list) {
> -		if (msg->u.watch.handle !=3D watch)
> -			continue;
> -		list_del(&msg->list);
> -		kfree(msg->u.watch.vec);
> -		kfree(msg);
> +	if (watch->nr_pending) {
> +		list_for_each_entry_safe(msg, tmp, &watch_events, list) {
> +			if (msg->u.watch.handle !=3D watch)
> +				continue;
> +			list_del(&msg->list);
> +			kfree(msg->u.watch.vec);
> +			kfree(msg);
> +		}
> +		watch->nr_pending =3D 0;
>   	}
>   	spin_unlock(&watch_events_lock);
>  =20
> @@ -802,7 +807,6 @@ void xs_suspend_cancel(void)
>  =20
>   static int xenwatch_thread(void *unused)
>   {
> -	struct list_head *ent;
>   	struct xs_stored_msg *msg;
>  =20
>   	for (;;) {
> @@ -815,13 +819,15 @@ static int xenwatch_thread(void *unused)
>   		mutex_lock(&xenwatch_mutex);
>  =20
>   		spin_lock(&watch_events_lock);
> -		ent =3D watch_events.next;
> -		if (ent !=3D &watch_events)
> -			list_del(ent);
> +		msg =3D list_first_entry_or_null(&watch_events,
> +				struct xs_stored_msg, list);
> +		if (msg) {
> +			list_del(&msg->list);
> +			msg->u.watch.handle->nr_pending--;
> +		}
>   		spin_unlock(&watch_events_lock);
>  =20
> -		if (ent !=3D &watch_events) {
> -			msg =3D list_entry(ent, struct xs_stored_msg, list);
> +		if (msg) {
>   			msg->u.watch.handle->callback(
>   				msg->u.watch.handle,
>   				(const char **)msg->u.watch.vec,
> diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
> index 1772507dc2c9..ed9e7e3307b7 100644
> --- a/include/xen/xenbus.h
> +++ b/include/xen/xenbus.h
> @@ -58,6 +58,8 @@ struct xenbus_watch
>   	/* Path being watched. */
>   	const char *node;
>  =20
> +	unsigned int nr_pending;
> +
>   	/*
>   	 * Called just before enqueing new event while a spinlock is held.
>   	 * The event will be discarded if this callback returns false.
>=20


--------------CA64A13DB928E42B8023DDC0
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

--------------CA64A13DB928E42B8023DDC0--

--SQpQFETUAy8uNs8fWFqgHqcxQAkJt9N2F--

--BTFEMFwHXxBd5wmigQYtzuEXr1td99gpv
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAl/bcDsFAwAAAAAACgkQsN6d1ii/Ey+s
bwgAhqfxReFrMWGCDysNruAEcZR/t8BjDsh/rTAdFEaFG9b4JmLLsEt/85UoiFenooU7jAFdL+AK
dv/RnWhMD+iFUNDGDIYPHejGPoBw3H7+EBVdSt9p4+d4WhIS+AlEQq7960KhNFVsP58jn4m2Elv9
hC08kBoRgffQFE2YZb5pztCWgHyh9KTP9LBEFwebmzCp1/rNSb5AOT+Yh8wkQIGP2Y+IYFgOaGcM
KnAXnuax+41/FP6ZZMCQ0peGpLCJcXKGNFzyi9LlvPscVSAGh5ufNBepRupSFv3dg/oTORz7F84j
LjeGBlzwrooIYcw63agNCJEcND2wlSKIcddRWhMvlQ==
=0c7Y
-----END PGP SIGNATURE-----

--BTFEMFwHXxBd5wmigQYtzuEXr1td99gpv--
