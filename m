Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF404E99AA
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241096AbiC1Ods (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238819AbiC1Odr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:33:47 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BA35DE56;
        Mon, 28 Mar 2022 07:32:05 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:58838)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nYqPZ-00CgIB-4O; Mon, 28 Mar 2022 08:32:01 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:41442 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nYqPX-00FAVQ-Nz; Mon, 28 Mar 2022 08:32:00 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, luto@kernel.org, frederic@kernel.org,
        mark.rutland@arm.com, valentin.schneider@arm.com,
        keescook@chromium.org, elver@google.com, legion@kernel.org
References: <20220328111828.1554086-1-sashal@kernel.org>
        <20220328111828.1554086-29-sashal@kernel.org>
Date:   Mon, 28 Mar 2022 09:31:51 -0500
In-Reply-To: <20220328111828.1554086-29-sashal@kernel.org> (Sasha Levin's
        message of "Mon, 28 Mar 2022 07:18:13 -0400")
Message-ID: <87r16mw3l4.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nYqPX-00FAVQ-Nz;;;mid=<87r16mw3l4.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Jk8ZogsqtzpfadvzTlhsP3VG8lGSQEcI=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Sasha Levin <sashal@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 805 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 9 (1.1%), b_tie_ro: 8 (1.0%), parse: 1.68 (0.2%),
        extract_message_metadata: 29 (3.6%), get_uri_detail_list: 7 (0.8%),
        tests_pri_-1000: 30 (3.8%), tests_pri_-950: 1.86 (0.2%),
        tests_pri_-900: 1.50 (0.2%), tests_pri_-90: 154 (19.2%), check_bayes:
        152 (18.9%), b_tokenize: 27 (3.4%), b_tok_get_all: 17 (2.1%),
        b_comp_prob: 6 (0.8%), b_tok_touch_all: 96 (11.9%), b_finish: 1.01
        (0.1%), tests_pri_0: 562 (69.8%), check_dkim_signature: 0.59 (0.1%),
        check_dkim_adsp: 3.1 (0.4%), poll_dns_idle: 0.90 (0.1%), tests_pri_10:
        2.2 (0.3%), tests_pri_500: 8 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH AUTOSEL 5.17 29/43] signal, x86: Delay calling signals
 in atomic on RT enabled kernels
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Thank you for cc'ing me.  You probably want to hold off on back-porting
this patch.  The appropriate fix requires some more conversation.

At a mininum this patch should not be using TIF_NOTIFY_RESUME.

Eric



Sasha Levin <sashal@kernel.org> writes:

