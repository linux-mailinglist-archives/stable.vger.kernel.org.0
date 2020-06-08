Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B6A1F1990
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 15:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgFHNBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 09:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbgFHNBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 09:01:23 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24D9C08C5C2
        for <stable@vger.kernel.org>; Mon,  8 Jun 2020 06:01:22 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w18so9619377iom.5
        for <stable@vger.kernel.org>; Mon, 08 Jun 2020 06:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QYNR/uxOcAEUDNeFbphoRdSDhaFvrHKkbPpWXO83o6Y=;
        b=ND4nJfQZdVhQ4plQQRWvuKAgrOm70Xchx7evDZX7FGIx/FJ/+50NeMZpHXoi5GCYtr
         nDB6jMEvQaT8QELIc8RSE0HCruGdy4de6Q+kpcMfLoJ3joRy9LIh2VWTDRHWmStgUelI
         i/1UqY2GdE5WHl1bpzP9rRQ6cTs/8c+6nbLLHo9BHj0W3dFcPky8Pqsnfdirhd527zrO
         x4zCoQhYg6ibS5GVIpoY2CIkrRl88Gf9eZ24yKj+3DIrJcUjlR8FzF0bZXwgBO1wVYcg
         MLOFKEUJKqG4ge9sjR6jD75dptWPN2xyBGz+2n8dHi/rpUw2v5JrjtUlPxD7s+QDhZtC
         EsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYNR/uxOcAEUDNeFbphoRdSDhaFvrHKkbPpWXO83o6Y=;
        b=aEIlNGy6sQJOolGK4IhIoVokJ3X+Nl6IdzaT4NCron/+Zh84txKdERS9zBvxmZkPEa
         AZM5J53RfUiG9z733Y45QKSA7Cc6CxPf/YrRdQKUW93WDjYptJL/dfCkSvinSTML6yFo
         ZTcKXj9TaLWjpFN5TlYxadBUrvzm/EPGPF0L64+3Df9djtZ3yu+owkcX3ygL6E5SxipB
         2P3hEJCxYaqjjo582aNIIboh76fAUfotjS1GAh1N0AbRBMRlma36Q2uGAgflKcJtNE7X
         rhBKx7V7+/lYUPSNgT6N7gXgZwEJ0sgH/c7aM8Jnxe8M+ZW5gdgbmdKCzeVmKxYAoAkV
         1DlQ==
X-Gm-Message-State: AOAM532dm+ki4c4iRvJK0R3oqxpKFFkleVC4VPRwMtu8ekmkYRQxSwfy
        ig0i80lpIB7waRmlfz/HGhxEBdmi1tm/rDLPgJP9sQ==
X-Google-Smtp-Source: ABdhPJzTffgndm2GkwoSmBabi5T1Od9zIkfJLVTQD0P3qGMb8YPi4Jw0pYr919atmRTSLJKalJVgpji0m8iN/fspL/Q=
X-Received: by 2002:a5e:8e47:: with SMTP id r7mr21924888ioo.204.1591621281688;
 Mon, 08 Jun 2020 06:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200608093950.86293-1-gprocida@google.com>
In-Reply-To: <20200608093950.86293-1-gprocida@google.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Mon, 8 Jun 2020 14:01:05 +0100
Message-ID: <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-bouncing mail.

This one is for 4.14. Apologies.

Giuliano.

On Mon, 8 Jun 2020 at 10:39, Giuliano Procida <gprocida@google.com> wrote:
>
> From: Jianchao Wang <jianchao.w.wang@oracle.com>
>
> commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f upstream.
>
> For blk-mq, part_in_flight/rw will invoke blk_mq_in_flight/rw to
> account the inflight requests. It will access the queue_hw_ctx and
> nr_hw_queues w/o any protection. When updating nr_hw_queues and
> blk_mq_in_flight/rw occur concurrently, panic comes up.
>
> Before update nr_hw_queues, the q will be frozen. So we could use
> q_usage_counter to avoid the race. percpu_ref_is_zero is used here
> so that we will not miss any in-flight request. The access to
> nr_hw_queues and queue_hw_ctx in blk_mq_queue_tag_busy_iter are
> under rcu critical section, __blk_mq_update_nr_hw_queues could use
> synchronize_rcu to ensure the zeroed q_usage_counter to be globally
> visible.
>
> Backporting Notes
>
> This is a re-backport, landing synchronize_rcu in the right place.
>
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Giuliano Procida <gprocida@google.com>
> ---
>  block/blk-mq.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 9d53f476c517..cf56bdad2e06 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2738,6 +2738,10 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
>
>         list_for_each_entry(q, &set->tag_list, tag_set_list)
>                 blk_mq_freeze_queue(q);
> +       /*
> +        * Sync with blk_mq_queue_tag_busy_iter.
> +        */
> +       synchronize_rcu();
>
>         set->nr_hw_queues = nr_hw_queues;
>         blk_mq_update_queue_map(set);
> @@ -2748,10 +2752,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
>
>         list_for_each_entry(q, &set->tag_list, tag_set_list)
>                 blk_mq_unfreeze_queue(q);
> -       /*
> -        * Sync with blk_mq_queue_tag_busy_iter.
> -        */
> -       synchronize_rcu();
>  }
>
>  void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
> --
> 2.27.0.278.ge193c7cf3a9-goog
>
