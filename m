Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AE83AA44D
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 21:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhFPT2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 15:28:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:17982 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232357AbhFPT2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 15:28:32 -0400
IronPort-SDR: tg4Iu1plkGV3iqt/Eb5zmfIqwKOzyixKjE5kQ6c4RjJ7HRIFez3dt1W68yIPBM/PJ+sQ72vbx+
 v3yxuhk/xtWg==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="227749466"
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="227749466"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 12:26:26 -0700
IronPort-SDR: 7I9LV2iRDWyFKoeIuBpHSJRJxWieP3FKWCzkXTMCnf8u+0IrMcVNrE7ShFBCFwt7n/M7VhcDLu
 BhE7FXqC7nmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="452463081"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2021 12:26:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 16 Jun 2021 12:26:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 16 Jun 2021 12:26:25 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.008;
 Wed, 16 Jun 2021 12:26:25 -0700
From:   "Souza, Jose" <jose.souza@intel.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Wayne.Lin@amd.com" <Wayne.Lin@amd.com>,
        "lyude@redhat.com" <lyude@redhat.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "aurabindo.pillai@amd.com" <aurabindo.pillai@amd.com>,
        "jerry.zuo@amd.com" <jerry.zuo@amd.com>,
        "Nicholas.Kazlauskas@amd.com" <Nicholas.Kazlauskas@amd.com>
Subject: Re: [PATCH v2 2/2] drm/dp_mst: Avoid to mess up payload table by
 ports in stale topology
Thread-Topic: [PATCH v2 2/2] drm/dp_mst: Avoid to mess up payload table by
 ports in stale topology
Thread-Index: AQHXYmOJ/7SfJFnPfEOxdT9rcgstcqsXfJqA
Date:   Wed, 16 Jun 2021 19:26:25 +0000
Message-ID: <99c6d1ddce7ede0b9d247563508b752acd41b424.camel@intel.com>
References: <20210616035501.3776-1-Wayne.Lin@amd.com>
         <20210616035501.3776-3-Wayne.Lin@amd.com>
