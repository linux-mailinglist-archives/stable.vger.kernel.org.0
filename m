Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A3D6EC862
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 11:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjDXJHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 05:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjDXJHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 05:07:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CA810F0;
        Mon, 24 Apr 2023 02:07:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6E5D421A97;
        Mon, 24 Apr 2023 09:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1682327266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SGD+BucwGfbqQ4YTykkUooDJ6V+PD7E9RWT+3z5Q+D0=;
        b=tHaOZWeTAvZw49i0zC3hJSv8ar/7nNs5/1v4S2uX4BKukt+4199GzNn7ui0UsgcsSpG9w1
        bkN6x4zi8ZqgeYiuYwilIRVteMVxVp5vVfm6wruPrU7WqFbZeaKygD2Bhtyw6rmxE930Tz
        XUVKMo4dp6Il2GCMY2xNfbOByRfrRf8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1682327266;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SGD+BucwGfbqQ4YTykkUooDJ6V+PD7E9RWT+3z5Q+D0=;
        b=js37x903mmnmfVlAU4K1hY4i3egjXW0KqHf1lOsdwIsRlYzv76fC1WWH9QAc//MzS5eAfS
        9op37d7ccUvS/NBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 39CD213780;
        Mon, 24 Apr 2023 09:07:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id k/r+DOJGRmR8fgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 24 Apr 2023 09:07:46 +0000
Message-ID: <5694a9ab-d474-c101-9398-eea55aab29df@suse.de>
Date:   Mon, 24 Apr 2023 11:07:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/2] drm/ofdrm: Update expected device name
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Cyril Brulebois <cyril@debamax.com>
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Herring <robh@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
References: <20230412095509.2196162-1-cyril@debamax.com>
 <20230412095509.2196162-3-cyril@debamax.com>
 <CAMuHMdW4rZn4p=gQZRWQQSEbQPmzZUd5eN+kP_Yr7bLgTHyvig@mail.gmail.com>
Content-Language: en-US
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <CAMuHMdW4rZn4p=gQZRWQQSEbQPmzZUd5eN+kP_Yr7bLgTHyvig@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------3Y3pbc50us0Nmvsa7ArgK72j"
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3Y3pbc50us0Nmvsa7ArgK72j
Content-Type: multipart/mixed; boundary="------------ip8hjlLeTlrIhQEr3G4ZyMBc";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
 Cyril Brulebois <cyril@debamax.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Rob Herring <robh@kernel.org>, Michal Suchanek <msuchanek@suse.de>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>
Message-ID: <5694a9ab-d474-c101-9398-eea55aab29df@suse.de>
Subject: Re: [PATCH 2/2] drm/ofdrm: Update expected device name
References: <20230412095509.2196162-1-cyril@debamax.com>
 <20230412095509.2196162-3-cyril@debamax.com>
 <CAMuHMdW4rZn4p=gQZRWQQSEbQPmzZUd5eN+kP_Yr7bLgTHyvig@mail.gmail.com>
In-Reply-To: <CAMuHMdW4rZn4p=gQZRWQQSEbQPmzZUd5eN+kP_Yr7bLgTHyvig@mail.gmail.com>

