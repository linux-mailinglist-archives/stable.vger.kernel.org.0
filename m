Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8EF4A4E37
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 19:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350535AbiAaS1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 13:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240613AbiAaS1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 13:27:21 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63117C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 10:27:21 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id 23so43176826ybf.7
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 10:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d28lvf1wm1wz+DZ0AAoq3J7h905xkloUFJ+IEHcTYLg=;
        b=Bne8dAlXC7eCe2Jba7b9iVNNpNRgCBW3WdTkgaucXv9uTXn9ggCIoqtu8+1pQ/VVKn
         havzAcSEMyOjiQK8fgeoLep0xi2zaeIORTGC9sjYjXm0DRBJL/05v/5nruQPkcJzogLN
         Uk69pVZ57D28rAy1ryPMWARoScbbnKE6v2Ro99UtQTosEU8SHPv0YQYUu3JSBNe3Tj7j
         F3G/AbvJZQjenV3/ZycKaclKcTIlM6TJJEmUzosCRVjOZXwH1ds0TDFDYzxFjTjVMv13
         6kA4T0qCJ+/dctXohV/YRahIWXOWQ09c7hm28ZTdzh6a5hf6wYadKS4Qy7MFI81pbZkV
         FdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d28lvf1wm1wz+DZ0AAoq3J7h905xkloUFJ+IEHcTYLg=;
        b=kfRTAIRF1PRcMK2D/NaKooSy9Iv6VAW17Qyx7cGX6xiPfflboNrC50/UCA88PitGMk
         QDmI+zuyD5t7KjC8dDYEUjRFojAyAY/VZZ4zxQ6Fcj2QLL0XmPO/mfeoZjcSAJgo5pwC
         Sd4ot3iC2OuY6BySB2b2eGY/8LB3wU+0S9jvOizx63RTqlN37AXmNLxJwvekRRnH/Ol6
         vroYneQRIrq4MVArJfzii6xGWCdN26nS1pXOiK7entNirJZ7qur0ajBTP0+eztpAoS37
         QHLW8hWjEEucq8/WDRE54vAfCHJMESyO10NZ2357b5jYxaglUN5PjNNvhbJf54XTn4im
         U8eA==
X-Gm-Message-State: AOAM530AHOQAsf1ZizdcO/289Pfm1c+faEdM02VNdCSUytJIA6e6uBOH
        gs02+iQxYyEJe1rCFQx78p1o65fIgaM7OjGtobzURcKnI3jrkw==
X-Google-Smtp-Source: ABdhPJynThca5yuDbapvNAXkqxh42mSRasRBleaE8bsMdx5JuIu8gLWN0+L4a7AECxKEggJfJYUZKm7ndtOw+DPJt3Q=
X-Received: by 2002:a25:be41:: with SMTP id d1mr33205988ybm.488.1643653640245;
 Mon, 31 Jan 2022 10:27:20 -0800 (PST)
MIME-Version: 1.0
References: <1643460589124193@kroah.com>
In-Reply-To: <1643460589124193@kroah.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Mon, 31 Jan 2022 10:27:09 -0800
Message-ID: <CAJuCfpFKoSV+zGOZCE1YUt=PtaBTmugdQ73CmoDh_wjb6RQs6w@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] psi: Fix uaf issue when psi trigger is
 destroyed while being" failed to apply to 5.10-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 4:49 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Thanks for letting me know! I'll try backporting to 5.4 and 5.10. Will
post patches later today.
Thanks,
Suren.

