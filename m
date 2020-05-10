Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D4B1CCAA3
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 13:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgEJL7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 07:59:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:47675 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728677AbgEJL7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 07:59:22 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-236-yr5hR8jROKGsvosUIzCW6w-1; Sun, 10 May 2020 12:59:18 +0100
X-MC-Unique: yr5hR8jROKGsvosUIzCW6w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 10 May 2020 12:59:18 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 10 May 2020 12:59:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'H. Peter Anvin'" <hpa@zytor.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brian Gerst <brgerst@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Daniel Axtens <dja@axtens.net>,
        "Masahiro Yamada" <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] x86: bitops: fix build regression
Thread-Topic: [PATCH] x86: bitops: fix build regression
Thread-Index: AQHWJV6GnFcKS0TA9USbY8l3s67J1qihNCig
Date:   Sun, 10 May 2020 11:59:17 +0000
Message-ID: <b1072e7116774e0c9e6e7e6f55bae4a3@AcuMS.aculab.com>
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com>
 <20200507113422.GA3762@hirez.programming.kicks-ass.net>
 <CAMzpN2hXUYvLuTA63N56ef4DEzyWXt_uVVq6PV0r8YQT-YN42g@mail.gmail.com>
 <CAKwvOd=a3MR7osKBpbq=d41ieo7G9FtOp5Kok5por1P5ZS9s4g@mail.gmail.com>
 <CAKwvOd=Ogbp0oVgmF2B9cePjyWnvLLFRSp2EnaonA-ZFN3K7Dg@mail.gmail.com>
 <CAMzpN2gu4stkRKTsMTVxyzckO3SMhfA+dmCnSu6-aMg5QAA_JQ@mail.gmail.com>
 <CAKwvOd=hVKrFU+imSGeX+MEKMpW97gE7bzn1C637qdns9KSnUA@mail.gmail.com>
 <8f53b69e-86cc-7ff9-671e-5e0a67ff75a2@zytor.com>
In-Reply-To: <8f53b69e-86cc-7ff9-671e-5e0a67ff75a2@zytor.com>
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

RnJvbTogUGV0ZXIgQW52aW4NCj4gU2VudDogMDggTWF5IDIwMjAgMTg6MzINCj4gT24gMjAyMC0w
NS0wOCAxMDoyMSwgTmljayBEZXNhdWxuaWVycyB3cm90ZToNCj4gPj4NCj4gPj4gT25lIGxhc3Qg
c3VnZ2VzdGlvbi4gIEFkZCB0aGUgImIiIG1vZGlmaWVyIHRvIHRoZSBtYXNrIG9wZXJhbmQ6ICJv
cmINCj4gPj4gJWIxLCAlMCIuICBUaGF0IGZvcmNlcyB0aGUgY29tcGlsZXIgdG8gdXNlIHRoZSA4
LWJpdCByZWdpc3RlciBuYW1lDQo+ID4+IGluc3RlYWQgb2YgdHJ5aW5nIHRvIGRlZHVjZSB0aGUg
d2lkdGggZnJvbSB0aGUgaW5wdXQuDQo+ID4NCj4gPiBBaCByaWdodDogaHR0cHM6Ly9nY2MuZ251
Lm9yZy9vbmxpbmVkb2NzL2djYy9FeHRlbmRlZC1Bc20uaHRtbCN4ODZPcGVyYW5kbW9kaWZpZXJz
DQo+ID4NCj4gPiBMb29rcyBsaWtlIHRoYXQgd29ya3MgZm9yIGJvdGggY29tcGlsZXJzLiAgSW4g
dGhhdCBjYXNlLCB3ZSBjYW4gbGlrZWx5DQo+ID4gZHJvcCB0aGUgYCYgMHhmZmAsIHRvby4gIExl
dCBtZSBwbGF5IHdpdGggdGhhdCwgdGhlbiBJJ2xsIGhvcGVmdWxseQ0KPiA+IHNlbmQgYSB2MyB0
b2RheS4NCj4gPg0KPiANCj4gR29vZCBpZGVhLiBJIHJlcXVlc3RlZCBhIHdoaWxlIGFnbyB0aGF0
IHRoZXkgZG9jdW1lbnQgdGhlc2UgbW9kaWZpZXJzOyB0aGV5DQo+IGNob3NlIG5vdCB0byBkb2N1
bWVudCB0aGVtIGFsbCB3aGljaCBpbiBzb21lIHdheXMgaXMgZ29vZDsgaXQgc2hvd3Mgd2hhdCB0
aGV5DQo+IGFyZSB3aWxsaW5nIHRvIGNvbW1pdCB0byBpbmRlZmluaXRlbHkuDQoNCkkgdGhvdWdo
dCB0aGUgaW50ZW50aW9uIGhlcmUgd2FzIHRvIGV4cGxpY2l0bHkgZG8gYSBieXRlIGFjY2Vzcy4N
CklmIHRoZSBjb25zdGFudCBiaXQgbnVtYmVyIGhhcyBoYWQgYSBkaXYvbW9kIGJ5IDggZG9uZSBv
biBpdCB0aGVuDQp0aGUgYWRkcmVzcyBjYW4gYmUgbWlzYWxpZ25lZCAtIHNvIHlvdSBtdXN0bid0
IGRvIGEgbm9uLWJ5dGUgc2l6ZWQNCmxvY2tlZCBhY2Nlc3MuDQoNCk9UT0ggdGhlIG9yaWdpbmFs
IGJhc2UgYWRkcmVzcyBtdXN0IGJlIGFsaWduZWQuDQoNCkxvb2tpbmcgYXQgc29tZSBpbnN0cnVj
dGlvbiB0aW1pbmcsIEJUUy9CVFIgYXJlbid0IHRvbyBiYWQgaWYgdGhlDQpiaXQgbnVtYmVyIGlz
IGEgY29uc3RhbnQuIEJ1dCBhcmUgNiBvciA3IGNsb2NrcyBzbG93ZXIgaWYgaXQgaXMgaW4gJWNs
Lg0KR2l2ZW4gdGhlc2UgYXJlIGxvY2tlZCBSTVcgYnVzIGN5Y2xlcyB0aGV5J2xsIGFsd2F5cyBi
ZSBzbG93IQ0KDQpIb3cgYWJvdXQgYW4gYXNtIG11bHRpLXBhcnQgYWx0ZXJuYXRpdmUgdGhhdCB1
c2VzIGEgYnl0ZSBvZmZzZXQNCmFuZCBieXRlIGNvbnN0YW50IGlmIHRoZSBjb21waWxlciB0aGlu
a3MgdGhlIG1hc2sgaXMgY29uc3RhbnQNCm9yIGEgNC1ieXRlIG9mZnNldCBhbmQgMzJiaXQgbWFz
ayBpZiBpdCBkb2Vzbid0Lg0KDQpUaGUgb3RoZXIgYWx0ZXJuYXRpdmUgaXMgdG8ganVzdCB1c2Ug
QlRTL0JUUyBhbmQgKG1heWJlKSByZWx5IG9uIHRoZQ0KYXNzZW1ibGVyIHRvIGFkZCBpbiB0aGUg
d29yZCBvZmZzZXQgdG8gdGhlIGJhc2UgYWRkcmVzcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVy
ZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5
bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

