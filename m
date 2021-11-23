Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33945AA1B
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 18:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhKWRc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 12:32:58 -0500
Received: from meesny.iki.fi ([195.140.195.201]:33868 "EHLO meesny.iki.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233491AbhKWRc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 12:32:58 -0500
Received: from [172.16.24.131] (73-55.dynamonet.fi [85.134.55.73])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: tmb@iki.fi)
        by meesny.iki.fi (Postfix) with ESMTPSA id 5F2022006A;
        Tue, 23 Nov 2021 19:29:44 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1637688584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2t98XDYERp7Yf0jPvOLKBXDZ3r+jBn7OEVeCLHGjBZg=;
        b=E1HkB57d+jxHUzeqEPIZEuK7OhOf33z3ZbQNo5yg470U4OVipPd2LJmp21JkwBnsg6K1cU
        BDRkwbWcV+pTbccoWYb1A8ycKKxK9jFDrjsPuAXeKVEx7hKG67Q4aU+2ziYtCSQM/TMc0F
        /cBqCfBqsKJa87Fq16Ohj+OoVLkTnOg=
Message-ID: <c83d6b54-d02f-c23b-d1cc-76c1993031d5@iki.fi>
Date:   Tue, 23 Nov 2021 19:29:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for
 forced signals" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, ebiederm@xmission.com,
        keescook@chromium.org, khuey@kylehuey.com, me@kylehuey.com,
        oliver.sang@intel.com, torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org
References: <163758427225348@kroah.com>
From:   Thomas Backlund <tmb@iki.fi>
In-Reply-To: <163758427225348@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=tmb@iki.fi smtp.mailfrom=tmb@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1637688584; a=rsa-sha256; cv=none;
        b=OX5QJOaH46oY3h1YEO6aOLNNl5r1+KLg4NOKUc4/t6irGGXU/n/oNzMgr+fOFVeNgeJwu6
        rsr0QCig9DfichhavAlawyt+hDsR84ZvoVVRabuE6UBv4wPd2wcFBM4lcrQQZDZPWr88Wo
        qqFRO0xVCYUBtFV6ke4nhfjnpWRIES0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1637688584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2t98XDYERp7Yf0jPvOLKBXDZ3r+jBn7OEVeCLHGjBZg=;
        b=bgg8fmwJS+EVwenQhuhiHcn7RBlz9KzL8oO/5IrhruWwasD31q/q8k29Os/SdadVajcVeq
        gPyiJvGRmiRwyKZUATmLLHyLeSR+vzjOmck03d+ekbzzcbcwtFKXHRh7edHPYTytw/8voC
        puQZgWh5qSYsVZHZLIjHgq8RUImcMGw=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 2021-11-22 kl. 14:31, skrev gregkh@linuxfoundation.org:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h


It will apply if you add this one first:

 From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 20 Oct 2021 12:43:59 -0500
Subject: [PATCH] signal: Implement force_fatal_sig




and if the other patch for signal that has similar description should 
land in 5.15:

 From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 18 Nov 2021 14:23:21 -0600
Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig 
when in  doubt



then the list is looks something like:


 From 941edc5bf174b67f94db19817cbeab0a93e0c32a Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 20 Oct 2021 12:44:00 -0500
Subject: [PATCH] exit/syscall_user_dispatch: Send ordinary signals on 
failure

 From 83a1f27ad773b1d8f0460d3a676114c7651918cc Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 20 Oct 2021 12:43:53 -0500
Subject: [PATCH] signal/powerpc: On swapcontext failure force SIGSEGV

 From 9bc508cf0791c8e5a37696de1a046d746fcbd9d8 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 20 Oct 2021 12:43:57 -0500
Subject: [PATCH] signal/s390: Use force_sigsegv in default_trap_handler

 From c317d306d55079525c9610267fdaf3a8a6d2f08b Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 20 Oct 2021 12:44:01 -0500
Subject: [PATCH] signal/sparc32: Exit with a fatal signal when
  try_to_clear_window_buffer fails

 From 086ec444f86660e103de8945d0dcae9b67132ac9 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 20 Oct 2021 12:44:02 -0500
Subject: [PATCH] signal/sparc32: In setup_rt_frame and setup_fram use
  force_fatal_sig

 From 1fbd60df8a852d9c55de8cd3621899cf4c72a5b7 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 20 Oct 2021 12:43:56 -0500
Subject: [PATCH] signal/vm86_32: Properly send SIGSEGV when the vm86 
state cannot be saved.

 From 695dd0d634df8903e5ead8aa08d326f63b23368a Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 20 Oct 2021 12:44:03 -0500
Subject: [PATCH] signal/x86: In emulate_vsyscall force a signal instead 
of calling do_exit

 From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 20 Oct 2021 12:43:59 -0500
Subject: [PATCH] signal: Implement force_fatal_sig

 From e21294a7aaae32c5d7154b187113a04db5852e37 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 25 Oct 2021 10:50:57 -0500
Subject: [PATCH] signal: Replace force_sigsegv(SIGSEGV) with
  force_fatal_sig(SIGSEGV)

 From e349d945fac76bddc78ae1cb92a0145b427a87ce Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 18 Nov 2021 11:11:13 -0600
