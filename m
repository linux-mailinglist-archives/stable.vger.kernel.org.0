Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2072C3A3DBD
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 10:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhFKIJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 04:09:58 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:46101 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229584AbhFKIJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 04:09:58 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-206-L8ys3hEWPauhtMu7NFL4nA-1; Fri, 11 Jun 2021 09:07:55 +0100
X-MC-Unique: L8ys3hEWPauhtMu7NFL4nA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.18; Fri, 11 Jun 2021 09:07:54 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Fri, 11 Jun 2021 09:07:54 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Nick Desaulniers' <ndesaulniers@google.com>,
        Tor Vic <torvic9@mailbox.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD <
 13.0.0
Thread-Topic: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD <
 13.0.0
Thread-Index: AQHXXi3hDa/SX38CoUOUtr2ZTdzJmqsOdORg
Date:   Fri, 11 Jun 2021 08:07:54 +0000
Message-ID: <6c8315ef3ebb45b59dd531c634bcff48@AcuMS.aculab.com>
References: <214134496.67043.1623317284090@office.mailbox.org>
 <CAKwvOdmU9TUiZ6AatJja=ksneRKP5saNCkx0qodLMOi_BshSSg@mail.gmail.com>
In-Reply-To: <CAKwvOdmU9TUiZ6AatJja=ksneRKP5saNCkx0qodLMOi_BshSSg@mail.gmail.com>
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

RnJvbTogTmljayBEZXNhdWxuaWVycw0KPiBTZW50OiAxMCBKdW5lIDIwMjEgMjA6MjENCj4gDQo+
IE9uIFRodSwgSnVuIDEwLCAyMDIxIGF0IDI6MjggQU0gPHRvcnZpYzlAbWFpbGJveC5vcmc+IHdy
b3RlOg0KPiA+DQo+ID4gU2luY2UgTExWTSBjb21taXQgMzc4N2VlNCwgdGhlICctc3RhY2stYWxp
Z25tZW50JyBmbGFnIGhhcyBiZWVuIGRyb3BwZWQgWzFdLA0KPiA+IGxlYWRpbmcgdG8gdGhlIGZv
bGxvd2luZyBlcnJvciBtZXNzYWdlIHdoZW4gYnVpbGRpbmcgYSBMVE8ga2VybmVsIHdpdGgNCj4g
PiBDbGFuZy0xMyBhbmQgTExELTEzOg0KPiA+DQo+ID4gICAgIGxkLmxsZDogZXJyb3I6IC1wbHVn
aW4tb3B0PS06IGxkLmxsZDogVW5rbm93biBjb21tYW5kIGxpbmUgYXJndW1lbnQNCj4gPiAgICAg
Jy1zdGFjay1hbGlnbm1lbnQ9OCcuICBUcnkgJ2xkLmxsZCAtLWhlbHAnDQo+ID4gICAgIGxkLmxs
ZDogRGlkIHlvdSBtZWFuICctLXN0YWNrcmVhbGlnbj04Jz8NCj4gPg0KPiA+IEl0IGFsc28gYXBw
ZWFycyB0aGF0IHRoZSAnLWNvZGUtbW9kZWwnIGZsYWcgaXMgbm90IG5lY2Vzc2FyeSBhbnltb3Jl
IHN0YXJ0aW5nDQo+ID4gd2l0aCBMTFZNLTkgWzJdLg0KPiA+DQo+ID4gRHJvcCAnLWNvZGUtbW9k
ZWwnIGFuZCBtYWtlICctc3RhY2stYWxpZ25tZW50JyBjb25kaXRpb25hbCBvbiBMTEQgPCAxMy4w
LjAuDQo+IA0KPiBQbGVhc2UgaW5jbHVkZSB0aGlzIGFkZGl0aW9uYWwgY29udGV4dCBpbiB2MjoN
Cj4gYGBgDQo+IFRoZXNlIGZsYWdzIHdlcmUgbmVjZXNzYXJ5IGJlY2F1c2UgdGhlc2UgZmxhZ3Mg
d2VyZSBub3QgZW5jb2RlZCBpbiB0aGUNCj4gSVIgcHJvcGVybHksIHNvIHRoZSBsaW5rIHdvdWxk
IHJlc3RhcnQgb3B0aW1pemF0aW9ucyB3aXRob3V0IHRoZW0uIE5vdw0KPiB0aGVyZSBhcmUgcHJv
cGVybHkgZW5jb2RlZCBpbiB0aGUgSVIsIGFuZCB0aGVzZSBmbGFncyBleHBvc2luZw0KPiBpbXBs
ZW1lbnRhdGlvbiBkZXRhaWxzIGFyZSBubyBsb25nZXIgbmVjZXNzYXJ5Lg0KPiBgYGANCj4gVGhh
dCB3YXkgaXQgZG9lc24ndCBzb3VuZCBsaWtlIHdlJ3JlIG5vdCB1c2luZyBhbiA4QiBzdGFjayBh
bGlnbm1lbnQNCj4gb24geDg2OyB3ZSB2ZXJ5IG11Y2ggYXJlIHNvOyBBTURHUFUgR1BGcyB3aXRo
b3V0IGl0IQ0KDQpBY3R1YWxseSwgZ2l2ZSB0aGF0IExUTyBpcyBzdGlsbCAnZXhwZXJpbWVudGFs
JyBpcyBpdCB3b3J0aCBqdXN0DQpyZW1vdmluZyB0aGUgZmxhZ3MgYW5kIHJlcXVpcmluZyBjbGFu
Zy0xMyBmb3IgTFRPIGJ1aWxkcz8NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

