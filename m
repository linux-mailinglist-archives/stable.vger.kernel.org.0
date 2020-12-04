Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07BA2CE528
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 02:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgLDBeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 20:34:00 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:36604 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725933AbgLDBeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 20:34:00 -0500
X-UUID: 1a1184f3fae94b00b88eb04fe4e4e788-20201204
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=asU0hyd6B0tIuuw9zw9QTEWC2OgJ7pNYC02KEDgawhA=;
        b=Up9ZqSCqRfRLvnwFp3OcBXFNk6I0liB/UvaXCB5mJmwJ2X6ptrT9Ft0fhPg2rRN8xbcSiKGWDLrfsYPFaYYmf5Hr1KD0X7UKYOLojTKhUhEVCmWA+LEHPwsi3tRZu3IQZwhL8jjXtyhyv4MN1oCvskSPv/PvIk7+v6q0JvLiCeI=;
X-UUID: 1a1184f3fae94b00b88eb04fe4e4e788-20201204
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 975999441; Fri, 04 Dec 2020 09:33:12 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Dec 2020 09:33:10 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Dec 2020 09:33:11 +0800
Message-ID: <1607045590.22275.6.camel@mtkswgap22>
Subject: Re: [PATCH v2] proc: use untagged_addr() for pagemap_read addresses
From:   Miles Chen <miles.chen@mediatek.com>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
CC:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        "Will Deacon" <will.deacon@arm.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Song Bao Hua <song.bao.hua@hisilicon.com>,
        <stable@vger.kernel.org>
Date:   Fri, 4 Dec 2020 09:33:10 +0800
In-Reply-To: <d836c2d2-321f-3931-568b-430d73c60c2c@arm.com>
References: <20201127050738.14440-1-miles.chen@mediatek.com>
         <d836c2d2-321f-3931-568b-430d73c60c2c@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTEyLTAzIGF0IDExOjQ1ICswMDAwLCBWaW5jZW56byBGcmFzY2lubyB3cm90
