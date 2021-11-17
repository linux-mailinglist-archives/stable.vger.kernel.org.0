Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A0D454961
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhKQO72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:59:28 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:50294 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhKQO72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 09:59:28 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1DA9D1FD29;
        Wed, 17 Nov 2021 14:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637160988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ULWNdZT5zgP0fGwSkrNsSz9dUlbgfDC0raAB8lnTGyI=;
        b=dXap3i/LQ8rKcslEtGg3eDHrpA+kh2arhleCPnxMCEFMEmJvxZPtc5Y4hXuMOOsVjWeQrZ
        SwSNDvGpdRaedbk2swj1E7/RoMp7JhsITJc6Zq8A57tsONAIvqlBEllGKFb7Z+1FwEAS5n
        iwB3Yi7aRJWknEbNMafeXKrZgkIjYBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637160988;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ULWNdZT5zgP0fGwSkrNsSz9dUlbgfDC0raAB8lnTGyI=;
        b=XBZz+jynCQc4WHLxeddgiEnZnFQCoHNbVvuxARUyir+hA0eFAvujhJLphALvrv8Dw3AxuE
        luduUBUnHChlnlAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DF74313AAD;
        Wed, 17 Nov 2021 14:56:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pGqBNRsYlWHDAgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 17 Nov 2021 14:56:27 +0000
Message-ID: <926ff1f6-2255-4e94-3a24-4fc78260f27d@suse.de>
Date:   Wed, 17 Nov 2021 15:56:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] drm/format-helper: Fix dst computation in
 drm_fb_xrgb8888_to_rgb888_dstclip()
Content-Language: en-US
To:     Hector Martin <marcan@marcan.st>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <20211117142206.197575-1-marcan@marcan.st>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20211117142206.197575-1-marcan@marcan.st>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8vBjnha6aQYVQUWNP8QSQK2i"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8vBjnha6aQYVQUWNP8QSQK2i
Content-Type: multipart/mixed; boundary="------------WtMvvewvWP9vwKls04kxjvwh";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Hector Martin <marcan@marcan.st>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@linux.ie>,
 Daniel Vetter <daniel@ffwll.ch>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org
Message-ID: <926ff1f6-2255-4e94-3a24-4fc78260f27d@suse.de>
Subject: Re: [PATCH] drm/format-helper: Fix dst computation in
 drm_fb_xrgb8888_to_rgb888_dstclip()
References: <20211117142206.197575-1-marcan@marcan.st>
In-Reply-To: <20211117142206.197575-1-marcan@marcan.st>

