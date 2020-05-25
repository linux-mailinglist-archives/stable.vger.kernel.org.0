Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DBC1E11F3
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 17:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404189AbgEYPlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 11:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404002AbgEYPlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 11:41:49 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6603BC061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:41:49 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id l15so20852276lje.9
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jxBcJ9+AnUHkNf5kBnInBEwkkB1cclUH2Vt26+wx2gA=;
        b=tPIUHKSvOf/mHPwB1oZXlpgCba9YJ1SzG4kK15dZUz/ESIVfr87suz04ududRrgbTP
         4olVQF5AUoaaqgbIn17LGSafuctORPDxweCIYuVhsrb6+iH5SrPnLUhy3Ihn9TTH5H/M
         E0HyTxG5yQENUWa/NyK9m0YCebuCMfKlWMnxDJcfKlmhM/as7PIO6o6wDfXoq/3qf6P5
         LWmahQ9/RnI7RJUlxDfE3+9+6MOuv5/Uut4cUT0gljLQ9HusgDHOSI2UuESAmo/o91/C
         GvD2xnSfTanld1rTdWsB+ca14dI2rG3xC2PF9TlEyXtGviUn+OPNEd0m/u9ug2qwuGLL
         df2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jxBcJ9+AnUHkNf5kBnInBEwkkB1cclUH2Vt26+wx2gA=;
        b=rhZXBamXGnwd3EE62ze2UWF1lzYP7bWUKuHnCeKuXYZzRpCGdOdadAiwHl0tbyMeYs
         XbFVP10IbVntfmURzsKxqi15yGMyDqsoyBke4cjrB4O9TcO1lYlqdt0aGx11mBuprsQp
         XbSTW2bjeL+atOtU4NVDJveiCFuOmAivbrmuTnLdkHRmx8XqiaMhOUNgt4QeVjizWsm+
         wEmh9EIzY2cXnIuHldMGijKLwq0N104EVsfcNpttArcO/serctSA4M20ZbJfc2frInz0
         mJPz5jJ5jPKUj/6t/4hy7PbjGWQ4XfH+asIf66oxa7RA+Sb/mUSXie65MUpwXMeDwHD1
         2kRw==
X-Gm-Message-State: AOAM532Y7egnst4XCP73o/bZY1JoK4B6bFfwxyC3sLb/h7EbwKUpRxF8
        kD9T++AKxwRHql7JdVYACVJZvFPPW6qjBMdJpJH5sg==
X-Google-Smtp-Source: ABdhPJweNyGoUqcLWWdBYwxM2b3Um1K4qHMabTgrSODqGt/4r/Udg8cyHCAyb3t1gs+Pry37+gXumDoygQE66l0xdN4=
X-Received: by 2002:a2e:9cc7:: with SMTP id g7mr12033030ljj.423.1590421307842;
 Mon, 25 May 2020 08:41:47 -0700 (PDT)
MIME-Version: 1.0
References: <1590417756152233@kroah.com>
In-Reply-To: <1590417756152233@kroah.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Mon, 25 May 2020 17:41:36 +0200
Message-ID: <CAKfTPtCdYVG3KbE4RixXYMEv=yQNu5zMutS7bTk4dAHqSxhs7A@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix enqueue_task_fair()
 warning some more" failed to apply to 5.6-stable tree
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Phil Auld <pauld@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 May 2020 at 16:42, <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This patch applies on top of
commit 6d4d22468dae ("sched/fair: Reorder enqueue/dequeue_task_fair path")
commit 5ab297bab984 ("sched/fair: Fix reordering of
enqueue/dequeue_task_fair()")



>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From b34cb07dde7c2346dec73d053ce926aeaa087303 Mon Sep 17 00:00:00 2001
> From: Phil Auld <pauld@redhat.com>
> Date: Tue, 12 May 2020 09:52:22 -0400
> Subject: [PATCH] sched/fair: Fix enqueue_task_fair() warning some more
>
> sched/fair: Fix enqueue_task_fair warning some more
>
> The recent patch, fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
> did not fully resolve the issues with the rq->tmp_alone_branch !=
> &rq->leaf_cfs_rq_list warning in enqueue_task_fair. There is a case where
> the first for_each_sched_entity loop exits due to on_rq, having incompletely
> updated the list.  In this case the second for_each_sched_entity loop can
> further modify se. The later code to fix up the list management fails to do
> what is needed because se does not point to the sched_entity which broke out
> of the first loop. The list is not fixed up because the throttled parent was
> already added back to the list by a task enqueue in a parallel child hierarchy.
>
> Address this by calling list_add_leaf_cfs_rq if there are throttled parents
> while doing the second for_each_sched_entity loop.
>
> Fixes: fe61468b2cb ("sched/fair: Fix enqueue_task_fair warning")
> Suggested-by: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Phil Auld <pauld@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
> Link: https://lkml.kernel.org/r/20200512135222.GC2201@lorien.usersys.redhat.com
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 02f323b85b6d..c6d57c334d51 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5479,6 +5479,13 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>                 /* end evaluation on encountering a throttled cfs_rq */
>                 if (cfs_rq_throttled(cfs_rq))
>                         goto enqueue_throttle;
> +
> +               /*
> +                * One parent has been throttled and cfs_rq removed from the
> +                * list. Add it back to not break the leaf list.
> +                */
> +               if (throttled_hierarchy(cfs_rq))
> +                       list_add_leaf_cfs_rq(cfs_rq);
>         }
>
>  enqueue_throttle:
>
