Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A164C38A
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 06:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbiLNFgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 00:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLNFgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 00:36:48 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C821582A
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 21:36:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1C23321ECF;
        Wed, 14 Dec 2022 05:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670996205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gWJWW6zyO0IutPpmlfjW68VUbNs+Vyq8rs/tvdtVWc8=;
        b=pEGI68gx83dciQMv1TO/T+kRGkHdJaYLvmP8crbWHjH+zBBeOZ3kq8jW6gkCGM+cbfh7mN
        gViBjaA1baMfgCVJdhPYfzvmVUki7vHB2KlT8CXezpOJVbX17ZIFrNraVjB5pVX0n92lmL
        ZaJIVSOZzSU6wGiCCLo/4QUeQY5+siY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EFE3B13456;
        Wed, 14 Dec 2022 05:36:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id m0IfOexgmWPFDwAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 14 Dec 2022 05:36:44 +0000
Message-ID: <4c546f93-3321-44b0-9cea-6e0bdbeaab4a@suse.com>
Date:   Wed, 14 Dec 2022 06:36:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 0/1] Request to cherry-pick 74e7e1efdad4 to 5.15.y
Content-Language: en-US
To:     Meena Shanmugam <meenashanmugam@google.com>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
References: <20221213215339.3697182-1-meenashanmugam@google.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20221213215339.3697182-1-meenashanmugam@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------9giihdVUJ03L7mgaIFwblGlM"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------9giihdVUJ03L7mgaIFwblGlM
Content-Type: multipart/mixed; boundary="------------Gd74DpLE3juDm2L3sVK0x1Fo";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Meena Shanmugam <meenashanmugam@google.com>, stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Message-ID: <4c546f93-3321-44b0-9cea-6e0bdbeaab4a@suse.com>
Subject: Re: [PATCH 5.15 0/1] Request to cherry-pick 74e7e1efdad4 to 5.15.y
References: <20221213215339.3697182-1-meenashanmugam@google.com>
In-Reply-To: <20221213215339.3697182-1-meenashanmugam@google.com>

--------------Gd74DpLE3juDm2L3sVK0x1Fo
Content-Type: multipart/mixed; boundary="------------XI73dck6CVhTCR9Cq9CEEKzx"

