Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401184936F0
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 10:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352927AbiASJNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 04:13:12 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:56036 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352899AbiASJNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 04:13:11 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B38401F3BB;
        Wed, 19 Jan 2022 09:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642583590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQVOFB3ezI5uQW3/DO9hFezH1aofBWbcWf/cnQ60Mg8=;
        b=odg2ii8kovVLjNDlglYZKeSZcf31qN86NR3h/I3S1DPA5IuNKYdnnlFfh6p7Pdavl1MnfS
        blLsnXRmtaTHtWujgX3lJO7ymgdV8+62Jam0XE1j2uMfoDksVmKv1myU6yC05UCIkvAalk
        0qupxTSGmQw6uHcVWw0fT20N0amiLac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642583590;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQVOFB3ezI5uQW3/DO9hFezH1aofBWbcWf/cnQ60Mg8=;
        b=k+qogi2tnl+Ul80gM5g/o3RWvxLT5QfMyIKJUmbe4PSrKmg86lBgpWXuUkaxhdpCKg9wwJ
        gz7efoyaJatH7+Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8BA5413B2D;
        Wed, 19 Jan 2022 09:13:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5+zYICbW52HWHQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 19 Jan 2022 09:13:10 +0000
Message-ID: <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
Date:   Wed, 19 Jan 2022 10:13:09 +0100
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
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wh3oXNf8IavelGruZ0XAkFNq"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wh3oXNf8IavelGruZ0XAkFNq
Content-Type: multipart/mixed; boundary="------------RTzj7QXoB0K0S01nWi5zD2ee";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Zack Rusin <zackr@vmware.com>,
 "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
 "javierm@redhat.com" <javierm@redhat.com>
Cc: Martin Krastev <krastevm@vmware.com>,
 Maaz Mombasawala <mombasawalam@vmware.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
References: <20220117180359.18114-1-zack@kde.org>
 <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
 <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
In-Reply-To: <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>

