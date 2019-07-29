Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97248787C1
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 10:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfG2IuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 04:50:09 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:36496 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726482AbfG2IuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 04:50:08 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-6-T74adJHKP9OKW6b0WGvMPg-1;
 Mon, 29 Jul 2019 09:50:05 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 29 Jul 2019 09:50:04 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 29 Jul 2019 09:50:04 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?utf-8?B?J0NocmlzdG9waCBCw7ZobXdhbGRlcic=?= 
        <christoph.boehmwalder@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Eric W . Biederman" <ebiederm@xmission.com>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drbd: do not ignore signals in threads
Thread-Topic: [PATCH] drbd: do not ignore signals in threads
Thread-Index: AQHVRehdZ3MFgEc+dUGpXqE3QyW7xKbhRpmw
Date:   Mon, 29 Jul 2019 08:50:04 +0000
Message-ID: <6259de605e9246b095233e3984262b93@AcuMS.aculab.com>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
In-Reply-To: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: T74adJHKP9OKW6b0WGvMPg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQ2hyaXN0b3BoIELDtmhtd2FsZGVyDQo+IFNlbnQ6IDI5IEp1bHkgMjAxOSAwOTozMw0K
PiBGaXggYSByZWdyZXNzaW9uIGludHJvZHVjZWQgYnkgdXBzdHJlYW0gY29tbWl0IGZlZTEwOTkw
MWYzOQ0KPiAoJ3NpZ25hbC9kcmJkOiBVc2Ugc2VuZF9zaWcgbm90IGZvcmNlX3NpZycpLg0KPiAN
Cj4gQ3VycmVudGx5LCB3aGVuIGEgdGhyZWFkIGlzIGluaXRpYWxpemVkLCBhbGwgc2lnbmFscyBh
cmUgc2V0IHRvIGJlDQo+IGlnbm9yZWQgYnkgZGVmYXVsdC4gRFJCRCB1c2VzIFNJR0hVUCB0byBl
bmQgaXRzIHRocmVhZHMsIHdoaWNoIG1lYW5zIGl0DQo+IGlzIG5vdyBubyBsb25nZXIgcG9zc2li
bGUgdG8gYnJpbmcgZG93biBhIERSQkQgcmVzb3VyY2UgYmVjYXVzZSB0aGUNCj4gc2lnbmFscyBk
byBub3QgbWFrZSBpdCB0aHJvdWdoIHRvIHRoZSB0aHJlYWQgaW4gcXVlc3Rpb24uDQo+IA0KPiBU
aGlzIGNpcmN1bXN0YW5jZSB3YXMgcHJldmlvdXNseSBoaWRkZW4gYnkgdGhlIGZhY3QgdGhhdCBE
UkJEIHVzZWQNCj4gZm9yY2Vfc2lnKCkgdG8ga2lsbCBpdHMgdGhyZWFkcy4gVGhlIGFmb3JlbWVu
dGlvbmVkIHVwc3RyZWFtIGNvbW1pdA0KPiBjaGFuZ2VkIHRoaXMgdG8gc2VuZF9zaWcoKSwgd2hp
Y2ggbWVhbnMgdGhlIGVmZmVjdHMgb2YgdGhlIHNpZ25hbHMgYmVpbmcNCj4gaWdub3JlZCBieSBk
ZWZhdWx0IGFyZSBub3cgYmVjb21pbmcgdmlzaWJsZS4NCj4gDQo+IFRodXMsIGlzc3VlIGFuIGFs
bG93X3NpZ25hbCgpIGF0IHRoZSBzdGFydCBvZiB0aGUgdGhyZWFkIHRvIGV4cGxpY2l0bHkNCj4g
YWxsb3cgdGhlIGRlc2lyZWQgc2lnbmFscy4NCg0KRG9lc24ndCB1bm1hc2tpbmcgdGhlIHNpZ25h
bHMgYW5kIHVzaW5nIHNlbmRfc2lnKCkgaW5zdGVhZCAgb2YgZm9yY2Vfc2lnKCkNCmhhdmUgdGhl
IChwcm9iYWJseSB1bndhbnRlZCkgc2lkZSBlZmZlY3Qgb2YgYWxsb3dpbmcgdXNlcnNwYWNlIHRv
IHNlbmQNCnRoZSBzaWduYWw/DQoNCkkndmUgY2VydGFpbmx5IGdvdCBzb21lIGRyaXZlciBjb2Rl
IHRoYXQgdXNlcyBmb3JjZV9zaWcoKSBvbiBhIGt0aHJlYWQNCnRoYXQgaXQgZG9lc24ndCAoZXZl
cikgd2FudCB1c2Vyc3BhY2UgdG8gc2lnbmFsLg0KDQpUaGUgb3JpZ2luYTEgY29tbWl0IHNheXM6
DQo+IEZ1cnRoZXIgZm9yY2Vfc2lnIGlzIGZvciBkZWxpdmVyaW5nIHN5bmNocm9ub3VzIHNpZ25h
bHMgKGFrYSBleGNlcHRpb25zKS4NCj4gVGhlIGxvY2tpbmcgaW4gZm9yY2Vfc2lnIGlzIG5vdCBw
cmVwYXJlZCB0byBkZWFsIHdpdGggcnVubmluZyBwcm9jZXNzZXMsIGFzDQo+IHRzay0+c2lnaGFu
ZCBtYXkgY2hhbmdlIGR1cmluZyBleGVjIGZvciBhIHJ1bm5pbmcgcHJvY2Vzcy4NCg0KSSB0aGlu
ayBhIGxvdCBvZiBjb2RlIGhhcyBhc3N1bWVkIHRoYXQgdGhlIG9ubHkgcmVhbCBkaWZmZXJlbmNl
IGJldHdlZW4NCnNlbmRfc2lnKCkgYW5kIGZvcmNlX3NpZygpIGlzIHRoYXQgdGhlIGxhdHRlciBp
Z25vcmVzIHRoZSBzaWduYWwgbWFzay4NCg0KSWYgeW91IG5lZWQgdG8gdW5ibG9jayBhIGtlcm5l
bCB0aHJlYWQgKGVnIG9uZSBibG9ja2VkIGluIGtlcm5lbF9hY2NlcHQoKSkNCmluIG9yZGVyIHRv
IHVubG9hZCBhIGRyaXZlciwgdGhlbiB5b3UgcmVhbGx5IGRvbid0IHdhbnQgaXQgdG8gYmUgcG9z
c2libGUNCmZvciBhbnl0aGluZyBlbHNlIHRvIHNpZ25hbCB0aGUga3RocmVhZC4NCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