--------------WtMvvewvWP9vwKls04kxjvwh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTcuMTEuMjEgdW0gMTU6MjIgc2NocmllYiBIZWN0b3IgTWFydGluOg0KPiBU
aGUgZHN0IHBvaW50ZXIgd2FzIGJlaW5nIGFkdmFuY2VkIGJ5IHRoZSBjbGlwIHdpZHRoLCBu
b3QgdGhlIGZ1bGwgbGluZQ0KPiBzdHJpZGUsIHJlc3VsdGluZyBpbiBjb3JydXB0aW9uLiBU
aGUgY2xpcCBvZmZzZXQgd2FzIGFsc28gY2FsY3VsYXRlZA0KPiBpbmNvcnJlY3RseS4NCj4g
DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IEhlY3Rv
ciBNYXJ0aW4gPG1hcmNhbkBtYXJjYW4uc3Q+DQoNClRoYW5rcyBmb3IgeW91ciBwYXRjaCwg
YnV0IHlvdSdyZSBwcm9iYWJseSBvbiB0aGUgd3JvbmcgYnJhbmNoLiBXZSANCnJld3JvdGUg
dGhpcyBjb2RlIHJlY2VudGx5IGFuZCBmaXhlZCB0aGUgaXNzdWUgaW4gZHJtLW1pc2MtbmV4
dC4gWzFdWzJdDQoNCklmIGFueXRoaW5nLCB0aGlzIHBhdGNoIGNvdWxkIGdvIGludG8gc3Rh
YmxlLiBJZiBhbnlvbmUgd2FudHMgdG8gbWVyZ2UgDQppdCB0aGVyZSwgdGhlbg0KDQpBY2tl
ZC1ieTogVGhvbWFzIFppbW1lcm1hbm4gPHR6aW1tZXJtYW5uQHN1c2UuZGU+DQoNCkJlc3Qg
cmVnYXJkcw0KVGhvbWFzDQoNClsxXSANCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2RyaS1k
ZXZlbC8yMDIxMTExMDEwMzcwMi4zNzQtNS10emltbWVybWFubkBzdXNlLmRlLw0KWzJdIA0K
aHR0cHM6Ly9jZ2l0LmZyZWVkZXNrdG9wLm9yZy9kcm0vZHJtLW1pc2MvY29tbWl0Lz9pZD01
M2JjMjA5OGQyYjZjY2ZmMjVmZTEzZjkzNDVjYmI1YzBlZjM0YTk5DQoNCj4gLS0tDQo+ICAg
ZHJpdmVycy9ncHUvZHJtL2RybV9mb3JtYXRfaGVscGVyLmMgfCA0ICsrLS0NCj4gICAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZm9ybWF0X2hlbHBlci5jIGIvZHJpdmVy
cy9ncHUvZHJtL2RybV9mb3JtYXRfaGVscGVyLmMNCj4gaW5kZXggZTY3NjkyMTQyMmI4Li4x
MmJjNmI0NWU5NWIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZm9ybWF0
X2hlbHBlci5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fZm9ybWF0X2hlbHBlci5j
DQo+IEBAIC0zNjYsMTIgKzM2NiwxMiBAQCB2b2lkIGRybV9mYl94cmdiODg4OF90b19yZ2I4
ODhfZHN0Y2xpcCh2b2lkIF9faW9tZW0gKmRzdCwgdW5zaWduZWQgaW50IGRzdF9waXRjaA0K
PiAgIAkJcmV0dXJuOw0KPiAgIA0KPiAgIAl2YWRkciArPSBjbGlwX29mZnNldChjbGlwLCBm
Yi0+cGl0Y2hlc1swXSwgc2l6ZW9mKHUzMikpOw0KPiAtCWRzdCArPSBjbGlwX29mZnNldChj
bGlwLCBkc3RfcGl0Y2gsIHNpemVvZih1MTYpKTsNCj4gKwlkc3QgKz0gY2xpcF9vZmZzZXQo
Y2xpcCwgZHN0X3BpdGNoLCAzKTsNCj4gICAJZm9yICh5ID0gMDsgeSA8IGxpbmVzOyB5Kysp
IHsNCj4gICAJCWRybV9mYl94cmdiODg4OF90b19yZ2I4ODhfbGluZShkYnVmLCB2YWRkciwg
bGluZXBpeGVscyk7DQo+ICAgCQltZW1jcHlfdG9pbyhkc3QsIGRidWYsIGRzdF9sZW4pOw0K
PiAgIAkJdmFkZHIgKz0gZmItPnBpdGNoZXNbMF07DQo+IC0JCWRzdCArPSBkc3RfbGVuOw0K
PiArCQlkc3QgKz0gZHN0X3BpdGNoOw0KPiAgIAl9DQo+ICAgDQo+ICAgCWtmcmVlKGRidWYp
Ow0KPiANCg0KLS0gDQpUaG9tYXMgWmltbWVybWFubg0KR3JhcGhpY3MgRHJpdmVyIERldmVs
b3Blcg0KU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFueSBHbWJIDQpNYXhmZWxkc3Ry
LiA1LCA5MDQwOSBOw7xybmJlcmcsIEdlcm1hbnkNCihIUkIgMzY4MDksIEFHIE7DvHJuYmVy
ZykNCkdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYNCg==

--------------WtMvvewvWP9vwKls04kxjvwh--

--------------8vBjnha6aQYVQUWNP8QSQK2i
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmGVGBsFAwAAAAAACgkQlh/E3EQov+AH
CQ//fGP23yvUugjceBxuGQTRrE2FzitmwCqi11IDCu/rVArqcX2nJdY8lplyHCxEGhOBFmaWGCmw
qbrklvJLXNrsTtbgwt7ErQfhOiopH8cJ9jHwT2DgFHQWb1Qfvuua8cfD19c1mG30uG6j+jah/RkI
1zd6V3w5LpjDxx8eP7B0yq0lLjvzlwAmk0RPFoj8Eq/CC6SDKF56Tb4K3J6tLkS7wE4CeTmDEauq
0iwBgvbKpW034NoSaX7sh3HaTUyZD0JUa98vaA1QH4NRbJfTo0qBf6V+/xVw2wBSn2nbj429j/AH
71s5/vcYXoBEMGu5JiTpeaFYDHNV6j8gfPXFjWSq8/pi32/eppH8pcxMUmQyfyLVrn1Wu8FX73v8
2dipo/FLrpW1pUyCFNhR6qvISTw+mmTVvRZxqPPh++YNGys7CUuwJCW58LPVytAmBMH1TZZXyObr
4U06vN9URHHpq7M4cNCq0JaobS+mRdEpqPn7BWIjPGcTUXCRfDJAGsGKE3AJvIlMtJciiQSr/lVB
F//XUam1NqgLla+WXrJHOTzlOxbI2E/DzwCl3u3DSObaaWdw8P0OeswM9/qx1FTjp3ZRGXSa4KRL
hMBbeLso8cRyhxaN/V/pNL5+O8Yze3brwCT4k+OQK1q4LJhpLZ0Hr6PCGcv9vQkVevC48aIukiKb
D7U=
=V3eb
-----END PGP SIGNATURE-----

--------------8vBjnha6aQYVQUWNP8QSQK2i--
