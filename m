Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA321B66F5
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 00:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgDWWmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 18:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgDWWmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 18:42:53 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2D5C09B044
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 15:42:51 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id c24so7551840uap.13
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 15:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJ6/10OQi+IjRoROw1bmmwZkTPHiPo4CeITaSJNBJxE=;
        b=lUYiU6CeDZLAwgfkrnPClfL9mW4Mccm3WgHBgOyJm3Ce+xg7lS02F8RLKC12vsJ7kl
         VaUzf3INAB4d7QhmeUNBWEZKfokkpuhEy9WQMrxDINFnlAD4RmaDOCx2fpGw5h+Ro1AT
         Xpnf7jZMZa1SZfYaLwydYhfmGM70QXxDKJwJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJ6/10OQi+IjRoROw1bmmwZkTPHiPo4CeITaSJNBJxE=;
        b=SRllHvaaIdKFBHYpR0AumJtX/63ScN3BzOhEcgiVloxdLMW23mJaR+d9T2lrA9pYK7
         ifFWmzYU3ifKkJr7VlOGD5lEmxyNGJkrIPhhpRcxpdA4IeAOLjlmNVgrMEqLggmG1y4Y
         GbGCPfL92QZlHud2ZkZANIXdOuC5xj3igthHcK5yUN/0hcWGGGCab4+tpGW7q2ndOkzz
         EEvPWy+olwfUBRaagunZvYXniAWTb+AllmF3zRubza6uDbC6FmU9AxN/S59N3WAKxcn+
         bqbCAy+cZlfVCt56War3qfJ7GGLLtW9I79sCS/SbVW1z389kQ+UPuCEeTJb3QlJ/jQPI
         aMRA==
X-Gm-Message-State: AGi0PuYk+M1FTLTU0s3ccOMvjB6d4/XSsgSJ8vsJtwcN5+Bix/unkb1j
        Sk7f4iABhYLZ9jAbIrdrRT9RucGdSgQ=
X-Google-Smtp-Source: APiQypK9emOUCLxsk5eX/t21ZdiAzecRJ2oVb762ZLrtCY/CKAQtcl+3eGO0D+pcbTjy7KaVv/Yc/A==
X-Received: by 2002:a05:6102:409:: with SMTP id d9mr5368809vsq.220.1587681770278;
        Thu, 23 Apr 2020 15:42:50 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id r137sm1090000vke.49.2020.04.23.15.42.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 15:42:49 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id g10so7585737uae.5
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 15:42:48 -0700 (PDT)
X-Received: by 2002:a05:6102:4d:: with SMTP id k13mr5446791vsp.198.1587681768455;
 Thu, 23 Apr 2020 15:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <1587035931-125028-1-git-send-email-john.garry@huawei.com>
 <e5416179-2ba0-c9a8-1b86-d52eae29e146@acm.org> <663d472a-5bde-4b89-3137-c7bfdf4d7b97@huawei.com>
In-Reply-To: <663d472a-5bde-4b89-3137-c7bfdf4d7b97@huawei.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 23 Apr 2020 15:42:37 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XBrKgng+vYzJx+qsOEZ-cZ10A0t+pRh=FcbQMop2ht4Q@mail.gmail.com>
Message-ID: <CAD=FV=XBrKgng+vYzJx+qsOEZ-cZ10A0t+pRh=FcbQMop2ht4Q@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: Put driver tag in blk_mq_dispatch_rq_list() when
 no budget
To:     John Garry <john.garry@huawei.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Apr 20, 2020 at 1:23 AM John Garry <john.garry@huawei.com> wrote:
>
> On 18/04/2020 03:43, Bart Van Assche wrote:
> > On 2020-04-16 04:18, John Garry wrote:
> >> If in blk_mq_dispatch_rq_list() we find no budget, then we break of the
> >> dispatch loop, but the request may keep the driver tag, evaulated
> >> in 'nxt' in the previous loop iteration.
> >>
> >> Fix by putting the driver tag for that request.
> >>
> >> Signed-off-by: John Garry <john.garry@huawei.com>
> >>
> >> diff --git a/block/blk-mq.c b/block/blk-mq.c
> >> index 8e56884fd2e9..a7785df2c944 100644
> >> --- a/block/blk-mq.c
> >> +++ b/block/blk-mq.c
> >> @@ -1222,8 +1222,10 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
> >>              rq = list_first_entry(list, struct request, queuelist);
> >>
> >>              hctx = rq->mq_hctx;
> >> -            if (!got_budget && !blk_mq_get_dispatch_budget(hctx))
> >> +            if (!got_budget && !blk_mq_get_dispatch_budget(hctx)) {
> >> +                    blk_mq_put_driver_tag(rq);
> >>                      break;
> >> +            }
> >>
> >>              if (!blk_mq_get_driver_tag(rq)) {
> >>                      /*
> >
> > Is this something that can only happen if q->mq_ops->queue_rq(hctx, &bd)
> > returns another value than BLK_STS_OK, BLK_STS_RESOURCE and
> > BLK_STS_DEV_RESOURCE?
>
> Right, as that case is handled in blk_mq_handle_dev_resource()
>
> If so, please add a comment in the source code
> > that explains this.
>
> So important that we should now do this in an extra patch?
>
> >
> > Is this perhaps a bug fix for 0bca799b9280 ("blk-mq: order getting
> > budget and driver tag")? If so, please mention this and add Cc tags for
> > the people who were Cc-ed on that patch.
>
> So it looks like 0bca799b9280 had a flaw, but I am not sure if anything
> got broken there and worthy of stable backport.
>
> I found this issue while debugging Ming's blk-mq cpu hotplug patchset,
> which I feel is ready to merge.
>
> Having said that, this nasty issue did take > 1 day for me to debug...
> so let me know.

As per the above conversation, presumably this should go to stable
then for any kernel that has commit 0bca799b9280 ("blk-mq: order
getting budget and driver tag")?  For instance, I think 4.19 would be
affected?  When I picked it there I got a conflict due to not having
commit ea4f995ee8b8 ("blk-mq: cache request hardware queue mapping")
but I think it's just a context collision and easy to resolve.

I'm no expert in the block code, but I posted my backport to 4.19 at
<https://crrev.com/c/2163313>.  I'm happy to send an email as a patch
to the list too or double-check that someone else's conflict
resolution matches mine.

-Doug
