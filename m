Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FE9666BCF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 08:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbjALHtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 02:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236504AbjALHtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 02:49:02 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF876383;
        Wed, 11 Jan 2023 23:48:55 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6861E3F4E2;
        Thu, 12 Jan 2023 07:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673509733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xi2BwY8yl2B+ViodWR887rTUtArSL6+29bcwhigQIgM=;
        b=sWMtWNgmFQNCdRHP4Gsh1CVsFK/JarnGb6yW73gRk+6Yo0uGNaSgdRol6XS5M/Cg8TWT4c
        vHrPyI+GW04AkG6eVhdnU4FvVLfDbMQE0hqxKXvdROtzaXB6FmLywK5jp2j+b4JzFK93og
        csfVm1GWQg6jTSPtiIMFd1rVZmAeKX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673509733;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xi2BwY8yl2B+ViodWR887rTUtArSL6+29bcwhigQIgM=;
        b=xrkPZXj3Xdghvu/ZEjm3KvAca0T8qDFp+1spKpmgn8Hob444GuIJrD7BKD9S5WihbmBIxb
        IITy3Gwd2XsGdbCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3411A134B3;
        Thu, 12 Jan 2023 07:48:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EoO/C2W7v2OvXQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 12 Jan 2023 07:48:53 +0000
Message-ID: <2117daa3-f26e-12c9-865c-42bd9c5b43ad@suse.de>
Date:   Thu, 12 Jan 2023 08:48:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 11/11] video/aperture: Only remove sysfb on the default
 vga pci device
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        Aaron Plattner <aplattner@nvidia.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>, Helge Deller <deller@gmx.de>
References: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
 <20230111154112.90575-11-daniel.vetter@ffwll.ch>
 <2102a618-2d5e-c286-311f-30e4baa4f85b@suse.de>
 <Y77lyzPOUt8JAyPX@phenom.ffwll.local>
Content-Language: en-US
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <Y77lyzPOUt8JAyPX@phenom.ffwll.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------czYDWnMyz4yPK2pl7Wts69G6"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------czYDWnMyz4yPK2pl7Wts69G6
Content-Type: multipart/mixed; boundary="------------yppo0wLp00b20lZ8SNCH2jHD";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: DRI Development <dri-devel@lists.freedesktop.org>,
 Aaron Plattner <aplattner@nvidia.com>,
 Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
 LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 Javier Martinez Canillas <javierm@redhat.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 Daniel Vetter <daniel.vetter@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
 Helge Deller <deller@gmx.de>
Message-ID: <2117daa3-f26e-12c9-865c-42bd9c5b43ad@suse.de>
Subject: Re: [PATCH 11/11] video/aperture: Only remove sysfb on the default
 vga pci device
References: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
 <20230111154112.90575-11-daniel.vetter@ffwll.ch>
 <2102a618-2d5e-c286-311f-30e4baa4f85b@suse.de>
 <Y77lyzPOUt8JAyPX@phenom.ffwll.local>
In-Reply-To: <Y77lyzPOUt8JAyPX@phenom.ffwll.local>

