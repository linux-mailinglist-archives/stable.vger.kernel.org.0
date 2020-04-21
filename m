Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498511B2163
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 10:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgDUISE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 04:18:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:33424 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbgDUISD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 04:18:03 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-45-R6erxUPxNwmDnj4dVoOApw-1; Tue, 21 Apr 2020 09:11:10 +0100
X-MC-Unique: R6erxUPxNwmDnj4dVoOApw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 21 Apr 2020 09:11:10 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 21 Apr 2020 09:11:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FPU register granularity [Was: Re: [PATCH crypto-stable] crypto:
 arch/lib - limit simd usage to PAGE_SIZE chunks]
Thread-Topic: FPU register granularity [Was: Re: [PATCH crypto-stable] crypto:
 arch/lib - limit simd usage to PAGE_SIZE chunks]
Thread-Index: AQHWF5Nwrne9SiRX+kyNbDVRZjwXoqiDOD6g
Date:   Tue, 21 Apr 2020 08:11:10 +0000
Message-ID: <77009e0fb2fd442791fa192841a1ae16@AcuMS.aculab.com>
References: <20200420075711.2385190-1-Jason@zx2c4.com>
 <2cdb57f2cdbd49e9bb1034d01d054bb7@AcuMS.aculab.com>
 <CAHmME9pq2Kdrp5C1+90PQyXsaG8xfdRwG-xGNs5U0ykVORrMbw@mail.gmail.com>
In-Reply-To: <CAHmME9pq2Kdrp5C1+90PQyXsaG8xfdRwG-xGNs5U0ykVORrMbw@mail.gmail.com>
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

