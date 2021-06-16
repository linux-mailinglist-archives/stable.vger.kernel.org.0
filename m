Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F9C3A9718
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 12:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhFPKV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 06:21:28 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:22466 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231452AbhFPKV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 06:21:26 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-215-TXlbLyjJMuanTG_9lkomZA-1; Wed, 16 Jun 2021 11:19:16 +0100
X-MC-Unique: TXlbLyjJMuanTG_9lkomZA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Jun
 2021 11:19:15 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Wed, 16 Jun 2021 11:19:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Amit Klein' <aksecurity@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Thread-Topic: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Thread-Index: AQHXYpBi9A2YPoOhfUuPKKRWnHSSTKsWa0BQ
Date:   Wed, 16 Jun 2021 10:19:15 +0000
Message-ID: <a388a8018b09429d93a4a6b6852c70b2@AcuMS.aculab.com>
References: <20210512144743.039977287@linuxfoundation.org>
 <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com>
 <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
In-Reply-To: <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
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

RnJvbTogQW1pdCBLbGVpbg0KPiBTZW50OiAxNiBKdW5lIDIwMjEgMTA6MTcNCi4uLg0KPiAtI2Rl
ZmluZSBJUF9JREVOVFNfU1ogMjA0OHUNCj4gLQ0KPiArLyogSGFzaCB0YWJsZXMgb2Ygc2l6ZSAy
MDQ4Li4yNjIxNDQgZGVwZW5kaW5nIG9uIFJBTSBzaXplLg0KPiArICogRWFjaCBidWNrZXQgdXNl
cyA4IGJ5dGVzLg0KPiArICovDQo+ICtzdGF0aWMgdTMyIGlwX2lkZW50c19tYXNrIF9fcmVhZF9t
b3N0bHk7DQouLi4NCj4gKyAgICAvKiBGb3IgbW9kZXJuIGhvc3RzLCB0aGlzIHdpbGwgdXNlIDIg
TUIgb2YgbWVtb3J5ICovDQo+ICsgICAgaWRlbnRzX2hhc2ggPSBhbGxvY19sYXJnZV9zeXN0ZW1f
aGFzaCgiSVAgaWRlbnRzIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgc2l6ZW9mKCpp
cF9pZGVudHMpICsgc2l6ZW9mKCppcF90c3RhbXBzKSwNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgMCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgMTYsIC8qIG9uZSBidWNrZXQg
cGVyIDY0IEtCICovDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgIEhBU0hfWkVSTywNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgTlVMTCwNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgJmlwX2lkZW50c19tYXNrLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAyMDQ4
LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAyNTYqMTAyNCk7DQo+ICsNCg0KQ2FuIHNv
bWVvbmUgZXhwbGFpbiB3aHkgdGhpcyBpcyBhIGdvb2QgaWRlYSBmb3IgYSAnbm9ybWFsJyBzeXN0
ZW0/DQoNCldoeSBzaG91bGQgbXkgZGVza3RvcCBzeXN0ZW0gJ3dhc3RlJyAyTUIgb2YgbWVtb3J5
IG9uIGEgbWFzc2l2ZQ0KaGFzaCB0YWJsZSB0aGF0IEkgZG9uJ3QgbmVlZC4NCkl0IG1pZ2h0IGJl
IG5lZWRlZCBieSBzeXN0ZW1zIHRoYW4gaGFuZGxlIG1hc3NpdmUgbnVtYmVycw0Kb2YgY29uY3Vy
cmVudCBjb25uZWN0aW9ucyAtIGJ1dCB0aGF0IGlzbid0ICdtb3N0IHN5c3RlbXMnLg0KDQpTdXJl
bHkgaXQgd291bGQgYmUgYmV0dGVyIHRvIGRldGVjdCB3aGVuIHRoZSBudW1iZXIgb2YgZW50cmll
cw0KaXMgY29tcGFyYWJsZSB0byB0aGUgdGFibGUgc2l6ZSBhbmQgdGhlbiByZXNpemUgdGhlIHRh
YmxlLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

