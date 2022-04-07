Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED50A4F7DCD
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 13:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiDGLT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 07:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244739AbiDGLTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 07:19:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3E0186EE;
        Thu,  7 Apr 2022 04:17:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 533AF1F85A;
        Thu,  7 Apr 2022 11:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649330240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dDQfiRLPVufvuVPTY+UISB3k5/4wdwlCC/3nm8qjtgk=;
        b=PRC6lKgDiL1NRZkKcmcZuYOdO1EGXE33ge2qnp2I6aWxhzhrHKmUqqwvuMEck4mxhxLjOE
        iKDrz1r1YxoUlCv+EitCl+h5BpSRLKQ+uz1vIIckZit4bm6jKC+8fzIjWLmDC2UhXrN7PH
        XCTrO2rBAKLxrizqg+mJdITG7aDpBn8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1355313A66;
        Thu,  7 Apr 2022 11:17:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XolAA0DITmJEaAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 07 Apr 2022 11:17:20 +0000
Message-ID: <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
Date:   Thu, 7 Apr 2022 13:17:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, Mel Gorman <mgorman@suse.de>
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
 <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
In-Reply-To: <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------nskH6gXR0GLd03pWvxgkqJK0"
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------nskH6gXR0GLd03pWvxgkqJK0
Content-Type: multipart/mixed; boundary="------------qUBVfqv5H5ox4HKrWPGghlVf";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Michal Hocko <mhocko@suse.com>
Cc: xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 stable@vger.kernel.org,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, Mel Gorman <mgorman@suse.de>
Message-ID: <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
 <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
In-Reply-To: <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>

--------------qUBVfqv5H5ox4HKrWPGghlVf
Content-Type: multipart/mixed; boundary="------------0Ft6bscHGfCDkhcPpHvpVFr1"