--------------yppo0wLp00b20lZ8SNCH2jHD
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTEuMDEuMjMgdW0gMTc6Mzcgc2NocmllYiBEYW5pZWwgVmV0dGVyOg0KPiBP
biBXZWQsIEphbiAxMSwgMjAyMyBhdCAwNToyMDowMFBNICswMTAwLCBUaG9tYXMgWmltbWVy
bWFubiB3cm90ZToNCj4+IEhpDQo+Pg0KPj4gQW0gMTEuMDEuMjMgdW0gMTY6NDEgc2Nocmll
YiBEYW5pZWwgVmV0dGVyOg0KPj4+IFRoaXMgZml4ZXMgYSByZWdyZXNzaW9uIGludHJvZHVj
ZWQgYnkgZWU3YTY5YWEzOGQ4ICgiZmJkZXY6IERpc2FibGUNCj4+PiBzeXNmYiBkZXZpY2Ug
cmVnaXN0cmF0aW9uIHdoZW4gcmVtb3ZpbmcgY29uZmxpY3RpbmcgRkJzIiksIHdoZXJlIHdl
DQo+Pj4gcmVtb3ZlIHRoZSBzeXNmYiB3aGVuIGxvYWRpbmcgYSBkcml2ZXIgZm9yIGFuIHVu
cmVsYXRlZCBwY2kgZGV2aWNlLA0KPj4+IHJlc3VsdGluZyBpbiB0aGUgdXNlciBsb29zaW5n
IHRoZWlyIGVmaWZiIGNvbnNvbGUgb3Igc2ltaWxhci4NCj4+Pg0KPj4+IE5vdGUgdGhhdCBp
biBwcmFjdGljZSB0aGlzIG9ubHkgaXMgYSBwcm9ibGVtIHdpdGggdGhlIG52aWRpYSBibG9i
LA0KPj4+IGJlY2F1c2UgdGhhdCdzIHRoZSBvbmx5IGdwdSBkcml2ZXIgcGVvcGxlIG1pZ2h0
IGluc3RhbGwgd2hpY2ggZG9lcyBub3QNCj4+PiBjb21lIHdpdGggYW4gZmJkZXYgZHJpdmVy
IG9mIGl0J3Mgb3duLiBGb3IgZXZlcnlvbmUgZWxzZSB0aGUgcmVhbCBncHUNCj4+PiBkcml2
ZXIgd2lsbCByZXN0b3IgYSB3b3JraW5nIGNvbnNvbGUuDQo+Pj4NCj4+PiBBbHNvIG5vdGUg
dGhhdCBpbiB0aGUgcmVmZXJlbmNlZCBidWcgdGhlcmUncyBjb25mdXNpb24gdGhhdCB0aGlz
IHNhbWUNCj4+PiBidWcgYWxzbyBoYXBwZW5zIG9uIGFtZGdwdS4gQnV0IHRoYXQgd2FzIGp1
c3QgYW5vdGhlciBhbWRncHUgc3BlY2lmaWMNCj4+PiByZWdyZXNzaW9uLCB3aGljaCBqdXN0
IGhhcHBlbmVkIHRvIGhhcHBlbiBhdCByb3VnaGx5IHRoZSBzYW1lIHRpbWUgYW5kDQo+Pj4g
d2l0aCB0aGUgc2FtZSB1c2VyLW9ic2VydmFibGUgc3ltcHRvbnMuIFRoYXQgYnVnIGlzIGZp
eGVkIG5vdywgc2VlDQo+Pj4gaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVn
LmNnaT9pZD0yMTYzMzEjYzE1DQo+Pj4NCj4+PiBGb3IgdGhlIGFib3ZlIHJlYXNvbnMgdGhl
IGNjOiBzdGFibGUgaXMganVzdCBub3Rpb25hbGx5LCB0aGlzIHBhdGNoDQo+Pj4gd2lsbCBu
ZWVkIGEgYmFja3BvcnQgYW5kIHRoYXQncyB1cCB0byBudmlkaWEgaWYgdGhleSBjYXJlIGVu
b3VnaC4NCj4+Pg0KPj4+IFJlZmVyZW5jZXM6IGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9y
Zy9zaG93X2J1Zy5jZ2k/aWQ9MjE2MzAzI2MyOA0KPj4+IFNpZ25lZC1vZmYtYnk6IERhbmll
bCBWZXR0ZXIgPGRhbmllbC52ZXR0ZXJAaW50ZWwuY29tPg0KPj4+IENjOiBBYXJvbiBQbGF0
dG5lciA8YXBsYXR0bmVyQG52aWRpYS5jb20+DQo+Pj4gQ2M6IEphdmllciBNYXJ0aW5leiBD
YW5pbGxhcyA8amF2aWVybUByZWRoYXQuY29tPg0KPj4+IENjOiBUaG9tYXMgWmltbWVybWFu
biA8dHppbW1lcm1hbm5Ac3VzZS5kZT4NCj4+PiBDYzogSGVsZ2UgRGVsbGVyIDxkZWxsZXJA
Z214LmRlPg0KPj4+IENjOiBTYW0gUmF2bmJvcmcgPHNhbUByYXZuYm9yZy5vcmc+DQo+Pj4g
Q2M6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4+PiBDYzog
PHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjUuMTkrIChpZiBzb21lb25lIGVsc2UgZG9l
cyB0aGUgYmFja3BvcnQpDQo+Pj4gLS0tDQo+Pj4gICAgZHJpdmVycy92aWRlby9hcGVydHVy
ZS5jIHwgNyArKysrLS0tDQo+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVv
L2FwZXJ0dXJlLmMgYi9kcml2ZXJzL3ZpZGVvL2FwZXJ0dXJlLmMNCj4+PiBpbmRleCBiYTU2
NTUxNTQ4MGQuLmExODIxZDM2OWJiMSAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL3ZpZGVv
L2FwZXJ0dXJlLmMNCj4+PiArKysgYi9kcml2ZXJzL3ZpZGVvL2FwZXJ0dXJlLmMNCj4+PiBA
QCAtMzIxLDE1ICszMjEsMTYgQEAgaW50IGFwZXJ0dXJlX3JlbW92ZV9jb25mbGljdGluZ19w
Y2lfZGV2aWNlcyhzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3QgY2hhciAqbmENCj4+PiAg
ICAJcHJpbWFyeSA9IHBkZXYgPT0gdmdhX2RlZmF1bHRfZGV2aWNlKCk7DQo+Pj4gKwlpZiAo
cHJpbWFyeSkNCj4+PiArCQlzeXNmYl9kaXNhYmxlKCk7DQo+Pj4gKw0KPj4NCj4+IFRoZXJl
J3MgYW5vdGhlciBzeXNmYl9kaXNhYmxlKCkgaW4gYXBlcnR1cmVfcmVtb3ZlX2NvbmZsaWN0
aW5nX2RldmljZXMoKQ0KPj4gd2l0aG91dCB0aGUgYnJhbmNoIGJ1dCB3aXRoIGEgbG9uZyBj
b21tZW50LiAgSSBmaW5kIHRoaXMgc2xpZ2h0bHkgY29uZnVzaW5nLg0KPj4NCj4+IEknZCBy
YXRoZXIgYWRkIGEgYnJhbmNoZWQgc3lzZmJfZGlzYWJsZSgpIHBsdXMgdGhlIGNvbW1lbnQg
IHRvDQo+PiBhcGVydHVyZV9kZXRhY2hfZGV2aWNlcygpLiBBbmQgdGhlbiBhZGQgYSAncHJp
bWFyeScgcGFyYW1ldGVyIHRvDQo+PiBhcGVydHVyZV9kZXRhY2hfZGV2aWNlcygpLiBJbiBh
cGVydHVyZV9yZW1vdmVfY29uZmxpY3RpbmdfZGV2aWNlcygpIHRoZQ0KPj4gcGFyYW1ldGVy
IHdvdWxkIGJlIHVuY29uZGl0aW9uYWxseSB0cnVlLg0KPiANCj4gWWVhaCBJIHdhcyBvbiB0
aGUgZmVuY2UsIGJ1dCBzaG91bGQgYmUgZWFzeSB0byByZWRvIHdpdGggYWxsIHRoZSBwcmVw
IHdvcmsNCj4gb3V0IG9mIHRoZSB3YXkuIEl0IGRvZXMgbWVhbiB3ZSBjYWxsIHN5c2ZiX2Rp
c2FibGUgb25jZSBmb3IgZXZlcnkgYmFyLCBidXQNCj4gdGhhdCBzaG91bGRuJ3QgbWF0dGVy
IGluIGFueSByZWFzb25hYmxlIGNhc2UgOi0pDQoNCk9yIGxlYXZlIGl0IGFzIGlzLiBJdCdz
IG5vdCBzbyBpbXBvcnRhbnQuIFRoZSBpZGVhIG9mIHRoZSBjdXJyZW50IGRlc2lnbiANCndh
cyB0aGF0IGFwZXJ0dXJlX3JlbW92ZV9jb25mbGljdGluZ19kZXZpY2UoKSB3b3VsZCBiZSB0
aGUgZ2VuZXJhbCANCmltcGxlbWVudGF0aW9uIGFuZCBhcGVydHVyZV9yZW1vdmVfY29uZmxp
Y3RpbmdfcGNpX2RldmljZSgpIHdvdWxkIGJlIGEgDQpoZWxwZXIgdGhhdCBvbmx5IGRldGVj
dHMgdGhlIGNvcnJlY3QgUENJIEJBUi4gVGhhdCBuZXZlciByZWFsbHkgd29ya2VkIA0KaW4g
cHJhY3RpY2UuDQoNCkJlc3QgcmVnYXJkcw0KVGhvbWFzDQoNCj4gLURhbmllbA0KPiANCj4+
DQo+PiBCZXN0IHJlZ2FyZHMNCj4+IFRob21hcw0KPj4NCj4+PiAgICAJZm9yIChiYXIgPSAw
OyBiYXIgPCBQQ0lfU1REX05VTV9CQVJTOyArK2Jhcikgew0KPj4+ICAgIAkJaWYgKCEocGNp
X3Jlc291cmNlX2ZsYWdzKHBkZXYsIGJhcikgJiBJT1JFU09VUkNFX01FTSkpDQo+Pj4gICAg
CQkJY29udGludWU7DQo+Pj4gICAgCQliYXNlID0gcGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYs
IGJhcik7DQo+Pj4gICAgCQlzaXplID0gcGNpX3Jlc291cmNlX2xlbihwZGV2LCBiYXIpOw0K
Pj4+IC0JCXJldCA9IGFwZXJ0dXJlX3JlbW92ZV9jb25mbGljdGluZ19kZXZpY2VzKGJhc2Us
IHNpemUsIG5hbWUpOw0KPj4+IC0JCWlmIChyZXQpDQo+Pj4gLQkJCXJldHVybiByZXQ7DQo+
Pj4gKwkJYXBlcnR1cmVfZGV0YWNoX2RldmljZXMoYmFzZSwgc2l6ZSk7DQo+Pj4gICAgCX0N
Cj4+PiAgICAJaWYgKCFwcmltYXJ5KQ0KPj4NCj4+IC0tIA0KPj4gVGhvbWFzIFppbW1lcm1h
bm4NCj4+IEdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXINCj4+IFNVU0UgU29mdHdhcmUgU29s
dXRpb25zIEdlcm1hbnkgR21iSA0KPj4gTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJn
LCBHZXJtYW55DQo+PiAoSFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQo+PiBHZXNjaMOkZnRz
ZsO8aHJlcjogSXZvIFRvdGV2DQo+IA0KPiANCj4gDQo+IA0KDQotLSANClRob21hcyBaaW1t
ZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0
aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2Vy
bWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEl2
byBUb3Rldg0K

