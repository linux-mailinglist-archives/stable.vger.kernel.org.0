Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D695A1766AF
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 23:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgCBWSt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 2 Mar 2020 17:18:49 -0500
Received: from mail-vi1eur05olkn2034.outbound.protection.outlook.com ([40.92.90.34]:64813
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgCBWSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 17:18:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kafhfOSsdgKu3zvubekbW0+1VpQyMLD565vx3XZcKbdCZ+HQxezj07holweHNRJeX606XzqUn+pMKyLEn9x7/W+Ec5W5EEZPqMVEysjGvyDYH2BjXWdpUSq/Un+UaoLCf7kjDBAScWLpT5/mQ84lu8um505h8Rjpd0oLZxPVqct86mw+jgHIbltA3+7ApmfbV77hLtjg1flLtlHSLmwQ6GRmpzuqP6Q2tGWSWXv450FrAY7x9FLTbd1JKpuMfsVRLMwVBpOSXhzB2t8U72MB3mKFaBSsda8Pjco99GwFKlayuCNT9NmzUdlMW/EU+DmFZPY1soTxZvMctipwv+M5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPGPNV0NplC0sdLL1DG0J0WyYVy8opNG6J3790oTzVw=;
 b=R7RcD1ywoV4P6joDwrW5T1F6WPAONcv0gj2ZEIpJO3R/yDejOPkyinglb5NprrvcMMJt+5SoPg7cWYqip5zrgBpHy44/7BH7aKJa3PCuGVY3m09ErwzSoLQ3nbgyNyWBkW6PSx0HFCGDUBo2RtJsqNzWVBNh4HMxpv07koM7PwaWVw1K3Rm9yyiACtfGTsaKaTs/ymskXz13d/xd7J37jWScZpNC9+Wh6FTlXqB2oRw6wHWX0eU/IKcBJRNVcPXs0HE9JPptwgbj3QW5DFdQUBPQqz+A9Mh/6uTnxFVUPNHq1Hby8a3h8MUiwbv+h63fMB3J8Ahj71ZgyC1siUXIJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from AM6EUR05FT059.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc11::3c) by
 AM6EUR05HT198.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc11::210)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Mon, 2 Mar
 2020 22:18:07 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.240.56) by
 AM6EUR05FT059.mail.protection.outlook.com (10.233.240.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14 via Frontend Transport; Mon, 2 Mar 2020 22:18:07 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 22:18:07 +0000
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0025.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 22:18:05 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Jann Horn <jannh@google.com>,
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
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCHv4] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv4] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8OBzc5kV6gCKfE+vkD4wYYEirg==
Date:   Mon, 2 Mar 2020 22:18:07 +0000
Message-ID: <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com>
 <20200301185244.zkofjus6xtgkx4s3@wittgenstein>
 <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
 <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
In-Reply-To: <87v9nmjulm.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::12) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:12CEE1B87C856B62439EF5A28642166689670B810577E7A283DAA2C6D139DD29;UpperCasedChecksum:C4A26F2C2A8A8F9622BA9C9FA761B47DE38E1591CAD8D0CF0B88C0E549B27E2B;SizeAsReceived:9559;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [CflebvNg2lr6RreJyU4EIUTxNtbqS86t]
x-microsoft-original-message-id: <18391133-2776-9afb-475e-5d829f43ca32@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 0d2da655-4fe4-45bf-6ec0-08d7bef7955f
x-ms-traffictypediagnostic: AM6EUR05HT198:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N1FgK9L2EJgzr7v8qkfW+IOxJnG3F+o+rEsTE7FIRNopZaJ7VgfBn6ufCCnO8Kkc8/lLvVweAX4OxmKOEW2bvb40M/kSRzGhZ5g1XLT66h2O67yubVas3vQH3Xb0uy3iB+faI64QmhHOPbICsNkc8Kct6/s4mejzcBKCDJJso7WLWCqL/j5rF3RcwPH6/E/3
x-ms-exchange-antispam-messagedata: roLk8dFxLtdNZzLal9MMD2G7VO6oBNufOYOtMU5y/v87nfcB/GcUTO+Lpn95n5r5B6s7RZ9tdCYrbiK72xZB+myJayA2IYm2pTWDg2KnTP+pHbCa5rsNsXmx9K+lHv6AYmT92MSzUYiGWcc6i0HMrQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <CDF412EB78824B49A82BA44DD14F5AC7@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2da655-4fe4-45bf-6ec0-08d7bef7955f
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 22:18:07.4360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6EUR05HT198
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a deadlock in the tracer when tracing a multi-threaded
application that calls execve while more than one thread are running.

