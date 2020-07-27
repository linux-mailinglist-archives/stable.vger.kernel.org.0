Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F4B22F9DE
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 22:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgG0UL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 16:11:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:46539 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgG0UL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 16:11:29 -0400
IronPort-SDR: hOQZZZYKLZU3rlV9o3fUoxksTfeOjto5IHQ+Qvzi7ePWn/sS3289eHZ7QnyqSfvz6VD8p1wIil
 S/mSCoF29Jqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="148973617"
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="148973617"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 13:11:27 -0700
IronPort-SDR: ua42VpdUMglpm/GiBvXcDBTeK6P6PDcZ3FAgbnS/0AnZyyMRMRwTKW23i2hE30rCO8IZU0F82c
 IrEYNnnC2wVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="490088627"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga005.fm.intel.com with ESMTP; 27 Jul 2020 13:11:27 -0700
Received: from orsmsx163.amr.corp.intel.com ([169.254.9.67]) by
 ORSMSX108.amr.corp.intel.com ([169.254.2.137]) with mapi id 14.03.0439.000;
 Mon, 27 Jul 2020 13:11:27 -0700
From:   "Tang, CQ" <cq.tang@intel.com>
To:     Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
CC:     intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Vetter, Daniel" <daniel.vetter@intel.com>
Subject: RE: [PATCH 1/3] drm: Restore driver.preclose() for all to use
Thread-Topic: [PATCH 1/3] drm: Restore driver.preclose() for all to use
Thread-Index: AQHWYRW5n+A4jji0YE+tc8HbwEq9WakcTJSA//+T8JA=
Date:   Mon, 27 Jul 2020 20:11:27 +0000
Message-ID: <1D440B9B88E22A4ABEF89F9F1F81BC2901183CE79A@ORSMSX163.amr.corp.intel.com>
References: <20200723172119.17649-1-chris@chris-wilson.co.uk>
 <CAKMK7uFt5ViekqBPqdBbJWN4FhfxvF57K58VW8hAZGZwjRDz0w@mail.gmail.com>
