Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9859B1D12DD
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 14:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgEMMhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 08:37:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:45741 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729975AbgEMMhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 08:37:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-12-jW35w8wzOfeMpvgDTW3dHQ-1; Wed, 13 May 2020 13:37:09 +0100
X-MC-Unique: jW35w8wzOfeMpvgDTW3dHQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 13 May 2020 13:37:09 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 13 May 2020 13:37:09 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Geert Uytterhoeven' <geert@linux-m68k.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        stable <stable@vger.kernel.org>,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Vineet Gupta" <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>
Subject: RE: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Thread-Topic: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Thread-Index: AQHWKQu4HYgJHBu5S0KOdh+8IRi0tqilymPggAAQx3+AABgL4A==
Date:   Wed, 13 May 2020 12:37:09 +0000
Message-ID: <204deb990a5949428a9d4fba7359eda1@AcuMS.aculab.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-4-lee.jones@linaro.org>
 <20200513093536.GB830571@kroah.com>
 <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
 <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com>
 <CAMuHMdV+FAjBtp-yzp+57o19gcasq15-9rDM58NbJsOwBu=vUQ@mail.gmail.com>
 <CAMuHMdUJeJaxtOLVfEkJgXw=A7YO93pD2C11wYCDr3VR7mOJ5g@mail.gmail.com>
In-Reply-To: <CAMuHMdUJeJaxtOLVfEkJgXw=A7YO93pD2C11wYCDr3VR7mOJ5g@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogR2VlcnQgVXl0dGVyaG9ldmVuDQo+IFNlbnQ6IDEzIE1heSAyMDIwIDEyOjA3DQo+IEhp
IERhdmlkLA0KPiANCj4gT24gV2VkLCBNYXkgMTMsIDIwMjAgYXQgMTowNSBQTSBHZWVydCBVeXR0
ZXJob2V2ZW4gPGdlZXJ0QGxpbnV4LW02OGsub3JnPiB3cm90ZToNCj4gPiBPbiBXZWQsIE1heSAx
MywgMjAyMCBhdCAxMjoxMCBQTSBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBhY3VsYWIuY29t
PiB3cm90ZToNCj4gPiA+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbg0KPiA+ID4gPiBTZW50OiAx
MyBNYXkgMjAyMCAxMDo0OQ0KPiA+ID4gLi4uDQo+ID4gPiA+ID4gSSBkb24ndCB3YW50IHRvIGFw
cGx5IHRoaXMgdG8gb2xkZXIga2VybmVscyBhcyBpdCBjb3VsZCBjYXVzZSBleHRyYQ0KPiA+ID4g
PiA+IG1lbW9yeSB1c2FnZSBmb3Igbm8gZ29vZCByZWFzb24uICBJIGhhdmUgbm8gaWRlYSB3aHkg
YSBub24gQVJDIHN5c3RlbQ0KPiA+ID4gPiA+IHdvdWxkIHdhbnQgaXQgOigNCj4gPiA+ID4NCj4g
PiA+ID4gSSB0aGluayB0aGUgcmVmZXJlbmNlIHRvIEFSQyBpcyBhIHJlZCBoZXJyaW5nLg0KPiA+
ID4gPiBUaGUgcmVhbCBpc3N1ZSBpcyB0aGF0IGJ1ZmZlcnMgdXNlZCBmb3IgRE1BIG1heSBub3Qg
aGF2ZSB0aGUgcmVxdWlyZWQNCj4gPiA+ID4gYWxpZ25tZW50LCB3aGljaCBpcyBub3QgbGltaXRl
ZCB0byBBUkMgc3lzdGVtcy4NCj4gPiA+ID4NCj4gPiA+ID4gTm90ZSB0aGF0IEknbSBhbHNvIG5v
dCBzdXBlciBoYXBweSB3aXRoIHRoZSBleHRyYSBtZW1vcnkgdXNhZ2UuDQo+ID4gPiA+IEJ1dCBk
ZXZtXyooKSBjb252ZW5pZW5jZXMgY29tZSB3aXRoIHRoZWlyIHBlbmFsdGllcy4uLg0KPiA+ID4N
Cj4gPiA+IEludGVyZXN0aW5nIHRob3VnaHQuDQo+ID4gPiBDb3VsZCB0aGUgZGV2bSAnaGVhZGVy
JyBiZSBwdXQgcmlnaHQgYXQgdGhlIGVuZCBvZiB0aGUga21hbGxvYygpDQo+ID4gPiBidWZmZXI/
DQo+ID4gPg0KPiA+ID4gVGhlbiB0aGUgZHJpdmVyIHdvdWxkIGJlIGdpdmVuIGFsaWduZWQgYWRk
cmVzcy4NCj4gPg0KPiA+IFllcywgaWYgdGhlIGhlYWRlciBpcyBleHRlbmRlZCB0byBjb250YWlu
IHRoZSByZWFsIHN0YXJ0IGFkZHJlc3Mgb2YgdGhlDQo+ID4gYWxsb2NhdGVkIGJsb2NrLg0KPiAN
Cj4gQnV0IHRoYXQgd291bGQgYnJlYWsgZXhwbGljaXQgZnJlZWluZyB0aHJvdWdoIGRldm1fa2Zy
ZWUoKSwgYXMgdGhhdCBpcw0KPiBwYXNzZWQgYSBwb2ludGVyIHRvIHRoZSBwYXlsb2FkLCBub3Qg
dGhlIGhlYWRlci4NCg0KVGhlcmUgaXMgYSBmdW5jdGlvbiB0aGF0IGdpdmVzIHRoZSBmdWxsIHNp
emUgb2YgbWVtb3J5IHRoYXQga21hbGxvYygpDQpyZXR1cm5zLg0KVGhhdCBjYW4gYmUgdXNlZCB0
byBmaW5kIHRoZSBlbmQgYW5kIGhlbmNlIHRoZSBoZWFkZXIuDQoNCkkgZG9uJ3QgdGhpbmsgeW91
IGNhbiBmaW5kIHRoZSBiYXNlL3NpemUgZnJvbSBhbiBhZGRyZXNzIHdpdGhpbiB0aGUNCmJ1ZmZl
ciAtIHNvIGEgbGVuZ3RoIGFuZC9vciBwb2ludGVyIGlzIG5lZWRlZCB0byBmaW5kIHRoZSBzdGFy
dC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

