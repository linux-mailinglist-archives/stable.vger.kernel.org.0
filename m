Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCBF1DB84D
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 17:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgETPdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 11:33:31 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:24756 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726851AbgETPdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 11:33:31 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-22-rP6gYl4LNfyrcK7WuRHs9w-1; Wed, 20 May 2020 16:33:27 +0100
X-MC-Unique: rP6gYl4LNfyrcK7WuRHs9w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 20 May 2020 16:33:27 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 20 May 2020 16:33:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Dan Williams' <dan.j.williams@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "X86 ML" <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: RE: [PATCH v3 1/2] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
Thread-Topic: [PATCH v3 1/2] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
Thread-Index: AQHWLrr3OGthQXUtsU6REk+fDuiGdKixGiVw
Date:   Wed, 20 May 2020 15:33:27 +0000
Message-ID: <380699aca2424f5ab1fb55c220350908@AcuMS.aculab.com>
References: <158992635164.403910.2616621400995359522.stgit@dwillia2-desk3.amr.corp.intel.com>
 <158992635697.403910.6957168747147028694.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87d06z7x1a.fsf@mpe.ellerman.id.au>
 <CAPcyv4igM-jK6OkPzd91ur_fNCaUxwbWTHhwWsWe-PJNjZdWGw@mail.gmail.com>
In-Reply-To: <CAPcyv4igM-jK6OkPzd91ur_fNCaUxwbWTHhwWsWe-PJNjZdWGw@mail.gmail.com>
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

RnJvbTogRGFuIFdpbGxpYW1zDQo+IFNlbnQ6IDIwIE1heSAyMDIwIDE2OjI2DQouLi4NCj4gPiA+
ICsjaWZkZWYgQ09ORklHX0FSQ0hfSEFTX0NPUFlfTUMNCj4gPiA+ICtleHRlcm4gdW5zaWduZWQg
bG9uZyBfX211c3RfY2hlY2sNCj4gPg0KPiA+IFdlIHRyeSBub3QgdG8gYWRkIGV4dGVybiBpbiBo
ZWFkZXJzIGFueW1vcmUuDQo+IA0KPiBPaywgSSB3YXMgZG9pbmcgdGhlIGNvcHktcGFzdGEgZGFu
Y2UsIGJ1dCBJJ2xsIHJlbW92ZSB0aGlzLg0KDQpJdCBpcyBkYXRhIG5vdCBjb2RlLCBpdCBuZWVk
cyB0aGUgZXh0ZXJuIHRvIG5vdCBiZSAnY29tbW9uJy4NCk9UT0ggd2hhdCBpcyBhIGdsb2JhbCB2
YXJpYWJsZSBiZWluZyB1c2VkIGZvcj8NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVz
cyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEg
MVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

