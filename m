Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDE11D15A2
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 15:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388104AbgEMNf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 09:35:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:28436 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388653AbgEMNf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 09:35:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-150-mvXCbwWQMYOTdi30zABxhg-1; Wed, 13 May 2020 14:35:50 +0100
X-MC-Unique: mvXCbwWQMYOTdi30zABxhg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 13 May 2020 14:35:49 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 13 May 2020 14:35:49 +0100
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
Thread-Index: AQHWKQu4HYgJHBu5S0KOdh+8IRi0tqilymPggAAQx3+AABgL4P///hYAgAAR6lA=
Date:   Wed, 13 May 2020 13:35:49 +0000
Message-ID: <905c8585943840e9ac7c09da37c88a44@AcuMS.aculab.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-4-lee.jones@linaro.org>
 <20200513093536.GB830571@kroah.com>
 <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
 <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com>
 <CAMuHMdV+FAjBtp-yzp+57o19gcasq15-9rDM58NbJsOwBu=vUQ@mail.gmail.com>
 <CAMuHMdUJeJaxtOLVfEkJgXw=A7YO93pD2C11wYCDr3VR7mOJ5g@mail.gmail.com>
 <204deb990a5949428a9d4fba7359eda1@AcuMS.aculab.com>
 <CAMuHMdUnbDHJSR+rJVq5h9AvBKDNuRnxw9ttXHyRFXYkqV_F+g@mail.gmail.com>
In-Reply-To: <CAMuHMdUnbDHJSR+rJVq5h9AvBKDNuRnxw9ttXHyRFXYkqV_F+g@mail.gmail.com>
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

