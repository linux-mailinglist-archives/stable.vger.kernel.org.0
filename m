Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4685599C1
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 14:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiFXMmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 08:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiFXMmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 08:42:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DBF4ECD1;
        Fri, 24 Jun 2022 05:42:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1EA751F8D3;
        Fri, 24 Jun 2022 12:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656074553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZPF37THvgfx7n6/XoaVA1Vlsvk1MiJMATW6ZECgwY24=;
        b=im68LekaDvUTQznrYum2ShKKJnAQVuPa9iPwtXYhNm+nSR6c54Dq8bkHiA73J6blPE+pmq
        g6lbz5FH5uiWNbj4mSSlwCR510Oe+42hV9zpP9TMVCjLeNgpb7XOYDAYrmyAXZQ7lFUqiT
        fa40wv2Ckb9sksXO+Tmafm8R4AtEzoE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D641D13ACA;
        Fri, 24 Jun 2022 12:42:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aRnFMjixtWIwawAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 24 Jun 2022 12:42:32 +0000
Message-ID: <2049c227-9a3d-6e43-01bb-639267b7ddad@suse.com>
Date:   Fri, 24 Jun 2022 14:42:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4] xen/gntdev: Avoid blocking in unmap_grant_pages()
Content-Language: en-US
To:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jennifer Herbert <jennifer.herbert@citrix.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220622022726.2538-1-demi@invisiblethingslab.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20220622022726.2538-1-demi@invisiblethingslab.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------gPZ7BfZdz9D3IEOV00gg8qhO"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------gPZ7BfZdz9D3IEOV00gg8qhO
Content-Type: multipart/mixed; boundary="------------87al14GsXIQ9g60d3eHk02fC";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 David Vrabel <david.vrabel@citrix.com>,
 Jennifer Herbert <jennifer.herbert@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Message-ID: <2049c227-9a3d-6e43-01bb-639267b7ddad@suse.com>
Subject: Re: [PATCH v4] xen/gntdev: Avoid blocking in unmap_grant_pages()
References: <20220622022726.2538-1-demi@invisiblethingslab.com>
In-Reply-To: <20220622022726.2538-1-demi@invisiblethingslab.com>

--------------87al14GsXIQ9g60d3eHk02fC
Content-Type: multipart/mixed; boundary="------------Bs1GaeD0uKddp5Jn7uvjrlcO"

