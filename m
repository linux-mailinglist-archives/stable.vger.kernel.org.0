Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152CD2F983
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 11:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfE3Je4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 05:34:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:41601 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbfE3Je4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 05:34:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-43-7gh7PonmMjqzmTiRGe_CfA-1; Thu, 30 May 2019 10:34:54 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 May 2019 10:34:53 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 May 2019 10:34:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Wong' <e@80x24.org>
CC:     'Oleg Nesterov' <oleg@redhat.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "dave@stgolabs.net" <dave@stgolabs.net>,
        "jbaron@akamai.com" <jbaron@akamai.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: pselect/etc semantics (Was: [PATCH v2] signal: Adjust error codes
 according to restore_user_sigmask())
Thread-Topic: pselect/etc semantics (Was: [PATCH v2] signal: Adjust error
 codes according to restore_user_sigmask())
Thread-Index: AQHVFjlRjDlHH6TU60ajIVKPNNmjrqaCR7xwgAAZvgCAAP1NYA==
Date:   Thu, 30 May 2019 09:34:53 +0000
Message-ID: <a703239f468d44d3b3e7d71b40289072@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <b05cec7f9e8f457281e689576a7a360f@AcuMS.aculab.com>
 <20190529185012.qqeqq4fsolprknrz@dcvr>
