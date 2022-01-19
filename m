Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DF7493A30
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 13:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354429AbiASMVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 07:21:24 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:52636 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354343AbiASMVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 07:21:23 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3889B212C5;
        Wed, 19 Jan 2022 12:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642594882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m7fTFFHRbri8DCleS1WNC8ZNng8QQdIeiovq6bltnIs=;
        b=Jvon2qENcIKHJQJo7Njmc95UxMfPceLrjsph8IYM6af+4xTLEjPEQBygMgCMplrgD1BWE5
        /NgcY2jNItAFHUdIHWe1cbsHzgHNiAnvBkElkm7zkm+9U+FRKNvF+GL0YVyY3gX9BvSv5Y
        w60eG6k9ff/rzcdH+hj9QAlwr3nWHcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642594882;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m7fTFFHRbri8DCleS1WNC8ZNng8QQdIeiovq6bltnIs=;
        b=vPWmTmAlclwH3WHJuUiG9sbLgAS5b4SdfI59azHSossGdnQzA8K13MdxKgMtuRW0BGdyKI
        NAim1Be2txp2m4Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1369D13B54;
        Wed, 19 Jan 2022 12:21:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id k4G3A0IC6GEbFgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 19 Jan 2022 12:21:22 +0000
Message-ID: <967fd413-1b55-7b94-a164-70f2942772f6@suse.de>
Date:   Wed, 19 Jan 2022 13:21:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] mgag200 fix memmapsl configuration in GCTL6 register
Content-Language: en-US
To:     Jocelyn Falempe <jfalempe@redhat.com>,
        dri-devel@lists.freedesktop.org
Cc:     michel@daenzer.net, lyude@redhat.com, javierm@redhat.com,
        stable@vger.kernel.org
References: <20220114094754.522401-1-jfalempe@redhat.com>
 <20220119102905.1194787-1-jfalempe@redhat.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20220119102905.1194787-1-jfalempe@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------af2d01oGHUAeXr6fi3uYKU2T"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------af2d01oGHUAeXr6fi3uYKU2T
Content-Type: multipart/mixed; boundary="------------Uv6NfilKd3jK9k1WohiQawu5";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Jocelyn Falempe <jfalempe@redhat.com>, dri-devel@lists.freedesktop.org
Cc: michel@daenzer.net, lyude@redhat.com, javierm@redhat.com,
 stable@vger.kernel.org
Message-ID: <967fd413-1b55-7b94-a164-70f2942772f6@suse.de>
Subject: Re: [PATCH v2] mgag200 fix memmapsl configuration in GCTL6 register
References: <20220114094754.522401-1-jfalempe@redhat.com>
 <20220119102905.1194787-1-jfalempe@redhat.com>
In-Reply-To: <20220119102905.1194787-1-jfalempe@redhat.com>

