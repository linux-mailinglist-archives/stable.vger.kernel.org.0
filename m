Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFF126770
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 17:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbfEVPzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 11:55:16 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45607 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfEVPzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 11:55:16 -0400
Received: by mail-io1-f68.google.com with SMTP id b3so2234454iob.12;
        Wed, 22 May 2019 08:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kb3WM7gPCIFW1UnQ0vFC/8eKfBUUYf+CYSf6YWVRBUk=;
        b=OxmUNETVTX2kM2b2am7Wt0QjqrpQ0WmM8pWApCtT1YJU0bKg/XUlMXMTV/JofMuoca
         BYrVh/6/P9sf1sQM+fQ6aFifVXzK8kqMbKmx1Gz90nojXGrKzQJ0/CAxQI/TJZcfjSEA
         Ug71MQ7dp0MUa6QZoapD4LK0lFEPTMRIejCOFm+H6wwkc9+SzBWNWNjzIctNudoZJRpR
         KefPOz4SMD874EddtAQh6k3LqmHP3h7NYkqwDcOclqdP+PhRj2XLbICn8JhyYvLjYZ92
         /kszDY9J8kE3jNsj8chBbQUoAEmfhZDvfU9rC2l/Zae6j9A0TzD5MHWJPXAiMuTB3LDG
         cDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kb3WM7gPCIFW1UnQ0vFC/8eKfBUUYf+CYSf6YWVRBUk=;
        b=WMeVf/xaHnMMgqts3LTO6tkzckRzodkVYs3VlsDNfzhlLKJ1HZ3T9goHlGRCjws8ye
         LECz4e5RknD8MLaLZtUP+zKRInEDbHJ0tcrJlN61tunFs7hItXfhYePtzBKGB+LfvhuK
         uXoNxhOpgKNL+A6xqLwRgHwZmSArdoOJlLi3qjN05DkaidHSH+PddEUQ35DtwgzGJnU/
         o1fsXIc1RtcBTfsPO4acm8Lm39mXNR13O2LAI1FGE2RhrjcdUtLvfeq+gSzhicIQuGH4
         ZopPdJQ4EdOQQJ0YPJaB5xMpy9+p41+za9Ud/CEKe2g75o71XV+RPCLg+m63awCwmGIz
         HHHg==
X-Gm-Message-State: APjAAAVhyKShl7tvlm/oVpPgiSDWBSmSTd59V0MrsG3t1GEJ40i7x/Nu
        awckedibnDvejZi3aQRI2KZHx9QdLpTdQrv0JxU=
X-Google-Smtp-Source: APXvYqz2u66DeVSCxgF0xIHaau9v4jAaesv4EGAF3nfS+zCIyKX2S86Vb9+yfpsBKCqrK3GzdTXTKxGwAodLTwQHfmQ=
X-Received: by 2002:a5e:840c:: with SMTP id h12mr8740557ioj.81.1558540515228;
 Wed, 22 May 2019 08:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com> <20190522150505.GA4915@redhat.com>
In-Reply-To: <20190522150505.GA4915@redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Wed, 22 May 2019 08:55:02 -0700
Message-ID: <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
Subject: Re: [PATCH v2] signal: Adjust error codes according to restore_user_sigmask()
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, dbueso@suse.de, axboe@kernel.dk,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-Deepa

> On May 22, 2019, at 8:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
>> On 05/21, Deepa Dinamani wrote:
>>
>> Note that this patch returns interrupted errors (EINTR, ERESTARTNOHAND,
>> etc) only when there is no other error. If there is a signal and an error
>> like EINVAL, the syscalls return -EINVAL rather than the interrupted
>> error codes.
>
> Ugh. I need to re-check, but at first glance I really dislike this change.
>
> I think we can fix the problem _and_ simplify the code. Something like below.
> The patch is obviously incomplete, it changes only only one caller of
> set_user_sigmask(), epoll_pwait() to explain what I mean.
> restore_user_sigmask() should simply die. Although perhaps another helper
> makes sense to add WARN_ON(test_tsk_restore_sigmask() && !signal_pending).

restore_user_sigmask() was added because of all the variants of these
syscalls we added because of y2038 as noted in commit message:

  signal: Add restore_user_sigmask()

    Refactor the logic to restore the sigmask before the syscall
    returns into an api.
    This is useful for versions of syscalls that pass in the
    sigmask and expect the current->sigmask to be changed during
    the execution and restored after the execution of the syscall.

    With the advent of new y2038 syscalls in the subsequent patches,
    we add two more new versions of the syscalls (for pselect, ppoll
    and io_pgetevents) in addition to the existing native and compat
    versions. Adding such an api reduces the logic that would need to
    be replicated otherwise.


