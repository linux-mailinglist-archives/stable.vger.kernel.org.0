Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D3E278B5
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 11:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfEWJDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 05:03:34 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:47378 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbfEWJDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 05:03:34 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-109-QAnUYR_ZPWu03W_8XUVOfg-1; Thu, 23 May 2019 10:03:30 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 23 May 2019 10:03:29 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 23 May 2019 10:03:29 +0100
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
Thread-Index: AQHVELwtsgR+BAQFXk2JV68Wk/7LjKZ4aINA
Date:   Thu, 23 May 2019 09:03:29 +0000
Message-ID: <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com>
 <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
In-Reply-To: <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: QAnUYR_ZPWu03W_8XUVOfg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRGVlcGEgRGluYW1hbmkNCj4gU2VudDogMjIgTWF5IDIwMTkgMTc6MzQNCj4gT24gV2Vk
LCBNYXkgMjIsIDIwMTkgYXQgOToxNCBBTSBPbGVnIE5lc3Rlcm92IDxvbGVnQHJlZGhhdC5jb20+
IHdyb3RlOg0KPiA+DQo+ID4gT24gMDUvMjIsIERlZXBhIERpbmFtYW5pIHdyb3RlOg0KPiA+ID4N
Cj4gPiA+IC1EZWVwYQ0KPiA+ID4NCj4gPiA+ID4gT24gTWF5IDIyLCAyMDE5LCBhdCA4OjA1IEFN
LCBPbGVnIE5lc3Rlcm92IDxvbGVnQHJlZGhhdC5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4g
Pj4gT24gMDUvMjEsIERlZXBhIERpbmFtYW5pIHdyb3RlOg0KPiA+ID4gPj4NCj4gPiA+ID4+IE5v
dGUgdGhhdCB0aGlzIHBhdGNoIHJldHVybnMgaW50ZXJydXB0ZWQgZXJyb3JzIChFSU5UUiwgRVJF
U1RBUlROT0hBTkQsDQo+ID4gPiA+PiBldGMpIG9ubHkgd2hlbiB0aGVyZSBpcyBubyBvdGhlciBl
cnJvci4gSWYgdGhlcmUgaXMgYSBzaWduYWwgYW5kIGFuIGVycm9yDQo+ID4gPiA+PiBsaWtlIEVJ
TlZBTCwgdGhlIHN5c2NhbGxzIHJldHVybiAtRUlOVkFMIHJhdGhlciB0aGFuIHRoZSBpbnRlcnJ1
cHRlZA0KPiA+ID4gPj4gZXJyb3IgY29kZXMuDQo+ID4gPiA+DQo+ID4gPiA+IFVnaC4gSSBuZWVk
IHRvIHJlLWNoZWNrLCBidXQgYXQgZmlyc3QgZ2xhbmNlIEkgcmVhbGx5IGRpc2xpa2UgdGhpcyBj
aGFuZ2UuDQo+ID4gPiA+DQo+ID4gPiA+IEkgdGhpbmsgd2UgY2FuIGZpeCB0aGUgcHJvYmxlbSBf
YW5kXyBzaW1wbGlmeSB0aGUgY29kZS4gU29tZXRoaW5nIGxpa2UgYmVsb3cuDQo+ID4gPiA+IFRo
ZSBwYXRjaCBpcyBvYnZpb3VzbHkgaW5jb21wbGV0ZSwgaXQgY2hhbmdlcyBvbmx5IG9ubHkgb25l
IGNhbGxlciBvZg0KPiA+ID4gPiBzZXRfdXNlcl9zaWdtYXNrKCksIGVwb2xsX3B3YWl0KCkgdG8g
ZXhwbGFpbiB3aGF0IEkgbWVhbi4NCj4gPiA+ID4gcmVzdG9yZV91c2VyX3NpZ21hc2soKSBzaG91
bGQgc2ltcGx5IGRpZS4gQWx0aG91Z2ggcGVyaGFwcyBhbm90aGVyIGhlbHBlcg0KPiA+ID4gPiBt
YWtlcyBzZW5zZSB0byBhZGQgV0FSTl9PTih0ZXN0X3Rza19yZXN0b3JlX3NpZ21hc2soKSAmJiAh
c2lnbmFsX3BlbmRpbmcpLg0KPiA+ID4NCj4gPiA+IHJlc3RvcmVfdXNlcl9zaWdtYXNrKCkgd2Fz
IGFkZGVkIGJlY2F1c2Ugb2YgYWxsIHRoZSB2YXJpYW50cyBvZiB0aGVzZQ0KPiA+ID4gc3lzY2Fs
bHMgd2UgYWRkZWQgYmVjYXVzZSBvZiB5MjAzOCBhcyBub3RlZCBpbiBjb21taXQgbWVzc2FnZToN
Cj4gPiA+DQo+ID4gPiAgIHNpZ25hbDogQWRkIHJlc3RvcmVfdXNlcl9zaWdtYXNrKCkNCj4gPiA+
DQo+ID4gPiAgICAgUmVmYWN0b3IgdGhlIGxvZ2ljIHRvIHJlc3RvcmUgdGhlIHNpZ21hc2sgYmVm
b3JlIHRoZSBzeXNjYWxsDQo+ID4gPiAgICAgcmV0dXJucyBpbnRvIGFuIGFwaS4NCj4gPiA+ICAg
ICBUaGlzIGlzIHVzZWZ1bCBmb3IgdmVyc2lvbnMgb2Ygc3lzY2FsbHMgdGhhdCBwYXNzIGluIHRo
ZQ0KPiA+ID4gICAgIHNpZ21hc2sgYW5kIGV4cGVjdCB0aGUgY3VycmVudC0+c2lnbWFzayB0byBi
ZSBjaGFuZ2VkIGR1cmluZw0KPiA+ID4gICAgIHRoZSBleGVjdXRpb24gYW5kIHJlc3RvcmVkIGFm
dGVyIHRoZSBleGVjdXRpb24gb2YgdGhlIHN5c2NhbGwuDQo+ID4gPg0KPiA+ID4gICAgIFdpdGgg
dGhlIGFkdmVudCBvZiBuZXcgeTIwMzggc3lzY2FsbHMgaW4gdGhlIHN1YnNlcXVlbnQgcGF0Y2hl
cywNCj4gPiA+ICAgICB3ZSBhZGQgdHdvIG1vcmUgbmV3IHZlcnNpb25zIG9mIHRoZSBzeXNjYWxs
cyAoZm9yIHBzZWxlY3QsIHBwb2xsDQo+ID4gPiAgICAgYW5kIGlvX3BnZXRldmVudHMpIGluIGFk
ZGl0aW9uIHRvIHRoZSBleGlzdGluZyBuYXRpdmUgYW5kIGNvbXBhdA0KPiA+ID4gICAgIHZlcnNp
b25zLiBBZGRpbmcgc3VjaCBhbiBhcGkgcmVkdWNlcyB0aGUgbG9naWMgdGhhdCB3b3VsZCBuZWVk
IHRvDQo+ID4gPiAgICAgYmUgcmVwbGljYXRlZCBvdGhlcndpc2UuDQo+ID4NCj4gPiBBZ2Fpbiwg
SSBuZWVkIHRvIHJlLWNoZWNrLCB3aWxsIGNvbnRpbnVlIHRvbW9ycm93LiBCdXQgc28gZmFyIEkg
YW0gbm90IHN1cmUNCj4gPiB0aGlzIGhlbHBlciBjYW4gYWN0dWFsbHkgaGVscC4NCj4gPg0KPiA+
ID4gPiAtLS0gYS9mcy9ldmVudHBvbGwuYw0KPiA+ID4gPiArKysgYi9mcy9ldmVudHBvbGwuYw0K
PiA+ID4gPiBAQCAtMjMxOCwxOSArMjMxOCwxOSBAQCBTWVNDQUxMX0RFRklORTYoZXBvbGxfcHdh
aXQsIGludCwgZXBmZCwgc3RydWN0IGVwb2xsX2V2ZW50IF9fdXNlciAqLA0KPiBldmVudHMsDQo+
ID4gPiA+ICAgICAgICBzaXplX3QsIHNpZ3NldHNpemUpDQo+ID4gPiA+IHsNCj4gPiA+ID4gICAg
aW50IGVycm9yOw0KPiA+ID4gPiAtICAgIHNpZ3NldF90IGtzaWdtYXNrLCBzaWdzYXZlZDsNCj4g
PiA+ID4NCj4gPiA+ID4gICAgLyoNCj4gPiA+ID4gICAgICogSWYgdGhlIGNhbGxlciB3YW50cyBh
IGNlcnRhaW4gc2lnbmFsIG1hc2sgdG8gYmUgc2V0IGR1cmluZyB0aGUgd2FpdCwNCj4gPiA+ID4g
ICAgICogd2UgYXBwbHkgaXQgaGVyZS4NCj4gPiA+ID4gICAgICovDQo+ID4gPiA+IC0gICAgZXJy
b3IgPSBzZXRfdXNlcl9zaWdtYXNrKHNpZ21hc2ssICZrc2lnbWFzaywgJnNpZ3NhdmVkLCBzaWdz
ZXRzaXplKTsNCj4gPiA+ID4gKyAgICBlcnJvciA9IHNldF91c2VyX3NpZ21hc2soc2lnbWFzaywg
c2lnc2V0c2l6ZSk7DQo+ID4gPiA+ICAgIGlmIChlcnJvcikNCj4gPiA+ID4gICAgICAgIHJldHVy
biBlcnJvcjsNCj4gPiA+ID4NCj4gPiA+ID4gICAgZXJyb3IgPSBkb19lcG9sbF93YWl0KGVwZmQs
IGV2ZW50cywgbWF4ZXZlbnRzLCB0aW1lb3V0KTsNCj4gPiA+ID4NCj4gPiA+ID4gLSAgICByZXN0
b3JlX3VzZXJfc2lnbWFzayhzaWdtYXNrLCAmc2lnc2F2ZWQpOw0KPiA+ID4gPiArICAgIGlmIChl
cnJvciAhPSAtRUlOVFIpDQo+ID4gPg0KPiA+ID4gQXMgeW91IGFkZHJlc3MgYWxsIHRoZSBvdGhl
ciBzeXNjYWxscyB0aGlzIGNvbmRpdGlvbiBiZWNvbWVzIG1vcmUgYW5kDQo+ID4gPiBtb3JlIGNv
bXBsaWNhdGVkLg0KPiA+DQo+ID4gTWF5IGJlLg0KPiA+DQo+ID4gPiA+IC0tLSBhL2luY2x1ZGUv
bGludXgvc2NoZWQvc2lnbmFsLmgNCj4gPiA+ID4gKysrIGIvaW5jbHVkZS9saW51eC9zY2hlZC9z
aWduYWwuaA0KPiA+ID4gPiBAQCAtNDE2LDcgKzQxNiw2IEBAIHZvaWQgdGFza19qb2luX2dyb3Vw
X3N0b3Aoc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrKTsNCj4gPiA+ID4gc3RhdGljIGlubGluZSB2
b2lkIHNldF9yZXN0b3JlX3NpZ21hc2sodm9pZCkNCj4gPiA+ID4gew0KPiA+ID4gPiAgICBzZXRf
dGhyZWFkX2ZsYWcoVElGX1JFU1RPUkVfU0lHTUFTSyk7DQo+ID4gPiA+IC0gICAgV0FSTl9PTigh
dGVzdF90aHJlYWRfZmxhZyhUSUZfU0lHUEVORElORykpOw0KPiA+ID4NCj4gPiA+IFNvIHlvdSBh
bHdheXMgd2FudCBkb19zaWduYWwoKSB0byBiZSBjYWxsZWQ/DQo+ID4NCj4gPiBXaHkgZG8geW91
IHRoaW5rIHNvPyBOby4gVGhpcyBpcyBqdXN0IHRvIGF2b2lkIHRoZSB3YXJuaW5nLCBiZWNhdXNl
IHdpdGggdGhlDQo+ID4gcGF0Y2ggSSBzZW50IHNldF9yZXN0b3JlX3NpZ21hc2soKSBpcyBjYWxs
ZWQgImluIGFkdmFuY2UiLg0KPiA+DQo+ID4gPiBZb3Ugd2lsbCBoYXZlIHRvIGNoZWNrIGVhY2gg
YXJjaGl0ZWN0dXJlJ3MgaW1wbGVtZW50YXRpb24gb2YNCj4gPiA+IGRvX3NpZ25hbCgpIHRvIGNo
ZWNrIGlmIHRoYXQgaGFzIGFueSBzaWRlIGVmZmVjdHMuDQo+ID4NCj4gPiBJIGRvbid0IHRoaW5r
IHNvLg0KPiANCj4gV2h5IG5vdD8NCj4gDQo+ID4gPiBBbHRob3VnaCB0aGlzIGlzIG5vdCB3aGF0
IHRoZSBwYXRjaCBpcyBzb2x2aW5nLg0KPiA+DQo+ID4gU3VyZS4gQnV0IHlvdSBrbm93LCBhZnRl
ciBJIHRyaWVkIHRvIHJlYWQgdGhlIGNoYW5nZWxvZywgSSBhbSBub3Qgc3VyZQ0KPiA+IEkgdW5k
ZXJzdGFuZCB3aGF0IGV4YWN0bHkgeW91IGFyZSB0cnlpbmcgdG8gZml4LiBDb3VsZCB5b3UgcGxl
YXNlIGV4cGxhaW4NCj4gPiB0aGlzIHBhcnQNCj4gPg0KPiA+ICAgICAgICAgVGhlIGJlaGF2aW9y
DQo+ID4gICAgICAgICBiZWZvcmUgODU0YTZlZDU2ODM5YSB3YXMgdGhhdCB0aGUgc2lnbmFscyB3
ZXJlIGRyb3BwZWQgYWZ0ZXIgdGhlIGVycm9yDQo+ID4gICAgICAgICBjb2RlIHdhcyBkZWNpZGVk
LiBUaGlzIHJlc3VsdGVkIGluIGxvc3Qgc2lnbmFscyBidXQgdGhlIHVzZXJzcGFjZSBkaWQgbm90
DQo+ID4gICAgICAgICBub3RpY2UgaXQNCj4gPg0KPiA+ID8gSSBmYWlsIHRvIHVuZGVyc3RhbmQg
aXQsIHNvcnJ5LiBJdCBsb29rcyBhcyBpZiB0aGUgY29kZSB3YXMgYWxyZWFkeSBidWdneSBiZWZv
cmUNCj4gPiB0aGF0IGNvbW1pdCBhbmQgaXQgY291bGQgbWlzcyBhIHNpZ25hbCBvciBzb21ldGhp
bmcgbGlrZSB0aGlzLCBidXQgSSBkbyBub3Qgc2VlIGhvdy4NCj4gDQo+IERpZCB5b3UgcmVhZCB0
aGUgZXhwbGFuYXRpb24gcG9pbnRlZCB0byBpbiB0aGUgY29tbWl0IHRleHQ/IDoNCj4gDQo+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWZzZGV2ZWwvMjAxOTA0MjcwOTMzMTkuc2dpY3Fp
azJvcWtlejN3a0BkY3ZyLw0KPiANCj4gTGV0IG1lIGtub3cgd2hhdCBwYXJ0IHlvdSBkb24ndCB1
bmRlcnN0YW5kIGFuZCBJIGNhbiBleHBsYWluIG1vcmUuDQo+IA0KPiBJdCB3b3VsZCBiZSBiZXR0
ZXIgdG8gdW5kZXJzdGFuZCB0aGUgaXNzc3VlIGJlZm9yZSB3ZSBzdGFydCBkaXNjdXNzaW5nIHRo
ZSBmaXguDQoNCg0KSSdtIGNvbmZ1c2VkLi4uDQpJIHRob3VnaHQ6DQoNCkVJTlRSIHNob3VsZCBv
bmx5IGJlIHJldHVybmVkIGlmIGEgYmxvY2tpbmcgc2xlZXAgKGVnIGluIGRvX2Vwb2xsX3dhaXQo
KSBpdHNlbGYpDQp3YXMgaW50ZXJydXB0ZWQgYnkgYSBzaWduYWwgdGhhdCB3YXMgZW5hYmxlZCBh
dCB0aGUgdGltZSBvZiB0aGUgc2xlZXAuDQoNClRoZSBoYW5kbGVycyBmb3IgYWxsIHVuYmxvY2tl
ZCBzaWduYWxzIHNob3VsZCBiZSBydW4gb24gcmV0dXJuIHRvIHVzZXIuDQpUaGlzIGlzIGFmdGVy
IHRoZSBtYXNrIGhhcyBiZWVuIHJlc3RvcmVkIGFuZCByZWdhcmRsZXNzIG9mIHRoZSBlcnJvciBj
b2RlLg0KDQpTbyBlcG9sbCgpIGNhbiByZXR1cm4gJ3N1Y2Nlc3MnIG9yICd0aW1lb3V0JyAoZXRj
KSBhbmQgdGhlIGhhbmRsZXIgZm9yIFNJR19VUkcNCnNob3VsZCBzdGlsbCBiZSBjYWxsZWQuDQpU
aGlzIGlzIGV4YWN0bHkgZXF1aXZhbGVudCB0byB0aGUgaW50ZXJydXB0IHRoYXQgZ2VuZXJhdGVz
IHRoZSBzaWduYWwgaGFwcGVuaW5nDQpqdXN0IGFmdGVyIHRoZSAncmV0dXJuIHRvIHVzZXInIG9m
IHRoZSBzeXN0ZW0gY2FsbC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtl
c2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBV
Sw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

