Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66B93A6C3E
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 18:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbhFNQpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 12:45:08 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59634 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbhFNQoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 12:44:39 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lspfU-00D7FK-2k; Mon, 14 Jun 2021 10:42:32 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lspfS-00BjnG-Lx; Mon, 14 Jun 2021 10:42:31 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michal Hocko <mhocko@suse.com>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Charles Haithcock <chaithco@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Helge Deller <deller@gmx.de>,
        YiFei Zhu <yifeifz2@illinois.edu>,
        Adrian Reber <areber@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
References: <AM8PR10MB4708AFBD838138A84CE89EF8E4359@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
        <20210610143642.e4535dbdc0db0b1bd3ee5367@linux-foundation.org>
        <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
Date:   Mon, 14 Jun 2021 11:42:22 -0500
In-Reply-To: <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
        (Bernd Edlinger's message of "Fri, 11 Jun 2021 17:55:09 +0200")
Message-ID: <877diwtn2p.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lspfS-00BjnG-Lx;;;mid=<877diwtn2p.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18+eJbPqFmFNte+/KoFQcpQyH7Zbs4+NIM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong,
        XM_B_Investor,XM_B_SpammyWords autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.0 XM_B_Investor BODY: Commonly used business phishing phrases
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 784 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 10 (1.2%), b_tie_ro: 8 (1.1%), parse: 1.36 (0.2%),
         extract_message_metadata: 15 (2.0%), get_uri_detail_list: 6 (0.7%),
        tests_pri_-1000: 7 (0.9%), tests_pri_-950: 1.24 (0.2%),
        tests_pri_-900: 1.02 (0.1%), tests_pri_-90: 161 (20.6%), check_bayes:
        150 (19.1%), b_tokenize: 22 (2.8%), b_tok_get_all: 16 (2.0%),
        b_comp_prob: 4.7 (0.6%), b_tok_touch_all: 103 (13.1%), b_finish: 0.99
        (0.1%), tests_pri_0: 575 (73.4%), check_dkim_signature: 0.73 (0.1%),
        check_dkim_adsp: 2.8 (0.4%), poll_dns_idle: 0.67 (0.1%), tests_pri_10:
        1.80 (0.2%), tests_pri_500: 6 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v9] exec: Fix dead-lock in de_thread with ptrace_attach
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This introduces signal->unsafe_execve_in_progress,
> which is used to fix the case when at least one of the
> sibling threads is traced, and therefore the trace
> process may dead-lock in ptrace_attach, but de_thread
> will need to wait for the tracer to continue execution.

Userspace processes hang waiting for each other.  Not a proper kernel
deadlock.  Annoying but not horrible.  Definitely worth fixing if we can.

> The solution is to detect this situation and allow
> ptrace_attach to continue, while de_thread() is still
> waiting for traced zombies to be eventually released.
> When the current thread changed the ptrace status from
> non-traced to traced, we can simply abort the whole
> execve and restart it by returning -ERESTARTSYS.
> This needs to be done before changing the thread leader,
> because the PTRACE_EVENT_EXEC needs to know the old
> thread pid.

Except you are not detecting this situation.  Testing for t->ptrace
finds tasks that have completed their ptrace attach and no longer need
the cred_gaurd_mutex.

You almost discover the related problem that involves PTRACE_EVENT_EXEC.

It will probably help to have a full description of all of the
processes and states involved in the hang in your description
so you can show how your proposed change avoids the problem.

> Although it is technically after the point of no return,
> we just have to reset bprm->point_of_no_return here,
> since at this time only the other threads have received
> a fatal signal, not the current thread.

No.  If you have killed other threads we are most definitely past the
point where it is at all reasonable to return to userspace.
Perfunctorily killing other threads may leave them with locks held and
who knows what other problems.  Certainly it leaves the application
unable to process a failure from exec and continue on.

> From the user's point of view the whole execve was
> simply delayed until after the ptrace_attach.

Conceptually I like what you are trying to detect and do.
However your description unfortunately does not match the code.

If you can find a test for another process waiting to ptrace_attach
one of our threads before we enter into de_thread that would be a
reasonable time to do something, and would potentially make a nice
fix.


Eric

