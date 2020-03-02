Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF6A1753F0
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 07:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgCBGkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 01:40:35 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:36176 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCBGke (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 01:40:34 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j8ekd-0001Co-C0; Sun, 01 Mar 2020 23:40:27 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j8ekZ-0007Je-VK; Sun, 01 Mar 2020 23:40:26 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        Kees Cook <keescook@chromium.org>,
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
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com>
        <20200301185244.zkofjus6xtgkx4s3@wittgenstein>
        <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
        <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Mon, 02 Mar 2020 00:38:14 -0600
In-Reply-To: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Sun, 1 Mar 2020 20:34:16 +0000")
Message-ID: <87a74zmfc9.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j8ekZ-0007Je-VK;;;mid=<87a74zmfc9.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1//e7nTlsRN0fvWenFVh7U2fAMKCnUdZyE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_XMDrugObfuBody_00
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  1.0 T_XMDrugObfuBody_00 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2479 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 2.8 (0.1%), b_tie_ro: 1.94 (0.1%), parse: 1.11
        (0.0%), extract_message_metadata: 16 (0.6%), get_uri_detail_list: 5
        (0.2%), tests_pri_-1000: 14 (0.6%), tests_pri_-950: 1.01 (0.0%),
        tests_pri_-900: 0.84 (0.0%), tests_pri_-90: 53 (2.2%), check_bayes: 52
        (2.1%), b_tokenize: 21 (0.9%), b_tok_get_all: 18 (0.7%), b_comp_prob:
        3.6 (0.1%), b_tok_touch_all: 7 (0.3%), b_finish: 0.58 (0.0%),
        tests_pri_0: 671 (27.1%), check_dkim_signature: 0.55 (0.0%),
        check_dkim_adsp: 2.5 (0.1%), poll_dns_idle: 1706 (68.8%),
        tests_pri_10: 1.49 (0.1%), tests_pri_500: 1715 (69.1%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [PATCHv2] exec: Fix a deadlock in ptrace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
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

I think your patch works, but I don't think to solve your case another
mutex is necessary.  Possibly it is justified, but I hesitate to
introduce yet another concept in the code.

Having read elsewhere in the thread that this does not solve the problem
Oleg has mentioned I am really hesitant to add more complexity to the
situation.


For your case there is a straight forward and local workaround.

When the current task is ptracing the target task don't bother with
cred_gaurd_mutex and ptrace_may_access in access_mm as those tests
have already passed.  Instead just confirm the ptrace status. AKA
the permission check in ptraces_access_vm.

I think something like this is all we need.

diff --git a/kernel/fork.c b/kernel/fork.c
index cee89229606a..b0ab98c84589 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1224,6 +1224,16 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 	struct mm_struct *mm;
 	int err;
 
+	if (task->ptrace && (current == task->parent)) {
+		mm = get_task_mm(task);
+		if ((get_dumpable(mm) != SUID_DUMP_USER) &&
+		    !ptracer_capable(task, mm->user_ns)) {
+			mmput(mm);
+			mm = ERR_PTR(-EACCESS);
+		}
+		return mm;
+	}
+
 	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
 	if (err)
 		return ERR_PTR(err);

Does this solve your test case?

The patch above is short the approriate locking for the ptrace attached
check.  (tasklist_lock I think).  But is enough to illustrate the idea,
and it is probably a check we want in any event so that if the tracer
starts dropping privileges process_vm_readv and process_vm_writev will
still be usable by the tracer.

Eric


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
> The proposed solution is to have a second mutex that is
> used in mm_access, so it is allowed to continue while the
> dying threads are not yet terminated.
>
> I also took the opportunity to improve the documentation
> of prepare_creds, which is obviously out of sync.
>
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  Documentation/security/credentials.rst    | 18 ++++++------
>  fs/exec.c                                 |  9 ++++++
>  include/linux/binfmts.h                   |  6 +++-
>  include/linux/sched/signal.h              |  1 +
>  init/init_task.c                          |  1 +
>  kernel/cred.c                             |  2 +-
>  kernel/fork.c                             |  5 ++--
>  mm/process_vm_access.c                    |  2 +-
>  tools/testing/selftests/ptrace/Makefile   |  4 +--
>  tools/testing/selftests/ptrace/vmaccess.c | 46 +++++++++++++++++++++++++++++++
>  10 files changed, 79 insertions(+), 15 deletions(-)
>  create mode 100644 tools/testing/selftests/ptrace/vmaccess.c
>
> v2: adds a test case which passes when this patch is applied.
>
>
> diff --git a/Documentation/security/credentials.rst b/Documentation/security/credentials.rst
> index 282e79f..c98e0a8 100644
> --- a/Documentation/security/credentials.rst
> +++ b/Documentation/security/credentials.rst
> @@ -437,9 +437,13 @@ new set of credentials by calling::
>  
>  	struct cred *prepare_creds(void);
>  
> -this locks current->cred_replace_mutex and then allocates and constructs a
> -duplicate of the current process's credentials, returning with the mutex still
> -held if successful.  It returns NULL if not successful (out of memory).
> +this allocates and constructs a duplicate of the current process's credentials.
> +It returns NULL if not successful (out of memory).
> +
> +If called from __do_execve_file, the mutex current->signal->cred_guard_mutex
> +is acquired before this function gets called, and the mutex
> +current->signal->cred_change_mutex is acquired later, while the credentials
> +and the process mmap are actually changed.
>  
>  The mutex prevents ``ptrace()`` from altering the ptrace state of a process
>  while security checks on credentials construction and changing is taking place
> @@ -466,9 +470,8 @@ by calling::
>  
>  This will alter various aspects of the credentials and the process, giving the
>  LSM a chance to do likewise, then it will use ``rcu_assign_pointer()`` to
> -actually commit the new credentials to ``current->cred``, it will release
> -``current->cred_replace_mutex`` to allow ``ptrace()`` to take place, and it
> -will notify the scheduler and others of the changes.
> +actually commit the new credentials to ``current->cred``, and it will notify
> +the scheduler and others of the changes.
>  
>  This function is guaranteed to return 0, so that it can be tail-called at the
>  end of such functions as ``sys_setresuid()``.
> @@ -486,8 +489,7 @@ invoked::
>  
>  	void abort_creds(struct cred *new);
>  
> -This releases the lock on ``current->cred_replace_mutex`` that
> -``prepare_creds()`` got and then releases the new credentials.
> +This releases the new credentials.
>  
>  
>  A typical credentials alteration function would look something like this::
> diff --git a/fs/exec.c b/fs/exec.c
> index 74d88da..a6884e4 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1266,6 +1266,12 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	if (retval)
>  		goto out;
>  
> +	retval = mutex_lock_killable(&current->signal->cred_change_mutex);
> +	if (retval)
> +		goto out;
> +
> +	bprm->called_flush_old_exec = 1;
> +
>  	/*
>  	 * Must be called _before_ exec_mmap() as bprm->mm is
>  	 * not visibile until then. This also enables the update
> @@ -1420,6 +1426,8 @@ static void free_bprm(struct linux_binprm *bprm)
>  {
>  	free_arg_pages(bprm);
>  	if (bprm->cred) {
> +		if (bprm->called_flush_old_exec)
> +			mutex_unlock(&current->signal->cred_change_mutex);
>  		mutex_unlock(&current->signal->cred_guard_mutex);
>  		abort_creds(bprm->cred);
>  	}
> @@ -1469,6 +1477,7 @@ void install_exec_creds(struct linux_binprm *bprm)
>  	 * credentials; any time after this it may be unlocked.
>  	 */
>  	security_bprm_committed_creds(bprm);
> +	mutex_unlock(&current->signal->cred_change_mutex);
>  	mutex_unlock(&current->signal->cred_guard_mutex);
>  }
>  EXPORT_SYMBOL(install_exec_creds);
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index b40fc63..2e1318b 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -44,7 +44,11 @@ struct linux_binprm {
>  		 * exec has happened. Used to sanitize execution environment
>  		 * and to set AT_SECURE auxv for glibc.
>  		 */
> -		secureexec:1;
> +		secureexec:1,
> +		/*
> +		 * Set by flush_old_exec, when the cred_change_mutex is taken.
> +		 */
> +		called_flush_old_exec:1;
>  #ifdef __alpha__
>  	unsigned int taso:1;
>  #endif
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 8805025..37eeabe 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -225,6 +225,7 @@ struct signal_struct {
>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>  					 * credential calculations
>  					 * (notably. ptrace) */
> +	struct mutex cred_change_mutex; /* guard against credentials change */
>  } __randomize_layout;
>  
>  /*
> diff --git a/init/init_task.c b/init/init_task.c
> index 9e5cbe5..6cd9a0f 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -26,6 +26,7 @@
>  	.multiprocess	= HLIST_HEAD_INIT,
>  	.rlim		= INIT_RLIMITS,
>  	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
> +	.cred_change_mutex = __MUTEX_INITIALIZER(init_signals.cred_change_mutex),
>  #ifdef CONFIG_POSIX_TIMERS
>  	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
>  	.cputimer	= {
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 809a985..e4c78de 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -676,7 +676,7 @@ void __init cred_init(void)
>   *
>   * Returns the new credentials or NULL if out of memory.
>   *
> - * Does not take, and does not return holding current->cred_replace_mutex.
> + * Does not take, and does not return holding ->cred_guard_mutex.
>   */
>  struct cred *prepare_kernel_cred(struct task_struct *daemon)
>  {
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 0808095..0395154 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1224,7 +1224,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  	struct mm_struct *mm;
>  	int err;
>  
> -	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
> +	err =  mutex_lock_killable(&task->signal->cred_change_mutex);
>  	if (err)
>  		return ERR_PTR(err);
>  
> @@ -1234,7 +1234,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  		mmput(mm);
>  		mm = ERR_PTR(-EACCES);
>  	}
> -	mutex_unlock(&task->signal->cred_guard_mutex);
> +	mutex_unlock(&task->signal->cred_change_mutex);
>  
>  	return mm;
>  }
> @@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
>  
>  	mutex_init(&sig->cred_guard_mutex);
> +	mutex_init(&sig->cred_change_mutex);
>  
>  	return 0;
>  }
> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> index 357aa7b..b3e6eb5 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -204,7 +204,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
>  	if (!mm || IS_ERR(mm)) {
>  		rc = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
>  		/*
> -		 * Explicitly map EACCES to EPERM as EPERM is a more a
> +		 * Explicitly map EACCES to EPERM as EPERM is a more
>  		 * appropriate error code for process_vw_readv/writev
>  		 */
>  		if (rc == -EACCES)
> diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
> index c0b7f89..2f1f532 100644
> --- a/tools/testing/selftests/ptrace/Makefile
> +++ b/tools/testing/selftests/ptrace/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -CFLAGS += -iquote../../../../include/uapi -Wall
> +CFLAGS += -std=c99 -pthread -iquote../../../../include/uapi -Wall
>  
> -TEST_GEN_PROGS := get_syscall_info peeksiginfo
> +TEST_GEN_PROGS := get_syscall_info peeksiginfo vmaccess
>  
>  include ../lib.mk
> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
> new file mode 100644
> index 0000000..ef08c9f
> --- /dev/null
> +++ b/tools/testing/selftests/ptrace/vmaccess.c
> @@ -0,0 +1,46 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
> + * All rights reserved.
> + *
> + * Check whether /proc/$pid/mem can be accessed without causing deadlocks
> + * when de_thread is blocked with ->cred_guard_mutex held.
> + */
> +
> +#include "../kselftest_harness.h"
> +#include <stdio.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <signal.h>
> +#include <unistd.h>
> +#include <sys/ptrace.h>
> +
> +static void *thread(void *arg)
> +{
> +	ptrace(PTRACE_TRACEME, 0, 0, 0);
> +	return NULL;
> +}
> +
> +TEST(vmaccess)
> +{
> +	int f, pid = fork();
> +	char mm[64];
> +
> +	if (!pid) {
> +		pthread_t pt;
> +		pthread_create(&pt, NULL, thread, NULL);
> +		pthread_join(pt, NULL);
> +		execlp("true", "true", NULL);
> +	}
> +
> +	sleep(1);
> +	sprintf(mm, "/proc/%d/mem", pid);
> +	f = open(mm, O_RDONLY);
> +	ASSERT_LE(0, f)
> +		close(f);
> +	/* this is not fixed! ptrace(PTRACE_ATTACH, pid, 0,0); */
> +	f = kill(pid, SIGCONT);
> +	ASSERT_EQ(0, f);
> +}
> +
> +TEST_HARNESS_MAIN