> From: Oleg Nesterov <oleg@redhat.com>
>
> [ Upstream commit bf9ad37dc8a30cce22ae95d6c2ca6abf8731d305 ]
>
> On x86_64 we must disable preemption before we enable interrupts
> for stack faults, int3 and debugging, because the current task is using
> a per CPU debug stack defined by the IST. If we schedule out, another task
> can come in and use the same stack and cause the stack to be corrupted
> and crash the kernel on return.
>
> When CONFIG_PREEMPT_RT is enabled, spinlock_t locks become sleeping, and
> one of these is the spin lock used in signal handling.
>
> Some of the debug code (int3) causes do_trap() to send a signal.
> This function calls a spinlock_t lock that has been converted to a
> sleeping lock. If this happens, the above issues with the corrupted
> stack is possible.
>
> Instead of calling the signal right away, for PREEMPT_RT and x86,
> the signal information is stored on the stacks task_struct and
> TIF_NOTIFY_RESUME is set. Then on exit of the trap, the signal resume
> code will send the signal when preemption is enabled.
>
> [ rostedt: Switched from #ifdef CONFIG_PREEMPT_RT to
>   ARCH_RT_DELAYS_SIGNAL_SEND and added comments to the code. ]
> [bigeasy: Add on 32bit as per Yang Shi, minor rewording. ]
> [ tglx: Use a config option ]
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lore.kernel.org/r/Ygq5aBB/qMQw6aP5@linutronix.de
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/Kconfig       |  1 +
>  include/linux/sched.h  |  3 +++
>  kernel/Kconfig.preempt | 12 +++++++++++-
>  kernel/entry/common.c  | 14 ++++++++++++++
>  kernel/signal.c        | 40 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 69 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 9f5bd41bf660..d557ac29b6cd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -120,6 +120,7 @@ config X86
>  	select ARCH_WANTS_NO_INSTR
>  	select ARCH_WANT_HUGE_PMD_SHARE
>  	select ARCH_WANT_LD_ORPHAN_WARN
> +	select ARCH_WANTS_RT_DELAYED_SIGNALS
>  	select ARCH_WANTS_THP_SWAP		if X86_64
>  	select ARCH_HAS_PARANOID_L1D_FLUSH
>  	select BUILDTIME_TABLE_SORT
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 75ba8aa60248..098e37fd770a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1087,6 +1087,9 @@ struct task_struct {
>  	/* Restored if set_restore_sigmask() was used: */
>  	sigset_t			saved_sigmask;
>  	struct sigpending		pending;
> +#ifdef CONFIG_RT_DELAYED_SIGNALS
> +	struct kernel_siginfo		forced_info;
> +#endif
>  	unsigned long			sas_ss_sp;
>  	size_t				sas_ss_size;
>  	unsigned int			sas_ss_flags;
> diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> index ce77f0265660..5644abd5f8a8 100644
> --- a/kernel/Kconfig.preempt
> +++ b/kernel/Kconfig.preempt
> @@ -132,4 +132,14 @@ config SCHED_CORE
>  	  which is the likely usage by Linux distributions, there should
>  	  be no measurable impact on performance.
>  
> -
> +config ARCH_WANTS_RT_DELAYED_SIGNALS
> +	bool
> +	help
> +	  This option is selected by architectures where raising signals
> +	  can happen in atomic contexts on PREEMPT_RT enabled kernels. This
> +	  option delays raising the signal until the return to user space
> +	  loop where it is also delivered. X86 requires this to deliver
> +	  signals from trap handlers which run on IST stacks.
> +
> +config RT_DELAYED_SIGNALS
> +	def_bool PREEMPT_RT && ARCH_WANTS_RT_DELAYED_SIGNALS
> diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> index bad713684c2e..0543a2c92f20 100644
> --- a/kernel/entry/common.c
> +++ b/kernel/entry/common.c
> @@ -148,6 +148,18 @@ static void handle_signal_work(struct pt_regs *regs, unsigned long ti_work)
>  	arch_do_signal_or_restart(regs, ti_work & _TIF_SIGPENDING);
>  }
>  
> +#ifdef CONFIG_RT_DELAYED_SIGNALS
> +static inline void raise_delayed_signal(void)
> +{
> +	if (unlikely(current->forced_info.si_signo)) {
> +		force_sig_info(&current->forced_info);
> +		current->forced_info.si_signo = 0;
> +	}
> +}
> +#else
> +static inline void raise_delayed_signal(void) { }
> +#endif
> +
>  static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
>  					    unsigned long ti_work)
>  {
> @@ -162,6 +174,8 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
>  		if (ti_work & _TIF_NEED_RESCHED)
>  			schedule();
>  
> +		raise_delayed_signal();
> +
>  		if (ti_work & _TIF_UPROBE)
>  			uprobe_notify_resume(regs);
>  
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 9b04631acde8..e93de6daa188 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1307,6 +1307,43 @@ enum sig_handler {
>  	HANDLER_EXIT,	 /* Only visible as the process exit code */
>  };
>  
> +/*
> + * On some archictectures, PREEMPT_RT has to delay sending a signal from a
> + * trap since it cannot enable preemption, and the signal code's
> + * spin_locks turn into mutexes. Instead, it must set TIF_NOTIFY_RESUME
> + * which will send the signal on exit of the trap.
> + */
> +#ifdef CONFIG_RT_DELAYED_SIGNALS
> +static inline bool force_sig_delayed(struct kernel_siginfo *info,
> +				     struct task_struct *t)
> +{
> +	if (!in_atomic())
> +		return false;
> +
> +	if (WARN_ON_ONCE(t->forced_info.si_signo))
> +		return true;
> +
> +	if (is_si_special(info)) {
> +		WARN_ON_ONCE(info != SEND_SIG_PRIV);
> +		t->forced_info.si_signo = info->si_signo;
> +		t->forced_info.si_errno = 0;
> +		t->forced_info.si_code = SI_KERNEL;
> +		t->forced_info.si_pid = 0;
> +		t->forced_info.si_uid = 0;
> +	} else {
> +		t->forced_info = *info;
> +	}
> +	set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
> +	return true;
> +}
> +#else
> +static inline bool force_sig_delayed(struct kernel_siginfo *info,
> +				     struct task_struct *t)
> +{
> +	return false;
> +}
> +#endif
> +
>  /*
>   * Force a signal that the process can't ignore: if necessary
>   * we unblock the signal and change any SIG_IGN to SIG_DFL.
> @@ -1327,6 +1364,9 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
>  	struct k_sigaction *action;
>  	int sig = info->si_signo;
>  
> +	if (force_sig_delayed(info, t))
> +		return 0;
> +
>  	spin_lock_irqsave(&t->sighand->siglock, flags);
>  	action = &t->sighand->action[sig-1];
>  	ignored = action->sa.sa_handler == SIG_IGN;
