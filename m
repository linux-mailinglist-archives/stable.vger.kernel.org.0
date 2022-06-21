Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE09F552F7F
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346938AbiFUKPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346612AbiFUKPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:15:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE0A286D6
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:15:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A51BB21C81;
        Tue, 21 Jun 2022 10:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655806515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nbNjOb9EARl7wjFXvG2DLzGB0YdBzstKEkzlxNifsjk=;
        b=uBbzYZeJ/HlpWNV2GEaw6KPalYZ0ZZLqfvaKUj1Oh5JEVZUXdM7GfvtilxHAVAv0TtiHT2
        TEfmho4BFhh/IVZZ/p8UCnPlziWB9B42s7QPJPt5JcdXf53+Zl4p5a4oCsm2zTysDAtJdG
        M2D0FWDBSctnERCy2n69GXBpGD2j4ig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655806515;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nbNjOb9EARl7wjFXvG2DLzGB0YdBzstKEkzlxNifsjk=;
        b=M1TTKJn30VXSBfLjlHnK4uHgSWJ1Ac5FtTzsZHfMts4blVbfXTMww7hFq4cC9349iWBpYj
        SVjPYyart0jjNOBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6838413638;
        Tue, 21 Jun 2022 10:15:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vOnDFzOasWIfQgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 21 Jun 2022 10:15:15 +0000
Message-ID: <303b9f91-9214-5243-8224-a11953960839@suse.de>
Date:   Tue, 21 Jun 2022 12:15:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
Content-Language: en-US
To:     Daniel Vetter <daniel.vetter@ffwll.ch>, security@kernel.org
Cc:     =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@amd.com>,
        Daniel Stone <daniels@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        openeuler-security@openeuler.org, guodaxing@huawei.com,
        Weigang <weigang12@huawei.com>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------UQf5rTzU8rgrSpruom2PFEqP"
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
--------------UQf5rTzU8rgrSpruom2PFEqP
Content-Type: multipart/mixed; boundary="------------eanO3p0FNo2uXZ0UNk1saGUO";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, security@kernel.org
Cc: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@amd.com>,
 Daniel Stone <daniels@collabora.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org,
 Helge Deller <deller@gmx.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, openeuler-security@openeuler.org,
 guodaxing@huawei.com, Weigang <weigang12@huawei.com>,
 Daniel Vetter <daniel.vetter@intel.com>
Message-ID: <303b9f91-9214-5243-8224-a11953960839@suse.de>
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20220621092319.379049-1-daniel.vetter@ffwll.ch>

