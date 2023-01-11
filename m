Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF17E666051
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 17:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjAKQXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 11:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbjAKQXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 11:23:20 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF483D5C6
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 08:20:32 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A5CFF4DEB;
        Wed, 11 Jan 2023 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673454001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=58f0LLfbqxSo7X5EEbErmWGaVVMVjGGLJJwU7gW14+w=;
        b=f5EkiFGX6rNk7HoAujbfxpf6UvHaEwcQZ8M7ra5rnWcH3Vp6ykdUNWQHOvkPffgRxgm26H
        m4izapSsbsLyQZ47mQQvTc6DmovgBFWVWt/g81detfu1csmi7dUH+SzWZjTZmeVzPGmN0/
        +BqJD2Sln9h8l8CEv2YTm5IwUl8WBmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673454001;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=58f0LLfbqxSo7X5EEbErmWGaVVMVjGGLJJwU7gW14+w=;
        b=Lhz4WyHUzHXn/WYCX6ZOc05vuE4y7B3wBFa+/p3bzVc4KP8jel1VpOi6sgZ9JVybreIEs6
        2sT8dR1NoEurX8Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69C971358A;
        Wed, 11 Jan 2023 16:20:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bGi8GLHhvmOlTwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 11 Jan 2023 16:20:01 +0000
Message-ID: <2102a618-2d5e-c286-311f-30e4baa4f85b@suse.de>
Date:   Wed, 11 Jan 2023 17:20:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 11/11] video/aperture: Only remove sysfb on the default
 vga pci device
Content-Language: en-US
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Aaron Plattner <aplattner@nvidia.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>, Helge Deller <deller@gmx.de>
References: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
 <20230111154112.90575-11-daniel.vetter@ffwll.ch>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20230111154112.90575-11-daniel.vetter@ffwll.ch>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Ml6ObZcRSbozD0DLMa0dlELb"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Ml6ObZcRSbozD0DLMa0dlELb
Content-Type: multipart/mixed; boundary="------------Yx1hdsmghhcaCcyvaTGQcYBc";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
 DRI Development <dri-devel@lists.freedesktop.org>
Cc: Aaron Plattner <aplattner@nvidia.com>,
 Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
 LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 Javier Martinez Canillas <javierm@redhat.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 Daniel Vetter <daniel.vetter@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
 Helge Deller <deller@gmx.de>
Message-ID: <2102a618-2d5e-c286-311f-30e4baa4f85b@suse.de>
Subject: Re: [PATCH 11/11] video/aperture: Only remove sysfb on the default
 vga pci device
References: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
 <20230111154112.90575-11-daniel.vetter@ffwll.ch>
In-Reply-To: <20230111154112.90575-11-daniel.vetter@ffwll.ch>

