Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616461BD4CB
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 08:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgD2Gnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 02:43:37 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726158AbgD2Gng (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 02:43:36 -0400
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 0529315BC91E05DB2692;
        Wed, 29 Apr 2020 07:43:35 +0100 (IST)
Received: from fraeml704-chm.china.huawei.com (10.206.15.53) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Wed, 29 Apr 2020 07:43:34 +0100
Received: from lhreml722-chm.china.huawei.com (10.201.108.73) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 29 Apr 2020 08:43:33 +0200
Received: from lhreml722-chm.china.huawei.com ([10.201.108.73]) by
 lhreml722-chm.china.huawei.com ([10.201.108.73]) with mapi id 15.01.1913.007;
 Wed, 29 Apr 2020 07:43:33 +0100
From:   Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 6/6] ima: Fix return value of ima_write_policy()
Thread-Topic: [PATCH v2 6/6] ima: Fix return value of ima_write_policy()
Thread-Index: AQHWHH9bJMB74MHPBU+JlJn2oiegG6iOwCwAgADnE9A=
Date:   Wed, 29 Apr 2020 06:43:33 +0000
Message-ID: <cee0cd9d63864ed4a39422c6be818e36@huawei.com>
References: <20200427102900.18887-1-roberto.sassu@huawei.com>
         <20200427103128.19229-1-roberto.sassu@huawei.com>
 <1588095998.5195.49.camel@linux.ibm.com>
