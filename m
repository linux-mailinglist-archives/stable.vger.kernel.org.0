Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E4A4022A0
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 06:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhIGETc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 00:19:32 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47898 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhIGETb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 00:19:31 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 278BE1FF56;
        Tue,  7 Sep 2021 04:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630988305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h49ksqWpNBrOpV9ozMeMCOB3BPOEfvBt8DuU3qwVRqc=;
        b=sZNNeEPwCdCRgkir273n5eFwHDgdw09J9nVsrNWcwRIcB8eB9BEzwnPVCPOPZCdJRaUvtb
        NxyFo5jPrQPrxrxIirIpNeQ1LSKCvGhkbtLkmmgRNtGv89i+lkQsylxBGUAM4rdp7dydgg
        ePYUWKRc0W2M5DRpLXYO2RjSjFhzsS0=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id B8D0612FF9;
        Tue,  7 Sep 2021 04:18:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 5CvvKhDoNmE4awAAGKfGzw
        (envelope-from <jgross@suse.com>); Tue, 07 Sep 2021 04:18:24 +0000
Subject: Re: [PATCH 1/2] PM: base: power: don't try to use non-existing RTC
 for storing data
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xenproject.org,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Stable <stable@vger.kernel.org>
References: <20210903084937.19392-1-jgross@suse.com>
 <20210903084937.19392-2-jgross@suse.com> <YTHjPbklWVDVaBfK@kroah.com>
 <1b6a8f9c-2a5f-e97e-c89d-5983ceeb20e5@suse.com>
 <CAJZ5v0g_WVFqDKCBYnoPtqR5VzH-eBMk+7M1bAmgGsyX0XGpgw@mail.gmail.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <3f08f433-a228-d512-3608-3ed0c797e653@suse.com>
Date:   Tue, 7 Sep 2021 06:18:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0g_WVFqDKCBYnoPtqR5VzH-eBMk+7M1bAmgGsyX0XGpgw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2WDWaUILT1zcTAfwQw13cP6arEOvVJ7NT"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2WDWaUILT1zcTAfwQw13cP6arEOvVJ7NT
Content-Type: multipart/mixed; boundary="40AjFM7hF7VBwEyptUN1cRO8vL4caXhmG";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 xen-devel@lists.xenproject.org, Linux PM <linux-pm@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@ucw.cz>, Stable <stable@vger.kernel.org>
Message-ID: <3f08f433-a228-d512-3608-3ed0c797e653@suse.com>
Subject: Re: [PATCH 1/2] PM: base: power: don't try to use non-existing RTC
 for storing data
References: <20210903084937.19392-1-jgross@suse.com>
 <20210903084937.19392-2-jgross@suse.com> <YTHjPbklWVDVaBfK@kroah.com>
 <1b6a8f9c-2a5f-e97e-c89d-5983ceeb20e5@suse.com>
 <CAJZ5v0g_WVFqDKCBYnoPtqR5VzH-eBMk+7M1bAmgGsyX0XGpgw@mail.gmail.com>
In-Reply-To: <CAJZ5v0g_WVFqDKCBYnoPtqR5VzH-eBMk+7M1bAmgGsyX0XGpgw@mail.gmail.com>

--40AjFM7hF7VBwEyptUN1cRO8vL4caXhmG
Content-Type: multipart/mixed;
 boundary="------------9B3DCA2E79466DA893357F5F"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------9B3DCA2E79466DA893357F5F
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 06.09.21 19:07, Rafael J. Wysocki wrote:
> On Fri, Sep 3, 2021 at 11:02 AM Juergen Gross <jgross@suse.com> wrote:
>>
>> On 03.09.21 10:56, Greg Kroah-Hartman wrote:
>>> On Fri, Sep 03, 2021 at 10:49:36AM +0200, Juergen Gross wrote:
>>>> In there is no legacy RTC device, don't try to use it for storing tr=
ace
>>>> data across suspend/resume.
>>>>
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>>> ---
>>>>    drivers/base/power/trace.c | 10 ++++++++++
>>>>    1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c=

>>>> index a97f33d0c59f..b7c80849455c 100644
>>>> --- a/drivers/base/power/trace.c
>>>> +++ b/drivers/base/power/trace.c
>>>> @@ -13,6 +13,7 @@
>>>>    #include <linux/export.h>
>>>>    #include <linux/rtc.h>
>>>>    #include <linux/suspend.h>
>>>> +#include <linux/init.h>
>>>>
>>>>    #include <linux/mc146818rtc.h>
>>>>
>>>> @@ -165,6 +166,9 @@ void generate_pm_trace(const void *tracedata, un=
signed int user)
>>>>       const char *file =3D *(const char **)(tracedata + 2);
>>>>       unsigned int user_hash_value, file_hash_value;
>>>>
>>>> +    if (!x86_platform.legacy.rtc)
>>>> +            return 0;
>>>
>>> Why does the driver core code here care about a platform/arch-specifi=
c
>>> thing at all?  Did you just break all other arches?
>>
>> This file is only compiled for x86. It depends on CONFIG_PM_TRACE_RTC,=

>> which has a "depends on X86" attribute.
>=20
> This feature uses the CMOS RTC memory to store data, so if that memory
> is not present, it's better to avoid using it.
>=20
> Please feel free to add
>=20
> Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>

Thanks!

>=20
> to this patch or let me know if you want me to take it.
>=20

No, I can take it with the other patch of this small series, thanks.


Juergen

--------------9B3DCA2E79466DA893357F5F
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

--------------9B3DCA2E79466DA893357F5F--

--40AjFM7hF7VBwEyptUN1cRO8vL4caXhmG--

--2WDWaUILT1zcTAfwQw13cP6arEOvVJ7NT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmE26BAFAwAAAAAACgkQsN6d1ii/Ey9r
Hwf/c5XiAVGxbZw83ONwePCE+bf8D3q8KJTcmCkhNwelw0RK36RQnVYNwSa9bzaSR89Lzi1swmXh
Lr82MokgGFWKUx9MPteFyc4i5PyxI2YNuktNKru/bQNoiVjNzBtppdt1N2GozS0vE2SeeAr+VNIf
OYYpAWaHOSV0UtyOSbD5pQYD8+dAfs87HJ+1iX3p9RLGNZI+zO0MHdzqVLdTxEaVhOitakKC1sPR
WXjVRTPTduUUqcnQUt93kt/1rz4zUcHoO5KdI859qIY4EmLKL4psTa2SEyjU0oB0JrUQxpoceul6
05bb8ymydiOv8M2YIpC1tRIiQMXnSWLYtp7FTgO7bg==
=1oDE
-----END PGP SIGNATURE-----

--2WDWaUILT1zcTAfwQw13cP6arEOvVJ7NT--
