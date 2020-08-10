Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B3024134F
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 00:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgHJWl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 18:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgHJWl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 18:41:58 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA60DC061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 15:41:57 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id v15so5586917lfg.6
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 15:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VdfT4UyfgRInqmNn91OrEga6Se2WHruOoGtg9fp8kQg=;
        b=pibFgRW7tgGNAJ27PV3J9AIuXywpAeAQSyt5CDijTmgaMKYrMCDVMo3O2QIgiI7OYK
         SDFoAvKoOHI063GWLjFmQ2+8lS2xMLsmgvCGCurHIIjogGkozcDpWOjnIMGcgb73lE0d
         E5GbU6iwVcFEgZffnJgpBLfuGrXV32jqhslUXiBDnNG7V+z0CLskv2L+leqm3yqnh5g3
         D6CY7uuat/Eus+BKBEORif2Ke9OiBWw2Knk/xRscMoNHzxCBFvU/Ea2WW4lWzEbsbN6u
         ZqpHmz6MeYFxpcWQHWO8Eet0jpHe3XX2ljfV5EdqRSepMJAs0F+sOak8Hn+ZxUBdO4pf
         2mcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdfT4UyfgRInqmNn91OrEga6Se2WHruOoGtg9fp8kQg=;
        b=QfgZ4MpU8YgzzQymywydNCSE1J/tRr/9iBwCO8THy8Rwu5j4PZ4UdCW/ghnBmePBc+
         F52lTBHSfvfYYnJh6kHUWjvvd86tmNamwB5BlFARCuHltFDgIgd9mFmmMmp2oqTVzuPN
         ka2XtWZ9LCcY1gTKaPn3FcTH6GCEBkdN5g065CatOKG9dfkVUZqK+oqNJXZ7+Rgjh+Z6
         BZajRvm5e45apVfvO8yBtDsMngVetmGDUW3JE2uVgG6j912fBMsE0OpFdFfIsOjWDBIJ
         hgfJ39t4r++LNFB4xzQqikexfTb0UYXnfOvtuNnrh9eu/t57pqFVW5TJ/NWPLNUgrREN
         OBqA==
X-Gm-Message-State: AOAM530FXppBZkYBo98GuL8Kawwca0SrLm9bP265EKhGXiJpDBqcdB9i
        LktgBoCAdY2CqwoUY/rzjSKj7vwMiJBpkcXSSzuqSA==
X-Google-Smtp-Source: ABdhPJzxlxLGLxO31MRNmkE1z6m2K1QVq0jgDYq35lazrgT4Ffs8/oJYnoWnEis2+DXqs0Uog/l1ghOP8QHLLj4n7FQ=
X-Received: by 2002:a19:74f:: with SMTP id 76mr1611147lfh.164.1597099316059;
 Mon, 10 Aug 2020 15:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200808183439.342243-1-axboe@kernel.dk> <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net> <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk> <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk> <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk> <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk> <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk> <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
In-Reply-To: <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 11 Aug 2020 00:41:29 +0200
Message-ID: <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 12:01 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 8/10/20 3:28 PM, Jens Axboe wrote:
> > On 8/10/20 3:26 PM, Jann Horn wrote:
> >> On Mon, Aug 10, 2020 at 11:12 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>> On 8/10/20 3:10 PM, Peter Zijlstra wrote:
> >>>> On Mon, Aug 10, 2020 at 03:06:49PM -0600, Jens Axboe wrote:
> >>>>
> >>>>> should work as far as I can tell, but I don't even know if there's a
> >>>>> reliable way to do task_in_kernel().
> >>>>
> >>>> Only on NOHZ_FULL, and tracking that is one of the things that makes it
> >>>> so horribly expensive.
> >>>
> >>> Probably no other way than to bite the bullet and just use TWA_SIGNAL
> >>> unconditionally...
> >>
> >> Why are you trying to avoid using TWA_SIGNAL? Is there a specific part
> >> of handling it that's particularly slow?
> >
> > Not particularly slow, but it's definitely heavier than TWA_RESUME. And
> > as we're driving any pollable async IO through this, just trying to
> > ensure it's as light as possible.
> >
> > It's not a functional thing, just efficiency.
>
> Ran some quick testing in a vm, which is worst case for this kind of
> thing as any kind of mucking with interrupts is really slow. And the hit
> is substantial. Though with the below, we're basically at parity again.
> Just for discussion...
>
>
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 5c0848ca1287..ea2c683c8563 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -42,7 +42,8 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
>                 set_notify_resume(task);
>                 break;
>         case TWA_SIGNAL:
> -               if (lock_task_sighand(task, &flags)) {
> +               if (!(task->jobctl & JOBCTL_TASK_WORK) &&
> +                   lock_task_sighand(task, &flags)) {
>                         task->jobctl |= JOBCTL_TASK_WORK;
>                         signal_wake_up(task, 0);
>                         unlock_task_sighand(task, &flags);

I think that should work in theory, but if you want to be able to do a
proper unlocked read of task->jobctl here, then I think you'd have to
use READ_ONCE() here and make all existing writes to ->jobctl use
WRITE_ONCE().

Also, I think that to make this work, stuff like get_signal() will
need to use memory barriers to ensure that reads from ->task_works are
ordered after ->jobctl has been cleared - ideally written such that on
the fastpath, the memory barrier doesn't execute.
