Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB612613300
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 10:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiJaJsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 05:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJaJsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 05:48:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7DECE24;
        Mon, 31 Oct 2022 02:48:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2BF661F91D;
        Mon, 31 Oct 2022 09:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667209679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=raHgg7DtJH4uQgAjVjur0VNOZMIRN0IqMEXdCp7DJG0=;
        b=MR2kiDjYDeoVxF05Qb+8FkdIr+BlbKMJDj4myz/T3udLivQJy31IqNp3YVoYd+Ihd2GhJP
        C5VKQcxy4hMQdSygNKwFPhpmjDYWlameC2jzUNYK6dybC3WZwmKa0juEIftXdi0wj1xJku
        cGvJagZCshYtjWpuaJn+WBTiQwm44Y4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667209679;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=raHgg7DtJH4uQgAjVjur0VNOZMIRN0IqMEXdCp7DJG0=;
        b=BRJ243cbEkbeCvyt7xfigOoyAEFqvgT6K6tTNq6y4ez3po5cHiptEQo5NkkAmez4lieTvj
        FFnVmHWXx1OI8xBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DDB6C13451;
        Mon, 31 Oct 2022 09:47:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id k4trM86ZX2P/ZQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 31 Oct 2022 09:47:58 +0000
Message-ID: <7f76fb8c-50a5-02d2-02fd-1af0497d823f@suse.de>
Date:   Mon, 31 Oct 2022 10:47:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
Content-Language: en-US
To:     Hector Martin <marcan@marcan.st>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>
Cc:     Pekka Paalanen <pekka.paalanen@collabora.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, asahi@lists.linux.dev
References: <20221027135711.24425-1-marcan@marcan.st>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20221027135711.24425-1-marcan@marcan.st>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ZcRpZwJjC5T9YfZ0di9GwKWA"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ZcRpZwJjC5T9YfZ0di9GwKWA
Content-Type: multipart/mixed; boundary="------------V7FArZw6FPO00zI03BcuoUn3";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Hector Martin <marcan@marcan.st>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Daniel Vetter <daniel@ffwll.ch>,
 Javier Martinez Canillas <javierm@redhat.com>
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, asahi@lists.linux.dev
Message-ID: <7f76fb8c-50a5-02d2-02fd-1af0497d823f@suse.de>
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
References: <20221027135711.24425-1-marcan@marcan.st>
In-Reply-To: <20221027135711.24425-1-marcan@marcan.st>

--------------V7FArZw6FPO00zI03BcuoUn3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