--------------Yx1hdsmghhcaCcyvaTGQcYBc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTEuMDEuMjMgdW0gMTY6NDEgc2NocmllYiBEYW5pZWwgVmV0dGVyOg0KPiBU
aGlzIGZpeGVzIGEgcmVncmVzc2lvbiBpbnRyb2R1Y2VkIGJ5IGVlN2E2OWFhMzhkOCAoImZi
ZGV2OiBEaXNhYmxlDQo+IHN5c2ZiIGRldmljZSByZWdpc3RyYXRpb24gd2hlbiByZW1vdmlu
ZyBjb25mbGljdGluZyBGQnMiKSwgd2hlcmUgd2UNCj4gcmVtb3ZlIHRoZSBzeXNmYiB3aGVu
IGxvYWRpbmcgYSBkcml2ZXIgZm9yIGFuIHVucmVsYXRlZCBwY2kgZGV2aWNlLA0KPiByZXN1
bHRpbmcgaW4gdGhlIHVzZXIgbG9vc2luZyB0aGVpciBlZmlmYiBjb25zb2xlIG9yIHNpbWls
YXIuDQo+IA0KPiBOb3RlIHRoYXQgaW4gcHJhY3RpY2UgdGhpcyBvbmx5IGlzIGEgcHJvYmxl
bSB3aXRoIHRoZSBudmlkaWEgYmxvYiwNCj4gYmVjYXVzZSB0aGF0J3MgdGhlIG9ubHkgZ3B1
IGRyaXZlciBwZW9wbGUgbWlnaHQgaW5zdGFsbCB3aGljaCBkb2VzIG5vdA0KPiBjb21lIHdp
dGggYW4gZmJkZXYgZHJpdmVyIG9mIGl0J3Mgb3duLiBGb3IgZXZlcnlvbmUgZWxzZSB0aGUg
cmVhbCBncHUNCj4gZHJpdmVyIHdpbGwgcmVzdG9yIGEgd29ya2luZyBjb25zb2xlLg0KPiAN
Cj4gQWxzbyBub3RlIHRoYXQgaW4gdGhlIHJlZmVyZW5jZWQgYnVnIHRoZXJlJ3MgY29uZnVz
aW9uIHRoYXQgdGhpcyBzYW1lDQo+IGJ1ZyBhbHNvIGhhcHBlbnMgb24gYW1kZ3B1LiBCdXQg
dGhhdCB3YXMganVzdCBhbm90aGVyIGFtZGdwdSBzcGVjaWZpYw0KPiByZWdyZXNzaW9uLCB3
aGljaCBqdXN0IGhhcHBlbmVkIHRvIGhhcHBlbiBhdCByb3VnaGx5IHRoZSBzYW1lIHRpbWUg
YW5kDQo+IHdpdGggdGhlIHNhbWUgdXNlci1vYnNlcnZhYmxlIHN5bXB0b25zLiBUaGF0IGJ1
ZyBpcyBmaXhlZCBub3csIHNlZQ0KPiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hv
d19idWcuY2dpP2lkPTIxNjMzMSNjMTUNCj4gDQo+IEZvciB0aGUgYWJvdmUgcmVhc29ucyB0
aGUgY2M6IHN0YWJsZSBpcyBqdXN0IG5vdGlvbmFsbHksIHRoaXMgcGF0Y2gNCj4gd2lsbCBu
ZWVkIGEgYmFja3BvcnQgYW5kIHRoYXQncyB1cCB0byBudmlkaWEgaWYgdGhleSBjYXJlIGVu
b3VnaC4NCj4gDQo+IFJlZmVyZW5jZXM6IGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9z
aG93X2J1Zy5jZ2k/aWQ9MjE2MzAzI2MyOA0KPiBTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgVmV0
dGVyIDxkYW5pZWwudmV0dGVyQGludGVsLmNvbT4NCj4gQ2M6IEFhcm9uIFBsYXR0bmVyIDxh
cGxhdHRuZXJAbnZpZGlhLmNvbT4NCj4gQ2M6IEphdmllciBNYXJ0aW5leiBDYW5pbGxhcyA8
amF2aWVybUByZWRoYXQuY29tPg0KPiBDYzogVGhvbWFzIFppbW1lcm1hbm4gPHR6aW1tZXJt
YW5uQHN1c2UuZGU+DQo+IENjOiBIZWxnZSBEZWxsZXIgPGRlbGxlckBnbXguZGU+DQo+IENj
OiBTYW0gUmF2bmJvcmcgPHNhbUByYXZuYm9yZy5vcmc+DQo+IENjOiBBbGV4IERldWNoZXIg
PGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVs
Lm9yZz4gIyB2NS4xOSsgKGlmIHNvbWVvbmUgZWxzZSBkb2VzIHRoZSBiYWNrcG9ydCkNCj4g
LS0tDQo+ICAgZHJpdmVycy92aWRlby9hcGVydHVyZS5jIHwgNyArKysrLS0tDQo+ICAgMSBm
aWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVvL2FwZXJ0dXJlLmMgYi9kcml2ZXJzL3ZpZGVvL2Fw
ZXJ0dXJlLmMNCj4gaW5kZXggYmE1NjU1MTU0ODBkLi5hMTgyMWQzNjliYjEgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvdmlkZW8vYXBlcnR1cmUuYw0KPiArKysgYi9kcml2ZXJzL3ZpZGVv
L2FwZXJ0dXJlLmMNCj4gQEAgLTMyMSwxNSArMzIxLDE2IEBAIGludCBhcGVydHVyZV9yZW1v
dmVfY29uZmxpY3RpbmdfcGNpX2RldmljZXMoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0
IGNoYXIgKm5hDQo+ICAgDQo+ICAgCXByaW1hcnkgPSBwZGV2ID09IHZnYV9kZWZhdWx0X2Rl
dmljZSgpOw0KPiAgIA0KPiArCWlmIChwcmltYXJ5KQ0KPiArCQlzeXNmYl9kaXNhYmxlKCk7
DQo+ICsNCg0KVGhlcmUncyBhbm90aGVyIHN5c2ZiX2Rpc2FibGUoKSBpbiBhcGVydHVyZV9y
ZW1vdmVfY29uZmxpY3RpbmdfZGV2aWNlcygpIA0Kd2l0aG91dCB0aGUgYnJhbmNoIGJ1dCB3
aXRoIGEgbG9uZyBjb21tZW50LiAgSSBmaW5kIHRoaXMgc2xpZ2h0bHkgY29uZnVzaW5nLg0K
DQpJJ2QgcmF0aGVyIGFkZCBhIGJyYW5jaGVkIHN5c2ZiX2Rpc2FibGUoKSBwbHVzIHRoZSBj
b21tZW50ICB0byANCmFwZXJ0dXJlX2RldGFjaF9kZXZpY2VzKCkuIEFuZCB0aGVuIGFkZCBh
ICdwcmltYXJ5JyBwYXJhbWV0ZXIgdG8gDQphcGVydHVyZV9kZXRhY2hfZGV2aWNlcygpLiBJ
biBhcGVydHVyZV9yZW1vdmVfY29uZmxpY3RpbmdfZGV2aWNlcygpIHRoZSANCnBhcmFtZXRl
ciB3b3VsZCBiZSB1bmNvbmRpdGlvbmFsbHkgdHJ1ZS4NCg0KQmVzdCByZWdhcmRzDQpUaG9t
YXMNCg0KPiAgIAlmb3IgKGJhciA9IDA7IGJhciA8IFBDSV9TVERfTlVNX0JBUlM7ICsrYmFy
KSB7DQo+ICAgCQlpZiAoIShwY2lfcmVzb3VyY2VfZmxhZ3MocGRldiwgYmFyKSAmIElPUkVT
T1VSQ0VfTUVNKSkNCj4gICAJCQljb250aW51ZTsNCj4gICANCj4gICAJCWJhc2UgPSBwY2lf
cmVzb3VyY2Vfc3RhcnQocGRldiwgYmFyKTsNCj4gICAJCXNpemUgPSBwY2lfcmVzb3VyY2Vf
bGVuKHBkZXYsIGJhcik7DQo+IC0JCXJldCA9IGFwZXJ0dXJlX3JlbW92ZV9jb25mbGljdGlu
Z19kZXZpY2VzKGJhc2UsIHNpemUsIG5hbWUpOw0KPiAtCQlpZiAocmV0KQ0KPiAtCQkJcmV0
dXJuIHJldDsNCj4gKwkJYXBlcnR1cmVfZGV0YWNoX2RldmljZXMoYmFzZSwgc2l6ZSk7DQo+
ICAgCX0NCj4gICANCj4gICAJaWYgKCFwcmltYXJ5KQ0KDQotLSANClRob21hcyBaaW1tZXJt
YW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0aW9u
cyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2VybWFu
eQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBU
b3Rldg0K

