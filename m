Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80B15B9DD1
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 16:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiIOOz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 10:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIOOzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 10:55:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA5E8003D;
        Thu, 15 Sep 2022 07:55:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 456F01F8D4;
        Thu, 15 Sep 2022 14:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663253753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Up584H0P24z3r3gFq4EXpD2t/lW/iWfr0mZFDdcmhXw=;
        b=BIFkM/hGv7VK2WLEAZHdqcYlEqZ+Eyiir8loQuZ+t5qFCrF3oP/WK5y9zaSUmuUgp2Sxw0
        hBnrUpOfbkkWVl3WrmeCu06qSM4jf/g+nfB5YzpU96SOf1FiuAy3tTW8N+mLKbsgcOikdk
        YzQY44yYWMugyAemhGzoKdYkgem4FLI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 06CDC133B6;
        Thu, 15 Sep 2022 14:55:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id s3gpO/g8I2MnBgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 15 Sep 2022 14:55:52 +0000
Message-ID: <643ef313-b9a8-e6ab-4dcb-43919f4d7af6@suse.com>
Date:   Thu, 15 Sep 2022 16:55:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] xen/xenbus: fix xenbus_setup_ring()
Content-Language: en-US
To:     Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>
References: <20220915143137.1763-1-jgross@suse.com>
 <34c9a80d-3a9d-cd51-32d2-cf778c981107@epam.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <34c9a80d-3a9d-cd51-32d2-cf778c981107@epam.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wFpgqiE47FhWtDq0JbwO0ovi"
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wFpgqiE47FhWtDq0JbwO0ovi
Content-Type: multipart/mixed; boundary="------------crtVEa6kfQw0NU0tyzTzdGi9";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <643ef313-b9a8-e6ab-4dcb-43919f4d7af6@suse.com>
Subject: Re: [PATCH] xen/xenbus: fix xenbus_setup_ring()
References: <20220915143137.1763-1-jgross@suse.com>
 <34c9a80d-3a9d-cd51-32d2-cf778c981107@epam.com>
In-Reply-To: <34c9a80d-3a9d-cd51-32d2-cf778c981107@epam.com>

--------------crtVEa6kfQw0NU0tyzTzdGi9
Content-Type: multipart/mixed; boundary="------------IS3EwCOGghcUGT2zkq73JJEK"

