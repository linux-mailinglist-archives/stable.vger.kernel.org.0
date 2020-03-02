Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0671764F2
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 21:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgCBU3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 15:29:02 -0500
Received: from mail-oln040092064044.outbound.protection.outlook.com ([40.92.64.44]:44199
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbgCBU3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 15:29:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTNljQOlo/VItxs1j0Fi5N+zMmwEKrqF/1+8tFozmgzXtESspeEJpb5VmBpIcZfahl5fah5AsvmqWXqLH7zLFuSEGuTQacFAM3r3xW06rKdQi+2l4IG8jEGKHcJxoVJ2pTCwVHsyCPqKHqOLSPU6gSG0MgGE4slDpOuhQzKZeHq1RJZeDyXL2nI8H43HRmWPVxD4nklr7H+xrmNy8ye4UHV4X/GmJsH+NwGV1yyZp8yiX/8JTD7x2Ka00HVwdQLIFLmTU8N+Ap2/eUfkVwnhauiBNyMwGO8sdMvXlgAIjS7ilBQ71fSQEReTtLfy1WrZokLUoNQBrLGqK2jiYVkFZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WItZN0YFIgwuGDkDEsDC/sqmYi0bb5gVZBC8nxRJ/E=;
 b=Q9hvojDEjJ1G9f9SF1D5LgoYkcXymvG3skAbRhSbRQLgG1JG418+RTblZpn4Hc6MpdbAIaru5L0g/nknkpDNhEPEbE4yXu3M8AmabzDrzaUpmv18de10p380TRRpuabCTW+20xmtemAknc6Ug47hy8ZSjSROwGi2RrKbGGAufIkLKAT9cAI9vtZUATBmgk4eFE9i0DDivNVw9ziQ6Ez2L818yyBIkAfWdxoYus4tdvpWb4AJ1DHvz5sQj7W+tTJPcc/P06a/L/dHG5nYyEysRUVXByJT2OZIN2kRcL5PLcCmneafQSwlAgQF0PEIfOf0CIBwi/qA/szYW+wfBo1LDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR01FT058.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::35) by
 HE1EUR01HT174.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::124)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 20:28:56 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.58) by
 HE1EUR01FT058.mail.protection.outlook.com (10.152.0.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 20:28:56 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 20:28:56 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR0102CA0023.eurprd01.prod.exchangelabs.com (2603:10a6:208:14::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 20:28:54 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian@brauner.io>
CC:     "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jamorris@linux.microsoft.com>,
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
Subject: Re: [PATCHv3] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv3] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8M6l6N/OOmCoxkO4zYjKB9YU8Kg1wMQA
Date:   Mon, 2 Mar 2020 20:28:56 +0000
Message-ID: <AM6PR03MB51709CFCC54A25681C87DABAE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <20200301185244.zkofjus6xtgkx4s3@wittgenstein>
 <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
 <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <CAG48ez0iXMD0mduKWHG6GZZoR+s2jXy776zwiRd+tFADCEiBEw@mail.gmail.com>
 <AM6PR03MB5170BD130F15CE1909F59B55E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <CAG48ez1jj_J3PtENWvu8piFGsik6RvuyD38ie48TYr2k1Rbf3A@mail.gmail.com>
 <5e5d45a3.1c69fb81.f99ac.0806@mx.google.com>
 <CAG48ez0zfutdReRCP38+F2O=LMU11FUQAG59YkaKZY8AJNxSGQ@mail.gmail.com>
 <AM6PR03MB517034D7787B305832FEA885E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
In-Reply-To: <AM6PR03MB517034D7787B305832FEA885E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0023.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::36) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:787DD6075D33EEEDAEE3E26861DF4223AC06363B82E577E006F6A557BB55324F;UpperCasedChecksum:2B76CB72DBD1AAE991D4CB4B16B2532DEF00E963AA4A4A30B3351A60950B7833;SizeAsReceived:9897;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [8hP23OIvzx9SHL5EUzvkrbLR1Am349/n]
x-microsoft-original-message-id: <2413bf2b-6663-892d-4898-3ff2cc543d30@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: b9ae2766-c41a-4bd8-5934-08d7bee854a8
x-ms-traffictypediagnostic: HE1EUR01HT174:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SKuFG1FQpeLCmrj5VXY87qA6kKnLO/nBsr9IKsmshVGR34OdWvSQyhaIPBlFhLTEL6e+xF34B2obzfLm48T7UAyCV4nmj+KmkY/jYgUdt6JHmLL5Z3sQptdTmVRAjB3BF4mGBnXdIVONfpf7T+H37Ln8tC8Zf1wPU2WZUDcTCaR8FhAwADkIkRfBpwkdzpvP
x-ms-exchange-antispam-messagedata: +jwvXQKamDUFGuKNA03o7tEV+/tc4QqAg7aKpBanW2ksZ6pDii2n+opRdV2pDmq9eHWso+4egPZ902wAp4S0BblV+N5V0Czy2DQZH1mbO9NuPb2RN1F1atay1BJl7akmtY4QnLWEp5Mp4zqrhz71Pw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <273077F5A4E6CE4C8F92F03DD763FF0F@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ae2766-c41a-4bd8-5934-08d7bee854a8
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 20:28:56.1301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT174
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMy8yLzIwIDk6MTAgUE0sIEJlcm5kIEVkbGluZ2VyIHdyb3RlOg0KPiAtLS0gYS9pbmNsdWRl
L2xpbnV4L2JpbmZtdHMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2JpbmZtdHMuaA0KPiBAQCAt
NDQsNyArNDQsMTEgQEAgc3RydWN0IGxpbnV4X2JpbnBybSB7DQo+ICAJCSAqIGV4ZWMgaGFzIGhh
cHBlbmVkLiBVc2VkIHRvIHNhbml0aXplIGV4ZWN1dGlvbiBlbnZpcm9ubWVudA0KPiAgCQkgKiBh
bmQgdG8gc2V0IEFUX1NFQ1VSRSBhdXh2IGZvciBnbGliYy4NCj4gIAkJICovDQo+IC0JCXNlY3Vy
ZWV4ZWM6MTsNCj4gKwkJc2VjdXJlZXhlYzoxLA0KPiArCQkvKg0KPiArCQkgKiBTZXQgYnkgZmx1
c2hfb2xkX2V4ZWMsIHdoZW4gdGhlIGNyZWRfY2hhbmdlX211dGV4IGlzIHRha2VuLg0KDQpPb3Bz
LCBtaXNzZWQgdG8gdXBkYXRlIHRoaXMgY29tbWVudCwgc2hvdWxkIGJlICJ3aGVuIHRoZSBjcmVk
X2d1YXJkX211dGV4IGlzIHRha2VuIi4NCg0KSSdsbCBzZW5kIGEgbmV3IHBhdGNoIGxhdGVyLg0K
DQpCZXJuZC4NCg0KPiArCQkgKi8NCj4gKwkJY2FsbGVkX2ZsdXNoX29sZF9leGVjOjE7DQo+ICAj
aWZkZWYgX19hbHBoYV9fDQo+ICAJdW5zaWduZWQgaW50IHRhc286MTsNCj4gICNlbmRpZg0K
