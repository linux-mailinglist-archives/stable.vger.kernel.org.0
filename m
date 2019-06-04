Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A6134287
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfFDJBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:01:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:52024 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727134AbfFDJBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 05:01:35 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-5-JkTxSXOoNISA2RzXYu7j5g-1;
 Tue, 04 Jun 2019 10:01:32 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 4 Jun 2019 10:01:32 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 4 Jun 2019 10:01:32 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Masahiro Yamada' <yamada.masahiro@socionext.com>
CC:     "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "Vineet Gupta" <vgupta@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] kbuild: use more portable 'command -v' for
 cc-cross-prefix
Thread-Topic: [PATCH] kbuild: use more portable 'command -v' for
 cc-cross-prefix
Thread-Index: AQHVGfoc7Nk6FX5Ty02s910sxgLWxaaJxI+g///4bICAACdTsIAA4rqAgABrGkA=
Date:   Tue, 4 Jun 2019 09:01:31 +0000
Message-ID: <96b710063de5464ea347bfa1e03308b5@AcuMS.aculab.com>
References: <20190603104902.23799-1-yamada.masahiro@socionext.com>
 <863c29c5f0214c008fbcbb2aac517a5c@AcuMS.aculab.com>
 <CAK7LNARHR=xv_YxQCkCM7PtW3vpNfXOgZrez0c4HbMX6C-8-uA@mail.gmail.com>
 <810dd6ae018b4a31b70d26fb6b29e48d@AcuMS.aculab.com>
 <CAK7LNAR_A1d5keiCRthNioW3nqkNadJkaCyMR3a5S8WS0jhgNQ@mail.gmail.com>
In-Reply-To: <CAK7LNAR_A1d5keiCRthNioW3nqkNadJkaCyMR3a5S8WS0jhgNQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: JkTxSXOoNISA2RzXYu7j5g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTWFzYWhpcm8gWWFtYWRhDQo+IFNlbnQ6IDA0IEp1bmUgMjAxOSAwNDozMQ0KLi4uDQo+
ID4gPiA+IFlvdSBjb3VsZCB1c2U6DQo+ID4gPiA+ICAgICAgICAgJChzaGVsbCBzaCAtYyAiY29t
bWFuZCAtdiAkKGMpZ2NjIikNCj4gPiA+ID4gb3IgbWF5YmU6DQo+ID4gPiA+ICAgICAgICAgJChz
aGVsbCBjb21tYW5kJCR7eDorfSAtdiAkKGMpZ2NjKQ0KPiA+ID4NCj4gPiA+DQo+ID4gPiBIb3cg
YWJvdXQgdGhpcz8NCj4gPiA+DQo+ID4gPiAgICAgICAgICAgJChzaGVsbCA6IH47IGNvbW1hbmQg
LXYgJChjKWdjYykNCj4gPg0KPiA+IE92ZXJjb21wbGljYXRlZCAuLi4uDQo+ID4NCj4gPiBJJ3Zl
IG5vdCBsb29rZWQgYXQgdGhlIGxpc3Qgb2YgJ3NwZWNpYWwgY2hhcmFjdGVycycgaW4gbWFrZSwN
Cj4gPiBidXQgSSBzdXNwZWN0IGFueSB2YXJpYWJsZSBleHBhbnNpb24gaXMgZW5vdWdoLg0KPiA+
IFNpbmNlICR7eDorfSBhbHdheXMgZXhwYW5kcyB0byB0aGUgZW1wdHkgc3RyaW5nICh3aGV0aGVy
IG9yDQo+ID4gbm90ICd4JyBpcyBkZWZpbmVkKSBpdCBjYW4ndCBoYXZlIGFueSB1bmZvcnR1bmF0
ZSBzaWRlIGVmZmVjdHMuDQo+IA0KPiANCj4gUHJvYmFibHksIG15IGV5ZXMgYXJlIHVzZWQgdG8g
TWFrZWZpbGUuDQo+ICI6IiBpcyBhIG5vLW9wIGNvbW1hbmQsIGFuZCBpdCBpcyB1c2VkIGV2ZXJ5
d2hlcmUgaW4ga2VybmVsIE1ha2VmaWxlcw0KPiBpbiB0aGUgZm9ybSBvZiAiQDonDQo+IA0KPiBJ
dCBkZXBlbmRzIG9uIHBlb3BsZSB3aGljaCBzb2x1dGlvbiBzZWVtcyBzaW1wbGVyLg0KPiBTbywg
dGhpcyBhcmd1bWVudCB0ZW5kcyB0byBlbmQgdXAgd2l0aCBiaWtlc2hlZGluZy4NCg0KSSBhbSBm
dWxseSBhd2FyZSBvZiAnOicsIGl0IGlzIGEgc2hlbGwgYnVpbHRpbiB0aGF0IGFsd2F5cyByZXR1
cm4gc3VjY2Vzcy4NClVzdWFsbHkgdXNlZCB3aGVuIHlvdSB3YW50IHRoZSBzaWRlLWVmZmVjdHMg
b2Ygc3Vic3RpdHV0aW9ucyB3aXRob3V0DQpleGVjdXRpbmcgYW55dGhpbmcgKGVnIDogJHtmb286
PWJhcn0gKSwgdG8gY2hhbmdlIHRoZSByZXN1bHQgb2YgYQ0Kc2VxdWVuY2Ugb2Ygc2hlbGwgY29t
bWFuZHMgb3IgYXMgYSBkdW1teSAoZWcgd2hpbGUgOjsgZG8gOjsgZG9uZTsgKQ0KVmVyeSBhbm5v
eWluZ2x5IGJhc2ggcGFyc2VzICE6IGFzIHNvbWV0aGluZyBvdGhlciB0aGFuICdub3QgdHJ1ZScu
DQoNCiQoc2hlbGwgY29tbWFuZCQke3g6K30gLXYgJChjKWdjYykgd2lsbCBiZSBtYXJnaW5hbGx5
IGZhc3Rlcg0KYmVjYXVzZSBpdCBpcyBsZXNzIHBhcnNpbmcuDQoNCglEYXZpZA0KIA0KDQotDQpS
ZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWls
dG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMp
DQo=