--------------Uv6NfilKd3jK9k1WohiQawu5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGksDQoNCkFtIDE5LjAxLjIyIHVtIDExOjI5IHNjaHJpZWIgSm9jZWx5biBGYWxlbXBlOg0K
PiBPbiBzb21lIHNlcnZlcnMgd2l0aCBNR0EgRzIwMF9TRV9BIChyZXYgNDIpLCBib290aW5n
IHdpdGggTGVnYWN5IEJJT1MsDQo+IHRoZSBoYXJkd2FyZSBoYW5ncyB3aGVuIHVzaW5nIGtk
dW1wIGFuZCBrZXhlYyBpbnRvIHRoZSBrZHVtcCBrZXJuZWwuDQo+IFRoaXMgaGFwcGVucyB3
aGVuIHRoZSB1bmNvbXByZXNzIGNvZGUgdHJpZXMgdG8gd3JpdGUgIkRlY29tcHJlc3Npbmcg
TGludXgiDQo+IHRvIHRoZSBWR0EgQ29uc29sZS4NCj4gDQo+IEl0IGNhbiBiZSByZXByb2R1
Y2VkIGJ5IHdyaXRpbmcgdG8gdGhlIFZHQSBjb25zb2xlICgweEI4MDAwKSBhZnRlcg0KPiBi
b290aW5nIHRvIGdyYXBoaWMgbW9kZSwgaXQgZ2VuZXJhdGVzIHRoZSBmb2xsb3dpbmcgZXJy
b3I6DQo+IA0KPiBrZXJuZWw6Tk1JOiBQQ0kgc3lzdGVtIGVycm9yIChTRVJSKSBmb3IgcmVh
c29uIGEwIG9uIENQVSAwLg0KPiBrZXJuZWw6RGF6ZWQgYW5kIGNvbmZ1c2VkLCBidXQgdHJ5
aW5nIHRvIGNvbnRpbnVlDQo+IA0KPiBUaGUgcm9vdCBjYXVzZSBpcyB0aGUgY29uZmlndXJh
dGlvbiBvZiB0aGUgTUdBIEdDVEw2IHJlZ2lzdGVyDQo+IA0KPiBBY2NvcmRpbmcgdG8gdGhl
IEdDVEw2IHJlZ2lzdGVyIGRvY3VtZW50YXRpb246DQo+IA0KPiBiaXQgMCBpcyBnY2dybW9k
ZToNCj4gICAgICAwOiBFbmFibGVzIGFscGhhIG1vZGUsIGFuZCB0aGUgY2hhcmFjdGVyIGdl
bmVyYXRvciBhZGRyZXNzaW5nIHN5c3RlbSBpcw0KPiAgICAgICBhY3RpdmF0ZWQuDQo+ICAg
ICAgMTogRW5hYmxlcyBncmFwaGljcyBtb2RlLCBhbmQgdGhlIGNoYXJhY3RlciBhZGRyZXNz
aW5nIHN5c3RlbSBpcyBub3QNCj4gICAgICAgdXNlZC4NCj4gDQo+IGJpdCAxIGlzIGNoYWlu
b2RkIGV2ZW46DQo+ICAgICAgMDogVGhlIEEwIHNpZ25hbCBvZiB0aGUgbWVtb3J5IGFkZHJl
c3MgYnVzIGlzIHVzZWQgZHVyaW5nIHN5c3RlbSBtZW1vcnkNCj4gICAgICAgYWRkcmVzc2lu
Zy4NCj4gICAgICAxOiBBbGxvd3MgQTAgdG8gYmUgcmVwbGFjZWQgYnkgZWl0aGVyIHRoZSBB
MTYgc2lnbmFsIG9mIHRoZSBzeXN0ZW0NCj4gICAgICAgYWRkcmVzcyAoaWZtZW1tYXBzbCBp
cyDigJgwMOKAmSksIG9yIGJ5IHRoZSBocGdvZGRldiAoTUlTQzw1Piwgb2RkL2V2ZW4NCj4g
ICAgICAgcGFnZSBzZWxlY3QpIGZpZWxkLCBkZXNjcmliZWQgb24gcGFnZSAzLTI5NCkuDQo+
IA0KPiBiaXQgMy0yIGFyZSBtZW1tYXBzbDoNCj4gICAgICBNZW1vcnkgbWFwIHNlbGVjdCBi
aXRzIDEgYW5kIDAuIFZHQS4NCj4gICAgICBUaGVzZSBiaXRzIHNlbGVjdCB3aGVyZSB0aGUg
dmlkZW8gbWVtb3J5IGlzIG1hcHBlZCwgYXMgc2hvd24gYmVsb3c6DQo+ICAgICAgICAgIDAw
ID0+IEEwMDAwaCAtIEJGRkZGaA0KPiAgICAgICAgICAwMSA9PiBBMDAwMGggLSBBRkZGRmgN
Cj4gICAgICAgICAgMTAgPT4gQjAwMDBoIC0gQjdGRkZoDQo+ICAgICAgICAgIDExID0+IEI4
MDAwaCAtIEJGRkZGaA0KPiANCj4gYml0IDctNCBhcmUgcmVzZXJ2ZWQuDQo+IA0KPiBDdXJy
ZW50IGNvZGUgc2V0IGl0IHRvIDB4MDUgPT4gbWVtbWFwc2wgdG8gYjAxID0+IDB4YTAwMDAg
KGdyYXBoaWMgbW9kZSkNCj4gQnV0IG9uIHg4NiwgdGhlIFZHQSBjb25zb2xlIGlzIGF0IDB4
YjgwMDAgKHRleHQgbW9kZSkNCj4gSW4gYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL21pc2Mu
YyBkZWJ1ZyBzdHJpbmdzIGFyZSB3cml0dGVuIHRvIDB4YjgwMDANCj4gQXMgdGhlIGRyaXZl
ciBkb2Vzbid0IHVzZSB0aGlzIG1hcHBpbmcgYXQgMHhhMDAwMCwgaXQgaXMgc2FmZSB0byBz
ZXQgaXQgdG8NCj4gMHhiODAwMCBpbnN0ZWFkLCB0byBhdm9pZCBrZXJuZWwgaGFuZyBvbiBH
MjAwX1NFX0EgcmV2NDIsIHdpdGgga2V4ZWMva2R1bXAuDQo+IA0KPiBUaHVzIGNoYW5naW5n
IHRoZSB2YWx1ZSAweDA1IHRvIDB4MGQNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEpvY2VseW4g
RmFsZW1wZSA8amZhbGVtcGVAcmVkaGF0LmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEphdmllciBN
YXJ0aW5leiBDYW5pbGxhcyA8amF2aWVybUByZWRoYXQuY29tPg0KPiBBY2tlZC1ieTogTHl1
ZGUgUGF1bCA8bHl1ZGVAcmVkaGF0LmNvbT4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcNCj4gLS0tDQo+IA0KPiB2MjogQWRkIGNsZWFyIHN0YXRlbWVudCB0aGF0IGl0J3Mgbm90
IHRoZSByaWdodCBjb25maWd1cmF0aW9uLCBidXQgaXQNCj4gICAgICBwcmV2ZW50cyBhbiBh
bm5veWluZyBidWcgd2l0aCBrZXhlYy9rZHVtcC4NCj4gDQo+ICAgZHJpdmVycy9ncHUvZHJt
L21nYWcyMDAvbWdhZzIwMF9tb2RlLmMgfCA1ICsrKystDQo+ICAgMSBmaWxlIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBfbW9kZS5jIGIvZHJpdmVycy9ncHUvZHJt
L21nYWcyMDAvbWdhZzIwMF9tb2RlLmMNCj4gaW5kZXggYjk4MzU0MWE0YzUzLi5jZDliYTEz
YWQ1ZmMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBf
bW9kZS5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBfbW9kZS5j
DQo+IEBAIC01MjksNyArNTI5LDEwIEBAIHN0YXRpYyB2b2lkIG1nYWcyMDBfc2V0X2Zvcm1h
dF9yZWdzKHN0cnVjdCBtZ2FfZGV2aWNlICptZGV2LA0KPiAgIAlXUkVHX0dGWCgzLCAweDAw
KTsNCj4gICAJV1JFR19HRlgoNCwgMHgwMCk7DQo+ICAgCVdSRUdfR0ZYKDUsIDB4NDApOw0K
PiAtCVdSRUdfR0ZYKDYsIDB4MDUpOw0KPiArCS8qIEdDVEw2IHNob3VsZCBiZSAweDA1LCBi
dXQgd2UgY29uZmlndXJlIG1lbW1hcHNsIHRvIDB4YjgwMDAgKHRleHQgbW9kZSksDQo+ICsJ
ICogc28gdGhhdCBpdCBkb2Vzbid0IGhhbmcgd2hlbiBydW5uaW5nIGtleGVjL2tkdW1wIG9u
IEcyMDBfU0UgcmV2NDIuDQo+ICsJICovDQo+ICsJV1JFR19HRlgoNiwgMHgwZCk7DQoNCkFw
cGVhcnMgdG8gYmUgd29ya2luZyBvbiBteSB0ZXN0IG1hY2hpbmUuDQoNCkJ1dCBwbGVhc2Ug
cnVuZSBzY3JpcHRzL2NoZWNrcGF0Y2gucGwgb24gdGhlIHBhdGNoIGJlZm9yZSBzZW5kaW5n
IGl0LiBJIA0KZ2V0IHNldmVyYWwgZXJyb3JzDQoNCldBUk5JTkc6IFBvc3NpYmxlIHVud3Jh
cHBlZCBjb21taXQgZGVzY3JpcHRpb24gKHByZWZlciBhIG1heGltdW0gNzUgDQpjaGFycyBw
ZXIgbGluZSkNCg0KIzk4Og0KDQogICAgIDA6IEVuYWJsZXMgYWxwaGEgbW9kZSwgYW5kIHRo
ZSBjaGFyYWN0ZXIgZ2VuZXJhdG9yIGFkZHJlc3Npbmcgc3lzdGVtIGlzDQoNCg0KDQpFUlJP
UjogdHJhaWxpbmcgd2hpdGVzcGFjZQ0KDQojMTQ5OiBGSUxFOiBkcml2ZXJzL2dwdS9kcm0v
bWdhZzIwMC9tZ2FnMjAwX21vZGUuYzo1MzI6DQoNCiteSS8qIEdDVEw2IHNob3VsZCBiZSAw
eDA1LCBidXQgd2UgY29uZmlndXJlIG1lbW1hcHNsIHRvIDB4YjgwMDAgKHRleHQgDQptb2Rl
KSxeTSQNCg0KDQoNCkVSUk9SOiB0cmFpbGluZyB3aGl0ZXNwYWNlDQoNCiMxNTA6IEZJTEU6
IGRyaXZlcnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBfbW9kZS5jOjUzMzoNCg0KK15JICog
c28gdGhhdCBpdCBkb2Vzbid0IGhhbmcgd2hlbiBydW5uaW5nIGtleGVjL2tkdW1wIG9uIEcy
MDBfU0UgcmV2NDIuXk0kDQoNCg0KDQoNCkJlc3QgcmVnYXJkcw0KVGhvbWFzDQoNCg0KPiAg
IAlXUkVHX0dGWCg3LCAweDBmKTsNCj4gICAJV1JFR19HRlgoOCwgMHgwZik7DQo+ICAgDQoN
Ci0tIA0KVGhvbWFzIFppbW1lcm1hbm4NCkdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXINClNV
U0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0
MDkgTsO8cm5iZXJnLCBHZXJtYW55DQooSFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNj
aMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2DQo=

