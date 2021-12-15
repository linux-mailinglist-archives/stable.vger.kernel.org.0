Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A7D475830
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 12:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242197AbhLOLvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 06:51:54 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:20935 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240633AbhLOLvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 06:51:54 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-124-_dpB1O-2NOunUQz0c53HRA-1; Wed, 15 Dec 2021 11:51:51 +0000
X-MC-Unique: _dpB1O-2NOunUQz0c53HRA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Wed, 15 Dec 2021 11:51:50 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Wed, 15 Dec 2021 11:51:50 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vlastimil Babka' <vbabka@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>
CC:     Baoquan He <bhe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>,
        "John.p.donnelly@oracle.com" <John.p.donnelly@oracle.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: RE: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Thread-Topic: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Thread-Index: AQHX8Z9KFPBHK7AOm0iccdN5CkYjd6wzbbQg
Date:   Wed, 15 Dec 2021 11:51:50 +0000
Message-ID: <67ff367b7a90452f8c009707a00e67b2@AcuMS.aculab.com>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com> <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
 <20211215044818.GB1097530@odroid> <20211215070335.GA1165926@odroid>
 <20211215072710.GA3010@lst.de> <f7c1f169-f9b3-6930-f933-d69ab0287069@suse.cz>
In-Reply-To: <f7c1f169-f9b3-6930-f933-d69ab0287069@suse.cz>
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

RnJvbTogVmxhc3RpbWlsIEJhYmthDQo+IFNlbnQ6IDE1IERlY2VtYmVyIDIwMjEgMTA6MzQNCj4g
DQo+IE9uIDEyLzE1LzIxIDA4OjI3LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gPiBPbiBX
ZWQsIERlYyAxNSwgMjAyMSBhdCAwNzowMzozNUFNICswMDAwLCBIeWVvbmdnb24gWW9vIHdyb3Rl
Og0KPiA+PiBJJ20gbm90IHN1cmUgdGhhdCBhbGxvY2F0aW5nIGZyb20gWk9ORV9ETUEzMiBpbnN0
ZWFkIG9mIFpPTkVfRE1BDQo+ID4+IGZvciBrZHVtcCBrZXJuZWwgaXMgbmljZSB3YXkgdG8gc29s
dmUgdGhpcyBwcm9ibGVtLg0KPiA+DQo+ID4gV2hhdCBpcyB0aGUgcHJvYmxlbSB3aXRoIHpvbmVz
IGluIGtkdW1wIGtlcm5lbHM/DQo+IA0KPiBNeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQga2R1bXAg
a2VybmVsIGNhbiBvbmx5IHVzZSBwaHlzaWNhbCBtZW1vcnkgdGhhdCBpdA0KPiBnb3QgcmVzZXJ2
ZWQgYnkgdGhlIG1haW4ga2VybmVsLCBhbmQgdGhlIG1haW4ga2VybmVsIHdpbGwgcmVzZXJ2ZSBz
b21lIGJsb2NrDQo+IG9mIG1lbW9yeSB0aGF0IGRvZXNuJ3QgaW5jbHVkZSBhbnkgcGFnZXMgZnJv
bSBaT05FX0RNQSAoZmlyc3QgMTZNQiBvZg0KPiBwaHlzaWNhbCBtZW1vcnkgb3Igd2hhdG5vdCku
IA0KLi4uDQoNCklzIHRoZXJlIHN0aWxsIGFueSBzdXBwb3J0IGZvciBhbnkgb2YgdGhlIHZlcnkg
b2xkIGhhcmR3YXJlIHRoYXQgY291bGQgb25seQ0Kc3VwcG9ydCAyNGJpdCBETUE/DQoNCkkgdGhp
bmsgdGhlIEFNRCBQQ25ldC1JU0EgYW5kIFBDbmV0LVBDSSBldGhlcm5ldCAobGFuY2UpIHdlcmUg
Ym90aCAzMmJpdCBtYXN0ZXJzLg0KKEkgZG9uJ3QgcmVtZW1iZXIgZXZlciBoYXZpbmcgdG8gd29y
cnkgYWJvdXQgcGh5c2ljYWwgYWRkcmVzc2VzLikNCkknbSBzdXJlIEkgcmVtZW1iZXIgc29tZSBv
bGQgU0NTSSBib2FyZHMgb25seSBiZWluZyBhYmxlIHRvIGRvIDI0Yml0IERNQS4NCkJ1dCBJIGNh
bid0IHJlbWVtYmVyIHdoaWNoIGJ1cyBpbnRlcmZhY2UgdGhleSB3ZXJlLg0KVW5saWtlbHkgdG8g
YmUgSVNBIGJlY2F1c2UgaXQgaGFzIGFsd2F5cyBiZWVuIGhhcmQgdG8gZ2V0IGEgbW90aGVyYm9h
cmQNCkRNQSBjaGFubmVsIGludG8gJ2Nhc2NhZGUgbW9kZScuDQoNCk1pZ2h0IGhhdmUgYmVlbiBz
b21lIEVJU0EgYm9hcmRzIC0gYW55b25lIHN0aWxsIHVzZSB0aG9zZT8NClNvIHdlIGFyZSBsZWZ0
IHdpdGggZWFybHkgUENJIGJvYXJkcy4NCg0KSXQgcmVhbGx5IGlzIHdvcnRoIGxvb2tpbmcgYXQg
d2hhdCBhY3R1YWxseSBuZWVkcyBpdCBhdCBhbGwuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVk
IEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5l
cywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

