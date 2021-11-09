Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4431344B087
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 16:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbhKIPlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 10:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237909AbhKIPla (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 10:41:30 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB35C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 07:38:44 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id y26so45261479lfa.11
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 07:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vrwzy5zpTLHwPWsOManZFHKM+eNNnbViCCXnPmnZuyY=;
        b=HC6/85nNuAx5H1FuNHNnntWtTv0Y1COPRGvSqxj5mmWUhsZBw7FYzX/ubVSw0Rhadb
         3yunJqZd97nmlFsdJYoheaJVt0CdSoJ1IbrLqGcbOai1W+xy6rvSJCCY2KZGdsTDAQdy
         AxT/ZORYg5vrGIMBvzB/4STQj7bADTmiczI6EVKQdLEt8SBOg7VbqL+0JxDgpMK7dvy9
         41RzKwCborSMZjIdOQpJHqU17CozFvkLgl+Yp1sKa5KUDTdez39e0uuDaLzDXPteZuPf
         XqSFbp9Vz70agBLpuNDdxmR1RuR8Kl3wRSHGpILwQQmbLcN7gMMvGbM/DnF8FTrdGjw6
         EYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vrwzy5zpTLHwPWsOManZFHKM+eNNnbViCCXnPmnZuyY=;
        b=6gqc9g5Eq7l+J7imBhNsksBtMp63D46jlWGnYyk+vKhCu8Gc0PNp72Quihu/iIYvwu
         bgqsrtIxkwp5scLNkfdYyPwmIyFu/eWPK34KCyeEWPyBctYvzIPocs5UHFEzOvcpU10b
         cxffyLy0D5gDtUq4szDbWXr2R16MadTZQGzCmWukldiV1sfOwhY1w3ijVjUwVh3CHnsR
         HULaDHtOpKIeYll9ikUG+dCeOV3EIBcQddr2N8h0wgUz3ElPjCfjtj1M3QTe8thCHhd9
         5MofPuTy7nKu9zfC6rY7UCKpzbdpIN6lUcQ/b2aYxsF6ICx4tN+L3xIUOPxzedq0sVJd
         JkiA==
X-Gm-Message-State: AOAM5309k3Boek/61lnzhdygPJRVddBhCAB/uqGeQKGgatq1/NLEgfea
        HuK4fGgiThw8aaAEqLAPxa8F3p08Qm5pVEPwxkAUJg==
X-Google-Smtp-Source: ABdhPJyUJgUpkpluplGRZfca5KTmk8ZghpHeK1dScOgSREcX73C2Mof9r+hZrWRsvdoY6ot3F417W2tsJ8BGhF2Rnv0=
X-Received: by 2002:a05:6512:2344:: with SMTP id p4mr7953037lfu.424.1636472322515;
 Tue, 09 Nov 2021 07:38:42 -0800 (PST)
MIME-Version: 1.0
References: <1636442582487@kroah.com>
In-Reply-To: <1636442582487@kroah.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Tue, 9 Nov 2021 07:38:30 -0800
Message-ID: <CAHRSSEyv5j36HYKRmkBowhUN2Wu5xh5rrGHdTJW50_VUwe__Cw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] binder: use euid from cred instead of
 using task" failed to apply to 4.4-stable tree
To:     gregkh@linuxfoundation.org
Cc:     casey@schaufler-ca.com, jannh@google.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg. I'll post backports for these this week.


On Mon, Nov 8, 2021 at 11:23 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.4-stable tree.
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
> From 29bc22ac5e5bc63275e850f0c8fc549e3d0e306b Mon Sep 17 00:00:00 2001
> From: Todd Kjos <tkjos@google.com>
> Date: Tue, 12 Oct 2021 09:56:12 -0700
> Subject: [PATCH] binder: use euid from cred instead of using task
>
> Save the 'struct cred' associated with a binder process
> at initial open to avoid potential race conditions
> when converting to an euid.
>
> Set a transaction's sender_euid from the 'struct cred'
> saved at binder_open() instead of looking up the euid
> from the binder proc's 'struct task'. This ensures
> the euid is associated with the security context that
> of the task that opened binder.
>
> Cc: stable@vger.kernel.org # 4.4+
> Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
> Signed-off-by: Todd Kjos <tkjos@google.com>
> Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Suggested-by: Jann Horn <jannh@google.com>
> Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index d9030cb6b1e4..231cff9b3b75 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -2702,7 +2702,7 @@ static void binder_transaction(struct binder_proc *proc,
>                 t->from = thread;
>         else
>                 t->from = NULL;
> -       t->sender_euid = task_euid(proc->tsk);
> +       t->sender_euid = proc->cred->euid;
>         t->to_proc = target_proc;
>         t->to_thread = target_thread;
>         t->code = tr->code;
> @@ -4343,6 +4343,7 @@ static void binder_free_proc(struct binder_proc *proc)
>         }
>         binder_alloc_deferred_release(&proc->alloc);
>         put_task_struct(proc->tsk);
> +       put_cred(proc->cred);
>         binder_stats_deleted(BINDER_STAT_PROC);
>         kfree(proc);
>  }
> @@ -5021,6 +5022,7 @@ static int binder_open(struct inode *nodp, struct file *filp)
>         spin_lock_init(&proc->outer_lock);
>         get_task_struct(current->group_leader);
>         proc->tsk = current->group_leader;
> +       proc->cred = get_cred(filp->f_cred);
>         INIT_LIST_HEAD(&proc->todo);
>         init_waitqueue_head(&proc->freeze_wait);
>         proc->default_priority = task_nice(current);
> diff --git a/drivers/android/binder_internal.h b/drivers/android/binder_internal.h
> index 810c0b84d3f8..e7d4920b3368 100644
> --- a/drivers/android/binder_internal.h
> +++ b/drivers/android/binder_internal.h
> @@ -364,6 +364,9 @@ struct binder_ref {
>   *                        (invariant after initialized)
>   * @tsk                   task_struct for group_leader of process
>   *                        (invariant after initialized)
> + * @cred                  struct cred associated with the `struct file`
> + *                        in binder_open()
> + *                        (invariant after initialized)
>   * @deferred_work_node:   element for binder_deferred_list
>   *                        (protected by binder_deferred_lock)
>   * @deferred_work:        bitmap of deferred work to perform
> @@ -424,6 +427,7 @@ struct binder_proc {
>         struct list_head waiting_threads;
>         int pid;
>         struct task_struct *tsk;
> +       const struct cred *cred;
>         struct hlist_node deferred_work_node;
>         int deferred_work;
>         int outstanding_txns;
>