--------------XI73dck6CVhTCR9Cq9CEEKzx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTMuMTIuMjIgMjI6NTMsIE1lZW5hIFNoYW5tdWdhbSB3cm90ZToNCj4gVGhlIGNvbW1p
dCA3NGU3ZTFlZmRhZDQgKHhlbi9uZXRiYWNrOiBkb24ndCBjYWxsIGtmcmVlX3NrYigpIHdp
dGgNCj4gaW50ZXJydXB0cyBkaXNhYmxlZCkgZml4ZXMgZGVhZGxvY2sgaW4gTGludXggbmV0
YmFjayBkcml2ZXIuIFRoaXMgc2VlbXMNCj4gdG8gYmUgYSBnb29kIGNhbmRpZGF0ZSBmb3Ig
dGhlIHN0YWJsZSB0cmVlcy4gVGhpcyBwYXRjaCBkaWRuJ3QgYXBwbHkNCj4gY2xlYW5seSBp
biA1LjE1IGtlcm5lbCBkdWUgdG8gZGlmZmVyZW5jZSBpbiBmdW5jdGlvbiBwcm90b3R5cGVz
IGluDQo+IGRyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL2NvbW1vbi5oLg0KPiANCj4gSnVlcmdl
biBHcm9zcyAoMSk6DQo+ICAgIHhlbi9uZXRiYWNrOiBkb24ndCBjYWxsIGtmcmVlX3NrYigp
IHdpdGggaW50ZXJydXB0cyBkaXNhYmxlZA0KPiANCj4gICBkcml2ZXJzL25ldC94ZW4tbmV0
YmFjay9jb21tb24uaCAgICB8IDIgKy0NCj4gICBkcml2ZXJzL25ldC94ZW4tbmV0YmFjay9p
bnRlcmZhY2UuYyB8IDYgKysrKy0tDQo+ICAgZHJpdmVycy9uZXQveGVuLW5ldGJhY2svcngu
YyAgICAgICAgfCA4ICsrKysrLS0tDQo+ICAgMyBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRp
b25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCg0KSXQgaGFzIGFscmVhZHkgYmVlbiBwaWNr
ZWQuDQoNCg0KSnVlcmdlbg0K
--------------XI73dck6CVhTCR9Cq9CEEKzx
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjri
oyspZKOBycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2
kaV2KL9650I1SJvedYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i
1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/B
BLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xqG7/377qptDmrk42GlSK
N4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR3Jvc3Mg
PGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsE
FgIDAQIeAQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4F
UGNQH2lvWAUy+dnyThpwdtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3Tye
vpB0CA3dbBQp0OW0fgCetToGIQrg0MbD1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u
+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbvoPHZ8SlM4KWm8rG+lIkGurq
qu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v5QL+qHI3EIP
tyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVy
Z2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJ
CAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4
RF7HoZhPVPogNVbC4YA6lW7DrWf0teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz7
8X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC/nuAFVGy+67q2DH8As3KPu0344T
BDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0LhITTd9jLzdDad1pQ
SToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLmXBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkM
nQfvUewRz80hSnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMB
AgAjBQJTjHDXAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/
Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJnFOXgMLdBQgBlVPO3/D9R8LtF9DBAFPN
hlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1jnDkfJZr6jrbjgyoZHi
w/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0N51N5Jf
VRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwP
OoE+lotufe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK
/1xMI3/+8jbO0tsn1tqSEUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuZGU+wsB5BBMBAgAjBQJTjHDrAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgEC
F4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3g3OZUEBmDHVVbqMtzwlmNC4
k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5dM7wRqzgJpJ
wK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu
5D+jLRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzB
TNh30FVKK1EvmV2xAKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37Io
N1EblHI//x/e2AaIHpzK5h88NEawQsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6
AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpWnHIs98ndPUDpnoxWQugJ6MpMncr
0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZRwgnBC5mVM6JjQ5x
Dk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNVbVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mm
we0icXKLkpEdIXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0I
v3OOImwTEe4co3c1mwARAQABwsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMv
Q/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEwTbe8YFsw2V/Buv6Z4Mysln3nQK5ZadD
534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1vJzQ1fOU8lYFpZXTXIH
b+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8VGiwXvT
yJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqc
suylWsviuGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5B
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------XI73dck6CVhTCR9Cq9CEEKzx--

--------------Gd74DpLE3juDm2L3sVK0x1Fo--

--------------9giihdVUJ03L7mgaIFwblGlM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmOZYOwFAwAAAAAACgkQsN6d1ii/Ey9+
QQgAiqHUfF0UCEua8ssyistwOjkxAX55i6fpca2Ix+3mZGOadBgv5lqqIADW4bL5zQHQoNMKhdsr
NFEjzVO3IFWgyWSDgZ0VnuPsFeiy95JqfyFLRDl3DvIDuH1V4KPanBCBvbqaDrmrLHybsEd91KUe
RzYdTy5lI5YeRzdT+jMZLAwTj1TeHUuH9mRfWTDbyCnn73gJMPGfQG+0XjRBXf8Ug38o97JQT/Mn
Pdvmm7QvmBRn5i5A/0TR8Q7zt86zdJsvsh6tdulImDrp+i+JbSgnqwzbsNkcuH4CyLOdiOJM6wvG
91GtsuFyLmPyLUggZIp76u1TtnIVh0mXPaqAKFip8g==
=gPzH
-----END PGP SIGNATURE-----

--------------9giihdVUJ03L7mgaIFwblGlM--
