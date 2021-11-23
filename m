Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B618E45A63C
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 16:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhKWPMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 10:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhKWPMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 10:12:01 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751F3C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 07:08:53 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id w1so93628024edc.6
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 07:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fjeja1GHOWpLU5mRJJ8SSibPhGHV/hkGR0W58uPmaoo=;
        b=dRTSWAaKTXMBiQ/NA3IUzkkzApTWiw+TajB5lXn/djtHeoUhR3M0r9CNo3dUY+sYCL
         ex0IZ/ZE3e9RB08Gf4h4rYrUHnQVyLPrwjvrbtWc4aFwfCyF9YxxILf7DvnDqkIHaELm
         5MTGR4CChN9GxeS+rSrRK86wYKIKSzJ12JzfR7UvpEoygWGgF+gtEdzhQGtaA4H1G7dt
         g1Gi4Q9nzcfFsm3YUKc2j9ViygdqQbWXJyzJ+6tfyxqZeh6RGxbV0ggqY1fN+1fFf9vS
         zy2DZQ1syZ1eU4XwqMKHhyk1D/I9K25WVt8yK+TjWPF6DNaeopuN6DV+B8w33+71zbb3
         fvPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fjeja1GHOWpLU5mRJJ8SSibPhGHV/hkGR0W58uPmaoo=;
        b=X0C/ksNb1LMQrs2x2sICcUrWVimH2oyFEfIUYq60nekL6arvYPD9y3mZNT+GHrXkEF
         Ku3wSCYQ9fnEbHR9zg1jSn3FNOdMVioXiED1uP2D9fw/FU1MUV1uQAO+InCRvduPvTRU
         qgNpGADxq7Uhj+DuCTpdqdvPFuRULCt/Xl/2xpdnS+b9YPKR5VEKkpVJq+FrDF+B7XHy
         GyO2zwG8l9I+T7rsuAhHRIRwmEolMpNKA9fnfaP2N0adNAP2q7R2a/MRwXWIpRyw9OkW
         xpcTOafQ1BEWIuTyb6ztLlLx3m1oYlGoYwzli3Ir8Cwq/Gq5a88SEVRRoYc08OvIKjrG
         KphQ==
X-Gm-Message-State: AOAM5308hdzGBCFZWNWJRSvOu0h2TS8labZLgo8guGFgOCl2rr7L/t87
        ZWwabsW1GY7N4for4TD3N+4zeLGbB+Dmg/eg+w4OOw==
X-Google-Smtp-Source: ABdhPJxp+ZjX1YTGesWYRUDBlccp/oD9LRlkERtmfEDXcoLK54bzcPcG9ryPbrQvltJD05PgBakEBStZm4y4CP7ssDU=
X-Received: by 2002:a17:906:4791:: with SMTP id cw17mr8499843ejc.493.1637680131980;
 Tue, 23 Nov 2021 07:08:51 -0800 (PST)
MIME-Version: 1.0
References: <163758427225348@kroah.com>
In-Reply-To: <163758427225348@kroah.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Tue, 23 Nov 2021 07:08:37 -0800
Message-ID: <CAP045Aq=_yLec0t2mGGrwBy=rJfJm7zB3YHOZSL7pzQYqvVgKA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for
 forced signals" failed to apply to 5.15-stable tree
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Kees Cook <keescook@chromium.org>, Kyle Huey <khuey@kylehuey.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org, "Robert O'Callahan" <rocallahan@gmail.com>,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric, are you going to take care of this?

- Kyle

On Mon, Nov 22, 2021 at 4:31 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From e349d945fac76bddc78ae1cb92a0145b427a87ce Mon Sep 17 00:00:00 2001
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
>         return ret;
>  }
>
> +enum sig_handler {
> +       HANDLER_CURRENT, /* If reachable use the current handler */
> +       HANDLER_SIG_DFL, /* Always use SIG_DFL handler semantics */
> +       HANDLER_EXIT,    /* Only visible as the process exit code */
> +};
> +
>  /*
>   * Force a signal that the process can't ignore: if necessary
>   * we unblock the signal and change any SIG_IGN to SIG_DFL.
> @@ -1310,7 +1316,8 @@ int do_send_sig_info(int sig, struct kernel_siginfo *info, struct task_struct *p
>   * that is why we also clear SIGNAL_UNKILLABLE.
>   */
>  static int
> -force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool sigdfl)
> +force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
> +       enum sig_handler handler)
>  {
>         unsigned long int flags;
>         int ret, blocked, ignored;
> @@ -1321,9 +1328,10 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool
>         action = &t->sighand->action[sig-1];
>         ignored = action->sa.sa_handler == SIG_IGN;
>         blocked = sigismember(&t->blocked, sig);
> -       if (blocked || ignored || sigdfl) {
> +       if (blocked || ignored || (handler != HANDLER_CURRENT)) {
>                 action->sa.sa_handler = SIG_DFL;
> -               action->sa.sa_flags |= SA_IMMUTABLE;
> +               if (handler == HANDLER_EXIT)
> +                       action->sa.sa_flags |= SA_IMMUTABLE;
>                 if (blocked) {
>                         sigdelset(&t->blocked, sig);
>                         recalc_sigpending_and_wake(t);
> @@ -1343,7 +1351,7 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t, bool
>
>  int force_sig_info(struct kernel_siginfo *info)
>  {
> -       return force_sig_info_to_task(info, current, false);
> +       return force_sig_info_to_task(info, current, HANDLER_CURRENT);
>  }
>
>  /*
> @@ -1660,7 +1668,7 @@ void force_fatal_sig(int sig)
>         info.si_code = SI_KERNEL;
>         info.si_pid = 0;
>         info.si_uid = 0;
> -       force_sig_info_to_task(&info, current, true);
> +       force_sig_info_to_task(&info, current, HANDLER_SIG_DFL);
>  }
>
>  /*
> @@ -1693,7 +1701,7 @@ int force_sig_fault_to_task(int sig, int code, void __user *addr
>         info.si_flags = flags;
>         info.si_isr = isr;
>  #endif
> -       return force_sig_info_to_task(&info, t, false);
> +       return force_sig_info_to_task(&info, t, HANDLER_CURRENT);
>  }
>
>  int force_sig_fault(int sig, int code, void __user *addr
> @@ -1813,7 +1821,8 @@ int force_sig_seccomp(int syscall, int reason, bool force_coredump)
>         info.si_errno = reason;
>         info.si_arch = syscall_get_arch(current);
>         info.si_syscall = syscall;
> -       return force_sig_info_to_task(&info, current, force_coredump);
> +       return force_sig_info_to_task(&info, current,
> +               force_coredump ? HANDLER_EXIT : HANDLER_CURRENT);
>  }
>
>  /* For the crazy architectures that include trap information in
>
