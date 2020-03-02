Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8718D175DF1
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 16:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCBPLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 10:11:44 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2497 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726621AbgCBPLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 10:11:44 -0500
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id A2C0C91186757F875EB4;
        Mon,  2 Mar 2020 15:11:42 +0000 (GMT)
Received: from fraeml704-chm.china.huawei.com (10.206.15.53) by
 LHREML712-CAH.china.huawei.com (10.201.108.35) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 2 Mar 2020 15:11:42 +0000
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Mon, 2 Mar 2020 16:11:41 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1713.004;
 Mon, 2 Mar 2020 16:11:42 +0100
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
Thread-Index: AQHV3/kpNT3OoKRF00CRxabm/9u1E6gU8McAgADT8jCAH5syAIAAFKYQ///9dQCAABQMwA==
Date:   Mon, 2 Mar 2020 15:11:41 +0000
Message-ID: <a5e0cdc4839e478d926b90bd5ba0857c@huawei.com>
References: <20200210100048.21448-1-roberto.sassu@huawei.com>
         <20200210100048.21448-3-roberto.sassu@huawei.com>
         <1581373420.5585.920.camel@linux.ibm.com>
         <6955307747034265bd282bf68c368f34@huawei.com>
         <1583156506.8544.60.camel@linux.ibm.com>
         <8a6fb34e18b147fa811e82c78fb30d66@huawei.com>
 <1583160394.8544.89.camel@linux.ibm.com>
