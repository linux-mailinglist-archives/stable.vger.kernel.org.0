Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64B5228A4D
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 23:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgGUVC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 17:02:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:11296 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbgGUVC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 17:02:57 -0400
IronPort-SDR: Z6ePjOkb6+5YKRiQgiY5Fn5HrV6Oe4ioQyNPK5BLUuhp/Wea8KyQIYzZcm8LTjpO02UJC2gLec
 ufuCCKwYiJ5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="147726646"
X-IronPort-AV: E=Sophos;i="5.75,380,1589266800"; 
   d="scan'208";a="147726646"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 14:02:45 -0700
IronPort-SDR: ioUjh/FqACUT3zUUZ8V4y90ZF7TyZlBKRwRmVmpCqa62H3SBYMQdfjL/MXY6C1baDjYOdIGFin
 c0GdBuus/heA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,380,1589266800"; 
   d="scan'208";a="318459277"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga008.jf.intel.com with ESMTP; 21 Jul 2020 14:02:44 -0700
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Jul 2020 14:02:44 -0700
Received: from fmsmsx108.amr.corp.intel.com ([169.254.9.75]) by
 fmsmsx123.amr.corp.intel.com ([169.254.7.157]) with mapi id 14.03.0439.000;
 Tue, 21 Jul 2020 14:02:44 -0700
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] io-mapping: Indicate mapping failure
Thread-Topic: [PATCH v2] io-mapping: Indicate mapping failure
Thread-Index: AQHWX4MfwzDEcHdlu02n3oFh4ZbooKkS+TgA//+K8vA=
Date:   Tue, 21 Jul 2020 21:02:44 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E866301245E046C@FMSMSX108.amr.corp.intel.com>
References: <20200721171936.81563-1-michael.j.ruhl@intel.com>
 <20200721135648.9603d924377825a7e6c0023b@linux-foundation.org>
