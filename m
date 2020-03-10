Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4531807A5
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 20:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCJTI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 15:08:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43668 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgCJTI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 15:08:59 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBkFN-0001yX-6z; Tue, 10 Mar 2020 13:08:57 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBkFL-0004Uf-I6; Tue, 10 Mar 2020 13:08:57 -0600
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
        <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <875zfcxlwy.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 14:06:36 -0500
In-Reply-To: <AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Tue, 10 Mar 2020 18:45:47 +0100")
Message-ID: <874kuwvxkz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBkFL-0004Uf-I6;;;mid=<874kuwvxkz.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18WbrkloOri1g4xv59aV91UgTyj+0r0tb4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4972]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1243 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 2.7 (0.2%), b_tie_ro: 1.86 (0.1%), parse: 1.10
        (0.1%), extract_message_metadata: 22 (1.8%), get_uri_detail_list: 2.5
        (0.2%), tests_pri_-1000: 22 (1.8%), tests_pri_-950: 1.26 (0.1%),
        tests_pri_-900: 1.07 (0.1%), tests_pri_-90: 36 (2.9%), check_bayes: 34
        (2.8%), b_tokenize: 14 (1.1%), b_tok_get_all: 10 (0.8%), b_comp_prob:
        3.1 (0.3%), b_tok_touch_all: 4.6 (0.4%), b_finish: 0.64 (0.1%),
        tests_pri_0: 594 (47.8%), check_dkim_signature: 0.57 (0.0%),
        check_dkim_adsp: 3.3 (0.3%), poll_dns_idle: 534 (43.0%), tests_pri_10:
        2.1 (0.2%), tests_pri_500: 558 (44.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 3/4] proc: io_accounting: Use new infrastructure to fix deadlocks in execve
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This changes do_io_accounting to use the new exec_update_mutex
> instead of cred_guard_mutex.
>
> This fixes possible deadlocks when the trace is accessing
> /proc/$pid/io for instance.
>
> This should be safe, as the credentials are only used for reading.

This is an improvement.

We probably want to do this just as an incremental step in making things
better but perhaps I am blind but I am not finding the reason for
guarding this with the cred_guard_mutex to be at all persuasive.

I think moving the ptrace_may_access check down to after the
unlock_task_sighand would be just as effective at addressing the
concerns raised in the original commit.  I think the task_lock provides
all of the barrier we need to make it safe to move the ptrace_may_access
checks safe.

The reason I say this is I don't see exec changing ->ioac.  Just
performing some I/O which would update the io accounting statistics.

Can anyone see if I am wrong?

Eric


commit 293eb1e7772b25a93647c798c7b89bf26c2da2e0
Author: Vasiliy Kulikov <segoon@openwall.com>
Date:   Tue Jul 26 16:08:38 2011 -0700

    proc: fix a race in do_io_accounting()
    
    If an inode's mode permits opening /proc/PID/io and the resulting file
    descriptor is kept across execve() of a setuid or similar binary, the
    ptrace_may_access() check tries to prevent using this fd against the
    task with escalated privileges.
    
    Unfortunately, there is a race in the check against execve().  If
    execve() is processed after the ptrace check, but before the actual io
    information gathering, io statistics will be gathered from the
    privileged process.  At least in theory this might lead to gathering
    sensible information (like ssh/ftp password length) that wouldn't be
    available otherwise.
    
    Holding task->signal->cred_guard_mutex while gathering the io
    information should protect against the race.
    
    The order of locking is similar to the one inside of ptrace_attach():
    first goes cred_guard_mutex, then lock_task_sighand().
    
    Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  fs/proc/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 4fdfe4f..529d0c6 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2770,7 +2770,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>  	unsigned long flags;
>  	int result;
>  
> -	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
> +	result = mutex_lock_killable(&task->signal->exec_update_mutex);
>  	if (result)
>  		return result;
>  
> @@ -2806,7 +2806,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>  	result = 0;
>  
>  out_unlock:
> -	mutex_unlock(&task->signal->cred_guard_mutex);
> +	mutex_unlock(&task->signal->exec_update_mutex);
>  	return result;
>  }
