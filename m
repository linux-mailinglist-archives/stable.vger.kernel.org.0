Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A841F43FAA8
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 12:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhJ2KYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 06:24:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42056 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhJ2KYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 06:24:49 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 32F851FD53;
        Fri, 29 Oct 2021 10:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635502940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NpBs+BlaJGVaaBIJS28nFtrD0GaRfryOLIVX4pU4cWE=;
        b=nP4l/aojAMAp+vKxcHtgt1X3MJL+nm8KRXhHTN0SYGe2t2Qm7RcEk2PVs5RVcesGeHAtV9
        NlLOwJ+plnTLeNYHn/yme6yyGAAQ5DsnhsZLcF1Hf7MrNMkywJxyYCv29GUGJWY3ur8i8/
        GMO2kcXmL/R7GqLGo5+UurDJZrYcNpg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8750F13BBE;
        Fri, 29 Oct 2021 10:22:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mfQIH1vLe2FKRwAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 29 Oct 2021 10:22:19 +0000
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20211028105952.10011-1-jgross@suse.com>
 <YXsFO2TMRiJTQM2q@mail-itl> <27e7619a-a797-5c46-9f9f-015ab488e31c@suse.com>
 <YXvFfRKuD574hulr@mail-itl>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Message-ID: <63a474ea-9e5d-4515-ca99-1d56f52b7673@suse.com>
Date:   Fri, 29 Oct 2021 12:22:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YXvFfRKuD574hulr@mail-itl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Fdc7FltF5YGeKV3gR9EUKXH5xt7a8jSp8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fdc7FltF5YGeKV3gR9EUKXH5xt7a8jSp8
Content-Type: multipart/mixed; boundary="joHFG26fOySkAysnHotfMlksprVfq3bLQ";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
Message-ID: <63a474ea-9e5d-4515-ca99-1d56f52b7673@suse.com>
Subject: Re: [PATCH] xen/balloon: add late_initcall_sync() for initial
 ballooning done
References: <20211028105952.10011-1-jgross@suse.com>
 <YXsFO2TMRiJTQM2q@mail-itl> <27e7619a-a797-5c46-9f9f-015ab488e31c@suse.com>
 <YXvFfRKuD574hulr@mail-itl>
In-Reply-To: <YXvFfRKuD574hulr@mail-itl>

--joHFG26fOySkAysnHotfMlksprVfq3bLQ
Content-Type: multipart/mixed;
 boundary="------------67EF389DDB8B8DBA8228B295"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------67EF389DDB8B8DBA8228B295
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 29.10.21 11:57, Marek Marczykowski-G=C3=B3recki wrote:
> On Fri, Oct 29, 2021 at 06:48:44AM +0200, Juergen Gross wrote:
>> On 28.10.21 22:16, Marek Marczykowski-G=C3=B3recki wrote:
>>> On Thu, Oct 28, 2021 at 12:59:52PM +0200, Juergen Gross wrote:
>>>> When running as PVH or HVM guest with actual memory < max memory the=

>>>> hypervisor is using "populate on demand" in order to allow the guest=

>>>> to balloon down from its maximum memory size. For this to work
>>>> correctly the guest must not touch more memory pages than its target=

>>>> memory size as otherwise the PoD cache will be exhausted and the gue=
st
>>>> is crashed as a result of that.
>>>>
>>>> In extreme cases ballooning down might not be finished today before
>>>> the init process is started, which can consume lots of memory.
>>>>
>>>> In order to avoid random boot crashes in such cases, add a late init=

>>>> call to wait for ballooning down having finished for PVH/HVM guests.=

>>>>
>>>> Cc: <stable@vger.kernel.org>
>>>> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethin=
gslab.com>
>>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>>
>>> It may happen that initial balloon down fails (state=3D=3DBP_ECANCELE=
D). In
>>> that case, it waits indefinitely. I think it should rather report a
>>> failure (and panic? it's similar to OOM before PID 1 starts, so rathe=
r
>>> hard to recover), instead of hanging.
>>
>> Okay, I can add something like that. I'm thinking of issuing a failure=

>> message in case of credit not having changed for 1 minute and panic()
>> after two more minutes. Is this fine?
>=20
> Isn't it better to get a state from balloon_thread()? If the balloon
> fails it won't really try anymore (until 3600s timeout), so waiting in
> that state doesn't help. And reporting the failure earlier may be more
> user friendly. Or maybe there is something that could wakeup the thread=

> earlier, that I don't see? Hot plugging more RAM is rather unlikely at
> this stage...

Waking up the thread would be easy, but probably that wouldn't really
help.

The idea was that maybe a Xen admin would see the guest not booting up
further and then adding some more memory to the guest (this should wake
up the balloon thread again).

I agree that stopping to wait for ballooning to finish in case of it
having failed is probably a sensible thing to do. Additionally I could
add a boot parameter to control the timeout after the fail message and
the panic().

What do you think?


Juergen


Juergen

--------------67EF389DDB8B8DBA8228B295
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

--------------67EF389DDB8B8DBA8228B295--

--joHFG26fOySkAysnHotfMlksprVfq3bLQ--

--Fdc7FltF5YGeKV3gR9EUKXH5xt7a8jSp8
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmF7y1sFAwAAAAAACgkQsN6d1ii/Ey+l
ugf/a3IW0loPuVfAGCVx81M8C6h2H4x7prD9NQDY+krOnWqeCgP9nV7xQApbU37EpG8y2ZVoNMLa
PMCd2Sv338o7J5q1Z3NIvJ5F7vB1dHVs1vGOMeuwwFyAP21gNrldaq7y5oVHwzk20sWAfdIZ36qE
BFzFi1fccui0FsJIP2m40XH+SqI6Zl89BZQgzzavYH0FQ9NleLE3vdRoWQmp9GJZsEw4kaBdprZh
IIydb0peoTHZ/1B026/jgNqUOrv7Y7czlFAvN6AAZBJo23Xe1X0bwiXCo/QUJKTprGBC+aFWAzTA
eCWri4KQYwntt25K6Nwd0oFnpT5ygnOg6hWUTjbtqA==
=MezS
-----END PGP SIGNATURE-----

--Fdc7FltF5YGeKV3gR9EUKXH5xt7a8jSp8--
