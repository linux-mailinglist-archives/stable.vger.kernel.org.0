Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F20115413E
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 10:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgBFJgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 04:36:42 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2384 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727111AbgBFJgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 04:36:42 -0500
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 16BF4F96700A143FF421;
        Thu,  6 Feb 2020 09:36:41 +0000 (GMT)
Received: from fraeml702-chm.china.huawei.com (10.206.15.51) by
 LHREML712-CAH.china.huawei.com (10.201.108.35) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 6 Feb 2020 09:36:41 +0000
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 6 Feb 2020 10:36:40 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1713.004;
 Thu, 6 Feb 2020 10:36:40 +0100
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
Thread-Index: AQHV3A/jJwoPNNxgYk6BJdeHa69IC6gNBbgAgADjWLA=
Date:   Thu, 6 Feb 2020 09:36:40 +0000
Message-ID: <b1507c1121b64b3abc00e154fcfeef65@huawei.com>
References: <20200205103317.29356-1-roberto.sassu@huawei.com>
         <20200205103317.29356-3-roberto.sassu@huawei.com>
 <1580936432.5585.309.camel@linux.ibm.com>
In-Reply-To: <1580936432.5585.309.camel@linux.ibm.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBvd25lci1saW51eC1zZWN1cml0
eS1tb2R1bGVAdmdlci5rZXJuZWwub3JnIFttYWlsdG86b3duZXItbGludXgtDQo+IHNlY3VyaXR5
LW1vZHVsZUB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBNaW1pIFpvaGFyDQo+IFNlbnQ6
IFdlZG5lc2RheSwgRmVicnVhcnkgNSwgMjAyMCAxMDowMSBQTQ0KPiBUbzogUm9iZXJ0byBTYXNz
dSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPjsNCj4gSmFtZXMuQm90dG9tbGV5QEhhbnNlblBh
cnRuZXJzaGlwLmNvbTsNCj4gamFya2tvLnNha2tpbmVuQGxpbnV4LmludGVsLmNvbQ0KPiBDYzog
bGludXgtaW50ZWdyaXR5QHZnZXIua2VybmVsLm9yZzsgbGludXgtc2VjdXJpdHktbW9kdWxlQHZn
ZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgU2lsdml1IFZs
YXNjZWFudQ0KPiA8U2lsdml1LlZsYXNjZWFudUBodWF3ZWkuY29tPjsgc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDIvOF0gaW1hOiBTd2l0Y2ggdG8gaW1h
X2hhc2hfYWxnbyBmb3IgYm9vdA0KPiBhZ2dyZWdhdGUNCj4gDQo+IEhpIFJvYmVydG8sDQo+IA0K
PiBPbiBXZWQsIDIwMjAtMDItMDUgYXQgMTE6MzMgKzAxMDAsIFJvYmVydG8gU2Fzc3Ugd3JvdGU6
DQo+IA0KPiA8c25pcD4NCj4gDQo+ID4gUmVwb3J0ZWQtYnk6IEplcnJ5IFNuaXRzZWxhYXIgPGpz
bml0c2VsQHJlZGhhdC5jb20+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBKYW1lcyBCb3R0b21sZXkNCj4g
PEphbWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiA+IENjOiBzdGFi
bGVAdmdlci5rZXJuZWwub3JnDQo+IA0KPiBDYydpbmcgc3RhYmxlIHJlc3VsdGVkIGluIFNhc2hh
J3MgYXV0b21hdGVkIG1lc3NhZ2UuwqDCoElmIHlvdSdyZSBnb2luZw0KPiB0byBDYyBzdGFibGUs
IHRoZW4gcGxlYXNlIGluY2x1ZGUgdGhlIHN0YWJsZSBrZXJuZWwgcmVsZWFzZSAoZS5nLiBDYzoN
Cj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY1LjMpLiDCoEFsc28gcGxlYXNlIGluY2x1ZGUg
YSAiRml4ZXMiIHRhZy4NCj4gwqBOb3JtYWxseSBvbmx5IGJ1ZyBmaXhlcyBhcmUgYmFja3BvcnRl
ZC4NCg0KT2ssIHdpbGwgYWRkIHRoZSBrZXJuZWwgdmVyc2lvbi4gSSBhbHNvIHRob3VnaHQgd2hp
Y2ggY29tbWl0IEkgc2hvdWxkDQptZW50aW9uIGluIHRoZSBGaXhlcyB0YWcuIElNQSBhbHdheXMg
cmVhZCB0aGUgU0hBMSBiYW5rIGZyb20gdGhlDQpiZWdpbm5pbmcuIEkgY291bGQgbWVudGlvbiB0
aGUgcGF0Y2ggdGhhdCBpbnRyb2R1Y2VzIHRoZSBuZXcgQVBJDQp0byByZWFkIG90aGVyIGJhbmtz
LCBidXQgSSdtIG5vdCBzdXJlLiBXaGF0IGRvIHlvdSB0aGluaz8NCg0KVGhhbmtzDQoNClJvYmVy
dG8NCg==
