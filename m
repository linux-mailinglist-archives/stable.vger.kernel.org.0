Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A45160A9
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 11:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfEGJSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 05:18:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:33010 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbfEGJSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 05:18:55 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-180-vfktmACVNDKgwMnn5zucnQ-1; Tue, 07 May 2019 10:18:52 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 7 May 2019 10:18:51 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 7 May 2019 10:18:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Zijlstra' <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Nicolai Stange" <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: RE: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Thread-Topic: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Thread-Index: AQHVBLOOpe57oOoUm0iPpfi6TWW3V6ZfXgyA
Date:   Tue, 7 May 2019 09:18:51 +0000
Message-ID: <b34aa38bdfe84263bc20b60761bf6005@AcuMS.aculab.com>
References: <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
 <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home>
 <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
 <20190507085753.GO2606@hirez.programming.kicks-ass.net>
In-Reply-To: <20190507085753.GO2606@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: vfktmACVNDKgwMnn5zucnQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogUGV0ZXIgWmlqbHN0cmENCj4gU2VudDogMDcgTWF5IDIwMTkgMDk6NTgNCi4uLg0KPiAr
CS8qDQo+ICsJICogV2hlbiB3ZSdyZSBoZXJlIGZyb20ga2VybmVsIG1vZGU7IHRoZSAoZXhjZXB0
aW9uKSBzdGFjayBsb29rcyBsaWtlOg0KPiArCSAqDQo+ICsJICogNCo0KCVlc3ApIC0gPHByZXZp
b3VzIGNvbnRleHQ+DQo+ICsJICogMyo0KCVlc3ApIC0gZmxhZ3MNCj4gKwkgKiAyKjQoJWVzcCkg
LSBjcw0KPiArCSAqIDEqNCglZXNwKSAtIGlwDQo+ICsJICogMCo0KCVlc3ApIC0gb3JpZ19lYXgN
Cg0KQW0gSSByaWdodCBpbiB0aGlua2luZyB0aGF0IHRoaXMgaXMgdGhlIG9ubHkgJ0lOVDMnIHN0
YWNrIGZyYW1lIHRoYXQNCm5lZWRzIHRvIGJlICdmaWRkbGVkJyB3aXRoPw0KQW5kIHRoYXQgdGhl
ICdlbXVsYXRlIGEgY2FsbCBpbnN0cnVjdGlvbicgaGFzIHZlcmlmaWVkIHRoYXQgaXMgdGhlIGNh
c2U/Pw0KU28gdGhlICVjcyBpcyBhbHdheXMgdGhlIGtlcm5lbCAlY3MuDQoNCklmIHRoZSAnY2Fs
bCB0YXJnZXQnIGFkZHJlc3MgaXMgc2F2ZWQgaW4gYSBwZXItY3B1IGxvY2F0aW9uIGl0IG91Z2h0
DQp0byBiZSBwb3NzaWJsZSB0byBnZXQgdGhlIGNvZGUgdGhhdCByZXR1cm5zIGZyb20gdGhlIElO
VDMgd2l0aCB0aGUNCmNhbGwgdGFyZ2V0IGFkZHJlc3MgKG9yIHplcm8pIGluICVheC4NCklmIG5v
bi16ZXJvLCBpbnN0ZWFkIG9mICdwb3AgJWF4OyBpcmV0JyBleGVjdXRlOg0KCXhjaGcgJWVheCwg
NCglZXNwKSAgIC0gc3dhcCBmdW5jdGlvbiBhZGRyZXNzIGFuZCBjYWxsZXJzIGlwDQoJcHVzaCAx
MiglZXNwKSAgICAgICAgLSBvbGQgZmxhZ3MNCgltb3YgIDE0KCVlc3ApLCVlYXggICAtIGNhbGxl
cnMgYWRkcmVzcyBvdmVyIGZsYWdzDQoJcG9wZiAgICAgICAgICAgICAgICAgLSBlbmFibGVzIGlu
dGVycnVwdHMgKGV0YykNCglwb3AgICVlYXgNCglyZXRmICAgICAgICAgICAgICAgICAtIEp1bXAg
dG8gY2FsbGVkIGZ1bmN0aW9uIGFuZCByZW1vdmUgJWNzDQoNCk5vdGhpbmcgZWxzZSBuZWVkcyB0
byBiZSBtb3ZlZC4NCg0KCURhdmlkDQoNCgkNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