Subject: [PATCH] signal: Don't always set SA_IMMUTABLE for forced signals

 From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 18 Nov 2021 14:23:21 -0600
Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig 
when in doubt



Applying them in listed order on top of 5.14.4 and builds/runs on i586, 
x86_64, armv7hl, aarch64

--
Thomas


> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From e349d945fac76bddc78ae1cb92a0145b427a87ce Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Thu, 18 Nov 2021 11:11:13 -0600
> Subject: [PATCH] signal: Don't always set SA_IMMUTABLE for forced signals
> 
> Recently to prevent issues with SECCOMP_RET_KILL and similar signals
> being changed before they are delivered SA_IMMUTABLE was added.
> 
> Unfortunately this broke debuggers[1][2] which reasonably expect to be
> able to trap synchronous SIGTRAP and SIGSEGV even when the target
> process is not configured to handle those signals.
> 
> Update force_sig_to_task to support both the case when we can allow
> the debugger to intercept and possibly ignore the signal and the case
> when it is not safe to let userspace know about the signal until the
> process has exited.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reported-by: Kyle Huey <me@kylehuey.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Cc: stable@vger.kernel.org
> [1] https://lkml.kernel.org/r/CAP045AoMY4xf8aC_4QU_-j7obuEPYgTcnQQP3Yxk=2X90jtpjw@mail.gmail.com
> [2] https://lkml.kernel.org/r/20211117150258.GB5403@xsang-OptiPlex-9020
> Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed")
> Link: https://lkml.kernel.org/r/877dd5qfw5.fsf_-_@email.froward.int.ebiederm.org
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Tested-by: Kees Cook <keescook@chromium.org>
> Tested-by: Kyle Huey <khuey@kylehuey.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 7c4b7ae714d4..7815e1bbeddc 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1298,6 +1298,12 @@ int do_send_sig_info(int sig, struct kernel_siginfo *info, struct task_struct *p
>   	return ret;
>   }
>   
> +enum sig_handler {
> +	HANDLER_CURRENT, /* If reachable use the current handler */
> +	HANDLER_SIG_DFL, /* Always use SIG_DFL handler semantics */
> +	HANDLER_EXIT,	 /* Only visible as the process exit code */
> +};
> +
>   /*
>    * Force a signal that the process can't ignore: if necessary
>    * we unblock the signal and change any SIG_IGN to SIG_DFL.
> @@ -1310,7 +1316,8 @@ int do_send_sig_info(int sig, struct kernel_siginfo *info, struct task_struct *p
>    * that is why we also clear SIGNAL_UNKILLABLE.
>    */
>   static int
> -force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool sigdfl)
> +force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
> +	enum sig_handler handler)
>   {
>   	unsigned long int flags;
>   	int ret, blocked, ignored;
> @@ -1321,9 +1328,10 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool
>   	action = &t->sighand->action[sig-1];
>   	ignored = action->sa.sa_handler == SIG_IGN;
>   	blocked = sigismember(&t->blocked, sig);
> -	if (blocked || ignored || sigdfl) {
> +	if (blocked || ignored || (handler != HANDLER_CURRENT)) {
>   		action->sa.sa_handler = SIG_DFL;
> -		action->sa.sa_flags |= SA_IMMUTABLE;
> +		if (handler == HANDLER_EXIT)
> +			action->sa.sa_flags |= SA_IMMUTABLE;
>   		if (blocked) {
>   			sigdelset(&t->blocked, sig);
>   			recalc_sigpending_and_wake(t);
> @@ -1343,7 +1351,7 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool
>   
>   int force_sig_info(struct kernel_siginfo *info)
>   {
> -	return force_sig_info_to_task(info, current, false);
> +	return force_sig_info_to_task(info, current, HANDLER_CURRENT);
>   }
>   
>   /*
> @@ -1660,7 +1668,7 @@ void force_fatal_sig(int sig)
>   	info.si_code = SI_KERNEL;
>   	info.si_pid = 0;
>   	info.si_uid = 0;
> -	force_sig_info_to_task(&info, current, true);
> +	force_sig_info_to_task(&info, current, HANDLER_SIG_DFL);
>   }
>   
>   /*
> @@ -1693,7 +1701,7 @@ int force_sig_fault_to_task(int sig, int code, void __user *addr
>   	info.si_flags = flags;
>   	info.si_isr = isr;
>   #endif
> -	return force_sig_info_to_task(&info, t, false);
> +	return force_sig_info_to_task(&info, t, HANDLER_CURRENT);
>   }
>   
>   int force_sig_fault(int sig, int code, void __user *addr
> @@ -1813,7 +1821,8 @@ int force_sig_seccomp(int syscall, int reason, bool force_coredump)
>   	info.si_errno = reason;
>   	info.si_arch = syscall_get_arch(current);
>   	info.si_syscall = syscall;
> -	return force_sig_info_to_task(&info, current, force_coredump);
> +	return force_sig_info_to_task(&info, current,
> +		force_coredump ? HANDLER_EXIT : HANDLER_CURRENT);
>   }
>   
>   /* For the crazy architectures that include trap information in
> 
> 

