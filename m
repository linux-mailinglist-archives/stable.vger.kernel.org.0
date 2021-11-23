Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1727F45ACF4
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 21:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbhKWUD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 15:03:59 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:59334 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhKWUD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 15:03:58 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:60186)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mpbyD-009Oqt-L8; Tue, 23 Nov 2021 13:00:49 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:50966 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mpbyB-005DFX-TX; Tue, 23 Nov 2021 13:00:49 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Backlund <tmb@iki.fi>, keescook@chromium.org,
        khuey@kylehuey.com, me@kylehuey.com, oliver.sang@intel.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
References: <163758427225348@kroah.com>
        <c83d6b54-d02f-c23b-d1cc-76c1993031d5@iki.fi>
        <YZ0vAK6QJJFP3jY5@kroah.com>
        <877dcyllom.fsf@email.froward.int.ebiederm.org>
Date:   Tue, 23 Nov 2021 14:00:41 -0600
In-Reply-To: <877dcyllom.fsf@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Tue, 23 Nov 2021 13:24:41 -0600")
Message-ID: <87k0gyk5g6.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mpbyB-005DFX-TX;;;mid=<87k0gyk5g6.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19CriM8bIwPJJwvYY2bOAFjrQgzxxZLJ8g=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.1 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,FVGT_m_MULTI_ODD,LotsOfNums_01,
        T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,T_TooManySym_02,T_TooManySym_03,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1082 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 9 (0.8%), b_tie_ro: 8 (0.7%), parse: 1.43 (0.1%),
        extract_message_metadata: 41 (3.7%), get_uri_detail_list: 7 (0.7%),
        tests_pri_-1000: 74 (6.8%), tests_pri_-950: 1.76 (0.2%),
        tests_pri_-900: 1.46 (0.1%), tests_pri_-90: 100 (9.2%), check_bayes:
        93 (8.6%), b_tokenize: 23 (2.1%), b_tok_get_all: 13 (1.2%),
        b_comp_prob: 6 (0.5%), b_tok_touch_all: 48 (4.4%), b_finish: 0.84
        (0.1%), tests_pri_0: 837 (77.4%), check_dkim_signature: 0.60 (0.1%),
        check_dkim_adsp: 2.2 (0.2%), poll_dns_idle: 0.60 (0.1%), tests_pri_10:
        2.3 (0.2%), tests_pri_500: 10 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for forced signals" failed to apply to 5.15-stable tree
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



ebiederm@xmission.com (Eric W. Biederman) writes:

> Greg KH <gregkh@linuxfoundation.org> writes:
>
>> On Tue, Nov 23, 2021 at 07:29:43PM +0200, Thomas Backlund wrote:
>>> Den 2021-11-22 kl. 14:31, skrev gregkh@linuxfoundation.org:
>>> > 
>>> > The patch below does not apply to the 5.15-stable tree.
>>> > If someone wants it applied there, or to any other stable or longterm
>>> > tree, then please email the backport, including the original git commit
>>> > id to <stable@vger.kernel.org>.
>>> > 
>>> > thanks,
>>> > 
>>> > greg k-h
>>> 
>>> 
>>> It will apply if you add this one first:
>>> 
>>> From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:59 -0500
>>> Subject: [PATCH] signal: Implement force_fatal_sig
>>> 
>>> 
>>> 
>>> 
>>> and if the other patch for signal that has similar description should land
>>> in 5.15:
>>> 
>>> From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Thu, 18 Nov 2021 14:23:21 -0600
>>> Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig when in
>>> doubt
>>> 
>>> 
>>> 
>>> then the list is looks something like:
>>> 
>>> 
>>> From 941edc5bf174b67f94db19817cbeab0a93e0c32a Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:44:00 -0500
>>> Subject: [PATCH] exit/syscall_user_dispatch: Send ordinary signals on
>>> failure
>>> 
>>> From 83a1f27ad773b1d8f0460d3a676114c7651918cc Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:53 -0500
>>> Subject: [PATCH] signal/powerpc: On swapcontext failure force SIGSEGV
>>> 
>>> From 9bc508cf0791c8e5a37696de1a046d746fcbd9d8 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:57 -0500
>>> Subject: [PATCH] signal/s390: Use force_sigsegv in default_trap_handler
>>> 
>>> From c317d306d55079525c9610267fdaf3a8a6d2f08b Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:44:01 -0500
>>> Subject: [PATCH] signal/sparc32: Exit with a fatal signal when
>>>  try_to_clear_window_buffer fails
>>> 
>>> From 086ec444f86660e103de8945d0dcae9b67132ac9 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:44:02 -0500
>>> Subject: [PATCH] signal/sparc32: In setup_rt_frame and setup_fram use
>>>  force_fatal_sig
>>> 
>>> From 1fbd60df8a852d9c55de8cd3621899cf4c72a5b7 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:56 -0500
>>> Subject: [PATCH] signal/vm86_32: Properly send SIGSEGV when the vm86 state
>>> cannot be saved.
>>> 
>>> From 695dd0d634df8903e5ead8aa08d326f63b23368a Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:44:03 -0500
>>> Subject: [PATCH] signal/x86: In emulate_vsyscall force a signal instead of
>>> calling do_exit
>>> 
>>> From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:59 -0500
>>> Subject: [PATCH] signal: Implement force_fatal_sig
>>> 
>>> From e21294a7aaae32c5d7154b187113a04db5852e37 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Mon, 25 Oct 2021 10:50:57 -0500
>>> Subject: [PATCH] signal: Replace force_sigsegv(SIGSEGV) with
>>>  force_fatal_sig(SIGSEGV)
>>> 
>>> From e349d945fac76bddc78ae1cb92a0145b427a87ce Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Thu, 18 Nov 2021 11:11:13 -0600
>>> Subject: [PATCH] signal: Don't always set SA_IMMUTABLE for forced signals
>>> 
>>> From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Thu, 18 Nov 2021 14:23:21 -0600
>>> Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig when in
>>> doubt
>>> 
>>> 
>>> 
>>> Applying them in listed order on top of 5.14.4 and builds/runs on i586,
>>> x86_64, armv7hl, aarch64
>>
>> That series list is crazy, let me go try it and see what blows up! :)
>
> Maybe I am wrong but I think "Don't always set SA_IMMUTABLE for forced
> signals" will apply if you drop the hunk modifying force_fatal_sig.
> Then you don't need to backport all of the cleanups just the fix.
>
> I will take a quick look and verify that.

