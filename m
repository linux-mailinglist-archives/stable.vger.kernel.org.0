Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A591DB85D
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 17:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgETPey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 11:34:54 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:26253 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726688AbgETPey (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 11:34:54 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-228-m9nY-k74MOCgdXhj5Ly8FA-1; Wed, 20 May 2020 16:34:51 +0100
X-MC-Unique: m9nY-k74MOCgdXhj5Ly8FA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 20 May 2020 16:34:50 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 20 May 2020 16:34:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Dan Williams' <dan.j.williams@intel.com>,
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
Thread-Index: AQHWLrr3OGthQXUtsU6REk+fDuiGdKixGiVwgAAAsmA=
Date:   Wed, 20 May 2020 15:34:50 +0000
Message-ID: <6a7200e6c57843eb8c6c08db9f991064@AcuMS.aculab.com>
References: <158992635164.403910.2616621400995359522.stgit@dwillia2-desk3.amr.corp.intel.com>
 <158992635697.403910.6957168747147028694.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87d06z7x1a.fsf@mpe.ellerman.id.au>
 <CAPcyv4igM-jK6OkPzd91ur_fNCaUxwbWTHhwWsWe-PJNjZdWGw@mail.gmail.com>
 <380699aca2424f5ab1fb55c220350908@AcuMS.aculab.com>
In-Reply-To: <380699aca2424f5ab1fb55c220350908@AcuMS.aculab.com>
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

PiBGcm9tOiBEYW4gV2lsbGlhbXMNCj4gPiBTZW50OiAyMCBNYXkgMjAyMCAxNjoyNg0KPiAuLi4N
Cj4gPiA+ID4gKyNpZmRlZiBDT05GSUdfQVJDSF9IQVNfQ09QWV9NQw0KPiA+ID4gPiArZXh0ZXJu
IHVuc2lnbmVkIGxvbmcgX19tdXN0X2NoZWNrDQo+ID4gPg0KPiA+ID4gV2UgdHJ5IG5vdCB0byBh
ZGQgZXh0ZXJuIGluIGhlYWRlcnMgYW55bW9yZS4NCj4gPg0KPiA+IE9rLCBJIHdhcyBkb2luZyB0
aGUgY29weS1wYXN0YSBkYW5jZSwgYnV0IEknbGwgcmVtb3ZlIHRoaXMuDQo+IA0KPiBJdCBpcyBk
YXRhIG5vdCBjb2RlLCBpdCBuZWVkcyB0aGUgZXh0ZXJuIHRvIG5vdCBiZSAnY29tbW9uJy4NCj4g
T1RPSCB3aGF0IGlzIGEgZ2xvYmFsIHZhcmlhYmxlIGJlaW5nIHVzZWQgZm9yPw0KDQpBYWFyZyBu
b3QgZW5vdWdoIGNvbnRleHQuLi4NCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBC
cmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdp
c3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