--------------eanO3p0FNo2uXZ0UNk1saGUO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjEuMDYuMjIgdW0gMTE6MjMgc2NocmllYiBEYW5pZWwgVmV0dGVyOg0KPiBU
aGUgZHJtIGZiZGV2IGVtdWxhdGlvbiBkb2VzIG5vdCBmb3J3YXJkIG1vZGUgY2hhbmdlcyB0
byB0aGUgZHJpdmVyLA0KPiBhbmQgaGVuY2UgYWxsIGNoYW5nZXMgd2hlcmUgcmVqZWN0ZWQg
aW4gODY1YWZiMTE5NDllICgiZHJtL2ZiLWhlbHBlcjoNCj4gcmVqZWN0IGFueSBjaGFuZ2Vz
IHRvIHRoZSBmYmRldiIpLg0KPiANCj4gVW5mb3J0dW5hdGVseSB0aGlzIHJlc3VsdGVkIGlu
IGJ1Z3Mgb24gbXVsdGlwbGUgbW9uaXRvciBzeXN0ZW1zIHdpdGgNCj4gZGlmZmVyZW50IHJl
c29sdXRpb25zLiBJbiB0aGF0IGNhc2UgdGhlIGZiZGV2IGVtdWxhdGlvbiBjb2RlIHNpemVz
IHRoZQ0KPiB1bmRlcmx5aW5nIGZyYW1lYnVmZmVyIGZvciB0aGUgbGFyZ2VzdCBzY3JlZW4g
KHdoaWNoIGRpY3RhdGVzDQo+IHgveXJlc192aXJ0dWFsKSwgYnV0IGFkanVzdCB0aGUgZmJk
ZXYgeC95cmVzIHRvIG1hdGNoIHRoZSBzbWFsbGVzdA0KPiByZXNvbHV0aW9uLiBUaGUgYWJv
dmUgbWVudGlvbmVkIHBhdGNoIGZhaWxlZCB0byByZWFsaXplIHRoYXQsIGFuZA0KPiBlcnJv
cm5vdXNseSB2YWxpZGF0ZWQgeC95cmVzIGFnYWluc3QgdGhlIGZiIGRpbWVuc2lvbnMuDQo+
IA0KPiBUaGlzIHdhcyBmaXhlZCBieSBqdXN0IGRyb3BwaW5nIHRoZSB2YWxpZGF0aW9uIGZv
ciB0b28gc21hbGwgc2l6ZXMsDQo+IHdoaWNoIHJlc3RvcmVkIHZ0IHN3aXRjaGluZyB3aXRo
IDEyZmZlZDk2ZDQzNiAoImRybS9mYi1oZWxwZXI6IEFsbG93DQo+IHZhci0+eC95cmVzKF92
aXJ0dWFsKSA8IGZiLT53aWR0aC9oZWlnaHQgYWdhaW4iKS4NCj4gDQo+IEJ1dCB0aGlzIGFs
c28gcmVzdG9yZWQgYWxsIGtpbmRzIG9mIHZhbGlkYXRpb24gaXNzdWVzIGFuZCB0aGVpcg0K
PiBmYWxsb3V0IGluIHRoZSBub3RvcmlvdXNseSBidWdneSBmYmNvbiBjb2RlIGZvciB0b28g
c21hbGwgc2l6ZXMuIFNpbmNlDQo+IG5vIG9uZSBpcyB2b2x1bnRlZXJpbmcgdG8gcmVhbGx5
IG1ha2UgZmJjb24gYW5kIHZjL3Z0IGZ1bGx5IHJvYnVzdA0KPiBhZ2FpbnN0IHRoZXNlIG1h
dGggaXNzdWVzIG1ha2Ugc3VyZSB0aGlzIGJhcm4gZG9vciBpcyBjbG9zZWQgZm9yIGdvb2QN
Cj4gYWdhaW4uDQo+IA0KPiBTaW5jZSBpdCdzIGEgYml0IHRyaWNreSB0byByZW1lbWJlciB0
aGUgeC95cmVzIHdlIHBpY2tlZCBhY3Jvc3MgYm90aA0KPiB0aGUgbmV3ZXIgZ2VuZXJpYyBm
YmRldiBlbXVsYXRpb24gYW5kIHRoZSBvbGRlciBjb2RlIHdpdGggbW9yZSBkcml2ZXINCj4g
aW52b2x2ZW1lbnQsIHdlIHNpbXBseSBjaGVjayB0aGF0IGl0IGRvZXNuJ3QgY2hhbmdlLiBU
aGlzIHJlbGllcyBvbg0KPiBkcm1fZmJfaGVscGVyX2ZpbGxfdmFyKCkgaGF2aW5nIGRvbmUg
dGhpbmdzIGNvcnJlY3RseSwgYW5kIG5vdGhpbmcNCj4gaGF2aW5nIHRyYW1wbGVkIGl0IHll
dC4NCj4gDQo+IE5vdGUgdGhhdCB0aGlzIGxlYXZlcyBhbGwgdGhlIG90aGVyIGZiZGV2IGRy
aXZlcnMgb3V0IGluIHRoZSByYWluLg0KPiBHaXZlbiB0aGF0IGRpc3Ryb3MgaGF2ZSBmaW5h
bGx5IHN0YXJ0ZWQgdG8gbW92ZSBhd2F5IGZyb20gdGhvc2UNCj4gY29tcGxldGVseSBmb3Ig
cmVhbCBJIHRoaW5rIHRoYXQncyBnb29kIGVub3VnaC4gVGhlIGNvZGUgaXQgc3BhZ2hldHRp
DQo+IGVub3VnaCB0aGF0IEkgZG8gbm90IGZlZWwgY29uZmlkZW50IHRvIGV2ZW4gcmV2aWV3
IGZpeGVzIGZvciBpdC4NCj4gDQo+IFdoYXQgbWlnaHQgaGVscCBmYmRldiBpcyBkb2luZyBz
b21ldGhpbmcgc2ltaWxhciB0byB3aGF0IHdhcyBkb25lIGluDQo+IGE0OTE0NWFjZmI5NyAo
ImZibWVtOiBhZGQgbWFyZ2luIGNoZWNrIHRvIGZiX2NoZWNrX2NhcHMoKSIpIGFuZCBlbnN1
cmUNCj4geC95cmVzX3ZpcnR1YWwgYXJlbid0IHRvbyBzbWFsbCwgZm9yIHNvbWUgdmFsdWUg
b2YgInRvbyBzbWFsbCIuIE1heWJlDQo+IGNoZWNraW5nIHRoYXQgdGhleSdyZSBhdCBsZWFz
dCB4L3lyZXMgbWFrZXMgc2Vuc2U/DQo+IA0KPiBGaXhlczogMTJmZmVkOTZkNDM2ICgiZHJt
L2ZiLWhlbHBlcjogQWxsb3cgdmFyLT54L3lyZXMoX3ZpcnR1YWwpIDwgZmItPndpZHRoL2hl
aWdodCBhZ2FpbiIpDQo+IENjOiBNaWNoZWwgRMOkbnplciA8bWljaGVsLmRhZW56ZXJAYW1k
LmNvbT4NCj4gQ2M6IERhbmllbCBTdG9uZSA8ZGFuaWVsc0Bjb2xsYWJvcmEuY29tPg0KPiBD
YzogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4NCj4gQ2M6IE1hYXJ0
ZW4gTGFua2hvcnN0IDxtYWFydGVuLmxhbmtob3JzdEBsaW51eC5pbnRlbC5jb20+DQo+IENj
OiBNYXhpbWUgUmlwYXJkIDxtcmlwYXJkQGtlcm5lbC5vcmc+DQo+IENjOiBUaG9tYXMgWmlt
bWVybWFubiA8dHppbW1lcm1hbm5Ac3VzZS5kZT4NCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPiAjIHY0LjExKw0KPiBDYzogSGVsZ2UgRGVsbGVyIDxkZWxsZXJAZ214LmRlPg0K
PiBDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4N
Cj4gQ2M6IG9wZW5ldWxlci1zZWN1cml0eUBvcGVuZXVsZXIub3JnDQo+IENjOiBndW9kYXhp
bmdAaHVhd2VpLmNvbQ0KPiBDYzogV2VpZ2FuZyAoSmltbXkpIDx3ZWlnYW5nMTJAaHVhd2Vp
LmNvbT4NCj4gUmVwb3J0ZWQtYnk6IFdlaWdhbmcgKEppbW15KSA8d2VpZ2FuZzEyQGh1YXdl
aS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IERhbmllbCBWZXR0ZXIgPGRhbmllbC52ZXR0ZXJA
aW50ZWwuY29tPg0KPiAtLS0NCj4gTm90ZTogV2VpZ2FuZyBhc2tlZCBmb3IgdGhpcyB0byBz
dGF5IHVuZGVyIGVtYmFyZ28gdW50aWwgaXQncyBhbGwNCj4gcmV2aWV3IGFuZCB0ZXN0ZWQu
DQo+IC1EYW5pZWwNCj4gLS0tDQo+ICAgZHJpdmVycy9ncHUvZHJtL2RybV9mYl9oZWxwZXIu
YyB8IDQgKystLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2RybV9mYl9o
ZWxwZXIuYyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fZmJfaGVscGVyLmMNCj4gaW5kZXggNjk1
OTk3YWUyYTdjLi41NjY0YTE3N2E0MDQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2Ry
bS9kcm1fZmJfaGVscGVyLmMNCj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2RybV9mYl9oZWxw
ZXIuYw0KPiBAQCAtMTM1NSw4ICsxMzU1LDggQEAgaW50IGRybV9mYl9oZWxwZXJfY2hlY2tf
dmFyKHN0cnVjdCBmYl92YXJfc2NyZWVuaW5mbyAqdmFyLA0KPiAgIAkgKiB0byBLTVMsIGhl
bmNlIGZhaWwgaWYgZGlmZmVyZW50IHNldHRpbmdzIGFyZSByZXF1ZXN0ZWQuDQo+ICAgCSAq
Lw0KPiAgIAlpZiAodmFyLT5iaXRzX3Blcl9waXhlbCA+IGZiLT5mb3JtYXQtPmNwcFswXSAq
IDggfHwNCj4gLQkgICAgdmFyLT54cmVzID4gZmItPndpZHRoIHx8IHZhci0+eXJlcyA+IGZi
LT5oZWlnaHQgfHwNCj4gLQkgICAgdmFyLT54cmVzX3ZpcnR1YWwgPiBmYi0+d2lkdGggfHwg
dmFyLT55cmVzX3ZpcnR1YWwgPiBmYi0+aGVpZ2h0KSB7DQo+ICsJICAgIHZhci0+eHJlcyAh
PSBpbmZvLT52YXIueHJlcyB8fCB2YXItPnlyZXMgIT0gaW5mby0+dmFyLnlyZXMgfHwNCg0K
VGhpcyBsb29rcyByZWFzb25hYmxlLiBXZSBlZmZlY3RpdmVseSBvbmx5IHN1cHBvcnQgYSBz
aW5nbGUgcmVzb2x1dGlvbiBoZXJlLg0KDQo+ICsJICAgIHZhci0+eHJlc192aXJ0dWFsICE9
IGZiLT53aWR0aCB8fCB2YXItPnlyZXNfdmlydHVhbCAhPSBmYi0+aGVpZ2h0KSB7DQoNCkFG
QUlVIHRoaXMgY2hhbmdlIHdvdWxkIHJlcXVpcmUgdGhhdCBhbGwgdXNlcnNwYWNlIGFsd2F5
cyB1c2VzIG1heGltdW0gDQp2YWx1ZXMgZm9yIHt4cmVzLHlyZXN9X3ZpcnR1YWwuIFNlZW1z
IHVucmVhbGlzdGljIHRvIG1lLg0KDQpCZXN0IHJlZ2FyZHMNClRob21hcw0KDQoNCj4gICAJ
CWRybV9kYmdfa21zKGRldiwgImZiIHJlcXVlc3RlZCB3aWR0aC9oZWlnaHQvYnBwIGNhbid0
IGZpdCBpbiBjdXJyZW50IGZiICINCj4gICAJCQkgICJyZXF1ZXN0ICVkeCVkLSVkICh2aXJ0
dWFsICVkeCVkKSA+ICVkeCVkLSVkXG4iLA0KPiAgIAkJCSAgdmFyLT54cmVzLCB2YXItPnly
ZXMsIHZhci0+Yml0c19wZXJfcGl4ZWwsDQoNCi0tIA0KVGhvbWFzIFppbW1lcm1hbm4NCkdy
YXBoaWNzIERyaXZlciBEZXZlbG9wZXINClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1h
bnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBHZXJtYW55DQooSFJC
IDM2ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2DQo=