> Other threads die quickly since the cred_guard_mutex
> is released, but a deadly signal is already pending.
> In case the mutex_lock_killable misses the signal,
> ->unsafe_execve_in_progress makes sure they release
> the mutex immediately and return with -ERESTARTNOINTR.
>
> This means there is no API change, unlike the previous
> version of this patch which was discussed here:
>
> https://lore.kernel.org/lkml/b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de/
>
> See tools/testing/selftests/ptrace/vmaccess.c
> for a test case that gets fixed by this change.
>
> Note that since the test case was originally designed to
> test the ptrace_attach returning an error in this situation,
> the test expectation needed to be adjusted, to allow the
> API to succeed at the first attempt.
>
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  fs/exec.c                                 | 37 +++++++++++++++++++++++++++++--
>  fs/proc/base.c                            |  6 +++++
>  include/linux/sched/signal.h              | 13 +++++++++++
>  kernel/ptrace.c                           |  9 ++++++++
>  kernel/seccomp.c                          | 12 +++++++---
>  tools/testing/selftests/ptrace/vmaccess.c | 25 ++++++++++++++-------
>  6 files changed, 89 insertions(+), 13 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 8344fba..c7b1926 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1040,6 +1040,8 @@ static int de_thread(struct task_struct *tsk)
>  	struct signal_struct *sig = tsk->signal;
>  	struct sighand_struct *oldsighand = tsk->sighand;
>  	spinlock_t *lock = &oldsighand->siglock;
> +	unsigned int prev_ptrace = tsk->ptrace;
> +	struct task_struct *t = tsk;
>  
>  	if (thread_group_empty(tsk))
>  		goto no_thread_group;
> @@ -1062,6 +1064,17 @@ static int de_thread(struct task_struct *tsk)
>  	if (!thread_group_leader(tsk))
>  		sig->notify_count--;
>  
> +	while_each_thread(tsk, t) {
> +		if (unlikely(t->ptrace) && t != tsk->group_leader)
> +			sig->unsafe_execve_in_progress = true;
> +	}
> +
> +	if (unlikely(sig->unsafe_execve_in_progress)) {
> +		spin_unlock_irq(lock);
> +		mutex_unlock(&sig->cred_guard_mutex);
> +		spin_lock_irq(lock);
> +	}
> +
>  	while (sig->notify_count) {
>  		__set_current_state(TASK_KILLABLE);
>  		spin_unlock_irq(lock);
> @@ -1072,6 +1085,17 @@ static int de_thread(struct task_struct *tsk)
>  	}
>  	spin_unlock_irq(lock);
>  
> +	if (unlikely(sig->unsafe_execve_in_progress)) {
> +		if (mutex_lock_killable(&sig->cred_guard_mutex))
> +			goto killed;
> +		sig->unsafe_execve_in_progress = false;
> +		if (!prev_ptrace && tsk->ptrace) {
> +			sig->group_exit_task = NULL;
> +			sig->notify_count = 0;
> +			return -ERESTARTSYS;
> +		}
> +	}
> +
>  	/*
>  	 * At this point all other threads have exited, all we have to
>  	 * do is to wait for the thread group leader to become inactive,
> @@ -1255,8 +1279,11 @@ int begin_new_exec(struct linux_binprm * bprm)
>  	 * Make this the only thread in the thread group.
>  	 */
>  	retval = de_thread(me);
> -	if (retval)
> +	if (retval) {
> +		if (retval == -ERESTARTSYS)
> +			bprm->point_of_no_return = false;
>  		goto out;
> +	}
>  
>  	/*
>  	 * Cancel any io_uring activity across execve
> @@ -1466,6 +1493,11 @@ static int prepare_bprm_creds(struct linux_binprm *bprm)
>  	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
>  		return -ERESTARTNOINTR;
>  
> +	if (unlikely(current->signal->unsafe_execve_in_progress)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		return -ERESTARTNOINTR;
> +	}
> +
>  	bprm->cred = prepare_exec_creds();
>  	if (likely(bprm->cred))
>  		return 0;
> @@ -1482,7 +1514,8 @@ static void free_bprm(struct linux_binprm *bprm)
>  	}
>  	free_arg_pages(bprm);
>  	if (bprm->cred) {
> -		mutex_unlock(&current->signal->cred_guard_mutex);
> +		if (!current->signal->unsafe_execve_in_progress)
> +			mutex_unlock(&current->signal->cred_guard_mutex);
>  		abort_creds(bprm->cred);
>  	}
>  	if (bprm->file) {
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 3851bfc..3b2a55c 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2739,6 +2739,12 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
>  	if (rv < 0)
>  		goto out_free;
>  
> +	if (unlikely(current->signal->unsafe_execve_in_progress)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		rv = -ERESTARTNOINTR;
> +		goto out_free;
> +	}
> +
>  	rv = security_setprocattr(PROC_I(inode)->op.lsm,
>  				  file->f_path.dentry->d_name.name, page,
>  				  count);
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 3f6a0fc..220a083 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -214,6 +214,17 @@ struct signal_struct {
>  #endif
>  
>  	/*
> +	 * Set while execve is executing but is *not* holding
> +	 * cred_guard_mutex to avoid possible dead-locks.
> +	 * The cred_guard_mutex is released *after* de_thread() has
> +	 * called zap_other_threads(), therefore a fatal signal is
> +	 * guaranteed to be already pending in the unlikely event, that
> +	 * current->signal->unsafe_execve_in_progress happens to be
> +	 * true after the cred_guard_mutex was acquired.
> +	 */
> +	bool unsafe_execve_in_progress;
> +
> +	/*
>  	 * Thread is the potential origin of an oom condition; kill first on
>  	 * oom
>  	 */
> @@ -227,6 +238,8 @@ struct signal_struct {
>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>  					 * credential calculations
>  					 * (notably. ptrace)
> +					 * Held while execve runs, except when
> +					 * a sibling thread is being traced.
>  					 * Deprecated do not use in new code.
>  					 * Use exec_update_lock instead.
>  					 */
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 61db50f..0cbc1eb 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -468,6 +468,14 @@ static int ptrace_traceme(void)
>  {
>  	int ret = -EPERM;
>  
> +	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
> +		return -ERESTARTNOINTR;
> +
> +	if (unlikely(current->signal->unsafe_execve_in_progress)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		return -ERESTARTNOINTR;
> +	}
> +
>  	write_lock_irq(&tasklist_lock);
>  	/* Are we already being traced? */
>  	if (!current->ptrace) {
> @@ -483,6 +491,7 @@ static int ptrace_traceme(void)
>  		}
>  	}
>  	write_unlock_irq(&tasklist_lock);
> +	mutex_unlock(&current->signal->cred_guard_mutex);
>  
>  	return ret;
>  }
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 1d60fc2..b1389ee 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1824,9 +1824,15 @@ static long seccomp_set_mode_filter(unsigned int flags,
>  	 * Make sure we cannot change seccomp or nnp state via TSYNC
>  	 * while another thread is in the middle of calling exec.
>  	 */
> -	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
> -	    mutex_lock_killable(&current->signal->cred_guard_mutex))
> -		goto out_put_fd;
> +	if (flags & SECCOMP_FILTER_FLAG_TSYNC) {
> +		if (mutex_lock_killable(&current->signal->cred_guard_mutex))
> +			goto out_put_fd;
> +
> +		if (unlikely(current->signal->unsafe_execve_in_progress)) {
> +			mutex_unlock(&current->signal->cred_guard_mutex);
> +			goto out_put_fd;
> +		}
> +	}
>  
>  	spin_lock_irq(&current->sighand->siglock);
>  
> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
> index 4db327b..c7c2242 100644
> --- a/tools/testing/selftests/ptrace/vmaccess.c
> +++ b/tools/testing/selftests/ptrace/vmaccess.c
> @@ -39,8 +39,15 @@ static void *thread(void *arg)
>  	f = open(mm, O_RDONLY);
>  	ASSERT_GE(f, 0);
>  	close(f);
> -	f = kill(pid, SIGCONT);
> -	ASSERT_EQ(f, 0);
> +	f = waitpid(-1, NULL, 0);
> +	ASSERT_NE(f, -1);
> +	ASSERT_NE(f, 0);
> +	ASSERT_NE(f, pid);
> +	f = waitpid(-1, NULL, 0);
> +	ASSERT_EQ(f, pid);
> +	f = waitpid(-1, NULL, 0);
> +	ASSERT_EQ(f, -1);
> +	ASSERT_EQ(errno, ECHILD);
>  }
>  
>  TEST(attach)
> @@ -57,22 +64,24 @@ static void *thread(void *arg)
>  
>  	sleep(1);
>  	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
> -	ASSERT_EQ(errno, EAGAIN);
> -	ASSERT_EQ(k, -1);
> +	ASSERT_EQ(k, 0);
>  	k = waitpid(-1, &s, WNOHANG);
>  	ASSERT_NE(k, -1);
>  	ASSERT_NE(k, 0);
>  	ASSERT_NE(k, pid);
>  	ASSERT_EQ(WIFEXITED(s), 1);
>  	ASSERT_EQ(WEXITSTATUS(s), 0);
> -	sleep(1);
> -	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
> -	ASSERT_EQ(k, 0);
>  	k = waitpid(-1, &s, 0);
>  	ASSERT_EQ(k, pid);
>  	ASSERT_EQ(WIFSTOPPED(s), 1);
>  	ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
> -	k = ptrace(PTRACE_DETACH, pid, 0L, 0L);
> +	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
> +	ASSERT_EQ(k, 0);
> +	k = waitpid(-1, &s, 0);
> +	ASSERT_EQ(k, pid);
> +	ASSERT_EQ(WIFSTOPPED(s), 1);
> +	ASSERT_EQ(WSTOPSIG(s), SIGTRAP);
> +	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
>  	ASSERT_EQ(k, 0);
>  	k = waitpid(-1, &s, 0);
>  	ASSERT_EQ(k, pid);
