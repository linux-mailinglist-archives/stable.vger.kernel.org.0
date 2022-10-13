Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDA35FDBFD
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 16:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJMOGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 10:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJMOGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 10:06:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844CE4E855
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 07:05:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A41991F38A;
        Thu, 13 Oct 2022 13:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665669307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yZGIK0o0NWnb1rvqaWJYoodVC7pQsiw1y30uK4tlkFk=;
        b=LlrPKZtEa2VKt9btjECcHYxjuGrIsNgu4/M5Z4vbgbWb+zwMxaoIS/bOiGcezo+bnPwoqr
        QIx06euY8kjmz0nsAgfdiHIajd9KZ/9kokKGtVOqp778TEmstHB06PILW9ikXiiNescDRK
        ADbsGXxEeoOw0FJLiFra42x25wCotRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665669307;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yZGIK0o0NWnb1rvqaWJYoodVC7pQsiw1y30uK4tlkFk=;
        b=jgv5uaV29iwJso0RMx1Yu4utI7UZDsFCCD45WL4lZyoEhOtymvXZ6xR2TTi+JZ1ncEz5et
        JwkY9CBxAB6kJXDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5D82813AAA;
        Thu, 13 Oct 2022 13:55:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QIzmFLsYSGNjRQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 13 Oct 2022 13:55:07 +0000
Message-ID: <03ca96bc-358f-3f02-c53e-5ff3a0d935dc@suse.de>
Date:   Thu, 13 Oct 2022 15:55:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
Content-Language: en-US
To:     Jocelyn Falempe <jfalempe@redhat.com>,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Cc:     michel@daenzer.net, stable@vger.kernel.org
References: <20221013132810.521945-1-jfalempe@redhat.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20221013132810.521945-1-jfalempe@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------VDKakA3QBOO6PjEGoiRz9Go2"
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------VDKakA3QBOO6PjEGoiRz9Go2
Content-Type: multipart/mixed; boundary="------------wb2YYErfSI0xD0fDL0mSBFI4";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Jocelyn Falempe <jfalempe@redhat.com>, dri-devel@lists.freedesktop.org,
 airlied@redhat.com
Cc: michel@daenzer.net, stable@vger.kernel.org
Message-ID: <03ca96bc-358f-3f02-c53e-5ff3a0d935dc@suse.de>
Subject: Re: [PATCH v2] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
References: <20221013132810.521945-1-jfalempe@redhat.com>
In-Reply-To: <20221013132810.521945-1-jfalempe@redhat.com>

