Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1629523E6
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 09:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfFYHET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 03:04:19 -0400
Received: from skedge04.snt-world.com ([91.208.41.69]:47050 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729705AbfFYHEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 03:04:15 -0400
Received: from sntmail12r.snt-is.com (unknown [10.203.32.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 4605767A7D4;
        Tue, 25 Jun 2019 09:04:07 +0200 (CEST)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail12r.snt-is.com
 (10.203.32.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 25 Jun
 2019 09:04:06 +0200
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1713.004; Tue, 25 Jun 2019 09:04:06 +0200
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     liaoweixiong <liaoweixiong@allwinnertech.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        "Richard Weinberger" <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuanhong Guo <gch981213@gmail.com>,
        "Marek Vasut" <marek.vasut@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
Thread-Topic: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
Thread-Index: AQHVKvG5vIRdXk03g0+SrXGJtaID9aarjwGAgABB7wA=
Date:   Tue, 25 Jun 2019 07:04:06 +0000
Message-ID: <97adf58f-4771-90f1-bdaf-5a9d00eef768@kontron.de>
References: <1561424549-784-1-git-send-email-liaoweixiong@allwinnertech.com>
 <20190625030807.GA11074@kroah.com>
In-Reply-To: <20190625030807.GA11074@kroah.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <82C2E515EE53D0458A0A48579DDDDAF9@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 4605767A7D4.ADE8A
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: bbrezillon@kernel.org, computersforpeace@gmail.com,
        dwmw2@infradead.org, gch981213@gmail.com, gregkh@linuxfoundation.org,
        liaoweixiong@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, marek.vasut@gmail.com,
        miquel.raynal@bootlin.com, richard@nod.at, stable@vger.kernel.org,
        vigneshr@ti.com
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgbGlhb3dlaXhpb25nLA0KDQpPbiAyNS4wNi4xOSAwNTowOCwgR3JlZyBLSCB3cm90ZToNCj4g
T24gVHVlLCBKdW4gMjUsIDIwMTkgYXQgMDk6MDI6MjlBTSArMDgwMCwgbGlhb3dlaXhpb25nIHdy
b3RlOg0KPj4gSW4gY2FzZSBvZiB0aGUgbGFzdCBwYWdlIGNvbnRhaW5pbmcgYml0ZmxpcHMgKHJl
dCA+IDApLA0KPj4gc3BpbmFuZF9tdGRfcmVhZCgpIHdpbGwgcmV0dXJuIHRoYXQgbnVtYmVyIG9m
IGJpdGZsaXBzIGZvciB0aGUgbGFzdA0KPj4gcGFnZS4gQnV0IHRvIG1lIGl0IGxvb2tzIGxpa2Ug
aXQgc2hvdWxkIGluc3RlYWQgcmV0dXJuIG1heF9iaXRmbGlwcyBsaWtlDQo+PiBpdCBkb2VzIHdo
ZW4gdGhlIGxhc3QgcGFnZSByZWFkIHJldHVybnMgd2l0aCAwLg0KPj4NCj4+IFNpZ25lZC1vZmYt
Ynk6IGxpYW93ZWl4aW9uZyA8bGlhb3dlaXhpb25nQGFsbHdpbm5lcnRlY2guY29tPg0KPj4gUmV2
aWV3ZWQtYnk6IEJvcmlzIEJyZXppbGxvbiA8Ym9yaXMuYnJlemlsbG9uQGNvbGxhYm9yYS5jb20+
DQo+PiBSZXZpZXdlZC1ieTogRnJpZWRlciBTY2hyZW1wZiA8ZnJpZWRlci5zY2hyZW1wZkBrb250
cm9uLmRlPg0KPj4gRml4ZXM6IDc1MjlkZjQ2NTI0OCAoIm10ZDogbmFuZDogQWRkIGNvcmUgaW5m
cmFzdHJ1Y3R1cmUgdG8gc3VwcG9ydCBTUEkgTkFORHMiKQ0KPj4gLS0tDQo+PiAgIGRyaXZlcnMv
bXRkL25hbmQvc3BpL2NvcmUuYyB8IDIgKy0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiA8Zm9ybWxldHRlcj4NCj4gDQo+IFRoaXMgaXMg
bm90IHRoZSBjb3JyZWN0IHdheSB0byBzdWJtaXQgcGF0Y2hlcyBmb3IgaW5jbHVzaW9uIGluIHRo
ZQ0KPiBzdGFibGUga2VybmVsIHRyZWUuICBQbGVhc2UgcmVhZDoNCj4gICAgICBodHRwczovL3d3
dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9wcm9jZXNzL3N0YWJsZS1rZXJuZWwtcnVsZXMu
aHRtbA0KPiBmb3IgaG93IHRvIGRvIHRoaXMgcHJvcGVybHkuDQo+IA0KPiA8L2Zvcm1sZXR0ZXI+
DQoNCkZZSSwgeW91IHNob3VsZCBub3Qgc2VuZCB0aGUgcGF0Y2ggdG8gc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZywgYnV0IA0KaW5zdGVhZCwgYXMgSSBzYWlkIGluIG15IG90aGVyIHJlcGx5LCBhZGQg
dGhlIHRhZyAiQ2M6IA0Kc3RhYmxlQHZnZXIua2VybmVsLm9yZyIuIFNlZSAiT3B0aW9uIDEiIGlu
IHRoZSBkb2N1bWVudCBHcmVnIHJlZmVycmVkIHRvLg0KDQpUaGFua3MsDQpGcmllZGVy