TWVyZ2VkIGludG8gZHJtLW1pc2MtZml4ZXMNCg0KQW0gMjcuMTAuMjIgdW0gMTU6NTcgc2No
cmllYiBIZWN0b3IgTWFydGluOg0KPiBkcm1fZmJfYnVpbGRfZm91cmNjX2xpc3QoKSBjdXJy
ZW50bHkgcmV0dXJucyBhbGwgZW11bGF0ZWQgZm9ybWF0cw0KPiB1bmNvbmRpdGlvbmFsbHkg
YXMgbG9uZyBhcyB0aGUgbmF0aXZlIGZvcm1hdCBpcyBhbW9uZyB0aGVtLCBldmVuIHRob3Vn
aA0KPiBub3QgYWxsIGNvbWJpbmF0aW9ucyBoYXZlIGNvbnZlcnNpb24gaGVscGVycy4gQWx0
aG91Z2ggdGhlIGxpc3QgaXMNCj4gYXJndWFibHkgcHJvdmlkZWQgdG8gdXNlcnNwYWNlIGlu
IHByZWNlZGVuY2Ugb3JkZXIsIHVzZXJzcGFjZSBjYW4gcGljaw0KPiBzb21ldGhpbmcgb3V0
LW9mLW9yZGVyIChhbmQgdGh1cyBicmVhayB3aGVuIGl0IHNob3VsZG4ndCksIG9yIHNpbXBs
eQ0KPiBvbmx5IHN1cHBvcnQgYSBmb3JtYXQgdGhhdCBpcyB1bnN1cHBvcnRlZCAoYW5kIHRo
dXMgdGhpbmsgaXQgY2FuIHdvcmssDQo+IHdoaWNoIHJlc3VsdHMgaW4gdGhlIGFwcGVhcmFu
Y2Ugb2YgYSBoYW5nIGFzIEZCIGJsaXRzIGZhaWwgbGF0ZXIgb24sDQo+IGluc3RlYWQgb2Yg
dGhlIGluaXRpYWxpemF0aW9uIGVycm9yIHlvdSdkIGV4cGVjdCBpbiB0aGlzIGNhc2UpLg0K
PiANCj4gQWRkIGNoZWNrcyB0byBmaWx0ZXIgdGhlIGxpc3Qgb2YgZW11bGF0ZWQgZm9ybWF0
cyB0byBvbmx5IHRob3NlDQo+IHN1cHBvcnRlZCBmb3IgY29udmVyc2lvbiB0byB0aGUgbmF0
aXZlIGZvcm1hdC4gVGhpcyBwcmVzdW1lcyB0aGF0IHRoZXJlDQo+IGlzIGEgc2luZ2xlIG5h
dGl2ZSBmb3JtYXQgKG9ubHkgdGhlIGZpcnN0IGlzIGNoZWNrZWQsIGlmIHRoZXJlIGFyZQ0K
PiBtdWx0aXBsZSkuIFJlZmFjdG9yaW5nIHRoaXMgQVBJIHRvIGRyb3AgdGhlIG5hdGl2ZSBs
aXN0IG9yIHN1cHBvcnQgaXQNCj4gcHJvcGVybHkgKGJ5IHJldHVybmluZyB0aGUgYXBwcm9w
cmlhdGUgZW11bGF0ZWQtPm5hdGl2ZSBtYXBwaW5nIHRhYmxlKQ0KPiBpcyBsZWZ0IGZvciBh
IGZ1dHVyZSBwYXRjaC4NCj4gDQo+IFRoZSBzaW1wbGVkcm0gZHJpdmVyIGlzIGxlZnQgYXMt
aXMgd2l0aCBhIGZ1bGwgdGFibGUgb2YgZW11bGF0ZWQNCj4gZm9ybWF0cy4gVGhpcyBrZWVw
cyBhbGwgY3VycmVudGx5IHdvcmtpbmcgY29udmVyc2lvbnMgYXZhaWxhYmxlIGFuZA0KPiBk
cm9wcyBhbGwgdGhlIGJyb2tlbiBvbmVzIChpLmUuIHRoaXMgYSBzdHJpY3QgYnVnZml4IHBh
dGNoLCBhZGRpbmcgbm8NCj4gbmV3IHN1cHBvcnRlZCBmb3JtYXRzIG5vciByZW1vdmluZyBh
bnkgYWN0dWFsbHkgd29ya2luZyBvbmVzKS4gSW4gb3JkZXINCj4gdG8gYXZvaWQgcHJvbGlm
ZXJhdGlvbiBvZiBlbXVsYXRlZCBmb3JtYXRzLCBmdXR1cmUgZHJpdmVycyBzaG91bGQNCj4g
YWR2ZXJ0aXNlIG9ubHkgWFJHQjg4ODggYXMgdGhlIHNvbGUgZW11bGF0ZWQgZm9ybWF0IChz
aW5jZSBzb21lDQo+IHVzZXJzcGFjZSBhc3N1bWVzIGl0cyBwcmVzZW5jZSkuDQo+IA0KPiBU
aGlzIGZpeGVzIGEgcmVhbCB1c2VyIHJlZ3Jlc3Npb24gd2hlcmUgdGhlID9SR0IyMTAxMDEw
IHN1cHBvcnQgY29tbWl0DQo+IHN0YXJ0ZWQgYWR2ZXJ0aXNpbmcgaXQgdW5jb25kaXRpb25h
bGx5IHdoZXJlIG5vdCBzdXBwb3J0ZWQsIGFuZCBLV2luDQo+IGRlY2lkZWQgdG8gc3RhcnQg
dG8gdXNlIGl0IG92ZXIgdGhlIG5hdGl2ZSBmb3JtYXQgYW5kIGJyb2tlLCBidXQgYWxzbw0K
PiB0aGUgZml4ZXMgdGhlIHNwdXJpb3VzIFJHQjU2NS9SR0I4ODggZm9ybWF0cyB3aGljaCBo
YXZlIGJlZW4gd3JvbmdseQ0KPiB1bmNvbmRpdGlvbmFsbHkgYWR2ZXJ0aXNlZCBzaW5jZSB0
aGUgZGF3biBvZiBzaW1wbGVkcm0uDQo+IA0KPiBGaXhlczogNmVhOTY2ZmNhMDg0ICgiZHJt
L3NpbXBsZWRybTogQWRkIFtBWF1SR0IyMTAxMDEwIGZvcm1hdHMiKQ0KPiBGaXhlczogMTFl
OGY1ZmQyMjNiICgiZHJtOiBBZGQgc2ltcGxlZHJtIGRyaXZlciIpDQo+IENjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IEhlY3RvciBNYXJ0aW4gPG1hcmNh
bkBtYXJjYW4uc3Q+DQo+IC0tLQ0KPiBJJ20gcHJvcG9zaW5nIHRoaXMgYWx0ZXJuYXRpdmUg
YXBwcm9hY2ggYWZ0ZXIgYSBoZWF0ZWQgZGlzY3Vzc2lvbiBvbg0KPiBJUkMuIEknbSBvdXQg
b2YgaWRlYXMsIGlmIHknYWxsIGRvbid0IGxpa2UgdGhpcyBvbmUgeW91IGNhbiBmaWd1cmUg
aXQNCj4gb3V0IGZvciB5b3Vyc2V2ZXMgOi0pDQo+IA0KPiBDaGFuZ2VzIHNpbmNlIHYxOg0K
PiBUaGlzIHYyIG1vdmVzIGFsbCB0aGUgY2hhbmdlcyB0byB0aGUgaGVscGVyIChzbyB0aGV5
IHdpbGwgYXBwbHkgdG8NCj4gdGhlIHVwY29taW5nIG9mZHJtLCB0aG91Z2ggb2Zkcm0gYWxz
byBuZWVkcyB0byBiZSBmaXhlZCB0byB0cmltIGl0cw0KPiBmb3JtYXQgdGFibGUgdG8gb25s
eSBmb3JtYXRzIHRoYXQgc2hvdWxkIGJlIGVtdWxhdGVkLCBwcm9iYWJseSBvbmx5DQo+IFhS
R0I4ODg4LCB0byBhdm9pZCBmdXJ0aGVyIHByb2xpZmVyYXRpbmcgdGhlIHVzZSBvZiBjb252
ZXJzaW9ucyksDQo+IGFuZCBhdm9pZHMgdG91Y2hpbmcgbW9yZSB0aGFuIG9uZSBmaWxlLiBU
aGUgQVBJIHN0aWxsIG5lZWRzIGNsZWFudXANCj4gYXMgbWVudGlvbmVkIChzdXBwb3J0aW5n
IG1vcmUgdGhhbiBvbmUgbmF0aXZlIGZvcm1hdCBpcyBmdW5kYW1lbnRhbGx5DQo+IGJyb2tl
biwgc2luY2UgdGhlIGhlbHBlciB3b3VsZCBuZWVkIHRvIHRlbGwgdGhlIGRyaXZlciAqd2hh
dCogbmF0aXZlDQo+IGZvcm1hdCB0byB1c2UgZm9yICplYWNoKiBlbXVsYXRlZCBmb3JtYXQg
c29tZWhvdyksIGJ1dCBhbGwgY3VycmVudCBhbmQNCj4gcGxhbm5lZCB1c2VycyBvbmx5IHBh
c3MgaW4gb25lIG5hdGl2ZSBmb3JtYXQsIHNvIHRoaXMgY2FuIChhbmQgc2hvdWxkKQ0KPiBi
ZSBmaXhlZCBsYXRlci4NCj4gDQo+IEFzaWRlOiBBZnRlciBvdGhlciBJUkMgZGlzY3Vzc2lv
biwgSSdtIHRlc3RpbmcgbnVraW5nIHRoZQ0KPiBYUkdCMjEwMTAxMCA8LT4gQVJHQjIxMDEw
MTAgYWR2ZXJ0aXNlbWVudCAod2hpY2ggZG9lcyBub3QgaW52b2x2ZQ0KPiBjb252ZXJzaW9u
KSBieSByZW1vdmluZyB0aG9zZSBlbnRyaWVzIGZyb20gc2ltcGxlZHJtIGluIHRoZSBBc2Fo
aSBMaW51eA0KPiBkb3duc3RyZWFtIHRyZWUuIEFzIGZhciBhcyBJJ20gY29uY2VybmVkLCBp
dCBjYW4gYmUgcmVtb3ZlZCBpZiBub2JvZHkNCj4gY29tcGxhaW5zIChieSByZW1vdmluZyB0
aG9zZSBlbnRyaWVzIGZyb20gdGhlIHNpbXBsZWRybSBhcnJheSksIGlmDQo+IG1haW50YWlu
ZXJzIGFyZSBnZW5lcmFsbHkgb2theSB3aXRoIHJlbW92aW5nIGFkdmVydGlzZWQgZm9ybWF0
cyBhdCBhbGwuDQo+IElmIHNvLCB0aGVyZSBtaWdodCBiZSBvdGhlciBvcHBvcnR1bml0aWVz
IGZvciBmdXJ0aGVyIHRyaW1taW5nIHRoZSBsaXN0DQo+IG5vbi1uYXRpdmUgZm9ybWF0cyBh
ZHZlcnRpc2VkIHRvIHVzZXJzcGFjZS4NCj4gDQo+IFRlc3RlZCB3aXRoIEtXaW4tWDExLCBL
V2luLVdheWxhbmQsIEdOT01FLVgxMSwgR05PTUUtV2F5bGFuZCwgYW5kIFdlc3Rvbg0KPiBv
biBib3RoIFhSR0IyMTAxMDEwIGFuZCBSR0I4ODg4IHNpbXBsZWRybSBmcmFtZWJ1ZmZlcnMu
DQo+IA0KPiAgIGRyaXZlcnMvZ3B1L2RybS9kcm1fZm9ybWF0X2hlbHBlci5jIHwgNjYgKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgNDcgaW5z
ZXJ0aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9ncHUvZHJtL2RybV9mb3JtYXRfaGVscGVyLmMgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2Zv
cm1hdF9oZWxwZXIuYw0KPiBpbmRleCBlMmY3NjYyMTQ1M2MuLjNlZTU5YmFlOWQyZiAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2RybV9mb3JtYXRfaGVscGVyLmMNCj4gKysr
IGIvZHJpdmVycy9ncHUvZHJtL2RybV9mb3JtYXRfaGVscGVyLmMNCj4gQEAgLTgwNyw2ICs4
MDcsMzggQEAgc3RhdGljIGJvb2wgaXNfbGlzdGVkX2ZvdXJjYyhjb25zdCB1aW50MzJfdCAq
Zm91cmNjcywgc2l6ZV90IG5mb3VyY2NzLCB1aW50MzJfdA0KPiAgIAlyZXR1cm4gZmFsc2U7
DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGNvbnN0IHVpbnQzMl90IGNvbnZfZnJvbV94cmdi
ODg4OFtdID0gew0KPiArCURSTV9GT1JNQVRfWFJHQjg4ODgsDQo+ICsJRFJNX0ZPUk1BVF9B
UkdCODg4OCwNCj4gKwlEUk1fRk9STUFUX1hSR0IyMTAxMDEwLA0KPiArCURSTV9GT1JNQVRf
QVJHQjIxMDEwMTAsDQo+ICsJRFJNX0ZPUk1BVF9SR0I1NjUsDQo+ICsJRFJNX0ZPUk1BVF9S
R0I4ODgsDQo+ICt9Ow0KPiArDQo+ICtzdGF0aWMgY29uc3QgdWludDMyX3QgY29udl9mcm9t
X3JnYjU2NV84ODhbXSA9IHsNCj4gKwlEUk1fRk9STUFUX1hSR0I4ODg4LA0KPiArCURSTV9G
T1JNQVRfQVJHQjg4ODgsDQo+ICt9Ow0KPiArDQo+ICtzdGF0aWMgYm9vbCBpc19jb252ZXJz
aW9uX3N1cHBvcnRlZCh1aW50MzJfdCBmcm9tLCB1aW50MzJfdCB0bykNCj4gK3sNCj4gKwlz
d2l0Y2ggKGZyb20pIHsNCj4gKwljYXNlIERSTV9GT1JNQVRfWFJHQjg4ODg6DQo+ICsJY2Fz
ZSBEUk1fRk9STUFUX0FSR0I4ODg4Og0KPiArCQlyZXR1cm4gaXNfbGlzdGVkX2ZvdXJjYyhj
b252X2Zyb21feHJnYjg4ODgsIEFSUkFZX1NJWkUoY29udl9mcm9tX3hyZ2I4ODg4KSwgdG8p
Ow0KPiArCWNhc2UgRFJNX0ZPUk1BVF9SR0I1NjU6DQo+ICsJY2FzZSBEUk1fRk9STUFUX1JH
Qjg4ODoNCj4gKwkJcmV0dXJuIGlzX2xpc3RlZF9mb3VyY2MoY29udl9mcm9tX3JnYjU2NV84
ODgsIEFSUkFZX1NJWkUoY29udl9mcm9tX3JnYjU2NV84ODgpLCB0byk7DQo+ICsJY2FzZSBE
Uk1fRk9STUFUX1hSR0IyMTAxMDEwOg0KPiArCQlyZXR1cm4gdG8gPT0gRFJNX0ZPUk1BVF9B
UkdCMjEwMTAxMDsNCj4gKwljYXNlIERSTV9GT1JNQVRfQVJHQjIxMDEwMTA6DQo+ICsJCXJl
dHVybiB0byA9PSBEUk1fRk9STUFUX1hSR0IyMTAxMDEwOw0KPiArCWRlZmF1bHQ6DQo+ICsJ
CXJldHVybiBmYWxzZTsNCj4gKwl9DQo+ICt9DQo+ICsNCj4gICAvKioNCj4gICAgKiBkcm1f
ZmJfYnVpbGRfZm91cmNjX2xpc3QgLSBGaWx0ZXJzIGEgbGlzdCBvZiBzdXBwb3J0ZWQgY29s
b3IgZm9ybWF0cyBhZ2FpbnN0DQo+ICAgICogICAgICAgICAgICAgICAgICAgICAgICAgICAg
dGhlIGRldmljZSdzIG5hdGl2ZSBmb3JtYXRzDQo+IEBAIC04MjcsNyArODU5LDkgQEAgc3Rh
dGljIGJvb2wgaXNfbGlzdGVkX2ZvdXJjYyhjb25zdCB1aW50MzJfdCAqZm91cmNjcywgc2l6
ZV90IG5mb3VyY2NzLCB1aW50MzJfdA0KPiAgICAqIGJlIGhhbmRlZCBvdmVyIHRvIGRybV91
bml2ZXJzYWxfcGxhbmVfaW5pdCgpIGV0IGFsLiBOYXRpdmUgZm9ybWF0cw0KPiAgICAqIHdp
bGwgZ28gYmVmb3JlIGVtdWxhdGVkIGZvcm1hdHMuIE90aGVyIGhldXJpc3RpY3MgbWlnaHQg
YmUgYXBwbGllZA0KPiAgICAqIHRvIG9wdGltaXplIHRoZSBvcmRlci4gRm9ybWF0cyBuZWFy
IHRoZSBiZWdpbm5pbmcgb2YgdGhlIGxpc3QgYXJlDQo+IC0gKiB1c3VhbGx5IHByZWZlcnJl
ZCBvdmVyIGZvcm1hdHMgbmVhciB0aGUgZW5kIG9mIHRoZSBsaXN0Lg0KPiArICogdXN1YWxs
eSBwcmVmZXJyZWQgb3ZlciBmb3JtYXRzIG5lYXIgdGhlIGVuZCBvZiB0aGUgbGlzdC4gRm9y
bWF0cw0KPiArICogd2l0aG91dCBjb252ZXJzaW9uIGhlbHBlcnMgd2lsbCBiZSBza2lwcGVk
LiBOZXcgZHJpdmVycyBzaG91bGQgb25seQ0KPiArICogcGFzcyBpbiBYUkdCODg4OCBhbmQg
YXZvaWQgZXhwb3NpbmcgYWRkaXRpb25hbCBlbXVsYXRlZCBmb3JtYXRzLg0KPiAgICAqDQo+
ICAgICogUmV0dXJuczoNCj4gICAgKiBUaGUgbnVtYmVyIG9mIGNvbG9yLWZvcm1hdHMgNEND
IGNvZGVzIHJldHVybmVkIGluIEBmb3VyY2NzX291dC4NCj4gQEAgLTgzOSw3ICs4NzMsNyBA
QCBzaXplX3QgZHJtX2ZiX2J1aWxkX2ZvdXJjY19saXN0KHN0cnVjdCBkcm1fZGV2aWNlICpk
ZXYsDQo+ICAgew0KPiAgIAl1MzIgKmZvdXJjY3MgPSBmb3VyY2NzX291dDsNCj4gICAJY29u
c3QgdTMyICpmb3VyY2NzX2VuZCA9IGZvdXJjY3Nfb3V0ICsgbmZvdXJjY3Nfb3V0Ow0KPiAt
CWJvb2wgZm91bmRfbmF0aXZlID0gZmFsc2U7DQo+ICsJdWludDMyX3QgbmF0aXZlX2Zvcm1h
dCA9IDA7DQo+ICAgCXNpemVfdCBpOw0KPiAgIA0KPiAgIAkvKg0KPiBAQCAtODU4LDI2ICs4
OTIsMTggQEAgc2l6ZV90IGRybV9mYl9idWlsZF9mb3VyY2NfbGlzdChzdHJ1Y3QgZHJtX2Rl
dmljZSAqZGV2LA0KPiAgIA0KPiAgIAkJZHJtX2RiZ19rbXMoZGV2LCAiYWRkaW5nIG5hdGl2
ZSBmb3JtYXQgJXA0Y2NcbiIsICZmb3VyY2MpOw0KPiAgIA0KPiAtCQlpZiAoIWZvdW5kX25h
dGl2ZSkNCj4gLQkJCWZvdW5kX25hdGl2ZSA9IGlzX2xpc3RlZF9mb3VyY2MoZHJpdmVyX2Zv
dXJjY3MsIGRyaXZlcl9uZm91cmNjcywgZm91cmNjKTsNCj4gKwkJLyoNCj4gKwkJICogVGhl
cmUgc2hvdWxkIG9ubHkgYmUgb25lIG5hdGl2ZSBmb3JtYXQgd2l0aCB0aGUgY3VycmVudCBB
UEkuDQo+ICsJCSAqIFRoaXMgQVBJIG5lZWRzIHRvIGJlIHJlZmFjdG9yZWQgdG8gY29ycmVj
dGx5IHN1cHBvcnQgYXJiaXRyYXJ5DQo+ICsJCSAqIHNldHMgb2YgbmF0aXZlIGZvcm1hdHMs
IHNpbmNlIGl0IG5lZWRzIHRvIHJlcG9ydCB3aGljaCBuYXRpdmUNCj4gKwkJICogZm9ybWF0
IHRvIHVzZSBmb3IgZWFjaCBlbXVsYXRlZCBmb3JtYXQuDQo+ICsJCSAqLw0KPiArCQlpZiAo
IW5hdGl2ZV9mb3JtYXQpDQo+ICsJCQluYXRpdmVfZm9ybWF0ID0gZm91cmNjOw0KPiAgIAkJ
KmZvdXJjY3MgPSBmb3VyY2M7DQo+ICAgCQkrK2ZvdXJjY3M7DQo+ICAgCX0NCj4gICANCj4g
LQkvKg0KPiAtCSAqIFRoZSBwbGFuZSdzIGF0b21pY191cGRhdGUgaGVscGVyIGNvbnZlcnRz
IHRoZSBmcmFtZWJ1ZmZlcidzIGNvbG9yIGZvcm1hdA0KPiAtCSAqIHRvIGEgbmF0aXZlIGZv
cm1hdCB3aGVuIGNvcHlpbmcgdG8gZGV2aWNlIG1lbW9yeS4NCj4gLQkgKg0KPiAtCSAqIElm
IHRoZXJlIGlzIG5vdCBhIHNpbmdsZSBmb3JtYXQgc3VwcG9ydGVkIGJ5IGJvdGgsIGRldmlj
ZSBhbmQNCj4gLQkgKiBkcml2ZXIsIHRoZSBuYXRpdmUgZm9ybWF0cyBhcmUgbGlrZWx5IG5v
dCBzdXBwb3J0ZWQgYnkgdGhlIGNvbnZlcnNpb24NCj4gLQkgKiBoZWxwZXJzLiBUaGVyZWZv
cmUgKm9ubHkqIHN1cHBvcnQgdGhlIG5hdGl2ZSBmb3JtYXRzIGFuZCBhZGQgYQ0KPiAtCSAq
IGNvbnZlcnNpb24gaGVscGVyIEFTQVAuDQo+IC0JICovDQo+IC0JaWYgKCFmb3VuZF9uYXRp
dmUpIHsNCj4gLQkJZHJtX3dhcm4oZGV2LCAiRm9ybWF0IGNvbnZlcnNpb24gaGVscGVycyBy
ZXF1aXJlZCB0byBhZGQgZXh0cmEgZm9ybWF0cy5cbiIpOw0KPiAtCQlnb3RvIG91dDsNCj4g
LQl9DQo+IC0NCj4gICAJLyoNCj4gICAJICogVGhlIGV4dHJhIGZvcm1hdHMsIGVtdWxhdGVk
IGJ5IHRoZSBkcml2ZXIsIGdvIHNlY29uZC4NCj4gICAJICovDQo+IEBAIC04OTAsNiArOTE2
LDkgQEAgc2l6ZV90IGRybV9mYl9idWlsZF9mb3VyY2NfbGlzdChzdHJ1Y3QgZHJtX2Rldmlj
ZSAqZGV2LA0KPiAgIAkJfSBlbHNlIGlmIChmb3VyY2NzID09IGZvdXJjY3NfZW5kKSB7DQo+
ICAgCQkJZHJtX3dhcm4oZGV2LCAiSWdub3JpbmcgZW11bGF0ZWQgZm9ybWF0ICVwNGNjXG4i
LCAmZm91cmNjKTsNCj4gICAJCQljb250aW51ZTsgLyogZW5kIG9mIGF2YWlsYWJsZSBvdXRw
dXQgYnVmZmVyICovDQo+ICsJCX0gZWxzZSBpZiAoIWlzX2NvbnZlcnNpb25fc3VwcG9ydGVk
KGZvdXJjYywgbmF0aXZlX2Zvcm1hdCkpIHsNCj4gKwkJCWRybV9kYmdfa21zKGRldiwgIlVu
c3VwcG9ydGVkIGVtdWxhdGVkIGZvcm1hdCAlcDRjY1xuIiwgJmZvdXJjYyk7DQo+ICsJCQlj
b250aW51ZTsgLyogZm9ybWF0IGlzIG5vdCBzdXBwb3J0ZWQgZm9yIGNvbnZlcnNpb24gKi8N
Cj4gICAJCX0NCj4gICANCj4gICAJCWRybV9kYmdfa21zKGRldiwgImFkZGluZyBlbXVsYXRl
ZCBmb3JtYXQgJXA0Y2NcbiIsICZmb3VyY2MpOw0KPiBAQCAtODk4LDcgKzkyNyw2IEBAIHNp
emVfdCBkcm1fZmJfYnVpbGRfZm91cmNjX2xpc3Qoc3RydWN0IGRybV9kZXZpY2UgKmRldiwN
Cj4gICAJCSsrZm91cmNjczsNCj4gICAJfQ0KPiAgIA0KPiAtb3V0Og0KPiAgIAlyZXR1cm4g
Zm91cmNjcyAtIGZvdXJjY3Nfb3V0Ow0KPiAgIH0NCj4gICBFWFBPUlRfU1lNQk9MKGRybV9m
Yl9idWlsZF9mb3VyY2NfbGlzdCk7DQoNCi0tIA0KVGhvbWFzIFppbW1lcm1hbm4NCkdyYXBo
aWNzIERyaXZlciBEZXZlbG9wZXINClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkg
R21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBHZXJtYW55DQooSFJCIDM2
ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2DQo=