--------------yppo0wLp00b20lZ8SNCH2jHD--

--------------czYDWnMyz4yPK2pl7Wts69G6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmO/u2QFAwAAAAAACgkQlh/E3EQov+AX
WA//XQF31tRtAr1HhSwyNjff3SiRnUIbMHJiz2X0CQ3xlUtyK6vrh3e3FH2Tdi60A5DD3guIbrgm
QdMr10BWwSPr8EIKXHf0VrdMBxKXABn3NjFRLoILvn2pezvMQMR7RfYBOsFT9HHHagm+Ypjq2+S2
62/zS99Cq6TmE9mO0nOxCAqp80aiw0bf7UCVHJkbrNuDHaEbzbEsX18sjTV/D/k9eRccnQE8Sw2d
qIgyWhxn9t0MB5ZMOo+T+9INrj5ykqJFNhzCGaIU8HKQCLos0RcjPGaHqKgPvb2AWXe99pJAogir
hN8LFsQqeJ/R47f0FsfvqizwU0ja/6mAUck+iv5cSD0XoemjNNgQJCFqdnIUvV90QKyWRTX3DN8b
1iJtlnMU1BMqfBY7eEU1GPlHX03KKUaMv+F8QOw6mxpIPK4IWBUkMKpMW7IgG61uxGKeJm2sCRwt
1opPqc4mt6OI6yhWekWwaPjbn5oxnhugLwdHu/Zo7QvAOpXVXdUAesXSDiOb9fKXPDnexSL0Q/n4
zgUEuKFZEVhR3ojrWwTx8wE+nLDeuN2wM0gDbNtsSeILPQsuwa6SM437+H/wX3g5N9kgIRDaMtXN
N9OqHoj0PQISQdMzC1EypILC/zbSfseti5ZF3L+L5Pf2iqLLgeKQVIrS22/xGH0pykOhzkh7mRhO
fH8=
=y1+G
-----END PGP SIGNATURE-----

--------------czYDWnMyz4yPK2pl7Wts69G6--
