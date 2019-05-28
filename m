Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C42C2D4
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 11:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfE1JMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 05:12:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:30671 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726686AbfE1JMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 05:12:54 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-161-gTnKQjRxNjino90nSZuzuA-1; Tue, 28 May 2019 10:12:52 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 28 May 2019 10:12:51 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 28 May 2019 10:12:51 +0100
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
Thread-Index: AQHVELwtsgR+BAQFXk2JV68Wk/7LjKZ4aINAgABVkoCAAB2x0P///TgAgAARdkCAAZjWloAFw/iw
Date:   Tue, 28 May 2019 09:12:51 +0000
Message-ID: <ea7a1808990a4c319faa38d5d08d8f19@AcuMS.aculab.com>
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
X-MC-Unique: gTnKQjRxNjino90nSZuzuA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRGVlcGEgRGluYW1hbmkNCj4gU2VudDogMjQgTWF5IDIwMTkgMTg6MDINCi4uLg0KPiBM
b29rIGF0IHRoZSBjb2RlIGJlZm9yZSA4NTRhNmVkNTY4MzlhOg0KPiANCj4gICAvKg0KPiAgICAg
ICAgICogSWYgd2UgY2hhbmdlZCB0aGUgc2lnbmFsIG1hc2ssIHdlIG5lZWQgdG8gcmVzdG9yZSB0
aGUgb3JpZ2luYWwgb25lLg0KPiAgICAgICAgICogSW4gY2FzZSB3ZSd2ZSBnb3QgYSBzaWduYWwg
d2hpbGUgd2FpdGluZywgd2UgZG8gbm90IHJlc3RvcmUgdGhlDQo+ICAgICAgICAgKiBzaWduYWwg
bWFzayB5ZXQsIGFuZCB3ZSBhbGxvdyBkb19zaWduYWwoKSB0byBkZWxpdmVyIHRoZSBzaWduYWwg
b24NCj4gICAgICAgICAqIHRoZSB3YXkgYmFjayB0byB1c2Vyc3BhY2UsIGJlZm9yZSB0aGUgc2ln
bmFsIG1hc2sgaXMgcmVzdG9yZWQuDQo+ICAgICAgICAgKi8NCj4gICAgICAgIGlmIChzaWdtYXNr
KSB7DQo+ICAgICAgICAgICAgICAgIyMjIyMjIyBUaGlzIGVyciBoYXMgbm90IGJlZW4gY2hhbmdl
ZCBzaW5jZSBlcF9wb2xsKCkNCj4gICAgICAgICAgICAgICAjIyMjIyMjIFNvIGlmIHRoZXJlIGlz
IGEgc2lnbmFsIGJlZm9yZSB0aGlzIHBvaW50LCBidXQNCj4gZXJyID0gMCwgdGhlbiB3ZSBnb3Rv
IGVsc2UuDQo+ICAgICAgICAgICAgICAgIGlmIChlcnIgPT0gLUVJTlRSKSB7DQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgbWVtY3B5KCZjdXJyZW50LT5zYXZlZF9zaWdtYXNrLCAmc2lnc2F2ZWQs
DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpemVvZihzaWdzYXZlZCkpOw0KPiAg
ICAgICAgICAgICAgICAgICAgICAgIHNldF9yZXN0b3JlX3NpZ21hc2soKTsNCj4gICAgICAgICAg
ICAgICAgfSBlbHNlDQo+ICAgICAgICAgICAgICAgICAgICAgICMjIyMjIyMjIyMjIyBUaGlzIGlz
IGEgcHJvYmxlbSBpZiB0aGVyZSBpcyBzaWduYWwNCj4gcGVuZGluZyB0aGF0IGlzIHNpZ21hc2sg
c2hvdWxkIGJsb2NrLg0KPiAgICAgICAgICAgICAgICAgICAgICAjIyMjIyMjIyMjIyBUaGlzIGlz
IHRoZSB3aG9sZSByZWFzb24gd2UgaGF2ZQ0KPiBjdXJyZW50LT5zYXZlZF9zaWdtYXNrPw0KPiAg
ICAgICAgICAgICAgICAgICAgICAgIHNldF9jdXJyZW50X2Jsb2NrZWQoJnNpZ3NhdmVkKTsNCj4g
ICAgICAgIH0NCg0KV2hhdCBoYXBwZW5zIGlmIGFsbCB0aGF0IGNyYXAgaXMganVzdCBkZWxldGVk
IChJIHByZXN1bWUgZnJvbSB0aGUNCmJvdHRvbSBvZiBlcF93YWl0KCkpID8NCg0KSSdtIGd1ZXNz
aW5nIHRoYXQgb24gdGhlIHdheSBiYWNrIHRvIHVzZXJzcGFjZSBzaWduYWwgaGFuZGxlcnMgZm9y
DQpzaWduYWxzIGVuYWJsZWQgaW4gdGhlIHByb2Nlc3MncyBjdXJyZW50IG1hc2sgKHRoZSBvbmUg
c3BlY2lmaWVkDQp0byBlcG9sbF9wd2FpdCkgZ2V0IGNhbGxlZC4NClRoZW4gdGhlIHNpZ25hbCBt
YXNrIGlzIGxvYWRlZCBmcm9tIGN1cnJlbnQtPnNhdmVkX3NpZ21hc2sgYW5kDQphbmQgZW5hYmxl
ZCBzaWduYWwgaGFuZGxlcnMgYXJlIGNhbGxlZCBhZ2Fpbi4NCk5vIHNwZWNpYWwgY29kZSB0aGVy
ZSB0aGF0IGRlcGVuZHMgb24gdGhlIHN5c2NhbGwgcmVzdWx0LCBlcnJubw0Kb2YgdGhlIHN5c2Nh
bGwgbnVtYmVyLg0KDQpUaGF0IHNlZW1zIGV4YWN0bHkgY29ycmVjdCENCg0KCURhdmlkDQoNCi0N
ClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBN
aWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxl
cykNCg==

