Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8189E2C612
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 14:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfE1MEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 08:04:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:21252 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbfE1MEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 08:04:22 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-2-p5vBR3z9NBis8WdfYPVZEA-1;
 Tue, 28 May 2019 13:04:18 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue,
 28 May 2019 13:04:17 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 28 May 2019 13:04:17 +0100
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
Thread-Index: AQHVELwtsgR+BAQFXk2JV68Wk/7LjKZ4aINAgABVkoCAAB2x0P///TgAgAARdkCAAZjWloAFw/iwgAAaDACAABYO8A==
Date:   Tue, 28 May 2019 12:04:17 +0000
Message-ID: <0eb2b10294f64ddbae0113cea55db639@AcuMS.aculab.com>
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
 <ea7a1808990a4c319faa38d5d08d8f19@AcuMS.aculab.com>
 <B9F0F146-C687-4D1D-8BFF-1236564631F6@gmail.com>
In-Reply-To: <B9F0F146-C687-4D1D-8BFF-1236564631F6@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: p5vBR3z9NBis8WdfYPVZEA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRGVlcGEgRGluYW1hbmkNCj4gU2VudDogMjggTWF5IDIwMTkgMTI6MzgNCj4gPiBPbiBN
YXkgMjgsIDIwMTksIGF0IDI6MTIgQU0sIERhdmlkIExhaWdodCA8RGF2aWQuTGFpZ2h0QGFjdWxh
Yi5jb20+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogRGVlcGEgRGluYW1hbmkNCj4gPj4gU2VudDog
MjQgTWF5IDIwMTkgMTg6MDINCj4gPiAuLi4NCj4gPj4gTG9vayBhdCB0aGUgY29kZSBiZWZvcmUg
ODU0YTZlZDU2ODM5YToNCj4gPj4NCj4gPj4gLyoNCj4gPj4gICAgICAgKiBJZiB3ZSBjaGFuZ2Vk
IHRoZSBzaWduYWwgbWFzaywgd2UgbmVlZCB0byByZXN0b3JlIHRoZSBvcmlnaW5hbCBvbmUuDQo+
ID4+ICAgICAgICogSW4gY2FzZSB3ZSd2ZSBnb3QgYSBzaWduYWwgd2hpbGUgd2FpdGluZywgd2Ug
ZG8gbm90IHJlc3RvcmUgdGhlDQo+ID4+ICAgICAgICogc2lnbmFsIG1hc2sgeWV0LCBhbmQgd2Ug
YWxsb3cgZG9fc2lnbmFsKCkgdG8gZGVsaXZlciB0aGUgc2lnbmFsIG9uDQo+ID4+ICAgICAgICog
dGhlIHdheSBiYWNrIHRvIHVzZXJzcGFjZSwgYmVmb3JlIHRoZSBzaWduYWwgbWFzayBpcyByZXN0
b3JlZC4NCj4gPj4gICAgICAgKi8NCj4gPj4gICAgICBpZiAoc2lnbWFzaykgew0KPiA+PiAgICAg
ICAgICAgICAjIyMjIyMjIFRoaXMgZXJyIGhhcyBub3QgYmVlbiBjaGFuZ2VkIHNpbmNlIGVwX3Bv
bGwoKQ0KPiA+PiAgICAgICAgICAgICAjIyMjIyMjIFNvIGlmIHRoZXJlIGlzIGEgc2lnbmFsIGJl
Zm9yZSB0aGlzIHBvaW50LCBidXQNCj4gPj4gZXJyID0gMCwgdGhlbiB3ZSBnb3RvIGVsc2UuDQo+
ID4+ICAgICAgICAgICAgICBpZiAoZXJyID09IC1FSU5UUikgew0KPiA+PiAgICAgICAgICAgICAg
ICAgICAgICBtZW1jcHkoJmN1cnJlbnQtPnNhdmVkX3NpZ21hc2ssICZzaWdzYXZlZCwNCj4gPj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpemVvZihzaWdzYXZlZCkpOw0KPiA+PiAgICAg
ICAgICAgICAgICAgICAgICBzZXRfcmVzdG9yZV9zaWdtYXNrKCk7DQo+ID4+ICAgICAgICAgICAg
ICB9IGVsc2UNCj4gPj4gICAgICAgICAgICAgICAgICAgICMjIyMjIyMjIyMjIyBUaGlzIGlzIGEg
cHJvYmxlbSBpZiB0aGVyZSBpcyBzaWduYWwNCj4gPj4gcGVuZGluZyB0aGF0IGlzIHNpZ21hc2sg
c2hvdWxkIGJsb2NrLg0KPiA+PiAgICAgICAgICAgICAgICAgICAgIyMjIyMjIyMjIyMgVGhpcyBp
cyB0aGUgd2hvbGUgcmVhc29uIHdlIGhhdmUNCj4gPj4gY3VycmVudC0+c2F2ZWRfc2lnbWFzaz8N
Cj4gPj4gICAgICAgICAgICAgICAgICAgICAgc2V0X2N1cnJlbnRfYmxvY2tlZCgmc2lnc2F2ZWQp
Ow0KPiA+PiAgICAgIH0NCj4gPg0KPiA+IFdoYXQgaGFwcGVucyBpZiBhbGwgdGhhdCBjcmFwIGlz
IGp1c3QgZGVsZXRlZCAoSSBwcmVzdW1lIGZyb20gdGhlDQo+ID4gYm90dG9tIG9mIGVwX3dhaXQo
KSkgPw0KPiANCj4gSG1tLCB5b3UgaGF2ZSB0byB1cGRhdGUgdGhlIHNhdmVkX3NpZ21hc2sgb3Ig
dGhlIHNpZ21hc2suDQoNCkRvZXNuJ3QgdGhlIHRvcCBvZiBlcF9wb2xsKCkgZG8gYWxsIHRoYXQ/
DQpTb21ldGhpbmcgbGlrZSBjb3B5aW5nIHRoZSBjdXJyZW50IHNpZ21hc2sgdG8gdGhlIHNhdmVk
X3NpZ21hc2sNCmFuZCB0aGUgdXNlci1zdXBwbGllZCBzaWdtYXNrIHRvIHRoZSBjdXJyZW50IHNp
Z21hc2suDQpPdGhlcndpc2UgdGhlIHNsZWVwcyB3b24ndCBiZSBpbnRlcnJ1cHRpYmxlLg0KDQpJ
dCBpcyB3b3J0aCBub3RpbmcgdGhhdCBib3RoIHBzZWxlY3QoKSBhbmQgZXBvbGxfcHdhaXQoKSBk
aWZmZXINCmZyb20gc2lnd2FpdCgpIChhbmQgZnJpZW5kcykgd2hpY2ggd2VyZSAoSUlSQykgdGhl
IGZpcnN0IHN5c3RlbQ0KY2FsbHMgdG8gdHJ5IHRvIHJlbW92ZSB0aGUgdGltaW5nIHdpbmRvd3Mg
YXNzb2NpYXRlZCB3aXRoIHdhaXRpbmcNCmZvciBzaWduYWxzLg0Kc2lnd2FpdCgpIHJldHVybnMg
dGhlIHNpZ25hbCBudW1iZXIgYW5kIHJlbW92ZXMgaXQgZnJvbSB0aGUgcGVuZGluZw0KbWFzayAt
IHNvIHRoZSBzaWduYWwgaGFuZGxlciB3b24ndCBiZSBjYWxsZWQgZm9yIHRoZSByZXR1cm5lZCBz
aWduYWwuDQooVW5sZXNzIGl0IHdhc24ndCBhY3R1YWxseSBtYXNrZWQhKQ0KU28gdGhlIHNpZ3dh
aXQoKSBjb2RlIGRvZXMgaGF2ZSB0byByZXN0b3JlIHRoZSBzaWduYWwgbWFzayBpdHNlbGYuDQoN
Cj4gPiBJJ20gZ3Vlc3NpbmcgdGhhdCBvbiB0aGUgd2F5IGJhY2sgdG8gdXNlcnNwYWNlIHNpZ25h
bCBoYW5kbGVycyBmb3INCj4gPiBzaWduYWxzIGVuYWJsZWQgaW4gdGhlIHByb2Nlc3MncyBjdXJy
ZW50IG1hc2sgKHRoZSBvbmUgc3BlY2lmaWVkDQo+ID4gdG8gZXBvbGxfcHdhaXQpIGdldCBjYWxs
ZWQuDQo+ID4gVGhlbiB0aGUgc2lnbmFsIG1hc2sgaXMgbG9hZGVkIGZyb20gY3VycmVudC0+c2F2
ZWRfc2lnbWFzayBhbmQNCj4gPiBhbmQgZW5hYmxlZCBzaWduYWwgaGFuZGxlcnMgYXJlIGNhbGxl
ZCBhZ2Fpbi4NCj4gDQo+IFdobyBpcyBzYXZpbmcgdGhpcyBzYXZlZF9zaWdtYXNrIHRoYXQgaXMg
YmVpbmcgcmVzdG9yZWQgb24gdGhlIHdheSBiYWNrPw0KDQpJdCBoYXMgdG8gYmUgc2F2ZWQgd2hl
biB0aGUgdXNlci1zdXBwbGllZCBvbmUgaW4gaW5zdGFsbGVkLg0KDQo+ID4gTm8gc3BlY2lhbCBj
b2RlIHRoZXJlIHRoYXQgZGVwZW5kcyBvbiB0aGUgc3lzY2FsbCByZXN1bHQsIGVycm5vDQo+ID4g
b2YgdGhlIHN5c2NhbGwgbnVtYmVyLg0KPiANCj4gSSBkaWRu4oCZdCBzYXkgdGhpcyBoYXMgYW55
dGhpbmcgdG8gZG8gd2l0aCBlcnJuby4NCg0KVGhlIGNvZGUgc25pcHBldCBhYm92ZSBjaGVja3Mg
aXQgLi4uDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1s
ZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJh
dGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

