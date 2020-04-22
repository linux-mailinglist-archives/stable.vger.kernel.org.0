Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4801B48DB
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 17:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDVPhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 11:37:12 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2081 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726066AbgDVPhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 11:37:12 -0400
Received: from LHREML710-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 0D4BE2C3DD3E77226FAE;
        Wed, 22 Apr 2020 16:37:10 +0100 (IST)
Received: from fraeml703-chm.china.huawei.com (10.206.15.52) by
 LHREML710-CAH.china.huawei.com (10.201.108.33) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Wed, 22 Apr 2020 16:37:09 +0100
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 22 Apr 2020 17:37:09 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Wed, 22 Apr 2020 17:37:09 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 2/5] evm: Check also if *tfm is an error pointer in
 init_desc()
Thread-Topic: [PATCH 2/5] evm: Check also if *tfm is an error pointer in
 init_desc()
Thread-Index: AQHWAsBYfnzdf1ZhX0uCPXIJwJOnhqiFMWkAgAA+khA=
Date:   Wed, 22 Apr 2020 15:37:08 +0000
Message-ID: <37b03062b6c1455ba45ddea556ce5353@huawei.com>
References: <20200325161116.7082-1-roberto.sassu@huawei.com>
         <20200325161116.7082-2-roberto.sassu@huawei.com>
 <1587563102.5738.32.camel@linux.ibm.com>
