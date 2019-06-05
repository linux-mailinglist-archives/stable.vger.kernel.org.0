Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E6E35934
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 11:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfFEJC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 05:02:59 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:29446 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbfFEJC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 05:02:59 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-38-VxfF2aphNgutSa8OvI8kog-1; Wed, 05 Jun 2019 10:02:56 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Wed,
 5 Jun 2019 10:02:54 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 5 Jun 2019 10:02:54 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Davidlohr Bueso" <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "e@80x24.org" <e@80x24.org>, Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: RE: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Thread-Topic: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Thread-Index: AQHVGxwzwFf0q/qAAkiR7PRGfFAGAqaMwPEw
Date:   Wed, 5 Jun 2019 09:02:54 +0000
Message-ID: <263d0e478ee447d9aa10baab0d8673a5@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com>
 <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: VxfF2aphNgutSa8OvI8kog-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMDQgSnVuZSAyMDE5IDIyOjI3DQo+IFVnaC4g
SSBodGluayB0aGlzIGlzIGNvcnJlY3QsIGJ1dCBJIHdpc2ggd2UgaGFkIGEgYmV0dGVyIGFuZCBt
b3JlDQo+IGludHVpdGl2ZSBpbnRlcmZhY2UuDQo+IA0KPiBJbiBwYXJ0aWN1bGFyLCBzaW5jZSBy
ZXN0b3JlX3VzZXJfc2lnbWFzaygpIGJhc2ljYWxseSB3YW50cyB0byBjaGVjaw0KPiBmb3IgInNp
Z25hbF9wZW5kaW5nKCkiIGFueXdheSAodG8gZGVjaWRlIGlmIHRoZSBtYXNrIHNob3VsZCBiZQ0K
PiByZXN0b3JlZCBieSBzaWduYWwgaGFuZGxpbmcgb3IgYnkgdGhhdCBmdW5jdGlvbiksIEkgcmVh
bGx5IGdldCB0aGUNCj4gZmVlbGluZyB0aGF0IGEgbG90IG9mIHRoZXNlIHBhdHRlcm5zIGxpa2UN
Cj4gDQo+ID4gLSAgICAgICByZXN0b3JlX3VzZXJfc2lnbWFzayhrc2lnLnNpZ21hc2ssICZzaWdz
YXZlZCk7DQo+ID4gLSAgICAgICBpZiAoc2lnbmFsX3BlbmRpbmcoY3VycmVudCkgJiYgIXJldCkN
Cj4gPiArDQo+ID4gKyAgICAgICBpbnRlcnJ1cHRlZCA9IHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQp
Ow0KPiA+ICsgICAgICAgcmVzdG9yZV91c2VyX3NpZ21hc2soa3NpZy5zaWdtYXNrLCAmc2lnc2F2
ZWQsIGludGVycnVwdGVkKTsNCj4gPiArICAgICAgIGlmIChpbnRlcnJ1cHRlZCAmJiAhcmV0KQ0K
PiA+ICAgICAgICAgICAgICAgICByZXQgPSAtRVJFU1RBUlROT0hBTkQ7DQo+IA0KPiBhcmUgd3Jv
bmcgdG8gYmVnaW4gd2l0aCwgYW5kIHdlIHJlYWxseSBzaG91bGQgYWltIGZvciBhbiBpbnRlcmZh
Y2UNCj4gd2hpY2ggc2F5cyAidGVsbCBtZSB3aGV0aGVyIHlvdSBjb21wbGV0ZWQgdGhlIHN5c3Rl
bSBjYWxsLCBhbmQgSSdsbA0KPiBnaXZlIHlvdSBhbiBlcnJvciByZXR1cm4gaWYgbm90Ii4NCj4g
DQo+IEhvdyBhYm91dCB3ZSBtYWtlIHJlc3RvcmVfdXNlcl9zaWdtYXNrKCkgdGFrZSB0d28gcmV0
dXJuIGNvZGVzOiB0aGUNCj4gJ3JldCcgd2UgYWxyZWFkeSBoYXZlLCBhbmQgdGhlIHJldHVybiB3
ZSB3b3VsZCBnZXQgaWYgdGhlcmUgaXMgYQ0KPiBzaWduYWwgcGVuZGluZyBhbmQgdydyZSBjdXJy
ZW50bHkgcmV0dXJuaW5nIHplcm8uDQo+IA0KPiBJT1csIEkgdGhpbmsgdGhlIGFib3ZlIGNvdWxk
IGJlY29tZQ0KPiANCj4gICAgICAgICByZXQgPSByZXN0b3JlX3VzZXJfc2lnbWFzayhrc2lnLnNp
Z21hc2ssICZzaWdzYXZlZCwgcmV0LCAtRVJFU1RBUlRIQU5EKTsNCj4gDQo+IGluc3RlYWQgaWYg
d2UganVzdCBtYWRlIHRoZSByaWdodCBpbnRlcmZhY2UgZGVjaXNpb24uDQoNCkkgdGhpbmsgd2Ug
c2hvdWxkIHRlbGwgcmVzdG9yZV91c2VyX3NpZ21hc2soKSB3aGV0aGVyIGl0IHNob3VsZA0KY2F1
c2UgYW55IHNpZ25hbCBoYW5kbGVzIHRvIGJlIHJ1biAodXNpbmcgdGhlIGN1cnJlbnQgbWFzaykN
CmFuZCBpdCBzaG91bGQgdGVsbCB1cyB3aGV0aGVyIGl0IHdvdWxkIHJ1biBhbnkgKGllIGlmIGl0
IGRlZmVycmVkDQpyZXN0b3JpbmcgdGhlIG1hc2sgdG8gc3lzY2FsbCBleGl0KS4NCg0KU28gdGhl
IGFib3ZlIHdvdWxkIChwcm9iYWJseSkgYmU6DQoJaWYgKHJlc3RvcmVfdXNlcl9zaWdtYXNrKGtz
aWcuc2lnbWFzaywgJnNpZ3NhdmVkLCB0cnVlKSAmJiAhcmV0KQ0KCQlyZXQgPSAtRVJFU1RBUlRO
T0hBTkQ7DQoNCmVwb2xsKCkgd291bGQgaGF2ZToNCglpZiAocmVzdG9yZV91c2VyX3NpZ21hc2so
eHh4LnNpZ21hc2ssICZzaWdzYXZlZCwgIXJldCB8fCByZXQgPT0gLUVJTlRSKSkNCgkJcmV0ID0g
LUVJTlRSOw0KDQpJIGFsc28gdGhpbmsgaXQgY291bGQgYmUgc2ltcGxpZmllZCBpZiBjb2RlIHRo
YXQgbG9hZGVkIHRoZSAndXNlciBzaWdtYXNrJw0Kc2F2ZWQgdGhlIG9sZCBvbmUgaW4gJ2N1cnJl
bnQtPnNhdmVkX3NpZ21hc2snIChhbmQgc2F2ZWQgdGhhdCBpdCBoYWQgZG9uZSBpdCkuDQpZb3Un
ZCBub3QgbmVlZCAnc2lnc2F2ZWQnIG5vciBwYXNzIHRoZSB1c2VyIHNpZ21hc2sgYWRkcmVzcyBp
bnRvDQp0aGUgcmVzdG9yZSBmdW5jdGlvbi4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRk
cmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBN
SzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

