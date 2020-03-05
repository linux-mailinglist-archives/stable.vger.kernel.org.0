Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412EB17AE3D
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 19:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgCEShC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 5 Mar 2020 13:37:02 -0500
Received: from mail-oln040092067067.outbound.protection.outlook.com ([40.92.67.67]:13599
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbgCEShA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 13:37:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhI1XmqziQW3YD5gb0ntt3IPDLbGePnZ/sRTRYGw7N+dKY76oBAD/G/JtxpKAO9KBpg5VwpnEhYMLxxD6tbFqDBoT0svGhWZCzicNBToFj5XQhGiq7KJt/bn8RknXA0lMDCwoXXFIkyT+GYUB2nxVYkhJv0Klk5csa5dO6co/aweB38dvPVYz2PoV/EZ+PSDNL4zin9Wina3AoDCg0FH8dq8gHbUx5j7JJ62uKTLaBOBs1qoqha7lp+n2DV26Xetfwk65VQ55PI+iwvEay1vUHY6g1TslV2WqiWYZ2nJFGVVCHuiUSEY1fxWWLTPRUIg7PgvRahkNZ7t8do2ObTuHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9fOsTZe1Bu5+YzcnxB3Teb7n1ZqO5xQHkklFS4b55E=;
 b=KGIUpWtE1xVjWZ/VNSYaXdETkwCF47bLdM+c21K4fLyxlahRcQH2OdmEXijPYVBmX+ckBvTZjSARRQfNgC1ML50kBPW2VtXiS+0rMA+SJ6YTwJaw6OXrpjPMKV5/n28Wksml1zwArUmhY+6yUdxenD7ZOe7x3UnNf0Z0hIdm4A4CwSvmxJBoM+5lKdYfeuOiV60BQiM2M5lvt4fBHSTVJlCIG/WdBh3fHNfnLbghsECIww+jPDGo5xbV/XWD5SddHvj2WJFKYxr4My477kFTObz1luSmScvkQe8pmgofd6XsWKsgInlsYC5wSgHxRuGbt5Iq5lZeWx/Xoua0k7NZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR02FT035.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1d::37) by
 HE1EUR02HT157.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1d::322)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Thu, 5 Mar
 2020 18:36:53 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.10.56) by
 HE1EUR02FT035.mail.protection.outlook.com (10.152.10.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Thu, 5 Mar 2020 18:36:53 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 18:36:53 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Thu, 5 Mar 2020 18:36:51 +0000
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
Subject: Re: [PATCHv6] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv6] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8m+7BrfnobQhVEKxcy9pzNZ2y6g6VTEA
Date:   Thu, 5 Mar 2020 18:36:53 +0000
Message-ID: <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
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
In-Reply-To: <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::21) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:679214EAD33E58F43A82E3A11FB996CD2DDB650D65B95A6F3BF96E8083093BDD;UpperCasedChecksum:25D458CC34E45A2DFA7BE01FCEF9F28B987CD969EEAA812854BAF0D6654235F9;SizeAsReceived:9890;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [puvcacwKR1/Ck1E4UQTYNFKbdTcKFJBY]
x-microsoft-original-message-id: <b4916235-a8a1-03b5-b8e8-d3e360f33132@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 38cd4891-3897-48e0-c0ca-08d7c1342d00
x-ms-traffictypediagnostic: HE1EUR02HT157:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w8Qwt79BMl/tl69BFAF8YQZi4V1xAJtXtU+u7q5mJtBKfJOvAoCnrElesOlhdmjLLDnW0wJsiM89ShwRccIv+caZMNDoGEkC7hbTQNnwa98rz8XcBKdiZtRuW4RO//FvOzdfEhOfdN9lkRXcMppT6jQwy9qf3iPz50vOe77YFeD4Kl3jbki8MQEk0U2afVrC
x-ms-exchange-antispam-messagedata: lEyhxXpWGgWNAEC8ffuxTxKJsxX6Zo+Gg7EpR6F3Bq7al7ICG5MHAIKWCPbrj7GlMBcshdH7cignjTUpSH3Mp3PNJeU/txfZU63gImassXKz9DELMMiuAfZhfNoZLOoi1XRN6vtFyh6H3a5ZxGmgRQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <C34358DEA3C7BF46ABBFD8476CCEB248@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 38cd4891-3897-48e0-c0ca-08d7c1342d00
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 18:36:53.7506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT157
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/4/20 10:56 PM, Bernd Edlinger wrote:
> This fixes a deadlock in the tracer when tracing a multi-threaded
> application that calls execve while more than one thread are running.
> 
> I observed that when running strace on the gcc test suite, it always
> blocks after a while, when expect calls execve, because other threads
> have to be terminated.  They send ptrace events, but the strace is no
> longer able to respond, since it is blocked in vm_access.
> 
> The deadlock is always happening when strace needs to access the
> tracees process mmap, while another thread in the tracee starts to
> execve a child process, but that cannot continue until the
> PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:
> 
> strace          D    0 30614  30584 0x00000000
> Call Trace:
> __schedule+0x3ce/0x6e0
> schedule+0x5c/0xd0
> schedule_preempt_disabled+0x15/0x20
> __mutex_lock.isra.13+0x1ec/0x520
> __mutex_lock_killable_slowpath+0x13/0x20
> mutex_lock_killable+0x28/0x30
> mm_access+0x27/0xa0
> process_vm_rw_core.isra.3+0xff/0x550
> process_vm_rw+0xdd/0xf0
> __x64_sys_process_vm_readv+0x31/0x40
> do_syscall_64+0x64/0x220
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> expect          D    0 31933  30876 0x80004003
> Call Trace:
> __schedule+0x3ce/0x6e0
> schedule+0x5c/0xd0
> flush_old_exec+0xc4/0x770
> load_elf_binary+0x35a/0x16c0
> search_binary_handler+0x97/0x1d0
> __do_execve_file.isra.40+0x5d4/0x8a0
> __x64_sys_execve+0x49/0x60
> do_syscall_64+0x64/0x220
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The proposed solution is to detect if a sibling thread
> exists that is traced and in this case to make PTRACE_ACCESS
> fail with -EAGAIN instead of dead-lock.
> But other functions like vm_access are allowed to complete normally.
> 
> This changes the lifetime of the cred_guard_mutex lock to be
> from flush_old_exec() through install_exec_creds().
> Before, cred_guard_mutex was held from prepare_bprm_creds() through
> install_exec_creds().
> 
> Additionally a new mutex exec_guard_mutex is introduced that is used
> for PTRACE_ACCESS and SECCOMP_FILTER_FLAG_TSYNC.
> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  Documentation/security/credentials.rst    | 29 ++++++++---
>  fs/exec.c                                 | 58 ++++++++++++++++++---
>  include/linux/binfmts.h                   | 15 +++++-
>  include/linux/sched/signal.h              | 10 ++--
>  init/init_task.c                          |  1 +
>  kernel/cred.c                             |  4 +-
>  kernel/fork.c                             |  1 +
>  kernel/ptrace.c                           | 20 ++++++--
>  kernel/seccomp.c                          | 15 +++---
>  mm/process_vm_access.c                    |  2 +-
>  tools/testing/selftests/ptrace/Makefile   |  4 +-
>  tools/testing/selftests/ptrace/vmaccess.c | 85 +++++++++++++++++++++++++++++++
>  12 files changed, 210 insertions(+), 34 deletions(-)
>  create mode 100644 tools/testing/selftests/ptrace/vmaccess.c
> 

Okay, I think there is consensus about the next steps to be as follows:

- post the Documentation/security/credentials.rst changes as an independent patch.
- post a infrastructure patch which only introduces two new mutexes,
  one exec_guard_mutex, and one the "cred_change_mutex" (I am unhappy with that name,
  because credentials can change without the cred_guard_mutex, this appears more
  to guarantee that the credentials of the process and the process memory map are
  consistent, so I think I need to think of a better name first...)
  This keeps cred_guard_mutex as is, just deprecates it, and adds a note that it will
  go away.
- post one patch that fixes the mm_access code path
- post one patch that fixes the PTRACE_ATTACH code path
- post one patch that introduces the new test cases


Thanks
Bernd.