In-Reply-To: <1587563102.5738.32.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.19.211]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkhVQVdFSSBURUNITk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzDQpNYW5h
Z2luZyBEaXJlY3RvcjogTGkgUGVuZywgTGkgSmlhbiwgU2hpIFlhbmxpDQoNCj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWltaSBab2hhciBbbWFpbHRvOnpvaGFyQGxpbnV4
LmlibS5jb21dDQo+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMjIsIDIwMjAgMzo0NSBQTQ0KPiBU
bzogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiBDYzogbGludXgt
aW50ZWdyaXR5QHZnZXIua2VybmVsLm9yZzsgbGludXgtc2VjdXJpdHktbW9kdWxlQHZnZXIua2Vy
bmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgS3J6eXN6dG9mIFN0cnVj
enluc2tpDQo+IDxrcnp5c3p0b2Yuc3RydWN6eW5za2lAaHVhd2VpLmNvbT47IFNpbHZpdSBWbGFz
Y2VhbnUNCj4gPFNpbHZpdS5WbGFzY2VhbnVAaHVhd2VpLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCAyLzVdIGV2bTogQ2hlY2sgYWxzbyBpZiAqdGZt
IGlzIGFuIGVycm9yIHBvaW50ZXIgaW4NCj4gaW5pdF9kZXNjKCkNCj4gDQo+IEhpIFJvYmVydG8s
IEtyenlzenRvZiwNCj4gDQo+IE9uIFdlZCwgMjAyMC0wMy0yNSBhdCAxNzoxMSArMDEwMCwgUm9i
ZXJ0byBTYXNzdSB3cm90ZToNCj4gPiBUaGUgbXV0ZXggaW4gaW5pdF9kZXNjKCksIGludHJvZHVj
ZWQgYnkgY29tbWl0IDk3NDI2Zjk4NTcyOSAoImV2bToNCj4gcHJldmVudA0KPiA+IHJhY2luZyBk
dXJpbmcgdGZtIGFsbG9jYXRpb24iKSBwcmV2ZW50cyB0d28gdGFza3MgdG8gY29uY3VycmVudGx5
IHNldCAqdGZtLg0KPiA+IEhvd2V2ZXIsIGNoZWNraW5nIGlmICp0Zm0gaXMgTlVMTCBpcyBub3Qg
ZW5vdWdoLCBhcyBjcnlwdG9fYWxsb2Nfc2hhc2goKQ0KPiA+IGNhbiByZXR1cm4gYW4gZXJyb3Ig
cG9pbnRlci4gVGhlIGZvbGxvd2luZyBzZXF1ZW5jZSBjYW4gaGFwcGVuOg0KPiA+DQo+ID4gVGFz
ayBBOiAqdGZtID0gY3J5cHRvX2FsbG9jX3NoYXNoKCkgPD0gZXJyb3IgcG9pbnRlcg0KPiA+IFRh
c2sgQjogaWYgKCp0Zm0gPT0gTlVMTCkgPD0gKnRmbSBpcyBub3QgTlVMTCwgdXNlIGl0DQo+ID4g
VGFzayBCOiByYyA9IGNyeXB0b19zaGFzaF9pbml0KGRlc2MpIDw9IHBhbmljDQo+ID4gVGFzayBB
OiAqdGZtID0gTlVMTA0KPiA+DQo+ID4gVGhpcyBwYXRjaCB1c2VzIHRoZSBJU19FUlJfT1JfTlVM
TCBtYWNybyB0byBkZXRlcm1pbmUgd2hldGhlciBvciBub3QNCj4gYSBuZXcNCj4gPiBjcnlwdG8g
Y29udGV4dCBtdXN0IGJlIGNyZWF0ZWQuDQo+ID4NCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZw0KPiA+IEZpeGVzOiA5NzQyNmY5ODU3MjkgKCJldm06IHByZXZlbnQgcmFjaW5nIGR1cmlu
ZyB0Zm0gYWxsb2NhdGlvbiIpDQo+IA0KPiBUaGFuayB5b3UuIMKgVHJ1ZSwgdGhpcyBjb21taXQg
aW50cm9kdWNlZCB0aGUgbXV0ZXgsIGJ1dCB0aGUgYWN0dWFsDQo+IHByb2JsZW0gaXMgbW9zdCBs
aWtlbHkgdGhlIHJlc3VsdCBvZiBhIGNyeXB0byBhbGdvcml0aG0gbm90IGJlaW5nDQo+IGNvbmZp
Z3VyZWQuIMKgRGVwZW5kaW5nIG9uIHRoZSBrZXJuZWwgYW5kIHdoaWNoIGNyeXB0byBhbGdvcml0
aG1zIGFyZQ0KPiBlbmFibGVkLCB2ZXJpZnlpbmcgYW4gRVZNIHNpZ25hdHVyZSBtaWdodCBub3Qg
YmUgcG9zc2libGUuIMKgSW4gdGhlDQo+IGVtYmVkZGVkIGVudmlyb25tZW50LCB3aGVyZSB0aGUg
ZW50aXJlIGZpbGVzeXN0ZW0gaXMgdXBkYXRlZCwgdGhlcmUNCj4gc2hvdWxkbid0IGJlIGFueSB1
bmtub3duIEVWTSBzaWduYXR1cmUgYWxnb3JpdGhtcy4NCg0KSGkgTWltaQ0KDQpyaWdodCwgdGhl
IGFjdHVhbCBjb21taXQgdGhhdCBpbnRyb2R1Y2VkIHRoZSBpc3N1ZSBpczoNCg0KZDQ2ZWIzNjk5
NTAyYiAoImV2bTogY3J5cHRvIGhhc2ggcmVwbGFjZWQgYnkgc2hhc2giKQ0KDQo+IEluIGNhc2Ug
R3JlZyBvciBTYXNoYSBkZWNpZGUgdGhpcyBwYXRjaCBzaG91bGQgYmUgYmFja3BvcnRlZCwNCj4g
aW5jbHVkaW5nIHRoZSBjb250ZXh0L21vdGl2YXRpb24gaW4gdGhlIHBhdGNoIGRlc2NyaXB0aW9u
IChmaXJzdA0KPiBwYXJhZ3JhcGgpIHdvdWxkIGJlIGhlbHBmdWwuDQoNCk9rLiBUaGUgbWFpbiBt
b3RpdmF0aW9uIGlzIHRvIGF2b2lkIGtlcm5lbCBwYW5pYywgZXNwZWNpYWxseSBpZiB0aGVyZQ0K
YXJlIG1hbnkgZmlsZXMgdGhhdCByZXF1aXJlIGFuIHVuc3VwcG9ydGVkIGhhc2ggYWxnb3JpdGht
LCBhcyBpdCB3b3VsZA0KaW5jcmVhc2UgdGhlIGxpa2VsaWhvb2Qgb2YgdGhlIHJhY2UgY29uZGl0
aW9uIEkgZGVzY3JpYmVkLg0KDQpSb2JlcnRvDQoNCkhVQVdFSSBURUNITk9MT0dJRVMgRHVlc3Nl
bGRvcmYgR21iSCwgSFJCIDU2MDYzDQpNYW5hZ2luZyBEaXJlY3RvcjogTGkgUGVuZywgTGkgSmlh
biwgU2hpIFlhbmxpDQoNCg0KPiA+IENvLWRldmVsb3BlZC1ieTogS3J6eXN6dG9mIFN0cnVjenlu
c2tpDQo+IDxrcnp5c3p0b2Yuc3RydWN6eW5za2lAaHVhd2VpLmNvbT4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBLcnp5c3p0b2YgU3RydWN6eW5za2kgPGtyenlzenRvZi5zdHJ1Y3p5bnNraUBodWF3ZWku
Y29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVh
d2VpLmNvbT4NCj4gPiAtLS0NCj4gPiAgc2VjdXJpdHkvaW50ZWdyaXR5L2V2bS9ldm1fY3J5cHRv
LmMgfCAyICstDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL3NlY3VyaXR5L2ludGVncml0eS9ldm0vZXZtX2Ny
eXB0by5jDQo+IGIvc2VjdXJpdHkvaW50ZWdyaXR5L2V2bS9ldm1fY3J5cHRvLmMNCj4gPiBpbmRl
eCAzNTY4Mjg1MmRkZWEuLjc3YWQxZTVhOTNlNCAxMDA2NDQNCj4gPiAtLS0gYS9zZWN1cml0eS9p
bnRlZ3JpdHkvZXZtL2V2bV9jcnlwdG8uYw0KPiA+ICsrKyBiL3NlY3VyaXR5L2ludGVncml0eS9l
dm0vZXZtX2NyeXB0by5jDQo+ID4gQEAgLTkxLDcgKzkxLDcgQEAgc3RhdGljIHN0cnVjdCBzaGFz
aF9kZXNjICppbml0X2Rlc2MoY2hhciB0eXBlLCB1aW50OF90DQo+IGhhc2hfYWxnbykNCj4gPiAg
CQlhbGdvID0gaGFzaF9hbGdvX25hbWVbaGFzaF9hbGdvXTsNCj4gPiAgCX0NCj4gPg0KPiA+IC0J
aWYgKCp0Zm0gPT0gTlVMTCkgew0KPiA+ICsJaWYgKElTX0VSUl9PUl9OVUxMKCp0Zm0pKSB7DQo+
ID4gIAkJbXV0ZXhfbG9jaygmbXV0ZXgpOw0KPiA+ICAJCWlmICgqdGZtKQ0KPiA+ICAJCQlnb3Rv
IG91dDsNCg0K
