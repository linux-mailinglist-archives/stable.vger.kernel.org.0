Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28C7441419
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 08:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhKAHXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 03:23:46 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33318 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhKAHXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 03:23:45 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CC9F21FD4D;
        Mon,  1 Nov 2021 07:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635751271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OiJvobuX3n+EKs/NhnXLnNLW7NKcWLIH/WcTQdqCZ8o=;
        b=I5K8caJmT6AxGK8R6Q6oIaoOxGSg79sI95p5WiZq1tU2uqNyf5stcBECg/L7SsHJ6NHsQD
        5WuNlPNJjZlUUjzPH0I/uVhA3gyvqVYsqnGiO6nFhKBNyuCACNQrCLbm137wpuSZKvTo18
        FVZZN/evzGDicGtdhvHqxbe9+vBGzgI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9853513A6F;
        Mon,  1 Nov 2021 07:21:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id akM/I2eVf2F/EAAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 01 Nov 2021 07:21:11 +0000
Subject: Re: [PATCH v3] xen/balloon: add late_initcall_sync() for initial
 ballooning done
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20211029142049.25198-1-jgross@suse.com>
 <11956c14-f1f7-70f0-40a6-aad31a264af6@oracle.com> <YXxzQhPvgAOkhGg/@mail-itl>
 <2365e65f-7431-4bf5-4ced-5e146776b9ac@oracle.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <0e32534b-c50f-d6ea-2927-dc763939dbcb@suse.com>
Date:   Mon, 1 Nov 2021 08:21:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2365e65f-7431-4bf5-4ced-5e146776b9ac@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SatvGOBbXAB4GMvHz0933pF793czZeWDD"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SatvGOBbXAB4GMvHz0933pF793czZeWDD
Content-Type: multipart/mixed; boundary="XMt9OejtjTyGiADg3Sqcf50uQJdI9RM6R";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= <marmarek@invisiblethingslab.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
Message-ID: <0e32534b-c50f-d6ea-2927-dc763939dbcb@suse.com>
Subject: Re: [PATCH v3] xen/balloon: add late_initcall_sync() for initial
 ballooning done
References: <20211029142049.25198-1-jgross@suse.com>
 <11956c14-f1f7-70f0-40a6-aad31a264af6@oracle.com> <YXxzQhPvgAOkhGg/@mail-itl>
 <2365e65f-7431-4bf5-4ced-5e146776b9ac@oracle.com>
In-Reply-To: <2365e65f-7431-4bf5-4ced-5e146776b9ac@oracle.com>

--XMt9OejtjTyGiADg3Sqcf50uQJdI9RM6R
Content-Type: multipart/mixed;
 boundary="------------C2DAF238F4CCA8207EC03136"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------C2DAF238F4CCA8207EC03136
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 30.10.21 01:44, Boris Ostrovsky wrote:
>=20
> On 10/29/21 6:18 PM, Marek Marczykowski-G=C3=B3recki wrote:
>> On Fri, Oct 29, 2021 at 05:46:18PM -0400, Boris Ostrovsky wrote:
>>> On 10/29/21 10:20 AM, Juergen Gross wrote:
>>>> --- a/Documentation/ABI/stable/sysfs-devices-system-xen_memory
>>>> +++ b/Documentation/ABI/stable/sysfs-devices-system-xen_memory
>>>> @@ -84,3 +84,13 @@ Description:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control=
 scrubbing pages before returning them to Xen for=20
>>>> others domains
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 use. Ca=
n be set with xen_scrub_pages cmdline
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 paramet=
er. Default value controlled with=20
>>>> CONFIG_XEN_SCRUB_PAGES_DEFAULT.
>>>> +
>>>> +What:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /sys/devices/system=
/xen_memory/xen_memory0/boot_timeout
>>>> +Date:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 November 2021
>>>> +KernelVersion:=C2=A0=C2=A0=C2=A0 5.16
>>>> +Contact:=C2=A0=C2=A0=C2=A0 xen-devel@lists.xenproject.org
>>>> +Description:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 The time (in seconds) to=
 wait before giving up to boot in case
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 initial ballooning fails=
 to free enough memory. Applies only
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 when running as HVM or P=
VH guest and started with less memory
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 configured than allowed =
at max.
>>>
>>> How is this going to be used? We only need this during boot.
>>>
>>>
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state =3D update_schedul=
e(state);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 balloon_state =3D update=
_schedule(balloon_state);
>>>
>>> Now that balloon_state has whole file scope it can probably be=20
>>> updated inside update_schedule().
>>>
>>>
>>>> +=C2=A0=C2=A0=C2=A0 while ((credit =3D current_credit()) < 0) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (credit !=3D last_cre=
dit) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
last_changed =3D jiffies;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
last_credit =3D credit;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (balloon_state =3D=3D=
 BP_ECANCELED) {
>>>
>>> What about other states? We are really waiting for BP_DONE, aren't we=
?
>> BP_DONE is set also as an intermediate step:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 balloo=
n_state =3D decrease_reservation(n_pages,
>>                                                             =20
>> GFP_BALLOON);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ba=
lloon_state =3D=3D BP_DONE && n_pages !=3D=20
>> -credit &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 n_pages < totalreserve_pages)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 balloon_state =3D BP_EAGAIN;
>>
>> It would be bad to finish waiting in this case.
>=20
>=20
> RIght, but if we were to say 'if (balloon_state !=3D BP_DONE)' the wors=
t=20
> that can happen is that we will continue on to the next iteration=20
> without warning and/or panicing. Of course, there is a chance thaton th=
e=20
> next iteration the same thing will happen but I think chances of hittin=
g=20
> this race every time are infinitely low. We can also check for=20
> current_credit() again.
>=20
>=20
> The question is whether we do want to continue waiting if we are in=20
> BP_AGAIN. I don't think BP_WAIT is possible in this case although this =

> may change in the future and we will forget to update this code.

BP_EAGAIN should not stop waiting, as it might be intermediate in case
some caches or buffers are freed.


Juergen

--------------C2DAF238F4CCA8207EC03136
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

--------------C2DAF238F4CCA8207EC03136--

--XMt9OejtjTyGiADg3Sqcf50uQJdI9RM6R--

--SatvGOBbXAB4GMvHz0933pF793czZeWDD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmF/lWYFAwAAAAAACgkQsN6d1ii/Ey80
KAf/Qqdw1mA/ijbb+odtKZ9Vua+VXes2bJWyzjxtQ/zKSRUvqcJ7qttbzmLt2A6ar2pscUiUGG5H
CVFIfzxKE3qXV7IlkEtyQ7bRFpL0Y7YjH5HnhM4mr6bttQZX6qwQDvGuNwLwkTP6bD4TVmN/wNoD
U1sjdad8E2Ay8a7+rbuVdii7lJ5RgrzXBnKVJDqqztYiWh/WgjC0r2kiCP46ZqVtimwzr6T7cB+5
f/OxmURztozz9NrXxmM7ST2XvAi4CBerYJAtr+KQvJg+3BD24MLRLg2JHX8ZIVrt2U7vjlKH1CAW
2c2ZsVpDv5xTgO4Y9SjpUqBsXz+x+K8GHgnadzjSfg==
=8Vp5
-----END PGP SIGNATURE-----

--SatvGOBbXAB4GMvHz0933pF793czZeWDD--
