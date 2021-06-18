Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4820D3AC6CE
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 11:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhFRJKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 05:10:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:26327 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233076AbhFRJKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 05:10:06 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-231-kCri9fpRP8m35SUQHdVvyg-1; Fri, 18 Jun 2021 10:07:54 +0100
X-MC-Unique: kCri9fpRP8m35SUQHdVvyg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 18 Jun
 2021 10:07:53 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Fri, 18 Jun 2021 10:07:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Krzysztof Kozlowski' <krzysztof.kozlowski@canonical.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
Subject: RE: [PATCH 5.4 031/184] modules: inherit TAINT_PROPRIETARY_MODULE
Thread-Topic: [PATCH 5.4 031/184] modules: inherit TAINT_PROPRIETARY_MODULE
Thread-Index: AQHXZB/50QaIqTZSLEykqrpaWct/h6sZeMHQ
Date:   Fri, 18 Jun 2021 09:07:53 +0000
Message-ID: <5ac70bdf2c5b440c83f12e75ca42a107@AcuMS.aculab.com>
References: <20210510101950.200777181@linuxfoundation.org>
 <20210510101951.249384110@linuxfoundation.org>
 <8edc6f45-6c42-19c7-6f40-6f1a49cc685b@canonical.com>
In-Reply-To: <8edc6f45-6c42-19c7-6f40-6f1a49cc685b@canonical.com>
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

RnJvbTogS3J6eXN6dG9mIEtvemxvd3NraQ0KPiBTZW50OiAxOCBKdW5lIDIwMjEgMDk6NTcNCj4g
DQo+IE9uIDEwLzA1LzIwMjEgMTI6MTgsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gPiBG
cm9tOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gPg0KPiA+IGNvbW1pdCAyNjJl
NmFlNzA4MWRmMzA0ZmM2MjVjZjM2OGQ1YzJjYmJhMmJiOTkxIHVwc3RyZWFtLg0KPiA+DQo+ID4g
SWYgYSBUQUlOVF9QUk9QUklFVEFSWV9NT0RVTEUgZXhwb3J0cyBzeW1ib2wsIGluaGVyaXQgdGhl
IHRhaW50IGZsYWcNCj4gPiBmb3IgYWxsIG1vZHVsZXMgaW1wb3J0aW5nIHRoZXNlIHN5bWJvbHMs
IGFuZCBkb24ndCBhbGxvdyBsb2FkaW5nDQo+ID4gc3ltYm9scyBmcm9tIFRBSU5UX1BST1BSSUVU
QVJZX01PRFVMRSBtb2R1bGVzIGlmIHRoZSBtb2R1bGUgcHJldmlvdXNseQ0KPiA+IGltcG9ydGVk
IGdwbG9ubHkgc3ltYm9scy4gIEFkZCBhIGFudGktY2lyY3VtdmVudGlvbiBkZXZpY2VzIHNvIHBl
b3BsZQ0KPiA+IGRvbid0IGFjY2lkZW50YWxseSBnZXQgdGhlbXNlbHZlcyBpbnRvIHRyb3VibGUg
dGhpcyB3YXkuDQo+ID4NCj4gPiBDb21tZW50IGZyb20gR3JlZzoNCj4gPiAgICJBaCwgdGhlIHBy
b3Zlbi10by1iZS1pbGxlZ2FsICJHUEwgQ29uZG9tIiBkZWZlbnNlIDopIg0KPiANCj4gUGF0Y2gg
Z290IGluIHRvIHN0YWJsZSwgc28gbXkgY29tbWVudHMgYXJlIHF1aXRlIGxhdGUsIGJ1dCBjYW4g
c29tZW9uZQ0KPiBleHBsYWluIG1lIC0gaG93IHRoaXMgaXMgYSBzdGFibGUgbWF0ZXJpYWw/IFdo
YXQgc3BlY2lmaWMsIHJlYWwgYnVnIHRoYXQNCj4gYm90aGVycyBwZW9wbGUsIGlzIGJlaW5nIGZp
eGVkIGhlcmU/IE9yIG1heWJlIGl0IGZpeGVzIHNlcmlvdXMgaXNzdWUNCj4gcmVwb3J0ZWQgYnkg
YSB1c2VyIG9mIGRpc3RyaWJ1dGlvbiBrZXJuZWw/IElPVywgaG93IGRvZXMgdGhpcyBtYXRjaA0K
PiBzdGFibGUga2VybmVsIHJ1bGVzIGF0IGFsbD8NCj4gDQo+IEZvciBzdXJlIGl0IGJyZWFrcyBz
b21lIG91dC1vZi10cmVlIG1vZHVsZXMgYWxyZWFkeSBwcmVzZW50IGFuZCB1c2VkIGJ5DQo+IGN1
c3RvbWVycyBvZiBkb3duc3RyZWFtIHN0YWJsZSBrZXJuZWxzLiBUaGVyZWZvcmUgSSB3b25kZXIg
d2hhdCBpcyB0aGUNCj4gYnVnIGZpeGVkIGhlcmUsIHNvIHRoZSBicmVha2FnZSBhbmQgYW5ub3lh
bmNlIG9mIHN0YWJsZSB1c2VycyBpcyBqdXN0aWZpZWQuDQoNCkl0IGFsc28gZG9lc24ndCBzdG9w
IG5vbi1ncGwgb3V0LW9mLXRyZWUgbW9kdWxlcyBkb2luZyBhbnl0aGluZy4NClRoZXkganVzdCBo
YXZlIHRvIGJlIHJlb3JnYW5pemVkIHdpdGggYSAnYmFzZScgR1BMIG1vZHVsZSB0aGF0DQppbmNs
dWRlcyB3cmFwcGVycyBmb3IgYWxsIHRoZSBncGxvbmx5IHN5bWJvbHMgYW5kIHRoZW4gYWxsDQp0
aGUgcmVzdCBvZiB0aGUgbW9kdWxlcyBjYW4gYmUgbm9uLWdwbC4NCg0KVGhpcyBtZWFucyB0aGF0
IGRyaXZlcnMgdGhhdCB3ZXJlIG1hcmtlZCBncGwgbm8gbG9uZ2VyIG5lZWQgdG8NCmJlIGJlY2F1
c2UgdGhleSBub3cgdXNlIHRoZSB3cmFwcGVycy4NCg0KU28gaXQgaXMganVzdCBhbiBhbm5veWFu
Y2UuDQoNCkZvcnR1bmF0ZWx5IG91ciBtYWluIG91dC1vZi10cmVlIGRyaXZlcnMgZG9uJ3QgdXNl
IGFueSBHUEwgYml0cw0KYXQgYWxsIC0gc28gdGhpcyBjaGFuZ2UgZG9lc24ndCBhZmZlY3Qgb3Vy
IGN1c3RvbWVyIHJlbGVhc2VzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExh
a2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQs
IFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

