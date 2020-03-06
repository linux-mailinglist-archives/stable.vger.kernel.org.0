Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75E517C623
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 20:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCFTQN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 6 Mar 2020 14:16:13 -0500
Received: from mail-oln040092070042.outbound.protection.outlook.com ([40.92.70.42]:8449
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbgCFTQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 14:16:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FghbxTReKSlAco+/DZw4jTOqbOguzXfGPbvIuxD+njSiaofPYF9jg0UO1bktRbhWatDyipYIPa9d6yRaWGavSnJiSPbPUf7hWXICiOqLDhWEGFucQShy31WfE4zdXp0XM3m4Z9ofBoP6Y8OKYOT5pTna3UeZcr164NyA/IIuFuc1hEbEs3jNZXhnsXbVJQb57u/TZhOMVJ6tMV6VFoj/3lvt75SjuYVtJ3zoahj6GsSns5YHYZ3tjtjjXWuJQXgVO6XdCvCjeypHsWQK2v/AlwYNTO3ariRjL01LhrrTKCFV6tkLRwiTAAG7IfAvCHpNNHA6yzORcDe8w6O4c9Yg3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIzJzakET+nudEIKDq5F6x974sE6vtbHCXBBRfPzsbM=;
 b=n1rLGoYP8nla7yBgJN41Vuk+gPWp4/nCtvIfM1MyW2Sq7eTKjQGm9WflmDP9PviMy1L9t+QYGuNXwFyS6l0z7PzR2YX2ixDrRp0laVINlXRuvzmeiO2aAInvY6XC2/nJAQhvimvUtOxsFq3Z5SB/djsmPQWjlWCGHhnr8k8dlFL0h1BLzUeSaX2hvlD4SMcrc8fGUngVfBeTpmElQrfOKwFY+PeiAIIa+6lP4e5s3YYxPlbA4d1nTAy+rRPT76BezNNp+m1+DikO82K0cg0Sh4iIU2dlxZIn8HWcgrehKNKXTeG/s5CNzLwVAiZaB7qomPbwNaGJRqAPSHqB3xPYhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB5EUR03FT020.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e0a::3c) by
 DB5EUR03HT131.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e0a::307)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Fri, 6 Mar
 2020 19:16:08 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.20.51) by
 DB5EUR03FT020.mail.protection.outlook.com (10.152.20.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Fri, 6 Mar 2020 19:16:08 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 19:16:08 +0000
Received: from [192.168.1.101] (92.77.140.102) by FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Fri, 6 Mar 2020 19:16:07 +0000
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
Subject: Re: [PATCH 2/2] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Topic: [PATCH 2/2] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Index: AQHV8zOjiaOX92PFsUy1cOGGFJ5V7ag6ihsAgAB9KjCAAOmyAA==
Date:   Fri, 6 Mar 2020 19:16:08 +0000
Message-ID: <AM6PR03MB5170E9D0DB405EC051F7731CE4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87imjicxjw.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170375DBF699D4F3DC7A08DE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k13yawpp.fsf@x220.int.ebiederm.org>
In-Reply-To: <87k13yawpp.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14)
 To AM6PR03MB5170.eurprd03.prod.outlook.com (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:EAD22F76A094F409A4EDCD4477720CEB4503D562E8D6AA0F890EDBA16291F42E;UpperCasedChecksum:71F045288ECA85363986E47F3340E99BB2B694FE8C4D59FE3583673AEEE75A6A;SizeAsReceived:9908;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [NjjbdR5hkty6MCsyI4upoQ3j5M/LGKJ+]
x-microsoft-original-message-id: <3809f78d-9223-ea8a-ce30-73dcf372d21d@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 00161e8f-36fa-488a-de4c-08d7c202d31b
x-ms-traffictypediagnostic: DB5EUR03HT131:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ou8Rae7NaWgGLlGpxv8IlgAD0rnGOfKRp3LkYZFlTSDVX26TdBtTfnvi5HjRCcRuMTqKn/01JrT0dImgQrL4aZc1/LZChvEtCY0BEiD6PFr+iImq55NAfUXtpbLZtKPWR8rcmgVAWcDSd7MjlgDGgT5TQnnVK9/AzigTObVOne1Z/W4DAhUok4ZS8I8OymNB
x-ms-exchange-antispam-messagedata: PQrQw1zcai4oqKo9xMjG8obL6CcGrgfQ++dRBm6IDPboDPUI3jHIe0Mid36OyT2vBJhfKtOTPe1TyQu1GxRItstobjF1rSBSMnWHqP9VIQ4YGpUPXWZkxwjBOkBUpiKZoG9qCDhFdJ60SKnQWiqi8A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <CA5DC7EFFE138C4AAD3C85E6122AAC41@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 00161e8f-36fa-488a-de4c-08d7c202d31b
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2020 19:16:08.8373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT131
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/6/20 6:17 AM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/5/20 10:16 PM, Eric W. Biederman wrote:
>>>
>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>> over the userspace accesses as the arguments from userspace are read.
>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>> threads are killed.  The cred_guard_mutex is held over
>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>

I am all for this patch, and the direction it is heading, Eric.

I just wanted to add a note that I think it is
possible that exec_mm_release can also invoke put_user(0, tsk->clear_child_tid),
under the new exec_update_mutex, since vm_access increments the
mm->mm_users, under the cred_update_mutex, but releases the mutex,
and the caller can hold the reference for a while and then exec_mmap is not
releasing the last reference.


Bernd.
