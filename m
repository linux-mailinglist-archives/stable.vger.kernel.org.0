Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761A117744F
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 11:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgCCKeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 05:34:14 -0500
Received: from mail-oln040092064072.outbound.protection.outlook.com ([40.92.64.72]:4999
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728531AbgCCKeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 05:34:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjqRLqVuDSULZVkSLZl70Cx0RQUvc3WTKPM0XVipYPEa6wN+rHcIGmeI3gEW2tOF+TBpgX3/vOvmhao4O//3JYP5FM6bfEYEgdk9SlE1/ntmQoYcpcCEngR2XP0ovA7B1Q+U+2f1YP/FOKjiLa1KR3BwQU8y+VKD6/HtkvAbXToeL6BMAfB2/OrZf3dTqkEpzKtooG+5Zk7rncms1vTaIcmgrl/tU0ht+Nl14iBxPBTP84EFwC75MNOKMXaQKtuR29LwoP1p/ZqCZStMzG66l21TCphdsWtIb/TGWKdJwXyIUfTb03nqlFvHVnH0g7BZT2/sZI30sTv8Cv6h4Np+Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLUI7IA4+/HzcnVxBzKItlXlnRelV2i7GnUjhGdmV+U=;
 b=AgJeBupUOtdOOiK/zGV+ZnFB1J7uwfbcd2eXASzWt2fvVBGvA0rUwbxkSh/gDsrl55nB+SWn1eQmb6pz99XlS2bXMyGqTM9TQpoOSdjLGrOib0QWyDZpnALllSANaGehZxK76njWYIcLCMy7DOH6Z/LiHW2vTgKIyJd/M4WmM3BVxeYKnDnkdeq8vagjVzlbT68Hj6ZaJtl0QCokRCXurYsNkQT30ZxWg978e/wPxmE8G9vM9JFcCNmzp5gMpg4K0pRR2kvikrjP4aK7+KVy82DF+cGgdM2vqB3+m3MyNwPx3R4cy7RboYTUNKpnGLtis/tsBfxZBF2+eg0VU7NC+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VE1EUR01FT064.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e19::33) by
 VE1EUR01HT232.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e19::483)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 10:34:08 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.2.59) by
 VE1EUR01FT064.mail.protection.outlook.com (10.152.3.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Tue, 3 Mar 2020 10:34:08 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 10:34:08 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0013.eurprd06.prod.outlook.com (2603:10a6:208:ab::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Tue, 3 Mar 2020 10:34:07 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>
CC:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCHv4] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv4] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8OBzc5kV6gCKfE+vkD4wYYEirqg2JJ+AgABtUACAABrXAA==
Date:   Tue, 3 Mar 2020 10:34:08 +0000
Message-ID: <AM6PR03MB5170E03613104B2ACE32F057E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
In-Reply-To: <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0013.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::26) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:78FB42FFA0A121F3B72BA473907DF57692312FF44CA4705F6780CF5ACA2D089A;UpperCasedChecksum:4485AFDF3DDB25D981BD1C7554F23E5321DD9E3C7A3B4496D25B11BA16D4543C;SizeAsReceived:9464;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [9QAZBGFOGVvl9dR/wniuYLeX8EeOYcug]
x-microsoft-original-message-id: <2b9fc6d8-644b-7b06-6660-551de3eb06d8@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 0800b837-431b-4c19-47d9-08d7bf5e6781
x-ms-traffictypediagnostic: VE1EUR01HT232:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qtHvuFy28zERxnVuszXg24nscUzBtPcX/0+5Mn8u3uZC7Ucd1HwDhNccEQqJJL1WrOOZL014ABbPcNOfryOXG0UTfq1gTAKec0q5iGJwWcG03b6oDdMjR209st8UYiAZoQWnCPVoDAXiJoaoGyXqeN1eWF4hVBKUa/ZDJ2PHZVH+c4Wi28aNc5WMPQB+TTsb
x-ms-exchange-antispam-messagedata: Z8ugYNO++D84u1K4044PC+ggZz8w7a28020wzZmjkLPw1KyPCPaVbfz9+jXq46TwjD+zYvuKDUjEo2DzYakjwe68QsejPgr4co0BCLlJaC0FgLYCH9KA5wDrLDsDFoGEh/HDcj/rzJxTEkKoi//56w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F63B6B75F4BA7344B9230BDF32DE1624@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0800b837-431b-4c19-47d9-08d7bf5e6781
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 10:34:08.3829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR01HT232
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMy8zLzIwIDk6NTggQU0sIENocmlzdGlhbiBCcmF1bmVyIHdyb3RlOg0KPiBPbiBNb24sIE1h
ciAwMiwgMjAyMCBhdCAwNjoyNjo0N1BNIC0wODAwLCBLZWVzIENvb2sgd3JvdGU6DQo+PiBPbiBN
b24sIE1hciAwMiwgMjAyMCBhdCAxMDoxODowN1BNICswMDAwLCBCZXJuZCBFZGxpbmdlciB3cm90
ZToNCj4+PiBUaGlzIGZpeGVzIGEgZGVhZGxvY2sgaW4gdGhlIHRyYWNlciB3aGVuIHRyYWNpbmcg
YSBtdWx0aS10aHJlYWRlZA0KPj4+IGFwcGxpY2F0aW9uIHRoYXQgY2FsbHMgZXhlY3ZlIHdoaWxl
IG1vcmUgdGhhbiBvbmUgdGhyZWFkIGFyZSBydW5uaW5nLg0KPj4+DQo+Pj4gSSBvYnNlcnZlZCB0
aGF0IHdoZW4gcnVubmluZyBzdHJhY2Ugb24gdGhlIGdjYyB0ZXN0IHN1aXRlLCBpdCBhbHdheXMN
Cj4+PiBibG9ja3MgYWZ0ZXIgYSB3aGlsZSwgd2hlbiBleHBlY3QgY2FsbHMgZXhlY3ZlLCBiZWNh
dXNlIG90aGVyIHRocmVhZHMNCj4+PiBoYXZlIHRvIGJlIHRlcm1pbmF0ZWQuICBUaGV5IHNlbmQg
cHRyYWNlIGV2ZW50cywgYnV0IHRoZSBzdHJhY2UgaXMgbm8NCj4+PiBsb25nZXIgYWJsZSB0byBy
ZXNwb25kLCBzaW5jZSBpdCBpcyBibG9ja2VkIGluIHZtX2FjY2Vzcy4NCj4+Pg0KPj4+IFRoZSBk
ZWFkbG9jayBpcyBhbHdheXMgaGFwcGVuaW5nIHdoZW4gc3RyYWNlIG5lZWRzIHRvIGFjY2VzcyB0
aGUNCj4+PiB0cmFjZWVzIHByb2Nlc3MgbW1hcCwgd2hpbGUgYW5vdGhlciB0aHJlYWQgaW4gdGhl
IHRyYWNlZSBzdGFydHMgdG8NCj4+PiBleGVjdmUgYSBjaGlsZCBwcm9jZXNzLCBidXQgdGhhdCBj
YW5ub3QgY29udGludWUgdW50aWwgdGhlDQo+Pj4gUFRSQUNFX0VWRU5UX0VYSVQgaXMgaGFuZGxl
ZCBhbmQgdGhlIFdJRkVYSVRFRCBldmVudCBpcyByZWNlaXZlZDoNCj4+Pg0KPj4+IHN0cmFjZSAg
ICAgICAgICBEICAgIDAgMzA2MTQgIDMwNTg0IDB4MDAwMDAwMDANCj4+PiBDYWxsIFRyYWNlOg0K
Pj4+IF9fc2NoZWR1bGUrMHgzY2UvMHg2ZTANCj4+PiBzY2hlZHVsZSsweDVjLzB4ZDANCj4+PiBz
Y2hlZHVsZV9wcmVlbXB0X2Rpc2FibGVkKzB4MTUvMHgyMA0KPj4+IF9fbXV0ZXhfbG9jay5pc3Jh
LjEzKzB4MWVjLzB4NTIwDQo+Pj4gX19tdXRleF9sb2NrX2tpbGxhYmxlX3Nsb3dwYXRoKzB4MTMv
MHgyMA0KPj4+IG11dGV4X2xvY2tfa2lsbGFibGUrMHgyOC8weDMwDQo+Pj4gbW1fYWNjZXNzKzB4
MjcvMHhhMA0KPj4+IHByb2Nlc3Nfdm1fcndfY29yZS5pc3JhLjMrMHhmZi8weDU1MA0KPj4+IHBy
b2Nlc3Nfdm1fcncrMHhkZC8weGYwDQo+Pj4gX194NjRfc3lzX3Byb2Nlc3Nfdm1fcmVhZHYrMHgz
MS8weDQwDQo+Pj4gZG9fc3lzY2FsbF82NCsweDY0LzB4MjIwDQo+Pj4gZW50cnlfU1lTQ0FMTF82
NF9hZnRlcl9od2ZyYW1lKzB4NDQvMHhhOQ0KPj4+DQo+Pj4gZXhwZWN0ICAgICAgICAgIEQgICAg
MCAzMTkzMyAgMzA4NzYgMHg4MDAwNDAwMw0KPj4+IENhbGwgVHJhY2U6DQo+Pj4gX19zY2hlZHVs
ZSsweDNjZS8weDZlMA0KPj4+IHNjaGVkdWxlKzB4NWMvMHhkMA0KPj4+IGZsdXNoX29sZF9leGVj
KzB4YzQvMHg3NzANCj4+PiBsb2FkX2VsZl9iaW5hcnkrMHgzNWEvMHgxNmMwDQo+Pj4gc2VhcmNo
X2JpbmFyeV9oYW5kbGVyKzB4OTcvMHgxZDANCj4+PiBfX2RvX2V4ZWN2ZV9maWxlLmlzcmEuNDAr
MHg1ZDQvMHg4YTANCj4+PiBfX3g2NF9zeXNfZXhlY3ZlKzB4NDkvMHg2MA0KPj4+IGRvX3N5c2Nh
bGxfNjQrMHg2NC8weDIyMA0KPj4+IGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0
LzB4YTkNCj4+Pg0KPj4+IFRoZSBwcm9wb3NlZCBzb2x1dGlvbiBpcyB0byB0YWtlIHRoZSBjcmVk
X2d1YXJkX211dGV4IG9ubHkNCj4+PiBpbiBhIGNyaXRpY2FsIHNlY3Rpb24gYXQgdGhlIGJlZ2lu
bmluZywgYW5kIGF0IHRoZSBlbmQgb2YgdGhlDQo+Pj4gZXhlY3ZlIGZ1bmN0aW9uLCBhbmQgbGV0
IFBUUkFDRV9BVFRBQ0ggZmFpbCB3aXRoIEVBR0FJTiB3aGlsZQ0KPj4+IGV4ZWN2ZSBpcyBub3Qg
Y29tcGxldGUsIGJ1dCBvdGhlciBmdW5jdGlvbnMgbGlrZSB2bV9hY2Nlc3MgYXJlDQo+Pj4gYWxs
b3dlZCB0byBjb21wbGV0ZSBub3JtYWxseS4NCj4+DQo+PiBTb3JyeSB0byBiZSBidW1tZXIsIGJ1
dCBJIGRvbid0IHRoaW5rIHRoaXMgd2lsbCB3b3JrLiBBIGZldyBtb3JlIHRoaW5ncw0KPj4gZHVy
aW5nIHRoZSBleGVjIHByb2Nlc3MgZGVwZW5kIG9uIGNyZWRfZ3VhcmRfbXV0ZXggYmVpbmcgaGVs
ZC4NCj4+DQo+PiBJZiBJJ20gcmVhZGluZyB0aGlzIHBhdGNoIGNvcnJlY3RseSwgdGhpcyBjaGFu
Z2VzIHRoZSBsaWZldGltZSBvZiB0aGUNCj4+IGNyZWRfZ3VhcmRfbXV0ZXggbG9jayB0byBiZToN
Cj4+IAktIGR1cmluZyBwcmVwYXJlX2Jwcm1fY3JlZHMoKQ0KPj4gCS0gZnJvbSBmbHVzaF9vbGRf
ZXhlYygpIHRocm91Z2ggaW5zdGFsbF9leGVjX2NyZWRzKCkNCj4+IEJlZm9yZSwgY3JlZF9ndWFy
ZF9tdXRleCB3YXMgaGVsZCBmcm9tIHByZXBhcmVfYnBybV9jcmVkcygpIHRocm91Z2gNCj4+IGlu
c3RhbGxfZXhlY19jcmVkcygpLg0KPj4NCj4+IFRoYXQgbWVhbnMsIGZvciBleGFtcGxlLCB0aGF0
IGNoZWNrX3Vuc2FmZV9leGVjKCkncyBkb2N1bWVudGVkIGludmFyaWFudA0KPj4gaXMgdmlvbGF0
ZWQ6DQo+PiAgICAgLyoNCj4+ICAgICAgKiBkZXRlcm1pbmUgaG93IHNhZmUgaXQgaXMgdG8gZXhl
Y3V0ZSB0aGUgcHJvcG9zZWQgcHJvZ3JhbQ0KPj4gICAgICAqIC0gdGhlIGNhbGxlciBtdXN0IGhv
bGQgLT5jcmVkX2d1YXJkX211dGV4IHRvIHByb3RlY3QgYWdhaW5zdA0KPj4gICAgICAqICAgUFRS
QUNFX0FUVEFDSCBvciBzZWNjb21wIHRocmVhZC1zeW5jDQo+PiAgICAgICovDQo+PiAgICAgc3Rh
dGljIHZvaWQgY2hlY2tfdW5zYWZlX2V4ZWMoc3RydWN0IGxpbnV4X2JpbnBybSAqYnBybSkgLi4u
DQo+PiB3aGljaCBpcyBsb29raW5nIGF0IG5vX25ld19wcml2cyBhcyB3ZWxsIGFzIG90aGVyIGRl
dGFpbHMsIGFuZCBtYWtpbmcNCj4+IGRlY2lzaW9ucyBhYm91dCB0aGUgYnBybSBzdGF0ZSBmcm9t
IHRoZSBjdXJyZW50IHN0YXRlLg0KPj4NCj4+IEkgdGhpbmsgaXQgYWxzbyBtZWFucyB0aGF0IHRo
ZSBwb3RlbnRpYWxseSBtdWx0aXBsZSBpbnZvY2F0aW9ucw0KPj4gb2YgYnBybV9maWxsX3VpZCgp
ICh2aWEgcHJlcGFyZV9iaW5wcm0oKSB2aWEgYmluZm10X3NjcmlwdC5jIGFuZA0KPj4gYmluZm10
X21pc2MuYykgd291bGQgYmUgY2hhbmdpbmcgYnBybS0+Y3JlZCBkZXRhaWxzICh1aWQsIGdpZCkg
d2l0aG91dA0KPj4gYSBsb2NrIChhbm90aGVyIHBsYWNlIHdoZXJlIGN1cnJlbnQncyBub19uZXdf
cHJpdnMgaXMgZXZhbHVhdGVkKS4NCj4+DQo+PiBSZWxhdGVkLCBpdCBhbHNvIG1lYW5zIHRoYXQg
Y3JlZF9ndWFyZF9tdXRleCBpcyB1bmhlbGQgZm9yIGV2ZXJ5DQo+PiBpbnZvY2F0aW9uIG9mIHNl
YXJjaF9iaW5hcnlfaGFuZGxlcigpICh3aGljaCBjYW4gbG9vcCB2aWEgdGhlIHByZXZpb3VzbHkN
Cj4+IG1lbnRpb25lZCBiaW5mbXRfc2NyaXB0LmMgYW5kIGJpbmZtdF9taXNjLmMpLCBpZiBhbnkg
b2YgdGhlbSBoYXZlIGhpZGRlbg0KPj4gZGVwZW5kZW5jaWVzIG9uIGNyZWRfZ3VhcmRfbXV0ZXgu
IChUaG91Z2h0IEkgb25seSBzZWUgYnBybV9maWxsX3VpZCgpDQo+PiBjdXJyZW50bHkuKQ0KPiAN
Cj4gU28gb25lIGlzc3VlIEkgc2VlIHdpdGggaGF2aW5nIHRvIHJlYWNxdWlyZSB0aGUgY3JlZF9n
dWFyZF9tdXRleCBtaWdodA0KPiBiZSB0aGF0IHRoaXMgd291bGQgYWxsb3cgdGFza3MgaG9sZGlu
ZyB0aGUgY3JlZF9ndWFyZF9tdXRleCB0byBibG9jayBhDQo+IGtpbGxlZCBleGVjJ2luZyB0YXNr
IGZyb20gZXhpdGluZywgcmlnaHQ/DQo+IA0KDQpZZXMgbWF5YmUsIGJ1dCBJIHRoaW5rIGl0IHdp
bGwgbm90IGJlIHdvcnNlIHRoYW4gaXQgaXMgbm93Lg0KU2luY2UgdGhlIHNlY29uZCB0aW1lIHRo
ZSBtdXRleCBpcyBhY3F1aXJlZCBpdCBpcyBkb25lIHdpdGgNCm11dGV4X2xvY2tfa2lsbGFibGUs
IHNvIGF0IGxlYXN0IGtpbGwgLTkgc2hvdWxkIGdldCBpdCB0ZXJtaW5hdGVkLg0KDQoNCkJlcm5k
Lg0K
