Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FBD3A9C4B
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 15:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhFPNo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 09:44:29 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:50014 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232458AbhFPNo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 09:44:27 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-210-PkI2T8O5PUadzIa1crN2Vg-1; Wed, 16 Jun 2021 14:42:18 +0100
X-MC-Unique: PkI2T8O5PUadzIa1crN2Vg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Jun
 2021 14:42:17 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Wed, 16 Jun 2021 14:42:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Amit Klein' <aksecurity@gmail.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Thread-Topic: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Thread-Index: AQHXYpBi9A2YPoOhfUuPKKRWnHSSTKsWa0BQgAAjcgCAABKx0A==
Date:   Wed, 16 Jun 2021 13:42:17 +0000
Message-ID: <a9956d07dfe64e5db829dbe1a8910bdd@AcuMS.aculab.com>
References: <20210512144743.039977287@linuxfoundation.org>
 <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com>
 <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
 <a388a8018b09429d93a4a6b6852c70b2@AcuMS.aculab.com>
 <CANEQ_++RSG=cOa-hWcHefqVa5_=FRo+PdwuJbE2A-NHA_RNXXQ@mail.gmail.com>
In-Reply-To: <CANEQ_++RSG=cOa-hWcHefqVa5_=FRo+PdwuJbE2A-NHA_RNXXQ@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQW1pdCBLbGVpbg0KPiBTZW50OiAxNiBKdW5lIDIwMjEgMTQ6MjANCj4gDQo+IE9uIFdl
ZCwgSnVuIDE2LCAyMDIxIGF0IDE6MTkgUE0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAYWN1
bGFiLmNvbT4gd3JvdGU6DQo+IA0KPiA+IENhbiBzb21lb25lIGV4cGxhaW4gd2h5IHRoaXMgaXMg
YSBnb29kIGlkZWEgZm9yIGEgJ25vcm1hbCcgc3lzdGVtPw0KPiANCj4gVGhpcyBwYXRjaCBtaXRp
Z2F0ZXMgc29tZSB0ZWNobmlxdWVzIHRoYXQgbGVhayBpbnRlcm5hbCBzdGF0ZSBkdWUgdG8NCj4g
dGFibGUgaGFzaCBjb2xsaXNpb25zLg0KDQpBcyB5b3Ugc2F5IGJlbG93IGl0IGlzbid0IHJlYWxs
eSBlZmZlY3RpdmUuLi4NCg0KPiA+IFdoeSBzaG91bGQgbXkgZGVza3RvcCBzeXN0ZW0gJ3dhc3Rl
JyAyTUIgb2YgbWVtb3J5IG9uIGEgbWFzc2l2ZQ0KPiA+IGhhc2ggdGFibGUgdGhhdCBJIGRvbid0
IG5lZWQuDQo+IA0KPiBJbiB0aGUgcGF0Y2gncyBkZWZlbnNlLCBpdCBvbmx5IGNvbnN1bWVzIDJN
QiB3aGVuIHRoZSBwaHlzaWNhbCBSQU0gaXMgPj0gMTZHQi4NCg0KUmlnaHQsIGJ1dCBJJ3ZlIDE2
R0Igb2YgbWVtb3J5IGJlY2F1c2UgSSBydW4gc29tZSB2ZXJ5IGxhcmdlDQphcHBsaWNhdGlvbnMg
dGhhdCBuZWVkIGFsbCB0aGUgbWVtb3J5IHRoZXkgY2FuIGdldCAoYW5kIG1vcmUpLg0KDQpJbiBh
bnkgY2FzZSwgZm9yIG1hbnkgYXJjaGl0ZWN0dXJlcyA4R0IgaXMgJ2VudHJ5IGxldmVsJy4NClRo
YXQgaW5jbHVkZXMgc29tZSBvciB0aGUgJ3NtYWxsJyBBUk0gY3B1cy4NClRoZXkgYXJlIHVubGlr
ZWx5IHRvIGhhdmUgdGVucyBvZiBjb25uZWN0aW9ucywgbmV2ZXIgbWluZA0KdGhvdXNhbmRzLg0K
DQo+ID4gSXQgbWlnaHQgYmUgbmVlZGVkIGJ5IHN5c3RlbXMgdGhhbiBoYW5kbGUgbWFzc2l2ZSBu
dW1iZXJzDQo+ID4gb2YgY29uY3VycmVudCBjb25uZWN0aW9ucyAtIGJ1dCB0aGF0IGlzbid0ICdt
b3N0IHN5c3RlbXMnLg0KPiA+DQo+ID4gU3VyZWx5IGl0IHdvdWxkIGJlIGJldHRlciB0byBkZXRl
Y3Qgd2hlbiB0aGUgbnVtYmVyIG9mIGVudHJpZXMNCj4gPiBpcyBjb21wYXJhYmxlIHRvIHRoZSB0
YWJsZSBzaXplIGFuZCB0aGVuIHJlc2l6ZSB0aGUgdGFibGUuDQo+IA0KPiBTZWN1cml0eS13aXNl
LCB0aGlzIGFwcHJvYWNoIGlzIG5vdCBlZmZlY3RpdmUuIFRoZSB0YWJsZSBzaXplIHdhcw0KPiBp
bmNyZWFzZWQgdG8gcmVkdWNlIHRoZSBsaWtlbGlob29kIG9mIGhhc2ggY29sbGlzaW9ucy4gVGhl
c2Ugc3RhcnQNCj4gaGFwcGVuaW5nIHdoZW4geW91IGhhdmUgfk5eKDEvMikgZWxlbWVudHMgKGZv
ciB0YWJsZSBzaXplIE4pLCBzbw0KPiB5b3UnbGwgbmVlZCB0byByZXNpemUgcHJldHR5IHF1aWNr
bHkgYW55d2F5Lg0KDQpZb3UgcmVhbGx5IGhhdmUgdG8gbGl2ZSB3aXRoIHNvbWUgaGFzaCBjb2xs
aXNpb25zLg0KUmVzaXppbmcgYXQgTl4oMS8yKSBqdXN0IGRvZXNuJ3Qgc2NhbGUuDQpOb3Qgb25s
eSB0aGF0IHRoZSBoYXNoIGZ1bmN0aW9uIHdpbGwgc3RvcCBnZW5lcmF0aW5nIG5vbi1jb2xsaWRp
bmcNCnZhbHVlcyBvbmNlIHRoZSB0YWJsZSBzdGFydHMgZ2V0dGluZyBiaWcuDQooQSB2ZXJ5IGV4
cGVuc2l2ZSBoYXNoIGZ1bmN0aW9uIG1pZ2h0IGhlbHAgLSBidXQgaSB3b3VsZG4ndCBjb3VudCBv
biBpdC4pDQoNCkluIGFueSBjYXNlLCB0aGUgY2hhbmNlIG9mIGhpdHRpbmcgYSBoYXNoIGNvbGxp
c2lvbiBpcyBzbGlnaHRseQ0KbGVzcyB0aGFuICh0YWJsZV9zaXplIC8gYWN0aXZlX2VudHJpZXMp
Lg0KDQpXaGF0IHlvdSB3YW50IHRvIGF2b2lkIGlzIHRoZSBFTEYgc3ltYm9sIGhhc2ggd2hlbiB0
aGUgYXZlcmFnZQ0KY2hhaW4gbGVuZ3RoIGlzIGFib3V0IDEuNSBhbmQgeW91IGhhdmUgdG8gc2Vw
YXJhdGVseSBjaGVjayB0aGUgaGFzaA0KdGFibGUgb2YgZXZlcnkgc2hhcmVkIGxpYnJhcnkuDQpU
aGF0IHF1aWNrbHkgYmFsbG9vbnMgdG8gYSBsb3Qgb2Ygc3RyaW5nIGNvbXBhcmVzLg0KKEkgbG9v
a2VkIGF0IHRoYXQgZm9yIG1vemlsbGEgbWF5IHllYXJzIGFnbyAtIHdhcyBob3JyaWQuKQ0KDQoJ
RGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1v
dW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEz
OTczODYgKFdhbGVzKQ0K

