Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0811623BC
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 10:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgBRJot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 04:44:49 -0500
Received: from skedge04.snt-world.com ([91.208.41.69]:35304 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgBRJot (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 04:44:49 -0500
Received: from sntmail10s.snt-is.com (unknown [10.203.32.183])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id D0C3967A8C4;
        Tue, 18 Feb 2020 10:44:46 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail10s.snt-is.com
 (10.203.32.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 18 Feb
 2020 10:44:46 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Tue, 18 Feb 2020 10:44:46 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 0/2] serial: imx: Backport fixes for irq handling to v4.14
Thread-Topic: [PATCH 0/2] serial: imx: Backport fixes for irq handling to
 v4.14
Thread-Index: AQHV5ZuphrtwteBzhkWCeOYI46C5s6ggUc4AgAAlLACAAAQRAIAAKRSA
Date:   Tue, 18 Feb 2020 09:44:46 +0000
Message-ID: <e71d11c4-b2e6-d923-337e-1378e1cf64c5@kontron.de>
References: <20200217140740.29743-1-frieder.schrempf@kontron.de>
 <20200218045008.GA2049358@kroah.com>
 <20200218070310.ibv2m2f7ihfaevrp@pengutronix.de>
 <20200218071744.GA2087281@kroah.com>
In-Reply-To: <20200218071744.GA2087281@kroah.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <00443668C1DDC642A055DA2A7D544E78@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: D0C3967A8C4.AF249
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        shawnguo@kernel.org, stable@vger.kernel.org,
        u.kleine-koenig@pengutronix.de
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTguMDIuMjAgMDg6MTcsIGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnIHdyb3RlOg0KPiBP
biBUdWUsIEZlYiAxOCwgMjAyMCBhdCAwODowMzoxMEFNICswMTAwLCBVd2UgS2xlaW5lLUvDtm5p
ZyB3cm90ZToNCj4+IE9uIFR1ZSwgRmViIDE4LCAyMDIwIGF0IDA1OjUwOjA4QU0gKzAxMDAsIGdy
ZWdraEBsaW51eGZvdW5kYXRpb24ub3JnIHdyb3RlOg0KPj4+IE9uIE1vbiwgRmViIDE3LCAyMDIw
IGF0IDAyOjA4OjAwUE0gKzAwMDAsIFNjaHJlbXBmIEZyaWVkZXIgd3JvdGU6DQo+Pj4+IEZyb206
IEZyaWVkZXIgU2NocmVtcGYgPGZyaWVkZXIuc2NocmVtcGZAa29udHJvbi5kZT4NCj4+Pj4NCj4+
Pj4gQSBjdXN0b21lciBvZiBvdXJzIGhhcyBwcm9ibGVtcyB3aXRoIFJTNDg1IG9uIGkuTVg2VUwg
d2l0aCB0aGUgbGF0ZXN0IHY0LjE0DQo+Pj4+IGtlcm5lbC4gVGhleSBnZXQgYW4gZXhjZXB0aW9u
IGxpa2UgYmVsb3cgZnJvbSB0aW1lIHRvIHRpbWUgKHRoZSB0cmFjZSBpcw0KPj4+PiBmcm9tIGFu
IG9sZGVyIGtlcm5lbCwgYnV0IHRoZSBwcm9ibGVtIGFsc28gZXhpc3RzIGluIHY0LjE0LjE3MCku
DQo+Pj4+DQo+Pj4+IEFzIHRoZSBjcHVpZGxlIHN0YXRlIDIgY2F1c2VzIGxhcmdlIGRlbGF5cyBm
b3IgdGhlIGludGVycnVwdCB0aGF0IGNvbnRyb2xzIHRoZQ0KPj4+PiBSUzQ4NSBSVFMgc2lnbmFs
ICh3aGljaCBjYW4gbGVhZCB0byBjb2xsaXNpb25zIG9uIHRoZSBidXMpLCBjcHVpZGxlIHN0YXRl
IDIgd2FzDQo+Pj4+IGRpc2FibGVkIG9uIHRoaXMgc3lzdGVtLiBUaGlzIGFzcGVjdCBtaWdodCBj
YXVzZSB0aGUgZXhjZXB0aW9uIGhhcHBlbmluZyBtb3JlDQo+Pj4+IG9mdGVuIG9uIHRoaXMgc3lz
dGVtIHRoYW4gb24gb3RoZXIgc3lzdGVtcyB3aXRoIGRlZmF1bHQgY3B1aWRsZSBzZXR0aW5ncy4N
Cj4+Pj4NCj4+Pj4gTG9va2luZyBmb3Igc29sdXRpb25zIEkgZm91bmQgVXdlJ3MgcGF0Y2hlcyB0
aGF0IHdlcmUgYXBwbGllZCBpbiB2NC4xNyBiZWluZw0KPj4+PiBtZW50aW9uZWQgaGVyZSBbMV0g
YW5kIGhlcmUgWzJdLiBJbiBbMV0gVXdlIG5vdGVzIHRoYXQgYmFja3BvcnRpbmcgdGhlc2UgZml4
ZXMNCj4+Pj4gdG8gdjQuMTQgbWlnaHQgbm90IGJlIHRyaXZpYWwsIGJ1dCBJIHRyaWVkIGFuZCBp
biBteSBvcGluaW9uIGZvdW5kIGl0IG5vdCB0byBiZQ0KPj4+PiB0b28gcHJvYmxlbWF0aWMgZWl0
aGVyLg0KPj4+Pg0KPj4+PiBXaXRoIHRoZSBiYWNrcG9ydGVkIHBhdGNoZXMgYXBwbGllZCwgb3Vy
IGN1c3RvbWVyIHJlcG9ydHMgdGhhdCB0aGUgZXhjZXB0aW9ucw0KPj4+PiBzdG9wcGVkIG9jY3Vy
aW5nLiBHaXZlbiB0aGlzIGFuZCB0aGUgZmFjdCB0aGF0IHRoZSBwcm9ibGVtIHNlZW1zIHRvIGJl
IGtub3duDQo+Pj4+IGFuZCBxdWl0ZSBjb21tb24sIGl0IHdvdWxkIGJlIG5pY2UgdG8gZ2V0IHRo
aXMgaW50byB0aGUgdjQuMTQgc3RhYmxlIHRyZWUuDQo+Pj4NCj4+PiBUaGFua3MgZm9yIHRoZSBi
YWNrcG9ydHMsIGJvdGggbm93IHF1ZXVlZCB1cC4NCj4+DQo+PiBUbyBjb21wbGV0ZSB0aGVzZSBm
aXhlcyB5b3UgYWxzbyB3YW50IHRvIGJhY2twb3J0DQo+Pg0KPj4gCTEwMWFhNDZiZDIyMSBzZXJp
YWw6IGlteDogZml4IGEgcmFjZSBjb25kaXRpb24gaW4gcmVjZWl2ZSBwYXRoDQo+IA0KPiBJZiBz
bywgaXQgbmVlZHMgdG8gYWxzbyBnbyB0byA0LjE5LnksIGFuZCBzb21lb25lIG5lZWRzIHRvIHBy
b3ZpZGUgYQ0KPiB3b3JraW5nIGJhY2twb3J0IGZvciBib3RoIHBsYWNlcyA6KQ0KDQpJIGNhbiB0
cnkgdG8gY29tZSB1cCB3aXRoIHNvbWV0aGluZy4gQnV0IEkgZG9uJ3QgaGF2ZSBhIHN5c3RlbSB0
aGF0IGlzIA0KYWZmZWN0ZWQgYnkgdGhpcyAob25seSBzaW5nbGUgY29yZSkgdG8gdGVzdC4NCg0K
QmVzdCByZWdhcmRzLA0KRnJpZWRlcg==