--------------wb2YYErfSI0xD0fDL0mSBFI4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQoNCkFtIDEzLjEwLjIyIHVtIDE1OjI4IHNjaHJpZWIgSm9jZWx5biBGYWxlbXBlOg0KPiBG
b3IgRzIwMF9TRV9BLCBQTEwgTSBzZXR0aW5nIGlzIHdyb25nLCB3aGljaCBsZWFkcyB0byBi
bGFuayBzY3JlZW4sDQo+IG9yICJzaWduYWwgb3V0IG9mIHJhbmdlIiBvbiBWR0EgZGlzcGxh
eS4NCj4gcHJldmlvdXMgY29kZSBoYWQgIm0gfD0gMHg4MCIgd2hpY2ggd2FzIGNoYW5nZWQg
dG8NCj4gbSB8PSAoKHBpeHBsbGNuICYgQklUKDgpKSA+PiAxKTsNCj4gDQo+IFRlc3RlZCBv
biBHMjAwX1NFX0EgcmV2IDQyDQo+IA0KPiBUaGlzIGxpbmUgb2YgY29kZSB3YXMgbW92ZWQg
dG8gYW5vdGhlciBmaWxlIHdpdGgNCj4gY29tbWl0IDg1Mzk3ZjZiYzRmZiAoImRybS9tZ2Fn
MjAwOiBJbml0aWFsaXplIGVhY2ggbW9kZWwgaW4gc2VwYXJhdGUNCj4gZnVuY3Rpb24iKSBi
dXQgY2FuIGJlIGVhc2lseSBiYWNrcG9ydGVkIGJlZm9yZSB0aGlzIGNvbW1pdC4NCj4gDQo+
IHYyOiAqIHB1dCBCSVQoNykgRmlyc3QgdG8gcmVzcGVjdCBNU0ItdG8tTFNCIChUaG9tYXMp
DQo+ICAgICAgKiBBZGQgYSBjb21tZW50IHRvIGV4cGxhaW4gdGhhdCB0aGlzIGJpdCBtdXN0
IGJlIHNldCAoVGhvbWFzKQ0KPiANCj4gRml4ZXM6IDJkZDA0MDk0NmVjZiAoImRybS9tZ2Fn
MjAwOiBTdG9yZSB2YWx1ZXMgKG5vdCBiaXRzKSBpbiBzdHJ1Y3QgbWdhZzIwMF9wbGxfdmFs
dWVzIikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTog
Sm9jZWx5biBGYWxlbXBlIDxqZmFsZW1wZUByZWRoYXQuY29tPg0KDQpSZXZpZXdlZC1ieTog
VGhvbWFzIFppbW1lcm1hbm4gPHR6aW1tZXJtYW5uQHN1c2UuZGU+DQoNCj4gLS0tDQo+ICAg
ZHJpdmVycy9ncHUvZHJtL21nYWcyMDAvbWdhZzIwMF9nMjAwc2UuYyB8IDMgKystDQo+ICAg
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBfZzIwMHNlLmMg
Yi9kcml2ZXJzL2dwdS9kcm0vbWdhZzIwMC9tZ2FnMjAwX2cyMDBzZS5jDQo+IGluZGV4IGJl
Mzg5ZWQ5MWNiZC4uYmQ2ZTU3M2M5YTFhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2dwdS9k
cm0vbWdhZzIwMC9tZ2FnMjAwX2cyMDBzZS5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9t
Z2FnMjAwL21nYWcyMDBfZzIwMHNlLmMNCj4gQEAgLTI4NCw3ICsyODQsOCBAQCBzdGF0aWMg
dm9pZCBtZ2FnMjAwX2cyMDBzZV8wNF9waXhwbGxjX2F0b21pY191cGRhdGUoc3RydWN0IGRy
bV9jcnRjICpjcnRjLA0KPiAgIAlwaXhwbGxjcCA9IHBpeHBsbGMtPnAgLSAxOw0KPiAgIAlw
aXhwbGxjcyA9IHBpeHBsbGMtPnM7DQo+ICAgDQo+IC0JeHBpeHBsbGNtID0gcGl4cGxsY20g
fCAoKHBpeHBsbGNuICYgQklUKDgpKSA+PiAxKTsNCj4gKwkvLyBGb3IgRzIwMFNFIEEsIEJJ
VCg3KSBzaG91bGQgYmUgc2V0IHVuY29uZGl0aW9uYWxseS4NCj4gKwl4cGl4cGxsY20gPSBC
SVQoNykgfCBwaXhwbGxjbTsNCj4gICAJeHBpeHBsbGNuID0gcGl4cGxsY247DQo+ICAgCXhw
aXhwbGxjcCA9IChwaXhwbGxjcyA8PCAzKSB8IHBpeHBsbGNwOw0KPiAgIA0KDQotLSANClRo
b21hcyBaaW1tZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3
YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJu
YmVyZywgR2VybWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bD
vGhyZXI6IEl2byBUb3Rldg0K

--------------wb2YYErfSI0xD0fDL0mSBFI4--

--------------VDKakA3QBOO6PjEGoiRz9Go2
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNIGLoFAwAAAAAACgkQlh/E3EQov+C7
7Q//dAb5XZ2CBprqX57y4WErMgsNLN6cQV0tCZF1B+8w86gDjxMIKSMAWDT0g1LjYG/HUmXQwEEI
TruuHa5MDJZhipwvZwG6A8OrHgGXfq2DPI2jCq+y83OdGAqdLU6d6SJlJjtOYWyqu+GcMY0u7vLY
WRxA6YlDJUgH621+13zzE3ks4u25Xq7fQH/dul6TdYL2IBzHpN5KIailGMP4YzcVwQNK9HExzqoO
ZVRky9ImV5tNGt7vi41xytRlp0XKvxSiO/UnP5wT7rN1bBZEfUgGHlKgmXr6keZXs9W4+UtIaNXb
Jm5MdjMMYSCRTXP4LZBi4n8ivGxOytx4kKkMSRgLTv/7NzPdvVF+86ifAMm+0HcnvizTE/Z/z66X
kW1ueGcwQxTc9En+E2fUW0qjTPAB+bySd72BgwLMolAZh+llxXdm9p2fcQxSw5SIqZnl24tXVo8R
H6cn4VA+NrrQk0zApPhDCL9/crGGA70mJSKMm15klLKb8DMi2EP6EnFymYRn7JXOgBG35IGC4Z4e
wJYYyu57y8GLn0JYpOkvAIWD6JoOXSMZhu2zaxIRNIDWe3guP7guWBJIWQWn0WgGR4rYhXQsin/V
6TEqjRJVUEpkpOHevo0OOdfI05PS36wgzfpLgiw7GCDMfABOydmovewGR26GXxY16j2BluS/HUnI
mkE=
=07AP
-----END PGP SIGNATURE-----

--------------VDKakA3QBOO6PjEGoiRz9Go2--
