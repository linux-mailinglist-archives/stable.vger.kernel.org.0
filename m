Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9DA15728C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 11:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJKIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 05:08:44 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:52024 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727178AbgBJKIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 05:08:44 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-35-OkSbDDqcMICduAibaIeR0w-1; Mon, 10 Feb 2020 10:08:39 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 10 Feb 2020 10:08:39 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 10 Feb 2020 10:08:39 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andy Shevchenko' <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
CC:     Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "Gayatri Kammela" <gayatri.kammela@intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: RE: [PATCH v3 3/3] x86/tsc_msr: Make MSR derived TSC frequency more
 accurate
Thread-Topic: [PATCH v3 3/3] x86/tsc_msr: Make MSR derived TSC frequency more
 accurate
Thread-Index: AQHV3gOblm6xQxu9fka+It/mQyyf3KgUN73A
Date:   Mon, 10 Feb 2020 10:08:38 +0000
Message-ID: <7486ebeb98bd44d4a50fb6f2df4799df@AcuMS.aculab.com>
References: <20200207205456.113758-1-hdegoede@redhat.com>
 <20200207205456.113758-3-hdegoede@redhat.com>
 <CAHp75VcEKS_XkdfqnydF3KgeH=Fk_9GyQfcmrs6D9rJbTuKstw@mail.gmail.com>
In-Reply-To: <CAHp75VcEKS_XkdfqnydF3KgeH=Fk_9GyQfcmrs6D9rJbTuKstw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: OkSbDDqcMICduAibaIeR0w-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQW5keSBTaGV2Y2hlbmtvDQo+IFNlbnQ6IDA3IEZlYnJ1YXJ5IDIwMjAgMjI6MTINCj4g
T24gRnJpLCBGZWIgNywgMjAyMCBhdCAxMDo1NSBQTSBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUBy
ZWRoYXQuY29tPiB3cm90ZToNCj4gPg0KPiA+IFRoZSAiSW50ZWwgNjQgYW5kIElBLTMyIEFyY2hp
dGVjdHVyZXMgU29mdHdhcmUgRGV2ZWxvcGVy4oCZcyBNYW51YWwNCj4gPiBWb2x1bWUgNDogTW9k
ZWwtU3BlY2lmaWMgUmVnaXN0ZXJzIiBoYXMgdGhlIGZvbGxvd2luZyB0YWJsZSBmb3IgdGhlDQo+
ID4gdmFsdWVzIGZyb20gZnJlcV9kZXNjX2J5dDoNCj4gDQo+IEZvciB0aGUgTEdNIHBlb3BsZSBp
biBDYyBsaXN0LiBIYW5zIGluY2x1ZGVkIHlvdSBpbiBvcmRlciB0byBjb25maXJtDQo+IHdoYXQn
cyBnb2luZyBvbiB3aXRoIFRTQyBvbiBMR00gU29DLg0KPiBDYW4geW91IGRvIGl0IGluIGEgd2F5
IHRoYXQgd2UgY2VydGFpbmx5IGtub3cgY2xvY2tzIHdpdGggZ29vZA0KPiBwcmVjaXNpb24gKGFu
ZCBpZiBTcHJlYWQgU3BlY3RydW0gaXMgaW4gdXNlIHdoYXQgc2hvdWxkIHdlIHB1dCBoZXJlKT8N
Cg0KSXNuJ3QgJ1NwcmVhZCBTcGVjdHJ1bScganVzdCBhIHNjYW0gc28gdGhhdCB0aGUgcmVzb25h
bnQgZGV0ZWN0b3INCnVzZWQgYnkgdGhlIHRlc3QgZXF1aXBtZW50IGZhaWxzIHRvIHJlZ2lzdGVy
IGFueXRoaW5nPw0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBC
cmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdp
c3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

