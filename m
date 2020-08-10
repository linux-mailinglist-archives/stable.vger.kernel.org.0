Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEABB2407EF
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgHJO4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:56:39 -0400
Received: from mga18.intel.com ([134.134.136.126]:29232 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHJO4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 10:56:38 -0400
IronPort-SDR: FfAQjVB1sFHOhzo/4Q+Mxfu0bB1brSBNa4iKM75WWw8sBEFTH7ZM5y8uASr4EHj4TuOeFtMvnu
 ldY/0b1oTZkw==
X-IronPort-AV: E=McAfee;i="6000,8403,9708"; a="141152608"
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="141152608"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 07:56:37 -0700
IronPort-SDR: ziv7wtaF9/bFd7Is7k/tA6fSPmEyGD9LJ3UxHXtex/kPa/J+261ZM2PEkC8mSqsRD5kLIcyafq
 ubljnV7a0EnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="276028593"
Received: from unknown (HELO fmsmsx604.amr.corp.intel.com) ([10.18.84.214])
  by fmsmga007.fm.intel.com with ESMTP; 10 Aug 2020 07:56:37 -0700
Received: from bgsmsx604.gar.corp.intel.com (10.67.234.6) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Aug 2020 07:56:36 -0700
Received: from bgsmsx604.gar.corp.intel.com (10.67.234.6) by
 BGSMSX604.gar.corp.intel.com (10.67.234.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Aug 2020 20:26:34 +0530
Received: from bgsmsx604.gar.corp.intel.com ([10.67.234.6]) by
 BGSMSX604.gar.corp.intel.com ([10.67.234.6]) with mapi id 15.01.1713.004;
 Mon, 10 Aug 2020 20:26:34 +0530
From:   "Shankar, Uma" <uma.shankar@intel.com>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "Zuo, Alex" <alex.zuo@intel.com>,
        "Kumar, Abhishek4" <abhishek4.kumar@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/i915/display: Fix NV12 sub plane atomic state
Thread-Topic: [PATCH] drm/i915/display: Fix NV12 sub plane atomic state
Thread-Index: AQHWbyRErQycfjyac0CApTHtxYp00akxD8yAgABc9iA=
Date:   Mon, 10 Aug 2020 14:56:34 +0000
Message-ID: <db10f02b5f074f268cf304e42d4b057f@intel.com>
References: <20200810151602.20757-1-uma.shankar@intel.com>
 <c73e1ba2-dec8-c95c-dbb4-efeffe21cfb4@linux.intel.com>
In-Reply-To: <c73e1ba2-dec8-c95c-dbb4-efeffe21cfb4@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.223.10.1]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFhcnRlbiBMYW5raG9y
c3QgPG1hYXJ0ZW4ubGFua2hvcnN0QGxpbnV4LmludGVsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBB
dWd1c3QgMTAsIDIwMjAgODoxNyBQTQ0KPiBUbzogU2hhbmthciwgVW1hIDx1bWEuc2hhbmthckBp
bnRlbC5jb20+OyBpbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+IENjOiBadW8sIEFs
ZXggPGFsZXguenVvQGludGVsLmNvbT47IEt1bWFyLCBBYmhpc2hlazQNCj4gPGFiaGlzaGVrNC5r
dW1hckBpbnRlbC5jb20+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0hdIGRybS9pOTE1L2Rpc3BsYXk6IEZpeCBOVjEyIHN1YiBwbGFuZSBhdG9taWMgc3RhdGUN
Cj4gDQo+IE9wIDEwLTA4LTIwMjAgb20gMTc6MTYgc2NocmVlZiBVbWEgU2hhbmthcjoNCj4gPiBG
cm9tOiBBYmhpc2hlayBLdW1hciA8YWJoaXNoZWs0Lmt1bWFyQGludGVsLmNvbT4NCj4gPg0KPiA+
IEZvciBOVjEyIGRpc3BsYXkgc3ViIHBsYW5lIGlzIGFsc28gY29uZmlndXJlZCBhbmQgZHJpdmVy
cyBpbnRlcm5hbGx5DQo+ID4gY3JlYXRlIHBsYW5lIGF0b21pYyBzdGF0ZS4gRHJpdmVyIGNvcGll
cyBhbGwgb2YgdGhlIHBhcmFtIG9mIG1haW4NCj4gPiBwbGFuZSBhdG9taWMgc3RhdGUgdG8gc3Vi
IHBsYW5lciBhdG9taWMgc3RhdGUgYnV0IGluIHN1YiBwbGFuZSBhdG9taWMNCj4gPiBzdGF0ZSBj
cnRjIGlzIG5vdCBhZGRlZCAsc28gd2hlbiBkcm0gYXRvbWljIHN0YXRlIGlzIGNvbmZpZ3VyZWQg
Zm9yDQo+ID4gY29tbWl0ICxmYWtlIGNvbW1pdCBoYW5kbGVyIGlzIGNyZWF0ZWQgZm9yIHN1YiBw
bGFuZSBhbmQgYWxzbyBzdGF0ZSBpcw0KPiA+IG5vdCBjbGVhcmVkIHdoZW4gTlYxMiBidWZmZXIg
aXMgbm90IGRpc3BsYXllZC4NCj4gPg0KPiA+IEZpeGVzOiAxZjU5NGIyMDlmZTEgKCJkcm0vaTkx
NTogUmVtb3ZlIHNwZWNpYWwgY2FzZSBzbGF2ZSBoYW5kbGluZw0KPiA+IGR1cmluZyBodyBwcm9n
cmFtbWluZyIpDQo+ID4gQ2hhbmdlLUlkOiBJNDQ3YjE2YmY0MzNkZmI1YjQzYjJlNGNhZGUyNThm
Yzc3NWFlZTA2NQ0KPiA+IENjOiBNYWFydGVuIExhbmtob3JzdCA8bWFhcnRlbi5sYW5raG9yc3RA
bGludXguaW50ZWwuY29tPg0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gU2ln
bmVkLW9mZi1ieTogQWJoaXNoZWsgS3VtYXIgPGFiaGlzaGVrNC5rdW1hckBpbnRlbC5jb20+DQo+
ID4gU2lnbmVkLW9mZi1ieTogVW1hIFNoYW5rYXIgPHVtYS5zaGFua2FyQGludGVsLmNvbT4NCj4g
PiAtLS0NCj4gPiAgZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kaXNwbGF5LmMg
fCA2ICsrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kaXNwbGF5
LmMNCj4gPiBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZGlzcGxheS5jDQo+
ID4gaW5kZXggNTIyYzc3MmEyMTExLi43NmRhMjE4OWIwMWQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kaXNwbGF5LmMNCj4gPiArKysgYi9kcml2
ZXJzL2dwdS9kcm0vaTkxNS9kaXNwbGF5L2ludGVsX2Rpc3BsYXkuYw0KPiA+IEBAIC0xMjUwMiw2
ICsxMjUwMiw3IEBAIHN0YXRpYyBpbnQgaWNsX2NoZWNrX252MTJfcGxhbmVzKHN0cnVjdA0KPiBp
bnRlbF9jcnRjX3N0YXRlICpjcnRjX3N0YXRlKQ0KPiA+ICAJc3RydWN0IGludGVsX2F0b21pY19z
dGF0ZSAqc3RhdGUgPSB0b19pbnRlbF9hdG9taWNfc3RhdGUoY3J0Y19zdGF0ZS0NCj4gPnVhcGku
c3RhdGUpOw0KPiA+ICAJc3RydWN0IGludGVsX3BsYW5lICpwbGFuZSwgKmxpbmtlZDsNCj4gPiAg
CXN0cnVjdCBpbnRlbF9wbGFuZV9zdGF0ZSAqcGxhbmVfc3RhdGU7DQo+ID4gKwlpbnQgcmV0Ow0K
PiA+ICAJaW50IGk7DQo+ID4NCj4gPiAgCWlmIChJTlRFTF9HRU4oZGV2X3ByaXYpIDwgMTEpDQo+
ID4gQEAgLTEyNTc2LDYgKzEyNTc3LDExIEBAIHN0YXRpYyBpbnQgaWNsX2NoZWNrX252MTJfcGxh
bmVzKHN0cnVjdA0KPiBpbnRlbF9jcnRjX3N0YXRlICpjcnRjX3N0YXRlKQ0KPiA+ICAJCWxpbmtl
ZF9zdGF0ZS0+dWFwaS5zcmMgPSBwbGFuZV9zdGF0ZS0+dWFwaS5zcmM7DQo+ID4gIAkJbGlua2Vk
X3N0YXRlLT51YXBpLmRzdCA9IHBsYW5lX3N0YXRlLT51YXBpLmRzdDsNCj4gPg0KPiA+ICsJCS8q
IFVwZGF0ZSBMaW5rZWQgcGxhbmUgY3J0YyBzYW1lIGFzIG9mIG1haW4gcGxhbmUgKi8NCj4gPiAr
CQlyZXQgPSBkcm1fYXRvbWljX3NldF9jcnRjX2Zvcl9wbGFuZSgmbGlua2VkX3N0YXRlLT51YXBp
LA0KPiBwbGFuZV9zdGF0ZS0+dWFwaS5jcnRjKTsNCj4gPiArCQlpZihyZXQpDQo+ID4gKwkJCXJl
dHVybiByZXQ7DQo+ID4gKw0KPiA+ICAJCWlmIChpY2xfaXNfaGRyX3BsYW5lKGRldl9wcml2LCBw
bGFuZS0+aWQpKSB7DQo+ID4gIAkJCWlmIChsaW5rZWQtPmlkID09IFBMQU5FX1NQUklURTUpDQo+
ID4gIAkJCQlwbGFuZV9zdGF0ZS0+Y3VzX2N0bCB8PSBQTEFORV9DVVNfUExBTkVfNzsNCj4gDQo+
IFRoYXQgc2hvdWxkbnQgYmUgZG9uZSwgdWFwaS5jcnRjIHNob3VsZCBiZSBOVUxMIGZvciB0aGUg
c2xhdmUgcGxhbmUuDQoNCkhpIE1hYXJ0ZW4sDQpXZSBzZWVtIHRvIGdldCBFQlVTWSBmcm9tIGNv
bW1pdCBhbmQgZmxpcHMgZmFpbCB3aXRoIE5WMTIsIFJHQiBzZWVtcyB0byB3b3JrIGZpbmUuDQpU
aGlzIGNoYW5nZSBpcyBtYWtpbmcgdGhpbmdzIHdvcmsuIFdoYXQgY291bGQgYmUgcG9zc2libHkg
Z29pbmcgd3JvbmcgPw0KDQpUaGlzIGlzIGJlaW5nIHRlc3RlZCB3aXRoIENocm9tZSBicm93c2Vy
IGFwcCB3aGlsZSBzd2l0Y2hpbmcgdGFicyB3aXRoIHZpZGVvcyBiZWluZw0KcGxheWVkIG9uIGVh
Y2ggb2YgdGhlc2UgdGFicy4NCg0KUmVnYXJkcywNClVtYSBTaGFua2FyDQoNCg0K