--------------ip8hjlLeTlrIhQEr3G4ZyMBc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjQuMDQuMjMgdW0gMDk6MzMgc2NocmllYiBHZWVydCBVeXR0ZXJob2V2ZW46
DQo+IEhpIEN5cmlsLA0KPiANCj4gQ0MgRFQNCj4gDQo+IE9uIFdlZCwgQXByIDEyLCAyMDIz
IGF0IDEyOjA14oCvUE0gQ3lyaWwgQnJ1bGVib2lzIDxjeXJpbEBkZWJhbWF4LmNvbT4gd3Jv
dGU6DQo+PiBTaW5jZSBjb21taXQgMjQxZDJmYjU2YTE4ICgib2Y6IE1ha2UgT0YgZnJhbWVi
dWZmZXIgZGV2aWNlIG5hbWVzIHVuaXF1ZSIpLA0KPj4gYXMgc3BvdHRlZCBieSBGcsOpZMOp
cmljIEJvbm5hcmQsIHRoZSBoaXN0b3JpY2FsICJvZi1kaXNwbGF5IiBkZXZpY2UgaXMNCj4+
IGdvbmU6IHRoZSB1cGRhdGVkIGxvZ2ljIGNyZWF0ZXMgIm9mLWRpc3BsYXkuMCIgaW5zdGVh
ZCwgdGhlbiBhcyBtYW55DQo+PiAib2YtZGlzcGxheS5OIiBhcyByZXF1aXJlZC4NCj4+DQo+
PiBUaGlzIG1lYW5zIHRoYXQgb2ZmYiBubyBsb25nZXIgZmluZHMgdGhlIGV4cGVjdGVkIGRl
dmljZSwgd2hpY2ggcHJldmVudHMNCj4+IHRoZSBEZWJpYW4gSW5zdGFsbGVyIGZyb20gc2V0
dGluZyB1cCBpdHMgaW50ZXJmYWNlLCBhdCBsZWFzdCBvbiBwcGM2NGVsLg0KPj4NCj4+IEdp
dmVuIHRoZSBjb2RlIHNpbWlsYXJpdHkgaXQgaXMgbGlrZWx5IHRvIGFmZmVjdCBvZmRybSBp
biB0aGUgc2FtZSB3YXkuDQo+Pg0KPj4gSXQgbWlnaHQgYmUgYmV0dGVyIHRvIGl0ZXJhdGUg
b24gYWxsIHBvc3NpYmxlIG5vZGVzLCBidXQgdXBkYXRpbmcgdGhlDQo+PiBoYXJkY29kZWQg
ZGV2aWNlIGZyb20gIm9mLWRpc3BsYXkiIHRvICJvZi1kaXNwbGF5LjAiIGlzIGxpa2VseSB0
byBoZWxwDQo+PiBhcyBhIGZpcnN0IHN0ZXAuDQo+Pg0KPj4gTGluazogaHR0cHM6Ly9idWd6
aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMTczMjgNCj4+IExpbms6IGh0dHBz
Oi8vYnVncy5kZWJpYW4ub3JnLzEwMzMwNTgNCj4+IEZpeGVzOiAyNDFkMmZiNTZhMTggKCJv
ZjogTWFrZSBPRiBmcmFtZWJ1ZmZlciBkZXZpY2UgbmFtZXMgdW5pcXVlIikNCj4+IENjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnICMgdjYuMisNCj4+IFNpZ25lZC1vZmYtYnk6IEN5cmls
IEJydWxlYm9pcyA8Y3lyaWxAZGViYW1heC5jb20+DQo+IA0KPiBUaGFua3MgZm9yIHlvdXIg
cGF0Y2gsIHdoaWNoIGlzIG5vdyBjb21taXQgM2E5ZDhlYTI1MzllYmViZA0KPiAoImRybS9v
ZmRybTogVXBkYXRlIGV4cGVjdGVkIGRldmljZSBuYW1lIikgaW4gZmJkZXYvZm9yLW5leHQu
DQo+IA0KPj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL3Rpbnkvb2Zkcm0uYw0KPj4gKysrIGIv
ZHJpdmVycy9ncHUvZHJtL3Rpbnkvb2Zkcm0uYw0KPj4gQEAgLTEzOTAsNyArMTM5MCw3IEBA
IE1PRFVMRV9ERVZJQ0VfVEFCTEUob2YsIG9mZHJtX29mX21hdGNoX2Rpc3BsYXkpOw0KPj4N
Cj4+ICAgc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgb2Zkcm1fcGxhdGZvcm1fZHJp
dmVyID0gew0KPj4gICAgICAgICAgLmRyaXZlciA9IHsNCj4+IC0gICAgICAgICAgICAgICAu
bmFtZSA9ICJvZi1kaXNwbGF5IiwNCj4+ICsgICAgICAgICAgICAgICAubmFtZSA9ICJvZi1k
aXNwbGF5LjAiLA0KPj4gICAgICAgICAgICAgICAgICAub2ZfbWF0Y2hfdGFibGUgPSBvZmRy
bV9vZl9tYXRjaF9kaXNwbGF5LA0KPj4gICAgICAgICAgfSwNCj4+ICAgICAgICAgIC5wcm9i
ZSA9IG9mZHJtX3Byb2JlLA0KPiANCj4gU2FtZSBjb21tZW50IGFzIGZvciAiW1BBVENIIDEv
Ml0gZmJkZXYvb2ZmYjogVXBkYXRlIGV4cGVjdGVkIGRldmljZQ0KPiBuYW1lIi4NCj4gDQo+
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvQ0FNdUhNZFZHRWVBc21iNHRBdXVxcUdKLTQr
QkJFVHdFd1lKQStNOU55SnYwQkpfaE5nQG1haWwuZ21haWwuY29tDQoNClNvcnJ5IHRoYXQg
SSBtaXNzZWQgdGhpcyBwYXRjaC4gSSBhZ3JlZSB0aGF0IGl0J3MgcHJvYmFibHkgbm90IGNv
cnJlY3QuIA0KQXQgbGVhc3QgaW4gb2Zkcm0sIHdlIHdhbnQgdG8gYmUgYWJsZSB0byB1c2Ug
bXVsdGlwbGUgZnJhbWVidWZmZXJzIGF0IA0KdGhlIHNhbWUgdGltZTsgYSBmZWF0dXJlIHRo
YXQgaGFzIGJlZW4gYnJva2VuIGJ5IHRoaXMgY2hhbmdlLg0KDQpCZXN0IHJlZ2FyZHMNClRo
b21hcw0KDQo+IA0KPiBHcntvZXRqZSxlZXRpbmd9cywNCj4gDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICBHZWVydA0KPiANCg0KLS0gDQpUaG9tYXMgWmltbWVybWFubg0KR3JhcGhp
Y3MgRHJpdmVyIERldmVsb3Blcg0KU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFueSBH
bWJIDQpGcmFua2Vuc3RyYXNzZSAxNDYsIDkwNDYxIE51ZXJuYmVyZywgR2VybWFueQ0KR0Y6
IEl2byBUb3RldiwgQW5kcmV3IE15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIEJvdWRpZW4gTW9l
cm1hbg0KSFJCIDM2ODA5IChBRyBOdWVybmJlcmcpDQo=