--------------Bs1GaeD0uKddp5Jn7uvjrlcO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMDYuMjIgMDQ6MjcsIERlbWkgTWFyaWUgT2Jlbm91ciB3cm90ZToNCj4gdW5tYXBf
Z3JhbnRfcGFnZXMoKSBjdXJyZW50bHkgd2FpdHMgZm9yIHRoZSBwYWdlcyB0byBubyBsb25n
ZXIgYmUgdXNlZC4NCj4gSW4gaHR0cHM6Ly9naXRodWIuY29tL1F1YmVzT1MvcXViZXMtaXNz
dWVzL2lzc3Vlcy83NDgxLCB0aGlzIGxlYWQgdG8gYQ0KPiBkZWFkbG9jayBhZ2FpbnN0IGk5
MTU6IGk5MTUgd2FzIHdhaXRpbmcgZm9yIGdudGRldidzIE1NVSBub3RpZmllciB0bw0KPiBm
aW5pc2gsIHdoaWxlIGdudGRldiB3YXMgd2FpdGluZyBmb3IgaTkxNSB0byBmcmVlIGl0cyBw
YWdlcy4gIEkgYWxzbw0KPiBiZWxpZXZlIHRoaXMgaXMgcmVzcG9uc2libGUgZm9yIHZhcmlv
dXMgZGVhZGxvY2tzIEkgaGF2ZSBleHBlcmllbmNlZCBpbg0KPiB0aGUgcGFzdC4NCj4gDQo+
IEF2b2lkIHRoZXNlIHByb2JsZW1zIGJ5IG1ha2luZyB1bm1hcF9ncmFudF9wYWdlcyBhc3lu
Yy4gIFRoaXMgcmVxdWlyZXMNCj4gbWFraW5nIGl0IHJldHVybiB2b2lkLCBhcyBhbnkgZXJy
b3JzIHdpbGwgbm90IGJlIGF2YWlsYWJsZSB3aGVuIHRoZQ0KPiBmdW5jdGlvbiByZXR1cm5z
LiAgRm9ydHVuYXRlbHksIHRoZSBvbmx5IHVzZSBvZiB0aGUgcmV0dXJuIHZhbHVlIGlzIGEN
Cj4gV0FSTl9PTigpLCB3aGljaCBjYW4gYmUgcmVwbGFjZWQgYnkgYSBXQVJOX09OIHdoZW4g
dGhlIGVycm9yIGlzDQo+IGRldGVjdGVkLiAgQWRkaXRpb25hbGx5LCBhIGZhaWxlZCBjYWxs
IHdpbGwgbm90IHByZXZlbnQgZnVydGhlciBjYWxscw0KPiBmcm9tIGJlaW5nIG1hZGUsIGJ1
dCB0aGlzIGlzIGhhcm1sZXNzLg0KPiANCj4gQmVjYXVzZSB1bm1hcF9ncmFudF9wYWdlcyBp
cyBub3cgYXN5bmMsIHRoZSBncmFudCBoYW5kbGUgd2lsbCBiZSBzZW50IHRvDQo+IElOVkFM
SURfR1JBTlRfSEFORExFIHRvbyBsYXRlIHRvIHByZXZlbnQgbXVsdGlwbGUgdW5tYXBzIG9m
IHRoZSBzYW1lDQo+IGhhbmRsZS4gIEluc3RlYWQsIGEgc2VwYXJhdGUgYm9vbCBhcnJheSBp
cyBhbGxvY2F0ZWQgZm9yIHRoaXMgcHVycG9zZS4NCj4gVGhpcyB3YXN0ZXMgbWVtb3J5LCBi
dXQgc3R1ZmZpbmcgdGhpcyBpbmZvcm1hdGlvbiBpbiBwYWRkaW5nIGJ5dGVzIGlzDQo+IHRv
byBmcmFnaWxlLiAgRnVydGhlcm1vcmUsIGl0IGlzIG5lY2Vzc2FyeSB0byBncmFiIGEgcmVm
ZXJlbmNlIHRvIHRoZQ0KPiBtYXAgYmVmb3JlIG1ha2luZyB0aGUgYXN5bmNocm9ub3VzIGNh
bGwsIGFuZCByZWxlYXNlIHRoZSByZWZlcmVuY2Ugd2hlbg0KPiB0aGUgY2FsbCByZXR1cm5z
Lg0KPiANCj4gSXQgaXMgYWxzbyBuZWNlc3NhcnkgdG8gZ3VhcmQgYWdhaW5zdCByZWVudHJh
bmN5IGluIGdudGRldl9tYXBfcHV0KCksDQo+IGFuZCB0byBoYW5kbGUgdGhlIGNhc2Ugd2hl
cmUgdXNlcnNwYWNlIHRyaWVzIHRvIG1hcCBhIG1hcHBpbmcgd2hvc2UNCj4gY29udGVudHMg
aGF2ZSBub3QgYWxsIGJlZW4gZnJlZWQgeWV0Lg0KPiANCj4gRml4ZXM6IDc0NTI4MjI1NmM3
NSAoInhlbi9nbnRkZXY6IHNhZmVseSB1bm1hcCBncmFudHMgaW4gY2FzZSB0aGV5IGFyZSBz
dGlsbCBpbiB1c2UiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQt
b2ZmLWJ5OiBEZW1pIE1hcmllIE9iZW5vdXIgPGRlbWlAaW52aXNpYmxldGhpbmdzbGFiLmNv
bT4NCg0KUHVzaGVkIHRvIHhlbi90aXAuZ2l0IGZvci1saW51cy01LjE5YQ0KDQoNCkp1ZXJn
ZW4NCg==
--------------Bs1GaeD0uKddp5Jn7uvjrlcO
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------Bs1GaeD0uKddp5Jn7uvjrlcO--

--------------87al14GsXIQ9g60d3eHk02fC--

--------------gPZ7BfZdz9D3IEOV00gg8qhO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmK1sTgFAwAAAAAACgkQsN6d1ii/Ey8u
XQf/ebYdmdSPTTkR0FxlVhx06ey7mujOAlSFkJUMi65CPOj1xBCOWOQcZnKHbm9wqcdUwroXHxNb
tjhi8PrEW+6ufRANQ9e9+Ri2UYvFpCooONzd/gi/riKn1aveHnos6SIg2yP/Iw9kcLbQyDHClZpn
tq2aX8oIkJ/A5VyeCT/q7I19Ar7KbdJ87K8z4tvOaK31c9Fj3a42v7djjI3M9wNTTk4UPjydMPBH
BuTA6qr8xY4wHzWnjbe1rcBJQXqPELxP1KM2aFX+L/kEXrVRi58F0FIiDopNhziDWH3wss14dJ1P
CiP3Nc46JG2vzibaMRcp1u/vWThTYttZGsc6hkes8w==
=qjWb
-----END PGP SIGNATURE-----

--------------gPZ7BfZdz9D3IEOV00gg8qhO--
