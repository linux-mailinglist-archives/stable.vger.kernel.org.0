Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14319312D8B
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 10:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBHJl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 04:41:56 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:44108 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231650AbhBHJjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 04:39:46 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-221-Ikoffz3gPGaJpmbA-8X8rQ-2; Mon, 08 Feb 2021 09:38:07 +0000
X-MC-Unique: Ikoffz3gPGaJpmbA-8X8rQ-2
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Feb 2021 09:38:05 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Feb 2021 09:38:05 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>, 'Willy Tarreau' <w@1wt.eu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC:     Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lwn@lwn.net" <lwn@lwn.net>, "jslaby@suse.cz" <jslaby@suse.cz>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>
Subject: RE: Linux 4.4.256
Thread-Topic: Linux 4.4.256
Thread-Index: AQHW/It+/rP1vSf8XEWqgVFokkPLWqpN9+RwgAAJ1gA=
Date:   Mon, 8 Feb 2021 09:38:05 +0000
Message-ID: <7f4be7044f4a4c77ad101d7e3ac71b40@AcuMS.aculab.com>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net> <YB6S612pwLbQJf4u@kroah.com>
 <20210206131113.GB7312@1wt.eu> <20210206132239.GC7312@1wt.eu>
 <54e88e8d1ba1487ba43eb36ddfec4e5a@AcuMS.aculab.com>
In-Reply-To: <54e88e8d1ba1487ba43eb36ddfec4e5a@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDA4IEZlYnJ1YXJ5IDIwMjEgMDk6MTANCj4gDQo+
IEZyb206IFdpbGx5IFRhcnJlYXUNCj4gPiBTZW50OiAwNiBGZWJydWFyeSAyMDIxIDEzOjIzDQo+
ID4NCj4gPiBPbiBTYXQsIEZlYiAwNiwgMjAyMSBhdCAwMjoxMToxM1BNICswMTAwLCBXaWxseSBU
YXJyZWF1IHdyb3RlOg0KPiA+ID4gU29tZXRoaW5nIGxpa2UgdGhpcyBsb29rcyBtb3JlIHJvYnVz
dCB0byBtZSwgaXQgd2lsbCB1c2UgU1VCTEVWRUwgZm9yDQo+ID4gPiB2YWx1ZXMgMCB0byAyNTUg
YW5kIDI1NSBmb3IgYW55IGxhcmdlciB2YWx1ZToNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9NYWtl
ZmlsZSBiL01ha2VmaWxlDQo+ID4gaW5kZXggN2Q4NmFkNmFkMzZjLi45YjkxYjg4MTViNDAgMTAw
NjQ0DQo+ID4gLS0tIGEvTWFrZWZpbGUNCj4gPiArKysgYi9NYWtlZmlsZQ0KPiA+IEBAIC0xMjUy
LDcgKzEyNTIsNyBAQCBlbmRlZg0KPiA+DQo+ID4gIGRlZmluZSBmaWxlY2hrX3ZlcnNpb24uaA0K
PiA+ICAJZWNobyBcI2RlZmluZSBMSU5VWF9WRVJTSU9OX0NPREUgJChzaGVsbCAgICAgICAgICAg
ICAgICAgICAgICAgICBcDQo+ID4gLQlleHByICQoVkVSU0lPTikgXCogNjU1MzYgKyAwJChQQVRD
SExFVkVMKSBcKiAyNTYgKyAwJChTVUJMRVZFTCkpOyBcDQo+ID4gKwlleHByICQoVkVSU0lPTikg
XCogNjU1MzYgKyAwJChQQVRDSExFVkVMKSBcKiAyNTYgKyAyNTUgXCogXCggMCQoU1VCTEVWRUwp
IFw+IDI1NSBcKSArDQo+ID4gMCQoU1VCTEVWRUwpIFwqIFwoIDAkKFNVQkxFVkVMKSBcPD0gMjU1
IFwpICk7IFwNCj4gPiAgCWVjaG8gJyNkZWZpbmUgS0VSTkVMX1ZFUlNJT04oYSxiLGMpICgoKGEp
IDw8IDE2KSArICgoYikgPDwgOCkgKyAoYykpJw0KPiA+ICBlbmRlZg0KPiANCj4gV2h5IG5vdDoN
Cj4gCSQoc2hlbGwgZWNobyAkJCgoJChWRVJTSU9OKTw8MTYgKyAkKFBBVENITEVWRUwpPDw4ICsg
KCQoU1VCVkVSU0lPTikgPCAyNTUgPyAkKFNVQlZFUlNJT04pIDoNCj4gMjU1KSkpKQ0KPiBVbnRl
c3RlZCwgYnV0IEkgdGhpbmsgb25seSB0aGUgb25lICQgbmVlZHMgYW55IGtpbmQgb2YgZXNjYXBl
Lg0KPiBUaGUgZXh0cmEgbGVhZGluZyB6ZXJvcyBkbyBoYXZlIHRvIGdvIC0gJCgoLi4uKSkgZG9l
cyBvY3RhbCA6LSgNCg0KT3IgcHJvYmFibHkgZXZlbiBiZXR0ZXI6DQoNCmVjaG8gJyNkZWZpbmUg
S0VSTkVMX1ZFUlNJT04oYSxiLGMpICgoKGEpIDw8IDE2KSArICgoYikgPDwgOCkgKyAoKGMpID4g
MjU1ID8gMjU1IDogKGMpKSknDQplY2hvICcjZGVmaW5lIExJTlVYX1ZFUlNJT05fQ09ERSBLRVJO
RUxfVkVSU0lPTigkKFZFUlNJT04pLCAkKFBBVENITEVWRUwpKzAsICQoU1VCTEVWRUwpKzApJw0K
DQpXaGljaCBnZXRzIHJpZCBvZiB0aGUgJChzaGVsbCkgYXMgd2VsbC4NCg0KCURhdmlkDQoNCi0N
ClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBN
aWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxl
cykNCg==