ZToNCj4gSGkgTWlsZXMsDQo+IA0KPiBPbiAxMS8yNy8yMCA1OjA3IEFNLCBNaWxlcyBDaGVuIHdy
b3RlOg0KPiA+IFdoZW4gd2UgdHJ5IHRvIHZpc2l0IHRoZSBwYWdlbWFwIG9mIGEgdGFnZ2VkIHVz
ZXJzcGFjZSBwb2ludGVyLCB3ZSBmaW5kDQo+ID4gdGhhdCB0aGUgc3RhcnRfdmFkZHIgaXMgbm90
IGNvcnJlY3QgYmVjYXVzZSBvZiB0aGUgdGFnLg0KPiA+IFRvIGZpeCBpdCwgd2Ugc2hvdWxkIHVu
dGFnIHRoZSB1c2VzcGFjZSBwb2ludGVycyBpbiBwYWdlbWFwX3JlYWQoKS4NCj4gPiANCj4gDQo+
IE5pdDogcy91c2VzcGFjZS91c2Vyc3BhY2UvIChwbGVhc2Ugc2VhcmNoIGFuZCByZXBsYWNlIGFs
bCBvY2N1cnJlbmNlcyA6KSApDQo+IA0KPiA+IEkgdGVzdGVkIHdpdGggNS4xMC1yYzQgYW5kIHRo
ZSBpc3N1ZSByZW1haW5zLg0KPiA+IA0KPiA+IEV4cGxhaW5hdGlvbiBmcm9tIENhdGFsaW4gaW4g
WzFdOg0KPiA+DQo+IA0KPiBOaXQ6IHMvRXhwbGFpbmF0aW9uL0V4cGxhbmF0aW9uLyAocGxlYXNl
IHNlYXJjaCBhbmQgcmVwbGFjZSBhbGwgb2NjdXJyZW5jZXMgOikgKQ0KDQp0aGFua3MsIEkgd2ls
bCBmaXggdGhpcyBhbmQgcHVzaCB2Mw0KPiANCj4gPiAiDQo+ID4gQXJndWFibHksIHRoYXQncyBh
IHVzZXItc3BhY2UgYnVnIHNpbmNlIHRhZ2dlZCBmaWxlIG9mZnNldHMgd2VyZSBuZXZlcg0KPiA+
IHN1cHBvcnRlZC4gSW4gdGhpcyBjYXNlIGl0J3Mgbm90IGV2ZW4gYSB0YWcgYXQgYml0IDU2IGFz
IHBlciB0aGUgYXJtNjQNCj4gPiB0YWdnZWQgYWRkcmVzcyBBQkkgYnV0IHJhdGhlciBkb3duIHRv
IGJpdCA0Ny4gWW91IGNvdWxkIHNheSB0aGF0IHRoZQ0KPiA+IHByb2JsZW0gaXMgY2F1c2VkIGJ5
IHRoZSBDIGxpYnJhcnkgKG1hbGxvYygpKSBvciB3aG9ldmVyIGNyZWF0ZWQgdGhlDQo+ID4gdGFn
Z2VkIHZhZGRyIGFuZCBwYXNzZWQgaXQgdG8gdGhpcyBmdW5jdGlvbi4gSXQncyBub3QgYSBrZXJu
ZWwNCj4gPiByZWdyZXNzaW9uIGFzIHdlJ3ZlIG5ldmVyIHN1cHBvcnRlZCBpdC4NCj4gPiANCj4g
PiBOb3csIHBhZ2VtYXAgaXMgYSBzcGVjaWFsIGNhc2Ugd2hlcmUgdGhlIG9mZnNldCBpcyB1c3Vh
bGx5IG5vdCBnZW5lcmF0ZWQNCj4gPiBhcyBhIGNsYXNzaWMgZmlsZSBvZmZzZXQgYnV0IHJhdGhl
ciBkZXJpdmVkIGJ5IHNoaWZ0aW5nIGEgdXNlciB2aXJ0dWFsDQo+ID4gYWRkcmVzcy4gSSBndWVz
cyB3ZSBjYW4gbWFrZSBhIGNvbmNlc3Npb24gZm9yIHBhZ2VtYXAgKG9ubHkpIGFuZCBhbGxvdw0K
PiA+IHN1Y2ggb2Zmc2V0IHdpdGggdGhlIHRhZyBhdCBiaXQgKDU2IC0gUEFHRV9TSElGVCArIDMp
Lg0KPiA+ICINCj4gPiANCj4gPiBNeSB0ZXN0IGNvZGUgaXMgYmFlZCBvbiBbMl06DQo+IA0KPiBO
aXQ6IHMvYmFlZC9iYXNlZC8gKHBsZWFzZSBzZWFyY2ggYW5kIHJlcGxhY2UgYWxsIG9jY3VycmVu
Y2VzIDopICkNCg0KdGhhbmtzLCBJIHdpbGwgZml4IHRoaXMgYW5kIHB1c2ggdjMNCg0KDQoNCk1p
bGVzDQo+IA0KPiBbLi4uXQ0KPiANCj4gPiAtLS0NCj4gPiAgZnMvcHJvYy90YXNrX21tdS5jIHwg
OCArKysrKystLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9mcy9wcm9jL3Rhc2tfbW11LmMgYi9mcy9w
cm9jL3Rhc2tfbW11LmMNCj4gPiBpbmRleCAyMTdhYTI3MDVkNWQuLjkyYjI3NzM4OGYwNSAxMDA2
NDQNCj4gPiAtLS0gYS9mcy9wcm9jL3Rhc2tfbW11LmMNCj4gPiArKysgYi9mcy9wcm9jL3Rhc2tf
bW11LmMNCj4gPiBAQCAtMTU5OSwxMSArMTU5OSwxNSBAQCBzdGF0aWMgc3NpemVfdCBwYWdlbWFw
X3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIGNoYXIgX191c2VyICpidWYsDQo+ID4gIA0KPiA+ICAJ
c3JjID0gKnBwb3M7DQo+ID4gIAlzdnBmbiA9IHNyYyAvIFBNX0VOVFJZX0JZVEVTOw0KPiA+IC0J
c3RhcnRfdmFkZHIgPSBzdnBmbiA8PCBQQUdFX1NISUZUOw0KPiA+ICAJZW5kX3ZhZGRyID0gbW0t
PnRhc2tfc2l6ZTsNCj4gPiAgDQo+ID4gIAkvKiB3YXRjaCBvdXQgZm9yIHdyYXBhcm91bmQgKi8N
Cj4gPiAtCWlmIChzdnBmbiA+IG1tLT50YXNrX3NpemUgPj4gUEFHRV9TSElGVCkNCj4gPiArCXN0
YXJ0X3ZhZGRyID0gZW5kX3ZhZGRyOw0KPiA+ICsJaWYgKHN2cGZuIDwgKFVMT05HX01BWCA+PiBQ
QUdFX1NISUZUKSkNCj4gDQo+IEl0IHNlZW1zIHRoYXQgJ3N2cGZuJyBzaG91bGQgYmUgbGVzcy10
aGVuLWVxdWFsICg8PSkgJyhVTE9OR19NQVggPj4NCj4gUEFHRV9TSElGVCknLiBJcyB0aGVyZSBh
bnkgc3BlY2lmaWMgcmVhc29uIHdoeSB0aGlzIGlzIG5vdCB0aGUgY2FzZT8NCj4gDQo+ID4gKwkJ
c3RhcnRfdmFkZHIgPSB1bnRhZ2dlZF9hZGRyKHN2cGZuIDw8IFBBR0VfU0hJRlQpOw0KPiA+ICsN
Cj4gPiArCS8qIEVuc3VyZSB0aGUgYWRkcmVzcyBpcyBpbnNpZGUgdGhlIHRhc2sgKi8NCj4gPiAr
CWlmIChzdGFydF92YWRkciA+IG1tLT50YXNrX3NpemUpDQo+ID4gIAkJc3RhcnRfdmFkZHIgPSBl
bmRfdmFkZHI7DQo+ID4gIA0KPiA+ICAJLyoNCj4gPiANCj4gDQo+IE90aGVyd2lzZToNCj4gDQo+
IFJldmlld2VkLWJ5OiBWaW5jZW56byBGcmFzY2lubyA8dmluY2Vuem8uZnJhc2Npbm9AYXJtLmNv
bT4NCj4gDQoNCg==

