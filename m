Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3C0163AEB
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 04:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgBSDQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 22:16:34 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:29717 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgBSDQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 22:16:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582082193; x=1613618193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E5N/7o6VGZBa7BVMDB3WxPy4rXL39R8UjJoASxTcpwI=;
  b=D4CHQbjMEvc2gloE9BViuPlyFRg+EyufVvy2YSmCf5G+XePNZy/grwGR
   RB9qMi134VS9cjA0D5lNT9GcvNzy3twcC2RCd3EvMDmOWg5lzIrd8wa/k
   UADalIPrS4DWof1RY6cWE/z/it3rSFExg6L5vusDWgZRgvkH3/c0qNtUH
   U=;
IronPort-SDR: nPGXDLSlq1mgpB0ur0SHuDd4GWdYk2MTS3/Xd9ybZfESAZUt/hp1VWZzaP4wcIpIfB8EPJ9OGb
 GZDeqCULsGAg==
X-IronPort-AV: E=Sophos;i="5.70,458,1574121600"; 
   d="scan'208";a="16987779"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Feb 2020 03:16:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id CF97EA27EF;
        Wed, 19 Feb 2020 03:16:31 +0000 (UTC)
Received: from EX13D01UWB004.ant.amazon.com (10.43.161.157) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 03:16:31 +0000
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13d01UWB004.ant.amazon.com (10.43.161.157) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Feb 2020 03:16:30 +0000
Received: from EX13D30UWC001.ant.amazon.com ([10.43.162.128]) by
 EX13D30UWC001.ant.amazon.com ([10.43.162.128]) with mapi id 15.00.1367.000;
 Wed, 19 Feb 2020 03:16:30 +0000
From:   "Jitindar SIngh, Suraj" <surajjs@amazon.com>
To:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "Singh, Balbir" <sblbir@amazon.com>
Subject: Re: [PATCH 1/3] ext4: introduce macro sbi_array_rcu_deref() to access
 rcu protected fields
Thread-Topic: [PATCH 1/3] ext4: introduce macro sbi_array_rcu_deref() to
 access rcu protected fields
Thread-Index: AQHV5tIfD/jLG261uU+fJ5kjcslyZ6gh2FEA
Date:   Wed, 19 Feb 2020 03:16:30 +0000
Message-ID: <6db70858fc2e9792cff585650891f5f9896cf28a.camel@amazon.com>
References: <20200219030851.2678-1-surajjs@amazon.com>
         <20200219030851.2678-2-surajjs@amazon.com>
In-Reply-To: <20200219030851.2678-2-surajjs@amazon.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1C1F5BBF8C56C4B9BAF1FC68098AFDF@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