In-Reply-To: <1583160394.8544.89.camel@linux.ibm.com>
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
em9oYXJAbGludXguaWJtLmNvbV0NCj4gU2VudDogTW9uZGF5LCBNYXJjaCAyLCAyMDIwIDM6NDcg
UE0NCj4gVG86IFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbT47DQo+IEph
bWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5jb207DQo+IGphcmtrby5zYWtraW5lbkBs
aW51eC5pbnRlbC5jb207IERtaXRyeSBLYXNhdGtpbg0KPiA8ZG1pdHJ5Lmthc2F0a2luQGdtYWls
LmNvbT4NCj4gQ2M6IGxpbnV4LWludGVncml0eUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNlY3Vy
aXR5LW1vZHVsZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IFNpbHZpdSBWbGFzY2VhbnUNCj4gPFNpbHZpdS5WbGFzY2VhbnVAaHVhd2VpLmNvbT47IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MyAyLzhdIGltYTog
U3dpdGNoIHRvIGltYV9oYXNoX2FsZ28gZm9yIGJvb3QNCj4gYWdncmVnYXRlDQo+IA0KPiANCj4g
PiA+ID4gPiBPbiBNb24sIDIwMjAtMDItMTAgYXQgMTE6MDAgKzAxMDAsIFJvYmVydG8gU2Fzc3Ug
d3JvdGU6DQo+ID4gPiBNeSBpbml0aWFsIHBhdGNoIGF0dGVtcHRlZCB0byB1c2UgYW55IGNvbW1v
biBUUE0gYW5kIGtlcm5lbCBoYXNoDQo+ID4gPiBhbGdvcml0aG0gdG8gY2FsY3VsYXRlIHRoZSBi
b290X2FnZ3JlZ2F0ZS4gwqBUaGUgZGlzY3Vzc2lvbiB3aXRoIEphbWVzDQo+ID4gPiB3YXMgcHJl
dHR5IGNsZWFyLCB3aGljaCB5b3UgZXZlbiBzdGF0ZWQgaW4gdGhlIENoYW5nZWxvZy4gwqBFaXRo
ZXIgd2UNCj4gPiA+IHVzZSB0aGUgSU1BIGRlZmF1bHQgaGFzaCBhbGdvcml0aG0sIFNIQTI1NiBm
b3IgVFBNIDIuMCBvciBTSEExIGZvcg0KPiBUUE0NCj4gPiA+IDEuMiBmb3IgdGhlIGJvb3QtYWdn
cmVnYXRlLg0KPiA+DQo+ID4gT2ssIEkgZGlkbid0IHVuZGVyc3RhbmQgZnVsbHkuIEkgdGhvdWdo
dCB3ZSBzaG91bGQgdXNlIHRoZSBkZWZhdWx0IElNQQ0KPiA+IGFsZ29yaXRobSBhbmQgc2VsZWN0
IFNIQTI1NiBhcyBmYWxsYmFjayBjaG9pY2UgZm9yIFRQTSAyLjAgaWYgdGhlcmUgaXMgbm8NCj4g
PiBQQ1IgYmFuayBmb3IgZGVmYXVsdCBhbGdvcml0aG0uDQo+IA0KPiBZZXMsIHByZWZlcmVuY2Ug
aXMgZ2l2ZW4gdG8gdGhlIElNQSBkZWZhdWx0IGFsZ29yaXRobSwgYnV0IGl0IHNob3VsZA0KPiBm
YWxsIGJhY2sgdG8gdXNpbmcgU0hBMjU2IG9yIFNIQTEsIGJhc2VkIG9uIHRoZSBUUE0uDQoNCk9r
LiBUaGUgcGF0Y2ggYWxyZWFkeSBkb2VzIGl0IGV2ZW4gaWYgdGhlIFRQTSB2ZXJzaW9uIGlzIG5v
dCBjaGVja2VkLg0KRm9yIFRQTSAxLjIsIGlmIHRoZSBkZWZhdWx0IGFsZ29yaXRobSBpcyBub3Qg
U0hBMSB0aGUgcGF0Y2ggd2lsbCBzZWxlY3QNCnRoZSBmaXJzdCBQQ1IgYmFuayAoU0hBMSkuDQoN
ClNob3VsZCBJIHNlbmQgYSBuZXcgcGF0Y2ggd2hpY2ggZXhwbGljaXRseSBjaGVja3MgdGhlIFRQ
TSB2ZXJzaW9uPw0KDQo+ID4gSSBhZGRpdGlvbmFsbHkgaW1wbGVtZW50ZWQgdGhlIGxvZ2ljIHRv
DQo+ID4gc2VsZWN0IHRoZSBmaXJzdCBQQ1IgYmFuayBpZiB0aGUgU0hBMjU2IFBDUiBiYW5rIGlz
IG5vdCBhdmFpbGFibGUgYnV0IEkgY2FuDQo+ID4gcmVtb3ZlIGl0Lg0KPiA+DQo+ID4gU0hBMjU2
IHNob3VsZCBiZSB0aGUgbWluaW11bSByZXF1aXJlbWVudCBmb3IgYm9vdCBhZ2dyZWdhdGUuIFRo
ZQ0KPiA+IGFkdmFudGFnZSBvZiB1c2luZyB0aGUgZGVmYXVsdCBJTUEgYWxnb3JpdGhtIGlzIHRo
YXQgaXQgd2lsbCBiZSBwb3NzaWJsZSB0bw0KPiA+IHNlbGVjdCBzdHJvbmdlciBhbGdvcml0aG1z
IHdoZW4gdGhleSBhcmUgc3VwcG9ydGVkIGJ5IHRoZSBUUE0uIFdlDQo+IG1pZ2h0DQo+ID4gaW50
cm9kdWNlIGEgbmV3IG9wdGlvbiB0byBzcGVjaWZ5IG9ubHkgdGhlIGFsZ29yaXRobSBmb3IgYm9v
dCBhZ2dyZWdhdGUsDQo+ID4gbGlrZSBKYW1lcyBzdWdnZXN0ZWQgdG8gc3VwcG9ydCBlbWJlZGRl
ZCBzeXN0ZW1zLiBMZXQgbWUga25vdyB3aGljaA0KPiA+IG9wdGlvbiB5b3UgcHJlZmVyLg0KPiAN
Cj4gSSBkb24ndCByZW1lbWJlciBKYW1lcyBzYXlpbmcgdGhhdCwgYnV0IGlmIHRoZSBjb21tdW5p
dHkgcmVhbGx5IHdhbnRzDQo+IHRoYXQgc3VwcG9ydCwgdGhlbiBpdCBzaG91bGQgYmUgdXBzdHJl
YW1lZCBpbmRlcGVuZGVudGx5LCBhcyBhDQo+IHNlcGFyYXRlIHBhdGNoLiDCoExldCdzIGZpcnN0
IGdldCB0aGUgYmFzaWNzIHdvcmtpbmcuDQoNCk9rLg0KDQpUaGFua3MNCg0KUm9iZXJ0bw0KDQpI
VUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2Mw0KTWFuYWdpbmcg
RGlyZWN0b3I6IExpIFBlbmcsIExpIEppYW4sIFNoaSBZYW5saQ0K
