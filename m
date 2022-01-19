Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FFA493C07
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 15:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355177AbiASOi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 09:38:29 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:44962 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355175AbiASOi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 09:38:28 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AA24D1F384;
        Wed, 19 Jan 2022 14:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642603107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Orgm0BqdZIgQCuYr0zzPDXUWssmC/UHhtBBhtVqzbBk=;
        b=csseSeu2uIukq7+tUJbTuXpsf06403Dr6q7L2Fulvj9BMiI7L0jeiPY9KYkVJfk2gA1cjA
        iW1Tlefk+JmcfLGTKcdoPzFBF8kwFKP09CmNtWq5WRdK7eBwmONX9T+M6tliBWtjsiHgC3
        gCZpCpzCZTLGdHybhTKF/gBCM604Peo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642603107;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Orgm0BqdZIgQCuYr0zzPDXUWssmC/UHhtBBhtVqzbBk=;
        b=szsO85VswCBpNGL+gPsJHqWH5YkO6dFORucdk89hNaQ96TM6pqv93k6q51Ievzt+zIUx37
        EVTssuT2ORkYujAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 830BA13F84;
        Wed, 19 Jan 2022 14:38:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sWcaH2Mi6GHTZwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 19 Jan 2022 14:38:27 +0000
Message-ID: <0f569863-99e8-7734-3ae1-e7f65eaa5347@suse.de>
Date:   Wed, 19 Jan 2022 15:38:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "javierm@redhat.com" <javierm@redhat.com>
Cc:     Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220117180359.18114-1-zack@kde.org>
 <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
 <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
 <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
 <d0f90d4cea4a137adb0b591ed9258540056a9813.camel@vmware.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <d0f90d4cea4a137adb0b591ed9258540056a9813.camel@vmware.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YVv376TGAl3JAGpuNYAkS409"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YVv376TGAl3JAGpuNYAkS409
Content-Type: multipart/mixed; boundary="------------QQkpORofor7iheI7kCY9E4Mp";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Zack Rusin <zackr@vmware.com>,
 "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
 "javierm@redhat.com" <javierm@redhat.com>
Cc: Martin Krastev <krastevm@vmware.com>,
 Maaz Mombasawala <mombasawalam@vmware.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <0f569863-99e8-7734-3ae1-e7f65eaa5347@suse.de>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
References: <20220117180359.18114-1-zack@kde.org>
 <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
 <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
 <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
 <d0f90d4cea4a137adb0b591ed9258540056a9813.camel@vmware.com>
In-Reply-To: <d0f90d4cea4a137adb0b591ed9258540056a9813.camel@vmware.com>