Yes.  I have just verified that if I drop the hunk for force_fatal_sig
which does not exit in 5.15 the patch applies cleanly and compiles
cleanly as well.

If you want to apply the whole series I will be flattered that you want
all of my cleanups in stable.  There might be a point to it as intend to
keep cleaning things up, and code that is actually interesting to
backport might not backport if you don't backport all of my cleanups.

Personally I would say just apply a version without the force_fatal_sig
hunk and all should be well.

My patch with the force_fatal_sig hunk deleted after being applied to
v5.15.4 is below.

Eric

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 18 Nov 2021 11:11:13 -0600
Subject: [PATCH] signal: Don't always set SA_IMMUTABLE for forced signals

Recently to prevent issues with SECCOMP_RET_KILL and similar signals
being changed before they are delivered SA_IMMUTABLE was added.

Unfortunately this broke debuggers[1][2] which reasonably expect to be
able to trap synchronous SIGTRAP and SIGSEGV even when the target
process is not configured to handle those signals.

Update force_sig_to_task to support both the case when we can allow
the debugger to intercept and possibly ignore the signal and the case
when it is not safe to let userspace know about the signal until the
process has exited.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Kyle Huey <me@kylehuey.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: stable@vger.kernel.org
[1] https://lkml.kernel.org/r/CAP045AoMY4xf8aC_4QU_-j7obuEPYgTcnQQP3Yxk=2X90jtpjw@mail.gmail.com
[2] https://lkml.kernel.org/r/20211117150258.GB5403@xsang-OptiPlex-9020
Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed")
Link: https://lkml.kernel.org/r/877dd5qfw5.fsf_-_@email.froward.int.ebiederm.org
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Tested-by: Kyle Huey <khuey@kylehuey.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ef46309a9409..718bd2d2da7f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1298,6 +1298,12 @@ int do_send_sig_info(int sig, struct kernel_siginfo *info, struct task_struct *p
 	return ret;
 }
 
+enum sig_handler {
+	HANDLER_CURRENT, /* If reachable use the current handler */
+	HANDLER_SIG_DFL, /* Always use SIG_DFL handler semantics */
+	HANDLER_EXIT,	 /* Only visible as the process exit code */
+};
+
 /*
  * Force a signal that the process can't ignore: if necessary
  * we unblock the signal and change any SIG_IGN to SIG_DFL.
@@ -1310,7 +1316,8 @@ int do_send_sig_info(int sig, struct kernel_siginfo *info, struct task_struct *p
  * that is why we also clear SIGNAL_UNKILLABLE.
  */
 static int
-force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool sigdfl)
+force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
+	enum sig_handler handler)
 {
 	unsigned long int flags;
 	int ret, blocked, ignored;
@@ -1321,9 +1328,10 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool
 	action = &t->sighand->action[sig-1];
 	ignored = action->sa.sa_handler == SIG_IGN;
 	blocked = sigismember(&t->blocked, sig);
-	if (blocked || ignored || sigdfl) {
+	if (blocked || ignored || (handler != HANDLER_CURRENT)) {
 		action->sa.sa_handler = SIG_DFL;
-		action->sa.sa_flags |= SA_IMMUTABLE;
+		if (handler == HANDLER_EXIT)
+			action->sa.sa_flags |= SA_IMMUTABLE;
 		if (blocked) {
 			sigdelset(&t->blocked, sig);
 			recalc_sigpending_and_wake(t);
@@ -1343,7 +1351,7 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool
 
 int force_sig_info(struct kernel_siginfo *info)
 {
-	return force_sig_info_to_task(info, current, false);
+	return force_sig_info_to_task(info, current, HANDLER_CURRENT);
 }
 
 /*
@@ -1685,7 +1693,7 @@ int force_sig_fault_to_task(int sig, int code, void __user *addr
 	info.si_flags = flags;
 	info.si_isr = isr;
 #endif
-	return force_sig_info_to_task(&info, t, false);
+	return force_sig_info_to_task(&info, t, HANDLER_CURRENT);
 }
 
 int force_sig_fault(int sig, int code, void __user *addr
@@ -1805,7 +1813,8 @@ int force_sig_seccomp(int syscall, int reason, bool force_coredump)
 	info.si_errno = reason;
 	info.si_arch = syscall_get_arch(current);
 	info.si_syscall = syscall;
-	return force_sig_info_to_task(&info, current, force_coredump);
+	return force_sig_info_to_task(&info, current,
+		force_coredump ? HANDLER_EXIT : HANDLER_CURRENT);
 }
 
 /* For the crazy architectures that include trap information in
-- 
2.20.1
