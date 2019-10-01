Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC278C39B7
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfJAQA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:00:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:43183 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbfJAQAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 12:00:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-164--oUOnduMO7u6T_CwoD2SuA-1; Tue, 01 Oct 2019 17:00:21 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 1 Oct 2019 17:00:21 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 1 Oct 2019 17:00:21 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'efremov@linux.com'" <efremov@linux.com>,
        'Dan Carpenter' <dan.carpenter@oracle.com>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
Thread-Topic: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
Thread-Index: AQHVd36LU5ikVLKK6EuvH5wLNYQtMKdEMyLwgAGeKE+AAAh2kP///AWAgAAc6lA=
Date:   Tue, 1 Oct 2019 16:00:20 +0000
Message-ID: <35c2d89987854fb8a42f04dc28ad4bc9@AcuMS.aculab.com>
References: <20190930110141.29271-1-efremov@linux.com>
 <37b195b700394e95aa8329afc9f60431@AcuMS.aculab.com>
 <e4051dcb-10dc-ff17-ec0b-6f51dccdb5bf@linux.com>
 <20191001135649.GH22609@kadam>
 <8d2e8196cae74ec4ae20e9c23e898207@AcuMS.aculab.com>
 <a7c002f7-c6f2-a9ed-0100-acfbafea65c5@linux.com>
In-Reply-To: <a7c002f7-c6f2-a9ed-0100-acfbafea65c5@linux.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: -oUOnduMO7u6T_CwoD2SuA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRGVuaXMgRWZyZW1vdg0KPiBTZW50OiAwMSBPY3RvYmVyIDIwMTkgMTY6MTMNCi4uLg0K
PiBKdXN0IGZvdW5kIGFuIG9mZmljaWFsIGRvY3VtZW50YXRpb24gdG8gdGhpcyBpc3N1ZToNCj4g
aHR0cHM6Ly9nY2MuZ251Lm9yZy9nY2MtNC45L3BvcnRpbmdfdG8uaHRtbA0KPiAiTnVsbCBwb2lu
dGVyIGNoZWNrcyBtYXkgYmUgb3B0aW1pemVkIGF3YXkgbW9yZSBhZ2dyZXNzaXZlbHkNCj4gLi4u
DQo+IFRoZSBwb2ludGVycyBwYXNzZWQgdG8gbWVtbW92ZSAoYW5kIHNpbWlsYXIgZnVuY3Rpb25z
IGluIDxzdHJpbmcuaD4pIG11c3QgYmUgbm9uLW51bGwNCj4gZXZlbiB3aGVuIG5ieXRlcz09MCwg
c28gR0NDIGNhbiB1c2UgdGhhdCBpbmZvcm1hdGlvbiB0byByZW1vdmUgdGhlIGNoZWNrIGFmdGVy
IHRoZQ0KPiBtZW1tb3ZlIGNhbGwuIENhbGxpbmcgY29weShwLCBOVUxMLCAwKSBjYW4gdGhlcmVm
b3JlIGRlZmVyZW5jZSBhIG51bGwgcG9pbnRlciBhbmQgY3Jhc2guIg0KDQpSaWdodCwgc28ganVz
dCBkb24ndCBjb2RlIGEgTlVMTCBwb2ludGVyIHRlc3QgYWZ0ZXIgYSBtZW1jcHkoKSBjYWxsLg0K
VGhlcmUgaXMgbm8gbmVlZCB0byBhdm9pZCB0aGUgY2FsbCBpdHNlbGYuDQoNCj4gQnV0IGFnYWlu
LCBJIHdvdWxkIHNheSB0aGF0IHRoZSBidWcgaW4gdGhpcyBjb2RlIGlzIGJlY2F1c2UgdGhlIGlm
IGNvbmRpdGlvbiB3YXMgY29weS1wYXN0ZWQNCj4gYW5kIGl0IHNob3VsZCBiZSBpbnZlcnRlZC4N
Cg0KT2gsIHRoZSBjb2RlIGlzIHF1ZXN0aW9uIGlzIGp1c3Qgc3R1cGlkbHkgYmFkLg0KSXQgc2Vl
bWVkIHRvIGRvOg0KCWlmIChhKQ0KCQl4Ow0KCWVsc2UgaWYgKCFhKQ0KCQl5Ow0KCWVsc2UNCgkJ
ZXJyb3IgKCJhbGwgYm9ya2VkIikNCg0KSWYgdGhlIHdob2xlIGRyaXZlciBpcyB3cml0dGVuIGxp
a2UgdGhhdCBpdCBuZWVkcyBmaXhpbmcgYmVmb3JlIGFueW9uZSB0YWtlcyBhIHNlcmlvdXMgbG9v
ayBhdCBpdC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0
cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

