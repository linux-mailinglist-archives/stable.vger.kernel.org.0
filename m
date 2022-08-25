Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4D5A1004
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 14:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239454AbiHYMK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 08:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241299AbiHYMK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 08:10:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E80A61EC;
        Thu, 25 Aug 2022 05:10:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6044B3480C;
        Thu, 25 Aug 2022 12:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661429453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gjck09GQI4/RaYuhjuwwBeaI4hqXSu+XeL5m6dAYpFc=;
        b=WpUb363DxrBIRbbQT601taWKmO/0CR8uuaQFr1SARlGEvo2QFZQIulAYIvUrN1NDnUcIWh
        a1HTGjqIRhDvu9ek3OYG1wPqY4JC2S62uSDGxyz2ziYDVuPsdKlfY3XRIbp1JXoNcpxogD
        ZDqSzubKMdkSDBt4rD/lAm1GXzJdnVc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2619213A8E;
        Thu, 25 Aug 2022 12:10:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0L3jB81mB2MWDgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 25 Aug 2022 12:10:53 +0000
Message-ID: <6aa83215-49fe-56c7-1a77-0a63a663c99f@suse.com>
Date:   Thu, 25 Aug 2022 14:10:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220825114004.24843-1-jgross@suse.com>
 <744be7c4-8e00-7876-5819-a1d07d3d423f@suse.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <744be7c4-8e00-7876-5819-a1d07d3d423f@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------iSKAdZWHzUA9FdVfw77QHvqS"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------iSKAdZWHzUA9FdVfw77QHvqS
Content-Type: multipart/mixed; boundary="------------ovfRKwRSMlhgiL0jip1tzA2l";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 stable@vger.kernel.org, Rustam Subkhankulov <subkhankulov@ispras.ru>,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Message-ID: <6aa83215-49fe-56c7-1a77-0a63a663c99f@suse.com>
Subject: Re: [PATCH v3] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
References: <20220825114004.24843-1-jgross@suse.com>
 <744be7c4-8e00-7876-5819-a1d07d3d423f@suse.com>
In-Reply-To: <744be7c4-8e00-7876-5819-a1d07d3d423f@suse.com>

--------------ovfRKwRSMlhgiL0jip1tzA2l
Content-Type: multipart/mixed; boundary="------------8f0RsFBjRSls6W1rX9O9Ak31"