>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From a06247c6804f1a7c86a2e5398a4c1f1db1471848 Mon Sep 17 00:00:00 2001
> From: Suren Baghdasaryan <surenb@google.com>
> Date: Tue, 11 Jan 2022 15:23:09 -0800
> Subject: [PATCH] psi: Fix uaf issue when psi trigger is destroyed while being
>  polled
>
> With write operation on psi files replacing old trigger with a new one,
> the lifetime of its waitqueue is totally arbitrary. Overwriting an
> existing trigger causes its waitqueue to be freed and pending poll()
> will stumble on trigger->event_wait which was destroyed.
> Fix this by disallowing to redefine an existing psi trigger. If a write
> operation is used on a file descriptor with an already existing psi
> trigger, the operation will fail with EBUSY error.
> Also bypass a check for psi_disabled in the psi_trigger_destroy as the
> flag can be flipped after the trigger is created, leading to a memory
> leak.
>
> Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Analyzed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20220111232309.1786347-1-surenb@google.com
>
> diff --git a/Documentation/accounting/psi.rst b/Documentation/accounting/psi.rst
> index f2b3439edcc2..860fe651d645 100644
> --- a/Documentation/accounting/psi.rst
> +++ b/Documentation/accounting/psi.rst
> @@ -92,7 +92,8 @@ Triggers can be set on more than one psi metric and more than one trigger
>  for the same psi metric can be specified. However for each trigger a separate
>  file descriptor is required to be able to poll it separately from others,
>  therefore for each trigger a separate open() syscall should be made even
> -when opening the same psi interface file.
> +when opening the same psi interface file. Write operations to a file descriptor
> +with an already existing psi trigger will fail with EBUSY.
>
>  Monitors activate only when system enters stall state for the monitored
>  psi metric and deactivates upon exit from the stall state. While system is
> diff --git a/include/linux/psi.h b/include/linux/psi.h
> index a70ca833c6d7..f8ce53bfdb2a 100644
> --- a/include/linux/psi.h
> +++ b/include/linux/psi.h
> @@ -33,7 +33,7 @@ void cgroup_move_task(struct task_struct *p, struct css_set *to);
>
>  struct psi_trigger *psi_trigger_create(struct psi_group *group,
>                         char *buf, size_t nbytes, enum psi_res res);
> -void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *t);
> +void psi_trigger_destroy(struct psi_trigger *t);
>
>  __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
>                         poll_table *wait);
> diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
> index 516c0fe836fd..1a3cef26d129 100644
> --- a/include/linux/psi_types.h
> +++ b/include/linux/psi_types.h
> @@ -141,9 +141,6 @@ struct psi_trigger {
>          * events to one per window
>          */
>         u64 last_event_time;
> -
> -       /* Refcounting to prevent premature destruction */
> -       struct kref refcount;
>  };
>
>  struct psi_group {
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index b31e1465868a..9d05c3ca2d5e 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3643,6 +3643,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
>         cgroup_get(cgrp);
>         cgroup_kn_unlock(of->kn);
>
> +       /* Allow only one trigger per file descriptor */
> +       if (ctx->psi.trigger) {
> +               cgroup_put(cgrp);
> +               return -EBUSY;
> +       }
> +
>         psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
>         new = psi_trigger_create(psi, buf, nbytes, res);
>         if (IS_ERR(new)) {
> @@ -3650,8 +3656,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
>                 return PTR_ERR(new);
>         }
>
> -       psi_trigger_replace(&ctx->psi.trigger, new);
> -
> +       smp_store_release(&ctx->psi.trigger, new);
>         cgroup_put(cgrp);
>
>         return nbytes;
> @@ -3690,7 +3695,7 @@ static void cgroup_pressure_release(struct kernfs_open_file *of)
>  {
>         struct cgroup_file_ctx *ctx = of->priv;
>
> -       psi_trigger_replace(&ctx->psi.trigger, NULL);
> +       psi_trigger_destroy(ctx->psi.trigger);
>  }
>
>  bool cgroup_psi_enabled(void)
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index a679613a7cb7..c137c4d6983e 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -1162,7 +1162,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
>         t->event = 0;
>         t->last_event_time = 0;
>         init_waitqueue_head(&t->event_wait);
> -       kref_init(&t->refcount);
>
>         mutex_lock(&group->trigger_lock);
>
> @@ -1191,15 +1190,19 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
>         return t;
>  }
>
> -static void psi_trigger_destroy(struct kref *ref)
> +void psi_trigger_destroy(struct psi_trigger *t)
>  {
> -       struct psi_trigger *t = container_of(ref, struct psi_trigger, refcount);
> -       struct psi_group *group = t->group;
> +       struct psi_group *group;
>         struct task_struct *task_to_destroy = NULL;
>
> -       if (static_branch_likely(&psi_disabled))
> +       /*
> +        * We do not check psi_disabled since it might have been disabled after
> +        * the trigger got created.
> +        */
> +       if (!t)
>                 return;
>
> +       group = t->group;
>         /*
>          * Wakeup waiters to stop polling. Can happen if cgroup is deleted
>          * from under a polling process.
> @@ -1235,9 +1238,9 @@ static void psi_trigger_destroy(struct kref *ref)
>         mutex_unlock(&group->trigger_lock);
>
>         /*
> -        * Wait for both *trigger_ptr from psi_trigger_replace and
> -        * poll_task RCUs to complete their read-side critical sections
> -        * before destroying the trigger and optionally the poll_task
> +        * Wait for psi_schedule_poll_work RCU to complete its read-side
> +        * critical section before destroying the trigger and optionally the
> +        * poll_task.
>          */
>         synchronize_rcu();
>         /*
> @@ -1254,18 +1257,6 @@ static void psi_trigger_destroy(struct kref *ref)
>         kfree(t);
>  }
>
> -void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *new)
> -{
> -       struct psi_trigger *old = *trigger_ptr;
> -
> -       if (static_branch_likely(&psi_disabled))
> -               return;
> -
> -       rcu_assign_pointer(*trigger_ptr, new);
> -       if (old)
> -               kref_put(&old->refcount, psi_trigger_destroy);
> -}
> -
>  __poll_t psi_trigger_poll(void **trigger_ptr,
>                                 struct file *file, poll_table *wait)
>  {
> @@ -1275,24 +1266,15 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
>         if (static_branch_likely(&psi_disabled))
>                 return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
>
> -       rcu_read_lock();
> -
> -       t = rcu_dereference(*(void __rcu __force **)trigger_ptr);
> -       if (!t) {
> -               rcu_read_unlock();
> +       t = smp_load_acquire(trigger_ptr);
> +       if (!t)
>                 return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
> -       }
> -       kref_get(&t->refcount);
> -
> -       rcu_read_unlock();
>
>         poll_wait(file, &t->event_wait, wait);
>
>         if (cmpxchg(&t->event, 1, 0) == 1)
>                 ret |= EPOLLPRI;
>
> -       kref_put(&t->refcount, psi_trigger_destroy);
> -
>         return ret;
>  }
>
> @@ -1316,14 +1298,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
>
>         buf[buf_size - 1] = '\0';
>
> -       new = psi_trigger_create(&psi_system, buf, nbytes, res);
> -       if (IS_ERR(new))
> -               return PTR_ERR(new);
> -
>         seq = file->private_data;
> +
>         /* Take seq->lock to protect seq->private from concurrent writes */
>         mutex_lock(&seq->lock);
> -       psi_trigger_replace(&seq->private, new);
> +
> +       /* Allow only one trigger per file descriptor */
> +       if (seq->private) {
> +               mutex_unlock(&seq->lock);
> +               return -EBUSY;
> +       }
> +
> +       new = psi_trigger_create(&psi_system, buf, nbytes, res);
> +       if (IS_ERR(new)) {
> +               mutex_unlock(&seq->lock);
> +               return PTR_ERR(new);
> +       }
> +
> +       smp_store_release(&seq->private, new);
>         mutex_unlock(&seq->lock);
>
>         return nbytes;
> @@ -1358,7 +1350,7 @@ static int psi_fop_release(struct inode *inode, struct file *file)
>  {
>         struct seq_file *seq = file->private_data;
>
> -       psi_trigger_replace(&seq->private, NULL);
> +       psi_trigger_destroy(seq->private);
>         return single_release(inode, file);
>  }
>
>