--------------Yx1hdsmghhcaCcyvaTGQcYBc--

--------------Ml6ObZcRSbozD0DLMa0dlELb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmO+4bAFAwAAAAAACgkQlh/E3EQov+A0
Dg//cjhjyvyNrq1Unm9x1sHYxc3/gIlRODM1tEoT7vAIxsRVimAF4vTjEFoqaD7oZxqeABXOfWUh
HQu72Jd4pzI/NGWVr+N1I8vFQEa98xdFUaE2t/yGNmGjJMiUQbXjbhjj7UpbyB7dH/XKoamEHjfT
dbpW2p8TRxbKZzW0lAcQVhwGbn/ad+AEepfrhKzUdU1GxNQKuPr3MiOavtckZ2kfMZ++zpiZeKhr
4KX4mUj+PWCwaB8Fd/OWGdCk9M8MpomSBvmFWT/1PCOvgXOWbf/0lsX1RomclDg4H/j5aoUC8JD7
D+Em3WQr231VORCXnAXBv3qNrtBeywGAe0sGMAmzcdX1PUi0wB3jFv+8EZfdNMRchlyjDjtkJ81f
H+eVVnYKT2IcNg5oTs/Uw/cczQ6oo4djULK8Fa1gqu6o5dl0L5ijlw9Na38I9fEDEa8UXBtjfohV
96fT+/xQaIiX2iv/2rXkmNzQtcWjl3885Apo4/kp/AEqDdSlhOoSlL6RbzRTxQnFjy8e7sA38WMh
4aLBJ/r1yR+TY0Irv2z/gEtyKDOaTzkAUp6z1AA5PeKylY6ySOR6YfGrNaI2mOCHMF4QGiMcgFTa
+2MxZzQOohfmIzBWi+pcWH5lDpYa6DwMtuv8Xv5y+2yCcKavJSsGldKbTTeTLEsneDWqhtAKWA4c
buU=
=MQ26
-----END PGP SIGNATURE-----

--------------Ml6ObZcRSbozD0DLMa0dlELb--
