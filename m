Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB90815AE
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 11:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfHEJlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 05:41:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52076 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbfHEJlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 05:41:10 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-236-iiCZ4_0kN0uCcHgQ-ApRbg-1; Mon, 05 Aug 2019 10:41:07 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 5 Aug 2019 10:41:07 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 5 Aug 2019 10:41:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?utf-8?B?J0NocmlzdG9waCBCw7ZobXdhbGRlcic=?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Philipp Reisner" <philipp.reisner@linbit.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: RE: [PATCH] drbd: do not ignore signals in threads
Thread-Topic: [PATCH] drbd: do not ignore signals in threads
Thread-Index: AQHVRehdZ3MFgEc+dUGpXqE3QyW7xKbhRpmwgAr+X4CAABFvoA==
Date:   Mon, 5 Aug 2019 09:41:06 +0000
Message-ID: <6f8c0d1e51c242a288fbf9b32240e4c1@AcuMS.aculab.com>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
 <6259de605e9246b095233e3984262b93@AcuMS.aculab.com>
 <ad16d006-4382-3f77-8968-6f840e58b8df@linbit.com>
In-Reply-To: <ad16d006-4382-3f77-8968-6f840e58b8df@linbit.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: iiCZ4_0kN0uCcHgQ-ApRbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQ2hyaXN0b3BoIELDtmhtd2FsZGVyDQo+IFNlbnQ6IDA1IEF1Z3VzdCAyMDE5IDEwOjMz
DQo+IA0KPiBPbiAyOS4wNy4xOSAxMDo1MCwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+IERvZXNu
J3QgdW5tYXNraW5nIHRoZSBzaWduYWxzIGFuZCB1c2luZyBzZW5kX3NpZygpIGluc3RlYWQgIG9m
IGZvcmNlX3NpZygpDQo+ID4gaGF2ZSB0aGUgKHByb2JhYmx5IHVud2FudGVkKSBzaWRlIGVmZmVj
dCBvZiBhbGxvd2luZyB1c2Vyc3BhY2UgdG8gc2VuZA0KPiA+IHRoZSBzaWduYWw/DQo+IA0KPiBJ
IGhhdmUgcmFuIHNvbWUgdGVzdHMsIGFuZCBpdCBkb2VzIGxvb2sgbGlrZSBpdCBpcyBub3cgcG9z
c2libGUgdG8gc2VuZA0KPiBzaWduYWxzIHRvIHRoZSBEUkJEIGt0aHJlYWQgZnJvbSB1c2Vyc3Bh
Y2UuIEhvd2V2ZXIsIC4uLg0KPiANCj4gPiBJJ3ZlIGNlcnRhaW5seSBnb3Qgc29tZSBkcml2ZXIg
Y29kZSB0aGF0IHVzZXMgZm9yY2Vfc2lnKCkgb24gYSBrdGhyZWFkDQo+ID4gdGhhdCBpdCBkb2Vz
bid0IChldmVyKSB3YW50IHVzZXJzcGFjZSB0byBzaWduYWwuDQo+IA0KPiAuLi4gd2UgZG9uJ3Qg
ZmVlbCB0aGF0IGl0IGlzIGFic29sdXRlbHkgbmVjZXNzYXJ5IGZvciB1c2Vyc3BhY2UgdG8gYmUN
Cj4gdW5hYmxlIHRvIHNlbmQgYSBzaWduYWwgdG8gb3VyIGt0aHJlYWRzLiBUaGlzIGlzIGJlY2F1
c2UgdGhlIERSQkQgdGhyZWFkDQo+IGluZGVwZW5kZW50bHkgY2hlY2tzIGl0cyBvd24gc3RhdGUs
IGFuZCAoZm9yIGV4YW1wbGUpIG9ubHkgZXhpdHMgYXMgYQ0KPiByZXN1bHQgb2YgYSBzaWduYWwg
aWYgaXRzIHRocmVhZCBzdGF0ZSB3YXMgYWxyZWFkeSAiRVhJVElORyIgdG8gYmVnaW4NCj4gd2l0
aC4NCg0KSW4gbXVzdCAnY2xlYXInIHRoZSBzaWduYWwgLSBvdGhlcndpc2UgaXQgd29uJ3QgYmxv
Y2sgYWdhaW4uDQoNCkkndmUgYWxzbyBnb3QgdGhpcyBob3JyaWQgY29kZSBmcmFnbWVudDoNCg0K
ICAgIGluaXRfd2FpdHF1ZXVlX2VudHJ5KCZ3LCBjdXJyZW50KTsNCg0KICAgIC8qIFRlbGwgc2No
ZWR1bGVyIHdlIGFyZSBnb2luZyB0byBzbGVlcC4uLiAqLw0KICAgIGlmIChzaWduYWxfcGVuZGlu
ZyhjdXJyZW50KSAmJiAhaW50ZXJydXB0aWJsZSkNCiAgICAgICAgLyogV2UgZG9uJ3Qgd2FudCB3
YWtpbmcgaW1tZWRpYXRlbHkgKGFnYWluKSAqLw0KICAgICAgICBzbGVlcF9zdGF0ZSA9IFRBU0tf
VU5JTlRFUlJVUFRJQkxFOw0KICAgIGVsc2UNCiAgICAgICAgc2xlZXBfc3RhdGUgPSBUQVNLX0lO
VEVSUlVQVElCTEU7DQogICAgc2V0X2N1cnJlbnRfc3RhdGUoc2xlZXBfc3RhdGUpOw0KDQogICAg
LyogQ29ubmVjdCB0byBjb25kaXRpb24gdmFyaWFibGUgLi4uICovDQogICAgYWRkX3dhaXRfcXVl
dWUoY3ZwLCAmdyk7DQogICAgbXV0ZXhfdW5sb2NrKG10eHApOyAvKiBSZWxlYXNlIG11dGV4ICov
DQoNCndoZXJlIHdlIHdhbnQgdG8gc2xlZXAgVEFTS19VTklOVEVSUlVQVElCTEUgYnV0IHRoYXQg
Zipja3MgdXAgdGhlICdsb2FkIGF2ZXJhZ2UnLA0Kc28gc2xlZXAgVEFTS19JTlRFUlJVUFRJQkxF
IHVubGVzcyB0aGVyZSBpcyBhIHNpZ25hbCBwZW5kaW5nIHRoYXQgd2Ugd2FudCB0bw0KaWdub3Jl
Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJv
YWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24g
Tm86IDEzOTczODYgKFdhbGVzKQ0K

