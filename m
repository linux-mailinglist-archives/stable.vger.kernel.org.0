Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB2B421F1A
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 08:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhJEGyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 02:54:20 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56464 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJEGyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 02:54:19 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BF93D222D8;
        Tue,  5 Oct 2021 06:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633416748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2uPjvyiTSs76YrBpiVALNEP8f+vD6bBJO6qePNnciDQ=;
        b=H7D1U9c8gprbkWW2T3hNKB/km7cHJOq3dgpVI8OHYdOGE2K9x7eBE1CGESIjWerns95SS+
        NZrBiRBR893wMptGz7vSvprMun7j5UKTiB4o8BOSJM5xJPjG9qNYl4rZi76GSjb4aK4cWN
        ikOyuvJfL4eP58h88HTUTRSiccH2YuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633416748;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2uPjvyiTSs76YrBpiVALNEP8f+vD6bBJO6qePNnciDQ=;
        b=5yJn2XDjsDA2UUwgcBgTgPW06PqUcHsHzPuy6JPcTLkcU2lxX7lndBToZ94n8SdT5s6PMT
        FPvPdV/ao+QdunAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 80AFD133A7;
        Tue,  5 Oct 2021 06:52:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Jew5Hiz2W2FrOgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 05 Oct 2021 06:52:28 +0000
Message-ID: <ffa85393-e76c-09e8-b4d2-b5c06523d014@suse.de>
Date:   Tue, 5 Oct 2021 08:52:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH] drm/fbdev: Clamp fbdev surface size if too large
Content-Language: en-US
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     daniel@ffwll.ch, airlied@linux.ie, mripard@kernel.org,
        maarten.lankhorst@linux.intel.com, kernel@amanoeldawod.com,
        dirty.ice.hu@gmail.com, michael+lkml@stapelberg.ch,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>, stable@vger.kernel.org
References: <20211004081506.6791-1-tzimmermann@suse.de>
 <YVq6AffkPKB62aGF@intel.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <YVq6AffkPKB62aGF@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------jAtEdaA0wphQtYTUxenTn7Iz"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------jAtEdaA0wphQtYTUxenTn7Iz
Content-Type: multipart/mixed; boundary="------------d4YgjXkEK013kUKfzC0yrJ0E";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: daniel@ffwll.ch, airlied@linux.ie, mripard@kernel.org,
 maarten.lankhorst@linux.intel.com, kernel@amanoeldawod.com,
 dirty.ice.hu@gmail.com, michael+lkml@stapelberg.ch,
 dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
 Maxime Ripard <maxime@cerno.tech>, stable@vger.kernel.org
Message-ID: <ffa85393-e76c-09e8-b4d2-b5c06523d014@suse.de>
Subject: Re: [PATCH] drm/fbdev: Clamp fbdev surface size if too large
References: <20211004081506.6791-1-tzimmermann@suse.de>
 <YVq6AffkPKB62aGF@intel.com>
In-Reply-To: <YVq6AffkPKB62aGF@intel.com>

