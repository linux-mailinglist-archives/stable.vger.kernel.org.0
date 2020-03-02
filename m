Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1B8176097
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 18:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgCBRBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 12:01:23 -0500
Received: from mail-oln040092075038.outbound.protection.outlook.com ([40.92.75.38]:45446
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726775AbgCBRBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 12:01:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnOyX0eu+4/+2rCYB7jCginOyHp/D8av1fxRoTjngq2YbDJ6wQU+a/6Q7B5VVn4XdLCiuxn0t8HI6vz3N4IW1a1W46xlW4P6YbNf72wyZ//7QDVYbYgZbfK8bkhMMfFEMt0GKJpbzwE3lu1wEqAHd/RNVeg9t3sQhD/j0ij5203BOLsh+TLKYwOqHdFasLlJHwJ+fSqUB6KrY86QrYz2vxNAwllM23ucJUheDMem4y/P/nCc+1WPc/0L7n8CalD/Df1+SGUTthvnuMc3Aq/WN4JxMxAM+aly22G3afdGUNkHny8pRy8deku+x7CkxqDlpISSvTrSwxmrK/9o4HRsrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WA21ewjcrpsXWZt9Fw4ry56JMT73bI/ugt3nQCmPsDE=;
 b=EAbH/NKCNun1++YIdZLiDggfcyeCba8nEY7/a90a7bc+G/UnlfZnkA79t1+TFlw+PBeDrcPm/iqkd9Ui1j0cpOwfjA8+4xAZHyBNMbkKFpjElpT4jzPMrg1UWhFt4qMfpqnkWj2ePdvqP5LFhf7LZ6fCAhKIRs3/pXhHc5OWh97aSAQCOY+s7bF157NqVgb9/9Re/mNrQt8pfcteB+HCGYPZxdT3Va8etWrHb04wWF4gt+lPKlmpzRC6qMJkUTCpelq9PI+RYigGKbrdB9uGaNj3yd+oQmUjtUS2AwnIsDxfrP6XRKoSuUsdE3T5coN6Bbn+7vjafJWcMOb78LOszg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR04FT039.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0d::37) by
 HE1EUR04HT087.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0d::341)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 17:01:16 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.26.57) by
 HE1EUR04FT039.mail.protection.outlook.com (10.152.26.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 17:01:16 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 17:01:16 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR02CA0050.eurprd02.prod.outlook.com (2603:10a6:208:d2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Mon, 2 Mar 2020 17:01:14 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jamorris@linux.microsoft.com>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        Kees Cook <keescook@chromium.org>,
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCHv2] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv2] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8AjGwZG4WijWc0+aQpdADP+q6qg02ufjgACXoYCAAASqH4AAAMAAgAAEyVeAAAZ9gIAABRGA
Date:   Mon, 2 Mar 2020 17:01:15 +0000
Message-ID: <AM6PR03MB5170BD130F15CE1909F59B55E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com>
 <20200301185244.zkofjus6xtgkx4s3@wittgenstein>
 <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
 <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <CAG48ez0iXMD0mduKWHG6GZZoR+s2jXy776zwiRd+tFADCEiBEw@mail.gmail.com>
