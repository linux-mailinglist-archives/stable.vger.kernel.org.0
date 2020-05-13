Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3FA1D0F5C
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbgEMKKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:10:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:21708 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729917AbgEMKKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 06:10:08 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-13-KFmgqBnFMECGYcls_MgxEw-1; Wed, 13 May 2020 11:10:04 +0100
X-MC-Unique: KFmgqBnFMECGYcls_MgxEw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 13 May 2020 11:10:03 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 13 May 2020 11:10:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Geert Uytterhoeven' <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Lee Jones <lee.jones@linaro.org>, stable <stable@vger.kernel.org>,
        "Alexey Brodkin" <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Will Deacon" <will.deacon@arm.com>
Subject: RE: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Thread-Topic: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Thread-Index: AQHWKQu4HYgJHBu5S0KOdh+8IRi0tqilymPg
Date:   Wed, 13 May 2020 10:10:03 +0000
Message-ID: <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-4-lee.jones@linaro.org>
 <20200513093536.GB830571@kroah.com>
 <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
In-Reply-To: <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
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

RnJvbTogR2VlcnQgVXl0dGVyaG9ldmVuDQo+IFNlbnQ6IDEzIE1heSAyMDIwIDEwOjQ5DQouLi4N
Cj4gPiBJIGRvbid0IHdhbnQgdG8gYXBwbHkgdGhpcyB0byBvbGRlciBrZXJuZWxzIGFzIGl0IGNv
dWxkIGNhdXNlIGV4dHJhDQo+ID4gbWVtb3J5IHVzYWdlIGZvciBubyBnb29kIHJlYXNvbi4gIEkg
aGF2ZSBubyBpZGVhIHdoeSBhIG5vbiBBUkMgc3lzdGVtDQo+ID4gd291bGQgd2FudCBpdCA6KA0K
PiANCj4gSSB0aGluayB0aGUgcmVmZXJlbmNlIHRvIEFSQyBpcyBhIHJlZCBoZXJyaW5nLg0KPiBU
aGUgcmVhbCBpc3N1ZSBpcyB0aGF0IGJ1ZmZlcnMgdXNlZCBmb3IgRE1BIG1heSBub3QgaGF2ZSB0
aGUgcmVxdWlyZWQNCj4gYWxpZ25tZW50LCB3aGljaCBpcyBub3QgbGltaXRlZCB0byBBUkMgc3lz
dGVtcy4NCj4gDQo+IE5vdGUgdGhhdCBJJ20gYWxzbyBub3Qgc3VwZXIgaGFwcHkgd2l0aCB0aGUg
ZXh0cmEgbWVtb3J5IHVzYWdlLg0KPiBCdXQgZGV2bV8qKCkgY29udmVuaWVuY2VzIGNvbWUgd2l0
aCB0aGVpciBwZW5hbHRpZXMuLi4NCg0KSW50ZXJlc3RpbmcgdGhvdWdodC4NCkNvdWxkIHRoZSBk
ZXZtICdoZWFkZXInIGJlIHB1dCByaWdodCBhdCB0aGUgZW5kIG9mIHRoZSBrbWFsbG9jKCkNCmJ1
ZmZlcj8NCg0KVGhlbiB0aGUgZHJpdmVyIHdvdWxkIGJlIGdpdmVuIGFsaWduZWQgYWRkcmVzcy4N
Cg0KCURhdmlkDQogDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

