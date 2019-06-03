Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6599132FEA
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 14:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfFCMnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 08:43:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:22668 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbfFCMnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 08:43:15 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-6-SDVVZ0DCOw-CfAQMUB-rxA-1;
 Mon, 03 Jun 2019 13:43:09 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 3 Jun 2019 13:43:08 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 3 Jun 2019 13:43:08 +0100
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
Thread-Index: AQHVGfoc7Nk6FX5Ty02s910sxgLWxaaJxwdw///34ACAAB3mMA==
Date:   Mon, 3 Jun 2019 12:43:08 +0000
Message-ID: <1ca8a995328f449fa58f732ebe70e378@AcuMS.aculab.com>
References: <20190603104902.23799-1-yamada.masahiro@socionext.com>
 <3dcacca3f71c46cc98fa64b13a405b59@AcuMS.aculab.com>
 <CAK7LNATt=P5rHrnK_8PTmjMb+tdtPg2qBgopRUDBFw_fkP2SsQ@mail.gmail.com>
In-Reply-To: <CAK7LNATt=P5rHrnK_8PTmjMb+tdtPg2qBgopRUDBFw_fkP2SsQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: SDVVZ0DCOw-CfAQMUB-rxA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTWFzYWhpcm8gWWFtYWRhDQo+IFNlbnQ6IDAzIEp1bmUgMjAxOSAxMjo0NQ0KPiBPbiBN
b24sIEp1biAzLCAyMDE5IGF0IDg6MTYgUE0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAYWN1
bGFiLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBNYXNhaGlybyBZYW1hZGENCj4gPiA+IFNl
bnQ6IDAzIEp1bmUgMjAxOSAxMTo0OQ0KPiA+ID4NCj4gPiA+IFRvIHByaW50IHRoZSBwYXRobmFt
ZSB0aGF0IHdpbGwgYmUgdXNlZCBieSBzaGVsbCBpbiB0aGUgY3VycmVudA0KPiA+ID4gZW52aXJv
bm1lbnQsICdjb21tYW5kIC12JyBpcyBhIHN0YW5kYXJkaXplZCB3YXkuIFsxXQ0KPiA+ID4NCj4g
PiA+ICd3aGljaCcgaXMgYWxzbyBvZnRlbiB1c2VkIGluIHNjcmlwdGluZywgYnV0IGl0IGlzIG5v
dCBwb3J0YWJsZS4NCj4gPg0KPiA+IEFsbCB1c2VzIG9mICd3aGljaCcgc2hvdWxkIGJlIGV4cHVu
Z2VkLg0KPiA+IEl0IGlzIGEgYm91cm5lIHNoZWxsIHNjcmlwdCB0aGF0IGlzIHRyeWluZyB0byBl
bXVsYXRlIGEgY3NoIGJ1aWx0aW4uDQo+ID4gSXQgaXMgZG9vbWVkIHRvIGZhaWwgaW4gY29ybmVy
IGNhc2VzLg0KPiA+IElTVFIgaXQgaGFzIHNlcmlvdXMgcHJvYmxlbXMgd2l0aCBzaGVsbCBmdW5j
dGlvbnMgYW5kIGFsaWFzZXMuDQo+IA0KPiBPSywgSSBkbyBub3QgaGF2ZSB0aW1lIHRvIGNoZWNr
IGl0IHRyZWV3aWRlLg0KPiBJIGV4cGVjdCBzb21lYm9keSB3aWxsIGNvbnRyaWJ1dGUgdG8gaXQu
DQo+IA0KPiANCj4gDQo+IEJUVywgSSBzZWUgeWV0IGFub3RoZXIgd2F5IHRvIGdldCB0aGUgY29t
bWFuZCBwYXRoLg0KPiANCj4gJ3R5cGUgLXBhdGgnIGlzIGJhc2gtc3BlY2lmaWMuDQoNCid0eXBl
JyBpdHNlbGYgc2hvdWxkIGJlIHN1cHBvcnRlZCBieSBhbGwgc2hlbGxzLCBidXQgdGhlIG91dHB1
dA0KZm9ybWF0IChlc3AgZm9yIGVycm9ycykgcHJvYmFibHkgdmFyaWVzLg0KDQo+IE1heWJlLCB3
ZSBzaG91bGQgZG8gdGhpcyB0b286DQo+IA0KPiBkaWZmIC0tZ2l0IGEvc2NyaXB0cy9ta3Vib290
LnNoIGIvc2NyaXB0cy9ta3Vib290LnNoDQo+IGluZGV4IDRiMWZlMDllOTA0Mi4uNzc4MjllZTQy
NjhlIDEwMDc1NQ0KPiAtLS0gYS9zY3JpcHRzL21rdWJvb3Quc2gNCj4gKysrIGIvc2NyaXB0cy9t
a3Vib290LnNoDQo+IEBAIC0xLDE0ICsxLDE0IEBADQo+IC0jIS9iaW4vYmFzaA0KPiArIyEvYmlu
L3NoDQoNCi9iaW4vc2ggbWlnaHQgYmUgJ2Rhc2gnIC0gd2hpY2ggaXMganVzdCBwbGFpbiBicm9r
ZW4gaW4gc28gbWFueSB3YXlzLg0KVHJ5IChJSVJDKSAke2ZvbyUke2ZvbyNiYXJ9fQ0KSXQgbWln
aHQgZXZlbiBiZSB0aGUgb3JpZ2luYWwgU1lTViAvYmluL3NoIHdoaWNoIGRvZXNuJ3Qgc3VwcG9y
dCAkKChleHByKSkNCm9yICR7Zm9vI2Jhcn0gLSBidXQgdGhhdCBtYXkgYnJlYWsgdG9vIG11Y2gs
IGJ1dCAkU0hFTEwgbWlnaHQgZml4IGl0Lg0KDQpkYXNoIHByb2JhYmx5IGhhcyB0aGUgcmF0aGVy
IG9ic2N1cmUgYnVnIGluIHN0cmlwcGluZyAnXG4nIGZyb20gJCguLi4pDQpvdXRwdXQgdGhhdCBJ
IGZvdW5kIGFuZCBmaXhlZCBpbiBOZXRCU0QncyBhc2ggbWF5IHllYXJzIGFnby4NClRyeTogZm9v
PSIkKGpvdCAtYiAiIiAxMzApIg0KQWxsIDEzMCAnXG4nIHNob3VsZCBiZSBkZWxldGVkLg0KTW9z
dGx5IGl0IGZhaWxzIHRvIGRlbGV0ZSBhbGwgdGhlICdcbicsIGJ1dCBpdCBjYW4gcmVtb3ZlIGV4
dHJhIG9uZXMhDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

