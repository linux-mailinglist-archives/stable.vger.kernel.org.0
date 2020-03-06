Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A81617C2DE
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 17:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCFQ0k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 6 Mar 2020 11:26:40 -0500
Received: from mail-oln040092074103.outbound.protection.outlook.com ([40.92.74.103]:51330
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbgCFQ0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 11:26:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mndLkuF/4+ZA8pg23sQ9BVkOtGDP0VE5c+lpIaJUjY5YySiJ2Avseh8fQonLow2E+UilVMoEs2iHF8hIC3VRAYouAh7Vwqg1H2dkuzyrrUc+cEH0xzOtpEo6ph2m6pjj2PkW4o7NLJ3jmEFjinyknuVti1ODKfTi0Q/5XGP42GPICaX422J4muvDnUTzaSwmamuwyiclT/DWWLH0OYvY333u8b8OfKvt4OvVtw+uJ6ppL3cuMjOLsUnp2tnf0za8aONfin53ImrsJhDV5Q4R0OhBK+wOPG8b8nTBqAF4mI3CGFtrdq+D1ckftSU/1lPT8YgVvWW8G07TBEKtQTZ+sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Io7E+Ui2qIzTcTCR72QAGn67K2nLZUYLahWMx2SMUc=;
 b=X57kxxxfGDnewALInZkbNePdMoLa4oQkduU6T3p6vZKjlh/r2O+Qk9EXP4RKbWDVVWYK+V3jnggakzBFmAsyFgHXAite5gAeq3akrWpdaplqaLetAlV1Zqayc3zIByJoFTBT1LTkHtMVoOxWTr6hr5MAej6Wgo+CAqi+RRpPuKSWIe651eQirSas0L+RVXN1Y3Yh/qR1DBJlJpTD0QYoMuJVo2m4fU+i+IZ7D/LdoXOP4t5UGgMaW2MAyC51gUo5hmsYNoUXOkT5CsVesO3q953423vsUXE2AA9+cj1gTghAMUpjJKIPlwZ+s2kD5Usi/175kxzmB/xtrbL9M+OvUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR04FT058.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::36) by
 VI1EUR04HT180.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::66)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Fri, 6 Mar
 2020 16:26:35 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.28.57) by
 VI1EUR04FT058.mail.protection.outlook.com (10.152.29.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Fri, 6 Mar 2020 16:26:35 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 16:26:35 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZRAP278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Fri, 6 Mar 2020 16:26:33 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/2] exec: Properly mark the point of no return
Thread-Topic: [PATCH 1/2] exec: Properly mark the point of no return
Thread-Index: AQHV8zOIDtdt4OHpy0WII6Z+9AZegqg6nBAAgABo5giAALyfgA==
Date:   Fri, 6 Mar 2020 16:26:34 +0000
Message-ID: <AM6PR03MB5170688693E4114CA9367211E4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87o8tacxl3.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170B05CFDAF21D8A99B7E48E4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87pndqax3j.fsf@x220.int.ebiederm.org>
In-Reply-To: <87pndqax3j.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZRAP278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::24) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:DA816E1DEDC4BA9DF9DBBBF2CC39CA4E2C4664A595A9424824BFDAF23294FBD6;UpperCasedChecksum:E1114A9E9CF3C62F1A20B426AF6762161E7A0FAD8694E8A5FE36B25F189AB47F;SizeAsReceived:9897;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [w3tKcLr0mKFaBaS1K/cxK7beXyXo0iyJ]
x-microsoft-original-message-id: <4fe01e54-2f0f-3381-ed4c-e90f63741717@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: ec1878a5-305e-44f8-082d-08d7c1eb2307
x-ms-traffictypediagnostic: VI1EUR04HT180:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V3jE/pm2bdQm0TxXo+FfbjDhjLWDPgMmRhMVcgCeHk/31mvdiWIA/DuG/043D396eT0QhFXCyL7dSirFLnZdhQ6U12OdMjsWMC+kR0KRZ3jsaIHXyNtRD30l2bWbKtgFn8hQJZ/5gNNJH9yux7NmmfgrO0/veRe2FrUNcfobzZSqwf+29d8me5/Go+45oAnG
x-ms-exchange-antispam-messagedata: k+uC5fcaLM7rehNPDQoZeMxt3OfEGzH7p2/ZRbCOhIoecExfA2Ouq1x+euM5xUOFLKbkSJ2wIMD5//t/wWfpdjfvSV3a+CYfh5EKJWqtpiDWQu8cFt0i+4gka2bxuT4/7Yh5+doi7cT4MnQZBcmZtg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <7C09FD473FD1FA4FA82AF05D172951FF@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1878a5-305e-44f8-082d-08d7c1eb2307
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2020 16:26:34.9940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/6/20 6:09 AM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/5/20 10:15 PM, Eric W. Biederman wrote:
>>>
>>> Add a flag binfmt->unrecoverable to mark when execution has gotten to
>>> the point where it is impossible to return to userspace with the
>>> calling process unchanged.
>>>
>>> While techinically this state starts as soon as de_thread starts

typo: s/techinically/technically/

>>> killing threads, the only return path at that point is if there is a
>>> fatal signal pending.  I have choosen instead to set unrecoverable

I'm not good at english, is this chosen ?


Bernd.
