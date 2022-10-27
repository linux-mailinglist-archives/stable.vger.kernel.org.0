Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D73560F5EB
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 13:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbiJ0LI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 07:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiJ0LI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 07:08:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0000940BCA;
        Thu, 27 Oct 2022 04:08:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A131122169;
        Thu, 27 Oct 2022 11:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666868905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zjRw91+bjPb+NJI6SVi4nLwp8R9hn7VJxGkhfDimwig=;
        b=OHW1wYt5um6ppAxzIJskLw0eWtTvcuqb7bTl2wV2n9H3j5OOVuhLJDwztnrNbZBlphy+Px
        69PLLLxnAzbnTJrNTY+dmZJuiHSYNW0xJa+TwxGsHcbiVGTgPKq1/dcE53Q5e3sgkJJmgh
        GQ+ZLvowMqcwKPQPCT6n9KxpShSahps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666868905;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zjRw91+bjPb+NJI6SVi4nLwp8R9hn7VJxGkhfDimwig=;
        b=eKuGLJ7pzAWzcL4THnPkJb+q8Yb3lrRmHDK3egskllvQ1G4WpL4t6b2DsGolK9XJuPsbsJ
        XqE0dyRCfpnFzjDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 65264134CA;
        Thu, 27 Oct 2022 11:08:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4f6MF6lmWmMsGQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 27 Oct 2022 11:08:25 +0000
Message-ID: <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de>
Date:   Thu, 27 Oct 2022 13:08:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] drm/simpledrm: Only advertise formats that are supported
Content-Language: en-US
To:     Hector Martin <marcan@marcan.st>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>
Cc:     Pekka Paalanen <pekka.paalanen@collabora.com>,
        dri-devel@lists.freedesktop.org, asahi@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221027101327.16678-1-marcan@marcan.st>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20221027101327.16678-1-marcan@marcan.st>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------IMXj1Q32CB9vzKIj9YB0Otxb"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------IMXj1Q32CB9vzKIj9YB0Otxb
Content-Type: multipart/mixed; boundary="------------Ot0A0KnCOWsH9L0XpzR8TkxL";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Hector Martin <marcan@marcan.st>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Daniel Vetter <daniel@ffwll.ch>,
 Javier Martinez Canillas <javierm@redhat.com>
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>,
 dri-devel@lists.freedesktop.org, asahi@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de>
Subject: Re: [PATCH] drm/simpledrm: Only advertise formats that are supported
References: <20221027101327.16678-1-marcan@marcan.st>
In-Reply-To: <20221027101327.16678-1-marcan@marcan.st>