--------------ip8hjlLeTlrIhQEr3G4ZyMBc--

--------------3Y3pbc50us0Nmvsa7ArgK72j
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmRGRuEFAwAAAAAACgkQlh/E3EQov+Dr
pRAAnj/UaISsoar5e1fo8PKJl+COcayGzfuST7+pRcHKO17GTckJv7liddZ2C+EMFsQB3NL5cHoU
dszXVUkbrVVr0U3PHDvSiXLkRC7beKNI4vxuqOZsOQiwAQzVBVq9CfqpOEqrner+5UIOolOoEk+E
R0cE5N7xJY+QgYqHqm5pxM34PiHe72NfW5juUo/hA57NomKntlBX1zykT7pUiJ7cWrZe04Yeao82
5KLr6gAfWLJsLAoeFI+X+a7govMo1QNxVY1VlWBOQpPV1WnsV7WL/D2Vh8J1ML+xRB1B+cybj6Rj
VOIIp9rEc4bXt5N0CpdtXmi/RDB2wVvxluV7++aTfe33s6bWQN30MABA7m1kvZQbgQLLEWfHcGkN
JDN8fd0TZ087lIO0JJ9fpjb6Hm2s1iOm5HwK7h+bK32BMDfVMXBjpsUOM3Ox2UgoN9GzltNssUi8
abKlBw/x4TQvVl6rewqe3dwsCh2BO3CN/cJgqrKSk45gERItJvsVVGnq8VZG8YxU0D8b3Hb8YxEW
qw8lUryEr6pI2uo4Qn55Sh0oKexgmpW5whB1KZG2ePjNjVdtFZ/DLUHLyP1lDR6yf5Wq22wTDR9o
W09VGWZ+eOjWfyGfO0NRpfpUOW0WfF4XJsQLUlVZoRGgt4a7DWyZ0PjR6pSN+kM08ecWM3Kp4xpN
hgg=
=Ntcm
-----END PGP SIGNATURE-----

--------------3Y3pbc50us0Nmvsa7ArgK72j--