--------------d4YgjXkEK013kUKfzC0yrJ0E
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMDQuMTAuMjEgdW0gMTA6MjMgc2NocmllYiBWaWxsZSBTeXJqw6Rsw6Q6DQo+
IE9uIE1vbiwgT2N0IDA0LCAyMDIxIGF0IDEwOjE1OjA2QU0gKzAyMDAsIFRob21hcyBaaW1t
ZXJtYW5uIHdyb3RlOg0KPj4gQ2xhbXAgdGhlIGZiZGV2IHN1cmZhY2Ugc2l6ZSBvZiB0aGUg
YXZhaWxhYmxlIG1heGltdW0gaGVpZ2h0IHRvIGF2b2lkDQo+PiBmYWlsaW5nIHRvIGluaXQg
Y29uc29sZSBlbXVsYXRpb24uIEFuIGV4YW1wbGUgZXJyb3IgaXMgc2hvd24gYmVsb3cuDQo+
Pg0KPj4gICAgYmFkIGZyYW1lYnVmZmVyIGhlaWdodCAyMzA0LCBzaG91bGQgYmUgPj0gNzY4
ICYmIDw9IDc2OA0KPj4gICAgW2RybV0gSW5pdGlhbGl6ZWQgc2ltcGxlZHJtIDEuMC4wIDIw
MjAwNjI1IGZvciBzaW1wbGUtZnJhbWVidWZmZXIuMCBvbiBtaW5vciAwDQo+PiAgICBzaW1w
bGUtZnJhbWVidWZmZXIgc2ltcGxlLWZyYW1lYnVmZmVyLjA6IFtkcm1dICpFUlJPUiogZmJk
ZXY6IEZhaWxlZCB0byBzZXR1cCBnZW5lcmljIGVtdWxhdGlvbiAocmV0PS0yMikNCj4+DQo+
PiBUaGlzIGlzIGVzcGVjaWFsbHkgYSBwcm9ibGVtIHdpdGggZHJpdmVycyB0aGF0IGhhdmUg
dmVyeSBzbWFsbCBzY3JlZW4NCj4+IHNpemVzIGFuZCBjYW5ub3Qgb3Zlci1hbGxvY2F0ZSBh
dCBhbGwuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogVGhvbWFzIFppbW1lcm1hbm4gPHR6aW1t
ZXJtYW5uQHN1c2UuZGU+DQo+PiBGaXhlczogMTFlOGY1ZmQyMjNiICgiZHJtOiBBZGQgc2lt
cGxlZHJtIGRyaXZlciIpDQo+PiBSZXBvcnRlZC1ieTogQW1hbm9lbCBEYXdvZCA8a2VybmVs
QGFtYW5vZWxkYXdvZC5jb20+DQo+PiBSZXBvcnRlZC1ieTogWm9sdMOhbiBLxZF2w6Fnw7Mg
PGRpcnR5LmljZS5odUBnbWFpbC5jb20+DQo+PiBSZXBvcnRlZC1ieTogTWljaGFlbCBTdGFw
ZWxiZXJnIDxtaWNoYWVsK2xrbWxAc3RhcGVsYmVyZy5jaD4NCj4+IENjOiBEYW5pZWwgVmV0
dGVyIDxkYW5pZWwudmV0dGVyQGZmd2xsLmNoPg0KPj4gQ2M6IE1heGltZSBSaXBhcmQgPG1h
eGltZUBjZXJuby50ZWNoPg0KPj4gQ2M6IGRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5v
cmcNCj4+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NS4xNCsNCj4+IC0tLQ0K
Pj4gICBkcml2ZXJzL2dwdS9kcm0vZHJtX2ZiX2hlbHBlci5jIHwgNiArKysrKysNCj4+ICAg
MSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL2dwdS9kcm0vZHJtX2ZiX2hlbHBlci5jIGIvZHJpdmVycy9ncHUvZHJtL2RybV9m
Yl9oZWxwZXIuYw0KPj4gaW5kZXggNjg2MDIyM2YwMDY4Li4zNjRmMTE5MDBiMzcgMTAwNjQ0
DQo+PiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vZHJtX2ZiX2hlbHBlci5jDQo+PiArKysgYi9k
cml2ZXJzL2dwdS9kcm0vZHJtX2ZiX2hlbHBlci5jDQo+PiBAQCAtMTUwOCw2ICsxNTA4LDcg
QEAgc3RhdGljIGludCBkcm1fZmJfaGVscGVyX3NpbmdsZV9mYl9wcm9iZShzdHJ1Y3QgZHJt
X2ZiX2hlbHBlciAqZmJfaGVscGVyLA0KPj4gICB7DQo+PiAgIAlzdHJ1Y3QgZHJtX2NsaWVu
dF9kZXYgKmNsaWVudCA9ICZmYl9oZWxwZXItPmNsaWVudDsNCj4+ICAgCXN0cnVjdCBkcm1f
ZGV2aWNlICpkZXYgPSBmYl9oZWxwZXItPmRldjsNCj4+ICsJc3RydWN0IGRybV9tb2RlX2Nv
bmZpZyAqY29uZmlnID0gJmRldi0+bW9kZV9jb25maWc7DQo+PiAgIAlpbnQgcmV0ID0gMDsN
Cj4+ICAgCWludCBjcnRjX2NvdW50ID0gMDsNCj4+ICAgCXN0cnVjdCBkcm1fY29ubmVjdG9y
X2xpc3RfaXRlciBjb25uX2l0ZXI7DQo+PiBAQCAtMTY2NSw2ICsxNjY2LDExIEBAIHN0YXRp
YyBpbnQgZHJtX2ZiX2hlbHBlcl9zaW5nbGVfZmJfcHJvYmUoc3RydWN0IGRybV9mYl9oZWxw
ZXIgKmZiX2hlbHBlciwNCj4+ICAgCS8qIEhhbmRsZSBvdXIgb3ZlcmFsbG9jYXRpb24gKi8N
Cj4+ICAgCXNpemVzLnN1cmZhY2VfaGVpZ2h0ICo9IGRybV9mYmRldl9vdmVyYWxsb2M7DQo+
PiAgIAlzaXplcy5zdXJmYWNlX2hlaWdodCAvPSAxMDA7DQo+PiArCWlmIChzaXplcy5zdXJm
YWNlX2hlaWdodCA+IGNvbmZpZy0+bWF4X2hlaWdodCkgew0KPj4gKwkJZHJtX3dhcm4oZGV2
LCAiRmJkZXYgb3Zlci1hbGxvY2F0aW9uIHRvbyBsYXJnZTsgY2xhbXBpbmcgaGVpZ2h0IHRv
ICVkXG4iLA0KPj4gKwkJCSBjb25maWctPm1heF9oZWlnaHQpOw0KPiANCj4gZHJtX3dhcm4o
KSBzZWVtcyBhIGJpdCBleGNlc3NpdmUuIGRybV9pbmZvKCk/DQo+IA0KPiBPciBjb3VsZCBq
dXN0IGhhdmUgbm8gcHJpbnRrIGFuZCB1c2UgYSBzaW1wbGUgbWluKCkgcGVyaGFwcy4NCg0K
VGhlIGZyYW1lYnVmZmVyIGNvZGUgdXNlcyBkZWJ1Z19rbXMgZm9yIHRoaXMga2luZCBvZiBt
ZXNzYWdlLiBJIGd1ZXNzLCANCkknbGwgZ28gd2l0aCB0aGF0Lg0KDQpCZXN0IHJlZ2FyZHMN
ClRoYW1hcw0KDQo+IA0KPj4gKwkJc2l6ZXMuc3VyZmFjZV9oZWlnaHQgPSBjb25maWctPm1h
eF9oZWlnaHQ7DQo+PiArCX0NCj4+DQo+PiAgIAkvKiBwdXNoIGRvd24gaW50byBkcml2ZXJz
ICovDQo+PiAgIAlyZXQgPSAoKmZiX2hlbHBlci0+ZnVuY3MtPmZiX3Byb2JlKShmYl9oZWxw
ZXIsICZzaXplcyk7DQo+PiAtLQ0KPj4gMi4zMy4wDQo+IA0KDQotLSANClRob21hcyBaaW1t
ZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0
aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2Vy
bWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEZl
bGl4IEltZW5kw7ZyZmZlcg0K

