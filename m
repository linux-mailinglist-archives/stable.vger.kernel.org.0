Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583603AFD9D
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 09:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhFVHNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 03:13:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7500 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhFVHNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 03:13:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G8HYR1XvTzZlSp;
        Tue, 22 Jun 2021 15:08:27 +0800 (CST)
Received: from dggemm752-chm.china.huawei.com (10.1.198.58) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 15:11:24 +0800
Received: from dggpemm000003.china.huawei.com (7.185.36.128) by
 dggemm752-chm.china.huawei.com (10.1.198.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 15:11:24 +0800
Received: from dggpemm000003.china.huawei.com ([7.185.36.128]) by
 dggpemm000003.china.huawei.com ([7.185.36.128]) with mapi id 15.01.2176.012;
 Tue, 22 Jun 2021 15:11:23 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
CC:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        David Howells <dhowells@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: =?gb2312?B?SnVzdCB0ZXN0IHNlbnQgYnkgbWlzc3Rha2UsIHBsZWFzZSBpZ25vcmUgaXQg?=
 =?gb2312?B?KHNvcnJ5IGZvciB0aGUgZGlzdHVyYikgLy+08Li0OiBbUEFUQ0hdIGFmczog?=
 =?gb2312?B?Zml4IHRyYWNlcG9pbnQgc3RyaW5nIHBsYWNlbWVudCB3aXRoIGJ1aWx0LWlu?=
 =?gb2312?Q?_AFS?=
Thread-Topic: =?gb2312?B?SnVzdCB0ZXN0IHNlbnQgYnkgbWlzc3Rha2UsIHBsZWFzZSBpZ25vcmUgaXQg?=
 =?gb2312?B?KHNvcnJ5IGZvciB0aGUgZGlzdHVyYikgLy+08Li0OiBbUEFUQ0hdIGFmczog?=
 =?gb2312?B?Zml4IHRyYWNlcG9pbnQgc3RyaW5nIHBsYWNlbWVudCB3aXRoIGJ1aWx0LWlu?=
 =?gb2312?Q?_AFS?=
Thread-Index: AddnNcof9UkERf5ySeSSg4cAuxVcPw==
Date:   Tue, 22 Jun 2021 07:11:23 +0000
Message-ID: <951c4518a82f4f2bbbcbc3a62a76ab54@hisilicon.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.69.38.183]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgZ3V5czogDQoNClZlcnkgZm9yIHRoZSBzb3JyeSBmb3IgZGlzdHVyYnMsIHRoaXMgaXMgYSB0
ZXN0IGZvciBsb2NhbCBnaXQgc2VuZCBlbWFpbCBzZXR1cCBhbmQgc2VudCBieSBtaXN0YWtlLiAN
ClBsZWFzZSBpZ25vcmUgdGhpcy4gDQoNClJlZ2FyZHMNClplbmd0YW8gDQoNCj4gLS0tLS3Tyrz+
1K28/i0tLS0tDQo+ILeivP7IyzogWmVuZ3RhbyAoQikNCj4gt6LLzcqxvOQ6IDIwMjHE6jbUwjIy
yNUgMTQ6NTINCj4gytW8/sjLOiBaZW5ndGFvIChCKSA8cHJpbWUuemVuZ0BoaXNpbGljb24uY29t
Pg0KPiCzrcvNOiBBbGV4ZXkgRG9icml5YW4gPGFkb2JyaXlhbkBnbWFpbC5jb20+OyBBbmRpIEts
ZWVuIDxhbmRpQGZpcnN0Zmxvb3Iub3JnPjsNCj4gRGF2aWQgSG93ZWxscyA8ZGhvd2VsbHNAcmVk
aGF0LmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IEFuZHJldyBNb3J0b24NCj4gPGFrcG1A
bGludXgtZm91bmRhdGlvbi5vcmc+OyBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVnLm9y
Zy5hdT4NCj4g1vfM4jogW1BBVENIXSBhZnM6IGZpeCB0cmFjZXBvaW50IHN0cmluZyBwbGFjZW1l
bnQgd2l0aCBidWlsdC1pbiBBRlMNCj4gDQo+IEZyb206IEFsZXhleSBEb2JyaXlhbiA8YWRvYnJp
eWFuQGdtYWlsLmNvbT4NCj4gDQo+IEkgd2FzIGFkZGluZyBjdXN0b20gdHJhY2Vwb2ludCB0byB0
aGUga2VybmVsLCBncmFiYmVkIGZ1bGwgRjM0IGtlcm5lbA0KPiAuY29uZmlnLCBkaXNhYmxlZCBt
b2R1bGVzIGFuZCBib290ZWQgd2hvbGUgc2hlYmFuZyBhcyBWTSBrZXJuZWwuDQo+IA0KPiBUaGVu
IGRpZA0KPiANCj4gCXBlcmYgcmVjb3JkIC1hIC1lIC4uLg0KPiANCj4gSXQgY3Jhc2hlZDoNCj4g
DQo+IAlnZW5lcmFsIHByb3RlY3Rpb24gZmF1bHQsIHByb2JhYmx5IGZvciBub24tY2Fub25pY2Fs
IGFkZHJlc3MNCj4gMHg0MzVmNTM0NjU5MmU0MjQzOiAwMDAwIFsjMV0gU01QIFBUSQ0KPiAJQ1BV
OiAxIFBJRDogODQyIENvbW06IGNhdCBOb3QgdGFpbnRlZCA1LjEyLjYrICMyNg0KPiAJSGFyZHdh
cmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS4x
NC4wLTEuZmMzMw0KPiAwNC8wMS8yMDE0DQo+IAlSSVA6IDAwMTA6dF9zaG93KzB4MjIvMHhkMA0K
PiANCj4gVGhlbiByZXByb2R1Y2VyIHdhcyBuYXJyb3dlZCB0bw0KPiANCj4gCSMgY2F0IC9zeXMv
a2VybmVsL3RyYWNpbmcvcHJpbnRrX2Zvcm1hdHMNCj4gDQo+IE9yaWdpbmFsIEYzNCBrZXJuZWwg
d2l0aCBtb2R1bGVzIGRpZG4ndCBjcmFzaC4NCj4gDQo+IFNvIEkgc3RhcnRlZCB0byBkaXNhYmxl
IG9wdGlvbnMgYW5kIGFmdGVyIGRpc2FibGluZyBBRlMgZXZlcnl0aGluZyBzdGFydGVkDQo+IHdv
cmtpbmcgYWdhaW4uDQo+IA0KPiBUaGUgcm9vdCBjYXVzZSBpcyB0aGF0IEFGUyB3YXMgcGxhY2lu
ZyBjaGFyIGFycmF5cyBjb250ZW50IGludG8gYSBzZWN0aW9uDQo+IGZ1bGwgb2YgX3BvaW50ZXJz
XyB0byBzdHJpbmdzIHdpdGggcHJlZGljdGFibGUgY29uc2VxdWVuY2VzLg0KPiANCj4gTm9uIGNh
bm9uaWNhbCBhZGRyZXNzIDQzNWY1MzQ2NTkyZTQyNDMgaXMgIkNCLllGU18iIHdoaWNoIGNhbWUg
ZnJvbQ0KPiBDTV9OQU1FIG1hY3JvLg0KPiANCj4gVGhlIGZpeCBpcyB0byBjcmVhdGUgY2hhciBh
cnJheSBhbmQgcG9pbnRlciB0byBpdCBzZXBhcmF0ZWRseS4NCj4gDQo+IFN0ZXBzIHRvIHJlcHJv
ZHVjZToNCj4gDQo+IAlDT05GSUdfQUZTPXkNCj4gCUNPTkZJR19UUkFDSU5HPXkNCj4gDQo+IAkj
IGNhdCAvc3lzL2tlcm5lbC90cmFjaW5nL3ByaW50a19mb3JtYXRzDQo+IA0KPiBMaW5rOiBodHRw
czovL2xrbWwua2VybmVsLm9yZy9yL1lMQVhmdlorck9iRU9kYy9AbG9jYWxob3N0LmxvY2FsZG9t
YWluDQo+IEZpeGVzOiA4ZThkN2YxM2I2ZDVhOSAoImFmczogQWRkIHNvbWUgdHJhY2Vwb2ludHMi
KQ0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4ZXkgRG9icml5YW4gKFNLIGh5bml4KSA8YWRvYnJpeWFu
QGdtYWlsLmNvbT4NCj4gQ2M6IEFuZGkgS2xlZW4gPGFuZGlAZmlyc3RmbG9vci5vcmc+DQo+IENj
OiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPg0KPiBDYzogPHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgt
Zm91bmRhdGlvbi5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IFN0ZXBoZW4gUm90aHdlbGwgPHNmckBj
YW5iLmF1dWcub3JnLmF1Pg0KPiAtLS0NCj4gIGZzL2Fmcy9jbXNlcnZpY2UuYyB8IDUgKysrLS0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZnMvYWZzL2Ntc2VydmljZS5jIGIvZnMvYWZzL2Ntc2VydmljZS5jDQo+
IGluZGV4IGQzYzZiYjIyYzVmNC4uZDM5YzYzYjEzZDlmIDEwMDY0NA0KPiAtLS0gYS9mcy9hZnMv
Y21zZXJ2aWNlLmMNCj4gKysrIGIvZnMvYWZzL2Ntc2VydmljZS5jDQo+IEBAIC0zMCw4ICszMCw5
IEBAIHN0YXRpYyB2b2lkIFNSWEFGU0NCX1RlbGxNZUFib3V0WW91cnNlbGYoc3RydWN0DQo+IHdv
cmtfc3RydWN0ICopOw0KPiAgc3RhdGljIGludCBhZnNfZGVsaXZlcl95ZnNfY2JfY2FsbGJhY2so
c3RydWN0IGFmc19jYWxsICopOw0KPiANCj4gICNkZWZpbmUgQ01fTkFNRShuYW1lKSBcDQo+IC0J
Y2hhciBhZnNfU1JYQ0IjI25hbWUjI19uYW1lW10gX190cmFjZXBvaW50X3N0cmluZyA9CVwNCj4g
LQkJIkNCLiIgI25hbWUNCj4gKwljb25zdCBjaGFyIGFmc19TUlhDQiMjbmFtZSMjX25hbWVbXSA9
ICJDQi4iICNuYW1lOwkJXA0KPiArCXN0YXRpYyBjb25zdCBjaGFyICpfYWZzX1NSWENCIyNuYW1l
IyNfbmFtZSBfX3RyYWNlcG9pbnRfc3RyaW5nID1cDQo+ICsJCWFmc19TUlhDQiMjbmFtZSMjX25h
bWUNCj4gDQo+ICAvKg0KPiAgICogQ0IuQ2FsbEJhY2sgb3BlcmF0aW9uIHR5cGUNCj4gLS0NCj4g
Mi4zMC4wDQoNCg==