--------------Uv6NfilKd3jK9k1WohiQawu5--

--------------af2d01oGHUAeXr6fi3uYKU2T
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHoAkEFAwAAAAAACgkQlh/E3EQov+DT
tw//dF5saiyrGmw7hzzdya5lKTe9HKqs64YCTnAt0c/PdYlZPaP/GTB16ugNG9DuejnGi+reqqDY
lETcI608pKG152UZRtWVaqybLV/xu6QAG04KndAPL3BxcNwiEbDgnjaS33q3ssw/IQrY2r5xTEFY
yyiMaD8Qhn6hOQ4jHVgKYk7ot4NjN6ft31WgemPowtTFdmY10eHaFerIfkafrUhfp1f82KV4E7pJ
j9o65M6mT8QBq2O5yhYaxTv88HAqGrjJQ52Txpwl+k5wlQy0lTe6gDGyzXsyb7OtSKg02F1Jkfr7
fXbtcMgTqiPNfeHnTPIcN8pdYO/SHp4lFgh1vArGvgxUrTd9meElNDpx1+bC1+9z1fNk84kRFF7E
MD6tlMwQXVoffMM7vCms/pomdWAySX6YbpQJvDj7XDWDQTO8ZFePoA6nY3VHV6MZZIsosqzI5Geg
0WZFjvqgWI3oEYMSie0QwDjaO8HuKR3A92tF5Hs1NPuUUXPrkqiyAjVSOltdN0MQ+ehQeyoFryio
9/bDpJyqANB7cemJFBS9HhZ1OKy8z3K2Bnohl5PHytVPriaA5gNpF6aB9hzUX+moa+PJXvxyk+ZB
l0qC8gX9OJ5KcYb38QtyUIlQ8wG94PWuyvxsTuFzT/C65dhzhQ62zUt0TulaXWZVVqb5T3TbuXAL
8IU=
=UT7e
-----END PGP SIGNATURE-----

--------------af2d01oGHUAeXr6fi3uYKU2T--