--------------Ot0A0KnCOWsH9L0XpzR8TkxL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjcuMTAuMjIgdW0gMTI6MTMgc2NocmllYiBIZWN0b3IgTWFydGluOg0KPiBV
bnRpbCBub3csIHNpbXBsZWRybSB1bmNvbmRpdGlvbmFsbHkgYWR2ZXJ0aXNlZCBhbGwgZm9y
bWF0cyB0aGF0IGNhbiBiZQ0KPiBzdXBwb3J0ZWQgbmF0aXZlbHkgYXMgY29udmVyc2lvbnMu
IEhvd2V2ZXIsIHdlIGRvbid0IGFjdHVhbGx5IGhhdmUgYQ0KPiBmdWxsIGNvbnZlcnNpb24g
bWF0cml4IG9mIGhlbHBlcnMuIEFsdGhvdWdoIHRoZSBsaXN0IGlzIGFyZ3VhYmx5DQo+IHBy
b3ZpZGVkIHRvIHVzZXJzcGFjZSBpbiBwcmVjZWRlbmNlIG9yZGVyLCB1c2Vyc3BhY2UgY2Fu
IHBpY2sgc29tZXRoaW5nDQo+IG91dC1vZi1vcmRlciAoYW5kIHRodXMgYnJlYWsgd2hlbiBp
dCBzaG91bGRuJ3QpLCBvciBzaW1wbHkgb25seSBzdXBwb3J0DQo+IGEgZm9ybWF0IHRoYXQg
aXMgdW5zdXBwb3J0ZWQgKGFuZCB0aHVzIHRoaW5rIGl0IGNhbiB3b3JrLCB3aGljaCByZXN1
bHRzDQo+IGluIHRoZSBhcHBlYXJhbmNlIG9mIGEgaGFuZyBhcyBGQiBibGl0cyBmYWlsIGxh
dGVyIG9uLCBpbnN0ZWFkIG9mIHRoZQ0KPiBpbml0aWFsaXphdGlvbiBlcnJvciB5b3UnZCBl
eHBlY3QgaW4gdGhpcyBjYXNlKS4NCj4gDQo+IFNwbGl0IHVwIHRoZSBmb3JtYXQgdGFibGUg
aW50byBzZXBhcmF0ZSBvbmVzIGZvciBlYWNoIHJlcXVpcmVkIHN1YnNldCwNCj4gYW5kIHRo
ZW4gcGljayBvbmUgYmFzZWQgb24gdGhlIG5hdGl2ZSBmb3JtYXQuIEFsc28gcmVtb3ZlIHRo
ZQ0KPiBuYXRpdmU8LT5jb252ZXJzaW9uIG92ZXJsYXAgY2hlY2sgZnJvbSB0aGUgaGVscGVy
ICh3aGljaCBkb2Vzbid0IG1ha2UNCj4gc2Vuc2UgYW55IG1vcmUsIHNpbmNlIHRoZSBuYXRp
dmUgZm9ybWF0IGlzIGFkdmVydGlzZWQgYW55d2F5IGFuZCB0aGlzDQo+IHdheSBSR0I1NjUv
UkdCODg4IGNhbiBzaGFyZSBhIGZvcm1hdCB0YWJsZSksIGFuZCBpbnN0ZWFkIHByaW50IHRo
ZSBzYW1lDQo+IG1lc3NhZ2UgaW4gc2ltcGxlZHJtIHdoZW4gdGhlIG5hdGl2ZSBmb3JtYXQg
aXMgbm90IG9uZSBmb3Igd2hpY2ggd2UgaGF2ZQ0KPiBjb252ZXJzaW9ucyBhdCBhbGwuDQo+
IA0KPiBUaGlzIGZpeGVzIGEgcmVhbCB1c2VyIHJlZ3Jlc3Npb24gd2hlcmUgdGhlID9SR0Iy
MTAxMDEwIHN1cHBvcnQgY29tbWl0DQo+IHN0YXJ0ZWQgYWR2ZXJ0aXNpbmcgaXQgdW5jb25k
aXRpb25hbGx5IHdoZXJlIG5vdCBzdXBwb3J0ZWQsIGFuZCBLV2luDQo+IGRlY2lkZWQgdG8g
c3RhcnQgdG8gdXNlIGl0IG92ZXIgdGhlIG5hdGl2ZSBmb3JtYXQsIGJ1dCBhbHNvIHRoZSBm
aXhlcw0KPiB0aGUgc3B1cmlvdXMgUkdCNTY1L1JHQjg4OCBmb3JtYXRzIHdoaWNoIGhhdmUg
YmVlbiB3cm9uZ2x5DQo+IHVuY29uZGl0aW9uYWxseSBhZHZlcnRpc2VkIHNpbmNlIHRoZSBk
YXduIG9mIHNpbXBsZWRybS4NCj4gDQo+IE5vdGU6IHRoaXMgcGF0Y2ggaXMgbWVyZ2VkIGJl
Y2F1c2Ugc3BsaXR0aW5nIGl0IGludG8gdHdvIHBhdGNoZXMsIG9uZQ0KPiBmb3IgdGhlIGhl
bHBlciBhbmQgb25lIGZvciBzaW1wbGVkcm0sIHdvdWxkIHJlZ3Jlc3MgYXQgdGhlIG1pZHBv
aW50DQo+IHJlZ2FyZGxlc3Mgb2YgdGhlIG9yZGVyLiBJZiBzaW1wbGVkcm0gaXMgY2hhbmdl
ZCBmaXJzdCwgdGhhdCB3b3VsZCBicmVhaw0KPiB3b3JraW5nIGNvbnZlcnNpb25zIHRvIFJH
QjU2NS9SR0I4ODggKHNpbmNlIHRob3NlIHNoYXJlIGEgdGFibGUgdGhhdA0KPiBkb2VzIG5v
dCBpbmNsdWRlIHRoZSBuYXRpdmUgZm9ybWF0cykuIElmIHRoZSBoZWxwZXIgaXMgY2hhbmdl
ZCBmaXJzdCwgaXQNCj4gd291bGQgc3RhcnQgc3B1cmlvdXNseSBhZHZlcnRpc2luZyBhbGwg
Y29udmVyc2lvbiBmb3JtYXRzIHdoZW4gdGhlDQo+IG5hdGl2ZSBmb3JtYXQgZG9lc24ndCBo
YXZlIGFueSBzdXBwb3J0ZWQgY29udmVyc2lvbnMgYXQgYWxsLg0KPiANCj4gQWNrZWQtYnk6
IFBla2thIFBhYWxhbmVuIDxwZWtrYS5wYWFsYW5lbkBjb2xsYWJvcmEuY29tPg0KPiBGaXhl
czogNmVhOTY2ZmNhMDg0ICgiZHJtL3NpbXBsZWRybTogQWRkIFtBWF1SR0IyMTAxMDEwIGZv
cm1hdHMiKQ0KPiBGaXhlczogMTFlOGY1ZmQyMjNiICgiZHJtOiBBZGQgc2ltcGxlZHJtIGRy
aXZlciIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6
IEhlY3RvciBNYXJ0aW4gPG1hcmNhbkBtYXJjYW4uc3Q+DQo+IC0tLQ0KPiAgIGRyaXZlcnMv
Z3B1L2RybS9kcm1fZm9ybWF0X2hlbHBlci5jIHwgMTUgLS0tLS0tLQ0KPiAgIGRyaXZlcnMv
Z3B1L2RybS90aW55L3NpbXBsZWRybS5jICAgIHwgNjIgKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0NCg0KV2UgY3VycmVudGx5IGhhdmUgdHdvIERSTSBkcml2ZXJzIHRoYXQgY2Fs
bCBkcm1fZmJfYnVpbGRfZm91cmNjX2xpc3QoKTogDQpzaW1wbGVkcm0gYW5kIG9mZHJtLiBJ
J3ZlIGJlZW4gdmVyeSBjYXJlZnVsIHRvIGtlZXAgdGhlIGZvcm1hdCBzZWxlY3Rpb24gDQpp
biBzeW5jIGJldHdlZW4gdGhlbS4gKFRoYXQncyB0aGUgcmVhc29uIHdoeSB0aGUgaGVscGVy
IGV4aXN0cyBhdCBhbGwuKSANCklmIHRoZSBkcml2ZXJzIHN0YXJ0IHRvIHVzZSBkaWZmZXJl
bnQgbG9naWMsIGl0IHdpbGwgb25seSBiZWNvbWUgbW9yZSANCmNoYW90aWMuDQoNClRoZSBm
b3JtYXQgYXJyYXkgb2Ygb2Zkcm0gaXMgYXQgWzFdLiBBdCBhIG1pbmltdW0sIG9mZHJtIHNo
b3VsZCBnZXQgdGhlIA0Kc2FtZSBmaXggYXMgc2ltcGxlZHJtLg0KDQpbMV0gDQpodHRwczov
L2NnaXQuZnJlZWRlc2t0b3Aub3JnL2RybS9kcm0tdGlwL3RyZWUvZHJpdmVycy9ncHUvZHJt
L3Rpbnkvb2Zkcm0uYyNuNzYwDQoNCj4gICAyIGZpbGVzIGNoYW5nZWQsIDU1IGluc2VydGlv
bnMoKyksIDIyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1
L2RybS9kcm1fZm9ybWF0X2hlbHBlci5jIGIvZHJpdmVycy9ncHUvZHJtL2RybV9mb3JtYXRf
aGVscGVyLmMNCj4gaW5kZXggZTJmNzY2MjE0NTNjLi5jNjBjMTNmM2E4NzIgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZm9ybWF0X2hlbHBlci5jDQo+ICsrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9kcm1fZm9ybWF0X2hlbHBlci5jDQo+IEBAIC04NjQsMjAgKzg2NCw2
IEBAIHNpemVfdCBkcm1fZmJfYnVpbGRfZm91cmNjX2xpc3Qoc3RydWN0IGRybV9kZXZpY2Ug
KmRldiwNCj4gICAJCSsrZm91cmNjczsNCj4gICAJfQ0KPiAgIA0KPiAtCS8qDQo+IC0JICog
VGhlIHBsYW5lJ3MgYXRvbWljX3VwZGF0ZSBoZWxwZXIgY29udmVydHMgdGhlIGZyYW1lYnVm
ZmVyJ3MgY29sb3IgZm9ybWF0DQo+IC0JICogdG8gYSBuYXRpdmUgZm9ybWF0IHdoZW4gY29w
eWluZyB0byBkZXZpY2UgbWVtb3J5Lg0KPiAtCSAqDQo+IC0JICogSWYgdGhlcmUgaXMgbm90
IGEgc2luZ2xlIGZvcm1hdCBzdXBwb3J0ZWQgYnkgYm90aCwgZGV2aWNlIGFuZA0KPiAtCSAq
IGRyaXZlciwgdGhlIG5hdGl2ZSBmb3JtYXRzIGFyZSBsaWtlbHkgbm90IHN1cHBvcnRlZCBi
eSB0aGUgY29udmVyc2lvbg0KPiAtCSAqIGhlbHBlcnMuIFRoZXJlZm9yZSAqb25seSogc3Vw
cG9ydCB0aGUgbmF0aXZlIGZvcm1hdHMgYW5kIGFkZCBhDQo+IC0JICogY29udmVyc2lvbiBo
ZWxwZXIgQVNBUC4NCj4gLQkgKi8NCj4gLQlpZiAoIWZvdW5kX25hdGl2ZSkgew0KPiAtCQlk
cm1fd2FybihkZXYsICJGb3JtYXQgY29udmVyc2lvbiBoZWxwZXJzIHJlcXVpcmVkIHRvIGFk
ZCBleHRyYSBmb3JtYXRzLlxuIik7DQo+IC0JCWdvdG8gb3V0Ow0KPiAtCX0NCj4gLQ0KPiAg
IAkvKg0KPiAgIAkgKiBUaGUgZXh0cmEgZm9ybWF0cywgZW11bGF0ZWQgYnkgdGhlIGRyaXZl
ciwgZ28gc2Vjb25kLg0KPiAgIAkgKi8NCj4gQEAgLTg5OCw3ICs4ODQsNiBAQCBzaXplX3Qg
ZHJtX2ZiX2J1aWxkX2ZvdXJjY19saXN0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsDQo+ICAg
CQkrK2ZvdXJjY3M7DQo+ICAgCX0NCj4gICANCj4gLW91dDoNCj4gICAJcmV0dXJuIGZvdXJj
Y3MgLSBmb3VyY2NzX291dDsNCj4gICB9DQo+ICAgRVhQT1JUX1NZTUJPTChkcm1fZmJfYnVp
bGRfZm91cmNjX2xpc3QpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3Rpbnkv
c2ltcGxlZHJtLmMgYi9kcml2ZXJzL2dwdS9kcm0vdGlueS9zaW1wbGVkcm0uYw0KPiBpbmRl
eCAxODQ4OTc3OWZiOGEuLjEyNTc0MTFmM2Q0NCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9n
cHUvZHJtL3Rpbnkvc2ltcGxlZHJtLmMNCj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL3Rpbnkv
c2ltcGxlZHJtLmMNCj4gQEAgLTQ0NiwyMiArNDQ2LDQ4IEBAIHN0YXRpYyBpbnQgc2ltcGxl
ZHJtX2RldmljZV9pbml0X3JlZ3VsYXRvcnMoc3RydWN0IHNpbXBsZWRybV9kZXZpY2UgKnNk
ZXYpDQo+ICAgICovDQo+ICAgDQo+ICAgLyoNCj4gLSAqIFN1cHBvcnQgYWxsIGZvcm1hdHMg
b2Ygc2ltcGxlZmIgYW5kIG1heWJlIG1vcmU7IGluIG9yZGVyDQo+IC0gKiBvZiBwcmVmZXJl
bmNlLiBUaGUgZGlzcGxheSdzIHVwZGF0ZSBmdW5jdGlvbiB3aWxsIGRvIGFueQ0KPiArICog
U3VwcG9ydCB0aGUgc3Vic2V0IG9mIGZvcm1hdHMgdGhhdCB3ZSBoYXZlIGNvbnZlcnNpb24g
aGVscGVycyBmb3IsDQo+ICsgKiBpbiBvcmRlciBvZiBwcmVmZXJlbmNlLiBUaGUgZGlzcGxh
eSdzIHVwZGF0ZSBmdW5jdGlvbiB3aWxsIGRvIGFueQ0KPiAgICAqIGNvbnZlcnNpb24gbmVj
ZXNzYXJ5Lg0KPiAgICAqDQo+ICAgICogVE9ETzogQWRkIGJsaXQgaGVscGVycyBmb3IgcmVt
YWluaW5nIGZvcm1hdHMgYW5kIHVuY29tbWVudA0KPiAgICAqICAgICAgIGNvbnN0YW50cy4N
Cj4gICAgKi8NCj4gLXN0YXRpYyBjb25zdCB1aW50MzJfdCBzaW1wbGVkcm1fcHJpbWFyeV9w
bGFuZV9mb3JtYXRzW10gPSB7DQo+ICsNCj4gKy8qDQo+ICsgKiBTdXBwb3J0ZWQgY29udmVy
c2lvbnMgdG8gUkdCNTY1IGFuZCBSR0I4ODg6DQo+ICsgKiAgIGZyb20gW0FYXVJHQjg4ODgN
Cj4gKyAqLw0KPiArc3RhdGljIGNvbnN0IHVpbnQzMl90IHNpbXBsZWRybV9wcmltYXJ5X3Bs
YW5lX2Zvcm1hdHNfYmFzZVtdID0gew0KPiArCURSTV9GT1JNQVRfWFJHQjg4ODgsDQo+ICsJ
RFJNX0ZPUk1BVF9BUkdCODg4OCwNCj4gK307DQo+ICsNCj4gKy8qDQo+ICsgKiBTdXBwb3J0
ZWQgY29udmVyc2lvbnMgdG8gW0FYXVJHQjg4ODg6DQo+ICsgKiAgIEEvWCB2YXJpYW50cyAo
bm8tb3ApDQo+ICsgKiAgIGZyb20gUkdCNTY1DQo+ICsgKiAgIGZyb20gUkdCODg4DQo+ICsg
Ki8NCj4gK3N0YXRpYyBjb25zdCB1aW50MzJfdCBzaW1wbGVkcm1fcHJpbWFyeV9wbGFuZV9m
b3JtYXRzX3hyZ2I4ODg4W10gPSB7DQo+ICAgCURSTV9GT1JNQVRfWFJHQjg4ODgsDQo+ICAg
CURSTV9GT1JNQVRfQVJHQjg4ODgsDQo+ICsJRFJNX0ZPUk1BVF9SR0I4ODgsDQo+ICAgCURS
TV9GT1JNQVRfUkdCNTY1LA0KPiAgIAkvL0RSTV9GT1JNQVRfWFJHQjE1NTUsDQo+ICAgCS8v
RFJNX0ZPUk1BVF9BUkdCMTU1NSwNCj4gLQlEUk1fRk9STUFUX1JHQjg4OCwNCj4gK307DQo+
ICsNCj4gKy8qDQo+ICsgKiBTdXBwb3J0ZWQgY29udmVyc2lvbnMgdG8gW0FYXVJHQjIxMDEw
MTA6DQo+ICsgKiAgIEEvWCB2YXJpYW50cyAobm8tb3ApDQo+ICsgKiAgIGZyb20gW0FYXVJH
Qjg4ODgNCj4gKyAqLw0KPiArc3RhdGljIGNvbnN0IHVpbnQzMl90IHNpbXBsZWRybV9wcmlt
YXJ5X3BsYW5lX2Zvcm1hdHNfeHJnYjIxMDEwMTBbXSA9IHsNCj4gICAJRFJNX0ZPUk1BVF9Y
UkdCMjEwMTAxMCwNCj4gICAJRFJNX0ZPUk1BVF9BUkdCMjEwMTAxMCwNCj4gKwlEUk1fRk9S
TUFUX1hSR0I4ODg4LA0KPiArCURSTV9GT1JNQVRfQVJHQjg4ODgsDQo+ICAgfTsNCj4gICAN
Cj4gICBzdGF0aWMgY29uc3QgdWludDY0X3Qgc2ltcGxlZHJtX3ByaW1hcnlfcGxhbmVfZm9y
bWF0X21vZGlmaWVyc1tdID0gew0KPiBAQCAtNjQyLDcgKzY2OCw4IEBAIHN0YXRpYyBzdHJ1
Y3Qgc2ltcGxlZHJtX2RldmljZSAqc2ltcGxlZHJtX2RldmljZV9jcmVhdGUoc3RydWN0IGRy
bV9kcml2ZXIgKmRydiwNCj4gICAJc3RydWN0IGRybV9lbmNvZGVyICplbmNvZGVyOw0KPiAg
IAlzdHJ1Y3QgZHJtX2Nvbm5lY3RvciAqY29ubmVjdG9yOw0KPiAgIAl1bnNpZ25lZCBsb25n
IG1heF93aWR0aCwgbWF4X2hlaWdodDsNCj4gLQlzaXplX3QgbmZvcm1hdHM7DQo+ICsJY29u
c3QgdWludDMyX3QgKmNvbnZfZm9ybWF0czsNCj4gKwlzaXplX3QgY29udl9uZm9ybWF0cywg
bmZvcm1hdHM7DQo+ICAgCWludCByZXQ7DQo+ICAgDQo+ICAgCXNkZXYgPSBkZXZtX2RybV9k
ZXZfYWxsb2MoJnBkZXYtPmRldiwgZHJ2LCBzdHJ1Y3Qgc2ltcGxlZHJtX2RldmljZSwgZGV2
KTsNCj4gQEAgLTc1NSwxMCArNzgyLDMxIEBAIHN0YXRpYyBzdHJ1Y3Qgc2ltcGxlZHJtX2Rl
dmljZSAqc2ltcGxlZHJtX2RldmljZV9jcmVhdGUoc3RydWN0IGRybV9kcml2ZXIgKmRydiwN
Cj4gICAJZGV2LT5tb2RlX2NvbmZpZy5mdW5jcyA9ICZzaW1wbGVkcm1fbW9kZV9jb25maWdf
ZnVuY3M7DQo+ICAgDQo+ICAgCS8qIFByaW1hcnkgcGxhbmUgKi8NCj4gKwlzd2l0Y2ggKGZv
cm1hdC0+Zm9ybWF0KSB7DQoNCkkgdHJ1c3QgeW91IHdoZW4geW91IHNheSB0aGF0IDxuYXRp
dmU+LT5YUkdCODg4OCBpcyBub3QgZW5vdWdoLiBCdXQgDQphbHRob3VnaCBJJ3ZlIHJlYWQg
eW91ciByZXBsaWVzLCBJIHN0aWxsIGRvbid0IHVuZGVyc3RhbmQgd2h5IHRoaXMgDQpzd2l0
Y2ggaXMgbmVjZXNzYXJ5Lg0KDQpXaHkgZG9uJ3Qgd2UgY2FsbCBkcm1fZmJfYnVpbGRfZm91
cmNjX2xpc3QoKSB3aXRoIHRoZSBuYXRpdmUgDQpmb3JtYXQvZm9ybWF0cyBhbmQgbGV0IGl0
IGFwcGVuZCBhIG51bWJlciBvZiBmb3JtYXRzLCBzdWNoIGFzIGFkZGluZyANClhSR0I4ODgs
IGFkZGluZyBBUkdCODg4OCBpZiBuZWNlc3NhcnksIGFkZGluZyBBUkdCMjEwMTAxMCBpZiBu
ZWNlc3NhcnkuIA0KRWFjaCB3aXRoIGEgZWxhYm9yYXRlIGNvbW1lbnQgd2h5IGFuZCB3aGlj
aCB1c2Vyc3BhY2UgbmVlZHMgdGhlIGZvcm1hdC4gKD8pDQoNCkJlc3QgcmVnYXJkcw0KVGhv
bWFzDQoNCj4gKwljYXNlIERSTV9GT1JNQVRfUkdCNTY1Og0KPiArCWNhc2UgRFJNX0ZPUk1B
VF9SR0I4ODg6DQo+ICsJCWNvbnZfZm9ybWF0cyA9IHNpbXBsZWRybV9wcmltYXJ5X3BsYW5l
X2Zvcm1hdHNfYmFzZTsNCj4gKwkJY29udl9uZm9ybWF0cyA9IEFSUkFZX1NJWkUoc2ltcGxl
ZHJtX3ByaW1hcnlfcGxhbmVfZm9ybWF0c19iYXNlKTsNCj4gKwkJYnJlYWs7DQo+ICsJY2Fz
ZSBEUk1fRk9STUFUX1hSR0I4ODg4Og0KPiArCWNhc2UgRFJNX0ZPUk1BVF9BUkdCODg4ODoN
Cj4gKwkJY29udl9mb3JtYXRzID0gc2ltcGxlZHJtX3ByaW1hcnlfcGxhbmVfZm9ybWF0c194
cmdiODg4ODsNCj4gKwkJY29udl9uZm9ybWF0cyA9IEFSUkFZX1NJWkUoc2ltcGxlZHJtX3By
aW1hcnlfcGxhbmVfZm9ybWF0c194cmdiODg4OCk7DQo+ICsJCWJyZWFrOw0KPiArCWNhc2Ug
RFJNX0ZPUk1BVF9YUkdCMjEwMTAxMDoNCj4gKwljYXNlIERSTV9GT1JNQVRfQVJHQjIxMDEw
MTA6DQo+ICsJCWNvbnZfZm9ybWF0cyA9IHNpbXBsZWRybV9wcmltYXJ5X3BsYW5lX2Zvcm1h
dHNfeHJnYjIxMDEwMTA7DQo+ICsJCWNvbnZfbmZvcm1hdHMgPSBBUlJBWV9TSVpFKHNpbXBs
ZWRybV9wcmltYXJ5X3BsYW5lX2Zvcm1hdHNfeHJnYjIxMDEwMTApOw0KPiArCQlicmVhazsN
Cj4gKwlkZWZhdWx0Og0KPiArCQljb252X2Zvcm1hdHMgPSBOVUxMOw0KPiArCQljb252X25m
b3JtYXRzID0gMDsNCj4gKwkJZHJtX3dhcm4oZGV2LCAiRm9ybWF0IGNvbnZlcnNpb24gaGVs
cGVycyByZXF1aXJlZCB0byBhZGQgZXh0cmEgZm9ybWF0cy5cbiIpOw0KPiArCQlicmVhazsN
Cj4gKwl9DQo+ICAgDQo+ICAgCW5mb3JtYXRzID0gZHJtX2ZiX2J1aWxkX2ZvdXJjY19saXN0
KGRldiwgJmZvcm1hdC0+Zm9ybWF0LCAxLA0KPiAtCQkJCQkgICAgc2ltcGxlZHJtX3ByaW1h
cnlfcGxhbmVfZm9ybWF0cywNCj4gLQkJCQkJICAgIEFSUkFZX1NJWkUoc2ltcGxlZHJtX3By
aW1hcnlfcGxhbmVfZm9ybWF0cyksDQo+ICsJCQkJCSAgICBjb252X2Zvcm1hdHMsIGNvbnZf
bmZvcm1hdHMsDQo+ICAgCQkJCQkgICAgc2Rldi0+Zm9ybWF0cywgQVJSQVlfU0laRShzZGV2
LT5mb3JtYXRzKSk7DQo+ICAgDQo+ICAgCXByaW1hcnlfcGxhbmUgPSAmc2Rldi0+cHJpbWFy
eV9wbGFuZTsNCg0KLS0gDQpUaG9tYXMgWmltbWVybWFubg0KR3JhcGhpY3MgRHJpdmVyIERl
dmVsb3Blcg0KU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFueSBHbWJIDQpNYXhmZWxk
c3RyLiA1LCA5MDQwOSBOw7xybmJlcmcsIEdlcm1hbnkNCihIUkIgMzY4MDksIEFHIE7DvHJu
YmVyZykNCkdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYNCg==

