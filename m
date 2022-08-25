Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D70E5A0B0C
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 10:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239333AbiHYIH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 04:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239267AbiHYIHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 04:07:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248729F748;
        Thu, 25 Aug 2022 01:07:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B0133337D2;
        Thu, 25 Aug 2022 08:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661414867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VSnJsW614eoN98hwUcGZAIUy0ZpD071hooa/76ULZt8=;
        b=r8i1qdeeaSAmHmUcueXLXw+qALbH0UYbew0hSHlqMd0V8yfjVydX4FjPnh32JCI5pZuXpB
        S4CYREAPO3G1MP1MFKxX5fAy8k6b6GAQ/am3JEg2Rl+K1aAJOn+vr+9KBOCqdcmudZ4ad+
        05VQBeWa/9h5YuDjEJGEsK0EHZUbcVg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6AA3413A8E;
        Thu, 25 Aug 2022 08:07:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GJOiF9MtB2McJAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 25 Aug 2022 08:07:47 +0000
Message-ID: <7d7af96c-5373-b23c-3d89-faf9c9d4ecb6@suse.com>
Date:   Thu, 25 Aug 2022 10:07:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220824142634.20966-1-jgross@suse.com>
 <396156e8-304e-ed68-8596-ee544dce0373@suse.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <396156e8-304e-ed68-8596-ee544dce0373@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------b6b0qdBxOtbEO4tXkfZJViOt"
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
--------------b6b0qdBxOtbEO4tXkfZJViOt
Content-Type: multipart/mixed; boundary="------------zWOJ3PCd3WjMk9LP2KcU87s9";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 stable@vger.kernel.org, Rustam Subkhankulov <subkhankulov@ispras.ru>,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Message-ID: <7d7af96c-5373-b23c-3d89-faf9c9d4ecb6@suse.com>
Subject: Re: [PATCH] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
References: <20220824142634.20966-1-jgross@suse.com>
 <396156e8-304e-ed68-8596-ee544dce0373@suse.com>
In-Reply-To: <396156e8-304e-ed68-8596-ee544dce0373@suse.com>

--------------zWOJ3PCd3WjMk9LP2KcU87s9
Content-Type: multipart/mixed; boundary="------------MdFpeP08AYCMR9QQClmKfH70"

