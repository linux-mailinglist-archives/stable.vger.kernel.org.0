Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79CE21E1EC
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 23:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGMVP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 17:15:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:10320 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgGMVP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 17:15:26 -0400
IronPort-SDR: EDqaiK0WtSOgTrEneRv8MAyBCNVRwcvUgb1YmATK7f1/U1WrnPtrk/jMtyWsxxP2eH45NC8DsR
 /LnRM19csIfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="150174338"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="150174338"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 14:15:26 -0700
IronPort-SDR: J5H0e8ohGOkWdoZ3dFsylYXCtBknDfifM3fnlDSIexWp9wKJo+XEoB0kZTnxqh9CprPSplPjtX
 bSaWrsS2B2zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="281530974"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga003.jf.intel.com with ESMTP; 13 Jul 2020 14:15:25 -0700
Received: from fmsmsx161.amr.corp.intel.com (10.18.125.9) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 13 Jul 2020 14:15:25 -0700
Received: from fmsmsx117.amr.corp.intel.com ([169.254.3.171]) by
 FMSMSX161.amr.corp.intel.com ([10.18.125.9]) with mapi id 14.03.0439.000;
 Mon, 13 Jul 2020 14:15:25 -0700
From:   "Souza, Jose" <jose.souza@intel.com>
To:     "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: Recalculate FBC w/a stride
 when needed
Thread-Topic: [Intel-gfx] [PATCH v2] drm/i915: Recalculate FBC w/a stride
 when needed
Thread-Index: AQHWV1nT297AOWowWEWpVKZyb2HnF6kGfJwA
Date:   Mon, 13 Jul 2020 21:15:24 +0000
Message-ID: <f9406f8743ed6746dc0dc8caa4936c03b7a47eef.camel@intel.com>
References: <20200710203408.23039-1-ville.syrjala@linux.intel.com>
         <20200711080336.13423-1-ville.syrjala@linux.intel.com>