In-Reply-To: <20200721135648.9603d924377825a7e6c0023b@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogQW5kcmV3IE1vcnRvbiA8YWtwbUBs
aW51eC1mb3VuZGF0aW9uLm9yZz4NCj5TZW50OiBUdWVzZGF5LCBKdWx5IDIxLCAyMDIwIDQ6NTcg
UE0NCj5UbzogUnVobCwgTWljaGFlbCBKIDxtaWNoYWVsLmoucnVobEBpbnRlbC5jb20+DQo+Q2M6
IGRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmc7IE1pa2UgUmFwb3BvcnQgPHJwcHRAbGlu
dXguaWJtLmNvbT47DQo+QW5keSBTaGV2Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5p
bnRlbC5jb20+OyBDaHJpcyBXaWxzb24NCj48Y2hyaXNAY2hyaXMtd2lsc29uLmNvLnVrPjsgc3Rh
YmxlQHZnZXIua2VybmVsLm9yZw0KPlN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIGlvLW1hcHBpbmc6
IEluZGljYXRlIG1hcHBpbmcgZmFpbHVyZQ0KPg0KPk9uIFR1ZSwgMjEgSnVsIDIwMjAgMTM6MTk6
MzYgLTA0MDAgIk1pY2hhZWwgSi4gUnVobCINCj48bWljaGFlbC5qLnJ1aGxAaW50ZWwuY29tPiB3
cm90ZToNCj4NCj4+IFRoZSAhQVRPTUlDX0lPTUFQIHZlcnNpb24gb2YgaW9fbWFwaW5nX2luaXRf
d2Mgd2lsbCBhbHdheXMgcmV0dXJuDQo+PiBzdWNjZXNzLCBldmVuIHdoZW4gdGhlIGlvcmVtYXAg
ZmFpbHMuDQo+Pg0KPj4gU2luY2UgdGhlIEFUT01JQ19JT01BUCB2ZXJzaW9uIHJldHVybnMgTlVM
TCB3aGVuIHRoZSBpbml0IGZhaWxzLCBhbmQNCj4+IGNhbGxlcnMgY2hlY2sgZm9yIGEgTlVMTCBy
ZXR1cm4gb24gZXJyb3IgdGhpcyBpcyB1bmV4cGVjdGVkLg0KPj4NCj4+IER1cmluZyBhIGRldmlj
ZSBwcm9iZSwgd2hlcmUgdGhlIGlvcmVtYXAgZmFpbGVkLCBhIGNyYXNoIGNhbiBsb29rDQo+PiBs
aWtlIHRoaXM6DQo+Pg0KPj4gQlVHOiB1bmFibGUgdG8gaGFuZGxlIHBhZ2UgZmF1bHQgZm9yIGFk
ZHJlc3M6IDAwMDAwMDAwMDAyMTAwMDANCj4+ICAjUEY6IHN1cGVydmlzb3Igd3JpdGUgYWNjZXNz
IGluIGtlcm5lbCBtb2RlDQo+PiAgI1BGOiBlcnJvcl9jb2RlKDB4MDAwMikgLSBub3QtcHJlc2Vu
dCBwYWdlDQo+PiAgT29wczogMDAwMiBbIzFdIFBSRUVNUFQgU01QDQo+PiAgQ1BVOiAwIFBJRDog
MTc3IENvbW06DQo+PiAgUklQOiAwMDEwOmZpbGxfcGFnZV9kbWEgW2k5MTVdDQo+PiAgIGdlbjhf
cHBndHRfY3JlYXRlIFtpOTE1XQ0KPj4gICBpOTE1X3BwZ3R0X2NyZWF0ZSBbaTkxNV0NCj4+ICAg
aW50ZWxfZ3RfaW5pdCBbaTkxNV0NCj4+ICAgaTkxNV9nZW1faW5pdCBbaTkxNV0NCj4+ICAgaTkx
NV9kcml2ZXJfcHJvYmUgW2k5MTVdDQo+PiAgIHBjaV9kZXZpY2VfcHJvYmUNCj4+ICAgcmVhbGx5
X3Byb2JlDQo+PiAgIGRyaXZlcl9wcm9iZV9kZXZpY2UNCj4+DQo+PiBUaGUgcmVtYXAgZmFpbHVy
ZSBvY2N1cnJlZCBtdWNoIGVhcmxpZXIgaW4gdGhlIHByb2JlLiAgSWYgaXQgaGFkDQo+PiBiZWVu
IHByb3BhZ2F0ZWQsIHRoZSBkcml2ZXIgd291bGQgaGF2ZSBleGl0ZWQgd2l0aCBhbiBlcnJvci4N
Cj4+DQo+PiBSZXR1cm4gTlVMTCBvbiBpb3JlbWFwIGZhaWx1cmUuDQo+Pg0KPj4gLi4uDQo+Pg0K
Pj4gLS0tIGEvaW5jbHVkZS9saW51eC9pby1tYXBwaW5nLmgNCj4+ICsrKyBiL2luY2x1ZGUvbGlu
dXgvaW8tbWFwcGluZy5oDQo+PiBAQCAtMTE4LDcgKzExOCw3IEBAIGlvX21hcHBpbmdfaW5pdF93
YyhzdHJ1Y3QgaW9fbWFwcGluZyAqaW9tYXAsDQo+PiAgCWlvbWFwLT5wcm90ID0gcGdwcm90X25v
bmNhY2hlZChQQUdFX0tFUk5FTCk7DQo+PiAgI2VuZGlmDQo+Pg0KPj4gLQlyZXR1cm4gaW9tYXA7
DQo+PiArCXJldHVybiBpb21hcC0+aW9tZW0gPyBpb21hcCA6IE5VTEw7DQo+PiAgfQ0KPj4NCj4+
ICBzdGF0aWMgaW5saW5lIHZvaWQNCj4NCj5MR1RNLiAgSG93ZXZlciBJIGRvIHRoaW5rIGl0IHdv
dWxkIGJlIHN0eWxpc3RpY2FsbHkgYmV0dGVyL3R5cGljYWwgdG8NCj5kZXRlY3QgYW5kIGhhbmRs
ZSB0aGUgZXJyb3IgZWFybHksIHJhdGhlciB0aGFuIHRvIGJsdW5kZXIgb24sDQo+cG9pbnRsZXNz
bHkgaW5pdGlhbGl6aW5nIHRoaW5ncz8NCg0KWWVhaCwgSSBwb25kZXJlZCB0aGF0LCBhbmQgdGhl
biBkaWRuJ3QgZG8gaXQuLi4NCg0KPi0tLSBhL2luY2x1ZGUvbGludXgvaW8tbWFwcGluZy5ofmlv
LW1hcHBpbmctaW5kaWNhdGUtbWFwcGluZy1mYWlsdXJlLWZpeA0KPisrKyBhL2luY2x1ZGUvbGlu
dXgvaW8tbWFwcGluZy5oDQo+QEAgLTEwNyw5ICsxMDcsMTIgQEAgaW9fbWFwcGluZ19pbml0X3dj
KHN0cnVjdCBpb19tYXBwaW5nICppbw0KPiAJCSAgIHJlc291cmNlX3NpemVfdCBiYXNlLA0KPiAJ
CSAgIHVuc2lnbmVkIGxvbmcgc2l6ZSkNCj4gew0KPisJaW9tYXAtPmlvbWVtID0gaW9yZW1hcF93
YyhiYXNlLCBzaXplKTsNCj4rCWlmICghaW9tYXAtPmlvbWVtKQ0KPisJCXJldHVybiBOVUxMOw0K
PisNCg0KVGhpcyBkb2VzIG1ha2UgbW9yZSBzZW5zZS4NCg0KSSBhbSBjb25mdXNlZCBieSB0aGUg
dHdvIGZvbGxvdyB1cCBlbWFpbHMgSSBqdXN0IGdvdC4NCg0KU2hhbGwgSSByZXN1Ym1pdCwgb3Ig
aXMgdGhpcyBwYXRoIChpZiAhaW9tYXAtPmlvbWVtKSByZXR1cm4gTlVMTCkNCm5vdyBpbiB0aGUg
dHJlZS4g8J+Yig0KDQpUaGFua3MsDQoNCk1pa2UNCg0KPiAJaW9tYXAtPmJhc2UgPSBiYXNlOw0K
PiAJaW9tYXAtPnNpemUgPSBzaXplOw0KPi0JaW9tYXAtPmlvbWVtID0gaW9yZW1hcF93YyhiYXNl
LCBzaXplKTsNCj4gI2lmIGRlZmluZWQocGdwcm90X25vbmNhY2hlZF93YykgLyogYXJjaHMgY2Fu
J3QgYWdyZWUgb24gYSBuYW1lIC4uLiAqLw0KPiAJaW9tYXAtPnByb3QgPSBwZ3Byb3Rfbm9uY2Fj
aGVkX3djKFBBR0VfS0VSTkVMKTsNCj4gI2VsaWYgZGVmaW5lZChwZ3Byb3Rfd3JpdGVjb21iaW5l
KQ0KPkBAIC0xMTgsNyArMTIxLDcgQEAgaW9fbWFwcGluZ19pbml0X3djKHN0cnVjdCBpb19tYXBw
aW5nICppbw0KPiAJaW9tYXAtPnByb3QgPSBwZ3Byb3Rfbm9uY2FjaGVkKFBBR0VfS0VSTkVMKTsN
Cj4gI2VuZGlmDQo+DQo+LQlyZXR1cm4gaW9tYXAtPmlvbWVtID8gaW9tYXAgOiBOVUxMOw0KPisJ
cmV0dXJuIGlvbWFwOw0KPiB9DQo+DQo+IHN0YXRpYyBpbmxpbmUgdm9pZA0KPl8NCg0K