--------------eanO3p0FNo2uXZ0UNk1saGUO--

--------------UQf5rTzU8rgrSpruom2PFEqP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmKxmjMFAwAAAAAACgkQlh/E3EQov+A3
yxAAr/CHGd7b1fsSUoDZyQ1q9AnSCXoNuZFlFBl/7LraTSf1GkxTOUfkVIz6jroBMrA/u7p15w2D
r9GPzpJYvH0jcezWYDcahBZL/vr3TvTAO0Qlc5O0SB1VYOCNAHVz+L+Fdqj9j5PV+VjbeW4i5fnI
2bprSpDG27PotUEiSIK0+v6pFr8AuVDfjtDIfyYvMTnebgv5ac8LBFUyGz3wi8WIcZV04+axOarC
2A3H1+ut42o9SgqSkAuR2cDfo7Jde/Lj16PBCgLKNc++dFc9rBvnvuJpG8p9mWaDnGJdKWzCDihd
jfB54zGSGQbus7NNBowUgShD3ctnqPEa1RQC4A9JVKAgtDh85UxRKtRQ0XTUPwPSJ8l9v0uiYEuc
ZKD9yRbR9YL3VfbW53mlZl6loFr2i+E4QTEKackPnJQjOF0KU8Wf7e6jUpxyPlgYO/JKK4vYSQyc
4hX3TjKYt3lJHP71r+JMlkc19VRxIv6Yu1iFeENO6pEOaVeGkxyANf/WKhLtFGtaD9pqDEU5F/hx
5ntHK1l50M2qNV6f4Z788z8a/IpDtG/TUc/nMGaUcEJoZyIKecm48/Q+b/txxUK/6Ly5IJOQD9xk
EfB+1BJaFU6hH3SpCzwEgPqB6s375x9/8lGHabv9zWKcQEoHukP9ysGd5fHS7dRfUNIfihzZANUv
Uts=
=RAfa
-----END PGP SIGNATURE-----

--------------UQf5rTzU8rgrSpruom2PFEqP--