In-Reply-To: <20200711080336.13423-1-ville.syrjala@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B40AC96B8B7D394DA9E14C9F85C00C5D@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU2F0LCAyMDIwLTA3LTExIGF0IDExOjAzICswMzAwLCBWaWxsZSBTeXJqYWxhIHdyb3RlOg0K
PiBGcm9tOiBWaWxsZSBTeXJqw6Rsw6QgPHZpbGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tPg0K
PiANCj4gQ3VycmVudGx5IHdlJ3JlIGZhaWxpbmcgdG8gcmVjYWxjdWxhdGUgdGhlIGdlbjkgRkJD
IHcvYSBzdHJpZGUNCj4gdW5sZXNzIHNvbWV0aGluZyBtb3JlIGRyYXN0aWMgdGhhbiBqdXN0IHRo
ZSBtb2RpZmllciBpdHNlbGYgaGFzDQo+IGNoYW5nZWQuIFRoaXMgb2Z0ZW4gbGVhdmVzIHVzIHdp
dGggRkJDIGVuYWJsZWQgd2l0aCB0aGUgbGluZWFyDQo+IGZiZGV2IGZyYW1lYnVmZmVyIHdpdGhv
dXQgdGhlIHcvYSBzdHJpZGUgZW5hYmxlZC4gVGhhdCB3aWxsIGNhdXNlDQo+IGFuIGltbWVkaWF0
ZSB1bmRlcnJ1biBhbmQgRkJDIHdpbGwgZ2V0IHByb21wdGx5IGRpc2FibGVkLg0KPiANCj4gRml4
IHRoZSBwcm9ibGVtIGJ5IGNoZWNraW5nIGlmIHRoZSB3L2Egc3RyaWRlIGlzIGFib3V0IHRvIGNo
YW5nZSwNCj4gYW5kIGdvIHRocm91Z2ggdGhlIGZ1bGwgZGFuY2UgaWYgc28uIFRoaXMgcGFydCBv
ZiB0aGUgRkJDIGNvZGUNCj4gaXMgc3RpbGwgcHJldHR5IG11Y2ggYSBkaXNhc3RlciBhbmQgd2ls
bCBuZWVkIGxvdHMgbW9yZSB3b3JrLg0KPiBCdXQgdGhpcyBzaG91bGQgYXQgbGVhc3QgZml4IHRo
ZSBpbW1lZGlhdGUgaXNzdWUuDQo+IA0KPiB2MjogRGVhY3RpdmF0ZSBGQkMgd2hlbiB0aGUgbW9k
aWZpZXIgY2hhbmdlcyBzaW5jZSB0aGF0IHdpbGwNCj4gICAgIGxpa2VseSByZXF1aXJlIHJlc2V0
dGluZyB0aGUgdy9hIENGQiBzdHJpZGUNCg0KUmV2aWV3ZWQtYnk6IEpvc8OpIFJvYmVydG8gZGUg
U291emEgPGpvc2Uuc291emFAaW50ZWwuY29tPg0KDQo+IA0KPiBDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBWaWxsZSBTeXJqw6Rsw6QgPHZpbGxlLnN5cmphbGFA
bGludXguaW50ZWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkv
aW50ZWxfZmJjLmMgfCAzMyArKysrKysrKysrKysrKysrKysrLS0tLS0NCj4gIGRyaXZlcnMvZ3B1
L2RybS9pOTE1L2k5MTVfZHJ2LmggICAgICAgICAgfCAgMSArDQo+ICAyIGZpbGVzIGNoYW5nZWQs
IDI3IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9mYmMuYyBiL2RyaXZlcnMvZ3B1L2RybS9p
OTE1L2Rpc3BsYXkvaW50ZWxfZmJjLmMNCj4gaW5kZXggZWYyZWIxNGY2MTU3Li44NTcyM2ZiYTYw
MDIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZmJj
LmMNCj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9mYmMuYw0KPiBA
QCAtNzQyLDYgKzc0MiwyNSBAQCBzdGF0aWMgYm9vbCBpbnRlbF9mYmNfY2ZiX3NpemVfY2hhbmdl
ZChzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqZGV2X3ByaXYpDQo+ICAJCWZiYy0+Y29tcHJlc3Nl
ZF9mYi5zaXplICogZmJjLT50aHJlc2hvbGQ7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyB1MTYgaW50
ZWxfZmJjX2dlbjlfd2FfY2ZiX3N0cmlkZShzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqZGV2X3By
aXYpDQo+ICt7DQo+ICsJc3RydWN0IGludGVsX2ZiYyAqZmJjID0gJmRldl9wcml2LT5mYmM7DQo+
ICsJc3RydWN0IGludGVsX2ZiY19zdGF0ZV9jYWNoZSAqY2FjaGUgPSAmZmJjLT5zdGF0ZV9jYWNo
ZTsNCj4gKw0KPiArCWlmICgoSVNfR0VOOV9CQyhkZXZfcHJpdikgfHwgSVNfQlJPWFRPTihkZXZf
cHJpdikpICYmDQo+ICsJICAgIGNhY2hlLT5mYi5tb2RpZmllciAhPSBJOTE1X0ZPUk1BVF9NT0Rf
WF9USUxFRCkNCj4gKwkJcmV0dXJuIERJVl9ST1VORF9VUChjYWNoZS0+cGxhbmUuc3JjX3csIDMy
ICogZmJjLT50aHJlc2hvbGQpICogODsNCj4gKwllbHNlDQo+ICsJCXJldHVybiAwOw0KPiArfQ0K
PiArDQo+ICtzdGF0aWMgYm9vbCBpbnRlbF9mYmNfZ2VuOV93YV9jZmJfc3RyaWRlX2NoYW5nZWQo
c3RydWN0IGRybV9pOTE1X3ByaXZhdGUgKmRldl9wcml2KQ0KPiArew0KPiArCXN0cnVjdCBpbnRl
bF9mYmMgKmZiYyA9ICZkZXZfcHJpdi0+ZmJjOw0KPiArDQo+ICsJcmV0dXJuIGZiYy0+cGFyYW1z
Lmdlbjlfd2FfY2ZiX3N0cmlkZSAhPSBpbnRlbF9mYmNfZ2VuOV93YV9jZmJfc3RyaWRlKGRldl9w
cml2KTsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGJvb2wgaW50ZWxfZmJjX2Nhbl9lbmFibGUoc3Ry
dWN0IGRybV9pOTE1X3ByaXZhdGUgKmRldl9wcml2KQ0KPiAgew0KPiAgCXN0cnVjdCBpbnRlbF9m
YmMgKmZiYyA9ICZkZXZfcHJpdi0+ZmJjOw0KPiBAQCAtOTAyLDYgKzkyMSw3IEBAIHN0YXRpYyB2
b2lkIGludGVsX2ZiY19nZXRfcmVnX3BhcmFtcyhzdHJ1Y3QgaW50ZWxfY3J0YyAqY3J0YywNCj4g
IAlwYXJhbXMtPmNydGMuaTl4eF9wbGFuZSA9IHRvX2ludGVsX3BsYW5lKGNydGMtPmJhc2UucHJp
bWFyeSktPmk5eHhfcGxhbmU7DQo+ICANCj4gIAlwYXJhbXMtPmZiLmZvcm1hdCA9IGNhY2hlLT5m
Yi5mb3JtYXQ7DQo+ICsJcGFyYW1zLT5mYi5tb2RpZmllciA9IGNhY2hlLT5mYi5tb2RpZmllcjsN
Cj4gIAlwYXJhbXMtPmZiLnN0cmlkZSA9IGNhY2hlLT5mYi5zdHJpZGU7DQo+ICANCj4gIAlwYXJh
bXMtPmNmYl9zaXplID0gaW50ZWxfZmJjX2NhbGN1bGF0ZV9jZmJfc2l6ZShkZXZfcHJpdiwgY2Fj
aGUpOw0KPiBAQCAtOTMxLDYgKzk1MSw5IEBAIHN0YXRpYyBib29sIGludGVsX2ZiY19jYW5fZmxp
cF9udWtlKGNvbnN0IHN0cnVjdCBpbnRlbF9jcnRjX3N0YXRlICpjcnRjX3N0YXRlKQ0KPiAgCWlm
IChwYXJhbXMtPmZiLmZvcm1hdCAhPSBjYWNoZS0+ZmIuZm9ybWF0KQ0KPiAgCQlyZXR1cm4gZmFs
c2U7DQo+ICANCj4gKwlpZiAocGFyYW1zLT5mYi5tb2RpZmllciAhPSBjYWNoZS0+ZmIubW9kaWZp
ZXIpDQo+ICsJCXJldHVybiBmYWxzZTsNCj4gKw0KPiAgCWlmIChwYXJhbXMtPmZiLnN0cmlkZSAh
PSBjYWNoZS0+ZmIuc3RyaWRlKQ0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+ICANCj4gQEAgLTEyMTgs
NyArMTI0MSw4IEBAIHZvaWQgaW50ZWxfZmJjX2VuYWJsZShzdHJ1Y3QgaW50ZWxfYXRvbWljX3N0
YXRlICpzdGF0ZSwNCj4gIA0KPiAgCWlmIChmYmMtPmNydGMpIHsNCj4gIAkJaWYgKGZiYy0+Y3J0
YyAhPSBjcnRjIHx8DQo+IC0JCSAgICAhaW50ZWxfZmJjX2NmYl9zaXplX2NoYW5nZWQoZGV2X3By
aXYpKQ0KPiArCQkgICAgKCFpbnRlbF9mYmNfY2ZiX3NpemVfY2hhbmdlZChkZXZfcHJpdikgJiYN
Cj4gKwkJICAgICAhaW50ZWxfZmJjX2dlbjlfd2FfY2ZiX3N0cmlkZV9jaGFuZ2VkKGRldl9wcml2
KSkpDQo+ICAJCQlnb3RvIG91dDsNCj4gIA0KPiAgCQlfX2ludGVsX2ZiY19kaXNhYmxlKGRldl9w
cml2KTsNCj4gQEAgLTEyNDAsMTIgKzEyNjQsNyBAQCB2b2lkIGludGVsX2ZiY19lbmFibGUoc3Ry
dWN0IGludGVsX2F0b21pY19zdGF0ZSAqc3RhdGUsDQo+ICAJCWdvdG8gb3V0Ow0KPiAgCX0NCj4g
IA0KPiAtCWlmICgoSVNfR0VOOV9CQyhkZXZfcHJpdikgfHwgSVNfQlJPWFRPTihkZXZfcHJpdikp
ICYmDQo+IC0JICAgIHBsYW5lX3N0YXRlLT5ody5mYi0+bW9kaWZpZXIgIT0gSTkxNV9GT1JNQVRf
TU9EX1hfVElMRUQpDQo+IC0JCWNhY2hlLT5nZW45X3dhX2NmYl9zdHJpZGUgPQ0KPiAtCQkJRElW
X1JPVU5EX1VQKGNhY2hlLT5wbGFuZS5zcmNfdywgMzIgKiBmYmMtPnRocmVzaG9sZCkgKiA4Ow0K
PiAtCWVsc2UNCj4gLQkJY2FjaGUtPmdlbjlfd2FfY2ZiX3N0cmlkZSA9IDA7DQo+ICsJY2FjaGUt
Pmdlbjlfd2FfY2ZiX3N0cmlkZSA9IGludGVsX2ZiY19nZW45X3dhX2NmYl9zdHJpZGUoZGV2X3By
aXYpOw0KPiAgDQo+ICAJZHJtX2RiZ19rbXMoJmRldl9wcml2LT5kcm0sICJFbmFibGluZyBGQkMg
b24gcGlwZSAlY1xuIiwNCj4gIAkJICAgIHBpcGVfbmFtZShjcnRjLT5waXBlKSk7DQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2Rydi5oIGIvZHJpdmVycy9ncHUvZHJt
L2k5MTUvaTkxNV9kcnYuaA0KPiBpbmRleCA4Nzk3M2RlZGY4ZTcuLjE0YjA5NWFmYWI0MiAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9kcnYuaA0KPiArKysgYi9kcml2
ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2Rydi5oDQo+IEBAIC00NDIsNiArNDQyLDcgQEAgc3RydWN0
IGludGVsX2ZiYyB7DQo+ICAJCXN0cnVjdCB7DQo+ICAJCQljb25zdCBzdHJ1Y3QgZHJtX2Zvcm1h
dF9pbmZvICpmb3JtYXQ7DQo+ICAJCQl1bnNpZ25lZCBpbnQgc3RyaWRlOw0KPiArCQkJdTY0IG1v
ZGlmaWVyOw0KPiAgCQl9IGZiOw0KPiAgDQo+ICAJCWludCBjZmJfc2l6ZTsNCg==