I observed that when running strace on the gcc test suite, it always
blocks after a while, when expect calls execve, because other threads
have to be terminated.  They send ptrace events, but the strace is no
longer able to respond, since it is blocked in vm_access.

The deadlock is always happening when strace needs to access the
tracees process mmap, while another thread in the tracee starts to
execve a child process, but that cannot continue until the
PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:

strace          D    0 30614  30584 0x00000000
Call Trace:
__schedule+0x3ce/0x6e0
schedule+0x5c/0xd0
schedule_preempt_disabled+0x15/0x20
__mutex_lock.isra.13+0x1ec/0x520
__mutex_lock_killable_slowpath+0x13/0x20
mutex_lock_killable+0x28/0x30
mm_access+0x27/0xa0
process_vm_rw_core.isra.3+0xff/0x550
process_vm_rw+0xdd/0xf0
__x64_sys_process_vm_readv+0x31/0x40
do_syscall_64+0x64/0x220
entry_SYSCALL_64_after_hwframe+0x44/0xa9

expect          D    0 31933  30876 0x80004003
Call Trace:
__schedule+0x3ce/0x6e0
schedule+0x5c/0xd0
flush_old_exec+0xc4/0x770
load_elf_binary+0x35a/0x16c0
search_binary_handler+0x97/0x1d0
__do_execve_file.isra.40+0x5d4/0x8a0
__x64_sys_execve+0x49/0x60
do_syscall_64+0x64/0x220
entry_SYSCALL_64_after_hwframe+0x44/0xa9

The proposed solution is to take the cred_guard_mutex only
in a critical section at the beginning, and at the end of the
execve function, and let PTRACE_ATTACH fail with EAGAIN while
execve is not complete, but other functions like vm_access are
allowed to complete normally.

I also took the opportunity to improve the documentation
of prepare_creds, which is obviously out of sync.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 Documentation/security/credentials.rst    | 19 +++++----
 fs/exec.c                                 | 28 +++++++++++--
 include/linux/binfmts.h                   |  6 ++-
 include/linux/sched/signal.h              |  1 +
 init/init_task.c                          |  1 +
 kernel/cred.c                             |  2 +-
 kernel/fork.c                             |  1 +
 kernel/ptrace.c                           |  4 ++
 mm/process_vm_access.c                    |  2 +-
 tools/testing/selftests/ptrace/Makefile   |  4 +-
 tools/testing/selftests/ptrace/vmaccess.c | 66 +++++++++++++++++++++++++++++++
 11 files changed, 117 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/ptrace/vmaccess.c

v2: adds a test case which passes when this patch is applied.
v3: fixes the issue without introducing a new mutex.
v4: fixes one comment and a formatting issue found by checkpatch.pl in the test case. 

diff --git a/Documentation/security/credentials.rst b/Documentation/security/credentials.rst
index 282e79f..61d6704 100644
--- a/Documentation/security/credentials.rst
+++ b/Documentation/security/credentials.rst
@@ -437,9 +437,14 @@ new set of credentials by calling::
 
 	struct cred *prepare_creds(void);
 