In-Reply-To: <CAG48ez0iXMD0mduKWHG6GZZoR+s2jXy776zwiRd+tFADCEiBEw@mail.gmail.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0050.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::27) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:B9900F4872545ACD7B4AC262212F03A1E8A251A8262895C2309629EF04574F00;UpperCasedChecksum:A2F46114EB3F5EECD1B1F9451433BDD545E1FC5BEE559AB4C61F4CEBEEAFC406;SizeAsReceived:9664;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [+bQ+L/1tslDbS4A/h6efaDr1Ao78Wc6h]
x-microsoft-original-message-id: <4984a737-4348-acf5-d7da-1b13c229779b@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: b99cce61-de58-4120-ce85-08d7becb517f
x-ms-traffictypediagnostic: HE1EUR04HT087:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PHAVQw6ieVLi+gUQJKsbLwvSjFUl+cGfz74jHKbNgNkRKsHzj7VqNaX3wyzCipwj9oFJROIHK4xYzpbjtSwJ86vrfEae2DQk6nqoQYQ/5u6GtRt/F7gj3JiAf3GTiKREjWJOWY14z6E+z/gCKKoj5CKWRpQ8rpKUFKmjn1puUOZba7R3acI3ESdVfKphjjgl
x-ms-exchange-antispam-messagedata: ZrML1GdK2182QozWaahfNS/ivDwgl/bYgAZ2XDFrUwjoGt3seGI0pibT9eExt4Ayvne3N3S64NncWC7BiBzEvdSvX4MtKqaikQLSYPH818Q1HdfPmlROATh4xMRMQQ+BiSKFvDMHbPSMELNBthEJpw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <12A9E26DF39C81429C8540E7796CCA8E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b99cce61-de58-4120-ce85-08d7becb517f
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 17:01:15.7559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR04HT087
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMy8yLzIwIDU6NDMgUE0sIEphbm4gSG9ybiB3cm90ZToNCj4gT24gTW9uLCBNYXIgMiwgMjAy
MCBhdCA1OjE5IFBNIEVyaWMgVy4gQmllZGVybWFuIDxlYmllZGVybUB4bWlzc2lvbi5jb20+IHdy
b3RlOg0KPj4NCj4+IEJlcm5kIEVkbGluZ2VyIDxiZXJuZC5lZGxpbmdlckBob3RtYWlsLmRlPiB3
cml0ZXM6DQo+Pg0KPj4+IE9uIDMvMi8yMCA0OjU3IFBNLCBFcmljIFcuIEJpZWRlcm1hbiB3cm90
ZToNCj4+Pj4gQmVybmQgRWRsaW5nZXIgPGJlcm5kLmVkbGluZ2VyQGhvdG1haWwuZGU+IHdyaXRl
czoNCj4+Pj4NCj4+Pj4+DQo+Pj4+PiBJIHRyaWVkIHRoaXMgd2l0aCBzL0VBQ0NFU1MvRUFDQ0VT
Ly4NCj4+Pj4+DQo+Pj4+PiBUaGUgdGVzdCBjYXNlIGluIHRoaXMgcGF0Y2ggaXMgbm90IGZpeGVk
LCBidXQgc3RyYWNlIGRvZXMgbm90IGZyZWV6ZSwNCj4+Pj4+IGF0IGxlYXN0IHdpdGggbXkgc2V0
dXAgd2hlcmUgaXQgZGlkIGZyZWV6ZSByZXBlYXRhYmxlLg0KPj4+Pg0KPj4+PiBUaGFua3MsIFRo
YXQgaXMgd2hhdCBJIHdhcyBhaW1pbmcgYXQuDQo+Pj4+DQo+Pj4+IFNvIHdlIGhhdmUgb25lIG1l
dGhvZCB3ZSBjYW4gcHVyc3VlIHRvIGZpeCB0aGlzIGluIHByYWN0aWNlLg0KPj4+Pg0KPj4+Pj4g
VGhhdCBpcw0KPj4+Pj4gb2J2aW91c2x5IGJlY2F1c2UgaXQgYnlwYXNzZXMgdGhlIGNyZWRfZ3Vh
cmRfbXV0ZXguICBCdXQgYWxsIG90aGVyDQo+Pj4+PiBwcm9jZXNzIHRoYXQgYWNjZXNzIHRoaXMg
ZmlsZSBzdGlsbCBmcmVlemUsIGFuZCBjYW5ub3QgYmUNCj4+Pj4+IGludGVycnVwdGVkIGV4Y2Vw
dCB3aXRoIGtpbGwgLTkuDQo+Pj4+Pg0KPj4+Pj4gSG93ZXZlciB0aGF0IHNtZWxscyBsaWtlIGEg
ZGVuaWFsIG9mIHNlcnZpY2UsIHRoYXQgdGhpcw0KPj4+Pj4gc2ltcGxlIHRlc3QgY2FzZSB3aGlj
aCBjYW4gYmUgZXhlY3V0ZWQgYnkgZ3Vlc3QsIGNyZWF0ZXMgYSAvcHJvYy8kcGlkL21lbQ0KPj4+
Pj4gdGhhdCBmcmVlemVzIGFueSBwcm9jZXNzLCBldmVuIHJvb3QsIHdoZW4gaXQgbG9va3MgYXQg
aXQuDQo+Pj4+PiBJIG1lYW46ICJsbiAtcyBSRUFETUUgL3Byb2MvJHBpZC9tZW0iIHdvdWxkIGJl
IGEgbmljZSBib21iLg0KPj4+Pg0KPj4+PiBZZXMuICBZb3VyIHRoZSB0ZXN0IGNhc2UgaW4geW91
ciBwYXRjaCBhIHZhcmlhbnQgb2YgdGhlIG9yaWdpbmFsDQo+Pj4+IHByb2JsZW0uDQo+Pj4+DQo+
Pj4+DQo+Pj4+IEkgaGF2ZSBiZWVuIHN0YXJpbmcgYXQgdGhpcyB0cnlpbmcgdG8gdW5kZXJzdGFu
ZCB0aGUgZnVuZGFtZW50YWxzIG9mIHRoZQ0KPj4+PiBvcmlnaW5hbCBkZWVwZXIgcHJvYmxlbS4N
Cj4+Pj4NCj4+Pj4gVGhlIGN1cnJlbnQgc2NvcGUgb2YgY3JlZF9ndWFyZF9tdXRleCBpbiBleGVj
IGlzIGJlY2F1c2UgYmVpbmcgcHRyYWNlZA0KPj4+PiBjYXVzZXMgc3VpZCBleGVjIHRvIGFjdCBk
aWZmZXJlbnRseS4gIFNvIHdlIG5lZWQgdG8ga25vdyBlYXJseSBpZiB3ZSBhcmUNCj4+Pj4gcHRy
YWNlZC4NCj4+Pj4NCj4+Pg0KPj4+IEl0IGhhcyBhIHNlY29uZCB1c2UsIHRoYXQgaXQgcHJldmVu
dHMgdHdvIHRocmVhZHMgZW50ZXJpbmcgZXhlY3ZlLA0KPj4+IHdoaWNoIHdvdWxkIHByb2JhYmx5
IHJlc3VsdCBpbiBkaXNhc3Rlci4NCj4+DQo+PiBFeGVjIGNhbiBmYWlsIHdpdGggYW4gZXJyb3Ig
Y29kZSB1cCB1bnRpbCBkZV90aHJlYWQuICBkZV90aHJlYWQgY2F1c2VzDQo+PiBleGVjIHRvIGZh
aWwgd2l0aCB0aGUgZXJyb3IgY29kZSAtRUFHQUlOIGZvciB0aGUgc2Vjb25kIHRocmVhZCB0byBn
ZXQNCj4+IGludG8gZGVfdGhyZWFkLg0KPj4NCj4+IFNvIG5vLiAgVGhlIGNyZWRfZ3VhcmRfbXV0
ZXggaXMgbm90IG5lZWRlZCBmb3IgdGhhdCBjYXNlIGF0IGFsbC4NCj4+DQo+Pj4+IElmIHRoYXQg
Y2FzZSBkaWQgbm90IGV4aXN0IHdlIGNvdWxkIHJlZHVjZSB0aGUgc2NvcGUgb2YgdGhlDQo+Pj4+
IGNyZWRfZ3VhcmRfbXV0ZXggaW4gZXhlYyB0byB3aGVyZSB5b3VyIHBhdGNoIHB1dHMgdGhlIGNy
ZWRfY2hhbmdlX211dGV4Lg0KPj4+Pg0KPj4+PiBJIGFtIHN0YXJ0aW5nIHRvIHRoaW5rIHJld29y
a2luZyBob3cgd2UgZGVhbCB3aXRoIHB0cmFjZSBhbmQgZXhlYyBpcyB0aGUNCj4+Pj4gd2F5IHRv
IHNvbHZlIHRoaXMgcHJvYmxlbS4NCj4+DQo+Pg0KPj4gSSBhbSA5OSUgY29udmluY2VkIHRoYXQg
dGhlIGZpeCBpcyB0byBtb3ZlIGNyZWRfZ3VhcmRfbXV0ZXggZG93bi4NCj4gDQo+ICJtb3ZlIGNy
ZWRfZ3VhcmRfbXV0ZXggZG93biIgYXMgaW4gInRha2UgaXQgb25jZSB3ZSd2ZSBhbHJlYWR5IHNl
dCB1cA0KPiB0aGUgbmV3IHByb2Nlc3MsIHBhc3QgdGhlIHBvaW50IG9mIG5vIHJldHVybiI/DQo+
IA0KPj4gVGhlbiByaWdodCBhZnRlciB3ZSB0YWtlIGNyZWRfZ3VhcmRfbXV0ZXggZG86DQo+PiAg
ICAgICAgIGlmIChwdHJhY2VkKSB7DQo+PiAgICAgICAgICAgICAgICAgdXNlX29yaWdpbmFsX2Ny
ZWRzKCk7DQo+PiAgICAgICAgIH0NCj4+DQo+PiBBbmQgY2FsbCBpdCBhIGRheS4NCj4+DQo+PiBU
aGUgZGV0YWlscyBzdWNrIGJ1dCBJIGFtIDk5JSBjZXJ0YWluIHRoYXQgd291bGQgc29sdmUgZXZl
cnlvbmVzDQo+PiBwcm9ibGVtcywgYW5kIG5vdCBiZSB0b28gYmFkIHRvIGF1ZGl0IGVpdGhlci4N
Cj4gDQo+IEFoLCBobW0sIHRoYXQgc291bmRzIGxpa2UgaXQnbGwgd29yayBmaW5lIGF0IGxlYXN0
IHdoZW4gbm8gTFNNcyBhcmUgaW52b2x2ZWQuDQo+IA0KPiBTRUxpbnV4IG5vcm1hbGx5IGRvZXNu
J3QgZG8gdGhlIGV4ZWN1dGlvbi1kZWdyYWRpbmcgdGhpbmcsIGl0IGp1c3QNCj4gYmxvY2tzIHRo
ZSBleGVjdXRpb24gY29tcGxldGVseSAtIHNlZSB0aGVpciBzZWxpbnV4X2Jwcm1fc2V0X2NyZWRz
KCkNCj4gaG9vay4gU28gSSB0aGluayB0aGV5J2Qgc3RpbGwgbmVlZCB0byBzZXQgc29tZSBzdGF0
ZSBvbiB0aGUgdGFzayB0aGF0DQo+IHNheXMgIndlJ3JlIGN1cnJlbnRseSBpbiB0aGUgbWlkZGxl
IG9mIGFuIGV4ZWN1dGlvbiB3aGVyZSB0aGUgdGFyZ2V0DQo+IHRhc2sgd2lsbCBydW4gaW4gY29u
dGV4dCBYIiwgYW5kIHRoZW4gY2hlY2sgYWdhaW5zdCB0aGF0IGluIHRoZQ0KPiBwdHJhY2VfbWF5
X2FjY2VzcyBob29rLiBPciBJIHN1cHBvc2UgdGhleSBjb3VsZCBqdXN0IGtpbGwgdGhlIHRhc2sN
Cj4gbmVhciB0aGUgZW5kIG9mIGV4ZWN2ZSwgYWx0aG91Z2ggdGhhdCdkIGJlIGtpbmRhIHVnbHku
DQo+IA0KDQpXZSBoYXZlIGN1cnJlbnQtPmluX2V4ZWN2ZSBmb3IgdGhhdCwgcmlnaHQ/DQpJIHRo
aW5rIHdoZW4gdGhlIGNyZWRfZ3VhcmRfbXV0ZXggaXMgdGFrZW4gb25seSBpbiB0aGUgY3JpdGlj
YWwgc2VjdGlvbiwNCnRoZW4gUFRSQUNFX0FUVEFDSCBjb3VsZCB0YWtlIHRoZSBndWFyZF9tdXRl
eCwgYW5kIGxvb2sgYXQgY3VycmVudC0+aW5fZXhlY3ZlLA0KYW5kIGp1c3QgcmV0dXJuIC1FQUdB
SU4gaW4gdGhhdCBjYXNlLCByaWdodCwgZXZlcnlib2R5IGhhcHB5IDopDQoNCg0KQmVybmQuDQo=