--------------0Ft6bscHGfCDkhcPpHvpVFr1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMDQuMjIgMTM6MDcsIE1pY2hhbCBIb2NrbyB3cm90ZToNCj4gT24gVGh1IDA3LTA0
LTIyIDEyOjQ1OjQxLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gT24gMDcuMDQuMjIgMTI6
MzQsIE1pY2hhbCBIb2NrbyB3cm90ZToNCj4+PiBDY2luZyBNZWwNCj4+Pg0KPj4+IE9uIFRo
dSAwNy0wNC0yMiAxMTozMjoyMSwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4+Pj4gU2luY2Ug
Y29tbWl0IDlkM2JlMjFiZjljMCAoIm1tLCBwYWdlX2FsbG9jOiBzaW1wbGlmeSB6b25lbGlz
dA0KPj4+PiBpbml0aWFsaXphdGlvbiIpIG9ubHkgem9uZXMgd2l0aCBmcmVlIG1lbW9yeSBh
cmUgaW5jbHVkZWQgaW4gYSBidWlsdA0KPj4+PiB6b25lbGlzdC4gVGhpcyBpcyBwcm9ibGVt
YXRpYyB3aGVuIGUuZy4gYWxsIG1lbW9yeSBvZiBhIHpvbmUgaGFzIGJlZW4NCj4+Pj4gYmFs
bG9vbmVkIG91dC4NCj4+Pg0KPj4+IFdoYXQgaXMgdGhlIGFjdHVhbCBwcm9ibGVtIHRoZXJl
Pw0KPj4NCj4+IFdoZW4gcnVubmluZyBhcyBYZW4gZ3Vlc3QgbmV3IGhvdHBsdWdnZWQgbWVt
b3J5IHdpbGwgbm90IGJlIG9ubGluZWQNCj4+IGF1dG9tYXRpY2FsbHksIGJ1dCBvbmx5IG9u
IHNwZWNpYWwgcmVxdWVzdC4gVGhpcyBpcyBkb25lIGluIG9yZGVyIHRvDQo+PiBzdXBwb3J0
IGFkZGluZyBlLmcuIHRoZSBwb3NzaWJpbGl0eSB0byB1c2UgYW5vdGhlciBHQiBvZiBtZW1v
cnksIHdoaWxlDQo+PiBhZGRpbmcgb25seSBhIHBhcnQgb2YgdGhhdCBtZW1vcnkgaW5pdGlh
bGx5Lg0KPj4NCj4+IEluIGNhc2UgYWRkaW5nIHRoYXQgbWVtb3J5IGlzIHBvcHVsYXRpbmcg
YSBuZXcgem9uZSwgdGhlIHBhZ2UgYWxsb2NhdG9yDQo+PiB3b24ndCBiZSBhYmxlIHRvIHVz
ZSB0aGlzIG1lbW9yeSB3aGVuIGl0IGlzIG9ubGluZWQsIGFzIHRoZSB6b25lIHdhc24ndA0K
Pj4gYWRkZWQgdG8gdGhlIHpvbmVsaXN0LCBkdWUgdG8gbWFuYWdlZF96b25lKCkgcmV0dXJu
aW5nIDAuDQo+IA0KPiBIb3cgaXMgdGhhdCBtZW1vcnkgb25saW5lZD8gQmVjYXVzZSAicmVn
dWxhciIgb25saW5pbmcgKG9ubGluZV9wYWdlcygpKQ0KPiBkb2VzIHJlYnVpbGQgem9uZWxp
c3RzIGlmIHRoZWlyIHpvbmUgaGFzbid0IGJlZW4gcG9wdWxhdGVkIGJlZm9yZS4NCg0KVGhl
IFhlbiBiYWxsb29uIGRyaXZlciBoYXMgYW4gb3duIGNhbGxiYWNrIGZvciBvbmxpbmluZyBw
YWdlcy4gVGhlIHBhZ2VzDQphcmUganVzdCBhZGRlZCB0byB0aGUgYmFsbG9vbmVkLW91dCBw
YWdlIGxpc3Qgd2l0aG91dCBoYW5kaW5nIHRoZW0gdG8gdGhlDQphbGxvY2F0b3IuIFRoaXMg
aXMgZG9uZSBvbmx5IHdoZW4gdGhlIGd1ZXN0IGlzIGJhbGxvb25lZCB1cC4NCg0KU28gdGhl
IHByb2JsZW0gaXMgdGhhdCBhIG5ldyB6b25lIGlzIGJlaW5nIHBvcHVsYXRlZCwgYnV0IGl0
IHdvbid0IGhhdmUNCmZyZWUgcGFnZXMgd2hlbiB0aGUgem9uZWxpc3RzIGFyZSByZWJ1aWx0
Lg0KDQoNCkp1ZXJnZW4NCg0K
--------------0Ft6bscHGfCDkhcPpHvpVFr1
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

--------------0Ft6bscHGfCDkhcPpHvpVFr1--

--------------qUBVfqv5H5ox4HKrWPGghlVf--

--------------nskH6gXR0GLd03pWvxgkqJK0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmJOyD8FAwAAAAAACgkQsN6d1ii/Ey/g
+Af/RaYeBV8VeGsuNXwt+3+abYnZw1S6fHU0/1SAUHlwvSU6ZjAUZva6kquKTk1nER67MDIbJFYk
DtwPu0ga+1z9j3MOajigjUJf2J+Zd24fQFMnQpjUn+ghR93kcgG/R06/ZsY7c4S03Xzr2KJ/bhFM
hiDDo9yCUkNZDvdYvGiy1D6zc8xOayskvmCnqeY2XHKXSmrvERBr67MFs5My6xBGNL1DcTz7zwRW
/OvTjuMzCzCX1sYdiI6WLg0ij1kn8MuyCstIshfU7VaE1shf7blsOlHiBRLsMcDsKH9YzYZI+TG+
56sSCuHViR+r08oUxiduznDOnhgLkPwXj3Th/TgZQQ==
=ods5
-----END PGP SIGNATURE-----

--------------nskH6gXR0GLd03pWvxgkqJK0--