In-Reply-To: <20210616035501.3776-3-Wayne.Lin@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0DE1DE8326E0C4698EA0097C58904DC@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIxLTA2LTE2IGF0IDExOjU1ICswODAwLCBXYXluZSBMaW4gd3JvdGU6DQo+IFtX
aHldDQo+IEFmdGVyIHVucGx1Zy9ob3RwbHVnIGh1YiBmcm9tIHRoZSBzeXN0ZW0sIHVzZXJzcGFj
ZSBtaWdodCBzdGFydCB0bw0KPiBjbGVhciBzdGFsZSBwYXlsb2FkcyBncmFkdWFsbHkuIElmIHdl
IGNhbGwgZHJtX2RwX21zdF9kZWFsbG9jYXRlX3ZjcGkoKQ0KPiB0byByZWxlYXNlIHN0YWxlIFZD
UEkgb2YgdGhvc2UgcG9ydHMgd2hpY2ggYXJlIG5vdCByZWxhdGluZyB0byBjdXJyZW50DQo+IHRv
cG9sb2d5LCB3ZSBoYXZlIGNoYW5lIHRvIHdyb25nbHkgY2xlYXIgYWN0aXZlIHBheWxvYWQgdGFi
bGUgZW50cnkgZm9yDQo+IGN1cnJlbnQgdG9wb2xvZ3kuDQo+IA0KPiBFLmcuDQo+IFdlIGhhdmUg
YWxsb2NhdGVkIFZDUEkgMSBpbiBjdXJyZW50IHBheWxvYWQgdGFibGUgYW5kIHdlIGNhbGwNCj4g
ZHJtX2RwX21zdF9kZWFsbG9jYXRlX3ZjcGkoKSB0byBjbGVhbiBWQ1BJIDEgaW4gc3RhbGUgdG9w
b2xvZ3kuIEluDQo+IGRybV9kcF9tc3RfZGVhbGxvY2F0ZV92Y3BpKCksIGl0IHdpbGwgY2FsbCBk
cm1fZHBfbXN0X3B1dF9wYXlsb2FkX2lkKCkNCj4gdHAgcHV0IFZDUEkgMSBhbmQgd2hpY2ggbWVh
bnMgSUQgMSBpcyBhdmFpbGFibGUgYWdhaW4uIFRoZXJlYWZ0ZXIsIGlmIHdlDQo+IHdhbnQgdG8g
YWxsb2NhdGUgYSBuZXcgcGF5bG9hZCBzdHJlYW0sIGl0IHdpbGwgZmluZCBJRCAxIGlzIGF2YWls
YWJsZSBieQ0KPiBkcm1fZHBfbXN0X2Fzc2lnbl9wYXlsb2FkX2lkKCkuIEhvd2V2ZXIsIElEIDEg
aXMgYmVpbmcgdXNlZA0KPiANCj4gW0hvd10NCj4gQ2hlY2sgdGFyZ2V0IHNpbmsgaXMgcmVsYXRp
bmcgdG8gY3VycmVudCB0b3BvbG9neSBvciBub3QgYmVmb3JlIGRvaW5nDQo+IGFueSBwYXlsb2Fk
IHRhYmxlIHVwZGF0ZS4NCj4gU2VhcmNoaW5nIHVwd2FyZCB0byBmaW5kIHRoZSB0YXJnZXQgc2lu
aydzIHJlbGV2YW50IHJvb3QgYnJhbmNoIGRldmljZS4NCj4gSWYgdGhlIGZvdW5kIHJvb3QgYnJh
bmNoIGRldmljZSBpcyBub3QgdGhlIHNhbWUgcm9vdCBvZiBjdXJyZW50DQo+IHRvcG9sb2d5LCBk
b24ndCB1cGRhdGUgcGF5bG9hZCB0YWJsZS4NCj4gDQo+IENoYW5nZXMgc2luY2UgdjE6DQo+ICog
Q2hhbmdlIGRlYnVnIG1hY3JvIHRvIHVzZSBkcm1fZGJnX2ttcygpIGluc3RlYWQNCj4gKiBBbWVu
ZCB0aGUgY29tbWl0IG1lc3NhZ2UgdG8gYWRkIENjIHRhZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IFdheW5lIExpbiA8V2F5bmUuTGluQGFtZC5jb20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUvZHJtL2RybV9kcF9tc3RfdG9wb2xvZ3kuYyB8IDI5
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDI5IGluc2Vy
dGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vZHJtX2RwX21zdF90
b3BvbG9neS5jIGIvZHJpdmVycy9ncHUvZHJtL2RybV9kcF9tc3RfdG9wb2xvZ3kuYw0KPiBpbmRl
eCBiNDFiODM3ZGI2NmQuLjlhYzE0OGVmZDllNCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9ncHUv
ZHJtL2RybV9kcF9tc3RfdG9wb2xvZ3kuYw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2Rw
X21zdF90b3BvbG9neS5jDQo+IEBAIC05NCw2ICs5NCw5IEBAIHN0YXRpYyBpbnQgZHJtX2RwX21z
dF9yZWdpc3Rlcl9pMmNfYnVzKHN0cnVjdCBkcm1fZHBfbXN0X3BvcnQgKnBvcnQpOw0KPiAgc3Rh
dGljIHZvaWQgZHJtX2RwX21zdF91bnJlZ2lzdGVyX2kyY19idXMoc3RydWN0IGRybV9kcF9tc3Rf
cG9ydCAqcG9ydCk7DQo+ICBzdGF0aWMgdm9pZCBkcm1fZHBfbXN0X2tpY2tfdHgoc3RydWN0IGRy
bV9kcF9tc3RfdG9wb2xvZ3lfbWdyICptZ3IpOw0KPiAgDQo+ICtzdGF0aWMgYm9vbCBkcm1fZHBf
bXN0X3BvcnRfZG93bnN0cmVhbV9vZl9icmFuY2goc3RydWN0IGRybV9kcF9tc3RfcG9ydCAqcG9y
dCwNCj4gKwkJCQkJCSBzdHJ1Y3QgZHJtX2RwX21zdF9icmFuY2ggKmJyYW5jaCk7DQo+ICsNCj4g
ICNkZWZpbmUgREJHX1BSRUZJWCAiW2RwX21zdF0iDQo+ICANCj4gICNkZWZpbmUgRFBfU1RSKHgp
IFtEUF8gIyMgeF0gPSAjeA0KPiBAQCAtMzM2Niw2ICszMzY5LDcgQEAgaW50IGRybV9kcF91cGRh
dGVfcGF5bG9hZF9wYXJ0MShzdHJ1Y3QgZHJtX2RwX21zdF90b3BvbG9neV9tZ3IgKm1ncikNCj4g
IAlzdHJ1Y3QgZHJtX2RwX21zdF9wb3J0ICpwb3J0Ow0KPiAgCWludCBpLCBqOw0KPiAgCWludCBj
dXJfc2xvdHMgPSAxOw0KPiArCWJvb2wgc2tpcDsNCj4gIA0KPiAgCW11dGV4X2xvY2soJm1nci0+
cGF5bG9hZF9sb2NrKTsNCj4gIAlmb3IgKGkgPSAwOyBpIDwgbWdyLT5tYXhfcGF5bG9hZHM7IGkr
Kykgew0KPiBAQCAtMzM4MCw2ICszMzg0LDE0IEBAIGludCBkcm1fZHBfdXBkYXRlX3BheWxvYWRf
cGFydDEoc3RydWN0IGRybV9kcF9tc3RfdG9wb2xvZ3lfbWdyICptZ3IpDQo+ICAJCQlwb3J0ID0g
Y29udGFpbmVyX29mKHZjcGksIHN0cnVjdCBkcm1fZHBfbXN0X3BvcnQsDQo+ICAJCQkJCSAgICB2
Y3BpKTsNCj4gIA0KPiArCQkJbXV0ZXhfbG9jaygmbWdyLT5sb2NrKTsNCj4gKwkJCXNraXAgPSAh
ZHJtX2RwX21zdF9wb3J0X2Rvd25zdHJlYW1fb2ZfYnJhbmNoKHBvcnQsIG1nci0+bXN0X3ByaW1h
cnkpOw0KPiArCQkJbXV0ZXhfdW5sb2NrKCZtZ3ItPmxvY2spOw0KPiArDQo+ICsJCQlpZiAoc2tp
cCkgew0KPiArCQkJCWRybV9kYmdfa21zKCJWaXJ0dWFsIGNoYW5uZWwgJWQgaXMgbm90IGluIGN1
cnJlbnQgdG9wb2xvZ3lcbiIsIGkpOw0KDQpNaXNzaW5nIGRldi9kcm0gcGFyYW1ldGVyIGFuZCBi
cmVha2luZyB0aGUgYnVpbGQuDQoNCj4gKwkJCQljb250aW51ZTsNCj4gKwkJCX0NCj4gIAkJCS8q
IFZhbGlkYXRlZCBwb3J0cyBkb24ndCBtYXR0ZXIgaWYgd2UncmUgcmVsZWFzaW5nDQo+ICAJCQkg
KiBWQ1BJDQo+ICAJCQkgKi8NCj4gQEAgLTM0NzksNiArMzQ5MSw3IEBAIGludCBkcm1fZHBfdXBk
YXRlX3BheWxvYWRfcGFydDIoc3RydWN0IGRybV9kcF9tc3RfdG9wb2xvZ3lfbWdyICptZ3IpDQo+
ICAJc3RydWN0IGRybV9kcF9tc3RfcG9ydCAqcG9ydDsNCj4gIAlpbnQgaTsNCj4gIAlpbnQgcmV0
ID0gMDsNCj4gKwlib29sIHNraXA7DQo+ICANCj4gIAltdXRleF9sb2NrKCZtZ3ItPnBheWxvYWRf
bG9jayk7DQo+ICAJZm9yIChpID0gMDsgaSA8IG1nci0+bWF4X3BheWxvYWRzOyBpKyspIHsNCj4g
QEAgLTM0ODgsNiArMzUwMSwxMyBAQCBpbnQgZHJtX2RwX3VwZGF0ZV9wYXlsb2FkX3BhcnQyKHN0
cnVjdCBkcm1fZHBfbXN0X3RvcG9sb2d5X21nciAqbWdyKQ0KPiAgDQo+ICAJCXBvcnQgPSBjb250
YWluZXJfb2YobWdyLT5wcm9wb3NlZF92Y3Bpc1tpXSwgc3RydWN0IGRybV9kcF9tc3RfcG9ydCwg
dmNwaSk7DQo+ICANCj4gKwkJbXV0ZXhfbG9jaygmbWdyLT5sb2NrKTsNCj4gKwkJc2tpcCA9ICFk
cm1fZHBfbXN0X3BvcnRfZG93bnN0cmVhbV9vZl9icmFuY2gocG9ydCwgbWdyLT5tc3RfcHJpbWFy
eSk7DQo+ICsJCW11dGV4X3VubG9jaygmbWdyLT5sb2NrKTsNCj4gKw0KPiArCQlpZiAoc2tpcCkN
Cj4gKwkJCWNvbnRpbnVlOw0KPiArDQo+ICAJCWRybV9kYmdfa21zKG1nci0+ZGV2LCAicGF5bG9h
ZCAlZCAlZFxuIiwgaSwgbWdyLT5wYXlsb2Fkc1tpXS5wYXlsb2FkX3N0YXRlKTsNCj4gIAkJaWYg
KG1nci0+cGF5bG9hZHNbaV0ucGF5bG9hZF9zdGF0ZSA9PSBEUF9QQVlMT0FEX0xPQ0FMKSB7DQo+
ICAJCQlyZXQgPSBkcm1fZHBfY3JlYXRlX3BheWxvYWRfc3RlcDIobWdyLCBwb3J0LCBtZ3ItPnBy
b3Bvc2VkX3ZjcGlzW2ldLT52Y3BpLCAmbWdyLT5wYXlsb2Fkc1tpXSk7DQo+IEBAIC00NTc0LDkg
KzQ1OTQsMTggQEAgRVhQT1JUX1NZTUJPTChkcm1fZHBfbXN0X3Jlc2V0X3ZjcGlfc2xvdHMpOw0K
PiAgdm9pZCBkcm1fZHBfbXN0X2RlYWxsb2NhdGVfdmNwaShzdHJ1Y3QgZHJtX2RwX21zdF90b3Bv
bG9neV9tZ3IgKm1nciwNCj4gIAkJCQlzdHJ1Y3QgZHJtX2RwX21zdF9wb3J0ICpwb3J0KQ0KPiAg
ew0KPiArCWJvb2wgc2tpcDsNCj4gKw0KPiAgCWlmICghcG9ydC0+dmNwaS52Y3BpKQ0KPiAgCQly
ZXR1cm47DQo+ICANCj4gKwltdXRleF9sb2NrKCZtZ3ItPmxvY2spOw0KPiArCXNraXAgPSAhZHJt
X2RwX21zdF9wb3J0X2Rvd25zdHJlYW1fb2ZfYnJhbmNoKHBvcnQsIG1nci0+bXN0X3ByaW1hcnkp
Ow0KPiArCW11dGV4X3VubG9jaygmbWdyLT5sb2NrKTsNCj4gKw0KPiArCWlmIChza2lwKQ0KPiAr
CQlyZXR1cm47DQo+ICsNCj4gIAlkcm1fZHBfbXN0X3B1dF9wYXlsb2FkX2lkKG1nciwgcG9ydC0+
dmNwaS52Y3BpKTsNCj4gIAlwb3J0LT52Y3BpLm51bV9zbG90cyA9IDA7DQo+ICAJcG9ydC0+dmNw
aS5wYm4gPSAwOw0KDQo=
