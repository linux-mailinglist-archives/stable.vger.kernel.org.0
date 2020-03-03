Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26949177539
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 12:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgCCLXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 06:23:36 -0500
Received: from mail-oln040092067031.outbound.protection.outlook.com ([40.92.67.31]:38373
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728374AbgCCLXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 06:23:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQejSuuiWG3F8zI58009atzNFO4LoNsslDwRM+t92e38a2rxfRp3SIW07181vTZyKcZ2TaoG9TmZOi4OBulKdPRlJ78KZlPmmL7Gfn6p8fc3eTOZusV2heNaxGPAjX6uQclnS6aX4Y4iYvxLqGiLL9bChi73yyor1Pg/fiKY1ZPPNC4p7p7JN/bbSD2st885cZchVQefOIYOaj85ScHPYqzvFmqed5z9cas1x4Du0FwM+zuUS/2gjC4mm1xVrHsgIWk3sJQYmwxpL9noHjALWi8FKA6+1EafsO6zDhnjgPZFd7nVHAnty722mJyrwunxp0EVZZBCWvCD0+hWbyuhCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bi9h3sQp5Fjur8g8LCJt1GQ2imEjfSTksNKIpeKdcPs=;
 b=Bk8G1SEltKaZYa+ycepVkuCD8+pyEzTLaW6YROpbF7HVzkv/V+uyvHflHu2zPgffoFlif4YZlWnbhBYEpyGPlDr4dpEmmFIUACTfn6fecOW5dHRdztF3JNb48l2II45vYSuO9ebOFAiDXnJgDWXOVGqQOCrY0TWlyuxEOIMM8IjaBsBWFLMxXLcfFKuHXQ5KalDO2yh5457a+fQ+08pnGjp2fA3dD2lLKCcHQyvdc1oDo0NMWI9LuGJ77fXOEp4cq9UgtsscrW4ZvrnKQxGtVrKQrELpTu9hI58GoHA50UEm1Lr7W4d+pmFcS4Vws0KeUassdI4HOJNMnKX39iKjZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR02FT037.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1d::35) by
 HE1EUR02HT165.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1d::239)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 11:23:31 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.10.54) by
 HE1EUR02FT037.mail.protection.outlook.com (10.152.10.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Tue, 3 Mar 2020 11:23:31 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 11:23:31 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR01CA0109.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Tue, 3 Mar 2020 11:23:30 +0000
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
Thread-Index: AQHV8OBzc5kV6gCKfE+vkD4wYYEirqg2JJ+AgABtUACAABrXAIAADcyA
Date:   Tue, 3 Mar 2020 11:23:31 +0000
Message-ID: <AM6PR03MB51706AE0FE7DA0F3F507F6BAE4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <AM6PR03MB5170E03613104B2ACE32F057E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
In-Reply-To: <AM6PR03MB5170E03613104B2ACE32F057E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0109.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::14) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:2472DEA6027607CB5A200246027E2FA3F4AA6FCE89AD573462F53366B269DA3A;UpperCasedChecksum:785365FC4FA3CE599406044206362DC58EF921E2C33B7FA8BCBAD834AA23D294;SizeAsReceived:9615;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [zw/mh3ppBNYMucu6VHXP8T2ZRIYX3eY6]
x-microsoft-original-message-id: <1856cb82-976f-3af3-05e8-4678592183cc@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 857cb9f1-f9cb-4c3f-1c12-08d7bf654d8f
x-ms-traffictypediagnostic: HE1EUR02HT165:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2EDaDqqQVkOIm28fh0lDkXAl3ksrgu+ezMZgm5InqvsfLa9byXwjaSUqyCuAQEg4hcqPzE/zXsGXvsf5IVl2ZBl+pUcTk1ydNYZ2/m8MtV6eL+s/boh8aKk1rvWQFmshOWe6oBt97/RcU3GpB8+L2eboFTgE3AFVkqqiL8NW4cIl1j5cxQnSilxEoAHUBxqT
x-ms-exchange-antispam-messagedata: VZENhCCNHMjf4K8P1+qAHGthdd10/VzzDJeU9c9sL4d0fyP9ASdhpkZN3LwVmZKrt01/xdNf7ou/tFZf+xsmCnXgDaqE/+IncE6Lofl+uoCM/LCecVbZpXa82nKmFiVPHmbrs+UDD2vaxtXddw4e3w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8BB21DE58DFF541A5F20C5C0C084BA5@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 857cb9f1-f9cb-4c3f-1c12-08d7bf654d8f
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 11:23:31.3229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT165
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMy8zLzIwIDExOjM0IEFNLCBCZXJuZCBFZGxpbmdlciB3cm90ZToNCj4gT24gMy8zLzIwIDk6
NTggQU0sIENocmlzdGlhbiBCcmF1bmVyIHdyb3RlOg0KPj4gU28gb25lIGlzc3VlIEkgc2VlIHdp
dGggaGF2aW5nIHRvIHJlYWNxdWlyZSB0aGUgY3JlZF9ndWFyZF9tdXRleCBtaWdodA0KPj4gYmUg
dGhhdCB0aGlzIHdvdWxkIGFsbG93IHRhc2tzIGhvbGRpbmcgdGhlIGNyZWRfZ3VhcmRfbXV0ZXgg
dG8gYmxvY2sgYQ0KPj4ga2lsbGVkIGV4ZWMnaW5nIHRhc2sgZnJvbSBleGl0aW5nLCByaWdodD8N
Cj4+DQo+IA0KPiBZZXMgbWF5YmUsIGJ1dCBJIHRoaW5rIGl0IHdpbGwgbm90IGJlIHdvcnNlIHRo
YW4gaXQgaXMgbm93Lg0KPiBTaW5jZSB0aGUgc2Vjb25kIHRpbWUgdGhlIG11dGV4IGlzIGFjcXVp
cmVkIGl0IGlzIGRvbmUgd2l0aA0KPiBtdXRleF9sb2NrX2tpbGxhYmxlLCBzbyBhdCBsZWFzdCBr
aWxsIC05IHNob3VsZCBnZXQgaXQgdGVybWluYXRlZC4NCj4gDQoNCg0KDQo+ICBzdGF0aWMgdm9p
ZCBmcmVlX2Jwcm0oc3RydWN0IGxpbnV4X2JpbnBybSAqYnBybSkNCj4gIHsNCj4gIAlmcmVlX2Fy
Z19wYWdlcyhicHJtKTsNCj4gIAlpZiAoYnBybS0+Y3JlZCkgew0KPiArCQlpZiAoIWJwcm0tPmNh
bGxlZF9mbHVzaF9vbGRfZXhlYykNCj4gKwkJCW11dGV4X2xvY2soJmN1cnJlbnQtPnNpZ25hbC0+
Y3JlZF9ndWFyZF9tdXRleCk7DQo+ICsJCWN1cnJlbnQtPnNpZ25hbC0+Y3JlZF9sb2NrZWRfZm9y
X3B0cmFjZSA9IGZhbHNlOw0KPiAgCQltdXRleF91bmxvY2soJmN1cnJlbnQtPnNpZ25hbC0+Y3Jl
ZF9ndWFyZF9tdXRleCk7DQoNCg0KSG1tLCBjb3VnaC4uLg0KYWN0dWFsbHkgd2hlbiB0aGUgbXV0
ZXhfbG9ja19raWxsYWJsZSBmYWlscywgZHVlIHRvIGtpbGwgLTksIGluIGZsdXNoX29sZF9leGVj
DQpmcmVlX2Jwcm0gbG9ja3MgdGhlIHNhbWUgbXV0ZXgsIHRoaXMgdGltZSB1bmtpbGxhYmxlLCBi
dXQgSSBzaG91bGQgYmV0dGVyIGRvDQptdXRleF9sb2NrX2tpbGxhYmxlIGhlcmUsIGFuZCBpZiB0
aGF0IGZhaWxzLCBJIGNhbiBsZWF2ZSBjcmVkX2xvY2tlZF9mb3JfcHRyYWNlLA0KaXQgc2hvdWxk
bid0IG1hdHRlciwgc2luY2UgdGhpcyBpcyBhIGZhdGFsIHNpZ25hbCBhbnl3YXksIHJpZ2h0Pw0K
DQpCZXJuZC4NCg==