--------------MdFpeP08AYCMR9QQClmKfH70
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUuMDguMjIgMDk6MzgsIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAyNC4wOC4yMDIy
IDE2OjI2LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gVGhlIGVycm9yIGV4aXQgb2YgcHJp
dmNtZF9pb2N0bF9kbV9vcCgpIGlzIGNhbGxpbmcgdW5sb2NrX3BhZ2VzKCkNCj4+IHBvdGVu
dGlhbGx5IHdpdGggcGFnZXMgYmVpbmcgTlVMTCwgbGVhZGluZyB0byBhIE5VTEwgZGVyZWZl
cmVuY2UuDQo+Pg0KPj4gRml4IHRoYXQgYnkgY2FsbGluZyB1bmxvY2tfcGFnZXMgb25seSBp
ZiBsb2NrX3BhZ2VzKCkgd2FzIGF0IGxlYXN0DQo+PiBwYXJ0aWFsbHkgc3VjY2Vzc2Z1bC4N
Cj4+DQo+PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+PiBGaXhlczogYWI1MjBi
ZThjZDVkICgieGVuL3ByaXZjbWQ6IEFkZCBJT0NUTF9QUklWQ01EX0RNX09QIikNCj4+IFJl
cG9ydGVkLWJ5OiBSdXN0YW0gU3Via2hhbmt1bG92IDxzdWJraGFua3Vsb3ZAaXNwcmFzLnJ1
Pg0KPj4gU2lnbmVkLW9mZi1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0K
PiANCj4gUmV2aWV3ZWQtYnk6IEphbiBCZXVsaWNoIDxqYmV1bGljaEBzdXNlLmNvbT4NCj4g
YWxiZWl0IEkgd29uZGVyIHdoZXRoZXIgeW91IGRpZCBjb25zaWRlciB0aGUgdmFyaWFudCBh
Y3R1YWxseQ0KPiByZWR1Y2luZyBjb2RlIHNpemUgKGFuZCBhdm9pZGluZyB0aGUgbmVlZCBm
b3IgeWV0IGFub3RoZXIgbGFiZWwpLA0KPiAuLi4NCj4gDQo+PiAtLS0gYS9kcml2ZXJzL3hl
bi9wcml2Y21kLmMNCj4+ICsrKyBiL2RyaXZlcnMveGVuL3ByaXZjbWQuYw0KPj4gQEAgLTY3
OSw3ICs2NzksNyBAQCBzdGF0aWMgbG9uZyBwcml2Y21kX2lvY3RsX2RtX29wKHN0cnVjdCBm
aWxlICpmaWxlLCB2b2lkIF9fdXNlciAqdWRhdGEpDQo+PiAgIAlyYyA9IGxvY2tfcGFnZXMo
a2J1ZnMsIGtkYXRhLm51bSwgcGFnZXMsIG5yX3BhZ2VzLCAmcGlubmVkKTsNCj4+ICAgCWlm
IChyYyA8IDApIHsNCj4+ICAgCQlucl9wYWdlcyA9IHBpbm5lZDsNCj4gDQo+IC4uLiBkcm9w
cGluZyB0aGlzIGxpbmUgYW5kIC4uLg0KPiANCj4+IC0JCWdvdG8gb3V0Ow0KPj4gKwkJZ290
byB1bmxvY2s7DQo+PiAgIAl9DQo+PiAgIA0KPj4gICAJZm9yIChpID0gMDsgaSA8IGtkYXRh
Lm51bTsgaSsrKSB7DQo+PiBAQCAtNjkxLDggKzY5MSw5IEBAIHN0YXRpYyBsb25nIHByaXZj
bWRfaW9jdGxfZG1fb3Aoc3RydWN0IGZpbGUgKmZpbGUsIHZvaWQgX191c2VyICp1ZGF0YSkN
Cj4+ICAgCXJjID0gSFlQRVJWSVNPUl9kbV9vcChrZGF0YS5kb20sIGtkYXRhLm51bSwgeGJ1
ZnMpOw0KPj4gICAJeGVuX3ByZWVtcHRpYmxlX2hjYWxsX2VuZCgpOw0KPj4gICANCj4+IC1v
dXQ6DQo+PiArIHVubG9jazoNCj4+ICAgCXVubG9ja19wYWdlcyhwYWdlcywgbnJfcGFnZXMp
Ow0KPiANCj4gLi4uIHBhc3NpbmcgInBpbm5lZCIgaGVyZS4NCg0KTG9va2luZyBpbnRvIHRo
aXMgSSBmb3VuZCBhbm90aGVyIHByb2JsZW06IE5PVCB1c2luZyBwaW5uZWQgaXMgd3Jvbmcs
IGFzDQpsb2NrX3BhZ2VzKCkgZG9lc24ndCBndWFyYW50ZWUgdGhhdCBhbGwgcGFnZXMgd2Vy
ZSByZWFsbHkgbG9ja2VkLiBJIHRoaW5rDQpsb2NrX3BhZ2VzKCkgc2hvdWxkIHJldHVybiBh
biBlcnJvciwgaW4gY2FzZSBwaW5fdXNlcl9wYWdlc19mYXN0KCkgZGlkbid0DQpsb2NrIGFz
IG1hbnkgcGFnZXMgZXMgZXhwZWN0ZWQuDQoNCg0KSnVlcmdlbg0K
--------------MdFpeP08AYCMR9QQClmKfH70
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------MdFpeP08AYCMR9QQClmKfH70--

--------------zWOJ3PCd3WjMk9LP2KcU87s9--

--------------b6b0qdBxOtbEO4tXkfZJViOt
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMHLdIFAwAAAAAACgkQsN6d1ii/Ey8F
vQf/begmdo9vfeilma7NyHZ1wW3LxiRrHtCaaxdCE4ertLAiYkgr4vogWsa0S6zgwKCQjGT/Hruv
Iu74RiOrlXh9qHVGSbpiVZYfh23xqL4lk9uV4ytPV7s8b9im0a6R0pahV5jrvQKVRpsSQmjaiX6Q
+rPgoVMp97W/m6f4EnT4/Tk+PXH6l2i75yZmzVzO/x45awG7IwNC0dWYAMFZ4J5XaIkWMEDDS4Gz
T0QBj5uD8l1//44SnuKvw1u/rM3VRHH0/t7uW7A5iGX0QvWAG935SgTexijlg8JjHy3nEyLg2Foc
6RpYii6bSHAYO4oB0pT3Cy2erShbQ431UnML9MY6zQ==
=Px2J
-----END PGP SIGNATURE-----

--------------b6b0qdBxOtbEO4tXkfZJViOt--
