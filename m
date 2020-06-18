Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220891FEC6B
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 09:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgFRH2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 03:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgFRH2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 03:28:12 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA40DC06174E
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 00:28:12 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id r2so5908864ioo.4
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 00:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CqND4gJx846ZFzWEH+nK3UGfCBzB7+vF9hhCqrPQW5U=;
        b=sobS3WRAEojAjoNX9JtXCtfUcrlm7vD/RrqIXlowWxBFPo6otVPx9XSVB5f+bIzbM2
         GV5JeXMlIYniulR2BwtxOriKngbiDGEmc8vcBMRBozRUD7WXc04g3sSCkSgyOI2kR/wu
         yLklmhIIUUxlWSbfc7O0I2ov+mehFlxapVgy2f22pLvY8p6gFZ9c8c9gWDitEOkWhmCk
         wXvYVnErR5mYuAxzEh4H24jGeeThiFv4UFq+Q4xJYX9k5j5jtPSgXo2B+70GArR5uAt3
         HyrDScN/3R36M0feFmKoqPtl6nwMQGwJQ4F/bZg/3mUhdWBuaipOsVWbgm+86pFY4Rej
         Dwiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CqND4gJx846ZFzWEH+nK3UGfCBzB7+vF9hhCqrPQW5U=;
        b=Vma9rzV3q3LcpBE53g5MK/uQuki/y30scl5RWsvKFoIUpPj9JS/s3k/Jm1F2w0R8ap
         bUw+W7AeBzljQTH9Mt2GXExPFIc+88LwjR50Rt1BQVj3E2Z0elxiKey7WW3vyMnQ4qYV
         RrMMvAZD6bkQgI1g8eLoo/g6XFktq1niivt9V5T3SOUOz8Wy/EeA0ofvL+cntqVNkgue
         h+XwEvWGKQi0PMDgBe9ZFevAJWvR6bIs6XQFA3/lEuZsmuErPZPBV7nKO8t7BsATJaUv
         IUdhQ7wwFC9ZQF6i0zNQ/o3UCEHn8GQIJIQ7IqwIh2ORgT+XAurq7VlIY8bZ3NuwZgQv
         Qu/g==
X-Gm-Message-State: AOAM532MVE1n3qe5HoSddIt5qOpYL1P38QoDcpaWLMUcbCMYSDOn+Lc/
        kD3JLlaSnhkGkklzl/8gZKZJEvqU7YEtDoVjfp5fLQrsqg8=
X-Google-Smtp-Source: ABdhPJwtyMOiGZsqHpy/R7hZpsYymENuz7EFu7thkg85t37/lrXKfzgad7PQQVN/+vXcW4ZMQoSUtsxS8Zq56uuOr7w=
X-Received: by 2002:a02:2406:: with SMTP id f6mr3164321jaa.59.1592465291828;
 Thu, 18 Jun 2020 00:28:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200608093950.86293-1-gprocida@google.com> <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
In-Reply-To: <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Thu, 18 Jun 2020 08:27:55 +0100
Message-ID: <CAGvU0H=Gd5CUMMW35wBFV=ZaE4u6aiu3VKPCiJNujGcwOvy3WA@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg.

Is this patch (and the similar one for 4.9) queued?

Giuliano.

On Mon, 8 Jun 2020 at 14:01, Giuliano Procida <gprocida@google.com> wrote:
>
> -bouncing mail.
>
> This one is for 4.14. Apologies.
>
> Giuliano.
>
> On Mon, 8 Jun 2020 at 10:39, Giuliano Procida <gprocida@google.com> wrote:
> >
> > From: Jianchao Wang <jianchao.w.wang@oracle.com>
> >
> > commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f upstream.
> >
> > For blk-mq, part_in_flight/rw will invoke blk_mq_in_flight/rw to
> > account the inflight requests. It will access the queue_hw_ctx and
> > nr_hw_queues w/o any protection. When updating nr_hw_queues and
> > blk_mq_in_flight/rw occur concurrently, panic comes up.
> >
> > Before update nr_hw_queues, the q will be frozen. So we could use
> > q_usage_counter to avoid the race. percpu_ref_is_zero is used here
> > so that we will not miss any in-flight request. The access to
> > nr_hw_queues and queue_hw_ctx in blk_mq_queue_tag_busy_iter are
> > under rcu critical section, __blk_mq_update_nr_hw_queues could use
> > synchronize_rcu to ensure the zeroed q_usage_counter to be globally
> > visible.
> >
> > Backporting Notes
> >
> > This is a re-backport, landing synchronize_rcu in the right place.
> >
> > Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> > Reviewed-by: Ming Lei <ming.lei@redhat.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Giuliano Procida <gprocida@google.com>
> > ---
> >  block/blk-mq.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 9d53f476c517..cf56bdad2e06 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -2738,6 +2738,10 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
> >
> >         list_for_each_entry(q, &set->tag_list, tag_set_list)
> >                 blk_mq_freeze_queue(q);
> > +       /*
> > +        * Sync with blk_mq_queue_tag_busy_iter.
> > +        */
> > +       synchronize_rcu();
> >
> >         set->nr_hw_queues = nr_hw_queues;
> >         blk_mq_update_queue_map(set);
> > @@ -2748,10 +2752,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
> >
> >         list_for_each_entry(q, &set->tag_list, tag_set_list)
> >                 blk_mq_unfreeze_queue(q);
> > -       /*
> > -        * Sync with blk_mq_queue_tag_busy_iter.
> > -        */
> > -       synchronize_rcu();
> >  }
> >
> >  void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
> > --
> > 2.27.0.278.ge193c7cf3a9-goog
> >
