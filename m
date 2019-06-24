Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4068950F51
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 16:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfFXO5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 10:57:03 -0400
Received: from skedge03.snt-world.com ([91.208.41.68]:45286 "EHLO
        skedge03.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfFXO5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 10:57:03 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jun 2019 10:57:03 EDT
Received: from sntmail12r.snt-is.com (unknown [10.203.32.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge03.snt-world.com (Postfix) with ESMTPS id 7D8DA67A90A;
        Mon, 24 Jun 2019 16:47:51 +0200 (CEST)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail12r.snt-is.com
 (10.203.32.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 24 Jun
 2019 16:47:50 +0200
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1713.004; Mon, 24 Jun 2019 16:47:50 +0200
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     liaoweixiong <liaoweixiong@allwinnertech.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Frieder Schrempf <frieder.schrempf@exceet.de>,
        Peter Pan <peterpandong@micron.com>,
        "Chuanhong Guo" <gch981213@gmail.com>
CC:     "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
Thread-Topic: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
Thread-Index: AQHVKoaYbYsysfnJPUKsxvje/QcCeKaqwQIA
Date:   Mon, 24 Jun 2019 14:47:50 +0000
Message-ID: <f86e6750-6b4f-daf7-3f0c-1c5e63b5b95d@kontron.de>
References: <1561378534-26119-1-git-send-email-liaoweixiong@allwinnertech.com>
In-Reply-To: <1561378534-26119-1-git-send-email-liaoweixiong@allwinnertech.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FE31BB9AAE8204BAD101611478CAFA2@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 7D8DA67A90A.A00F2
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: bbrezillon@kernel.org, computersforpeace@gmail.com,
        dwmw2@infradead.org, frieder.schrempf@exceet.de, gch981213@gmail.com,
        liaoweixiong@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, marek.vasut@gmail.com,
        miquel.raynal@bootlin.com, peterpandong@micron.com, richard@nod.at,
        stable@vger.kernel.org, vigneshr@ti.com
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMjQuMDYuMTkgMTQ6MTUsIGxpYW93ZWl4aW9uZyB3cm90ZToNCj4gSW4gY2FzZSBvZiB0aGUg
bGFzdCBwYWdlIGNvbnRhaW5pbmcgYml0ZmxpcHMgKHJldCA+IDApLA0KPiBzcGluYW5kX210ZF9y
ZWFkKCkgd2lsbCByZXR1cm4gdGhhdCBudW1iZXIgb2YgYml0ZmxpcHMgZm9yIHRoZSBsYXN0DQo+
IHBhZ2UuIEJ1dCB0byBtZSBpdCBsb29rcyBsaWtlIGl0IHNob3VsZCBpbnN0ZWFkIHJldHVybiBt
YXhfYml0ZmxpcHMgbGlrZQ0KPiBpdCBkb2VzIHdoZW4gdGhlIGxhc3QgcGFnZSByZWFkIHJldHVy
bnMgd2l0aCAwLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogbGlhb3dlaXhpb25nIDxsaWFvd2VpeGlv
bmdAYWxsd2lubmVydGVjaC5jb20+DQo+IEFja2VkLWJ5OiBCb3JpcyBCcmV6aWxsb24gPGJvcmlz
LmJyZXppbGxvbkBjb2xsYWJvcmEuY29tPg0KPiBBY2tlZC1ieTogRnJpZWRlciBTY2hyZW1wZiA8
ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlPg0KDQpXaHkgZGlkIHlvdSBjaGFuZ2Ugb3VyIFJl
dmlld2VkLWJ5IHRhZ3MgdG8gQWNrZWQtYnkgdGFncz8NCg0KPiBGaXhlczogNzUyOWRmNDY1MjQ4
ICgibXRkOiBuYW5kOiBBZGQgY29yZSBpbmZyYXN0cnVjdHVyZSB0byBzdXBwb3J0IFNQSSBOQU5E
cyIpDQo+IC0tLQ0KPiAgIGRyaXZlcnMvbXRkL25hbmQvc3BpL2NvcmUuYyB8IDIgKy0NCj4gICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL210ZC9uYW5kL3NwaS9jb3JlLmMgYi9kcml2ZXJzL210ZC9uYW5kL3Nw
aS9jb3JlLmMNCj4gaW5kZXggNTU2YmZkYi4uNmI5Mzg4ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9tdGQvbmFuZC9zcGkvY29yZS5jDQo+ICsrKyBiL2RyaXZlcnMvbXRkL25hbmQvc3BpL2NvcmUu
Yw0KPiBAQCAtNTExLDEyICs1MTEsMTIgQEAgc3RhdGljIGludCBzcGluYW5kX210ZF9yZWFkKHN0
cnVjdCBtdGRfaW5mbyAqbXRkLCBsb2ZmX3QgZnJvbSwNCj4gICAJCWlmIChyZXQgPT0gLUVCQURN
U0cpIHsNCj4gICAJCQllY2NfZmFpbGVkID0gdHJ1ZTsNCj4gICAJCQltdGQtPmVjY19zdGF0cy5m
YWlsZWQrKzsNCj4gLQkJCXJldCA9IDA7DQo+ICAgCQl9IGVsc2Ugew0KPiAgIAkJCW10ZC0+ZWNj
X3N0YXRzLmNvcnJlY3RlZCArPSByZXQ7DQo+ICAgCQkJbWF4X2JpdGZsaXBzID0gbWF4X3QodW5z
aWduZWQgaW50LCBtYXhfYml0ZmxpcHMsIHJldCk7DQo+ICAgCQl9DQo+ICAgDQo+ICsJCXJldCA9
IDA7DQo+ICAgCQlvcHMtPnJldGxlbiArPSBpdGVyLnJlcS5kYXRhbGVuOw0KPiAgIAkJb3BzLT5v
b2JyZXRsZW4gKz0gaXRlci5yZXEub29ibGVuOw0KPiAgIAl9DQo+IA==
