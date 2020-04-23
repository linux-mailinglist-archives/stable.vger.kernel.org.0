Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DC01B5856
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 11:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgDWJjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 05:39:43 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2086 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726410AbgDWJjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 05:39:43 -0400
Received: from lhreml735-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 5A0927DFEBE864243B4C;
        Thu, 23 Apr 2020 10:39:41 +0100 (IST)
Received: from fraeml705-chm.china.huawei.com (10.206.15.54) by
 lhreml735-chm.china.huawei.com (10.201.108.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Thu, 23 Apr 2020 10:39:41 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 23 Apr 2020 11:39:40 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Thu, 23 Apr 2020 11:39:40 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] ima: Fix return value of ima_write_policy()
Thread-Topic: [PATCH] ima: Fix return value of ima_write_policy()
Thread-Index: AQHWF7xRx28EQ9GMrU2OdYcTlO4YtaiF3mkAgACWcpA=
Date:   Thu, 23 Apr 2020 09:39:40 +0000
Message-ID: <baf2fd326f5043538390254304b85e41@huawei.com>
References: <20200421090442.22693-1-roberto.sassu@huawei.com>
 <1587609266.5165.58.camel@linux.ibm.com>
In-Reply-To: <1587609266.5165.58.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.15.0]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBvd25lci1saW51eC1zZWN1cml0
eS1tb2R1bGVAdmdlci5rZXJuZWwub3JnIFttYWlsdG86b3duZXItbGludXgtDQo+IHNlY3VyaXR5
LW1vZHVsZUB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBNaW1pIFpvaGFyDQo+IFNlbnQ6
IFRodXJzZGF5LCBBcHJpbCAyMywgMjAyMCA0OjM0IEFNDQo+IFRvOiBSb2JlcnRvIFNhc3N1IDxy
b2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+IENjOiBsaW51eC1pbnRlZ3JpdHlAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1zZWN1cml0eS1tb2R1bGVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTaWx2aXUgVmxhc2NlYW51DQo+IDxTaWx2aXUuVmxhc2Nl
YW51QGh1YXdlaS5jb20+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0hdIGltYTogRml4IHJldHVybiB2YWx1ZSBvZiBpbWFfd3JpdGVfcG9saWN5KCkNCj4gDQo+
IE9uIFR1ZSwgMjAyMC0wNC0yMSBhdCAxMTowNCArMDIwMCwgUm9iZXJ0byBTYXNzdSB3cm90ZToN
Cj4gPiBSZXR1cm4gZGF0YWxlbiBpbnN0ZWFkIG9mIHplcm8gaWYgdGhlcmUgaXMgYSBydWxlIHRv
IGFwcHJhaXNlIHRoZSBwb2xpY3kNCj4gPiBidXQgdGhhdCBydWxlIGlzIG5vdCBlbmZvcmNlZC4N
Cj4gPg0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gRml4ZXM6IDE5ZjhhODQ3
MTNlZGMgKCJpbWE6IG1lYXN1cmUgYW5kIGFwcHJhaXNlIHRoZSBJTUEgcG9saWN5IGl0c2VsZiIp
DQo+ID4gU2lnbmVkLW9mZi1ieTogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWku
Y29tPg0KPiA+IC0tLQ0KPiA+ICBzZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9mcy5jIHwgMiAr
Kw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0t
Z2l0IGEvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfZnMuYw0KPiBiL3NlY3VyaXR5L2ludGVn
cml0eS9pbWEvaW1hX2ZzLmMNCj4gPiBpbmRleCBhNzFlODIyYTZlOTIuLjJjMmVhODE0Yjk1NCAx
MDA2NDQNCj4gPiAtLS0gYS9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9mcy5jDQo+ID4gKysr
IGIvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfZnMuYw0KPiA+IEBAIC0zNDAsNiArMzQwLDgg
QEAgc3RhdGljIHNzaXplX3QgaW1hX3dyaXRlX3BvbGljeShzdHJ1Y3QgZmlsZSAqZmlsZSwNCj4g
Y29uc3QgY2hhciBfX3VzZXIgKmJ1ZiwNCj4gPiAgCQkJCSAgICAxLCAwKTsNCj4gPiAgCQlpZiAo
aW1hX2FwcHJhaXNlICYgSU1BX0FQUFJBSVNFX0VORk9SQ0UpDQo+ID4gIAkJCXJlc3VsdCA9IC1F
QUNDRVM7DQo+ID4gKwkJZWxzZQ0KPiA+ICsJCQlyZXN1bHQgPSBkYXRhbGVuOw0KPiANCj4gSW4g
YWxsIG90aGVyIGNhc2VzLCB3aGVyZSB0aGUgSU1BX0FQUFJBSVNFX0VORk9SQ0UgaXMgbm90IGVu
YWJsZWQgd2UNCj4gYWxsb3cgdGhlIGFjdGlvbi4gwqBIZXJlIHdlIHByZXZlbnQgbG9hZGluZyB0
aGUgcG9saWN5LCBidXQgZG9uJ3QNCj4gcmV0dXJuIGFuIGVycm9yLiDCoE9uZSBvcHRpb24sIGFz
IHlvdSBkaWQsIGlzIHJldHVybiBzb21lIGluZGljYXRpb24NCj4gdGhhdCB0aGUgcG9saWN5IHdh
cyBub3QgbG9hZGVkLiDCoEFub3RoZXIgb3B0aW9uIHdvdWxkIGJlIHRvIGFsbG93DQo+IGxvYWRp
bmcgdGhlIHBvbGljeSBpbiBMT0cgb3IgRklYIG1vZGUsIGJ1dCBJIGRvbid0IHRoaW5rIHRoYXQg
d291bGQgYmUNCj4gcHJvZHVjdGl2ZS4gwqBQZXJoYXBzIGRpZmZlcmVudGlhdGUgYmV0d2VlbiB0
aGUgTE9HIGFuZCBGSVggbW9kZXMgZnJvbQ0KPiB0aGUgT0ZGIG1vZGUuIMKgRm9yIHRoZSBMT0cg
YW5kIEZJWCBtb2RlcywgcGVyaGFwcyByZXR1cm4gLUVBQ0NFUyBhcw0KPiB3ZWxsLiDCoEZvciB0
aGUgT0ZGIGNhc2UsIGxvYWRpbmcgYSBwb2xpY3kgd2l0aCBhcHByYWlzZSBydWxlcyBzaG91bGQN
Cj4gbm90IGJlIHBlcm1pdHRlZC4NCg0KSW4gTE9HIG9yIEZJWCBtb2RlLCBsb2FkaW5nIGEgcG9s
aWN5IHdpdGggYWJzb2x1dGUgcGF0aCB3aWxsIHN1Y2NlZWQuDQpNYXliZSB3ZSBzaG91bGQganVz
dCBrZWVwIHRoZSBzYW1lIGJlaGF2aW9yIGFsc28gd2hlbiB0aGUgcG9saWN5DQppcyBkaXJlY3Rs
eSB3cml0dGVuIHRvIHNlY3VyaXR5ZnMuDQoNCk9rIGZvciB0aGUgT0ZGIG1vZGUsIGJ1dCBwcm9i
YWJseSB0aGlzIHNob3VsZCBiZSBhIHNlcGFyYXRlIHBhdGNoLg0KDQpSb2JlcnRvDQoNCkhVQVdF
SSBURUNITk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzDQpNYW5hZ2luZyBEaXJl
Y3RvcjogTGkgUGVuZywgTGkgSmlhbiwgU2hpIFlhbmxpDQoNCg0KPiA+ICAJfSBlbHNlIHsNCj4g
PiAgCQlyZXN1bHQgPSBpbWFfcGFyc2VfYWRkX3J1bGUoZGF0YSk7DQo+ID4gIAl9DQoNCg==