--------------QQkpORofor7iheI7kCY9E4Mp
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTkuMDEuMjIgdW0gMTU6MjQgc2NocmllYiBaYWNrIFJ1c2luOg0KPiBPbiBX
ZWQsIDIwMjItMDEtMTkgYXQgMTA6MTMgKzAxMDAsIFRob21hcyBaaW1tZXJtYW5uIHdyb3Rl
Og0KPj4gSGkNCj4+DQo+PiBBbSAxOS4wMS4yMiB1bSAwMzoxNSBzY2hyaWViIFphY2sgUnVz
aW46DQo+Pj4gT24gVHVlLCAyMDIyLTAxLTE4IGF0IDIwOjAwICswMTAwLCBKYXZpZXIgTWFy
dGluZXogQ2FuaWxsYXMgd3JvdGU6DQo+Pj4+IEhlbGxvIFphY2ssDQo+Pj4+DQo+Pj4+IE9u
IDEvMTcvMjIgMTk6MDMsIFphY2sgUnVzaW4gd3JvdGU6DQo+Pj4+PiBGcm9tOiBaYWNrIFJ1
c2luIDx6YWNrckB2bXdhcmUuY29tPg0KPj4+Pj4NCj4+Pj4+IFdoZW4gc3lzZmJfc2ltcGxl
IGlzIGVuYWJsZWQgbG9hZGluZyB2bXdnZnggZmFpbHMgYmVjYXVzZSB0aGUNCj4+Pj4+IHJl
Z2lvbnMNCj4+Pj4+IGFyZSBoZWxkIGJ5IHRoZSBwbGF0Zm9ybS4gSW4gdGhhdCBjYXNlDQo+
Pj4+PiByZW1vdmVfY29uZmxpY3RpbmcqX2ZyYW1lYnVmZmVycw0KPj4+Pj4gb25seSByZW1v
dmVzIHRoZSBzaW1wbGVmYiBidXQgbm90IHRoZSByZWdpb25zIGhlbGQgYnkgc3lzZmIuDQo+
Pj4+Pg0KPj4+Pg0KPj4+PiBJbmRlZWQsIHRoYXQncyBhbiBpc3N1ZS4gSSB3b25kZXIgaWYg
d2Ugc2hvdWxkIGRyb3AgdGhlDQo+Pj4+IElPUkVTT1VSQ0VfQlVTWQ0KPj4+PiBmbGFnIGZy
b20gdGhlIG1lbW9yeSByZXNvdXJjZSBhZGRlZCB0byB0aGUgInNpbXBsZS1mcmFtZWJ1ZmZl
ciINCj4+Pj4gZGV2aWNlDQo+Pj4+ID8NCj4+Pg0KPj4+IEkgdGhpbmsgdGhpcyBpcyBvbmUg
b2YgdGhvc2UgY2FzZXMgd2hlcmUgaXQgZGVwZW5kcyBvbiB3aGF0IHdlIHBsYW4NCj4+PiB0
bw0KPj4+IGRvIGFmdGVyIHRoYXQuIFNlbWVudGljYWxseSBpdCBtYWtlcyBzZW5zZSB0byBo
YXZlIGl0IGluIHRoZXJlIC0NCj4+PiB0aGUNCj4+PiBmcmFtZWJ1ZmZlciBtZW1vcnkgaXMg
Y2xhaW1lZCBieSB0aGUgInNpbXBsZS1mcmFtZWJ1ZmZlciIgYW5kIGl0J3MNCj4+PiBidXN5
LCBpdCdzIGp1c3QgdGhhdCBpdCBjcmVhdGVzIGlzc3VlcyBmb3IgZHJpdmVycyBhZnRlciB1
bmxvYWRpbmcuDQo+Pj4gSQ0KPj4+IHRoaW5rIHJlbW92aW5nIGl0LCB3aGlsZSBtYWtpbmcg
dGhpbmdzIGVhc2llciBmb3IgZHJpdmVycywgd291bGQgYmUNCj4+PiBjb25mdXNpbmcgZm9y
IHBlb3BsZSByZWFkaW5nIHRoZSBjb2RlIGxhdGVyLCB1bmxlc3MgdGhlcmUncyBzb21lDQo+
Pj4ga2luZA0KPj4+IG9mIGNsZWFudXAgdGhhdCB3b3VsZCBoYXBwZW4gd2l0aCBpdCAoZS5n
LiByZW1vdmluZyBJT1JFU09VUkNFX0JVU1kNCj4+PiBhbHRvZ2V0aGVyIGFuZCBtYWtpbmcg
dGhlIGRybSBkcml2ZXJzIHByb3Blcmx5IHJlcXVlc3QgdGhlaXINCj4+PiByZXNvdXJjZXMp
LsKgQXQgbGVhc3QgYnkgaXRzZWxmIGl0IGRvZXNuJ3Qgc2VlbSB0byBiZSBtdWNoIGJldHRl
cg0KPj4+IHNvbHV0aW9uIHRoYW4gaGF2aW5nIHRoZSBkcm0gZHJpdmVycyBub3QgY2FsbA0K
Pj4+IHBjaV9yZXF1ZXN0X3JlZ2lvbltzXSwNCj4+PiB3aGljaCBhcGFydCBmcm9tIGh5cGVy
diBhbmQgY2lycnVzIChpaXJjIGJvY2hzIGRvZXMgaXQgZm9yDQo+Pj4gcmVzb3VyY2VzDQo+
Pj4gb3RoZXIgdGhhbiBmYiB3aGljaCB3b3VsZG4ndCBoYXZlIGJlZW4gY2xhaW1lZCBieSAi
c2ltcGxlLQ0KPj4+IGZyYW1lYnVmZmVyIikNCj4+PiBpcyBhbHJlYWR5IHRoZSBjYXNlLg0K
Pj4+DQo+Pj4gSSBkbyB0aGluayB3ZSBzaG91bGQgZG8gb25lIG9mIHRoZW0gdG8gbWFrZSB0
aGUgY29kZWJhc2UgY29oZXJlbnQ6DQo+Pj4gZWl0aGVyIHJlbW92ZSBJT1JFU09VUkNFX0JV
U1kgZnJvbSAic2ltcGxlLWZyYW1lYnVmZmVyIiBvciByZW1vdmUNCj4+PiBwY2lfcmVxdWVz
dF9yZWdpb25bc10gZnJvbSBoeXBlcnYgYW5kIGNpcnJ1cy4NCj4+DQo+PiBJIGp1c3QgZGlz
Y3Vzc2VkIHRoaXMgYSBiaXQgd2l0aCBKYXZpZXIuIEl0J3MgYSBwcm9ibGVtIHdpdGggdGhl
DQo+PiBzaW1wbGUtZnJhbWVidWZmZXIgY29kZSwgcmF0aGVyIHRoZW4gdm13Z2Z4Lg0KPj4N
Cj4+IElNSE8gdGhlIGJlc3Qgc29sdXRpb24gaXMgdG8gZHJvcCBJT1JFU09VUkNFX0JVU1kg
ZnJvbSBzeXNmYiBhbmQgaGF2ZQ0KPj4gZHJpdmVycyByZWdpc3Rlci9yZWxlYXNlIHRoZSBy
YW5nZSB3aXRoIF9CVVNZLiBUaGF0IHdvdWxkIHNpZ25hbCB0aGUNCj4+IG1lbW9yeSBiZWxv
bmdzIHRvIHRoZSBzeXNmYiBkZXZpY2UgYnV0IGlzIG5vdCBidXN5IHVubGVzcyBhIGRyaXZl
cg0KPj4gaGFzDQo+PiBiZWVuIGJvdW5kLiBBZnRlciBzaW1wbGVmYiByZWxlYXNlZCB0aGUg
cmFuZ2UsIGl0IHNob3VsZCBiZSAnbm9uLQ0KPj4gYnVzeScNCj4+IGFnYWluIGFuZCBhdmFp
bGFibGUgZm9yIHZtd2dmeC4gU2ltcGxlZHJtIGRvZXMgYSBob3QtdW5wbHVnIG9mIHRoZQ0K
Pj4gc3lzZmINCj4+IGRldmljZSwgc28gdGhlIG1lbW9yeSByYW5nZSBnZXRzIHJlbGVhc2Vk
IGVudGlyZWx5LiBJZiB5b3Ugd2FudCwgSSdsbA0KPj4gcHJlcGFyZSBzb21lIHBhdGNoZXMg
Zm9yIHRoaXMgc2NlbmFyaW8uDQo+Pg0KPj4gSWYgdGhpcyBkb2Vzbid0IHdvcmssIHB1c2hp
bmcgYWxsIHJlcXVlc3QvcmVsZWFzZSBwYWlycyBpbnRvIGRyaXZlcnMNCj4+IHdvdWxkIGJl
IG15IG5leHQgb3B0aW9uLg0KPj4NCj4+IElmIG5vbmUgb2YgdGhpcyBpcyBmZWFzaWJsZSwg
d2UgY2FuIHN0aWxsIHJlbW92ZSBwY2lfcmVxdWVzdF9yZWdpb24oKQ0KPj4gZnJvbSB2bXdn
ZnguDQo+IA0KPiANCj4gSSB0aGluayB0aGF0J3Mgb3J0aG9nb25hbCB0byB0aGUgZml4IGJl
Y2F1c2UgaGF2aW5nIHBjaV9yZXF1ZXN0X3JlZ2lvbg0KPiBtYWtlcyB2bXdnZnggYmVoYXZl
IGRpZmZlcmVudGx5IGZyb20gbWFqb3JpdHkgb2YgRFJNIGRyaXZlcnMsIGUuZy4gb24NCj4g
c3lzdGVtcyB3aXRoIHN5c2ZiIGVuYWJsZWQgd2l0aCA1LjE1IHZtd2dmeCBmYWlscyB0byBi
b290IGFuZCBsZWF2ZXMNCj4gdGhlIHN5c3RlbSBicm9rZW4gd2l0aG91dCBhbnkgZmIgZHJp
dmVyIChiZWNhdXNlIHdoaWxlIHdlIGhhdmUNCj4gKnJlbW92ZV9jb25mbGljdGluZypfZnJh
bWVidWZmZXJzIHdlIGRvbid0IGhhdmUgZHJtX3Jlc3RvcmVfc3lzdGVtX2ZiDQo+IG9yIHN1
Y2ggdG8gbG9hZCBiYWNrIHRoZSBib290IGZiIGFmdGVyIGRybSBkcml2ZXIgbG9hZCBmYWls
cykgYnV0IHNpbmNlDQo+IGl0J3Mgb25lIG9mIHRoZSBmZXcgZHJpdmVycyB3aGljaCBkb2Vz
IHJlcXVlc3QgcmVnaW9ucyBpdCB0b29rIGEgYml0DQo+IGZvciB1cyB0byBub3RpY2UuDQo+
IA0KPiBTbyBpbiB0aGlzIGNhc2UgSSdkIG11Y2ggcmF0aGVyIGJlIGxpa2UgdGhlIG90aGVy
IGRyaXZlcnMgcmF0aGVyIHRoYW4NCj4gY29ycmVjdCBiZWNhdXNlIGl0IGxvd2VycyB0aGUg
b2RkcyBvZiB2bXdnZnggYnJlYWtpbmcgaW4gdGhlIGZ1dHVyZS4NCg0KV2VsbCwgaWYgeW91
IHdhbnQgdG8gcmVtb3ZlIHRoZSBjYWxscyB0aGVuIGRvIHNvLCBvZiBjb3Vyc2UuDQoNCkkn
ZCByYXRoZXIgYWRkIHRoZSByZXF1ZXN0X21lbW9yeSgpIGNhbGxzIHRvIGFsbCB0aGUgb3Ro
ZXIgZHJpdmVycyB0aGF0IA0KYXJlIG1pc3NpbmcgdGhlbS4gSmF2aWVyIHN1Z2dlc3RlZCB0
byBtYWtlIHRoaXMgYW4gb2ZmaWNpYWwgVE9ETyBpdGVtLiANCkhhdmluZyB0aGUgQlVTWSBm
bGFnIHNldCB3aGVuIGEgZHJpdmVyIGlzIGFjdGl2ZSwgc3RpbGwgaXMgdGhlIGNvcnJlY3Qg
DQp0aGluZyB0byBkby4NCg0KSSdtIG5vdCBzdXJlIGkgdW5kZXJzdGFuZCB5b3VyIGNvbW1l
bnQgYWJvdXQgZHJtX3Jlc3RvcmVfc3lzdGVtX2ZiLiANClRoZXJlIGlzIG5vIHdheSBvZiBh
dG9taWNhbGx5IHN3aXRjaGluZyBkcml2ZXJzIGFuZCB0aGF0J3MgYWx3YXlzIGJlZW4gYSAN
CnByb2JsZW0uIEZhaWxpbmcgYXQgcGNpX3JlcXVlc3RfbWVtcm95KCkgaXMganVzdCBvbmUg
b2YgbWFueSBwb3NzaWJsZSANCnJlYXNvbnMgZm9yIHRoZSBzd2l0Y2ggdG8gZmFpbC4gVGhl
IGJlc3QgeW91IGNvdWxkIGRvIGlzIHRvIHJlYXJyYW5nZSANCnRoZSBjb2RlIHRvIGRvICdy
ZW1vdmVfY29uZmxpY3RpbmcqKCknIGF0IHRoZSBsYXRlc3QgcG9pbnQgcG9zc2libGUuDQoN
CkJlc3QgcmVnYXJkcw0KVGhvbWFzDQoNCj4gDQo+IHoNCj4gDQoNCi0tIA0KVGhvbWFzIFpp
bW1lcm1hbm4NCkdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXINClNVU0UgU29mdHdhcmUgU29s
dXRpb25zIEdlcm1hbnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBH
ZXJtYW55DQooSFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJlcjog
SXZvIFRvdGV2DQo=

