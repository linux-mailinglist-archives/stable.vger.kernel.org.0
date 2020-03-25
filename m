Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8061F192BF4
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 16:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgCYPNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 11:13:08 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48290 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbgCYPNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 11:13:08 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jH7iL-0000FW-EX; Wed, 25 Mar 2020 09:13:05 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jH7iK-00084e-3v; Wed, 25 Mar 2020 09:13:05 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
References: <AM6PR03MB5170B2F5BE24A28980D05780E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Wed, 25 Mar 2020 10:10:28 -0500
In-Reply-To: <AM6PR03MB5170B2F5BE24A28980D05780E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Fri, 20 Mar 2020 21:24:03 +0100")
Message-ID: <871rpg8o7v.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jH7iK-00084e-3v;;;mid=<871rpg8o7v.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+JEzuXaPnCFv9XVnwdfICRpMm6S2cfZJU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4965]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 715 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 3.6 (0.5%), b_tie_ro: 2.4 (0.3%), parse: 0.72
        (0.1%), extract_message_metadata: 9 (1.3%), get_uri_detail_list: 1.45
        (0.2%), tests_pri_-1000: 6 (0.9%), tests_pri_-950: 0.97 (0.1%),
        tests_pri_-900: 0.84 (0.1%), tests_pri_-90: 376 (52.6%), check_bayes:
        363 (50.8%), b_tokenize: 10 (1.4%), b_tok_get_all: 9 (1.3%),
        b_comp_prob: 2.1 (0.3%), b_tok_touch_all: 338 (47.3%), b_finish: 0.85
        (0.1%), tests_pri_0: 305 (42.7%), check_dkim_signature: 0.39 (0.1%),
        check_dkim_adsp: 2.4 (0.3%), poll_dns_idle: 1.14 (0.2%), tests_pri_10:
        2.8 (0.4%), tests_pri_500: 7 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v6 00/16] Infrastructure to allow fixing exec deadlocks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This is an infrastructure change that makes way for fixing this issue.
> Each patch was already posted previously so this is just a cleanup of
> the original mailing list thread(s) which got out of control by now.
>
> Everything started here:
> https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>
> I added reviewed-by tags from the mailing list threads, except when
> withdrawn.
>
> It took a lot longer than expected to collect everything from the
> mailinglist threads, since several commit messages have been infected
> with typos, and they got fixed without a new patch version.
>
> - Correct the point of no return.
> - Add two new mutexes to replace cred_guard_mutex.
> - Fix each use of cred_guard_mutex.
> - Update documentation.
> - Add a test case.
>
> Bernd Edlinger (11):
>   exec: Fix a deadlock in strace
>   selftests/ptrace: add test cases for dead-locks
>   mm: docs: Fix a comment in process_vm_rw_core
>   kernel: doc: remove outdated comment cred.c
>   kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
>   proc: Use new infrastructure to fix deadlocks in execve
>   proc: io_accounting: Use new infrastructure to fix deadlocks in execve
>   perf: Use new infrastructure to fix deadlocks in execve
>   pidfd: Use new infrastructure to fix deadlocks in execve
>   exec: Fix dead-lock in de_thread with ptrace_attach
>   doc: Update documentation of ->exec_*_mutex
>
> Eric W. Biederman (5):
>   exec: Only compute current once in flush_old_exec
>   exec: Factor unshare_sighand out of de_thread and call it separately
>   exec: Move cleanup of posix timers on exec out of de_thread
>   exec: Move exec_mmap right after de_thread in flush_old_exec
>   exec: Add exec_update_mutex to replace cred_guard_mutex
>
>  Documentation/security/credentials.rst    |  29 +++++--
>  fs/exec.c                                 | 122 ++++++++++++++++++++++--------
>  fs/proc/base.c                            |  23 +++---
>  include/linux/binfmts.h                   |   8 +-
>  include/linux/sched/signal.h              |  17 ++++-
>  init/init_task.c                          |   3 +-
>  kernel/cred.c                             |   4 +-
>  kernel/events/core.c                      |  12 +--
>  kernel/fork.c                             |   7 +-
>  kernel/kcmp.c                             |   8 +-
>  kernel/pid.c                              |   4 +-
>  kernel/ptrace.c                           |  20 ++++-
>  kernel/seccomp.c                          |  15 ++--
>  mm/process_vm_access.c                    |   2 +-
>  tools/testing/selftests/ptrace/Makefile   |   4 +-
>  tools/testing/selftests/ptrace/vmaccess.c |  86 +++++++++++++++++++++
>  16 files changed, 278 insertions(+), 86 deletions(-)
>  create mode 100644 tools/testing/selftests/ptrace/vmaccess.c

Two small nits.

- You reposted my patches with adding your signed-off-by
- You reposted my patches and did not include a "From:"
  in the body so "git am" listed you as the author.

I have fixed those up and will be merging this code to linux-next,
unless you object.

Eric