K0NjIHN0YWJsZQ0KKGNvcnJlY3RseSB0aGlzIHRpbWUpDQoNCk9uIFR1ZSwgMjAyMC0wMi0xOCBh
dCAxOTowOCAtMDgwMCwgU3VyYWogSml0aW5kYXIgU2luZ2ggd3JvdGU6DQo+IFRoZSBzX2dyb3Vw
X2Rlc2MgZmllbGQgaW4gdGhlIHN1cGVyIGJsb2NrIGluZm8gKHNiaSkgaXMgcHJvdGVjdGVkIGJ5
DQo+IHJjdSB0bw0KPiBwcmV2ZW50IGFjY2VzcyB0byBhbiBpbnZhbGlkIHBvaW50ZXIgZHVyaW5n
IG9ubGluZSByZXNpemUgb3BlcmF0aW9ucy4NCj4gVGhlcmUgYXJlIDIgb3RoZXIgYXJyYXlzIGlu
IHNiaSwgc19ncm91cF9pbmZvIGFuZCBzX2ZsZXhfZ3JvdXBzLA0KPiB3aGljaA0KPiByZXF1aXJl
IHNpbWlsYXIgcmN1IHByb3RlY3Rpb24gd2hpY2ggaXMgaW50cm9kdWNlZCBpbiB0aGUgc3Vic2Vx
dWVudA0KPiBwYXRjaGVzLiBJbnRyb2R1Y2UgYSBoZWxwZXIgbWFjcm8gc2JpX2FycmF5X3JjdV9k
ZXJlZigpIHRvIGJlIHVzZWQgdG8NCj4gcHJvdmlkZSByY3UgcHJvdGVjdGVkIGFjY2VzcyB0byBz
dWNoIGZpZWxkcy4NCj4gDQo+IEFsc28gdXBkYXRlIHRoZSBjdXJyZW50IHNfZ3JvdXBfZGVzYyBh
Y2Nlc3Mgc2l0ZSB0byB1c2UgdGhlIG1hY3JvLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU3VyYWog
Sml0aW5kYXIgU2luZ2ggPHN1cmFqanNAYW1hem9uLmNvbT4NCkNjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnDQo+IENjOiBzdGFibGVAdmdlci1rZXJuZWwub3JnDQo+IC0tLQ0KPiAgZnMvZXh0NC9i
YWxsb2MuYyB8IDExICsrKysrLS0tLS0tDQo+ICBmcy9leHQ0L2V4dDQuaCAgIHwgMTcgKysrKysr
KysrKysrKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgNiBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9leHQ0L2JhbGxvYy5jIGIvZnMvZXh0NC9i
YWxsb2MuYw0KPiBpbmRleCA1MzY4YmY2NzMwMGIuLjhmZDBiM2NkYWI0YyAxMDA2NDQNCj4gLS0t
IGEvZnMvZXh0NC9iYWxsb2MuYw0KPiArKysgYi9mcy9leHQ0L2JhbGxvYy5jDQo+IEBAIC0yODEs
MTQgKzI4MSwxMyBAQCBzdHJ1Y3QgZXh0NF9ncm91cF9kZXNjICoNCj4gZXh0NF9nZXRfZ3JvdXBf
ZGVzYyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLA0KPiAgDQo+ICAJZ3JvdXBfZGVzYyA9IGJsb2Nr
X2dyb3VwID4+IEVYVDRfREVTQ19QRVJfQkxPQ0tfQklUUyhzYik7DQo+ICAJb2Zmc2V0ID0gYmxv
Y2tfZ3JvdXAgJiAoRVhUNF9ERVNDX1BFUl9CTE9DSyhzYikgLSAxKTsNCj4gLQlyY3VfcmVhZF9s
b2NrKCk7DQo+IC0JYmhfcCA9IHJjdV9kZXJlZmVyZW5jZShzYmktPnNfZ3JvdXBfZGVzYylbZ3Jv
dXBfZGVzY107DQo+ICsJYmhfcCA9IHNiaV9hcnJheV9yY3VfZGVyZWYoc2JpLCBzX2dyb3VwX2Rl
c2MsIGdyb3VwX2Rlc2MpOw0KPiAgCS8qDQo+IC0JICogV2UgY2FuIHVubG9jayBoZXJlIHNpbmNl
IHRoZSBwb2ludGVyIGJlaW5nIGRlcmVmZXJlbmNlZA0KPiB3b24ndCBiZQ0KPiAtCSAqIGRlcmVm
ZXJlbmNlZCBhZ2Fpbi4gQnkgbG9va2luZyBhdCB0aGUgdXNhZ2UgaW4gYWRkX25ld19nZGIoKQ0K
PiB0aGUNCj4gLQkgKiB2YWx1ZSBpc24ndCBtb2RpZmllZCwganVzdCB0aGUgcG9pbnRlciwgYW5k
IHNvIGl0IHJlbWFpbnMNCj4gdmFsaWQuDQo+ICsJICogc2JpX2FycmF5X3JjdV9kZXJlZiByZXR1
cm5zIHdpdGggcmN1IHVubG9ja2VkLCB0aGlzIGlzIG9rDQo+IHNpbmNlDQo+ICsJICogdGhlIHBv
aW50ZXIgYmVpbmcgZGVyZWZlcmVuY2VkIHdvbid0IGJlIGRlcmVmZXJlbmNlZCBhZ2Fpbi4NCj4g
QnkNCj4gKwkgKiBsb29raW5nIGF0IHRoZSB1c2FnZSBpbiBhZGRfbmV3X2dkYigpIHRoZSB2YWx1
ZSBpc24ndA0KPiBtb2RpZmllZCwNCj4gKwkgKiBqdXN0IHRoZSBwb2ludGVyLCBhbmQgc28gaXQg
cmVtYWlucyB2YWxpZC4NCj4gIAkgKi8NCj4gLQlyY3VfcmVhZF91bmxvY2soKTsNCj4gIAlpZiAo
IWJoX3ApIHsNCj4gIAkJZXh0NF9lcnJvcihzYiwgIkdyb3VwIGRlc2NyaXB0b3Igbm90IGxvYWRl
ZCAtICINCj4gIAkJCSAgICJibG9ja19ncm91cCA9ICV1LCBncm91cF9kZXNjID0gJXUsIGRlc2Mg
PQ0KPiAldSIsDQo+IGRpZmYgLS1naXQgYS9mcy9leHQ0L2V4dDQuaCBiL2ZzL2V4dDQvZXh0NC5o
DQo+IGluZGV4IDE0OWVlMGFiNmQ2NC4uMjM2ZmM2NTAwMzQwIDEwMDY0NA0KPiAtLS0gYS9mcy9l
eHQ0L2V4dDQuaA0KPiArKysgYi9mcy9leHQ0L2V4dDQuaA0KPiBAQCAtMTU3Niw2ICsxNTc2LDIz
IEBAIHN0YXRpYyBpbmxpbmUgaW50IGV4dDRfdmFsaWRfaW51bShzdHJ1Y3QNCj4gc3VwZXJfYmxv
Y2sgKnNiLCB1bnNpZ25lZCBsb25nIGlubykNCj4gIAkJIGlubyA8PSBsZTMyX3RvX2NwdShFWFQ0
X1NCKHNiKS0+c19lcy0NCj4gPnNfaW5vZGVzX2NvdW50KSk7DQo+ICB9DQo+ICANCj4gKy8qDQo+
ICsgKiBSZXR1cm5zOiBzYmktPmZpZWxkW2luZGV4XQ0KPiArICogVXNlZCB0byBhY2Nlc3MgYW4g
YXJyYXkgZWxlbWVudCBmcm9tIHRoZSBmb2xsb3dpbmcgc2JpIGZpZWxkcw0KPiB3aGljaCByZXF1
aXJlDQo+ICsgKiByY3UgcHJvdGVjdGlvbiB0byBhdm9pZCBkZXJlZmVyZW5jaW5nIGFuIGludmFs
aWQgcG9pbnRlciBkdWUgdG8NCj4gcmVhc3NpZ25tZW50DQo+ICsgKiAtIHNfZ3JvdXBfZGVzYw0K
PiArICogLSBzX2dyb3VwX2luZm8NCj4gKyAqIC0gc19mbGV4X2dyb3VwDQo+ICsgKi8NCj4gKyNk
ZWZpbmUgc2JpX2FycmF5X3JjdV9kZXJlZihzYmksIGZpZWxkLCBpbmRleCkJCQkNCj4gCSAgIFwN
Cj4gKyh7CQkJCQkJCQkJDQo+ICAgIFwNCj4gKwl0eXBlb2YoKigoc2JpKS0+ZmllbGQpKSBfdjsJ
CQkJCQ0KPiAgICBcDQo+ICsJcmN1X3JlYWRfbG9jaygpOwkJCQkJCSAgIFwNCj4gKwlfdiA9ICgo
dHlwZW9mKChzYmkpLT5maWVsZCkpcmN1X2RlcmVmZXJlbmNlKChzYmkpLQ0KPiA+ZmllbGQpKVtp
bmRleF07IFwNCj4gKwlyY3VfcmVhZF91bmxvY2soKTsJCQkJCQkNCj4gICAgXA0KPiArCV92OwkJ
CQkJCQkJDQo+ICAgIFwNCj4gK30pDQo+ICsNCj4gIC8qDQo+ICAgKiBTaW11bGF0ZV9mYWlsIGNv
ZGVzDQo+ICAgKi8NCg==