--------------QQkpORofor7iheI7kCY9E4Mp--

--------------YVv376TGAl3JAGpuNYAkS409
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHoImIFAwAAAAAACgkQlh/E3EQov+Ch
DQ//eXb3QBsJ38R8LwBdngLlYG7A9EKDr0WP7FVdd2RQiyn6HYOODJ4M5mRRolzN+D3RSGUszza2
MOrlqS40/zxQZhZXlDoTDHdKjWz5cjwVr3tAFORVIgy0lTGa8CvTQA85lLDTL1uv8M6duFyITCwn
HxVnrYHExfisHXPDONs8BbbddZy4PBtYS81tF90TvvdYxMH7OfZt0SRqd3Lfo2h+6esi35Nq2BAf
ooUdlM9+ddro2t1oYh3eeqlr/VuyFLKcgRbEJEkxezBNPZQl5ab8QxUbymXQmo/Klim2dvkoCJBb
YeUd7AGrVGw4z88ZJ36661t5cXlSlds15B62JB8v3wpZREyXg2f8UVg15aN0AmnhnRDH3X1W2HI1
KvXPrSVBiqZ08BO5zt5vFF8htzmhI85gzixuUWLuF2oQmITuIW9ZdnYlyds4gkglhGiXXrquIFBR
dvJU4Qcp4ah96d2dJOhhCvonM/DfTuLTiSi9pEIv+sTxvdTa77zcOMWnxNMRuFUd95RI4fGrbdwv
TfnlIYyQsGGnG0FjR11tooJJHUf8Qp5xcwRyd/6MASfD59d8WYrPyW2EAI9+rXwn3o9thWK3QIdE
ONjwBufQO6OyrcO1uqErPESVipIOEQTSfFJnZrPplZh9N8A194pXZX1mg8ziaZLxC16Qob7tay5K
5OQ=
=AYN/
-----END PGP SIGNATURE-----

--------------YVv376TGAl3JAGpuNYAkS409--