-this locks current->cred_replace_mutex and then allocates and constructs a
-duplicate of the current process's credentials, returning with the mutex still
-held if successful.  It returns NULL if not successful (out of memory).
+this allocates and constructs a duplicate of the current process's credentials.
+It returns NULL if not successful (out of memory).
+
+If called from __do_execve_file, the mutex current->signal->cred_guard_mutex
+is acquired before this function gets called, and released after setting
+current->signal->cred_locked_for_ptrace.  The same mutex is acquired later,
+while the credentials and the process mmap are actually changed, and
+current->signal->cred_locked_for_ptrace is reset again.
 
 The mutex prevents ``ptrace()`` from altering the ptrace state of a process
 while security checks on credentials construction and changing is taking place
@@ -466,9 +471,8 @@ by calling::
 
 This will alter various aspects of the credentials and the process, giving the
 LSM a chance to do likewise, then it will use ``rcu_assign_pointer()`` to
-actually commit the new credentials to ``current->cred``, it will release
-``current->cred_replace_mutex`` to allow ``ptrace()`` to take place, and it
-will notify the scheduler and others of the changes.
+actually commit the new credentials to ``current->cred``, and it will notify
+the scheduler and others of the changes.
 
 This function is guaranteed to return 0, so that it can be tail-called at the
 end of such functions as ``sys_setresuid()``.
@@ -486,8 +490,7 @@ invoked::
 
 	void abort_creds(struct cred *new);
 
-This releases the lock on ``current->cred_replace_mutex`` that
-``prepare_creds()`` got and then releases the new credentials.
+This releases the new credentials.
 
 
 A typical credentials alteration function would look something like this::
diff --git a/fs/exec.c b/fs/exec.c
index 74d88da..e466301 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1266,6 +1266,12 @@ int flush_old_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out;
 
+	retval = mutex_lock_killable(&current->signal->cred_guard_mutex);
+	if (retval)
+		goto out;
+
+	bprm->called_flush_old_exec = 1;
+
 	/*
 	 * Must be called _before_ exec_mmap() as bprm->mm is
 	 * not visibile until then. This also enables the update
@@ -1398,28 +1404,41 @@ void finalize_exec(struct linux_binprm *bprm)
 EXPORT_SYMBOL(finalize_exec);
 
 /*
- * Prepare credentials and lock ->cred_guard_mutex.
+ * Prepare credentials and set ->cred_locked_for_ptrace.
  * install_exec_creds() commits the new creds and drops the lock.
  * Or, if exec fails before, free_bprm() should release ->cred and
  * and unlock.
  */
 static int prepare_bprm_creds(struct linux_binprm *bprm)
 {
+	int ret;
+
 	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
 		return -ERESTARTNOINTR;
 
+	ret = -EAGAIN;
+	if (unlikely(current->signal->cred_locked_for_ptrace))
+		goto out;
+
+	ret = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
-	if (likely(bprm->cred))
-		return 0;
+	if (likely(bprm->cred)) {
+		current->signal->cred_locked_for_ptrace = true;
+		ret = 0;
+	}
 
+out:
 	mutex_unlock(&current->signal->cred_guard_mutex);
-	return -ENOMEM;
+	return ret;
 }
 
 static void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
+		if (!bprm->called_flush_old_exec)
+			mutex_lock(&current->signal->cred_guard_mutex);
+		current->signal->cred_locked_for_ptrace = false;
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
@@ -1469,6 +1488,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	 * credentials; any time after this it may be unlocked.
 	 */
 	security_bprm_committed_creds(bprm);