--------------RTzj7QXoB0K0S01nWi5zD2ee
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTkuMDEuMjIgdW0gMDM6MTUgc2NocmllYiBaYWNrIFJ1c2luOg0KPiBPbiBU
dWUsIDIwMjItMDEtMTggYXQgMjA6MDAgKzAxMDAsIEphdmllciBNYXJ0aW5leiBDYW5pbGxh
cyB3cm90ZToNCj4+IEhlbGxvIFphY2ssDQo+Pg0KPj4gT24gMS8xNy8yMiAxOTowMywgWmFj
ayBSdXNpbiB3cm90ZToNCj4+PiBGcm9tOiBaYWNrIFJ1c2luIDx6YWNrckB2bXdhcmUuY29t
Pg0KPj4+DQo+Pj4gV2hlbiBzeXNmYl9zaW1wbGUgaXMgZW5hYmxlZCBsb2FkaW5nIHZtd2dm
eCBmYWlscyBiZWNhdXNlIHRoZSByZWdpb25zDQo+Pj4gYXJlIGhlbGQgYnkgdGhlIHBsYXRm
b3JtLiBJbiB0aGF0IGNhc2UNCj4+PiByZW1vdmVfY29uZmxpY3RpbmcqX2ZyYW1lYnVmZmVy
cw0KPj4+IG9ubHkgcmVtb3ZlcyB0aGUgc2ltcGxlZmIgYnV0IG5vdCB0aGUgcmVnaW9ucyBo
ZWxkIGJ5IHN5c2ZiLg0KPj4+DQo+Pg0KPj4gSW5kZWVkLCB0aGF0J3MgYW4gaXNzdWUuIEkg
d29uZGVyIGlmIHdlIHNob3VsZCBkcm9wIHRoZSBJT1JFU09VUkNFX0JVU1kNCj4+IGZsYWcg
ZnJvbSB0aGUgbWVtb3J5IHJlc291cmNlIGFkZGVkIHRvIHRoZSAic2ltcGxlLWZyYW1lYnVm
ZmVyIiBkZXZpY2UNCj4+ID8NCj4gDQo+IEkgdGhpbmsgdGhpcyBpcyBvbmUgb2YgdGhvc2Ug
Y2FzZXMgd2hlcmUgaXQgZGVwZW5kcyBvbiB3aGF0IHdlIHBsYW4gdG8NCj4gZG8gYWZ0ZXIg
dGhhdC4gU2VtZW50aWNhbGx5IGl0IG1ha2VzIHNlbnNlIHRvIGhhdmUgaXQgaW4gdGhlcmUg
LSB0aGUNCj4gZnJhbWVidWZmZXIgbWVtb3J5IGlzIGNsYWltZWQgYnkgdGhlICJzaW1wbGUt
ZnJhbWVidWZmZXIiIGFuZCBpdCdzDQo+IGJ1c3ksIGl0J3MganVzdCB0aGF0IGl0IGNyZWF0
ZXMgaXNzdWVzIGZvciBkcml2ZXJzIGFmdGVyIHVubG9hZGluZy4gSQ0KPiB0aGluayByZW1v
dmluZyBpdCwgd2hpbGUgbWFraW5nIHRoaW5ncyBlYXNpZXIgZm9yIGRyaXZlcnMsIHdvdWxk
IGJlDQo+IGNvbmZ1c2luZyBmb3IgcGVvcGxlIHJlYWRpbmcgdGhlIGNvZGUgbGF0ZXIsIHVu
bGVzcyB0aGVyZSdzIHNvbWUga2luZA0KPiBvZiBjbGVhbnVwIHRoYXQgd291bGQgaGFwcGVu
IHdpdGggaXQgKGUuZy4gcmVtb3ZpbmcgSU9SRVNPVVJDRV9CVVNZDQo+IGFsdG9nZXRoZXIg
YW5kIG1ha2luZyB0aGUgZHJtIGRyaXZlcnMgcHJvcGVybHkgcmVxdWVzdCB0aGVpcg0KPiBy
ZXNvdXJjZXMpLsKgQXQgbGVhc3QgYnkgaXRzZWxmIGl0IGRvZXNuJ3Qgc2VlbSB0byBiZSBt
dWNoIGJldHRlcg0KPiBzb2x1dGlvbiB0aGFuIGhhdmluZyB0aGUgZHJtIGRyaXZlcnMgbm90
IGNhbGwgcGNpX3JlcXVlc3RfcmVnaW9uW3NdLA0KPiB3aGljaCBhcGFydCBmcm9tIGh5cGVy
diBhbmQgY2lycnVzIChpaXJjIGJvY2hzIGRvZXMgaXQgZm9yIHJlc291cmNlcw0KPiBvdGhl
ciB0aGFuIGZiIHdoaWNoIHdvdWxkbid0IGhhdmUgYmVlbiBjbGFpbWVkIGJ5ICJzaW1wbGUt
ZnJhbWVidWZmZXIiKQ0KPiBpcyBhbHJlYWR5IHRoZSBjYXNlLg0KPiANCj4gSSBkbyB0aGlu
ayB3ZSBzaG91bGQgZG8gb25lIG9mIHRoZW0gdG8gbWFrZSB0aGUgY29kZWJhc2UgY29oZXJl
bnQ6DQo+IGVpdGhlciByZW1vdmUgSU9SRVNPVVJDRV9CVVNZIGZyb20gInNpbXBsZS1mcmFt
ZWJ1ZmZlciIgb3IgcmVtb3ZlDQo+IHBjaV9yZXF1ZXN0X3JlZ2lvbltzXSBmcm9tIGh5cGVy
diBhbmQgY2lycnVzLg0KDQpJIGp1c3QgZGlzY3Vzc2VkIHRoaXMgYSBiaXQgd2l0aCBKYXZp
ZXIuIEl0J3MgYSBwcm9ibGVtIHdpdGggdGhlIA0Kc2ltcGxlLWZyYW1lYnVmZmVyIGNvZGUs
IHJhdGhlciB0aGVuIHZtd2dmeC4NCg0KSU1ITyB0aGUgYmVzdCBzb2x1dGlvbiBpcyB0byBk
cm9wIElPUkVTT1VSQ0VfQlVTWSBmcm9tIHN5c2ZiIGFuZCBoYXZlIA0KZHJpdmVycyByZWdp
c3Rlci9yZWxlYXNlIHRoZSByYW5nZSB3aXRoIF9CVVNZLiBUaGF0IHdvdWxkIHNpZ25hbCB0
aGUgDQptZW1vcnkgYmVsb25ncyB0byB0aGUgc3lzZmIgZGV2aWNlIGJ1dCBpcyBub3QgYnVz
eSB1bmxlc3MgYSBkcml2ZXIgaGFzIA0KYmVlbiBib3VuZC4gQWZ0ZXIgc2ltcGxlZmIgcmVs
ZWFzZWQgdGhlIHJhbmdlLCBpdCBzaG91bGQgYmUgJ25vbi1idXN5JyANCmFnYWluIGFuZCBh
dmFpbGFibGUgZm9yIHZtd2dmeC4gU2ltcGxlZHJtIGRvZXMgYSBob3QtdW5wbHVnIG9mIHRo
ZSBzeXNmYiANCmRldmljZSwgc28gdGhlIG1lbW9yeSByYW5nZSBnZXRzIHJlbGVhc2VkIGVu
dGlyZWx5LiBJZiB5b3Ugd2FudCwgSSdsbCANCnByZXBhcmUgc29tZSBwYXRjaGVzIGZvciB0
aGlzIHNjZW5hcmlvLg0KDQpJZiB0aGlzIGRvZXNuJ3Qgd29yaywgcHVzaGluZyBhbGwgcmVx
dWVzdC9yZWxlYXNlIHBhaXJzIGludG8gZHJpdmVycyANCndvdWxkIGJlIG15IG5leHQgb3B0
aW9uLg0KDQpJZiBub25lIG9mIHRoaXMgaXMgZmVhc2libGUsIHdlIGNhbiBzdGlsbCByZW1v
dmUgcGNpX3JlcXVlc3RfcmVnaW9uKCkgDQpmcm9tIHZtd2dmeC4NCg0KQmVzdCByZWdhcmRz
DQpUaG9tYXMNCg0KPiANCj4gDQo+IA0KPj4+IExpa2UgdGhlIG90aGVyIGRybSBkcml2ZXJz
IHdlIG5lZWQgdG8gc3RvcCByZXF1ZXN0aW5nIGFsbCB0aGUgcGNpDQo+Pj4gcmVnaW9ucw0K
Pj4+IHRvIGxldCB0aGUgZHJpdmVyIGxvYWQgd2l0aCBwbGF0Zm9ybSBjb2RlIGVuYWJsZWQu
DQo+Pj4gVGhpcyBhbGxvd3Mgdm13Z2Z4IHRvIGxvYWQgY29ycmVjdGx5IG9uIHN5c3RlbXMg
d2l0aCBzeXNmYl9zaW1wbGUNCj4+PiBlbmFibGVkLg0KPj4+DQo+Pg0KPj4gSSByZWFkIHRo
aXMgdmVyeSBpbnRlcmVzdGluZyB0aHJlYWQgZnJvbSB0d28geWVhcnMgYWdvOg0KPj4NCj4+
IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIwLzExLzUvMjQ4DQo+Pg0KPj4gTWF5YmUgaXMg
d29ydGggbWVudGlvbmluZyBpbiB0aGUgY29tbWl0IG1lc3NhZ2Ugd2hhdCBEYW5pZWwgc2Fp
ZCB0aGVyZSwNCj4+IHRoYXQgaXMgdGhhdCBvbmx5IGEgZmV3IERSTSBkcml2ZXJzIHJlcXVl
c3QgZXhwbGljaXRseSB0aGUgUENJIHJlZ2lvbnMNCj4+IGFuZCB0aGUgb25seSByZWxpYWJs
ZSBhcHByb2FjaCBpcyBmb3IgYnVzIGRyaXZlcnMgdG8gY2xhaW0gdGhlc2UuDQo+IA0KPiBB
aCwgZ3JlYXQgcG9pbnQuIEknbGwgdXBkYXRlIHRoZSBjb21taXQgbG9nIHdpdGggdGhhdC4N
Cj4gDQo+Pj4gU2lnbmVkLW9mZi1ieTogWmFjayBSdXNpbiA8emFja3JAdm13YXJlLmNvbT4N
Cj4+PiBGaXhlczogNTIzMzc1Yzk0M2U1ICgiZHJtL3Ztd2dmeDogUG9ydCB2bXdnZnggdG8g
YXJtNjQiKQ0KPj4+IENjOiBkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+Pj4g
Q2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4+IFJldmlld2VkLWJ5OiBNYXJ0aW4g
S3Jhc3RldiA8a3Jhc3Rldm1Adm13YXJlLmNvbT4NCj4+PiAtLS0NCj4+DQo+PiBUaGUgcGF0
Y2ggbG9va3MgZ29vZCB0byBtZSwgdGhhbmtzIGEgbG90IGZvciBmaXhpbmcgdGhpczoNCj4+
DQo+PiBSZXZpZXdlZC1ieTogSmF2aWVyIE1hcnRpbmV6IENhbmlsbGFzIDxqYXZpZXJtQHJl
ZGhhdC5jb20+DQo+IA0KPiBUaGFua3MgZm9yIHRha2luZyBhIGxvb2sgYXQgdGhpcywgSSBh
cHByZWNpYXRlIGl0IQ0KPiANCj4geg0KDQotLSANClRob21hcyBaaW1tZXJtYW5uDQpHcmFw
aGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55
IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2VybWFueQ0KKEhSQiAz
NjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3Rldg0K

