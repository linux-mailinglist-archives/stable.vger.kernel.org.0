Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823A5175D06
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 15:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCBO2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 09:28:07 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2495 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727053AbgCBO2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 09:28:06 -0500
Received: from lhreml702-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id B68A47C0738F4A9E4DA7;
        Mon,  2 Mar 2020 14:28:04 +0000 (GMT)
Received: from fraeml703-chm.china.huawei.com (10.206.15.52) by
 lhreml702-cah.china.huawei.com (10.201.108.43) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 2 Mar 2020 14:28:04 +0000
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Mon, 2 Mar 2020 15:28:03 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1713.004;
 Mon, 2 Mar 2020 15:28:03 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 2/8] ima: Switch to ima_hash_algo for boot aggregate
Thread-Topic: [PATCH v3 2/8] ima: Switch to ima_hash_algo for boot aggregate
Thread-Index: AQHV3/kpNT3OoKRF00CRxabm/9u1E6gU8McAgADT8jCAH5syAIAAFKYQ
Date:   Mon, 2 Mar 2020 14:28:03 +0000
Message-ID: <8a6fb34e18b147fa811e82c78fb30d66@huawei.com>
References: <20200210100048.21448-1-roberto.sassu@huawei.com>
         <20200210100048.21448-3-roberto.sassu@huawei.com>
         <1581373420.5585.920.camel@linux.ibm.com>
         <6955307747034265bd282bf68c368f34@huawei.com>
 <1583156506.8544.60.camel@linux.ibm.com>