In-Reply-To: <1588095998.5195.49.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.9.247]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWltaSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaW1pIFpv
aGFyIFttYWlsdG86em9oYXJAbGludXguaWJtLmNvbV0NCj4gU2VudDogVHVlc2RheSwgQXByaWwg
MjgsIDIwMjAgNzo0NyBQTQ0KPiBUbzogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3
ZWkuY29tPjsgS3J6eXN6dG9mIFN0cnVjenluc2tpDQo+IDxrcnp5c3p0b2Yuc3RydWN6eW5za2lA
aHVhd2VpLmNvbT4NCj4gQ2M6IGxpbnV4LWludGVncml0eUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LXNlY3VyaXR5LW1vZHVsZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IFNpbHZpdSBWbGFzY2VhbnUNCj4gPFNpbHZpdS5WbGFzY2VhbnVAaHVhd2VpLmNv
bT47IEtyenlzenRvZiBTdHJ1Y3p5bnNraQ0KPiA8a3J6eXN6dG9mLnN0cnVjenluc2tpQGh1YXdl
aS5jb20+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIg
Ni82XSBpbWE6IEZpeCByZXR1cm4gdmFsdWUgb2YgaW1hX3dyaXRlX3BvbGljeSgpDQo+IA0KPiBI
aSBSb2JlcnRvLA0KPiANCj4gT24gTW9uLCAyMDIwLTA0LTI3IGF0IDEyOjMxICswMjAwLCBSb2Jl
cnRvIFNhc3N1IHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggZml4ZXMgdGhlIHJldHVybiB2YWx1ZSBv
ZiBpbWFfd3JpdGVfcG9saWN5KCkgd2hlbiBhIG5ldw0KPiA+IHBvbGljeSBpcyBkaXJlY3RseSBw
YXNzZWQgdG8gSU1BIGFuZCB0aGUgY3VycmVudCBwb2xpY3kgcmVxdWlyZXMNCj4gPiBhcHByYWlz
YWwgb2YgdGhlIGZpbGUgY29udGFpbmluZyB0aGUgcG9saWN5LiBDdXJyZW50bHksIGlmIGFwcHJh
aXNhbA0KPiA+IGlzIG5vdCBpbiBFTkZPUkNFIG1vZGUsDQo+ID4gaW1hX3dyaXRlX3BvbGljeSgp
IHJldHVybnMgMCBhbmQgbGVhZHMgdXNlciBzcGFjZSBhcHBsaWNhdGlvbnMgdG8gYW4NCj4gPiBl
bmRsZXNzIGxvb3AuIEZpeCB0aGlzIGlzc3VlIGJ5IGRlbnlpbmcgdGhlIG9wZXJhdGlvbiByZWdh
cmRsZXNzIG9mDQo+ID4gdGhlIGFwcHJhaXNhbCBtb2RlLg0KPiA+DQo+ID4gQ2hhbmdlbG9nDQo+
ID4NCj4gPiB2MToNCj4gPiAtIGRlbnkgdGhlIG9wZXJhdGlvbiBpbiBhbGwgY2FzZXMgKHN1Z2dl
c3RlZCBieSBNaW1pLCBLcnp5c3p0b2YpDQo+IA0KPiBSZWxhdGl2ZWx5IHJlY2VudGx5LCBwZW9w
bGUgaGF2ZSBtb3ZlZCBhd2F5IGZyb20gaW5jbHVkaW5nIHRoZSAiQ2hhbmdlbG9nIg0KPiBpbiB0
aGUgdXBzdHJlYW0gY29tbWl0LiAoSSdtIHJlbW92aW5nIHRoZW0gbm93LikNCj4gDQo+ID4NCj4g
PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIDQuMTAueA0KPiA+IEZpeGVzOiAxOWY4YTg0
NzEzZWRjICgiaW1hOiBtZWFzdXJlIGFuZCBhcHByYWlzZSB0aGUgSU1BIHBvbGljeQ0KPiA+IGl0
c2VsZiIpDQo+ID4gU2lnbmVkLW9mZi1ieTogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBo
dWF3ZWkuY29tPg0KPiANCj4gV2l0aG91dCB0aGUgQ2hhbmdlbG9nLCB0aGUgb25seSB3YXkgb2Yg
YWNrbm93bGVkZ2luZyBwZW9wbGUncyBjb250cmlidXRpb25zDQo+IGlzIGJ5IGluY2x1ZGluZyB0
aGVpciB0YWdzLiDCoEtyenlzenRvZiwgZGlkIHlvdSB3YW50IHRvIGFkZCB5b3VyICJSZXZpZXdl
ZC1ieSINCj4gdGFnPw0KDQpQbGVhc2UgYWRkOg0KUmV2aWV3ZWQtYnk6IEtyenlzenRvZiBTdHJ1
Y3p5bnNraSA8a3J6eXN6dG9mLnN0cnVjenluc2tpQGh1YXdlaS5jb20+DQoNClRoYW5rcywNCkty
enlzenRvZg0KDQo+IA0KPiA+IC0tLQ0KPiANCj4gUGVvcGxlIGhhdmUgc3RhcnRlZCBwdXR0aW5n
IHRoZSBDaGFuZ2Vsb2cgb3IgYW55IGNvbW1lbnRzIGltbWVkaWF0ZWx5DQo+IGJlbG93IHRoZSBz
ZXBhcmF0b3IgIi0tLSIgaGVyZS4NCj4gDQo+IHRoYW5rcywNCj4gDQo+IE1pbWkNCj4gDQo+ID4g
IHNlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hX2ZzLmMgfCAzICstLQ0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfZnMuYw0KPiA+IGIvc2VjdXJpdHkvaW50ZWdy
aXR5L2ltYS9pbWFfZnMuYyBpbmRleCA4YjAzMGExYzVlMGQuLmUzZmNhZDg3MTg2MQ0KPiA+IDEw
MDY0NA0KPiA+IC0tLSBhL3NlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hX2ZzLmMNCj4gPiArKysg
Yi9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9mcy5jDQo+ID4gQEAgLTMzOCw4ICszMzgsNyBA
QCBzdGF0aWMgc3NpemVfdCBpbWFfd3JpdGVfcG9saWN5KHN0cnVjdCBmaWxlICpmaWxlLCBjb25z
dA0KPiBjaGFyIF9fdXNlciAqYnVmLA0KPiA+ICAJCWludGVncml0eV9hdWRpdF9tc2coQVVESVRf
SU5URUdSSVRZX1NUQVRVUywgTlVMTCwgTlVMTCwNCj4gPiAgCQkJCSAgICAicG9saWN5X3VwZGF0
ZSIsICJzaWduZWQgcG9saWN5IHJlcXVpcmVkIiwNCj4gPiAgCQkJCSAgICAxLCAwKTsNCj4gPiAt
CQlpZiAoaW1hX2FwcHJhaXNlICYgSU1BX0FQUFJBSVNFX0VORk9SQ0UpDQo+ID4gLQkJCXJlc3Vs
dCA9IC1FQUNDRVM7DQo+ID4gKwkJcmVzdWx0ID0gLUVBQ0NFUzsNCj4gPiAgCX0gZWxzZSB7DQo+
ID4gIAkJcmVzdWx0ID0gaW1hX3BhcnNlX2FkZF9ydWxlKGRhdGEpOw0KPiA+ICAJfQ0KDQo=
