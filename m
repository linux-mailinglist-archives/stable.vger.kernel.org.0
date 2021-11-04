Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D0C445772
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 17:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhKDQrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 12:47:37 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40484 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhKDQrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 12:47:37 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0D969212BD;
        Thu,  4 Nov 2021 16:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636044298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+iHyYJVejxE3c+M9dmelJzpLB+/Wh6THMcNjAw741DM=;
        b=ZG+o2TcgbZrkgBuC6dv9I8/AQoEDlU7rGmksNtmvXMrdavMzT9X0x/tiCrqhfE/uyD6UmT
        Zpw1mvkaLp6SZwQ+QJqjicM7b3Ess/0cvGAmyRmlUJkHcAZPaf1eV8pJcW1zNc7z8/pz+2
        YrrYu3b8BezNiBddbntqNlhqadObGRc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B694913E70;
        Thu,  4 Nov 2021 16:44:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eHvVKgkOhGFeFwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 04 Nov 2021 16:44:57 +0000
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20211102091944.17487-1-jgross@suse.com>
 <f986a7c4-3032-fecd-2e19-4d63a2ee10c7@oracle.com>
 <f8e52acc-2566-1ed0-d2a3-21e2d468fab7@oracle.com>
 <3b1f1771-0a96-1f71-9c9d-9fb1a53a266e@suse.com>
 <18c12ead-ddf1-9231-7f3b-aafddd349dcf@oracle.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v4] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Message-ID: <2f3addff-fbe0-8ef0-6407-e879c0e9827f@suse.com>
Date:   Thu, 4 Nov 2021 17:44:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <18c12ead-ddf1-9231-7f3b-aafddd349dcf@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="g757mACy6ndOeHy2l0XCaKTMldya4VhZX"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--g757mACy6ndOeHy2l0XCaKTMldya4VhZX
Content-Type: multipart/mixed; boundary="7NqwldsUw7TpcaPNG4ex5XcZovKmVXFSQ";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= <marmarek@invisiblethingslab.com>
Message-ID: <2f3addff-fbe0-8ef0-6407-e879c0e9827f@suse.com>
Subject: Re: [PATCH v4] xen/balloon: add late_initcall_sync() for initial
 ballooning done
References: <20211102091944.17487-1-jgross@suse.com>
 <f986a7c4-3032-fecd-2e19-4d63a2ee10c7@oracle.com>
 <f8e52acc-2566-1ed0-d2a3-21e2d468fab7@oracle.com>
 <3b1f1771-0a96-1f71-9c9d-9fb1a53a266e@suse.com>
 <18c12ead-ddf1-9231-7f3b-aafddd349dcf@oracle.com>
In-Reply-To: <18c12ead-ddf1-9231-7f3b-aafddd349dcf@oracle.com>

--7NqwldsUw7TpcaPNG4ex5XcZovKmVXFSQ
Content-Type: multipart/mixed;
 boundary="------------4A2F17B6B681BBA4AE9C74EE"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------4A2F17B6B681BBA4AE9C74EE
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 04.11.21 17:34, Boris Ostrovsky wrote:
>=20
> On 11/4/21 12:21 PM, Juergen Gross wrote:
>> On 04.11.21 16:55, Boris Ostrovsky wrote:
>>>
>>> On 11/3/21 9:55 PM, Boris Ostrovsky wrote:
>>>>
>>>> On 11/2/21 5:19 AM, Juergen Gross wrote:
>>>>> When running as PVH or HVM guest with actual memory < max memory th=
e
>>>>> hypervisor is using "populate on demand" in order to allow the gues=
t
>>>>> to balloon down from its maximum memory size. For this to work
>>>>> correctly the guest must not touch more memory pages than its targe=
t
>>>>> memory size as otherwise the PoD cache will be exhausted and the gu=
est
>>>>> is crashed as a result of that.
>>>>>
>>>>> In extreme cases ballooning down might not be finished today before=

