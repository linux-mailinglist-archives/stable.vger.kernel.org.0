Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9725445696F
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 06:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhKSFTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 00:19:24 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47670 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhKSFTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 00:19:24 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5906E212C3;
        Fri, 19 Nov 2021 05:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637298981; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CZ8May4VfhuaiCLlX4LdXWGn2SOL5tYQ4J+aUlevn30=;
        b=C94y6rlvM/z7CPIf9CLqsdyr4RA5/4QTgtiqRdnY6VraBsjk/mqROE/kfEXN5CYA2KULQ5
        sv44aupivlmA79ogr2MPfzpsrz6c7szHVvKM3gneshZESnRO8OST8RC7K9eTUUbBMOcYQZ
        cvTXhMK94Wj9RufBqgEZpSN2OE5Wh+8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0F0A013A42;
        Fri, 19 Nov 2021 05:16:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 37LxASUzl2FxIAAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 19 Nov 2021 05:16:21 +0000
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     Jan Beulich <jbeulich@suse.com>, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org
References: <20211117021145.3105042-1-sstabellini@kernel.org>
 <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com>
 <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop>
 <44403efe-a850-b53b-785f-6f5c73eb2b96@suse.com>
 <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>
 <b0cd6af9-66c4-3a73-734a-3a51d052fac2@suse.com>
 <alpine.DEB.2.22.394.2111181226460.1412361@ubuntu-linux-20-04-desktop>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
Message-ID: <2d6a1818-e6d0-eb5d-5319-e0cd2e071b03@suse.com>
Date:   Fri, 19 Nov 2021 06:16:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2111181226460.1412361@ubuntu-linux-20-04-desktop>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k9FHfRXORn3u1wfdVDhanJ9xPhj52Izt9"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k9FHfRXORn3u1wfdVDhanJ9xPhj52Izt9
Content-Type: multipart/mixed; boundary="dq7zbyiopWgrKFF7IM4pZ8fIUMjtIo0st";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Stefano Stabellini <sstabellini@kernel.org>
Cc: Jan Beulich <jbeulich@suse.com>, boris.ostrovsky@oracle.com,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 Stefano Stabellini <stefano.stabellini@xilinx.com>, stable@vger.kernel.org
Message-ID: <2d6a1818-e6d0-eb5d-5319-e0cd2e071b03@suse.com>
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
References: <20211117021145.3105042-1-sstabellini@kernel.org>
 <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com>
 <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop>
 <44403efe-a850-b53b-785f-6f5c73eb2b96@suse.com>
 <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>
 <b0cd6af9-66c4-3a73-734a-3a51d052fac2@suse.com>
 <alpine.DEB.2.22.394.2111181226460.1412361@ubuntu-linux-20-04-desktop>
In-Reply-To: <alpine.DEB.2.22.394.2111181226460.1412361@ubuntu-linux-20-04-desktop>

--dq7zbyiopWgrKFF7IM4pZ8fIUMjtIo0st
Content-Type: multipart/mixed;
 boundary="------------1D5CADEDF14EBB1AB90E832F"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------1D5CADEDF14EBB1AB90E832F
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 18.11.21 22:00, Stefano Stabellini wrote:
> On Thu, 18 Nov 2021, Juergen Gross wrote:
>> On 18.11.21 09:47, Jan Beulich wrote:
>>> On 18.11.2021 06:32, Juergen Gross wrote:
>>>> On 18.11.21 03:37, Stefano Stabellini wrote:
>>>>> --- a/drivers/xen/xenbus/xenbus_probe.c
>>>>> +++ b/drivers/xen/xenbus/xenbus_probe.c
>>>>> @@ -951,6 +951,28 @@ static int __init xenbus_init(void)
>>>>>     		err =3D hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
>>>>>     		if (err)
>>>>>     			goto out_error;
>>>>> +		/*
>>>>> +		 * Return error on an invalid value.
>>>>> +		 *
>>>>> +		 * Uninitialized hvm_params are zero and return no error.
>>>>> +		 * Although it is theoretically possible to have
>>>>> +		 * HVM_PARAM_STORE_PFN set to zero on purpose, in reality it
>>>>> is
>>>>> +		 * not zero when valid. If zero, it means that Xenstore hasn't
>>>>> +		 * been properly initialized. Instead of attempting to map a
>>>>> +		 * wrong guest physical address return error.
>>>>> +		 */
>>>>> +		if (v =3D=3D 0) {
>>>>
>>>> Make this "if (v =3D=3D ULONG_MAX || v=3D=3D 0)" instead?
>>>> This would result in the same err on a new and an old hypervisor
>>>> (assuming we switch the hypervisor to init params with ~0UL).
>=20
> Sure, I can do that
>=20
>=20
>>>>> +			err =3D -ENOENT;
>>>>> +			goto out_error;
>>>>> +		}
>>>>> +		/*
>>>>> +		 * ULONG_MAX is invalid on 64-bit because is INVALID_PFN.
>>>>> +		 * On 32-bit return error to avoid truncation.
>>>>> +		 */
>>>>> +		if (v >=3D ULONG_MAX) {
>>>>> +			err =3D -EINVAL;
>>>>> +			goto out_error;
>>>>> +		}
>>>>
>>>> Does it make sense to continue the system running in case of
>>>> truncation? This would be a 32-bit guest with more than 16TB of RAM
>>>> and the Xen tools decided to place the Xenstore ring page above the
>>>> 16TB boundary. This is a completely insane scenario IMO.
>>>>
>>>> A proper panic() in this case would make diagnosis of that much
>>>> easier (me having doubts that this will ever be hit, though).
>>>
>>> While I agree panic() may be an option here (albeit I'm not sure why
>>> that would be better than trying to cope with 0 and hence without
>>
>> I could imagine someone wanting to run a guest without Xenstore access=
,
>> which BTW will happen in case of a guest created by the hypervisor at
>> boot time.
>>
>>> xenbus), I'd like to point out that the amount of RAM assigned to a
>>> guest is unrelated to the choice of GFNs for the various "magic"
>>> items.
>>
>> Yes, but this would still be a major tools problem which probably
>> would render the whole guest rather unusable.
>=20
> First let's distinguish between an error due to "hvm_param not
> initialized" and an error due to more serious conditions, such as "pfn
> above max".
>=20
> "hvm_param not initialized" could mean v =3D=3D 0 (as it would be today=
) or
> v =3D=3D ~0UL (if we change Xen to initialize all hvm_param to ~0UL). I=