--------------RTzj7QXoB0K0S01nWi5zD2ee--

--------------wh3oXNf8IavelGruZ0XAkFNq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHn1iYFAwAAAAAACgkQlh/E3EQov+DV
Zg//ayYmFOm1qC5sqQWU/Kue3lfKyDLlaopB/E/j4MGXZOivrQBYA5VHS4WDQASl6GE4g5rrJYuZ
H+dTPc7SVPFCA9KTfFZFUqTDaBOC+zZCzhTMoe4XHdVzy/7z5LYPYiWYVnrlN4CJXq/4MWcYfxm2
UgILyWPvZnGeV0cYAVFDaygm4TwA8WJlWStg618rMZHfYbN8dbWnskZaNczEtwumL0VNi7dbCJWX
6UTSnEmvcZ7jJnUgGrIsLFLIWou4w+Cy6cdGyCzaagasdt583bX8MTdADB299A6AFrxwnfMpXwf9
5YjPh5E1+rWH0Hc7OYbKDd0yZCEAFF+8jYeGNnOsVxDmW0+yLwd26Yw/Y2zXcERncYyDeKDowVC7
e6sMn31e2CEzJvWpqcFSi6jyoXYiC+QZjY+DehIonTGRK0chuu28GuseB4MpqT15pCkmYp+OYU9n
qh0+jjfZ5dkZrPjkreA6P/IEY/8NHBX0ea/n6tsDtb4BfZpBAqAFID+dDQTXdb4q49ULWXOCSl7X
zG0nXnFwFxUTFqTBEEE5DV2WpDXsOz02Js3lOXIPtFFZ83n1CxaawIYaJPLnhdz90yfbvx6Qi3Hi
9mWEGamOtpUohS4xi1pONNAGVsGJINiV5JAPeFu35CfoKryJrIx25WiYW9q2EAoezm9rcXq8AhKl
dv0=
=uV3U
-----END PGP SIGNATURE-----

--------------wh3oXNf8IavelGruZ0XAkFNq--
