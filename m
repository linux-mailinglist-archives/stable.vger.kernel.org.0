Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCB518015F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgCJPQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:16:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54422 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJPQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:16:07 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBgby-0004CF-1k; Tue, 10 Mar 2020 09:16:02 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBgbx-0004Li-5P; Tue, 10 Mar 2020 09:16:01 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <878sk94eay.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y12yc7.fsf@x220.int.ebiederm.org>
        <87k13t2xpd.fsf@x220.int.ebiederm.org>
        <87d09l2x5n.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <871rq12vxu.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <877dzt1fnf.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517033EAD25BED15CC84E17DE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 10:13:42 -0500
In-Reply-To: <AM6PR03MB517033EAD25BED15CC84E17DE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Tue, 10 Mar 2020 14:43:41 +0100")
Message-ID: <87d09kxmxl.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBgbx-0004Li-5P;;;mid=<87d09kxmxl.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/eOO49tMC1vtWTUcFarj2ncADp1TyDOKs=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMNoVowels autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 328 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 2.3 (0.7%), b_tie_ro: 1.57 (0.5%), parse: 0.90
        (0.3%), extract_message_metadata: 10 (3.0%), get_uri_detail_list: 1.60
        (0.5%), tests_pri_-1000: 15 (4.5%), tests_pri_-950: 0.98 (0.3%),
        tests_pri_-900: 0.92 (0.3%), tests_pri_-90: 36 (11.1%), check_bayes:
        35 (10.7%), b_tokenize: 11 (3.5%), b_tok_get_all: 11 (3.4%),
        b_comp_prob: 2.8 (0.9%), b_tok_touch_all: 8 (2.5%), b_finish: 0.59
        (0.2%), tests_pri_0: 252 (76.8%), check_dkim_signature: 0.51 (0.2%),
        check_dkim_adsp: 2.3 (0.7%), poll_dns_idle: 0.61 (0.2%), tests_pri_10:
        1.75 (0.5%), tests_pri_500: 5 (1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/4] exec: Fix a deadlock in ptrace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

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

Overall this looks good.  Mind if I change the subject to:
"exec: Fix a deadlock in strace" ?

Eric


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
> This changes mm_access to use the new exec_update_mutex
> instead of cred_guard_mutex.
>
> This patch is based on the following patch by Eric W. Biederman:
> "[PATCH 0/5] Infrastructure to allow fixing exec deadlocks"
> Link: https://lore.kernel.org/lkml/87v9ne5y4y.fsf_-_@x220.int.ebiederm.org/
>
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  kernel/fork.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index c12595a..5720ff3 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1224,7 +1224,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  	struct mm_struct *mm;
>  	int err;
>  
> -	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
> +	err =  mutex_lock_killable(&task->signal->exec_update_mutex);
>  	if (err)
>  		return ERR_PTR(err);
>  
> @@ -1234,7 +1234,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  		mmput(mm);
>  		mm = ERR_PTR(-EACCES);
>  	}
> -	mutex_unlock(&task->signal->cred_guard_mutex);
> +	mutex_unlock(&task->signal->exec_update_mutex);
>  
>  	return mm;
>  }
