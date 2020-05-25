Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908C01E1225
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 17:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391043AbgEYPzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 11:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390998AbgEYPzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 11:55:18 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3909C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:55:16 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z13so11574503ljn.7
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UZDddnpoOyP0FJJV23p5xrvVjha4lOwjGjPgJfs0qqE=;
        b=LbVKXQY4Szafaa8jACbd1BbMyFcg6RDea59NKS4+hrKSrOEqj1VGPfv3qsn/orNcLJ
         7vZVhkMk2sfDXn6b6xsPxhJmmq9zh3LTEq/YeRvgFUOnZzUF1Lssu2qTgh+5fPi+dUhy
         d0N8KCm28bPRq8zADzch6d8QTY3iW4lx8o2OK/aY5X8eNx9HFgCm7TYBi6D7HcH7NeRm
         ECPHGg9uwhc6o1D/YEGPScN8tKB0a83FhZ33pR6/K69sZvliGoVw8f/cRGz2U5FE0rTX
         /IZ/A9yxCJkUEZdHieVyApjDEVtbwobL5n+KQfxK1nF6ceiZ399FXTteMw8TPvlNMfFH
         zktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UZDddnpoOyP0FJJV23p5xrvVjha4lOwjGjPgJfs0qqE=;
        b=j597RFC+K4l822F4vk/mWSkfZuiLcnEPPXEsJeufb1gmbFHTKmBeQeCDDKnI3guVUv
         aDcEfOryzsFQxJF1/jA8EL6/QuGbNlGr9znPzip1pIqaurefSifTvkfUhLo2RH7UkpXo
         LjocBgaIjLRlXIJ9CFwcPHo45oykY4k6JAdkUN8ivQdrhzhAvysNJzTkHuyToEwxyb8S
         xrxVznMXo5ReULdUJbtbZkfeOaAr/HXB4GqgcdLtRFEcTDV/HvSm8D2C9uHsSvbFS/2b
         ooa3Hv2b1b7gzJFsOVTUd1woHYdP3vylXDPS5aPODjPQN0Jc9NOsm2M9Q/SiNl5WO9WZ
         ysew==
X-Gm-Message-State: AOAM530xgiDUfxmlABap/x9S/2GVNgCUyZNULwGVfaGsq+osse8IgiRJ
        1k5qsCx19Vj4ukebX3FNy/X9eCyqRxPhgyL9usi9WQ==
X-Google-Smtp-Source: ABdhPJwPQ7DsCgjJXto61Xix+Y2DG5KnFtwN11HDCk8IQMcH9Jmub2ewqHXfws83RwjmrdqiX3ZYCC9q7NVhJ4+9Y/8=
X-Received: by 2002:a2e:1f02:: with SMTP id f2mr13573214ljf.156.1590422115224;
 Mon, 25 May 2020 08:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <1590417756152233@kroah.com> <CAKfTPtCdYVG3KbE4RixXYMEv=yQNu5zMutS7bTk4dAHqSxhs7A@mail.gmail.com>
 <20200525154918.GB1039448@kroah.com>
In-Reply-To: <20200525154918.GB1039448@kroah.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Mon, 25 May 2020 17:55:03 +0200
Message-ID: <CAKfTPtCCegv884Rd03hB9doLM8_JSFY=tg7dFaWgOYsGLYjNEg@mail.gmail.com>
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

On Mon, 25 May 2020 at 17:49, gregkh@linuxfoundation.org
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, May 25, 2020 at 05:41:36PM +0200, Vincent Guittot wrote:
> > On Mon, 25 May 2020 at 16:42, <gregkh@linuxfoundation.org> wrote:
> > >
> > >
> > > The patch below does not apply to the 5.6-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> >
> > This patch applies on top of
> > commit 6d4d22468dae ("sched/fair: Reorder enqueue/dequeue_task_fair path")
>
> That applies, but:
>
> > commit 5ab297bab984 ("sched/fair: Fix reordering of
> > enqueue/dequeue_task_fair()")
>
> That one does not.
>
> Can you make a backported patch series of these that I can apply easily?

I tested the cherry-pick of the 2 commits above on top of v5.6.14 and
there were applying without error. Should I use another tag ?


>
> thanks,
>
> greg k-h
