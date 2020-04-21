Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D641B20FF
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 10:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgDUIF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 04:05:28 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:41113 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbgDUIF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 04:05:26 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-194-bOrZo3U0OfCgfC1rgonSRA-1; Tue, 21 Apr 2020 09:05:23 +0100
X-MC-Unique: bOrZo3U0OfCgfC1rgonSRA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 21 Apr 2020 09:05:22 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 21 Apr 2020 09:05:22 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ard Biesheuvel' <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FPU register granularity [Was: Re: [PATCH crypto-stable] crypto:
 arch/lib - limit simd usage to PAGE_SIZE chunks]
Thread-Topic: FPU register granularity [Was: Re: [PATCH crypto-stable] crypto:
 arch/lib - limit simd usage to PAGE_SIZE chunks]
Thread-Index: AQHWF6rUb3STV3+On0alUpvKAanXNqiDN3TA
Date:   Tue, 21 Apr 2020 08:05:22 +0000
Message-ID: <c9e0cabe2d6844ac9fc8c00f6bb3bc27@AcuMS.aculab.com>
References: <20200420075711.2385190-1-Jason@zx2c4.com>
 <2cdb57f2cdbd49e9bb1034d01d054bb7@AcuMS.aculab.com>
 <CAHmME9pq2Kdrp5C1+90PQyXsaG8xfdRwG-xGNs5U0ykVORrMbw@mail.gmail.com>
 <CAMj1kXEdWu1v0tGT2Co0oMqWDJS_FNx97qZJmp3GPrrj8MrnrQ@mail.gmail.com>
In-Reply-To: <CAMj1kXEdWu1v0tGT2Co0oMqWDJS_FNx97qZJmp3GPrrj8MrnrQ@mail.gmail.com>
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