>
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 4a0e98d..85f56e4 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -2318,19 +2318,19 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
>        size_t, sigsetsize)
> {
>    int error;
> -    sigset_t ksigmask, sigsaved;
>
>    /*
>     * If the caller wants a certain signal mask to be set during the wait,
>     * we apply it here.
>     */
> -    error = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
> +    error = set_user_sigmask(sigmask, sigsetsize);
>    if (error)
>        return error;
>
>    error = do_epoll_wait(epfd, events, maxevents, timeout);
>
> -    restore_user_sigmask(sigmask, &sigsaved);
> +    if (error != -EINTR)

As you address all the other syscalls this condition becomes more and
more complicated.

> +        restore_saved_sigmask();
>
>    return error;
> }
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index e412c09..1e82ae0 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -416,7 +416,6 @@ void task_join_group_stop(struct task_struct *task);
> static inline void set_restore_sigmask(void)
> {
>    set_thread_flag(TIF_RESTORE_SIGMASK);
> -    WARN_ON(!test_thread_flag(TIF_SIGPENDING));

So you always want do_signal() to be called?
You will have to check each architecture's implementation of
do_signal() to check if that has any side effects.

Although this is not what the patch is solving. What we want is to
adjust return codes on all these syscalls to user and not drop
signals. Please check v2/v3 of the patch. I've updated the commit text
to provide more context into what is actually being fixed here.

If we really want to simplify, we should rewrite all the internal
logic of all the ppoll, epoll_pwait, io_pgetevent syscall internal
handling where we set the error code.
As new versions of syscalls were added, the internal logic got
reworked rather hapazardly. But, as the current issue points out,
these are delicate changes.

-Deepa
> }
>
> static inline void clear_tsk_restore_sigmask(struct task_struct *tsk)
> @@ -447,7 +446,6 @@ static inline bool test_and_clear_restore_sigmask(void)
> static inline void set_restore_sigmask(void)
> {
>    current->restore_sigmask = true;
> -    WARN_ON(!test_thread_flag(TIF_SIGPENDING));
> }
> static inline void clear_tsk_restore_sigmask(struct task_struct *tsk)
> {
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index 9702016..887cea6 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -273,8 +273,7 @@ extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
>                   struct task_struct *p, enum pid_type type);
> extern int __group_send_sig_info(int, struct kernel_siginfo *, struct task_struct *);
> extern int sigprocmask(int, sigset_t *, sigset_t *);
> -extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
> -    sigset_t *oldset, size_t sigsetsize);
> +extern int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize);
> extern void restore_user_sigmask(const void __user *usigmask,
>                 sigset_t *sigsaved);
> extern void set_current_blocked(sigset_t *);
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 227ba17..76f4f9a 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2801,19 +2801,21 @@ EXPORT_SYMBOL(sigprocmask);
>  * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
>  * epoll_pwait where a new sigmask is passed from userland for the syscalls.
>  */
> -int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
> -             sigset_t *oldset, size_t sigsetsize)
> +int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize)
> {
> -    if (!usigmask)
> +    sigset_t *kmask;
> +
> +    if (!umask)
>        return 0;
>
>    if (sigsetsize != sizeof(sigset_t))
>        return -EINVAL;
> -    if (copy_from_user(set, usigmask, sizeof(sigset_t)))
> +    if (copy_from_user(kmask, umask, sizeof(sigset_t)))
>        return -EFAULT;
>
> -    *oldset = current->blocked;
> -    set_current_blocked(set);
> +    set_restore_sigmask();
> +    current->saved_sigmask = current->blocked;
> +    set_current_blocked(kmask);
>
>    return 0;
> }
> @@ -2840,39 +2842,6 @@ int set_compat_user_sigmask(const compat_sigset_t __user *usigmask,
> EXPORT_SYMBOL(set_compat_user_sigmask);
> #endif
>
> -/*
> - * restore_user_sigmask:
> - * usigmask: sigmask passed in from userland.
> - * sigsaved: saved sigmask when the syscall started and changed the sigmask to
> - *           usigmask.
> - *
> - * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
> - * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
> - */
> -void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
> -{
> -
> -    if (!usigmask)
> -        return;
> -    /*
> -     * When signals are pending, do not restore them here.
> -     * Restoring sigmask here can lead to delivering signals that the above
> -     * syscalls are intended to block because of the sigmask passed in.
> -     */
> -    if (signal_pending(current)) {
> -        current->saved_sigmask = *sigsaved;
> -        set_restore_sigmask();
> -        return;
> -    }
> -
> -    /*
> -     * This is needed because the fast syscall return path does not restore
> -     * saved_sigmask when signals are not pending.
> -     */
> -    set_current_blocked(sigsaved);
> -}
> -EXPORT_SYMBOL(restore_user_sigmask);
> -
> /**
>  *  sys_rt_sigprocmask - change the list of currently blocked signals
>  *  @how: whether to add, remove, or set signals
>