>>>>> the init process is started, which can consume lots of memory.
>>>>>
>>>>> In order to avoid random boot crashes in such cases, add a late ini=
t
>>>>> call to wait for ballooning down having finished for PVH/HVM guests=
=2E
>>>>>
>>>>> Warn on console if initial ballooning fails, panic() after stalling=

>>>>> for more than 3 minutes per default. Add a module parameter for
>>>>> changing this timeout.
>>>>>
>>>>> Cc: <stable@vger.kernel.org>
>>>>> Reported-by: Marek Marczykowski-G=C3=B3recki=20
>>>>> <marmarek@invisiblethingslab.com>
>>>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>>>
>>>>
>>>>
>>>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>>
>>>
>>> This appears to have noticeable effect on boot time (and boot=20
>>> experience in general).
>>>
>>>
>>> I have
>>>
>>>
>>> =C2=A0=C2=A0 memory=3D1024
>>> =C2=A0=C2=A0 maxmem=3D8192
>>>
>>>
>>> And my boot time (on an admittedly slow box) went from 33 to 45=20
>>> seconds. And boot pauses in the middle while it is waiting for=20
>>> ballooning to complete.
>>>
>>>
>>> [=C2=A0=C2=A0=C2=A0 5.062714] xen:balloon: Waiting for initial balloo=
ning down=20
>>> having finished.
>>> [=C2=A0=C2=A0=C2=A0 5.449696] random: crng init done
>>> [=C2=A0=C2=A0 34.613050] xen:balloon: Initial ballooning down finishe=
d.
>>
>> This shows that before it was just by chance that the PoD cache wasn't=

>> exhausted.
>=20
>=20
> True.
>=20
>=20
>>
>>> So at least I think we should consider bumping log level down from in=
fo.
>>
>> Which level would you prefer? warn?
>>
>=20
> Notice? Although that won't make much difference as WARN is the default=
=20
> level.

Right. That was my thinking.

> I suppose we can't turn scrubbing off at this point?

I don't think we can be sure a ballooned page wasn't in use before. And
it could contain some data e.g. from the loaded initrd, maybe even put
there by the boot loader. So no, I wouldn't want to do that by default.

We could add another value to the xen_scrub_pages boot parameter, like
xen_scrub_pages=3Dnot-at-boot or some such. But this should be another
patch. And it should be documented that initrd or kernel data might
leak.

>> And if so, would you mind doing this while committing (I have one day
>> off tomorrow)?
>=20
>=20
> Yes, of course.

Thanks.


Juergen


--------------4A2F17B6B681BBA4AE9C74EE
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

--------------4A2F17B6B681BBA4AE9C74EE--

--7NqwldsUw7TpcaPNG4ex5XcZovKmVXFSQ--

--g757mACy6ndOeHy2l0XCaKTMldya4VhZX
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGEDggFAwAAAAAACgkQsN6d1ii/Ey9m
cQf/Y8gjihmtFO7hC5ULMnfDS95jAGACBv8aeEPDpOoA4xQj/n6WO/Ecb3sHUKOTm/+rMxlTUIrz
i/LHUEG+dp+LMFSf9E2ex/p7CodZEy3z2w14ov9KjtzRp+4qPfTSSwnjYRGhrK4pwaY2lw5G7LLD
JLRan5rgj5HRQv3f+oh6qtoIeQPf4DmmYIOE9tQs1lPELvKJPuhybycfou1GOfhdolqVqMEmQJHm
HtejYDi6MOjQ/rH33WPGtEF7MiUy2YxPs86Cer/nRoDc8W4gBOJsTjgM/9DHeVAi8I59pRo2yy81
NrbDRY2uXA5m2usYdtzAWh+TXb4lcNOHsVI1I/aNUg==
=b84U
-----END PGP SIGNATURE-----

--g757mACy6ndOeHy2l0XCaKTMldya4VhZX--