> don't think we want to panic in these cases as they are not actually
> true erroneous configurations. We should just stop trying to initialize=

> xenstore and continue with the rest.
>=20
>=20
> The "pfn above max" case could happen if v is greater than the max pfn.=

> This is a true error in the configuration because the toolstack should
> know that the guest is 32-bit so it should give it a pfn that the guest=


I don't think so. All x86 PVH/HVM guests start booting in 32-bit mode.

> is able to use. As Jan wrote in another email, for 32-bit the actual
> limit depends on the physical address bits but actually Linux has never=

> been able to cope with a pfn > ULONG_MAX on 32-bit because xen_store_gf=
n
> is defined as unsigned long. So Linux 32-bit has been truncating
> HVM_PARAM_STORE_PFN all along.

The question is whether the number of physical address bits as presented
to the guest is always >=3D 44. If not the actual limit is less than
ULONG_MAX. Other than that you are right: a PFN larger than a 32-bit
ULONG_MAX will be truncated by a 32-bit guest.

> There is also an argument that depending on kconfig Linux 32-bit might
> only be able to handle addresses < 4G, so I don't think the toolstack
> can assume that a 32-bit guest is able to cope with HVM_PARAM_STORE_PFN=

>> ULONG_MAX.  If Linux is 32-bit and HVM_PARAM_STORE_PFN > ULONG_MAX,
> even if HVM_PARAM_STORE_PFN < address_bits_max I think it would be fair=

> to still consider it an error, but I can see it could be argued either
> way. Certainly if HVM_PARAM_STORE_PFN > address_bits_max is an error.

Right. The tools should NEVER put the frame above 4G for a non-PV guest.

> In any case, I think it is still better for Linux to stop trying to
> initialize Xenstore but continue with the rest because there is a bunch=

> of other useful things Linux can do without it. Panic should only be th=
e
> last resort if there is nothing else to do. In this case we haven't eve=
n
> initialized the service and the service is not essential, at least it i=
s
> not essential in certain ARM setups.
>=20
>=20
> So in conclusion, I think this patch should:
> - if v =3D=3D 0 return error (uninitialized)
> - if v =3D=3D ~0ULL (INVALID_PFN) return error (uinitialized)
> - if v >=3D ~0UL (32-bit) return error (even if this case could be made=
 to
>    work for v < max_address_bits depending on kconfig)
>=20
> Which leads to something like:
>=20
>          /* uninitialized */
> 		if (v =3D=3D 0 || v =3D=3D ~0ULL) {
> 			err =3D -ENOENT;
> 			goto out_error;
> 		}
>          /*
>           * Avoid truncation on 32-bit.
>           * TODO: handle addresses >=3D 4G
>           */
>          if ( v >=3D ~0UL ) {
>              err =3D -EINVAL;
>              goto out_error;

I think at least in this case a pr_err("...") should be added.

Silent failure is not nice.


Juergen

--------------1D5CADEDF14EBB1AB90E832F
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

--------------1D5CADEDF14EBB1AB90E832F--

--dq7zbyiopWgrKFF7IM4pZ8fIUMjtIo0st--

--k9FHfRXORn3u1wfdVDhanJ9xPhj52Izt9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGXMyQFAwAAAAAACgkQsN6d1ii/Ey/B
mgf8CeBF7aQ7MCZzknGdgTgOEM6ZT59iOsQaIj2gd/8mNjdLxmb57oAPWsXqP34QvpbdhWvQpWaP
P6HjSFA91VTAY+Tj1cTxcFQt5tb7t2ZCBMeuzfRCVitfEwGbGRWY2/Rn4LuRZayBVEiMxNa8cyDt
9I4nVLcN+2atND2UsnJ/qXM5CNlRELepxI8fm95/u4pC10Ih9ntaaHl5Ith2zlzmgA4GXi5qxqSp
Hm/+pohiLIl8T60rWW7W3GBC0K4MDj/26q2Zbd6WokVLOYtLofxjpaPnrS7o/w4VPIVSS5hrNyf6
SP5WV13CqMeHZqgEfRhq5tIcktJQv6au5XBAmlyvAw==
=fAIM
-----END PGP SIGNATURE-----

--k9FHfRXORn3u1wfdVDhanJ9xPhj52Izt9--