+	current->signal->cred_locked_for_ptrace = false;
 	mutex_unlock(&current->signal->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b40fc63..2930253 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -44,7 +44,11 @@ struct linux_binprm {
 		 * exec has happened. Used to sanitize execution environment
 		 * and to set AT_SECURE auxv for glibc.
 		 */
-		secureexec:1;
+		secureexec:1,
+		/*
+		 * Set by flush_old_exec, when the cred_guard_mutex is taken.
+		 */
+		called_flush_old_exec:1;
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 8805025..073a2b7 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -225,6 +225,7 @@ struct signal_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace) */
+	bool cred_locked_for_ptrace;	/* set while in execve */
 } __randomize_layout;
 
 /*
diff --git a/init/init_task.c b/init/init_task.c
index 9e5cbe5..ecefff28 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -26,6 +26,7 @@
 	.multiprocess	= HLIST_HEAD_INIT,
 	.rlim		= INIT_RLIMITS,
 	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
+	.cred_locked_for_ptrace = false,
 #ifdef CONFIG_POSIX_TIMERS
 	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
 	.cputimer	= {
diff --git a/kernel/cred.c b/kernel/cred.c
index 809a985..e4c78de 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -676,7 +676,7 @@ void __init cred_init(void)
  *
  * Returns the new credentials or NULL if out of memory.
  *
- * Does not take, and does not return holding current->cred_replace_mutex.
+ * Does not take, and does not return holding ->cred_guard_mutex.
  */
 struct cred *prepare_kernel_cred(struct task_struct *daemon)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 0808095..a2b2ec8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
 	mutex_init(&sig->cred_guard_mutex);
+	sig->cred_locked_for_ptrace = false;
 
 	return 0;
 }
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 43d6179..abf09ba 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -395,6 +395,10 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (mutex_lock_interruptible(&task->signal->cred_guard_mutex))
 		goto out;
 
+	retval = -EAGAIN;
+	if (task->signal->cred_locked_for_ptrace)
+		goto unlock_creds;
+
 	task_lock(task);
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS);
 	task_unlock(task);
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 357aa7b..b3e6eb5 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -204,7 +204,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	if (!mm || IS_ERR(mm)) {
 		rc = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
 		/*
-		 * Explicitly map EACCES to EPERM as EPERM is a more a
+		 * Explicitly map EACCES to EPERM as EPERM is a more
 		 * appropriate error code for process_vw_readv/writev
 		 */
 		if (rc == -EACCES)
diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
index c0b7f89..2f1f532 100644
--- a/tools/testing/selftests/ptrace/Makefile
+++ b/tools/testing/selftests/ptrace/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -iquote../../../../include/uapi -Wall
+CFLAGS += -std=c99 -pthread -iquote../../../../include/uapi -Wall
 
-TEST_GEN_PROGS := get_syscall_info peeksiginfo
+TEST_GEN_PROGS := get_syscall_info peeksiginfo vmaccess
 
 include ../lib.mk
diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
new file mode 100644
index 0000000..6d8a048
--- /dev/null
+++ b/tools/testing/selftests/ptrace/vmaccess.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
+ * All rights reserved.
+ *
+ * Check whether /proc/$pid/mem can be accessed without causing deadlocks
+ * when de_thread is blocked with ->cred_guard_mutex held.
+ */
+
+#include "../kselftest_harness.h"
+#include <stdio.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <signal.h>
+#include <unistd.h>
+#include <sys/ptrace.h>
+
+static void *thread(void *arg)
+{
+	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
+	return NULL;
+}
+
+TEST(vmaccess)
+{
+	int f, pid = fork();
+	char mm[64];
+
+	if (!pid) {
+		pthread_t pt;
+
+		pthread_create(&pt, NULL, thread, NULL);
+		pthread_join(pt, NULL);
+		execlp("true", "true", NULL);
+	}
+
+	sleep(1);
+	sprintf(mm, "/proc/%d/mem", pid);
+	f = open(mm, O_RDONLY);
+	ASSERT_LE(0, f);
+	close(f);
+	f = kill(pid, SIGCONT);
+	ASSERT_EQ(0, f);
+}
+
+TEST(attach)
+{
+	int f, pid = fork();
+
+	if (!pid) {
+		pthread_t pt;
+
+		pthread_create(&pt, NULL, thread, NULL);
+		pthread_join(pt, NULL);
+		execlp("true", "true", NULL);
+	}
+
+	sleep(1);
+	f = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
+	ASSERT_EQ(EAGAIN, errno);
+	ASSERT_EQ(f, -1);
+	f = kill(pid, SIGCONT);
+	ASSERT_EQ(0, f);
+}
+
+TEST_HARNESS_MAIN
-- 
1.9.1
