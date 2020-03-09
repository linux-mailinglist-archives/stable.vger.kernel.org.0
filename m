Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D3117E642
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgCISBl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 14:01:41 -0400
Received: from mail-oln040092066098.outbound.protection.outlook.com ([40.92.66.98]:17472
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726920AbgCISBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 14:01:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEGyhtOykNBYhYJXTrU5BYn5Nw1jiW0u9AbUkiS+/Nr0gFQy2G6G6mYj3pfard+/DP5MH9SncGjGTX6Ck54BD+UFtR0hSlg45/QitPqhhUZhiU0F6BHRrq8OAkguttHUyifUwuaGGbA4tiAIxYXtTIDSVAApztC8U4KRPCrhXtCd12VcjIy/cbRL8WJPsK8nNZYd//NSWMqx3yHmL/jaPazVaSJws1NddE8VJb1s+PudacD3igxifd2TKofE5JI4kGujEN0kv9jyK+OakqRD71FRfIEO7hiPA1DpuXVT0co957n/cinj6UWSC+/p1aZEool05WRRM9pEKAhxOHuszA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaFADDnkPuGl8Zmq7Kn5QVuRowweiKh7NmWI4heORTw=;
 b=YbrpeNR2H6J46Ndn6G0jwycGLPJYT3DIaLKxorsINcRvumORPVVkey8GAbY21Jp9wTOltIKJiQvQzWRCRFiQupw0PYNgRcQfNQ+AJiOPr9fOe1nvadQmf23wSa6Hg+tS8IW3mD4te+3HJPt+hzHPLGv7AmaXKD3zF1FA8EqqSkKye0OeKv1KzqFe/D5jibblUrSBR9x3eXKhe8/xlnJLff2fka5DWHaATUn4K3RNhvL2JxOtxPIAXewe9Gpan0wTmVR9/ix4E+3kMyvDVYw3vnjTxnoQjwEWcR+ux28Ql8HNWZ1/7gl3qjZFpMvAtITfpH0ZVd2So9JKi261SlW9Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB5EUR01FT058.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e1a::35) by
 DB5EUR01HT079.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e1a::189)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 18:01:35 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.4.51) by
 DB5EUR01FT058.mail.protection.outlook.com (10.152.5.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 18:01:35 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 18:01:35 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0034.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Mon, 9 Mar 2020 18:01:33 +0000
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
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Topic: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Index: AQHV9ZJHYfsGvDLnM0SksOJ5MpqOZahARvEAgABCQ42AAAUtgA==
Date:   Mon, 9 Mar 2020 18:01:35 +0000
Message-ID: <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <878sk94eay.fsf@x220.int.ebiederm.org>
In-Reply-To: <878sk94eay.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0034.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::21) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:A57AD5DF42E7681DD1A5E9478BCCAE97A758CE38338C8F4FF21105D5B882CB10;UpperCasedChecksum:E220060974F10C0CB68726E7BBB16EF0EACD99CD78B5974A67339EC0E43D0DB4;SizeAsReceived:9897;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [/ILZkTKjw93Tvir6ADJQOGFs7+aME87d]
x-microsoft-original-message-id: <884bc59f-da81-2d41-c998-fed8957a975b@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: fc7261d3-faa1-4e64-ed3b-08d7c453e7fc
x-ms-traffictypediagnostic: DB5EUR01HT079:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jn3KF51toENzP2Npoicxyji9z9CjEqjFVpiaBq3OioOaW8mVuFMLz38ecOcJ8OMgLMyc6LYfTXdL7bKJS9AclD2FbTkFhFVdBEg5DYVak8oKphPtI9brsNYx9kLK5OQrCF7Zj5a9TQPdCO0KDXMJz1gBSdpPfiVdST0OeocMUnnLkFYjo0pSilENj3EcL9X6
x-ms-exchange-antispam-messagedata: ma3dbFshHeEX2/XVIdEgnMUAGPt0IfYjmRRt0SUCVgOJOlgA5mkWBs6td6o2PaaPOWhZDvQsWsvJOWjIJQz+7G2b49gsm3J+WeHQ8uMbUgEQqcyb51ip8HnGft4SJhYmWQFKzLl5J8u3xZ+j0q14zA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <972EFA2F9B6F6F4DA42C93C492443383@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: fc7261d3-faa1-4e64-ed3b-08d7c453e7fc
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 18:01:35.2755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR01HT079
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/20 6:40 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/8/20 10:38 PM, Eric W. Biederman wrote:
>>>
>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>> over the userspace accesses as the arguments from userspace are read.
>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>                                 ^ over
>>
>> ... is held while waiting for the trace parent to handle PTRACE_EVENT_EXIT
>> or something?
> 
> Yes.  Let me see if I can phrase that better.
> 
>> I wonder if we also should mention that
>> it is held while waiting for the trace parent to
>> receive the exit code with "wait"?
> 
> I don't think we have to spell out the details of how it all works,
> unless that makes things clearer.  Kernel developers can be expected
> to figure out how the kernel works.  The critical thing is that it is
> an indefinite wait for userspace to take action.
> 
> But I will look.
> 
>>> threads are killed.  The cred_guard_mutex is held over
>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>
>>> Any of those can result in deadlock, as the cred_guard_mutex is held
>>> over a possible indefinite userspace waits for userspace.
>>>
>>> Add exec_update_mutex that is only held over exec updating process
>>
>> Add ?
> 
> Yes.  That is what the change does: add exec_update_mutex.
> 

I just kind of missed the "subject" in this sentence,
like "This patch adds an exec_update_mutex that is ..."
but english is a foreign language for me, so may be okay as is.


Bernd.

>>> with the new contents of exec, so that code that needs not to be
>>> confused by exec changing the mm and the cred in ways that can not
>>> happen during ordinary execution of a process.
>>>
>>> The plan is to switch the users of cred_guard_mutex to
>>> exec_udpate_mutex one by one.  This lets us move forward while still
>>
>> s/udpate/update/
> 
> Yes.  Very much so.
> 
> Eric
> 