In-Reply-To: <CAKMK7uFt5ViekqBPqdBbJWN4FhfxvF57K58VW8hAZGZwjRDz0w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuaWVsIFZldHRlciA8
ZGFuaWVsQGZmd2xsLmNoPg0KPiBTZW50OiBNb25kYXksIEp1bHkgMjcsIDIwMjAgMTI6MzMgUE0N
Cj4gVG86IENocmlzIFdpbHNvbiA8Y2hyaXNAY2hyaXMtd2lsc29uLmNvLnVrPjsgRGF2ZSBBaXJs
aWUgPGFpcmxpZWRAcmVkaGF0LmNvbT4NCj4gQ2M6IGludGVsLWdmeCA8aW50ZWwtZ2Z4QGxpc3Rz
LmZyZWVkZXNrdG9wLm9yZz47IHN0YWJsZQ0KPiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz47IEd1
c3Rhdm8gUGFkb3Zhbg0KPiA8Z3VzdGF2by5wYWRvdmFuQGNvbGxhYm9yYS5jb20+OyBUYW5nLCBD
USA8Y3EudGFuZ0BpbnRlbC5jb20+OyBkcmktDQo+IGRldmVsIDxkcmktZGV2ZWxAbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnPjsgVmV0dGVyLCBEYW5pZWwNCj4gPGRhbmllbC52ZXR0ZXJAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvM10gZHJtOiBSZXN0b3JlIGRyaXZlci5wcmVjbG9z
ZSgpIGZvciBhbGwgdG8gdXNlDQo+IA0KPiBPbiBUaHUsIEp1bCAyMywgMjAyMCBhdCA3OjIxIFBN
IENocmlzIFdpbHNvbiA8Y2hyaXNAY2hyaXMtd2lsc29uLmNvLnVrPg0KPiB3cm90ZToNCj4gPg0K
PiA+IEFuIHVuZm9ydHVuYXRlIHNlcXVlbmNlIG9mIGV2ZW50cywgYnV0IGl0IHR1cm5zIG91dCB0
aGVyZSBpcyBhIHZhbGlkDQo+ID4gdXNlY2FzZSBmb3IgYmVpbmcgYWJsZSB0byBmcmVlL2RlY291
cGxlIHRoZSBkcml2ZXIgb2JqZWN0cyBiZWZvcmUgdGhleQ0KPiA+IGFyZSBmcmVlZCBieSB0aGUg
RFJNIGNvcmUuIEluIHBhcnRpY3VsYXIsIGlmIHdlIGhhdmUgYSBwb2ludGVyIGludG8gYQ0KPiA+
IGRybSBjb3JlIG9iamVjdCBmcm9tIGluc2lkZSBhIGRyaXZlciBvYmplY3QsIHRoYXQgcG9pbnRl
ciBuZWVkcyB0byBiZQ0KPiA+IG5lcmZlZCAqYmVmb3JlKiBpdCBpcyBmcmVlZCBzbyB0aGF0IGNv
bmN1cnJlbnQgYWNjZXNzIChlLmcuIGRlYnVnZnMpDQo+ID4gZG9lcyBub3QgZm9sbG93aW5nIHRo
ZSBkYW5nbGluZyBwb2ludGVyLg0KPiA+DQo+ID4gVGhlIGxlZ2FjeSBtYXJrZXIgd2FzIGFkZGlu
ZyBpbiB0aGUgY29kZSBtb3ZlbWVudCBmcm9tIGRycF9mb3BzLmMgdG8NCj4gPiBkcm1fZmlsZS5j
DQo+IA0KPiBJIG1pZ2h0IGZ1bWJsZSBhIGxvdCwgYnV0IG5vdCB0aGlzIG9uZToNCj4gDQo+IGNv
bW1pdCA0NWMzZDIxM2E0MDBjOTUyYWI3MTE5ZjM5NGM1MjkzYmI2ODc3ZTZiDQo+IEF1dGhvcjog
RGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4NCj4gRGF0ZTogICBNb24gTWF5
IDggMTA6MjY6MzMgMjAxNyArMDIwMA0KPiANCj4gICAgIGRybTogTmVyZiB0aGUgcHJlY2xvc2Ug
Y2FsbGJhY2sgZm9yIG1vZGVybiBkcml2ZXJzDQo+IA0KPiBBbHNvIGxvb2tpbmcgYXQgdGhlIGRl
YnVnZnMgaG9vayB0aGF0IGhhcyBzb21lIHJhdGhlciBhZHZlbnR1cm91cyBzdHVmZg0KPiBnb2lu
ZyBvbiBJIHRoaW5rLCBmZWVscyBhIGJpdCBsaWtlIGEga2l0Y2hlbnNpbmsgd2l0aCBiYXR0ZXJp
ZXMgaW5jbHVkZWQuIElmIHRoYXQncw0KPiByZWFsbHkgYWxsIG5lZWRlZCBJJ2Qgc2F5IGl0ZXJh
dGUgdGhlIGNvbnRleHRzIGJ5IGZpcnN0IGdvaW5nIG92ZXIgZmlsZXMsIHRoZW4gdGhlDQo+IGN0
eCAod2hpY2ggYXJlbnQgc2hhcmVkIGFueXdheSkgYW5kIHRoZSBwcm9ibGVtIHNob3VsZCBhbHNv
IGJlIGdvbmUuDQoNCkRlYnVnZnMgY29kZSBjYW4ganVtcCBpbiBhZnRlciBkcm1fZ2VtX3JlbGVh
c2UoKSAod2hlcmUgZmlsZS0+b2JqZWN0X2lkciBpcyBkZXN0cm95ZWQpLCBidXQgYmVmb3JlIHBv
c3RjbG9zZSgpLiBBdCB0aGlzIHdpbmRvdywgZXZlcnl0aGluZyBpcyBmaW5lIGZvciBkZWJ1Z2Zz
IGNvbnRleHQgYWNjZXNzaW5nIGV4Y2VwdCB0aGUgZmlsZS0+b2JqZWN0X2lkci4NCg0KLS1DUQ0K
DQo+IC1EYW5pZWwNCj4gDQo+ID4gUmVmZXJlbmNlczogOWFjZGFjNjhiY2RjICgiZHJtOiByZW5h
bWUgZHJtX2ZvcHMuYyB0byBkcm1fZmlsZS5jIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBDaHJpcyBX
aWxzb24gPGNocmlzQGNocmlzLXdpbHNvbi5jby51az4NCj4gPiBDYzogRGFuaWVsIFZldHRlciA8
ZGFuaWVsLnZldHRlckBpbnRlbC5jb20+DQo+ID4gQ2M6IEd1c3Rhdm8gUGFkb3ZhbiA8Z3VzdGF2
by5wYWRvdmFuQGNvbGxhYm9yYS5jb20+DQo+ID4gQ2M6IENRIFRhbmcgPGNxLnRhbmdAaW50ZWwu
Y29tPg0KPiA+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NC4xMisNCj4gPiAtLS0N
Cj4gPiAgZHJpdmVycy9ncHUvZHJtL2RybV9maWxlLmMgfCAzICstLQ0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9ncHUvZHJtL2RybV9maWxlLmMgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2ZpbGUu
Yw0KPiA+IGluZGV4IDBhYzQ1NjZhZTNmNC4uN2I0MjU4ZDZmN2NjIDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvZ3B1L2RybS9kcm1fZmlsZS5jDQo+ID4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2Ry
bV9maWxlLmMNCj4gPiBAQCAtMjU4LDggKzI1OCw3IEBAIHZvaWQgZHJtX2ZpbGVfZnJlZShzdHJ1
Y3QgZHJtX2ZpbGUgKmZpbGUpDQo+ID4gICAgICAgICAgICAgICAgICAgKGxvbmcpb2xkX2VuY29k
ZV9kZXYoZmlsZS0+bWlub3ItPmtkZXYtPmRldnQpLA0KPiA+ICAgICAgICAgICAgICAgICAgIGF0
b21pY19yZWFkKCZkZXYtPm9wZW5fY291bnQpKTsNCj4gPg0KPiA+IC0gICAgICAgaWYgKGRybV9j
b3JlX2NoZWNrX2ZlYXR1cmUoZGV2LCBEUklWRVJfTEVHQUNZKSAmJg0KPiA+IC0gICAgICAgICAg
IGRldi0+ZHJpdmVyLT5wcmVjbG9zZSkNCj4gPiArICAgICAgIGlmIChkZXYtPmRyaXZlci0+cHJl
Y2xvc2UpDQo+ID4gICAgICAgICAgICAgICAgIGRldi0+ZHJpdmVyLT5wcmVjbG9zZShkZXYsIGZp
bGUpOw0KPiA+DQo+ID4gICAgICAgICBpZiAoZHJtX2NvcmVfY2hlY2tfZmVhdHVyZShkZXYsIERS
SVZFUl9MRUdBQ1kpKQ0KPiA+IC0tDQo+ID4gMi4yMC4xDQo+ID4NCj4gPiBfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiA+IGRyaS1kZXZlbCBtYWlsaW5n
IGxpc3QNCj4gPiBkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+ID4gaHR0cHM6Ly9s
aXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwNCj4gDQo+IA0K
PiANCj4gLS0NCj4gRGFuaWVsIFZldHRlcg0KPiBTb2Z0d2FyZSBFbmdpbmVlciwgSW50ZWwgQ29y
cG9yYXRpb24NCj4gaHR0cDovL2Jsb2cuZmZ3bGwuY2gNCg==
