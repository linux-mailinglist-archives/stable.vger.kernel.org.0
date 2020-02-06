Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4AC154404
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 13:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBFM2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 07:28:21 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2387 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726744AbgBFM2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 07:28:21 -0500
Received: from LHREML710-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 48935563F0E88C196A82;
        Thu,  6 Feb 2020 12:28:19 +0000 (GMT)
Received: from fraeml703-chm.china.huawei.com (10.206.15.52) by
 LHREML710-CAH.china.huawei.com (10.201.108.33) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 6 Feb 2020 12:28:18 +0000
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 6 Feb 2020 13:28:18 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1713.004;
 Thu, 6 Feb 2020 13:28:18 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 2/8] ima: Switch to ima_hash_algo for boot aggregate
Thread-Topic: [PATCH v2 2/8] ima: Switch to ima_hash_algo for boot aggregate
Thread-Index: AQHV3A/jJwoPNNxgYk6BJdeHa69IC6gNBbgAgADjWLCAABy9AIAAEWug
Date:   Thu, 6 Feb 2020 12:28:18 +0000
Message-ID: <17bfd3e2b7fa4f31a46a6688e4a6e34f@huawei.com>
References: <20200205103317.29356-1-roberto.sassu@huawei.com>
         <20200205103317.29356-3-roberto.sassu@huawei.com>
         <1580936432.5585.309.camel@linux.ibm.com>
         <b1507c1121b64b3abc00e154fcfeef65@huawei.com>
 <1580991426.5585.334.camel@linux.ibm.com>
In-Reply-To: <1580991426.5585.334.camel@linux.ibm.com>
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
em9oYXJAbGludXguaWJtLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDYsIDIwMjAg
MToxNyBQTQ0KPiBUbzogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPjsN
Cj4gSmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbTsNCj4gamFya2tvLnNha2tp
bmVuQGxpbnV4LmludGVsLmNvbQ0KPiBDYzogbGludXgtaW50ZWdyaXR5QHZnZXIua2VybmVsLm9y
ZzsgbGludXgtc2VjdXJpdHktbW9kdWxlQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZzsgU2lsdml1IFZsYXNjZWFudQ0KPiA8U2lsdml1LlZsYXNjZWFudUBo
dWF3ZWkuY29tPjsgc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IHYyIDIvOF0gaW1hOiBTd2l0Y2ggdG8gaW1hX2hhc2hfYWxnbyBmb3IgYm9vdA0KPiBhZ2dyZWdh
dGUNCj4gDQo+IE9uIFRodSwgMjAyMC0wMi0wNiBhdCAwOTozNiArMDAwMCwgUm9iZXJ0byBTYXNz
dSB3cm90ZToNCj4gPiA+IEhpIFJvYmVydG8sDQo+ID4gPg0KPiA+ID4gT24gV2VkLCAyMDIwLTAy
LTA1IGF0IDExOjMzICswMTAwLCBSb2JlcnRvIFNhc3N1IHdyb3RlOg0KPiA+ID4NCj4gPiA+IDxz
bmlwPg0KPiA+ID4NCj4gPiA+ID4gUmVwb3J0ZWQtYnk6IEplcnJ5IFNuaXRzZWxhYXIgPGpzbml0
c2VsQHJlZGhhdC5jb20+DQo+ID4gPiA+IFN1Z2dlc3RlZC1ieTogSmFtZXMgQm90dG9tbGV5DQo+
ID4gPiA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT4NCj4gPiA+ID4gU2ln
bmVkLW9mZi1ieTogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiA+
ID4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+ID4NCj4gPiA+IENjJ2luZyBzdGFi
bGUgcmVzdWx0ZWQgaW4gU2FzaGEncyBhdXRvbWF0ZWQgbWVzc2FnZS7CoMKgSWYgeW91J3JlIGdv
aW5nDQo+ID4gPiB0byBDYyBzdGFibGUsIHRoZW4gcGxlYXNlIGluY2x1ZGUgdGhlIHN0YWJsZSBr
ZXJuZWwgcmVsZWFzZSAoZS5nLiBDYzoNCj4gPiA+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2
NS4zKS4gwqBBbHNvIHBsZWFzZSBpbmNsdWRlIGEgIkZpeGVzIiB0YWcuDQo+ID4gPiDCoE5vcm1h
bGx5IG9ubHkgYnVnIGZpeGVzIGFyZSBiYWNrcG9ydGVkLg0KPiA+DQo+ID4gT2ssIHdpbGwgYWRk
IHRoZSBrZXJuZWwgdmVyc2lvbi4gSSBhbHNvIHRob3VnaHQgd2hpY2ggY29tbWl0IEkgc2hvdWxk
DQo+ID4gbWVudGlvbiBpbiB0aGUgRml4ZXMgdGFnLiBJTUEgYWx3YXlzIHJlYWQgdGhlIFNIQTEg
YmFuayBmcm9tIHRoZQ0KPiA+IGJlZ2lubmluZy4gSSBjb3VsZCBtZW50aW9uIHRoZSBwYXRjaCB0
aGF0IGludHJvZHVjZXMgdGhlIG5ldyBBUEkNCj4gPiB0byByZWFkIG90aGVyIGJhbmtzLCBidXQg
SSdtIG5vdCBzdXJlLiBXaGF0IGRvIHlvdSB0aGluaz8NCj4gDQo+IFRoaXMgcGF0Y2ggaXMgZGVw
ZW5kZW50IG9uIG5yX2FsbG9jYXRlZF9iYW5rcy4gwqBQbGVhc2UgdHJ5IGFwcGx5aW5nDQo+IHRo
aXMgcGF0Y2ggdG8gdGhlIGVhcmxpZXN0IHN0YWJsZSBrZXJuZWwgd2l0aCB0aGUgY29tbWl0IHRo
YXQNCj4gaW50cm9kdWNlcyBucl9hbGxvY2F0ZWRfYmFua3MgYW5kIHRlc3QgdG8gbWFrZSBzdXJl
IGl0IHdvcmtzIHByb3Blcmx5Lg0KDQpJdCBhbHNvIGRlcGVuZHMgb24gODc5YjU4OTIxMGE5ICgi
dHBtOiByZXRyaWV2ZSBkaWdlc3Qgc2l6ZSBvZiB1bmtub3duIg0KYWxnb3JpdGhtcyB3aXRoIFBD
UiByZWFkIikgd2hpY2ggZXhwb3J0ZWQgdGhlIG1hcHBpbmcgYmV0d2VlbiBUUE0NCmFsZ29yaXRo
bSBJRCBhbmQgY3J5cHRvIElELCBhbmQgY2hhbmdlZCB0aGUgZGVmaW5pdGlvbiBvZiB0cG1fcGNy
X3JlYWQoKQ0KdG8gcmVhZCBub24tU0hBMSBQQ1IgYmFua3MuIEl0IHJlcXVpcmVzIG1hbnkgcGF0
Y2hlcywgc28gYmFja3BvcnRpbmcgaXQNCmlzIG5vdCBhIHRyaXZpYWwgdGFzay4gSSB0aGluayB0
aGUgZWFybGllc3Qga2VybmVsIHRoaXMgcGF0Y2ggY2FuIGJlIGJhY2twb3J0ZWQgdG8NCmlzIDUu
MS4NCg0KUm9iZXJ0bw0K
