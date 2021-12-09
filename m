Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A941F46EB1F
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 16:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbhLIPae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 10:30:34 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:57452 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbhLIPab (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 10:30:31 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8502E210FD;
        Thu,  9 Dec 2021 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639063616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NRvh7JJq/Uy7CdAC3cTY+jsARIcDnw1RIyhr2Us3gwY=;
        b=qrS3gq9nR0J6sd5ARS49QByBMupTCWaEZAxI8MVY9UL5GcVpzdiMaO7/jlt9gS8ja858S3
        py0QOp3Flx7A88dL41g63GeuHGHRLTONtEC1efw5duLfDNudBlv20cakKPtFMWy54O+FJD
        4ivEwnRfaa4EqISmnt4mqnBcQtU9k0k=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1272513343;
        Thu,  9 Dec 2021 15:26:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DhU3A0AgsmE9RAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 09 Dec 2021 15:26:56 +0000
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and early
 param parsing
To:     Borislav Petkov <bp@alien8.de>, John Dorminy <jdorminy@redhat.com>
Cc:     tip-bot2@linutronix.de, anjaneya.chagam@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com> <YbIeYIM6JEBgO3tG@zn.tnic>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
Date:   Thu, 9 Dec 2021 16:26:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YbIeYIM6JEBgO3tG@zn.tnic>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WNrzaBCogaAYTU4DxptjSOj3Qi8GmYzuY"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WNrzaBCogaAYTU4DxptjSOj3Qi8GmYzuY
Content-Type: multipart/mixed; boundary="6Nrj8K1mPOH1iCabd27obsWXM2CpjY0zW";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Borislav Petkov <bp@alien8.de>, John Dorminy <jdorminy@redhat.com>
Cc: tip-bot2@linutronix.de, anjaneya.chagam@intel.com,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-tip-commits@vger.kernel.org, stable@vger.kernel.org, x86@kernel.org,
 Hugh Dickins <hughd@google.com>, "Patrick J. Volkerding"
 <volkerdi@gmail.com>, Mike Rapoport <rppt@kernel.org>
Message-ID: <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and early
 param parsing
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com> <YbIeYIM6JEBgO3tG@zn.tnic>
In-Reply-To: <YbIeYIM6JEBgO3tG@zn.tnic>

--6Nrj8K1mPOH1iCabd27obsWXM2CpjY0zW
Content-Type: multipart/mixed;
 boundary="------------3BE92FB5CF8CA8511A69597D"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------3BE92FB5CF8CA8511A69597D
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 09.12.21 16:19, Borislav Petkov wrote:
> + Hugh and Patrick.
>=20
> On Thu, Dec 09, 2021 at 09:38:10AM -0500, John Dorminy wrote:
>> Greetings;
>>
>> It seems that this patch causes a mem=3D parameter to the kernel to ha=
ve no effect, unfortunately...
>>
>> As far as I understand, the x86 mem parameter handler parse_memopt() (=
called by parse_early_param()) relies on being called after e820__memory_=
setup(): it simply removes any memory above the specified limit at that m=
oment, allowing memory to later be hotplugged without regard for the init=
ial limit. However, the initial non-hotplugged memory must already have b=
een set up, in e820__memory_setup(), so that it can be removed in parse_m=
emopt(); if parse_early_param() is called before e820__memory_setup(), as=
 this change does, the parameter ends up having no effect.
>>
>> I apologize that I don't know how to fix this, but I'm happy to test p=
atches.
>=20
> Yeah, people have been reporting boot failures with mem=3D on the cmdli=
ne.
>=20
> I think I see why, can you try this one:

Sigh. This will break Xen PV. Again. The comment above the call of
early_reserve_memory() tells you why.

Juergen

>=20
> ---
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 6a190c7f4d71..6db971e61e4b 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -862,6 +862,8 @@ void __init setup_arch(char **cmdline_p)
>   	 */
>   	x86_configure_nx();
>  =20
> +	e820__memory_setup();
> +
>   	/*
>   	 * This parses early params and it needs to run before
>   	 * early_reserve_memory() because latter relies on such settings
> @@ -884,7 +886,6 @@ void __init setup_arch(char **cmdline_p)
>   	early_reserve_memory();
>  =20
>   	iomem_resource.end =3D (1ULL << boot_cpu_data.x86_phys_bits) - 1;
> -	e820__memory_setup();
>   	parse_setup_data();
>  =20
>   	copy_edd();
> ---
>=20
> Leaving in the rest for the newly added folks.
>=20
>> Typical dmesg output showing the lack of effect, built from the prior =
change and this change:
>>
>> With a git tree synced to 8d48bf8206f77aa8687f0e241e901e5197e52423^ (w=
orking):
>> [    0.000000] Command line: BOOT_IMAGE=3D(hd0,msdos1)/boot/vmlinuz-5.=
16.0-rc1 root=3DUUID=3Da4f7bd84-4f29-40bc-8c98-f4a72d0856c4 ro net.ifname=
s=3D0 crashkernel=3D128M mem=3D4G
>> ...
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] =
usable
>> [    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007dd3afff] =
usable
>> [    0.000000] BIOS-e820: [mem 0x000000007dd3b000-0x000000007deeffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x000000007def0000-0x000000007e0d3fff] =
ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x000000007e0d4000-0x000000007f367fff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x000000007f368000-0x000000007f7fffff] =
ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed3ffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] =
usable
>> [    0.000000] e820: remove [mem 0x100000000-0xfffffffffffffffe] usabl=
e
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] user-defined physical RAM map:
>> [    0.000000] user: [mem 0x0000000000000000-0x000000000009abff] usabl=
e
>> [    0.000000] user: [mem 0x000000000009ac00-0x000000000009ffff] reser=
ved
>> [    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reser=
ved
>> [    0.000000] user: [mem 0x0000000000100000-0x000000007dd3afff] usabl=
e
>> [    0.000000] user: [mem 0x000000007dd3b000-0x000000007deeffff] reser=
ved
>> [    0.000000] user: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI =
NVS
>> [    0.000000] user: [mem 0x000000007e0d4000-0x000000007f367fff] reser=
ved
>> [    0.000000] user: [mem 0x000000007f368000-0x000000007f7fffff] ACPI =
NVS
>> [    0.000000] user: [mem 0x0000000080000000-0x000000008fffffff] reser=
ved
>> [    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed3ffff] reser=
ved
>> [    0.000000] user: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
>> ...
>> [    0.025617] Memory: 1762876K/2061136K available (16394K kernel code=
, 3568K rwdata, 10324K rodata, 2676K init, 4924K bss, 298000K reserved, 0=
K cma-reserved)
>>
>> Synced 8d48bf8206f77aa8687f0e241e901e5197e52423 (not working):
>>
>> [    0.000000] Command line: BOOT_IMAGE=3D(hd0,msdos1)/boot/vmlinuz-5.=
16.0-rc4+ root=3DUUID=3D0e750e61-b92e-4708-a974-c50a3fb7e969 ro net.ifnam=
es=3D0 crashkernel=3D128M mem=3D4G
>> [    0.000000] e820: remove [mem 0x100000000-0xfffffffffffffffe] usabl=
e
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] =
usable
>> [    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007dd3afff] =
usable
>> [    0.000000] BIOS-e820: [mem 0x000000007dd3b000-0x000000007deeffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x000000007def0000-0x000000007e0d3fff] =
ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x000000007e0d4000-0x000000007f367fff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x000000007f368000-0x000000007f7fffff] =
ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed3ffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] =
reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] =
usable
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] user-defined physical RAM map:
>> [    0.000000] user: [mem 0x0000000000000000-0x000000000009abff] usabl=
e
>> [    0.000000] user: [mem 0x000000000009ac00-0x000000000009ffff] reser=
ved
>> [    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reser=
ved
>> [    0.000000] user: [mem 0x0000000000100000-0x000000007dd3afff] usabl=
e
>> [    0.000000] user: [mem 0x000000007dd3b000-0x000000007deeffff] reser=
ved
>> [    0.000000] user: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI =
NVS
>> [    0.000000] user: [mem 0x000000007e0d4000-0x000000007f367fff] reser=
ved
>> [    0.000000] user: [mem 0x000000007f368000-0x000000007f7fffff] ACPI =
NVS
>> [    0.000000] user: [mem 0x0000000080000000-0x000000008fffffff] reser=
ved
>> [    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed3ffff] reser=
ved
>> [    0.000000] user: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
>> [    0.000000] user: [mem 0x0000000100000000-0x000000207fffffff] usabl=
e
>> ...
>> [    0.695267] Memory: 131657608K/134181712K available (16394K kernel =
code, 3568K rwdata, 10328K rodata, 2676K init, 4924K bss, 2523844K reserv=
ed, 0K cma-reserved)
>>
>=20


--------------3BE92FB5CF8CA8511A69597D
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

--------------3BE92FB5CF8CA8511A69597D--

--6Nrj8K1mPOH1iCabd27obsWXM2CpjY0zW--

--WNrzaBCogaAYTU4DxptjSOj3Qi8GmYzuY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmGyID8FAwAAAAAACgkQsN6d1ii/Ey+y
Ogf/bfbkq8Eo2ocQ/OqlwblOCCMYGOc1VIQMmmTVtBQdLrzTCE8tBHlFUKicyP1Ru0DqAdOZYUAv
DRQG1h7cKU8p/aOEh+PoOhpKOC8SiwvtqsWZ/sK72eja7/aVCj3jj/DS31ewE+ItiBd3yuOOO2Dv
qZIsw98nbecOxqu8m2EXtTVFfT8lxOE3x7MNN6VkrI3HnxNWbxkHleZiOu3MPbfEGuk4Nor97ZG5
6fAiLQr57JDHj1pgQcr8vBlfOSoDsCOqG2CuuyrEsF/Xw1S9khvtlRume4E5naasW5m/8oWlLaDC
UTmoWcu9L7DlG5ZrTs6oV7dEuBdkGKF8VHVh+Tjhvw==
=vvir
-----END PGP SIGNATURE-----

--WNrzaBCogaAYTU4DxptjSOj3Qi8GmYzuY--