--------------8f0RsFBjRSls6W1rX9O9Ak31
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUuMDguMjIgMTM6NTgsIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAyNS4wOC4yMDIy
IDEzOjQwLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gLS0tIGEvZHJpdmVycy94ZW4vcHJp
dmNtZC5jDQo+PiArKysgYi9kcml2ZXJzL3hlbi9wcml2Y21kLmMNCj4+IEBAIC01ODEsNyAr
NTgxLDcgQEAgc3RhdGljIGludCBsb2NrX3BhZ2VzKA0KPj4gICAJc3RydWN0IHByaXZjbWRf
ZG1fb3BfYnVmIGtidWZzW10sIHVuc2lnbmVkIGludCBudW0sDQo+PiAgIAlzdHJ1Y3QgcGFn
ZSAqcGFnZXNbXSwgdW5zaWduZWQgaW50IG5yX3BhZ2VzLCB1bnNpZ25lZCBpbnQgKnBpbm5l
ZCkNCj4+ICAgew0KPj4gLQl1bnNpZ25lZCBpbnQgaTsNCj4+ICsJdW5zaWduZWQgaW50IGks
IG9mZiA9IDA7DQo+PiAgIA0KPj4gICAJZm9yIChpID0gMDsgaSA8IG51bTsgaSsrKSB7DQo+
PiAgIAkJdW5zaWduZWQgaW50IHJlcXVlc3RlZDsNCj4+IEBAIC01ODksMTkgKzU4OSwyMyBA
QCBzdGF0aWMgaW50IGxvY2tfcGFnZXMoDQo+PiAgIA0KPj4gICAJCXJlcXVlc3RlZCA9IERJ
Vl9ST1VORF9VUCgNCj4+ICAgCQkJb2Zmc2V0X2luX3BhZ2Uoa2J1ZnNbaV0udXB0cikgKyBr
YnVmc1tpXS5zaXplLA0KPj4gLQkJCVBBR0VfU0laRSk7DQo+PiArCQkJUEFHRV9TSVpFKSAt
IG9mZjsNCj4+ICAgCQlpZiAocmVxdWVzdGVkID4gbnJfcGFnZXMpDQo+PiAgIAkJCXJldHVy
biAtRU5PU1BDOw0KPj4gICANCj4+ICAgCQlwYWdlX2NvdW50ID0gcGluX3VzZXJfcGFnZXNf
ZmFzdCgNCj4+IC0JCQkodW5zaWduZWQgbG9uZykga2J1ZnNbaV0udXB0ciwNCj4+ICsJCQko
dW5zaWduZWQgbG9uZylrYnVmc1tpXS51cHRyICsgb2ZmICogUEFHRV9TSVpFLA0KPj4gICAJ
CQlyZXF1ZXN0ZWQsIEZPTExfV1JJVEUsIHBhZ2VzKTsNCj4+IC0JCWlmIChwYWdlX2NvdW50
IDwgMCkNCj4+IC0JCQlyZXR1cm4gcGFnZV9jb3VudDsNCj4+ICsJCWlmIChwYWdlX2NvdW50
IDw9IDApDQo+PiArCQkJcmV0dXJuIHBhZ2VfY291bnQgPyA6IC1FRkFVTFQ7DQo+PiAgIA0K
Pj4gICAJCSpwaW5uZWQgKz0gcGFnZV9jb3VudDsNCj4+ICAgCQlucl9wYWdlcyAtPSBwYWdl
X2NvdW50Ow0KPj4gICAJCXBhZ2VzICs9IHBhZ2VfY291bnQ7DQo+PiArDQo+PiArCQlvZmYg
PSByZXF1ZXN0ZWQgLSBwYWdlX2NvdW50Ow0KPj4gKwkJaWYgKG9mZikNCj4+ICsJCQlpLS07
DQo+PiAgIAl9DQo+IA0KPiBJbml0aWFsbHkgSSB0aG91Z2h0IHRoaXMgd291bGQgZ28gd3Jv
bmcgb25seSBvbiB0aGUgM3JkIGl0ZXJhdGlvbiwgYnV0DQo+IG1lYW53aGlsZSBJIHRoaW5r
IGl0J3Mgd3JvbmcgYWxyZWFkeSBvbiB0aGUgMm5kLiBXaGF0IEkgdGhpbmsgeW91IG5lZWQN
Cj4gaXMNCj4gDQo+IAkJaWYgKHBhZ2VfY291bnQgPCByZXF1ZXN0ZWQpDQo+IAkJCWktLTsN
Cj4gCQlvZmYgKz0gcGFnZV9jb3VudDsNCj4gDQo+IG9yIHdpdGggdGhlIGkrKyBmcm9tIHRo
ZSBsb29wIGhlYWRlciBhYnNvcmJlZCBoZXJlDQo+IA0KPiAJCWlmIChwYWdlX2NvdW50ID09
IHJlcXVlc3RlZCkNCj4gCQkJaSsrOw0KPiAJCW9mZiArPSBwYWdlX2NvdW50Ow0KPiANCj4g
UGx1cyBvZiBjb3Vyc2Ugb2ZmIG5lZWRzIHJlc2V0dGluZyB0byB6ZXJvIHdoZW5ldmVyIGkg
YWR2YW5jZXMuIEkuZS4NCj4gDQo+IAkJaWYgKHBhZ2VfY291bnQgPT0gcmVxdWVzdGVkKSB7
DQo+IAkJCWkrKzsNCj4gCQkJb2ZmID0gMDsNCj4gCQl9IGVsc2Ugew0KPiAJCQlvZmYgKz0g
cGFnZV9jb3VudDsNCj4gCQl9DQoNClllYWgsIG9yOg0KDQoJCW9mZiA9IChwYWdlX2NvdW50
ID09IHJlcXVlc3RlZCkgPyAwIDogb2ZmICsgcGFnZV9jb3VudDsNCgkJaSArPSAhb2ZmOw0K
DQoNCkp1ZXJnZW4NCg==
--------------8f0RsFBjRSls6W1rX9O9Ak31
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

--------------8f0RsFBjRSls6W1rX9O9Ak31--

--------------ovfRKwRSMlhgiL0jip1tzA2l--

--------------iSKAdZWHzUA9FdVfw77QHvqS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMHZswFAwAAAAAACgkQsN6d1ii/Ey+K
Jwf+K7DBL4ZFeDZlNrJb+wJtI7ThM4gfEYFahdARD65OSY4stNqUn+zsmOFbypGBoy+4F1BL81mv
rvGlZSBKPrOLil9IBD2Bdf7a1XWQ5yKn/D9X0qjdrC8L7pT6eY+mQeotJ6vz8XiER0QGP7aIrerP
aZlUEi9EvLlVt688oHQtBGQ+XH6tgj9UVyO3NY+GpupZrM0DJ3gGKYmaWEEk77xQ4x2shuV5c/j2
23msZUJXr6w52hTXtRMUzBUKEir5oz7/H5yIsx/SLWOrSRuEKDb9YRusoCyqQUUbdLMRvEHslcz4
brUPmfRMe/JGtCD0lOGdMhbEfJgDTSIuhzAad2OYsQ==
=Wmmb
-----END PGP SIGNATURE-----

--------------iSKAdZWHzUA9FdVfw77QHvqS--