RnJvbTogSmFzb24gQS4gRG9uZW5mZWxkDQo+IFNlbnQ6IDIxIEFwcmlsIDIwMjAgMDU6MTUNCj4g
DQo+IEhpIERhdmlkLA0KPiANCj4gT24gTW9uLCBBcHIgMjAsIDIwMjAgYXQgMjozMiBBTSBEYXZp
ZCBMYWlnaHQgPERhdmlkLkxhaWdodEBhY3VsYWIuY29tPiB3cm90ZToNCj4gPiBNYXliZSBrZXJu
ZWxfZnBfYmVnaW4oKSBzaG91bGQgYmUgcGFzc2VkIHRoZSBhZGRyZXNzIG9mIHNvbWV3aGVyZQ0K
PiA+IHRoZSBhZGRyZXNzIG9mIGFuIGZwdSBzYXZlIGFyZWEgYnVmZmVyIGNhbiBiZSB3cml0dGVu
IHRvLg0KPiA+IFRoZW4gdGhlIHByZS1lbXB0aW9uIGNvZGUgY2FuIGFsbG9jYXRlIHRoZSBidWZm
ZXIgYW5kIHNhdmUgdGhlDQo+ID4gc3RhdGUgaW50byBpdC4NCj4gDQo+IEludGVyZXN0aW5nIGlk
ZWEuIEl0IGxvb2tzIGxpa2UgYHN0cnVjdCB4cmVnc19zdGF0ZWAgaXMgb25seSA1NzYNCj4gYnl0
ZXMuIFRoYXQncyBub3QgZXhhY3RseSBzbWFsbCwgYnV0IGl0J3Mgbm90IGluc2FuZWx5IGh1Z2Ug
ZWl0aGVyLA0KPiBhbmQgbWF5YmUgd2UgY291bGQganVzdGlmaWFibHkgc3RpY2sgdGhhdCBvbiB0
aGUgc3RhY2ssIG9yIGV2ZW4NCj4gcmVzZXJ2ZSBwYXJ0IG9mIHRoZSBzdGFjayBhbGxvY2F0aW9u
IGZvciB0aGF0IHRoYXQgdGhlIGZ1bmN0aW9uIHdvdWxkDQo+IGtub3cgYWJvdXQsIHdpdGhvdXQg
bmVlZGluZyB0byBzcGVjaWZ5IGFueSBhZGRyZXNzLg0KDQpBcyB5b3Ugc2FpZCB5b3Vyc2VsZiwg
d2l0aCBBVlg1MTIgaXQgaXMgbXVjaCBsYXJnZXIuDQpXaGljaCBpcyB3aHkgSSBzdWdnZXN0ZWQg
dGhlIHNhdmUgY29kZSBjb3VsZCBhbGxvY2F0ZSB0aGUgYXJlYS4NCk5vdGUgdGhhdCB0aGlzIHdv
dWxkIG9ubHkgYmUgbmVlZGVkIGZvciBuZXN0ZWQgdXNlIChmb3IgYSBmdWxsIHNhdmUpLg0KDQo+
ID4ga2VybmVsX2ZwdV9iZWdpbigpIG91Z2h0IGFsc28gYmUgcGFzc2VkIGEgcGFyYW1ldGVyIHNh
eWluZyB3aGljaA0KPiA+IGZwdSBmZWF0dXJlcyBhcmUgcmVxdWlyZWQsIGFuZCByZXR1cm4gd2hp
Y2ggYXJlIGFsbG9jYXRlZC4NCj4gPiBPbiB4ODYgdGhpcyBjb3VsZCBiZSB1c2VkIHRvIGNoZWNr
IGZvciBBVlg1MTIgKGV0Yykgd2hpY2ggbWF5IGJlDQo+ID4gYXZhaWxhYmxlIGluIGFuIElTUiB1
bmxlc3MgaXQgaW50ZXJydXB0ZWQgaW5zaWRlIGEga2VybmVsX2ZwdV9iZWdpbigpDQo+ID4gc2Vj
dGlvbiAoZXRjKS4NCj4gPiBJdCB3b3VsZCBhbHNvIGFsbG93IG9wdGltaXNhdGlvbnMgaWYgb25s
eSAxIG9yIDIgZnB1IHJlZ2lzdGVycyBhcmUNCj4gPiBuZWVkZWQgKGVnIGZvciBzb21lIG9mIHRo
ZSBjcnlwdG8gZnVuY3Rpb25zKSByYXRoZXIgdGhhbiB0aGUgd2hvbGUNCj4gPiBmcHUgcmVnaXN0
ZXIgc2V0Lg0KPiANCj4gRm9yIEFWWDUxMiB0aGlzIHByb2JhYmx5IG1ha2VzIHNlbnNlLCBJIHN1
cHBvc2UuIEJ1dCBJJ20gbm90IHN1cmUgaWYNCj4gdGhlcmUgYXJlIHRvbyBtYW55IGJpdHMgb2Yg
Y3J5cHRvIGNvZGUgdGhhdCBvbmx5IHVzZSBhIGZldyByZWdpc3RlcnMuDQo+IFRoZXJlIGFyZSB0
aG9zZSBhY2NlbGVyYXRlZCBtZW1jcHkgcm91dGluZXMgaW4gaTkxNSB0aG91Z2ggLS0gZXZlciBz
ZWUNCj4gZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9tZW1jcHkuYz8gc29ydCBvZiB3aWxkLiBC
dXQgaWYgd2UgZGlkIGdvDQo+IHRoaXMgd2F5LCBJIHdvbmRlciBpZiBpdCdkIG1ha2Ugc2Vuc2Ug
dG8gdG90YWxseSBvdmVyZW5naW5lZXIgaXQgYW5kDQo+IHdyaXRlIGEgZ2NjL2FzIHBsdWdpbiB0
byBjcmVhdGUgdGhlIHJlZ2lzdGVyIG1hc2sgZm9yIHVzLiBPciwgbWF5YmUNCj4gc29tZSBjaGVj
a2VyIGluc2lkZSBvZiBvYmp0b29sIGNvdWxkIGhlbHAgaGVyZS4NCg0KSSBzdXNwZWN0IHNvbWUg
b2YgdGhhdCBjb2RlIGlzIG92ZXJseSB1bnJvbGxlZC4NCg0KPiBBY3R1YWxseSwgdGhvdWdoLCB0
aGUgdGhpbmcgSSd2ZSBiZWVuIHdvbmRlcmluZyBhYm91dCBpcyBhY3R1YWxseQ0KPiBtb3Zpbmcg
aW4gdGhlIGNvbXBsZXRlIG9wcG9zaXRlIGRpcmVjdGlvbjogaXMgdGhlcmUgc29tZQ0KPiBlZmZp
Y2llbnQtZW5vdWdoIHdheSB0aGF0IHdlIGNvdWxkIGFsbG93IEZQVSByZWdpc3RlcnMgaW4gYWxs
IGNvbnRleHRzDQo+IGFsd2F5cywgd2l0aG91dCB0aGUgbmVlZCBmb3Iga2VybmVsX2ZwdV9iZWdp
bi9lbmQ/IEkgd2FzIHJldmVyc2luZw0KPiBudG9za3JubC5leGUgYW5kIHdhcyBraW5kIG9mIGlt
cHJlc3NlZCAobWF5YmUgbm90IHRoZSByaWdodCB3b3JkPykgYnkNCj4gdGhlaXIganVkaWNpb3Vz
IHVzZSBvZiB2ZWN0b3Jpc2F0aW9uIGV2ZXJ5d2hlcmUuIEkgYXNzdW1lIGEgbG90IG9mDQo+IHRo
YXQgaXMgYmVpbmcgZ2VuZXJhdGVkIGJ5IHRoZWlyIGNvbXBpbGVyLCB3aGljaCBvZiBjb3Vyc2Ug
Z2NjIGNvdWxkDQo+IGRvIGZvciB1cyBpZiB3ZSBsZXQgaXQuIElzIHRoYXQgYW4gaW50ZXJlc3Rp
bmcgYXZlbnVlIHRvIGNvbnNpZGVyPyBPcg0KPiBhcmUgeW91IHByZXR0eSBjZXJ0YWluIHRoYXQg
aXQnZCBiZSBhIGh1Z2UgbWlzdGFrZSwgd2l0aCBhbg0KPiBpcnJldmVyc2libGUgc3BlZWQgaGl0
Pw0KDQoNCkkgdGhpbmsgd2luZG93cyB0YWtlcyB0aGUgJ2hpdCcgb2Ygc2F2aW5nIHRoZSBlbnRp
cmUgZnB1IHN0YXRlIG9uDQpldmVyeSBrZXJuZWwgZW50cnkuDQpOb3RlIHRoYXQgZm9yIHN5c3Rl
bSBjYWxscyB0aGlzIGlzIGFjdHVhbGx5IG1pbmltYWwuDQpBbGwgdGhlICdjYWxsZWUgc2F2ZWQn
IHJlZ2lzdGVycyAobW9zdCBvZiB0aGUgZnB1IG9uZXMpIGNhbiBiZQ0KdHJhc2hlZCAtIGllIHJl
bG9hZGVkIHdpdGggemVyb3MuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFr
ZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwg
VUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

