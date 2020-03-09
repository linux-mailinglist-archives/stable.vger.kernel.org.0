Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EB417E775
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 19:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgCISrk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 14:47:40 -0400
Received: from mail-oln040092070034.outbound.protection.outlook.com ([40.92.70.34]:1166
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727334AbgCISrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 14:47:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqN3ZX2pqMOeLl5rlrKkTGNV2/mztrjrkWZW3JLvhvDyJaJUzr+Qs4wJJMxAlVExyx3HjQxVWGILzbDOsnY3hheHL4ws6C7X/0XlVbawWVwLCXBrDHO50yTjGTLnppvDQ+828ub1wUQACne5G4tLVTsrcd7tt13zQ4InO/lQ/qQwCprwmJtN43arR4qnEwvcfUr14yzWme39gANE4bSrIRFMxn+rKiOb34tCts09RG3jVyH2uORjCgXTtwFBxI2TAUeyE3NaKZpvrBwFUb3hvmeniXPBnVktYiS3U72m9yotOOkfs14HlG5J4aDHUkSXqctHmSOAAa1X30FpJ1ID3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7H1A0H76jH6eSJLcejuScwrFt8LXQ8nOgkOC4bWRTU=;
 b=MjmlJTHPtpuLheM6k/fg821dUvDbeCHwcOrQggx3Y0gkIK6Q4QrILbXKQF1dp4ZgmqxMm6m1nBLP7alxaxeVpZ+11d4Ni3O9bCA3R44zfpuOkEwSYPZudgmsKirUASI30e2b4Cs3uHtCCmpsuujyVSNdHA2kHET0wKx0LSPV2kcKXB4qkFjG8X2N/kEZfhnKvEGMow1YsTxM/B0yhhBcmCtsFO0876zQH7nq8JUZVj7q898teZM5cLTaRX6QLSYTmfvLlVwrronIsKg6cwolzYm5AGmzT0q4Dk6F52yHtwyNO6/cOVHuFWm8sjFL9Z9hxc4AjGkBonp93E9JXGdskQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB5EUR03FT047.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e0a::35) by
 DB5EUR03HT121.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e0a::445)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 18:47:33 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.20.55) by
 DB5EUR03FT047.mail.protection.outlook.com (10.152.21.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 18:47:33 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 18:47:33 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Mon, 9 Mar 2020 18:47:32 +0000
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
Thread-Index: AQHV9ZJHYfsGvDLnM0SksOJ5MpqOZahARvEAgABCQ42AAAUtgIAAA0/bgAADytmAAANO2YAAAnOA
Date:   Mon, 9 Mar 2020 18:47:33 +0000
Message-ID: <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y12yc7.fsf@x220.int.ebiederm.org> <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
In-Reply-To: <87d09l2x5n.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:17D50A9079693C9730F13F4FCFB4C58965ABDABB018076CCCBFAE6141CCBDE09;UpperCasedChecksum:943194F64A5F2251D16D357F1D689DF5F732291536CA9783E0600AACAC54A29E;SizeAsReceived:9977;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [3oQ7Uxmx+ynr7v1Spcc0igVUIJqKghv9]
x-microsoft-original-message-id: <a2581578-c3c6-6055-1811-08feca5d1cd3@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: bef8d83c-f9a0-4369-50ba-08d7c45a542a
x-ms-traffictypediagnostic: DB5EUR03HT121:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mcxWwbqx6jZv4TamNQqlbiI3Ar93DM75YP5msmSrCZjI/hoFC3oQ46BxTJl3n+VOJJSe4sSheD6A3eCiWVtE0ftx/0/JGvbMuoXDpyaVdCNTRlCmY8yNKgZaXfrrWWmJFpLJNSkoaQcut6w3vPEEBahop63tE4IUHri6twFVuZ8RkaAf7t5zpKVDPnVR75Gr1yrzyomjNFF3JiNaqREUgpwEa4ByxM0nfyzSqo6Q1kU=
x-ms-exchange-antispam-messagedata: Ax8gQJ7eltKZ1TbGEo1FsMhWsQ+vm8pGzfoym/VXJYqaA9QznsnNPidOSbTJKFGRocdUqPFFZxmPN/ubXrMBauR919P0Omwp9LEP6ExRpiXSa7mgOlIutNoKz8V+oQ6j80entIMyByasDOgukM/6Xw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <3A42B7F095068546B228DA429521FE49@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: bef8d83c-f9a0-4369-50ba-08d7c45a542a
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 18:47:33.7822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT121
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/20 7:36 PM, Eric W. Biederman wrote:
> 
> My rewritten change description reads as follows:
> 
>     exec: Add a exec_update_mutex to replace cred_guard_mutex

is this "an" exec_update_mutex?

>     
>     The cred_guard_mutex is problematic as it is held over possibly
>     indefinite waits for userspace.  The possilbe indefinite waits for
>     userspace that I have identified are: The cred_guard_mutex is held in
>     PTRACE_EVENT_EXIT waiting for the tracer.  The cred_guard_mutex is
>     held over "put_user(0, tsk->clear_child_tid)" in exit_mm().  The
>     cred_guard_mutex is held over "get_user(futex_offset, ...")  in
>     exit_robust_list.  The cred_guard_mutex held over copy_strings.
>     
>     The functions get_user and put_user can trigger a page fault which can
>     potentially wait indefinitely in the case of userfaultfd or if
>     userspace implements part of the page fault path.
>     
>     In any of those cases the userspace process that the kernel is waiting
>     for might userspace might make a different system call that winds up
                ^-------------^
                      ^- remove this
>     taking the cred_guard_mutex and result in deadlock.
>     
>     Holding a mutex over any of those possibly indefinite waits for
>     userspace does not appear necessary.  Add exec_update_mutex that will
>     just cover updating the process during exec where the permissions and
>     the objects pointed to by the task struct may be out of sync.
>     
>     The plan is to switch the users of cred_guard_mutex to
>     exec_udpate_mutex one by one.  This lets us move forward while still

            ^-- typo: update

>     being careful and not introducing any regressions.
>     
>     Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
>     Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>     Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
>     Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
>     Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
>     Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
>     Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
>     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Does that sound better?
> 

almost done.

> Eric
> 
