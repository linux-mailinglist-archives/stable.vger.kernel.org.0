Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A23557C4F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 14:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiFWM5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 08:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiFWM5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 08:57:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BF44B87B;
        Thu, 23 Jun 2022 05:57:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5564321B17;
        Thu, 23 Jun 2022 12:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655989025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IwQIdTPOL0hcDLLiZO+ZnH1H9mqh4iSUrszqHqXfKJc=;
        b=BNfNzZISdwN6dTOvSVYKGZafp2YfIvseJA0TCW0PiO4whijnaYKYDM8hVcwHRGoZ4QTfVk
        leCP35Oaw2HuejLPN93Q5mccJnMwjK/L6qfssXBkWzjy3y7dtoelT1JpXUNNaRmZXuX2EG
        bIeKBExMFKB5AvuTchIeVoPJ5rAmt6E=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1570113461;
        Thu, 23 Jun 2022 12:57:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Jf+GAyFjtGJqGQAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 23 Jun 2022 12:57:05 +0000
Message-ID: <88ca4ce6-0f8a-0084-9074-7e72a341536b@suse.com>
Date:   Thu, 23 Jun 2022 14:57:04 +0200
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
 boundary="------------MjLJ9LQCj5UmEMxFvomyfUd0"
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
--------------MjLJ9LQCj5UmEMxFvomyfUd0
Content-Type: multipart/mixed; boundary="------------CM7Lbh2cN3VZwePM0uCnSORv";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 David Vrabel <david.vrabel@citrix.com>,
 Jennifer Herbert <jennifer.herbert@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Message-ID: <88ca4ce6-0f8a-0084-9074-7e72a341536b@suse.com>
Subject: Re: [PATCH v4] xen/gntdev: Avoid blocking in unmap_grant_pages()
References: <20220622022726.2538-1-demi@invisiblethingslab.com>
In-Reply-To: <20220622022726.2538-1-demi@invisiblethingslab.com>

--------------CM7Lbh2cN3VZwePM0uCnSORv
Content-Type: multipart/mixed; boundary="------------EZrvq5EHS1RGY5UKrUtgHHZI"

--------------EZrvq5EHS1RGY5UKrUtgHHZI
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
bT4NCg0KUmV2aWV3ZWQtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCg0K
DQpKdWVyZ2VuDQo=
--------------EZrvq5EHS1RGY5UKrUtgHHZI
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------EZrvq5EHS1RGY5UKrUtgHHZI--

--------------CM7Lbh2cN3VZwePM0uCnSORv--

--------------MjLJ9LQCj5UmEMxFvomyfUd0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmK0YyAFAwAAAAAACgkQsN6d1ii/Ey9/
pgf/eNQa9Pf7E8x2YxUld0WpDOH6NxiTgM+wwHd/VsfBNuwXmthu0iGFvImOHIPJ21gD7Ibz1N4N
JFOp4Dh60QJ04EjrnT8SDaz7Mu9lsA1dHr6MMXokdbSRTijHVhzpMphN63AnZOvHCJn2FUzp+UvE
riOxkKCB3yIohXFV3oajCQHmZBb83wMizl02J/hA7pAez4pen8JiQYMnkq7djZ+vXc1E0PAcZf17
5QPSXEbR4ghoUqkd8rFVq4vUClmyqRJwsOtuYdSd6VS3U1vjg1MW712MBTyT/snO+5snXZp53jE7
QRHhn7aLmtPAt/nC6Gf+lmgxBdtpdIah0mJByVQixA==
=t+Ri
-----END PGP SIGNATURE-----

--------------MjLJ9LQCj5UmEMxFvomyfUd0--
