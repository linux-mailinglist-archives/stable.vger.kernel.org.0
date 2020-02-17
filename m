Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C321610F3
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgBQLTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:19:30 -0500
Received: from skedge04.snt-world.com ([91.208.41.69]:49214 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgBQLTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:19:30 -0500
Received: from sntmail14r.snt-is.com (unknown [10.203.32.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 8755667A879;
        Mon, 17 Feb 2020 12:19:26 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail14r.snt-is.com
 (10.203.32.184) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 17 Feb
 2020 12:19:26 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Mon, 17 Feb 2020 12:19:26 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
CC:     Boris Brezillon <bbrezillon@kernel.org>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Peter Pan <peterpandong@micron.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 3/3] mtd: spinand: Wait for the erase op to finish before
 writing a bad block marker
Thread-Topic: [PATCH 3/3] mtd: spinand: Wait for the erase op to finish before
 writing a bad block marker
Thread-Index: AQHV4PlTblnHiLQcV0asTsn4OWAZ0KgfKk6AgAALNIA=
Date:   Mon, 17 Feb 2020 11:19:25 +0000
Message-ID: <cbec4c2f-64f3-3353-b237-83345321d7a7@kontron.de>
References: <20200211163452.25442-1-frieder.schrempf@kontron.de>
 <20200211163452.25442-4-frieder.schrempf@kontron.de>
 <20200217113919.0508acc4@xps13>
In-Reply-To: <20200217113919.0508acc4@xps13>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0A59AABDB63894FBDE63DEC1DF3D9EE@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 8755667A879.AE6B2
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: bbrezillon@kernel.org, git-commits@allycomm.com,
        liaoweixiong@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, miquel.raynal@bootlin.com,
        peterpandong@micron.com, richard@nod.at, stable@vger.kernel.org
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWlxdWVsLA0KDQpPbiAxNy4wMi4yMCAxMTozOSwgTWlxdWVsIFJheW5hbCB3cm90ZToNCj4g
SGkgRnJpZWRlciwNCj4gDQo+IFNjaHJlbXBmIEZyaWVkZXIgPGZyaWVkZXIuc2NocmVtcGZAa29u
dHJvbi5kZT4gd3JvdGUgb24gVHVlLCAxMSBGZWINCj4gMjAyMCAxNjozNTo1MyArMDAwMDoNCj4g
DQo+PiBGcm9tOiBGcmllZGVyIFNjaHJlbXBmIDxmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24uZGU+
DQo+Pg0KPj4gQ3VycmVudGx5IHdoZW4gbWFya2luZyBhIGJsb2NrLCB3ZSB1c2Ugc3BpbmFuZF9l
cmFzZV9vcCgpIHRvIGVyYXNlDQo+PiB0aGUgYmxvY2sgYmVmb3JlIHdyaXRpbmcgdGhlIG1hcmtl
ciB0byB0aGUgT09CIGFyZWEgd2l0aG91dCB3YWl0aW5nDQo+PiBmb3IgdGhlIG9wZXJhdGlvbiB0
byBzdWNjZWVkLiBUaGlzIGNhbiBsZWFkIHRvIHRoZSBtYXJraW5nIGZhaWxpbmcNCj4+IHNpbGVu
dGx5IGFuZCBubyBiYWQgYmxvY2sgbWFya2VyIGJlaW5nIHdyaXR0ZW4gdG8gdGhlIGZsYXNoLg0K
Pj4NCj4+IFRvIGZpeCB0aGlzIHdlIHJldXNlIHRoZSBzcGluYW5kX2VyYXNlKCkgZnVuY3Rpb24s
IHRoYXQgYWxyZWFkeSBkb2VzDQo+PiBldmVyeXRoaW5nIHdlIG5lZWQgdG8gZG8gYmVmb3JlIGFj
dHVhbGx5IHdyaXRpbmcgdGhlIG1hcmtlci4NCj4+DQo+IA0KPiBUaGFua3MgYSBsb3QgZm9yIHRo
aXMgc2VyaWVzIQ0KPiANCj4gWWV0IEkgZG9uJ3QgcmVhbGx5IHVuZGVyc3RhbmQgdGhlIHBvaW50
IG9mIHdhaXRpbmcgZm9yIHRoZSBlcmFzdXJlIGlmDQo+IGl0IGZhaWxlZDogd2UgZG9uJ3QgcmVh
bGx5IGNhcmUgYXMgcHJvZ3JhbW1pbmcgKDEgLT4gMCkgY2VsbHMgaXMgYWx3YXlzDQo+IHBvc3Np
YmxlLiBBcmUgeW91IHN1cmUgdGhpcyBsZWFkIHRvIGFuIGVycm9yPw0KDQpXZSBkb24ndCBjYXJl
IGFib3V0IHRoZSByZXN1bHQgb2YgdGhlIGVyYXNlIG9wZXJhdGlvbiwgYnV0IEkgdGhpbmsgd2Ug
DQpzdGlsbCBuZWVkIHRvIHdhaXQgZm9yIGl0IHRvIGJlIGRvbmUgYW5kIHRoZSBTVEFUVVNfQlVT
WSBiaXQgdG8gYmUgDQpjbGVhcmVkLiBPdGhlcndpc2UgaXQgc2VlbXMgbGlrZSB0aGUgcHJvZ3Jh
bSBvcGVyYXRpb24gdG8gc2V0IHRoZSBtYXJrZXIgDQpjYW4gZ2V0IGlnbm9yZWQgYnkgdGhlIGNo
aXAuIEF0IGxlYXN0IHRoYXQncyBteSBleHBsYW5hdGlvbiBmb3IgdGhlIA0KYmVoYXZpb3IgSSB3
YXMgb2JzZXJ2aW5nLg0KDQo+IA0KPiBBbHNvLCB3aHkganVzdCBub3QgY2FsbGluZyBzcGluYW5k
X2VyYXNlKCkgaW5zdGVhZCBvZg0KPiBzcGluYW5kX2VyYXNlX29wKCkgZnJvbSBzcGluYW5kX21h
cmtiYWQoKT8NCg0KWWVhaCwgdGhhdCdzIHdyb25nLiBJIHdhcyB0aGlua2luZywgdGhhdCBzcGlu
YW5kX2VyYXNlX29wKCkgd291bGQgcmV0dXJuIA0KYW4gZXJyb3IgaWYgdGhlIGVyYXNlIGZhaWxl
ZCBvbiB0aGUgZmxhc2ggbGV2ZWwgKHdoaWNoIHNob3VsZCBoYXZlIGJlZW4gDQppZ25vcmVkIGlu
IHRoaXMgY2FzZSkuIFRoZSBjdXJyZW50IGNvZGUgc3VnZ2VzdGVkIHRoaXMgYXMgaXQgZG9lc24n
dCANCmhhbmRsZSB0aGUgcmV0dXJuIHZhbHVlIG9mIHNwaW5hbmRfZXJhc2Vfb3AoKS4NCg0KQnV0
IGluIGZhY3QgdGhlIHN1Y2Nlc3Mgb2YgdGhlIGVyYXNlIG9wZXJhdGlvbiBpcyBvbmx5IGNoZWNr
ZWQgaW4gDQpzcGluYW5kX2VyYXNlKCkgYWZ0ZXIgd2FpdGluZyBmb3IgdGhlIGZsYXNoIHRvIGJl
IHJlYWR5LiBTbyBJIHRoaW5rIHdlIA0KY2FuIHVzZSBzcGluYW5kX2VyYXNlKCksIGJ1dCBpbnN0
ZWFkIG9mIGlnbm9yaW5nIHRoZSByZXR1cm4gdmFsdWUgb2YgDQpzcGluYW5kX2VyYXNlX29wKCks
IHdlIG5lZWQgdG8gaWdub3JlIHRoZSAnc3RhdHVzICYgU1RBVFVTX0VSQVNFX0ZBSUxFRCcgDQpj
aGVjay4NCg0KVGhhbmtzLA0KRnJpZWRlcg0KDQo+IA0KPj4gRml4ZXM6IDc1MjlkZjQ2NTI0OCAo
Im10ZDogbmFuZDogQWRkIGNvcmUgaW5mcmFzdHJ1Y3R1cmUgdG8gc3VwcG9ydCBTUEkgTkFORHMi
KQ0KPj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4+IFNpZ25lZC1vZmYtYnk6IEZyaWVk
ZXIgU2NocmVtcGYgPGZyaWVkZXIuc2NocmVtcGZAa29udHJvbi5kZT4NCj4+IC0tLQ0KPj4gICBk
cml2ZXJzL210ZC9uYW5kL3NwaS9jb3JlLmMgfCA1NiArKysrKysrKysrKysrKysrKystLS0tLS0t
LS0tLS0tLS0tLS0tDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAyOCBpbnNlcnRpb25zKCspLCAyOCBk
ZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tdGQvbmFuZC9zcGkvY29y
ZS5jIGIvZHJpdmVycy9tdGQvbmFuZC9zcGkvY29yZS5jDQo+PiBpbmRleCA5MjVkYjYyNjk4NjEu
LjhhNjlkMTM2MzllMiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbXRkL25hbmQvc3BpL2NvcmUu
Yw0KPj4gKysrIGIvZHJpdmVycy9tdGQvbmFuZC9zcGkvY29yZS5jDQo+PiBAQCAtNjAwLDYgKzYw
MCwzMiBAQCBzdGF0aWMgaW50IHNwaW5hbmRfbXRkX2Jsb2NrX2lzYmFkKHN0cnVjdCBtdGRfaW5m
byAqbXRkLCBsb2ZmX3Qgb2ZmcykNCj4+ICAgCXJldHVybiByZXQ7DQo+PiAgIH0NCj4+ICAgDQo+
PiArc3RhdGljIGludCBfX3NwaW5hbmRfZXJhc2Uoc3RydWN0IG5hbmRfZGV2aWNlICpuYW5kLCBj
b25zdCBzdHJ1Y3QgbmFuZF9wb3MgKnBvcywNCj4+ICsJCQkgICBib29sIGhhcmRfZmFpbCkNCj4+
ICt7DQo+PiArCXN0cnVjdCBzcGluYW5kX2RldmljZSAqc3BpbmFuZCA9IG5hbmRfdG9fc3BpbmFu
ZChuYW5kKTsNCj4+ICsJdTggc3RhdHVzOw0KPj4gKwlpbnQgcmV0Ow0KPj4gKw0KPj4gKwlyZXQg
PSBzcGluYW5kX3NlbGVjdF90YXJnZXQoc3BpbmFuZCwgcG9zLT50YXJnZXQpOw0KPj4gKwlpZiAo
cmV0KQ0KPj4gKwkJcmV0dXJuIHJldDsNCj4+ICsNCj4+ICsJcmV0ID0gc3BpbmFuZF93cml0ZV9l
bmFibGVfb3Aoc3BpbmFuZCk7DQo+PiArCWlmIChyZXQpDQo+PiArCQlyZXR1cm4gcmV0Ow0KPj4g
Kw0KPj4gKwlyZXQgPSBzcGluYW5kX2VyYXNlX29wKHNwaW5hbmQsIHBvcyk7DQo+PiArCWlmIChy
ZXQgJiYgaGFyZF9mYWlsKQ0KPj4gKwkJcmV0dXJuIHJldDsNCj4+ICsNCj4+ICsJcmV0ID0gc3Bp
bmFuZF93YWl0KHNwaW5hbmQsICZzdGF0dXMpOw0KPj4gKwlpZiAoIXJldCAmJiAoc3RhdHVzICYg
U1RBVFVTX0VSQVNFX0ZBSUxFRCkpDQo+PiArCQlyZXQgPSAtRUlPOw0KPj4gKw0KPj4gKwlyZXR1
cm4gcmV0Ow0KPj4gK30NCj4+ICsNCj4+ICAgc3RhdGljIGludCBzcGluYW5kX21hcmtiYWQoc3Ry
dWN0IG5hbmRfZGV2aWNlICpuYW5kLCBjb25zdCBzdHJ1Y3QgbmFuZF9wb3MgKnBvcykNCj4+ICAg
ew0KPj4gICAJc3RydWN0IHNwaW5hbmRfZGV2aWNlICpzcGluYW5kID0gbmFuZF90b19zcGluYW5k
KG5hbmQpOw0KPj4gQEAgLTYxNCwxNiArNjQwLDEwIEBAIHN0YXRpYyBpbnQgc3BpbmFuZF9tYXJr
YmFkKHN0cnVjdCBuYW5kX2RldmljZSAqbmFuZCwgY29uc3Qgc3RydWN0IG5hbmRfcG9zICpwb3Mp
DQo+PiAgIAlpbnQgcmV0Ow0KPj4gICANCj4+ICAgCS8qIEVyYXNlIGJsb2NrIGJlZm9yZSBtYXJr
aW5nIGl0IGJhZC4gKi8NCj4+IC0JcmV0ID0gc3BpbmFuZF9zZWxlY3RfdGFyZ2V0KHNwaW5hbmQs
IHBvcy0+dGFyZ2V0KTsNCj4+IC0JaWYgKHJldCkNCj4+IC0JCXJldHVybiByZXQ7DQo+PiAtDQo+
PiAtCXJldCA9IHNwaW5hbmRfd3JpdGVfZW5hYmxlX29wKHNwaW5hbmQpOw0KPj4gKwlyZXQgPSBf
X3NwaW5hbmRfZXJhc2UobmFuZCwgcG9zLCBmYWxzZSk7DQo+PiAgIAlpZiAocmV0KQ0KPj4gICAJ
CXJldHVybiByZXQ7DQo+PiAgIA0KPj4gLQlzcGluYW5kX2VyYXNlX29wKHNwaW5hbmQsIHBvcyk7
DQo+PiAtDQo+PiAgIAlyZXR1cm4gc3BpbmFuZF93cml0ZV9wYWdlKHNwaW5hbmQsICZyZXEpOw0K
Pj4gICB9DQo+PiAgIA0KPj4gQEAgLTY0NCwyNyArNjY0LDcgQEAgc3RhdGljIGludCBzcGluYW5k
X210ZF9ibG9ja19tYXJrYmFkKHN0cnVjdCBtdGRfaW5mbyAqbXRkLCBsb2ZmX3Qgb2ZmcykNCj4+
ICAgDQo+PiAgIHN0YXRpYyBpbnQgc3BpbmFuZF9lcmFzZShzdHJ1Y3QgbmFuZF9kZXZpY2UgKm5h
bmQsIGNvbnN0IHN0cnVjdCBuYW5kX3BvcyAqcG9zKQ0KPj4gICB7DQo+PiAtCXN0cnVjdCBzcGlu
YW5kX2RldmljZSAqc3BpbmFuZCA9IG5hbmRfdG9fc3BpbmFuZChuYW5kKTsNCj4+IC0JdTggc3Rh
dHVzOw0KPj4gLQlpbnQgcmV0Ow0KPj4gLQ0KPj4gLQlyZXQgPSBzcGluYW5kX3NlbGVjdF90YXJn
ZXQoc3BpbmFuZCwgcG9zLT50YXJnZXQpOw0KPj4gLQlpZiAocmV0KQ0KPj4gLQkJcmV0dXJuIHJl
dDsNCj4+IC0NCj4+IC0JcmV0ID0gc3BpbmFuZF93cml0ZV9lbmFibGVfb3Aoc3BpbmFuZCk7DQo+
PiAtCWlmIChyZXQpDQo+PiAtCQlyZXR1cm4gcmV0Ow0KPj4gLQ0KPj4gLQlyZXQgPSBzcGluYW5k
X2VyYXNlX29wKHNwaW5hbmQsIHBvcyk7DQo+PiAtCWlmIChyZXQpDQo+PiAtCQlyZXR1cm4gcmV0
Ow0KPj4gLQ0KPj4gLQlyZXQgPSBzcGluYW5kX3dhaXQoc3BpbmFuZCwgJnN0YXR1cyk7DQo+PiAt
CWlmICghcmV0ICYmIChzdGF0dXMgJiBTVEFUVVNfRVJBU0VfRkFJTEVEKSkNCj4+IC0JCXJldCA9
IC1FSU87DQo+PiAtDQo+PiAtCXJldHVybiByZXQ7DQo+PiArCXJldHVybiBfX3NwaW5hbmRfZXJh
c2UobmFuZCwgcG9zLCB0cnVlKTsNCj4+ICAgfQ0KPj4gICANCj4+ICAgc3RhdGljIGludCBzcGlu
YW5kX210ZF9lcmFzZShzdHJ1Y3QgbXRkX2luZm8gKm10ZCwNCj4gDQo+IFRoYW5rcywNCj4gTWlx
dcOobA0KPiA=