In-Reply-To: <20190529185012.qqeqq4fsolprknrz@dcvr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 7gh7PonmMjqzmTiRGe_CfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRXJpYyBXb25nDQo+IFNlbnQ6IDI5IE1heSAyMDE5IDE5OjUwDQouLi4NCj4gPiBQZXJz
b25hbGx5IEkgdGhpbmsgdGhhdCBpcyB3cm9uZy4NCj4gPiBHaXZlbiBjb2RlIGxpa2UgdGhlIGFi
b3ZlIHRoYXQgaGFzOg0KPiA+IAkJd2hpbGUgKCFpbnRlcnJ1cHRlZCkgew0KPiA+IAkJCXBzZWxl
Y3QoLi4uLCAmc2lnaW50KTsNCj4gPiAJCQkvLyBwcm9jZXNzIGF2YWlsYWJsZSBkYXRhDQo+ID4g
CQl9DQo+ID4NCj4gPiBZb3Ugd2FudCB0aGUgc2lnbmFsIGhhbmRsZXIgdG8gYmUgZXhlY3V0ZWQg
ZXZlbiBpZiBvbmUgb2YgdGhlIGZkcw0KPiA+IGFsd2F5cyBoYXMgYXZhaWxhYmxlIGRhdGEuDQo+
ID4gT3RoZXJ3aXNlIHlvdSBjYW4ndCBpbnRlcnJ1cHQgYSBwcm9jZXNzIHRoYXQgaXMgYWx3YXlz
IGJ1c3kuDQoNCkZXSVcgaW4gdGhlIHBhc3QgSSd2ZSBzZWVuIGEgcHJvY2VzcyB0aGF0IGxvb3Bz
IHNlbGVjdC1hY2NlcHQtZm9yay1leGVjDQpnZXQgaXRzIHByaW9yaXR5IHJlZHVjZWQgdG8gdGhl
IHBvaW50IHdoZXJlIGl0IG5ldmVyIGJsb2NrZWQNCmluIHNlbGVjdC4gVGhlIGNsaWVudCBzaWRl
IHJldHJpZXMgbWFkZSBpdCBnbyBiYWRseSB3cm9uZyENCklmIGl0IGhhZCBsaW1pdGVkIHdoZW4g
U0lHX0lOVCB3YXMgZGV0ZWN0ZWQgaXQgd291bGQgaGF2ZSBiZWVuDQphIGxpdHRsZSBtb3JlIGRp
ZmZpY3VsdCB0byBraWxsLg0KDQo+IEFncmVlZC4uLiAgSSBiZWxpZXZlIGNtb2dzdG9yZWQgaGFz
IGFsd2F5cyBoYWQgYSBidWcgaW4gdGhlIHdheQ0KPiBpdCB1c2VzIGVwb2xsX3B3YWl0IGJlY2F1
c2UgaXQgZmFpbGVkIHRvIGNoZWNrIGludGVycnVwdHMgaWY6DQo+IA0KPiBhKSBhbiBGRCBpcyBy
ZWFkeSArIGludGVycnVwdA0KPiBiKSBlcG9sbF9wd2FpdCByZXR1cm5zIDAgb24gaW50ZXJydXB0
DQoNCkJ1dCB0aGUga2VybmVsIGNvZGUgc2VlbXMgdG8gb25seSBjYWxsIHRoZSBzaWduYWwgaGFu
ZGxlcg0KKGZvciBzaWduYWxzIHRoYXQgYXJlIGVuYWJsZWQgZHVyaW5nIHBzZWxlY3QoKSAoZXRj
KSkgaWYNCnRoZSB1bmRlcmx5aW5nIHdhaXQgaXMgaW50ZXJydXB0ZWQuDQoNCj4gVGhlIGJ1ZyBy
ZW1haW5zIGluIHVzZXJzcGFjZSBmb3IgYSksIHdoaWNoIEkgd2lsbCBmaXggYnkgYWRkaW5nDQo+
IGFuIGludGVycnVwdCBjaGVjayB3aGVuIGFuIEZEIGlzIHJlYWR5LiAgVGhlIHdpbmRvdyBpcyB2
ZXJ5DQo+IHNtYWxsIGZvciBhKSBhbmQgZGlmZmljdWx0IHRvIHRyaWdnZXIsIGFuZCBhbHNvIGlu
IGEgcmFyZSBjb2RlDQo+IHBhdGguDQo+IA0KPiBUaGUgYikgY2FzZSBpcyB0aGUga2VybmVsIGJ1
ZyBpbnRyb2R1Y2VkIGluIDg1NGE2ZWQ1NjgzOWE0MGYNCj4gKCJzaWduYWw6IEFkZCByZXN0b3Jl
X3VzZXJfc2lnbWFzaygpIikuDQo+IA0KPiBJIGRvbid0IHRoaW5rIHRoZXJlJ3MgYW55IGRpc2Fn
cmVlbWVudCB0aGF0IGIpIGlzIGEga2VybmVsIGJ1Zy4NCg0KSWYgdGhlIHNpZ25hbCBpcyByYWlz
ZWQgYWZ0ZXIgdGhlIHdhaXQgaGFzIHRpbWVkIG91dCBidXQgYmVmb3JlDQp0aGUgc2lnbmFsIG1h
c2sgaXMgcmVzdG9yZWQuDQoNCj4gU28gdGhlIGNvbmZ1c2lvbiBpcyBmb3IgYSksIGFuZCBQT1NJ
WCBpcyBub3QgY2xlYXIgdy5yLnQuIGhvdw0KPiBwc2VsZWN0L3BvbGwgd29ya3Mgd2hlbiB0aGVy
ZSdzIGJvdGggRkQgcmVhZGluZXNzIGFuZCBhbg0KPiBpbnRlcnJ1cHQuDQo+IA0KPiBUaHVzIEkn
bSBpbmNsaW5lZCB0byBiZWxpZXZlICpzZWxlY3QvKnBvbGwvZXBvbGxfKndhaXQgc2hvdWxkDQo+
IGZvbGxvdyBQT1NJWCByZWFkKCkgc2VtYW50aWNzOg0KPiANCj4gICAgICAgIElmIGEgcmVhZCgp
IGlzIGludGVycnVwdGVkIGJ5IGEgc2lnbmFsIGJlZm9yZSBpdCByZWFkcyBhbnkgZGF0YSwgaXQg
c2hhbGwNCj4gICAgICAgIHJldHVybiDiiJIxIHdpdGggZXJybm8gc2V0IHRvIFtFSU5UUl0uDQo+
IA0KPiAgICAgICAgSWYgIGEgIHJlYWQoKSAgaXMgIGludGVycnVwdGVkIGJ5IGEgc2lnbmFsIGFm
dGVyIGl0IGhhcyBzdWNjZXNzZnVsbHkgcmVhZA0KPiAgICAgICAgc29tZSBkYXRhLCBpdCBzaGFs
bCByZXR1cm4gdGhlIG51bWJlciBvZiBieXRlcyByZWFkLg0KDQpFeGNlcHQgdGhhdCBhYm92ZSB5
b3Ugd2FudCBkaWZmZXJlbnQgc2VtYW50aWNzIDotKQ0KRm9yIHJlYWQoKSBhbnkgc2lnbmFsIGhh
bmRsZXIgaXMgYWx3YXlzIGNhbGxlZC4NCkFuZCB0aGUgcmV0dXJuIHZhbHVlIG9mIGEgbm9uLWJs
b2NraW5nIHJlYWQgdGhhdCByZXR1cm5zIG5vIGRhdGENCmlzIG5vdCBhZmZlY3RlZCBieSBhbnkg
cGVuZGluZyBzaWduYWxzLg0KDQpGb3IgcHNlbGVjdCgpIHRoYXQgd291bGQgbWVhbiB0aGF0IGlm
IHRoZSB3YWl0IHRpbWVkIG91dCAocmVzdWx0IDApDQphbmQgdGhlbiBhIHNpZ25hbCB3YXMgcmFp
c2VkIChiZWZvcmUgdGhlIG1hc2sgZ290IGNoYW5nZWQgYmFjaykgdGhlbg0KdGhlIHJldHVybiB2
YWx1ZSB3b3VsZCBiZSB6ZXJvIGFuZCB0aGUgc2lnbmFsIGhhbmRsZXIgd291bGQgYmUgY2FsbGVk
Lg0KU28geW91ciAoYikgYWJvdmUgaXMgbm90IGEgYnVnLg0KRXZlbiBzZWxlY3QoKSBjYW4gcmV0
dXJuICd0aW1lb3V0JyBhbmQgaGF2ZSBhIHNpZ25hbCBoYW5kbGVyIGNhbGxlZC4NCg0KVGhlcmUg
YXJlIHJlYWxseSB0d28gc2VwYXJhdGUgaXNzdWVzOg0KMSkgU2lnbmFscyB0aGF0IGFyZSBwZW5k
aW5nIHdoZW4gdGhlIG5ldyBtYXNrIGlzIGFwcGxpZWQuDQoyKSBTaWduYWxzIHRoYXQgYXJlIHJh
aXNlZCBhZnRlciB0aGUgd2FpdCB0ZXJtaW5hdGVzIChzdWNjZXNzIG9yIHRpbWVvdXQpLg0KSWYg
dGhlIHNpZ25hbCBoYW5kbGVycyBmb3IgKDIpIGFyZSBub3QgY2FsbGVkIHRoZW4gdGhleSBiZWNv
bWUgKDEpDQpuZXh0IHRpbWUgYXJvdW5kIHRoZSBhcHBsaWNhdGlvbiBsb29wLg0KDQpNYXliZSB0
aGUgJ3Jlc3RvcmUgc2lnbWFzaycgZnVuY3Rpb24gc2hvdWxkIGJlIHBhc3NlZCBhbiBpbmRpY2F0
aW9uDQpvZiB3aGV0aGVyIGl0IGlzIGFsbG93ZWQgdG8gbGV0IHNpZ25hbCBoYW5kbGVyIGJlIGNh
bGxlZCBhbmQgcmV0dXJuDQp3aGV0aGVyIHRoZXkgd291bGQgYmUgY2FsbGVkIChpZSB3aGV0aGVy
IGl0IHJlc3RvcmVkIHRoZSBzaWduYWwgbWFzaw0Kb3IgbGVmdCBpdCBmb3IgdGhlIHN5c2NhbGwg
ZXhpdCBjb2RlIHRvIGRvIGFmdGVyIGNhbGxpbmcgdGhlIHNpZ25hbA0KaGFuZGxlcnMpLg0KDQpU
aGF0IHdvdWxkIGFsbG93IGVwb2xsKCkgdG8gY29udmVydCB0aW1lb3V0K3BlbmRpbmcgc2lnbmFs
IHRvIEVJTlRSLA0Kb3IgdG8gYWxsb3cgYWxsIGhhbmRsZXJzIGJlIGNhbGxlZCByZWdhcmRsZXNz
IG9mIHRoZSByZXR1cm4gdmFsdWUuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