--------------V7FArZw6FPO00zI03BcuoUn3--

--------------ZcRpZwJjC5T9YfZ0di9GwKWA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNfmc4FAwAAAAAACgkQlh/E3EQov+BM
VA//Wh+hG7KNEtIWZRePs+tgwX7/6UqF+VKbSD1GwZ7wyfrduX90hDZS3WosJ4xu/0ESXjjICG/l
B6RDBPKVIuxhJhVUAfhlhDXnyQuaH1fYkwDUF7sCvuuxfmu9w7PZxdtossTEfxkm1HRBr7HnHIld
97UAsE9WTCZ5m2YlfbMBC/W0im6//GZwzHVDXhQWbOT7t4xihL3beT+bZjhD+TpcD7/RjZ7DAxJB
F+okG5XRsaAfYCTnQCFPYj6Y8DzN32K1UpbNs3maNpP+ZMJlJUtKBpkH7R/7Aj+EHmpVZ53yvYid
GzdVFB3pv7Sw8x0FN13ucSS+MTLdsODkJQOUjJOmipEfjjC2DRjOUv+V4zOPERh6kv9mfJ36PGfX
tTNuGw/+HAziM7LAa8vLg1M/6w0vD6FNBXtRs0TPGy813/eQOHx9saGboqijef2hfqyz6X+Pyo1b
d4IykTpsFzNAG3O6IkkeaKoyF9ARbyM12xj28THAnJmCm/+La6MlJ0ztLVHXSGAHVya9qsyM01dK
sZxYaL80K0mEAuiuO7v1Vtqj//NGgXxcFEUMWYANXAUDAY4SjBT/umwUnESgj8nid2/N98o7+yJ8
d/kKuorqhbsXdFJsF+P3dl8tYkFWuzWjpTsekZXgZ595suTUvUtAWTbwkrnQkz45+XcNRGrlkEye
PXU=
=OJJa
-----END PGP SIGNATURE-----

--------------ZcRpZwJjC5T9YfZ0di9GwKWA--
