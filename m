Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1439493DAF
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 16:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355966AbiASPuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 10:50:39 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51072 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355981AbiASPug (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 10:50:36 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 82DD91F3BF;
        Wed, 19 Jan 2022 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642607435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lOdDJ/fn+UYPr7RVLcI24hXpS/LaDSwWKTWVuG4N9H0=;
        b=Bt4qtoPIK7zzjcQZvlWXMp0egIFp8w20lcCXebMHyfx7ZoDvJuNX3kl9O9gsHtP1lPYM9d
        AVmd+V8/vrm3X7BQADTxiqpc6OrUzOF1UCfJBOU/Wfl26MGqVnKp/joRn59B+iPkGRPWmE
        QTsGwA8969mz7CuWwzk00nDZ1n6BYdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642607435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lOdDJ/fn+UYPr7RVLcI24hXpS/LaDSwWKTWVuG4N9H0=;
        b=Opr6tq3B28YLf+Hsg8rGfbYea1ZskaRIJdExA6JKgj06Y4zW40hdYmCOGYZUH6vXKtqS5L
        +y/778Z8TiA9/+Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5D18713F84;
        Wed, 19 Jan 2022 15:50:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iQ+pFUsz6GHEEQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 19 Jan 2022 15:50:35 +0000
Message-ID: <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
Date:   Wed, 19 Jan 2022 16:50:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "javierm@redhat.com" <javierm@redhat.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
References: <20220117180359.18114-1-zack@kde.org>
 <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
 <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
 <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
 <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
 <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------RZQAbzeb1eW0tuIa00oQH85B"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------RZQAbzeb1eW0tuIa00oQH85B
Content-Type: multipart/mixed; boundary="------------vCNhZnb5JQIBvzh0DSl2F3xy";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Zack Rusin <zackr@vmware.com>,
 "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
 "javierm@redhat.com" <javierm@redhat.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Martin Krastev <krastevm@vmware.com>,
 Maaz Mombasawala <mombasawalam@vmware.com>
Message-ID: <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
References: <20220117180359.18114-1-zack@kde.org>
 <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
 <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
 <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
 <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
 <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
In-Reply-To: <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>

--------------vCNhZnb5JQIBvzh0DSl2F3xy
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTkuMDEuMjIgdW0gMTY6MTIgc2NocmllYiBaYWNrIFJ1c2luOg0KPiBPbiBX
ZWQsIDIwMjItMDEtMTkgYXQgMTU6MDAgKzAxMDAsIFRob21hcyBaaW1tZXJtYW5uIHdyb3Rl
Og0KPj4gSGkgWmFjaw0KPj4NCj4+IEFtIDE5LjAxLjIyIHVtIDEwOjEzIHNjaHJpZWIgVGhv
bWFzIFppbW1lcm1hbm46DQo+Pj4gSGkNCj4+Pg0KPj4+IEFtIDE5LjAxLjIyIHVtIDAzOjE1
IHNjaHJpZWIgWmFjayBSdXNpbjoNCj4+Pj4gT24gVHVlLCAyMDIyLTAxLTE4IGF0IDIwOjAw
ICswMTAwLCBKYXZpZXIgTWFydGluZXogQ2FuaWxsYXMgd3JvdGU6DQo+Pj4+PiBIZWxsbyBa
YWNrLA0KPj4+Pj4NCj4+Pj4+IE9uIDEvMTcvMjIgMTk6MDMsIFphY2sgUnVzaW4gd3JvdGU6
DQo+Pj4+Pj4gRnJvbTogWmFjayBSdXNpbiA8emFja3JAdm13YXJlLmNvbT4NCj4+Pj4+Pg0K
Pj4+Pj4+IFdoZW4gc3lzZmJfc2ltcGxlIGlzIGVuYWJsZWQgbG9hZGluZyB2bXdnZnggZmFp
bHMgYmVjYXVzZSB0aGUNCj4+Pj4+PiByZWdpb25zDQo+Pj4+Pj4gYXJlIGhlbGQgYnkgdGhl
IHBsYXRmb3JtLiBJbiB0aGF0IGNhc2UNCj4+Pj4+PiByZW1vdmVfY29uZmxpY3RpbmcqX2Zy
YW1lYnVmZmVycw0KPj4+Pj4+IG9ubHkgcmVtb3ZlcyB0aGUgc2ltcGxlZmIgYnV0IG5vdCB0
aGUgcmVnaW9ucyBoZWxkIGJ5IHN5c2ZiLg0KPj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4gSW5kZWVk
LCB0aGF0J3MgYW4gaXNzdWUuIEkgd29uZGVyIGlmIHdlIHNob3VsZCBkcm9wIHRoZQ0KPj4+
Pj4gSU9SRVNPVVJDRV9CVVNZDQo+Pj4+PiBmbGFnIGZyb20gdGhlIG1lbW9yeSByZXNvdXJj
ZSBhZGRlZCB0byB0aGUgInNpbXBsZS1mcmFtZWJ1ZmZlciINCj4+Pj4+IGRldmljZQ0KPj4+
Pj4gPw0KPj4+Pg0KPj4+PiBJIHRoaW5rIHRoaXMgaXMgb25lIG9mIHRob3NlIGNhc2VzIHdo
ZXJlIGl0IGRlcGVuZHMgb24gd2hhdCB3ZSBwbGFuDQo+Pj4+IHRvDQo+Pj4+IGRvIGFmdGVy
IHRoYXQuIFNlbWVudGljYWxseSBpdCBtYWtlcyBzZW5zZSB0byBoYXZlIGl0IGluIHRoZXJl
IC0NCj4+Pj4gdGhlDQo+Pj4+IGZyYW1lYnVmZmVyIG1lbW9yeSBpcyBjbGFpbWVkIGJ5IHRo
ZSAic2ltcGxlLWZyYW1lYnVmZmVyIiBhbmQgaXQncw0KPj4+PiBidXN5LCBpdCdzIGp1c3Qg
dGhhdCBpdCBjcmVhdGVzIGlzc3VlcyBmb3IgZHJpdmVycyBhZnRlciB1bmxvYWRpbmcuDQo+
Pj4+IEkNCj4+Pj4gdGhpbmsgcmVtb3ZpbmcgaXQsIHdoaWxlIG1ha2luZyB0aGluZ3MgZWFz
aWVyIGZvciBkcml2ZXJzLCB3b3VsZCBiZQ0KPj4+PiBjb25mdXNpbmcgZm9yIHBlb3BsZSBy
ZWFkaW5nIHRoZSBjb2RlIGxhdGVyLCB1bmxlc3MgdGhlcmUncyBzb21lDQo+Pj4+IGtpbmQN
Cj4+Pj4gb2YgY2xlYW51cCB0aGF0IHdvdWxkIGhhcHBlbiB3aXRoIGl0IChlLmcuIHJlbW92
aW5nIElPUkVTT1VSQ0VfQlVTWQ0KPj4+PiBhbHRvZ2V0aGVyIGFuZCBtYWtpbmcgdGhlIGRy
bSBkcml2ZXJzIHByb3Blcmx5IHJlcXVlc3QgdGhlaXINCj4+Pj4gcmVzb3VyY2VzKS7CoEF0
IGxlYXN0IGJ5IGl0c2VsZiBpdCBkb2Vzbid0IHNlZW0gdG8gYmUgbXVjaCBiZXR0ZXINCj4+
Pj4gc29sdXRpb24gdGhhbiBoYXZpbmcgdGhlIGRybSBkcml2ZXJzIG5vdCBjYWxsDQo+Pj4+
IHBjaV9yZXF1ZXN0X3JlZ2lvbltzXSwNCj4+Pj4gd2hpY2ggYXBhcnQgZnJvbSBoeXBlcnYg
YW5kIGNpcnJ1cyAoaWlyYyBib2NocyBkb2VzIGl0IGZvcg0KPj4+PiByZXNvdXJjZXMNCj4+
Pj4gb3RoZXIgdGhhbiBmYiB3aGljaCB3b3VsZG4ndCBoYXZlIGJlZW4gY2xhaW1lZCBieSAi
c2ltcGxlLQ0KPj4+PiBmcmFtZWJ1ZmZlciIpDQo+Pj4+IGlzIGFscmVhZHkgdGhlIGNhc2Uu
DQo+Pj4+DQo+Pj4+IEkgZG8gdGhpbmsgd2Ugc2hvdWxkIGRvIG9uZSBvZiB0aGVtIHRvIG1h
a2UgdGhlIGNvZGViYXNlIGNvaGVyZW50Og0KPj4+PiBlaXRoZXIgcmVtb3ZlIElPUkVTT1VS
Q0VfQlVTWSBmcm9tICJzaW1wbGUtZnJhbWVidWZmZXIiIG9yIHJlbW92ZQ0KPj4+PiBwY2lf
cmVxdWVzdF9yZWdpb25bc10gZnJvbSBoeXBlcnYgYW5kIGNpcnJ1cy4NCj4+Pg0KPj4+IEkg
anVzdCBkaXNjdXNzZWQgdGhpcyBhIGJpdCB3aXRoIEphdmllci4gSXQncyBhIHByb2JsZW0g
d2l0aCB0aGUNCj4+PiBzaW1wbGUtZnJhbWVidWZmZXIgY29kZSwgcmF0aGVyIHRoZW4gdm13
Z2Z4Lg0KPj4+DQo+Pj4gSU1ITyB0aGUgYmVzdCBzb2x1dGlvbiBpcyB0byBkcm9wIElPUkVT
T1VSQ0VfQlVTWSBmcm9tIHN5c2ZiIGFuZCBoYXZlDQo+Pj4gZHJpdmVycyByZWdpc3Rlci9y
ZWxlYXNlIHRoZSByYW5nZSB3aXRoIF9CVVNZLiBUaGF0IHdvdWxkIHNpZ25hbCB0aGUNCj4+
PiBtZW1vcnkgYmVsb25ncyB0byB0aGUgc3lzZmIgZGV2aWNlIGJ1dCBpcyBub3QgYnVzeSB1
bmxlc3MgYSBkcml2ZXINCj4+PiBoYXMNCj4+PiBiZWVuIGJvdW5kLiBBZnRlciBzaW1wbGVm
YiByZWxlYXNlZCB0aGUgcmFuZ2UsIGl0IHNob3VsZCBiZSAnbm9uLQ0KPj4+IGJ1c3knDQo+
Pj4gYWdhaW4gYW5kIGF2YWlsYWJsZSBmb3Igdm13Z2Z4LiBTaW1wbGVkcm0gZG9lcyBhIGhv
dC11bnBsdWcgb2YgdGhlDQo+Pj4gc3lzZmINCj4+PiBkZXZpY2UsIHNvIHRoZSBtZW1vcnkg
cmFuZ2UgZ2V0cyByZWxlYXNlZCBlbnRpcmVseS4gSWYgeW91IHdhbnQsIEknbGwNCj4+PiBw
cmVwYXJlIHNvbWUgcGF0Y2hlcyBmb3IgdGhpcyBzY2VuYXJpby4NCj4+DQo+PiBBdHRhY2hl
ZCBpcyBhIHBhdGNoIHRoYXQgaW1wbGVtZW50cyB0aGlzLiBEb2luZw0KPj4NCj4+ICDCoCBj
YXQgL3Byb2MvaW9tZW0NCj4+ICDCoMKgIC4uLg0KPj4gIMKgwqAgZTAwMDAwMDAtZWZmZmZm
ZmYgOiAwMDAwOjAwOjAyLjANCj4+DQo+PiAgwqDCoMKgwqAgZTAwMDAwMDAtZTA3ZThmZmYg
OiBCT09URkINCj4+DQo+PiAgwqDCoMKgwqDCoMKgIGUwMDAwMDAwLWUwN2U4ZmZmIDogc2lt
cGxlZmINCj4+DQo+PiAgwqDCoCAuLi4NCj4+DQo+PiBzaG93cyB0aGUgbWVtb3J5LiAnQk9P
VEZCJyBpcyB0aGUgc2ltcGxlLWZyYW1lYnVmZmVyIGRldmljZSBhbmQNCj4+ICdzaW1wbGVm
YicgaXMgdGhlIGRyaXZlci4gT25seSB0aGUgbGF0dGVyIHVzZXMgX0JVU1kuIFNhbWUgZm9y
DQo+PiBhbmQgdGhlIG1lbW9yeSBjYW5iZSBhY3F1aXJlZCBieSB2bXdnZnguDQo+Pg0KPj4g
WmFjaywgcGxlYXNlIHRlc3QgdGhpcyBwYXRjaC4gSWYgaXQgd29ya3MsIEknbGwgc2VuZCBv
dXQgdGhlIHJlYWwNCj4+IHBhdGNoc2V0Lg0KPiANCj4gSG1tLCB0aGUgcGF0Y2ggbG9va3Mg
Z29vZCBidXQgaXQgZG9lc24ndCB3b3JrLiBBZnRlciBib290OiAvcHJvYy9pb21lbQ0KPiA1
MDAwMDAwMC03ZmZmZmZmZiA6IHBjaWVAMHg0MDAwMDAwMA0KPiAgICA3ODAwMDAwMC03ZmZm
ZmZmZiA6IDAwMDA6MDA6MGYuMA0KPiAgICAgIDc4MDAwMDAwLTc4MmZmZmZmIDogQk9PVEZC
DQo+IA0KPiBhbmQgdm13Z2Z4IGZhaWxzIG9uIHBjaV9yZXF1ZXN0X3JlZ2lvbnM6DQo+IA0K
PiBrZXJuZWw6IGZiMDogc3dpdGNoaW5nIHRvIHZtd2dmeCBmcm9tIHNpbXBsZQ0KPiBrZXJu
ZWw6IENvbnNvbGU6IHN3aXRjaGluZyB0byBjb2xvdXIgZHVtbXkgZGV2aWNlIDgweDI1DQo+
IGtlcm5lbDogdm13Z2Z4IDAwMDA6MDA6MGYuMDogQkFSIDI6IGNhbid0IHJlc2VydmUgW21l
bSAweDc4MDAwMDAwLQ0KPiAweDdmZmZmZmZmIDY0Yml0IHByZWZdDQo+IGtlcm5lbDogdm13
Z2Z4OiBwcm9iZSBvZiAwMDAwOjAwOjBmLjAgZmFpbGVkIHdpdGggZXJyb3IgLTE2DQo+IA0K
PiBsZWF2aW5nIHRoZSBzeXN0ZW0gd2l0aG91dCBhIGZiIGRyaXZlci4NCg0KT0ssIEkgc3Vz
cGVjdCB0aGF0IGl0IHdvdWxkIHdvcmsgaWYgeW91IHVzZSBzaW1wbGVkcm0gaW5zdGVhZCBv
ZiANCnNpbXBsZWZiLiBDb3VsZCB5b3UgdHJ5IHBsZWFzZT8gWW91J2QgaGF2ZSB0byBidWls
ZCBEUk0gYW5kIHNpbXBsZWRybSANCmludG8gdGhlIGtlcm5lbCBiaW5hcnkuDQoNCklmIHRo
YXQgd29ya3MsIHdvdWxkIHlvdSBjb25zaWRlciBwcm90ZWN0aW5nIHBjaV9yZXF1ZXN0X3Jl
Z2lvbigpIHdpdGgNCiAgI2lmIG5vdCBkZWZpbmVkKENPTkZJR19GQl9TSU1QTEUpDQogICNl
bmRpZg0KDQp3aXRoIGEgRklYTUUgY29tbWVudD8NCg0Kc2ltcGxlZHJtIGhvdC11bnBsdWdz
IHRoZSBzeXNmYiBkZXZpY2UgZW50aXJlbHkuIE1heWJlIHNpbXBsZWZiIGNhbiBkbyANCnRo
ZSBzYW1lLiBJJ20gbm90IHN1cmUsIGJ1dCBwb3NzaWJseS4NCg0KQmVzdCByZWdhcmRzDQpU
aG9tYXMNCg0KPiANCj4geg0KDQotLSANClRob21hcyBaaW1tZXJtYW5uDQpHcmFwaGljcyBE
cml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgN
Ck1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2VybWFueQ0KKEhSQiAzNjgwOSwg
QUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3Rldg0K

--------------vCNhZnb5JQIBvzh0DSl2F3xy--

--------------RZQAbzeb1eW0tuIa00oQH85B
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHoM0oFAwAAAAAACgkQlh/E3EQov+De
IxAAjfD+cObPqrr7FpXGlwwtFGgfqy1opgou5DFFnrEMi1FpPrlKspVrQgLy7grHVp1yAkTEm8X6
sXpN5+fd65e0J64fHrHMvcmULO3gR2q9g35s3tAxrNh1CKCNaYJNXJZjA7pTr7YMm2AGoYeGEAR0
Yzl2gm3i38aUjmkA3Nr3YX25aZoh90eT18O8DnVWExuaj3WQhCaSNuR3fFUxUSOgQWANmd4qk8GC
3Ru+UtmsOjB9SsRknC0P57MPf4CaCon4AN0Nx3yvp6vvKpnwPHbJJh1T8k00fZ9TdPXEeDuthtt2
fYt4+M14bkThgjryFAXfG1+dA+1vSs6rgmCH53eJIhuwgAlWZupGqmyDuOaJisIIkrzeGPXFeIv+
tkafyaj19DbjA37yRFfzwJtOcVyvhMJq4FgnU24yTklURrrdfFxoS2Cmd/C9BMe1xgZL5gDUV7LV
i/nxIvLS/uyMo5Nca2oqwewH9Mat3MWpAOCWTmm8Ws/ysnNrHfWZima1bPQtr6cWUnieTAHusJu+
RxNF9woPmBp9Mkem7uCJ03ppIYlWCjXlSZY6JPTifW1I+FS0+helRRIajuzSukVXZjcjOaGYfi2C
o5wzRMbRjHiOwo6cIu2qmUNARMnYNHxCej2wQajZYEg1WZDMjYE5VTWSomkWUvyTlm7otGA3YPxQ
pBw=
=xuwq
-----END PGP SIGNATURE-----

--------------RZQAbzeb1eW0tuIa00oQH85B--