RnJvbTogQXJkIEJpZXNoZXV2ZWwNCj4gU2VudDogMjEgQXByaWwgMjAyMCAwODowMg0KPiBPbiBU
dWUsIDIxIEFwciAyMDIwIGF0IDA2OjE1LCBKYXNvbiBBLiBEb25lbmZlbGQgPEphc29uQHp4MmM0
LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBIaSBEYXZpZCwNCj4gPg0KPiA+IE9uIE1vbiwgQXByIDIw
LCAyMDIwIGF0IDI6MzIgQU0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAYWN1bGFiLmNvbT4g
d3JvdGU6DQo+ID4gPiBNYXliZSBrZXJuZWxfZnBfYmVnaW4oKSBzaG91bGQgYmUgcGFzc2VkIHRo
ZSBhZGRyZXNzIG9mIHNvbWV3aGVyZQ0KPiA+ID4gdGhlIGFkZHJlc3Mgb2YgYW4gZnB1IHNhdmUg
YXJlYSBidWZmZXIgY2FuIGJlIHdyaXR0ZW4gdG8uDQo+ID4gPiBUaGVuIHRoZSBwcmUtZW1wdGlv
biBjb2RlIGNhbiBhbGxvY2F0ZSB0aGUgYnVmZmVyIGFuZCBzYXZlIHRoZQ0KPiA+ID4gc3RhdGUg
aW50byBpdC4NCj4gPg0KPiA+IEludGVyZXN0aW5nIGlkZWEuIEl0IGxvb2tzIGxpa2UgYHN0cnVj
dCB4cmVnc19zdGF0ZWAgaXMgb25seSA1NzYNCj4gPiBieXRlcy4gVGhhdCdzIG5vdCBleGFjdGx5
IHNtYWxsLCBidXQgaXQncyBub3QgaW5zYW5lbHkgaHVnZSBlaXRoZXIsDQo+ID4gYW5kIG1heWJl
IHdlIGNvdWxkIGp1c3RpZmlhYmx5IHN0aWNrIHRoYXQgb24gdGhlIHN0YWNrLCBvciBldmVuDQo+
ID4gcmVzZXJ2ZSBwYXJ0IG9mIHRoZSBzdGFjayBhbGxvY2F0aW9uIGZvciB0aGF0IHRoYXQgdGhl
IGZ1bmN0aW9uIHdvdWxkDQo+ID4ga25vdyBhYm91dCwgd2l0aG91dCBuZWVkaW5nIHRvIHNwZWNp
ZnkgYW55IGFkZHJlc3MuDQo+ID4NCj4gPiA+IGtlcm5lbF9mcHVfYmVnaW4oKSBvdWdodCBhbHNv
IGJlIHBhc3NlZCBhIHBhcmFtZXRlciBzYXlpbmcgd2hpY2gNCj4gPiA+IGZwdSBmZWF0dXJlcyBh
cmUgcmVxdWlyZWQsIGFuZCByZXR1cm4gd2hpY2ggYXJlIGFsbG9jYXRlZC4NCj4gPiA+IE9uIHg4
NiB0aGlzIGNvdWxkIGJlIHVzZWQgdG8gY2hlY2sgZm9yIEFWWDUxMiAoZXRjKSB3aGljaCBtYXkg
YmUNCj4gPiA+IGF2YWlsYWJsZSBpbiBhbiBJU1IgdW5sZXNzIGl0IGludGVycnVwdGVkIGluc2lk
ZSBhIGtlcm5lbF9mcHVfYmVnaW4oKQ0KPiA+ID4gc2VjdGlvbiAoZXRjKS4NCj4gPiA+IEl0IHdv
dWxkIGFsc28gYWxsb3cgb3B0aW1pc2F0aW9ucyBpZiBvbmx5IDEgb3IgMiBmcHUgcmVnaXN0ZXJz
IGFyZQ0KPiA+ID4gbmVlZGVkIChlZyBmb3Igc29tZSBvZiB0aGUgY3J5cHRvIGZ1bmN0aW9ucykg
cmF0aGVyIHRoYW4gdGhlIHdob2xlDQo+ID4gPiBmcHUgcmVnaXN0ZXIgc2V0Lg0KPiA+DQo+ID4g
Rm9yIEFWWDUxMiB0aGlzIHByb2JhYmx5IG1ha2VzIHNlbnNlLCBJIHN1cHBvc2UuIEJ1dCBJJ20g
bm90IHN1cmUgaWYNCj4gPiB0aGVyZSBhcmUgdG9vIG1hbnkgYml0cyBvZiBjcnlwdG8gY29kZSB0
aGF0IG9ubHkgdXNlIGEgZmV3IHJlZ2lzdGVycy4NCj4gPiBUaGVyZSBhcmUgdGhvc2UgYWNjZWxl
cmF0ZWQgbWVtY3B5IHJvdXRpbmVzIGluIGk5MTUgdGhvdWdoIC0tIGV2ZXIgc2VlDQo+ID4gZHJp
dmVycy9ncHUvZHJtL2k5MTUvaTkxNV9tZW1jcHkuYz8gc29ydCBvZiB3aWxkLiBCdXQgaWYgd2Ug
ZGlkIGdvDQo+ID4gdGhpcyB3YXksIEkgd29uZGVyIGlmIGl0J2QgbWFrZSBzZW5zZSB0byB0b3Rh
bGx5IG92ZXJlbmdpbmVlciBpdCBhbmQNCj4gPiB3cml0ZSBhIGdjYy9hcyBwbHVnaW4gdG8gY3Jl
YXRlIHRoZSByZWdpc3RlciBtYXNrIGZvciB1cy4gT3IsIG1heWJlDQo+ID4gc29tZSBjaGVja2Vy
IGluc2lkZSBvZiBvYmp0b29sIGNvdWxkIGhlbHAgaGVyZS4NCj4gPg0KPiA+IEFjdHVhbGx5LCB0
aG91Z2gsIHRoZSB0aGluZyBJJ3ZlIGJlZW4gd29uZGVyaW5nIGFib3V0IGlzIGFjdHVhbGx5DQo+
ID4gbW92aW5nIGluIHRoZSBjb21wbGV0ZSBvcHBvc2l0ZSBkaXJlY3Rpb246IGlzIHRoZXJlIHNv
bWUNCj4gPiBlZmZpY2llbnQtZW5vdWdoIHdheSB0aGF0IHdlIGNvdWxkIGFsbG93IEZQVSByZWdp
c3RlcnMgaW4gYWxsIGNvbnRleHRzDQo+ID4gYWx3YXlzLCB3aXRob3V0IHRoZSBuZWVkIGZvciBr
ZXJuZWxfZnB1X2JlZ2luL2VuZD8gSSB3YXMgcmV2ZXJzaW5nDQo+ID4gbnRvc2tybmwuZXhlIGFu
ZCB3YXMga2luZCBvZiBpbXByZXNzZWQgKG1heWJlIG5vdCB0aGUgcmlnaHQgd29yZD8pIGJ5DQo+
ID4gdGhlaXIganVkaWNpb3VzIHVzZSBvZiB2ZWN0b3Jpc2F0aW9uIGV2ZXJ5d2hlcmUuIEkgYXNz
dW1lIGEgbG90IG9mDQo+ID4gdGhhdCBpcyBiZWluZyBnZW5lcmF0ZWQgYnkgdGhlaXIgY29tcGls
ZXIsIHdoaWNoIG9mIGNvdXJzZSBnY2MgY291bGQNCj4gPiBkbyBmb3IgdXMgaWYgd2UgbGV0IGl0
LiBJcyB0aGF0IGFuIGludGVyZXN0aW5nIGF2ZW51ZSB0byBjb25zaWRlcj8gT3INCj4gPiBhcmUg
eW91IHByZXR0eSBjZXJ0YWluIHRoYXQgaXQnZCBiZSBhIGh1Z2UgbWlzdGFrZSwgd2l0aCBhbg0K
PiA+IGlycmV2ZXJzaWJsZSBzcGVlZCBoaXQ/DQo+ID4NCj4gDQo+IFdoZW4gSSBhZGRlZCBzdXBw
b3J0IGZvciBrZXJuZWwgbW9kZSBTSU1EIHRvIGFybTY0IG9yaWdpbmFsbHksIHRoZXJlDQo+IHdh
cyBhIGtlcm5lbF9uZW9uX2JlZ2luX3BhcnRpYWwoKSB0aGF0IHRvb2sgYW4gaW50IHRvIHNwZWNp
ZnkgaG93IG1hbnkNCj4gcmVnaXN0ZXJzIHdlcmUgYmVpbmcgdXNlZCwgdGhlIHJlYXNvbiBiZWlu
ZyB0aGF0IE5FT04gcHJlc2VydmUvc3RvcmUNCj4gd2FzIGZ1bGx5IGVhZ2VyIGF0IHRoaXMgcG9p
bnQsIGFuZCBhcm02NCBoYXMgMzIgU0lNRCByZWdpc3RlcnMsIG1hbnkNCj4gb2Ygd2hpY2ggd2Vy
ZW4ndCByZWFsbHkgdXNlZCwgZS5nLiwgaW4gdGhlIGJhc2ljIGltcGxlbWVudGF0aW9uIG9mIEFF
Uw0KPiBiYXNlZCBvbiBzcGVjaWFsIGluc3RydWN0aW9ucy4NCj4gDQo+IFdpdGggdGhlIGludHJv
ZHVjdGlvbiBvZiBsYXp5IHJlc3RvcmUsIGFuZCBTVkUgaGFuZGxpbmcgZm9yIHVzZXJzcGFjZSwN
Cj4gd2UgZGVjaWRlZCB0byByZW1vdmUgdGhpcyBiZWNhdXNlIGl0IGRpZG4ndCByZWFsbHkgaGVs
cCBhbnltb3JlLCBhbmQNCj4gbWFkZSB0aGUgY29kZSBtb3JlIGRpZmZpY3VsdCB0byBtYW5hZ2Uu
DQo+IA0KPiBIb3dldmVyLCBJIHRoaW5rIGl0IHdvdWxkIG1ha2Ugc2Vuc2UgdG8gaGF2ZSBzb21l
dGhpbmcgbGlrZSB0aGlzIGluDQo+IHRoZSBnZW5lcmFsIGNhc2UuIEkuZS4sIE5FT04gcmVnaXN0
ZXJzIDAtMyBhcmUgYWx3YXlzIHByZXNlcnZlZCB3aGVuDQo+IGFuIGV4Y2VwdGlvbiBvciBpbnRl
cnJ1cHQgKG9yIHN5c2NhbGwpIGlzIHRha2VuLCBhbmQgc28gdGhleSBjYW4gYmUNCj4gdXNlZCBh
bnl3aGVyZSBpbiB0aGUga2VybmVsLiBJZiB5b3Ugd2FudCB0aGUgd2hvbGUgc2V0LCB5b3Ugd2ls
bCBoYXZlDQo+IHRvIHVzZSBiZWdpbi9lbmQgYXMgYmVmb3JlLiBUaGlzIHdvdWxkIGFscmVhZHkg
dW5sb2NrIGEgZmV3DQo+IGludGVyZXN0aW5nIGNhc2UsIGxpa2UgbWVtY3B5LCB4b3IsIGFuZCBz
ZXF1ZW5jZXMgdGhhdCBjYW4gZWFzaWx5IGJlDQo+IGltcGxlbWVudGVkIHdpdGggb25seSBhIGZl
dyByZWdpc3RlcnMgc3VjaCBhcyBpbnN0cnVjdGlvIGJhc2VkIEFFUy4NCj4gDQo+IFVuZm9ydHVu
YXRlbHksIHRoZSBjb21waWxlciBuZWVkcyB0byBiZSB0YXVnaHQgYWJvdXQgdGhpcyB0byBiZQ0K
PiBjb21wbGV0ZWx5IHVzZWZ1bCwgd2hpY2ggbWVhbnMgbG90cyBvZiBwcm90b3R5cGluZyBhbmQg
YmVuY2htYXJraW5nDQo+IHVwZnJvbnQsIGFzIHRoZSBjb250cmFjdCB3aWxsIGJlIHNldCBpbiBz
dG9uZSBvbmNlIHRoZSBjb21waWxlcnMgZ2V0DQo+IG9uIGJvYXJkLg0KDQpZb3UgY2FuIGFsd2F5
cyBqdXN0IHVzZSBhc20gd2l0aCBleHBsaWNpdCByZWdpc3RlcnMuDQoNCglEYXZpZA0KDQotDQpS
ZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWls
dG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMp
DQo=