--------------IS3EwCOGghcUGT2zkq73JJEK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTUuMDkuMjIgMTY6NDcsIE9sZWtzYW5kciBUeXNoY2hlbmtvIHdyb3RlOg0KPiANCj4g
T24gMTUuMDkuMjIgMTc6MzEsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+IA0KPiBIZWxsbyBK
dWVyZ2VuDQo+IA0KPj4gQ29tbWl0IDQ1NzMyNDBmMDc2NCAoInhlbi94ZW5idXM6IGVsaW1p
bmF0ZSB4ZW5idXNfZ3JhbnRfcmluZygpIikNCj4+IGludHJvZHVjZWQgYW4gZXJyb3IgZm9y
IGluaXRpYWxpemF0aW9uIG9mIG11bHRpLXBhZ2UgcmluZ3MuDQo+Pg0KPj4gQ2M6IHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcNCj4+IEZpeGVzOiA0NTczMjQwZjA3NjQgKCJ4ZW4veGVuYnVz
OiBlbGltaW5hdGUgeGVuYnVzX2dyYW50X3JpbmcoKSIpDQo+PiBSZXBvcnRlZC1ieTogU2Fu
ZGVyIEVpa2VsZW5ib29tIDxsaW51eEBlaWtlbGVuYm9vbS5pdD4NCj4+IFNpZ25lZC1vZmYt
Ynk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4+IC0tLQ0KPj4gICAgZHJp
dmVycy94ZW4veGVuYnVzL3hlbmJ1c19jbGllbnQuYyB8IDkgKysrKysrLS0tDQo+PiAgICAx
IGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4NCj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi94ZW5idXMveGVuYnVzX2NsaWVudC5jIGIvZHJp
dmVycy94ZW4veGVuYnVzL3hlbmJ1c19jbGllbnQuYw0KPj4gaW5kZXggZDVmM2Y3NjM3MTdl
Li5jYWE1YzVjMzJmOGUgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3hlbi94ZW5idXMveGVu
YnVzX2NsaWVudC5jDQo+PiArKysgYi9kcml2ZXJzL3hlbi94ZW5idXMveGVuYnVzX2NsaWVu
dC5jDQo+PiBAQCAtMzgyLDkgKzM4MiwxMCBAQCBpbnQgeGVuYnVzX3NldHVwX3Jpbmcoc3Ry
dWN0IHhlbmJ1c19kZXZpY2UgKmRldiwgZ2ZwX3QgZ2ZwLCB2b2lkICoqdmFkZHIsDQo+PiAg
ICAJdW5zaWduZWQgbG9uZyByaW5nX3NpemUgPSBucl9wYWdlcyAqIFhFTl9QQUdFX1NJWkU7
DQo+PiAgICAJZ3JhbnRfcmVmX3QgZ3JlZl9oZWFkOw0KPj4gICAgCXVuc2lnbmVkIGludCBp
Ow0KPj4gKwl2b2lkICphZGRyOw0KPj4gICAgCWludCByZXQ7DQo+PiAgICANCj4+IC0JKnZh
ZGRyID0gYWxsb2NfcGFnZXNfZXhhY3QocmluZ19zaXplLCBnZnAgfCBfX0dGUF9aRVJPKTsN
Cj4+ICsJYWRkciA9ICp2YWRkciA9IGFsbG9jX3BhZ2VzX2V4YWN0KHJpbmdfc2l6ZSwgZ2Zw
IHwgX19HRlBfWkVSTyk7DQo+PiAgICAJaWYgKCEqdmFkZHIpIHsNCj4+ICAgIAkJcmV0ID0g
LUVOT01FTTsNCj4+ICAgIAkJZ290byBlcnI7DQo+PiBAQCAtNDAxLDEzICs0MDIsMTUgQEAg
aW50IHhlbmJ1c19zZXR1cF9yaW5nKHN0cnVjdCB4ZW5idXNfZGV2aWNlICpkZXYsIGdmcF90
IGdmcCwgdm9pZCAqKnZhZGRyLA0KPj4gICAgCQl1bnNpZ25lZCBsb25nIGdmbjsNCj4+ICAg
IA0KPj4gICAgCQlpZiAoaXNfdm1hbGxvY19hZGRyKCp2YWRkcikpDQo+PiAtCQkJZ2ZuID0g
cGZuX3RvX2dmbih2bWFsbG9jX3RvX3Bmbih2YWRkcltpXSkpOw0KPj4gKwkJCWdmbiA9IHBm
bl90b19nZm4odm1hbGxvY190b19wZm4oYWRkcikpOw0KPj4gICAgCQllbHNlDQo+PiAtCQkJ
Z2ZuID0gdmlydF90b19nZm4odmFkZHJbaV0pOw0KPj4gKwkJCWdmbiA9IHZpcnRfdG9fZ2Zu
KGFkZHIpOw0KPj4gICAgDQo+PiAgICAJCWdyZWZzW2ldID0gZ250dGFiX2NsYWltX2dyYW50
X3JlZmVyZW5jZSgmZ3JlZl9oZWFkKTsNCj4+ICAgIAkJZ250dGFiX2dyYW50X2ZvcmVpZ25f
YWNjZXNzX3JlZihncmVmc1tpXSwgZGV2LT5vdGhlcmVuZF9pZCwNCj4+ICAgIAkJCQkJCWdm
biwgMCk7DQo+PiArDQo+PiArCQlhZGRyICs9IFBBR0VfU0laRTsNCj4gDQo+IFhFTl9QQUdF
X1NJWkU/DQoNCk9oLCBpbmRlZWQhIFdpbGwgY2hhbmdlIG9uIGNvbW1pdC4NCg0KPiANCj4g
DQo+IFJldmlld2VkLWJ5OiBPbGVrc2FuZHIgVHlzaGNoZW5rbyA8b2xla3NhbmRyX3R5c2hj
aGVua29AZXBhbS5jb20+DQoNClRoYW5rcywNCg0KDQpKdWVyZ2VuDQo=
--------------IS3EwCOGghcUGT2zkq73JJEK
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------IS3EwCOGghcUGT2zkq73JJEK--

--------------crtVEa6kfQw0NU0tyzTzdGi9--

--------------wFpgqiE47FhWtDq0JbwO0ovi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMjPPgFAwAAAAAACgkQsN6d1ii/Ey9N
XAf/bpqthZlSl1ixQKVVr9dS8fNG2tPVotRcLlJFDxlqzhiVrOdrcyL7dzDcyMRgMOJPzuz9CJYV
yGfwD3XPNLLJ1qNdn7lY57i6bj1ZrcjwzqHbU69jXqbUUzHGpiTC0ivSLiByoNNGQp1KJ8Ld4hSX
MDlOFL5H40DvovwXvdOIp8wAJosY4Xj6oxixVKP3B2nK2PehZ0/RUvWRj3eZB0D36HUXgMxfM4r4
+WtS6ZI0bEBh/70CGKBY6X8XH2et07lxa5HA3nbSrxMxpFaZAbdKgop61Xi7htlrUGHp6Dj3Oktz
rHryOTk3wojNRZ9ECsEF3Tvfw8N7bsX/b5f686okaQ==
=RHQ7
-----END PGP SIGNATURE-----

--------------wFpgqiE47FhWtDq0JbwO0ovi--