RnJvbTogR2VlcnQgVXl0dGVyaG9ldmVuDQo+IFNlbnQ6IDEzIE1heSAyMDIwIDE0OjI2DQo+IEhp
IERhdmlkLA0KPiANCj4gT24gV2VkLCBNYXkgMTMsIDIwMjAgYXQgMjozNyBQTSBEYXZpZCBMYWln
aHQgPERhdmlkLkxhaWdodEBhY3VsYWIuY29tPiB3cm90ZToNCj4gPiBGcm9tOiBHZWVydCBVeXR0
ZXJob2V2ZW4NCj4gPiA+IE9uIFdlZCwgTWF5IDEzLCAyMDIwIGF0IDE6MDUgUE0gR2VlcnQgVXl0
dGVyaG9ldmVuIDxnZWVydEBsaW51eC1tNjhrLm9yZz4gd3JvdGU6DQo+ID4gPiA+IE9uIFdlZCwg
TWF5IDEzLCAyMDIwIGF0IDEyOjEwIFBNIERhdmlkIExhaWdodCA8RGF2aWQuTGFpZ2h0QGFjdWxh
Yi5jb20+IHdyb3RlOg0KPiA+ID4gPiA+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbg0KPiA+ID4g
PiA+ID4gU2VudDogMTMgTWF5IDIwMjAgMTA6NDkNCj4gPiA+ID4gPiAuLi4NCj4gPiA+ID4gPiA+
ID4gSSBkb24ndCB3YW50IHRvIGFwcGx5IHRoaXMgdG8gb2xkZXIga2VybmVscyBhcyBpdCBjb3Vs
ZCBjYXVzZSBleHRyYQ0KPiA+ID4gPiA+ID4gPiBtZW1vcnkgdXNhZ2UgZm9yIG5vIGdvb2QgcmVh
c29uLiAgSSBoYXZlIG5vIGlkZWEgd2h5IGEgbm9uIEFSQyBzeXN0ZW0NCj4gPiA+ID4gPiA+ID4g
d291bGQgd2FudCBpdCA6KA0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEkgdGhpbmsgdGhlIHJl
ZmVyZW5jZSB0byBBUkMgaXMgYSByZWQgaGVycmluZy4NCj4gPiA+ID4gPiA+IFRoZSByZWFsIGlz
c3VlIGlzIHRoYXQgYnVmZmVycyB1c2VkIGZvciBETUEgbWF5IG5vdCBoYXZlIHRoZSByZXF1aXJl
ZA0KPiA+ID4gPiA+ID4gYWxpZ25tZW50LCB3aGljaCBpcyBub3QgbGltaXRlZCB0byBBUkMgc3lz
dGVtcy4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBOb3RlIHRoYXQgSSdtIGFsc28gbm90IHN1
cGVyIGhhcHB5IHdpdGggdGhlIGV4dHJhIG1lbW9yeSB1c2FnZS4NCj4gPiA+ID4gPiA+IEJ1dCBk
ZXZtXyooKSBjb252ZW5pZW5jZXMgY29tZSB3aXRoIHRoZWlyIHBlbmFsdGllcy4uLg0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gSW50ZXJlc3RpbmcgdGhvdWdodC4NCj4gPiA+ID4gPiBDb3VsZCB0aGUg
ZGV2bSAnaGVhZGVyJyBiZSBwdXQgcmlnaHQgYXQgdGhlIGVuZCBvZiB0aGUga21hbGxvYygpDQo+
ID4gPiA+ID4gYnVmZmVyPw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVGhlbiB0aGUgZHJpdmVyIHdv
dWxkIGJlIGdpdmVuIGFsaWduZWQgYWRkcmVzcy4NCj4gPiA+ID4NCj4gPiA+ID4gWWVzLCBpZiB0
aGUgaGVhZGVyIGlzIGV4dGVuZGVkIHRvIGNvbnRhaW4gdGhlIHJlYWwgc3RhcnQgYWRkcmVzcyBv
ZiB0aGUNCj4gPiA+ID4gYWxsb2NhdGVkIGJsb2NrLg0KPiA+ID4NCj4gPiA+IEJ1dCB0aGF0IHdv
dWxkIGJyZWFrIGV4cGxpY2l0IGZyZWVpbmcgdGhyb3VnaCBkZXZtX2tmcmVlKCksIGFzIHRoYXQg
aXMNCj4gPiA+IHBhc3NlZCBhIHBvaW50ZXIgdG8gdGhlIHBheWxvYWQsIG5vdCB0aGUgaGVhZGVy
Lg0KPiA+DQo+ID4gVGhlcmUgaXMgYSBmdW5jdGlvbiB0aGF0IGdpdmVzIHRoZSBmdWxsIHNpemUg
b2YgbWVtb3J5IHRoYXQga21hbGxvYygpDQo+ID4gcmV0dXJucy4NCj4gPiBUaGF0IGNhbiBiZSB1
c2VkIHRvIGZpbmQgdGhlIGVuZCBhbmQgaGVuY2UgdGhlIGhlYWRlci4NCj4gDQo+IERvIHlvdSBr
bm93IHRoZSBuYW1lIG9mIHRoZSBmdW5jdGlvbj8NCg0Ka3NpemUoKSAtIHVzZWQgYnkgdGhlIHNr
YiBhbGxvY2F0aW5nIGNvZGUuDQoNCkkgZG9uJ3Qga25vdyBob3cgdGhlIGFsbCB0aGUgYWxsb2Nh
dG9ycyBiZWhhdmUuDQpTb21lIG1pZ2h0IGJlIGFkZGluZyBhIGhlYWRlciBhbnl3YXkgLSB3aGlj
aCBtaWdodCBhY3R1YWxseSBoYXZlDQpzcGFjZSBpdCBpbiB0aGF0IGRldm1fYWxsb2MgY291bGQg
dXNlLg0KDQpPVE9IIEkndmUgc2VlbiBrZXJuZWwgbWVtb3J5IGFsbG9jYXRvcnMgdGhhdCAoZWZm
ZWN0aXZlbHkpIHB1dA0KdGhlIGluZGV4IG9mIHRoZSBwb29sIGludG8gdGhlIHBhZ2UgdGFibGUu
DQpUaGV5IG5lZWQgbm8gcmVkIHRhcGUgYXQgYWxsLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJl
ZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXlu
ZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