--------------Ot0A0KnCOWsH9L0XpzR8TkxL--

--------------IMXj1Q32CB9vzKIj9YB0Otxb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNaZqgFAwAAAAAACgkQlh/E3EQov+DO
9Q//TzHk6nUZNnj7ErsBs/fHt+Z0chP2HnotvLQFNdUjGN6pMxsYrtA373ZD6Zlbxxut7o8CF7FW
yNsjN3gVKVUdrSLkFPKBytkUO0P6uNpYT9JE1d3V4BbIPw1ARsezHvjMtqSd3G6vpV5jLs/j7ae8
bE1g5ykrZHMVq6opOipiWPUnAHAEQ4x/QQEZrzJUKapl+BZ30A5RC5kB6c/oei+TbKeTONvMPgMD
/0XybL/v1Qwy77exgsknDXWP5wQwJyd89acdQE794ecKQuCJYZ84zFzJ+DNnbuEfPRByh0Ucmw+a
naX7ov+RDudhZOq2833rnWUuFs9Ujc1F9pxI1GkTuRCgpgpb4YgbTkn74U5kMncTNvcGZFJDAwJV
l6wbfocNv5F6RD1aB00AtU/pS6qPoH040vDv509IvvZePKGfTrQldhiXbWYyFJpHOLEs0S2YxU6o
FpJ08l0v6cyT9E6ba+z92OBKNFCbit5492lKVBtUHp2Yiqx/xGpuS6wMmm+e5RTMyzKVn/DCORp9
yMH1DWmo22tVgBcSLQgWQ/eyvBp8K8d56nmRO2/H3xKuUClfKPnk8/UFtX2EcXXgVqzewj9vDrm5
4YepQSqf1B+tqajCsSV4fS6jPRk7LW0eGColZBUsz36CmPvueXfuk9PQBHo3TyzT2qhbJZAFvr2l
Lbk=
=dYUn
-----END PGP SIGNATURE-----

--------------IMXj1Q32CB9vzKIj9YB0Otxb--
