Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8AF23213A
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 17:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgG2PJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 11:09:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:41937 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgG2PJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 11:09:48 -0400
IronPort-SDR: Q9p97yCZ5Uv5pOYRuf+yg1+t3rqo1gMbk1ABcLM2rcY2kJtlNabxewOT/RhMyLxNPvPMfFXwFc
 Y1EnIsbDiynw==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="152666805"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="152666805"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 08:09:47 -0700
IronPort-SDR: GagSq0xY1JUqlQZztKdqk7dFOdSz71mNIA7WOluPT9cnV24kOa3bJJ9GUtoItbO6dfhKchIAeV
 fVZnNhtQ+euQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313057299"
Received: from irsmsx606.ger.corp.intel.com ([163.33.146.139])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 08:09:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 IRSMSX606.ger.corp.intel.com (163.33.146.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 29 Jul 2020 16:09:44 +0100
Received: from fmsmsx611.amr.corp.intel.com ([10.18.126.91]) by
 fmsmsx611.amr.corp.intel.com ([10.18.126.91]) with mapi id 15.01.1713.004;
 Wed, 29 Jul 2020 08:09:42 -0700
From:   "Tang, CQ" <cq.tang@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
CC:     intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Vetter, Daniel" <daniel.vetter@intel.com>
Subject: RE: [PATCH 1/3] drm: Restore driver.preclose() for all to use
Thread-Topic: [PATCH 1/3] drm: Restore driver.preclose() for all to use
Thread-Index: AQHWYRW5n+A4jji0YE+tc8HbwEq9WakcTJSAgAFel4CAAQcEIA==
Date:   Wed, 29 Jul 2020 15:09:42 +0000
Message-ID: <0118a278832d4dde8d8d71e3db635869@intel.com>
References: <20200723172119.17649-1-chris@chris-wilson.co.uk>
 <CAKMK7uFt5ViekqBPqdBbJWN4FhfxvF57K58VW8hAZGZwjRDz0w@mail.gmail.com>
 <159595365380.28639.1774414370144556112@build.alporthouse.com>
In-Reply-To: <159595365380.28639.1774414370144556112@build.alporthouse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2hyaXMgV2lsc29uIDxj
aHJpc0BjaHJpcy13aWxzb24uY28udWs+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMjgsIDIwMjAg
OToyOCBBTQ0KPiBUbzogRGFuaWVsIFZldHRlciA8ZGFuaWVsQGZmd2xsLmNoPjsgRGF2ZSBBaXJs
aWUgPGFpcmxpZWRAcmVkaGF0LmNvbT4NCj4gQ2M6IGludGVsLWdmeCA8aW50ZWwtZ2Z4QGxpc3Rz
LmZyZWVkZXNrdG9wLm9yZz47IHN0YWJsZQ0KPiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz47IEd1
c3Rhdm8gUGFkb3Zhbg0KPiA8Z3VzdGF2by5wYWRvdmFuQGNvbGxhYm9yYS5jb20+OyBUYW5nLCBD
USA8Y3EudGFuZ0BpbnRlbC5jb20+OyBkcmktDQo+IGRldmVsIDxkcmktZGV2ZWxAbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnPjsgVmV0dGVyLCBEYW5pZWwNCj4gPGRhbmllbC52ZXR0ZXJAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvM10gZHJtOiBSZXN0b3JlIGRyaXZlci5wcmVjbG9z
ZSgpIGZvciBhbGwgdG8gdXNlDQo+IA0KPiBRdW90aW5nIERhbmllbCBWZXR0ZXIgKDIwMjAtMDct
MjcgMjA6MzI6NDUpDQo+ID4gT24gVGh1LCBKdWwgMjMsIDIwMjAgYXQgNzoyMSBQTSBDaHJpcyBX
aWxzb24gPGNocmlzQGNocmlzLXdpbHNvbi5jby51az4NCj4gd3JvdGU6DQo+ID4gPg0KPiA+ID4g
QW4gdW5mb3J0dW5hdGUgc2VxdWVuY2Ugb2YgZXZlbnRzLCBidXQgaXQgdHVybnMgb3V0IHRoZXJl
IGlzIGEgdmFsaWQNCj4gPiA+IHVzZWNhc2UgZm9yIGJlaW5nIGFibGUgdG8gZnJlZS9kZWNvdXBs
ZSB0aGUgZHJpdmVyIG9iamVjdHMgYmVmb3JlDQo+ID4gPiB0aGV5IGFyZSBmcmVlZCBieSB0aGUg
RFJNIGNvcmUuIEluIHBhcnRpY3VsYXIsIGlmIHdlIGhhdmUgYSBwb2ludGVyDQo+ID4gPiBpbnRv
IGEgZHJtIGNvcmUgb2JqZWN0IGZyb20gaW5zaWRlIGEgZHJpdmVyIG9iamVjdCwgdGhhdCBwb2lu
dGVyDQo+ID4gPiBuZWVkcyB0byBiZSBuZXJmZWQgKmJlZm9yZSogaXQgaXMgZnJlZWQgc28gdGhh
dCBjb25jdXJyZW50IGFjY2Vzcw0KPiA+ID4gKGUuZy4gZGVidWdmcykgZG9lcyBub3QgZm9sbG93
aW5nIHRoZSBkYW5nbGluZyBwb2ludGVyLg0KPiA+ID4NCj4gPiA+IFRoZSBsZWdhY3kgbWFya2Vy
IHdhcyBhZGRpbmcgaW4gdGhlIGNvZGUgbW92ZW1lbnQgZnJvbSBkcnBfZm9wcy5jIHRvDQo+ID4g
PiBkcm1fZmlsZS5jDQo+ID4NCj4gPiBJIG1pZ2h0IGZ1bWJsZSBhIGxvdCwgYnV0IG5vdCB0aGlz
IG9uZToNCj4gPg0KPiA+IGNvbW1pdCA0NWMzZDIxM2E0MDBjOTUyYWI3MTE5ZjM5NGM1MjkzYmI2
ODc3ZTZiDQo+ID4gQXV0aG9yOiBEYW5pZWwgVmV0dGVyIDxkYW5pZWwudmV0dGVyQGZmd2xsLmNo
Pg0KPiA+IERhdGU6ICAgTW9uIE1heSA4IDEwOjI2OjMzIDIwMTcgKzAyMDANCj4gPg0KPiA+ICAg
ICBkcm06IE5lcmYgdGhlIHByZWNsb3NlIGNhbGxiYWNrIGZvciBtb2Rlcm4gZHJpdmVycw0KPiAN
Cj4gR2FoLCB3aGVuIEkgZ29pbmcgdGhyb3VnaCB0aGUgaGlzdG9yeSBpdCBsb29rZWQgbGlrZSBp
dCBhcHBlYXJlZCBvdXQgb2YNCj4gbm93aGVyZS4NCj4gDQo+ID4gQWxzbyBsb29raW5nIGF0IHRo
ZSBkZWJ1Z2ZzIGhvb2sgdGhhdCBoYXMgc29tZSByYXRoZXIgYWR2ZW50dXJvdXMNCj4gPiBzdHVm
ZiBnb2luZyBvbiBJIHRoaW5rLCBmZWVscyBhIGJpdCBsaWtlIGEga2l0Y2hlbnNpbmsgd2l0aCBi
YXR0ZXJpZXMNCj4gPiBpbmNsdWRlZC4gSWYgdGhhdCdzIHJlYWxseSBhbGwgbmVlZGVkIEknZCBz
YXkgaXRlcmF0ZSB0aGUgY29udGV4dHMgYnkNCj4gPiBmaXJzdCBnb2luZyBvdmVyIGZpbGVzLCB0
aGVuIHRoZSBjdHggKHdoaWNoIGFyZW50IHNoYXJlZCBhbnl3YXkpIGFuZA0KPiA+IHRoZSBwcm9i
bGVtIHNob3VsZCBhbHNvIGJlIGdvbmUuDQo+IA0KPiBPciB3ZSBjb3VsZCBjdXQgb3V0IHRoZSBt
aWRkbGVsYXllciBhbmQgcHV0IHRoZSByZWxlYXNlIHVuZGVyIHRoZSBkcml2ZXINCj4gY29udHJv
bCB3aXRoIGEgY2FsbCB0byB0aGUgZHJtX3JlbGVhc2UoKSB3aGVuIHRoZSBkcml2ZXIgaXMgcmVh
ZHkuDQoNCkNoaXJpcywgY2FuIGV4cGxhaW4gdGhpcyBpZGVhLCBvciBwb3N0IGEgcGF0Y2ggPw0K
DQotLUNRDQoNCj4gLUNocmlzDQo=
