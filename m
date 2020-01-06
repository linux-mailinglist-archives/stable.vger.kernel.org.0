Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46CEC13166F
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgAFRDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 12:03:33 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:36359 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726448AbgAFRDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 12:03:33 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-132-nOSr783xMa-7DxD_ykfdFg-1; Mon, 06 Jan 2020 17:03:28 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 6 Jan 2020 17:03:26 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 6 Jan 2020 17:03:26 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnaldo Carvalho de Melo' <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        "Clark Williams" <williams@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Dmitry Levin <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        kbuild test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: RE: [PATCH 20/20] tools lib: Fix builds when glibc contains strlcpy()
Thread-Topic: [PATCH 20/20] tools lib: Fix builds when glibc contains
 strlcpy()
Thread-Index: AQHVxKuZWj/n7qG5rES0HVjQNYsqcqfd3KnQ
Date:   Mon, 6 Jan 2020 17:03:26 +0000
Message-ID: <bd755ddc840a485098f9e51d2692f39d@AcuMS.aculab.com>
References: <20200106160705.10899-1-acme@kernel.org>
 <20200106160705.10899-21-acme@kernel.org>
In-Reply-To: <20200106160705.10899-21-acme@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: nOSr783xMa-7DxD_ykfdFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQXJuYWxkbyBDYXJ2YWxobyBkZSBNZWxvDQo+IFNlbnQ6IDA2IEphbnVhcnkgMjAyMCAx
NjowNw0KPiANCj4gRnJvbTogVml0YWx5IENoaWt1bm92IDx2dEBhbHRsaW51eC5vcmc+DQo+IA0K
PiBEaXNhYmxlIGEgY291cGxlIG9mIGNvbXBpbGF0aW9uIHdhcm5pbmdzICh3aGljaCBhcmUgdHJl
YXRlZCBhcyBlcnJvcnMpDQo+IG9uIHN0cmxjcHkoKSBkZWZpbml0aW9uIGFuZCBkZWNsYXJhdGlv
biwgYWxsb3dpbmcgdXNlcnMgdG8gY29tcGlsZSBwZXJmDQo+IGFuZCBrZXJuZWwgKG9ianRvb2wp
IHdoZW46DQo+IA0KPiAxLiBnbGliYyBoYXZlIHN0cmxjcHkoKSAoc3VjaCBhcyBpbiBBTFQgTGlu
dXggc2luY2UgMjAwNCkgb2JqdG9vbCBhbmQNCj4gICAgcGVyZiBidWlsZCBmYWlscyB3aXRoIHRo
aXMgKGluIGdjYyk6DQo+IA0KPiAgIEluIGZpbGUgaW5jbHVkZWQgZnJvbSBleGVjLWNtZC5jOjM6
DQo+ICAgdG9vbHMvaW5jbHVkZS9saW51eC9zdHJpbmcuaDoyMDoxNTogZXJyb3I6IHJlZHVuZGFu
dCByZWRlY2xhcmF0aW9uIG9mIOKAmHN0cmxjcHnigJkgWy1XZXJyb3I9cmVkdW5kYW50LWRlY2xz
XQ0KPiAgICAgIDIwIHwgZXh0ZXJuIHNpemVfdCBzdHJsY3B5KGNoYXIgKmRlc3QsIGNvbnN0IGNo
YXIgKnNyYywgc2l6ZV90IHNpemUpOw0KPiANCj4gMi4gY2xhbmcgaWdub3JlcyBgLVdyZWR1bmRh
bnQtZGVjbHMnLCBidXQgcHJvZHVjZXMgYW5vdGhlciB3YXJuaW5nIHdoZW4NCj4gICAgYnVpbGRp
bmcgcGVyZjoNCj4gDQo+ICAgICBDQyAgICAgICB1dGlsL3N0cmluZy5vDQo+ICAgLi4vbGliL3N0
cmluZy5jOjk5Ojg6IGVycm9yOiBhdHRyaWJ1dGUgZGVjbGFyYXRpb24gbXVzdCBwcmVjZWRlIGRl
ZmluaXRpb24gWy1XZXJyb3IsLVdpZ25vcmVkLWF0dHJpYnV0ZXNdDQo+ICAgc2l6ZV90IF9fd2Vh
ayBzdHJsY3B5KGNoYXIgKmRlc3QsIGNvbnN0IGNoYXIgKnNyYywgc2l6ZV90IHNpemUpDQo+ICAg
Li4vLi4vdG9vbHMvaW5jbHVkZS9saW51eC9jb21waWxlci5oOjY2OjM0OiBub3RlOiBleHBhbmRl
ZCBmcm9tIG1hY3JvICdfX3dlYWsnDQo+ICAgIyBkZWZpbmUgX193ZWFrICAgICAgICAgICAgICAg
ICBfX2F0dHJpYnV0ZV9fKCh3ZWFrKSkNCj4gICAvdXNyL2luY2x1ZGUvYml0cy9zdHJpbmdfZm9y
dGlmaWVkLmg6MTUxOjg6IG5vdGU6IHByZXZpb3VzIGRlZmluaXRpb24gaXMgaGVyZQ0KPiAgIF9f
TlRIIChzdHJsY3B5IChjaGFyICpfX3Jlc3RyaWN0IF9fZGVzdCwgY29uc3QgY2hhciAqX19yZXN0
cmljdCBfX3NyYywNCg0KV2h5IG5vdCBqdXN0IGFsd2F5cyB1c2UgdGhlIGxvY2FsIHZlcnNpb24g
YnkgcmVuYW1pbmcgaXQ/DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