In-Reply-To: <1583156506.8544.60.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.220.96.108]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaW1pIFpvaGFyIFttYWlsdG86
em9oYXJAbGludXguaWJtLmNvbV0NCj4gU2VudDogTW9uZGF5LCBNYXJjaCAyLCAyMDIwIDI6NDIg
UE0NCj4gVG86IFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbT47DQo+IEph
bWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5jb207DQo+IGphcmtrby5zYWtraW5lbkBs
aW51eC5pbnRlbC5jb207IERtaXRyeSBLYXNhdGtpbg0KPiA8ZG1pdHJ5Lmthc2F0a2luQGdtYWls
LmNvbT4NCj4gQ2M6IGxpbnV4LWludGVncml0eUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNlY3Vy
aXR5LW1vZHVsZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IFNpbHZpdSBWbGFzY2VhbnUNCj4gPFNpbHZpdS5WbGFzY2VhbnVAaHVhd2VpLmNvbT47IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MyAyLzhdIGltYTog
U3dpdGNoIHRvIGltYV9oYXNoX2FsZ28gZm9yIGJvb3QNCj4gYWdncmVnYXRlDQo+IA0KPiBPbiBU
dWUsIDIwMjAtMDItMTEgYXQgMTA6MDkgKzAwMDAsIFJvYmVydG8gU2Fzc3Ugd3JvdGU6DQo+ID4g
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiANCj4gUGxlYXNlIGZpbmQvdXNlIGEgbWFp
bGVyIHRoYXQgZG9lc24ndCBpbmNsdWRlIHRoaXMganVuay4NCg0KSSB3aWxsIGRvLiBJIGRpZG4n
dCBoYXZlIHRoZSB0aW1lIHlldC4NCg0KPiA+ID4gT24gTW9uLCAyMDIwLTAyLTEwIGF0IDExOjAw
ICswMTAwLCBSb2JlcnRvIFNhc3N1IHdyb3RlOg0KPiA+ID4gPiBib290X2FnZ3JlZ2F0ZSBpcyB0
aGUgZmlyc3QgZW50cnkgb2YgSU1BIG1lYXN1cmVtZW50IGxpc3QuIEl0cyBwdXJwb3NlDQo+IGlz
DQo+ID4gPiA+IHRvIGxpbmsgcHJlLWJvb3QgbWVhc3VyZW1lbnRzIHRvIElNQSBtZWFzdXJlbWVu
dHMuIEFzIElNQSB3YXMNCj4gPiA+IGRlc2lnbmVkIHRvDQo+ID4gPiA+IHdvcmsgd2l0aCBhIFRQ
TSAxLjIsIHRoZSBTSEExIFBDUiBiYW5rIHdhcyBhbHdheXMgc2VsZWN0ZWQuDQo+ID4gPiA+DQo+
ID4gPiA+IEN1cnJlbnRseSwgZXZlbiBpZiBhIFRQTSAyLjAgaXMgdXNlZCwgdGhlIFNIQTEgUENS
IGJhbmsgaXMgc2VsZWN0ZWQuDQo+ID4gPiA+IEhvd2V2ZXIsIHRoZSBhc3N1bXB0aW9uIHRoYXQg
dGhlIFNIQTEgUENSIGJhbmsgaXMgYWx3YXlzIGF2YWlsYWJsZSBpcw0KPiBub3QNCj4gPiA+ID4g
Y29ycmVjdCwgYXMgUENSIGJhbmtzIGNhbiBiZSBzZWxlY3RlZCB3aXRoIHRoZSBQQ1JfQWxsb2Nh
dGUoKSBUUE0NCj4gPiA+IGNvbW1hbmQuDQo+ID4gPiA+DQo+ID4gPiA+IFRoaXMgcGF0Y2ggdHJp
ZXMgdG8gdXNlIGltYV9oYXNoX2FsZ28gYXMgaGFzaCBhbGdvcml0aG0gZm9yDQo+ID4gPiBib290
X2FnZ3JlZ2F0ZS4NCj4gPiA+ID4gSWYgbm8gUENSIGJhbmsgdXNlcyB0aGF0IGFsZ29yaXRobSwg
dGhlIHBhdGNoIHRyaWVzIHRvIGZpbmQgdGhlIFNIQTI1Ng0KPiBQQ1INCj4gPiA+ID4gYmFuayAo
d2hpY2ggaXMgbWFuZGF0b3J5IGluIHRoZSBUQ0cgUEMgQ2xpZW50IHNwZWNpZmljYXRpb24pLg0K
PiA+ID4NCj4gPiA+IFVwIHRvIGhlcmUsIHRoZSBwYXRjaCBkZXNjcmlwdGlvbiBtYXRjaGVzIHRo
ZSBjb2RlLg0KPiA+ID4gPiBJZiBhbHNvIHRoaXMNCj4gPiA+ID4gYmFuayBpcyBub3QgZm91bmQs
IHRoZSBwYXRjaCBzZWxlY3RzIHRoZSBmaXJzdCBvbmUuIElmIHRoZSBUUE0gYWxnb3JpdGhtDQo+
ID4gPiA+IG9mIHRoYXQgYmFuayBpcyBub3QgbWFwcGVkIHRvIGEgY3J5cHRvIElELCBib290X2Fn
Z3JlZ2F0ZSBpcyBzZXQgdG8NCj4gemVyby4NCj4gPiA+DQo+ID4gPiBUaGlzIGNvbW1lbnQgYW5k
IHRoZSBvbmUgaW5saW5lIGFyZSBsZWZ0IG92ZXIgZnJvbSBwcmV2aW91cyB2ZXJzaW9uLg0KPiA+
DQo+ID4gSGkgTWltaQ0KPiA+DQo+ID4gYWN0dWFsbHkgdGhlIGNvZGUgZG9lcyB3aGF0IGlzIGRl
c2NyaWJlZCBhYm92ZS4gYmFua19pZHggaXMgaW5pdGlhbGx5DQo+ID4gc2V0IHRvIHplcm8gYW5k
IHJlbWFpbnMgYXMgaXQgaXMgaWYgdGhlcmUgaXMgbm8gUENSIGJhbmsgZm9yIHRoZSBkZWZhdWx0
DQo+ID4gSU1BIGFsZ29yaXRobSBvciBTSEEyNTYuDQo+IA0KPiBTb3JyeSBmb3IgdGhlIGRlbGF5
IGluIGNvbnRpbnVpbmcgdG8gcmV2aWV3IHRoaXMgcGF0Y2ggc2V0LiDCoEl0IHRvb2sgYQ0KPiB3
aGlsZSB0byB3cml0ZSBpbWEtZXZtLXV0aWxzIHJlZ3Jlc3Npb24gdGVzdHMgZm9yIGl0Lg0KPiAN
Cj4gRG1pdHJ5IGFuZCB5b3Ugd2VyZSB0aGUgb25lcyB0aGF0IGluaXRpYXRlZCBpbWEtZXZtLXV0
aWxzLCBzYXlpbmcNCj4gdGhlcmUgc2hvdWxkIGEgc2luZ2xlIHBhY2thZ2UgZm9yIHNpZ25pbmcg
ZmlsZXMgYW5kIGludGVncml0eSB0ZXN0aW5nLg0KPiDCoFRoZSBmZWF0dXJlcyBpbiBpbWEtZXZt
LXV0aWxzIHNob3VsZCByZWZsZWN0IHdoYXQgaXMgYWN0dWFsbHkNCj4gdXBzdHJlYW1lZCBpbiB0
aGUga2VybmVsLiDCoChDdXJyZW50bHkgdGhlcmUgYXJlIGEgZmV3IGV4cGVyaW1lbnRhbA0KPiBm
ZWF0dXJlcyB3aGljaCB3ZXJlIG5ldmVyIHVwc3RyZWFtZWQuIMKgSSdkIGxpa2UgdG8gcmVtb3Zl
IHRoZW0sIGJ1dCBhbQ0KPiBhIGJpdCBjb25jZXJuZWQgdGhhdCB0aGV5IGFyZSBiZWluZyB1c2Vk
LikgwqBJJ2QgYXBwcmVjaWF0ZSB5b3VyIGhlbHANCj4gaW4ga2VlcGluZyBpbWEtZXZtLXV0aWxz
IHVwIHRvIGRhdGUuIMKgSXQgd2lsbCBoZWxwIHNpbXBsaWZ5DQo+IHVwc3RyZWFtaW5nIG5ldyBr
ZXJuZWwgZmVhdHVyZXMuDQo+IA0KPiBNeSBpbml0aWFsIHBhdGNoIGF0dGVtcHRlZCB0byB1c2Ug
YW55IGNvbW1vbiBUUE0gYW5kIGtlcm5lbCBoYXNoDQo+IGFsZ29yaXRobSB0byBjYWxjdWxhdGUg
dGhlIGJvb3RfYWdncmVnYXRlLiDCoFRoZSBkaXNjdXNzaW9uIHdpdGggSmFtZXMNCj4gd2FzIHBy
ZXR0eSBjbGVhciwgd2hpY2ggeW91IGV2ZW4gc3RhdGVkIGluIHRoZSBDaGFuZ2Vsb2cuIMKgRWl0
aGVyIHdlDQo+IHVzZSB0aGUgSU1BIGRlZmF1bHQgaGFzaCBhbGdvcml0aG0sIFNIQTI1NiBmb3Ig
VFBNIDIuMCBvciBTSEExIGZvciBUUE0NCj4gMS4yIGZvciB0aGUgYm9vdC1hZ2dyZWdhdGUuDQoN
Ck9rLCBJIGRpZG4ndCB1bmRlcnN0YW5kIGZ1bGx5LiBJIHRob3VnaHQgd2Ugc2hvdWxkIHVzZSB0
aGUgZGVmYXVsdCBJTUENCmFsZ29yaXRobSBhbmQgc2VsZWN0IFNIQTI1NiBhcyBmYWxsYmFjayBj
aG9pY2UgZm9yIFRQTSAyLjAgaWYgdGhlcmUgaXMgbm8NClBDUiBiYW5rIGZvciBkZWZhdWx0IGFs
Z29yaXRobS4gSSBhZGRpdGlvbmFsbHkgaW1wbGVtZW50ZWQgdGhlIGxvZ2ljIHRvDQpzZWxlY3Qg
dGhlIGZpcnN0IFBDUiBiYW5rIGlmIHRoZSBTSEEyNTYgUENSIGJhbmsgaXMgbm90IGF2YWlsYWJs
ZSBidXQgSSBjYW4NCnJlbW92ZSBpdC4NCg0KU0hBMjU2IHNob3VsZCBiZSB0aGUgbWluaW11bSBy
ZXF1aXJlbWVudCBmb3IgYm9vdCBhZ2dyZWdhdGUuIFRoZQ0KYWR2YW50YWdlIG9mIHVzaW5nIHRo
ZSBkZWZhdWx0IElNQSBhbGdvcml0aG0gaXMgdGhhdCBpdCB3aWxsIGJlIHBvc3NpYmxlIHRvDQpz
ZWxlY3Qgc3Ryb25nZXIgYWxnb3JpdGhtcyB3aGVuIHRoZXkgYXJlIHN1cHBvcnRlZCBieSB0aGUg
VFBNLiBXZSBtaWdodA0KaW50cm9kdWNlIGEgbmV3IG9wdGlvbiB0byBzcGVjaWZ5IG9ubHkgdGhl
IGFsZ29yaXRobSBmb3IgYm9vdCBhZ2dyZWdhdGUsDQpsaWtlIEphbWVzIHN1Z2dlc3RlZCB0byBz
dXBwb3J0IGVtYmVkZGVkIHN5c3RlbXMuIExldCBtZSBrbm93IHdoaWNoDQpvcHRpb24geW91IHBy
ZWZlci4NCg0KVGhhbmtzDQoNClJvYmVydG8NCg0KSFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2Vs
ZG9yZiBHbWJILCBIUkIgNTYwNjMNCk1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBMaSBKaWFu
LCBTaGkgWWFubGkNCg==
