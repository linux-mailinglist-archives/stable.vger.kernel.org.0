Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE5A3FFCA2
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348682AbhICJD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:03:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41304 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348635AbhICJDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 05:03:00 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5EFA6225F7;
        Fri,  3 Sep 2021 09:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630659719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y2yOgR7xOsgNe3DptYo2QPyqQttv32W4xVBl15aqNN4=;
        b=pNNE6BX8asHX6WKrgFgKgJflKWF5Ifavakx2rqMPBZZDZpfs2PgmzaM61GHNjicbucQaA4
        gYG1qSy5fMSSHEv6bwSJbR+RVxktEdMYGR5MnqeZ6tCaBOKDNFCE3fMsHRcAyWj+Mm8ben
        LzQuKW/A7oCAYGQQFM9AdQ5A3LB1+N4=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0FB0C1374A;
        Fri,  3 Sep 2021 09:01:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 2qW5AYfkMWFBdwAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 09:01:59 +0000
Subject: Re: [PATCH 1/2] PM: base: power: don't try to use non-existing RTC
 for storing data
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     xen-devel@lists.xenproject.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org
References: <20210903084937.19392-1-jgross@suse.com>
 <20210903084937.19392-2-jgross@suse.com> <YTHjPbklWVDVaBfK@kroah.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <1b6a8f9c-2a5f-e97e-c89d-5983ceeb20e5@suse.com>
Date:   Fri, 3 Sep 2021 11:01:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YTHjPbklWVDVaBfK@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8QrHnFxLhYwW5JVUDZedIeiKcRWLD8jDi"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8QrHnFxLhYwW5JVUDZedIeiKcRWLD8jDi
Content-Type: multipart/mixed; boundary="DDwF9mzVWNkpBGBzATm4O5noHEiM7Qhxi";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: xen-devel@lists.xenproject.org, linux-pm@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
 Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
 "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org
Message-ID: <1b6a8f9c-2a5f-e97e-c89d-5983ceeb20e5@suse.com>
Subject: Re: [PATCH 1/2] PM: base: power: don't try to use non-existing RTC
 for storing data
References: <20210903084937.19392-1-jgross@suse.com>
 <20210903084937.19392-2-jgross@suse.com> <YTHjPbklWVDVaBfK@kroah.com>
In-Reply-To: <YTHjPbklWVDVaBfK@kroah.com>

--DDwF9mzVWNkpBGBzATm4O5noHEiM7Qhxi
Content-Type: multipart/mixed;
 boundary="------------7C43D073BE29B721237268B8"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------7C43D073BE29B721237268B8
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 03.09.21 10:56, Greg Kroah-Hartman wrote:
> On Fri, Sep 03, 2021 at 10:49:36AM +0200, Juergen Gross wrote:
>> In there is no legacy RTC device, don't try to use it for storing trac=
e
>> data across suspend/resume.
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>   drivers/base/power/trace.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
>> index a97f33d0c59f..b7c80849455c 100644
>> --- a/drivers/base/power/trace.c
>> +++ b/drivers/base/power/trace.c
>> @@ -13,6 +13,7 @@
>>   #include <linux/export.h>
>>   #include <linux/rtc.h>
>>   #include <linux/suspend.h>
>> +#include <linux/init.h>
>>  =20
>>   #include <linux/mc146818rtc.h>
>>  =20
>> @@ -165,6 +166,9 @@ void generate_pm_trace(const void *tracedata, unsi=
gned int user)
>>   	const char *file =3D *(const char **)(tracedata + 2);
>>   	unsigned int user_hash_value, file_hash_value;
>>  =20
>> +	if (!x86_platform.legacy.rtc)
>> +		return 0;
>=20
> Why does the driver core code here care about a platform/arch-specific
> thing at all?  Did you just break all other arches?

This file is only compiled for x86. It depends on CONFIG_PM_TRACE_RTC,
which has a "depends on X86" attribute.


Juergen

--------------7C43D073BE29B721237268B8
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

--------------7C43D073BE29B721237268B8--

--DDwF9mzVWNkpBGBzATm4O5noHEiM7Qhxi--

--8QrHnFxLhYwW5JVUDZedIeiKcRWLD8jDi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmEx5IYFAwAAAAAACgkQsN6d1ii/Ey8Z
Ywf+Pq3IKlaBuk34XWwT2ZcLn5H2s4d3HKoC1sokLsNtHiDJAveAMkhzsaIiSP8xfYzC0FKpGsB2
Y9iAFojypHyCF/BVEY1A48vxMFfYVcgqrohKB9MUVOhKDsaB5mzAZ7YeqQR5khtuc5J2B34Rij5c
VW0E0QjxjgcPL4O0ZFw9+p+f/BpIBECqUZV1hVoSiEtunFIt9xz+hJFJ9CF5P/ic0lsaNy2aTUos
3sHTrWdrBcHLE8pPN4wYXWz5SBj4HW64jG9C/nO6lw43EJ4JO4tw9KtgQ7VI4oQphdQmiKqk8Vzw
m3FWeab8bAWHHq9/MpyGfh+SBea4edJOy/pVI7CKng==
=vU83
-----END PGP SIGNATURE-----

--8QrHnFxLhYwW5JVUDZedIeiKcRWLD8jDi--