--------------d4YgjXkEK013kUKfzC0yrJ0E--

--------------jAtEdaA0wphQtYTUxenTn7Iz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmFb9isFAwAAAAAACgkQlh/E3EQov+Bs
JBAAhgMMAHYdEx8NPJRfJSabnoKUrgFuasbCir1O6p4sQiBvTEROhFOi+AGOMvH104Tl3QjKVni7
Us7vK2YgTFXVWCSAksz+YIkg55l/WcBlgdasnv2aFNMpHR+FG1Q9alBBdaQzYV+qapWAPtmtdicb
tEUb6TbOxji/x6izqTZfS/jOWoFRtW5Gut9I+GKMBr/0ZQpe6ZueIvz+rJOHAePGEoil3BKRqt7M
haR1i3kKY5HIM1Md6CPgj+7aWFemAE2Akw4uKA3YxkQyb4RBTTdXXzlKZ/b4yBDKvz6rcif0bhiY
5mMCnL8F3h0Hm6aRK6Nqurg0l/mM8DroozuyOehjBuXF/t/IsEw07yL9KBiU9IMANIGKbi9lMm3k
FYBoZjdMslgmqpjwJyC5QvcQWoWGXPpsA80mGp0HJXyCOpwX15PEWOoiTGtRcmgQNUr/5cffhTcV
OTPpnSerUak91K2s2BRswYqSQ01RUDDZUlZ3IkUQGVOlxb7aSc59lP2kNE5ynQG4Or652AyITswd
7TtB1ddX0PjNFwD5WsSjcKefYdaXXCS5o33ibJkp4SsZCgoaMxOzxdXwsRRVeXOpYY/ZyuzKWsjk
V3kgw6meuQ3a08jc4GDMAqBBNl545po6fAxddnL8/u4+HPGhh2xQvEy5DqUjqMxF/ylRx1fpXAjO
irQ=
=J0Yv
-----END PGP SIGNATURE-----

--------------jAtEdaA0wphQtYTUxenTn7Iz--
