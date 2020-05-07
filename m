Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A271D1C84E4
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 10:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgEGIfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 04:35:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:48500 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbgEGIfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 04:35:05 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-42--XL0GonEN0uCYRKkZGNirQ-1; Thu, 07 May 2020 09:35:02 +0100
X-MC-Unique: -XL0GonEN0uCYRKkZGNirQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 7 May 2020 09:35:01 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 7 May 2020 09:35:01 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'hpa@zytor.com'" <hpa@zytor.com>,
        'Brian Gerst' <brgerst@gmail.com>,
        "Nick Desaulniers" <ndesaulniers@google.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        stable <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] x86: bitops: fix build regression
Thread-Topic: [PATCH] x86: bitops: fix build regression
Thread-Index: AQHWJDdSnFcKS0TA9USbY8l3s67J1qicPRAA///0fYCAABqNUA==
Date:   Thu, 7 May 2020 08:35:01 +0000
Message-ID: <ef7d077424554abebbd0d46738c90163@AcuMS.aculab.com>
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <CAMzpN2idWF2_4wtPebM2B2HVyksknr9hAqK8HJi_vjQ06bgu2g@mail.gmail.com>
 <60b16c05ca9e4954a7e4fcdd3075e23d@AcuMS.aculab.com>
 <7C32CF96-0519-4C32-B66B-23AD9C1F1F52@zytor.com>
In-Reply-To: <7C32CF96-0519-4C32-B66B-23AD9C1F1F52@zytor.com>
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

RnJvbTogaHBhQHp5dG9yLmNvbQ0KPiBTZW50OiAwNyBNYXkgMjAyMCAwODo1OQ0KPiBPbiBNYXkg
NywgMjAyMCAxMjo0NDo0NCBBTSBQRFQsIERhdmlkIExhaWdodCA8RGF2aWQuTGFpZ2h0QEFDVUxB
Qi5DT00+IHdyb3RlOg0KPiA+RnJvbTogQnJpYW4gR2Vyc3QNCj4gPj4gU2VudDogMDcgTWF5IDIw
MjAgMDc6MTgNCj4gPi4uLg0KPiA+PiA+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2JpdG9w
cy5oDQo+ID4+ID4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vYml0b3BzLmgNCj4gPj4gPiBA
QCAtNTQsNyArNTQsNyBAQCBhcmNoX3NldF9iaXQobG9uZyBuciwgdm9sYXRpbGUgdW5zaWduZWQg
bG9uZw0KPiA+KmFkZHIpDQo+ID4+ID4gICAgICAgICBpZiAoX19idWlsdGluX2NvbnN0YW50X3Ao
bnIpKSB7DQo+ID4+ID4gICAgICAgICAgICAgICAgIGFzbSB2b2xhdGlsZShMT0NLX1BSRUZJWCAi
b3JiICUxLCUwIg0KPiA+PiA+ICAgICAgICAgICAgICAgICAgICAgICAgIDogQ09OU1RfTUFTS19B
RERSKG5yLCBhZGRyKQ0KPiA+PiA+IC0gICAgICAgICAgICAgICAgICAgICAgIDogImlxIiAoQ09O
U1RfTUFTSyhucikgJiAweGZmKQ0KPiA+PiA+ICsgICAgICAgICAgICAgICAgICAgICAgIDogImlx
IiAoKHU4KShDT05TVF9NQVNLKG5yKSAmIDB4ZmYpKQ0KPiA+Pg0KPiA+PiBJIHRoaW5rIGEgYmV0
dGVyIGZpeCB3b3VsZCBiZSB0byBtYWtlIENPTlNUX01BU0soKSByZXR1cm4gYSB1OCB2YWx1ZQ0K
PiA+PiByYXRoZXIgdGhhbiBoYXZlIHRvIGNhc3Qgb24gZXZlcnkgdXNlLg0KPiA+DQo+ID5PciBh
c3NpZ24gdG8gYSBsb2NhbCB2YXJpYWJsZSAtIHRoZW4gaXQgZG9lc24ndCBtYXR0ZXIgaG93DQo+
ID50aGUgdmFsdWUgaXMgYWN0dWFsbHkgY2FsY3VsYXRlZC4gU286DQo+ID4JCQl1OCBtYXNrID0g
Q09OU1RfTUFTSyhucik7DQo+ID4JCQlhc20gdm9sYXRpbGUoTE9DS19QUkVGSVggIm9yYiAlMSwl
MCINCj4gPgkJCQk6IENPTlNUX01BU0tfQUREUihuciwgYWRkcikNCj4gPgkJCQk6ICJpcSIgbWFz
aw0KPiA+DQo+ID4JRGF2aWQNCj4gPg0KPiA+LQ0KPiA+UmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsDQo+ID5NSzEgMVBU
LCBVSw0KPiA+UmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCj4gDQo+ICJjb25zdCB1
OCIgcGxlYXNlLi4uDQoNCldoeSwganVzdCBhIHdhc3RlIG9mIGRpc2sgc3BhY2UuDQoNCglEYXZp
ZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQg
RmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4
NiAoV2FsZXMpDQo=

