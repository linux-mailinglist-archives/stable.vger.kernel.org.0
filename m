Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6ADB2C1F6
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 11:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfE1JCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 05:02:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:50213 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbfE1JCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 05:02:35 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-92-RqQYt7MHN5K4Xjo0lCZlLQ-1; Tue, 28 May 2019 10:02:33 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 28 May 2019 10:02:32 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 28 May 2019 10:02:32 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Deepa Dinamani' <deepa.kernel@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Arnd Bergmann" <arnd@arndb.de>, "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        "Linux FS-devel Mailing List" <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Thread-Topic: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Thread-Index: AQHVELwtsgR+BAQFXk2JV68Wk/7LjKZ4aINAgABVkoCAAB2x0P///TgAgAARdkCAAZjWloAFvmIA
Date:   Tue, 28 May 2019 09:02:32 +0000
Message-ID: <72e07794bcba476f9cad948df2723362@AcuMS.aculab.com>
References: <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141054.GB2655@redhat.com>
 <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com>
 <20190524163310.GG2655@redhat.com>
 <CABeXuvrUKZnECj+NgLdpe5uhKBEmSynrakD-3q9XHqk8Aef5UQ@mail.gmail.com>
In-Reply-To: <CABeXuvrUKZnECj+NgLdpe5uhKBEmSynrakD-3q9XHqk8Aef5UQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: RqQYt7MHN5K4Xjo0lCZlLQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRGVlcGEgRGluYW1hbmkNCj4gU2VudDogMjQgTWF5IDIwMTkgMTg6MDINCi4uLg0KPiBN
YXliZSBhIGNydWRlIHVzZXJzcGFjZSBhcHBsaWNhdGlvbiBjb3VsZCBkbyBzb21ldGhpbmcgbGlr
ZSB0aGlzOg0KPiANCj4gc2lnX2hhbmRsZXIoKQ0KPiB7DQo+ICAgc2V0IGdsb2JhbCBhYm9ydCA9
IDENCj4gfQ0KPiANCj4gcG9sbF90aGVfZmRzKCkNCj4gew0KPiAgICAgICAgIHJldCA9IGVwb2xs
X3B3YWl0KCkNCj4gICAgICAgICBpZiAocmV0KQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIHJl
dA0KPiAgICAgICAgIGlmIChhYm9ydCkNCj4gICAgICAgICAgICAgICAgIC8vIGJ1dCB0aGlzIGFi
b3J0IHNob3VsZCBiZSBpZ25vcmVkIGlmIHJldCB3YXMgMC4NCj4gICAgICAgICAgICAgICAgIHJl
dHVybiB0cnlfYWdhaW4NCj4gDQo+IH0NCg0KQXMgYW4gYXBwbGljYXRpb24gd3JpdGVyIEknZCB3
YW50IHRvIHNlZSAnYWJvcnQgPT0gMScgZXZlbg0KaWYgZXBvbGxfcHdhaXQoKSByZXR1cm5lZCB0
aGF0IGFuIGZkIHdhcyAncmVhZHknLg0KDQpTbyB0aGUgY29kZSBhYm92ZSBzaG91bGQgcHJvYmFi
bHkgYmU6DQogICAgd2FpdF9hZ2FpbjoNCiAgICAgICAgcmV0ID0gZXBvbGxfcHdhaXQoKTsNCiAg
ICAgICAgaWYgKGFib3J0KQ0KICAgICAgICAgICAgcHJvY2Vzc19hYm9ydCgpOw0KICAgICAgICBp
ZiAocmV0IDw9IDApIHsNCiAgICAgICAgICAgIGlmIChyZXQgPT0gMCkNCiAgICAgICAgICAgICAg
ICBwcm9jZXNzX3RpbWVvdXQoKTsNCiAgICAgICAgICAgIGlmIChyZXQgPT0gMCB8fCBlcnJubyA9
PSBFSU5UUikNCiAgICAgICAgICAgICAgICBnb3RvIHdhaXRfYWdhaW47DQogICAgICAgICAgICAv
LyBTb21ldGhpbmcgd2VudCBob3JyaWJseSB3cm9uZyBpbiBlcG9sbF9wd2FpdCgpDQogICAgICAg
ICAgICByZXR1cm4gcmV0Ow0KICAgICAgICB9DQogICAgICAgIC8vIHByb2Nlc3MgdGhlICdyZWFk
eScgZmRzDQoNCkl0IHdvdWxkIGJlIG5vbi11bnJlYXNvbmFibGUgZm9yIHRoZSBhcHBsaWNhdGlv
biB0byBoYXZlDQphbGwgc2lnbmFscyBibG9ja2VkIGV4Y2VwdCBkdXJpbmcgdGhlIGVwb2xsX3B3
YWl0KCkuDQpTbyB0aGUgYXBwbGljYXRpb24gbmVlZHMgdGhlIHNpZ25hbCBoYW5kbGVyIGZvciBT
SUdfSU5UIChldGMpDQp0byBiZSBjYWxsZWQgZXZlbiBpZiBvbmUgb2YgdGhlIGZkIGlzIGFsd2F5
cyAncmVhZHknLg0KDQogICAgRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRl
LCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpS
ZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

