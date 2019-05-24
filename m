Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C502954B
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 11:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389782AbfEXJ6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 05:58:31 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:56363 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389777AbfEXJ6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 05:58:30 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-4-v0DLxGEwM9yGbvCb2AhJBQ-1;
 Fri, 24 May 2019 10:58:27 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 24 May 2019 10:58:26 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 24 May 2019 10:58:26 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Deepa Dinamani' <deepa.kernel@gmail.com>
CC:     Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Thread-Topic: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Thread-Index: AQHVELwtsgR+BAQFXk2JV68Wk/7LjKZ4aINAgABVkoCAAB2x0P///TgAgAARdkCAAAfWgIABCrvA
Date:   Fri, 24 May 2019 09:58:26 +0000
Message-ID: <761e28606d344963a32eda6195a4e899@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com>
 <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
In-Reply-To: <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: v0DLxGEwM9yGbvCb2AhJBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRGVlcGEgRGluYW1hbmkNCj4gU2VudDogMjMgTWF5IDIwMTkgMTk6MDcNCj4gT2ssIHNp
bmNlIHRoZXJlIGhhcyBiZWVuIHF1aXRlIGEgYml0IG9mIGFyZ3VtZW50IGhlcmUsIEkgd2lsbA0K
PiBiYWNrdHJhY2sgYSBsaXR0bGUgYml0IGFuZCBtYXliZSBpdCB3aWxsIGhlbHAgdXMgdW5kZXJz
dGFuZCB3aGF0J3MNCj4gaGFwcGVuaW5nIGhlcmUuDQo+IFRoZXJlIGFyZSBtYW55IHNjZW5hcmlv
cyBiZWluZyBkaXNjdXNzZWQgb24gdGhpcyB0aHJlYWQ6DQo+IGEuIFN0YXRlIG9mIGNvZGUgYmVm
b3JlIDg1NGE2ZWQ1NjgzOWENCj4gYi4gU3RhdGUgYWZ0ZXIgODU0YTZlZDU2ODM5YQ0KPiBjLiBQ
cm9wb3NlZCBmaXggYXMgcGVyIHRoZSBwYXRjaHNldCBpbiBxdWVzdGlvbi4NCj4gDQo+IE9sZWcs
IEkgd2lsbCBkaXNjdXNzIHRoZXNlIGZpcnN0IGFuZCB0aGVuIHdlIGNhbiBkaXNjdXNzIHRoZQ0K
PiBhZGRpdGlvbmFsIGNoYW5nZXMgeW91IHN1Z2dlc3RlZC4NCj4gDQo+IFNvbWUgYmFja2dyb3Vu
ZCBvbiB3aHkgd2UgaGF2ZSB0aGVzZSBzeXNjYWxscyB0aGF0IHRha2Ugc2lnbWFzayBhcyBhbg0K
PiBhcmd1bWVudC4gVGhpcyBpcyBqdXN0IGZvciB0aGUgc2FrZSBvZiBjb21wbGV0ZW5lc3Mgb2Yg
dGhlIGFyZ3VtZW50Lg0KPiANCj4gVGhlc2UgYXJlIHBhcnRpY3VsYXJseSBtZWFudCBmb3IgYSBz
Y2VuYXJpbyhkKSBzdWNoIGFzIGJlbG93Og0KPiANCj4gMS4gYmxvY2sgdGhlIHNpZ25hbHMgeW91
IGRvbid0IGNhcmUgYWJvdXQuDQo+IDIuIHN5c2NhbGwoKQ0KPiAzLiB1bmJsb2NrIHRoZSBzaWdu
YWxzIGJsb2NrZWQgaW4gMS4NCj4gDQo+IFRoZSBwcm9ibGVtIGhlcmUgaXMgdGhhdCBpZiB0aGVy
ZSBpcyBhIHNpZ25hbCB0aGF0IGlzIG5vdCBibG9ja2VkIGJ5IDENCj4gYW5kIHN1Y2ggYSBzaWdu
YWwgaXMgZGVsaXZlcmVkIGJldHdlZW4gMSBhbmQgMihzaW5jZSB0aGV5IGFyZSBub3QNCj4gYXRv
bWljKSwgdGhlIHN5c2NhbGwgaW4gMiBtaWdodCBibG9jayBmb3JldmVyIGFzIGl0IG5ldmVyIGZv
dW5kIG91dA0KPiBhYm91dCB0aGUgc2lnbmFsLg0KDQpJIHRoaW5rIHdlIGFsbCBhZ3JlZSBhYm91
dCB0aGUgdW5kZXJseWluZyBwcm9ibGVtIHRoZXNlIHN5c3RlbSBjYWxscyBzb2x2ZS4NCg0KPiBB
cyBwZXIgW2FdIGFuZCBsZXQncyBjb25zaWRlciB0aGUgY2FzZSBvZiBlcG9sbF9wd2FpdCBvbmx5
IGZpcnN0IGZvciBzaW1wbGljaXR5Lg0KRm9yIHNpbXBsaWNpdHkgeW91IG91Z2h0IHRvIGNvbnNp
ZGVyIHNpZ3dhaXRpbmZvKCkgOi0pDQoNCj4gQXMgSSBzYWlkIGJlZm9yZSwgZXBfcG9sbCgpIGlz
IHdoYXQgY2hlY2tzIGZvciBzaWduYWxfcGVuZGluZygpIGFuZCBpcw0KPiByZXNwb25zaWJsZSBm
b3Igc2V0dGluZyBlcnJubyB0byAtRUlOVFIgd2hlbiB0aGVyZSBpcyBhIHNpZ25hbC4NCg0KQWgs
IHRoZXJlIGluIGxpZXMgdGhlIHByb2JsZW0gKHdlbGwgb25lIG9mIHRoZW0pLg0KZXBfcG9sbCgp
IHNob3VsZCBvbmx5IHJldHVybiAtRUlOVFIgaWYgaXRzIHNsZWVwICh3YWl0aW5nIGZvciBhbiBm
ZCB0bw0KYmUgcmVhZHkpIGlzIGludGVycnVwdGVkLg0KVGhlIHNpZ25hbCBoYW5kbGVyKHMpIHNo
b3VsZCBzdGlsbCBiZSBjYWxsZWQgdGhvdWdoLg0KSWYgdGhlIHRpbWVvdXQgaXMgMCB0aGVuIGFu
eSBzaWduYWwgaGFuZGxlciBzaG91bGQgYmUgY2FsbGVkLCBidXQgdGhlDQpyZXR1cm4gdmFsdWUg
aXMgc3RpbGwgMCAoaWYgbm8gZmQgYXJlICdyZWFkeScpLg0KDQo+IFNvIGlmIGEgc2lnbmFsIGlz
IHJlY2VpdmVkIGFmdGVyIGVwX3BvbGwoKSBhbmQgZXBfcG9sbCgpIHJldHVybnMNCj4gc3VjY2Vz
cywgaXQgaXMgbmV2ZXIgbm90aWNlZCBieSB0aGUgc3lzY2FsbCBkdXJpbmcgZXhlY3V0aW9uLg0K
PiBTbyB0aGUgcXVlc3Rpb24gaXMgZG9lcyB0aGUgdXNlcnNwYWNlIGhhdmUgdG8ga25vdyBhYm91
dCB0aGlzIHNpZ25hbA0KPiBvciBub3QuIEZyb20gc2NlbmFyaW8gW2RdIGFib3ZlLCBJIHdvdWxk
IHNheSBpdCBzaG91bGQsIGV2ZW4gaWYgYWxsDQo+IHRoZSBmZCdzIGNvbXBsZXRlZCBzdWNjZXNz
ZnVsbHkuDQoNCldoYXQgaXMgc2NlbmFyaW8gW2RdPyBZb3UndmUgY29kZSB2ZXJzaW9ucyBhL2Iv
YyBidXQgbm8gc2NlbmFyaW9zLg0KDQo+IFRoaXMgZG9lcyBub3QgaGFwcGVuIGluIFthXS4gU28g
dGhpcyBpcyB3aGF0IEkgc2FpZCB3YXMgYWxyZWFkeSBicm9rZW4uDQo+IA0KPiBXaGF0IFtiXSBk
b2VzIGlzIHRvIG1vdmUgdGhlIHNpZ25hbCBjaGVjayBjbG9zZXIgdG8gdGhlIHJlc3RvcmF0aW9u
IG9mDQo+IHRoZSBzaWduYWwuIFRoaXMgd2F5IGl0IGlzIGdvb2QuIFNvLCBpZiB0aGVyZSBpcyBh
IHNpZ25hbCBhZnRlcg0KPiBlcF9wb2xsKCkgcmV0dXJucyBzdWNjZXNzLCBpdCBpcyBub3RpY2Vk
IGFuZCB0aGUgc2lnbmFsIGlzIGRlbGl2ZXJlZA0KPiB3aGVuIHRoZSBzeXNjYWxsIGV4aXRzLiBC
dXQsIHRoZSBzeXNjYWxsIGVycm9yIHN0YXR1cyBpdHNlbGYgaXMgMC4NCg0KQnkgMCB5b3UgbWVh
biA+PSAwID8/DQoNCj4gU28gbm93IFtjXSBpcyBhZGp1c3RpbmcgdGhlIHJldHVybiB2YWx1ZXMg
YmFzZWQgb24gd2hldGhlciBleHRyYQ0KPiBzaWduYWxzIHdlcmUgZGV0ZWN0ZWQgYWZ0ZXIgZXBf
cG9sbCgpLiBUaGlzIHBhcnQgd2FzIG5lZWRlZCBldmVuIGZvcg0KPiBbYV0uDQoNCklNSE8gVGhl
IHJldHVybiB2YWx1ZSBzaG91bGQgbmV2ZXIgYmUgY2hhbmdlZC4NCk11Y2ggbGlrZSB3cml0ZSgp
IGNhbiByZXR1cm4gYSBwYXJ0aWFsIGxlbmd0aCBpZiBhIHNpZ25hbCBoYXBwZW5zLg0KDQpJU1RN
IHRoYXQgYSB1c2VyIHNpZ25hbCBoYW5kbGVyIHNob3VsZCBiZSBzY2hlZHVsZWQgdG8gYmUgcnVu
DQppZiB0aGUgc2lnbmFsIGlzIHBlbmRpbmcgYW5kIG5vdCBtYXNrZWQuDQpPbiByZXR1cm4gdG8g
dXNlciBhbGwgc2NoZWR1bGVkIHNpZ25hbCBoYW5kbGVycyBhcmUgY2FsbGVkDQoocmVnYXJkbGVz
cyBhcyB0byB3aGV0aGVyIHRoZSBzaWduYWwgaXMgbWFza2VkIGF0IHRoYXQgdGltZSkuDQpUaGlz
IG1pZ2h0IG1lYW4gZ2V0dGluZyB0aGUgJ3JldHVybiB0byB1c2VyJyBjb2RlIHRvIHJlc3RvcmUN
CnRoZSBvcmlnaW5hbCBzaWduYWwgbWFzayBzYXZlZCBmb3IgZXBvbGxfcHdhaXQoKSBhbmQgcHNl
bGVjdCgpIGV0Yy4NCg0KSWYsIGZvciBzb21lIHBlcnZlcnRlZCByZWFzb24gKGNvbXBhdGliaWxp
dHkgd2l0aCBicm9rZW4gYXBwcyksDQp5b3UgbmVlZCBlcG9sbF9wd2FpdCgpIHRvIHJldHVybiBF
SU5UUiBpbnN0ZWFkIG9mIDAgdGhlIHlvdQ0KcHJvYmFibHkgbmVlZCBhIHNwZWNpYWwgJ2tlcm5l
bCBpbnRlcm5hbCcgZXJybm8gdmFsdWUgdGhhdA0KaXMgYWx3YXlzIGNvbnZlcnRlZCBieSB0aGUg
c3lzY2FsbCBleGl0IGNvZGUgdG8gRUlOVFIvMA0KKGFuZCBhIHNlY29uZCBvbmUgdGhhdCBpcyBF
SU5UUi9FQUdBSU4gZXRjKS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtl
c2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBV
Sw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

