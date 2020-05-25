Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A97C1E124D
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 18:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389011AbgEYQD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 12:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388432AbgEYQDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 12:03:25 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36ADC061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 09:03:23 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id v16so21301270ljc.8
        for <stable@vger.kernel.org>; Mon, 25 May 2020 09:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xBLYi0YQHEVKyFqR5oe3zDmD/AbgLTVzJ2Yoz4/B2Vo=;
        b=ZhbQylC4rasFSlRWjlE3b/V2zkhtawYAkZK3AglBahyzwraItg9e+wWdOvldH76+aV
         +3JYcogLRmMX6xHEE1NeCLKqwVaOF6bfFX9fgLiPYjWkVjGlgR7yCQhQb1McAcjLEE0q
         1eaPrAlxai2HyN8ATJmzpj8Wi4DcXTrQ39y+vnFhH/eZhnfMrf8JP++/mnFmql50FJ/d
         hlBmY1nivvr1ALqz27Mba+aDkzczUYxzzH5I3gTnDXweWSwGovstuioJICnSnejYGOZ+
         00r4w7h9pi8ZLOw2v1Aw/SPomeJ9SE/o2nPqMiqkn6jygW+s+HmLTvyjhU2yf2I6r+2C
         2LmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xBLYi0YQHEVKyFqR5oe3zDmD/AbgLTVzJ2Yoz4/B2Vo=;
        b=aWV7wggWsbGj+7Xil9H0QQ2mWMp43SU76pzunP9i5GVAdswEo9TRFcv+GoPy+mc8V0
         0Ixd55BPzRcmpr38yLw4ifRRLlUmkG3mXlJ06Szl4HnGRQAXj6IWLZh+R0VX8BJfRP6n
         /RaiGJGRYzhQnJR+tOHYGITBb1tPTVw0sAvJKzmi5+jPkO+mZ2J/P3LKTHGJP6bqWC4q
         t4RFo4YStZoSAObsqQU5hilafoc0/CHZNtvAVAfwDX/TB6Q/Ejl2w0H9v0CInv/rTSUp
         IPKWdQ8U8qI7ZIXsDDXN2XmfZu9/s5nKBn+sQPWinKAHUgD1Z6BU7nB5RtxA8LT8dlsY
         3duw==
X-Gm-Message-State: AOAM531uFaVdvVv+KI9lj/B44TigfMTuwtP650DJHTMhBw4opULe4yZ0
        d7fuK3xRlDGf83jX3U7x1P24VNrXd0KKjrnshmR5zA==
X-Google-Smtp-Source: ABdhPJxZmEfMcqa8ZWQaGWqpKQoxF8UlPhtYL6RhEGqFoERJAblOKn2LFk9wJGDbCnCVBVbHk1kL44gCQF25+TbRIbo=
X-Received: by 2002:a2e:9957:: with SMTP id r23mr14849991ljj.226.1590422602403;
 Mon, 25 May 2020 09:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <15904177553090@kroah.com>
In-Reply-To: <15904177553090@kroah.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Mon, 25 May 2020 18:03:11 +0200
Message-ID: <CAKfTPtBPNrA0aPrbMSbqPbc7W00k+kqLWx9rX41M1=DH_ehsEw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix enqueue_task_fair()
 warning some more" failed to apply to 5.4-stable tree
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
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Similarly to v5.6, this patch applies on top of
commit 6d4d22468dae ("sched/fair: Reorder enqueue/dequeue_task_fair path")
commit 5ab297bab984 ("sched/fair: Fix reordering of
enqueue/dequeue_task_fair()")

I have been able to cherry-pick the 3 patches without error on top of v5.4.42.

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
