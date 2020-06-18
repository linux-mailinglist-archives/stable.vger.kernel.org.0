Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43081FF8F1
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgFRQOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbgFRQOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 12:14:41 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DB6C06174E
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 09:14:41 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id x189so7654769iof.9
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 09:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e1MaTAnpj26DDXKm6e1qOQzsIYQ9dEAR517c0elJIas=;
        b=FbPtNMMsfxzwkx/42V6aFmwZXkDYGBp4zJFoN13kOepcQhfsb/w9jKqG6oDC2MWbrN
         lWp5qVUU0mdCS2K1YKcHI9oOAsdCBAwLjaQA1Xh83Z9SCXcLM7XP4BKjjtgVE95aE7Xd
         G9+N+L16MfnkwIPTnxUIOcxtGp44sj/bRSrupEPz8rX5LiwYVO7YKjepVCho9NkYjngT
         7f+MiG4zEJIcy45NHqA/+WDjfOzlNwKrUJTdAv5YOh+Xv5Iy//GXQvr8kBpVxpWN2O/K
         Au+1ZR+lfjrZ6EzfCat4YuUu+La4OHPbcqQ1kqcy7pHoNUA8SLVsdWeps9vUVSNZDQOQ
         /VBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e1MaTAnpj26DDXKm6e1qOQzsIYQ9dEAR517c0elJIas=;
        b=Y3//Fc/IjAJEkuCpSkzFkIEFIGgxcTjyZ8ELQ+t3aJWvSHmWlng/fQpFSm3UfpYtVd
         iMJRfHpRfP7IsPT9FMOVe3pCLdt8Ro8CDN1MQYVjjZ737pdkS1RHzsI/m4C6x9x4R/r/
         uWmh0QNllx2UGXB4vtyvFxaj9y68KQfiwe1Ucr/3r7WdUEDAK+xtzxI7Shcxhywu/4J0
         xKIfsTnYRrj6pHSbhM1QENN+wmqjoHj7ugFDfu67vxu+2W5YkWq1CfDTL3VZUyJmNOYR
         ToBGO94manisxZomUM4ddn1BpKqHqoibJ0achcHt5pCfFRWo4aJdl9q1Z0RyARQaj1h5
         EoMw==
X-Gm-Message-State: AOAM5328im2RxSQJ7WSGoE3hIw0inHU4ZDtfscfnbflLP0DORb8h9QA9
        f9Qo8xXnfuMFtnRzTQ+cUOEl2/+en/v9xUeTF38H6f7d/HWS6Q==
X-Google-Smtp-Source: ABdhPJyotJgHN2sVioLg6fLkqsI+q4Pag2FE/Qz3jlzBQYS2+LgEOffiZC2YBzugjkxiKHg1DZXUwgi+OoXpUpawa2A=
X-Received: by 2002:a05:6638:bd4:: with SMTP id g20mr5104917jad.92.1592496880446;
 Thu, 18 Jun 2020 09:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200608093950.86293-1-gprocida@google.com> <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
 <CAGvU0H=Gd5CUMMW35wBFV=ZaE4u6aiu3VKPCiJNujGcwOvy3WA@mail.gmail.com>
 <20200618073258.GA3856402@kroah.com> <CAGvU0HmmV9+bkavHqB7TPbGwgUWvygLfWrCCmLmJ0uVOSHXoQQ@mail.gmail.com>
 <20200618145904.GB3017232@kroah.com> <CAGvU0HkAXae67ABKZQfjyc99u1ojeTmDTcykQa1O4jJ4B9iC4A@mail.gmail.com>
 <20200618160514.GA3539988@kroah.com>
In-Reply-To: <20200618160514.GA3539988@kroah.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Thu, 18 Jun 2020 17:14:23 +0100
Message-ID: <CAGvU0HkDEecRdZgYwQJOcj7DM+cU4i-OQ+oxTV+Lbq_6X+YATw@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi.

On Thu, 18 Jun 2020 at 17:05, Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jun 18, 2020 at 04:35:03PM +0100, Giuliano Procida wrote:
> > Hi.
> >
> > On Thu, 18 Jun 2020 at 15:59, Greg KH <greg@kroah.com> wrote:
> > >
> > > On Thu, Jun 18, 2020 at 10:16:45AM +0100, Giuliano Procida wrote:
> > > > Hi.
> > > >
> > > > On Thu, 18 Jun 2020 at 08:33, Greg KH <greg@kroah.com> wrote:
> > > > >
> > > > >
> > > > > A: http://en.wikipedia.org/wiki/Top_post
> > > > > Q: Were do I find info about this thing called top-posting?
> > > > > A: Because it messes up the order in which people normally read text.
> > > > > Q: Why is top-posting such a bad thing?
> > > > > A: Top-posting.
> > > > > Q: What is the most annoying thing in e-mail?
> > > > >
> > > > > A: No.
> > > > > Q: Should I include quotations after my reply?
> > > > >
> > > > > http://daringfireball.net/2007/07/on_top
> > > > >
> > > > > :)
> > > >
> > > > I'm well aware of the above.
> > > > Alas, I haven't used mutt properly in about 15 years and I'm still
> > > > doing everything with Gmail.
> > >
> > > gmail can handle proper quoting, if you are stuck with that :)
> > >
> > > > Given that I was referring to the entire email thread, I punted on
> > > > finding a place to insert a comment.
> > > > BTW, there's a typo in the Q&A above. s/Were/Where/
> > >
> > > Ah, nice catch, first one to notice that in years!
> > >
> > > > > On Thu, Jun 18, 2020 at 08:27:55AM +0100, Giuliano Procida wrote:
> > > > > > Hi Greg.
> > > > > >
> > > > > > Is this patch (and the similar one for 4.9) queued?
> > > > >
> > > > > f5bbbbe4d635 ("blk-mq: sync the update nr_hw_queues with
> > > > > blk_mq_queue_tag_busy_iter") is in the following stable releases:
> > > > >         4.4.224 4.9.219 4.14.176 4.19
> > > > >
> > > > > Do you not see it there?
> > > >
> > > > We are referring to different "it"s.
> > > >
> > > > Yours: f5bbbbe4d635 is the upstream patch that went into v4.19-rc1 and
> > > > which you back-ported to at least some of these kernels. This is
> > > > clearly there.
> > >
> > > Great.
> > >
> > > > Mine: the commit sent earlier in this email thread - it's a
> > > > re-back-port, as I think the original back-port for 4.14 (and
> > > > similarly for 4.9) is incorrect. This has clearly not reached public
> > > > git, hence my question about whether the change was queued.
> > >
> > > I don't know what the git commit id you are looking for here, sorry.  I
> > > don't have the whole thread anywhere.
> > >
> > > > These are the ids of messages containing my commits:
> > > >
> > > > 4.14: 20200608093950.86293-1-gprocida@google.com
> > > > 4.9: 20200608094030.87031-1-gprocida@google.com
> > >
> > > Pointers to this on lore.kernel.org perhaps?
> > >
> >
> > I wasn't aware stable was publicly archived. Here you go:
> >
> > 4.14: https://lore.kernel.org/stable/20200608093950.86293-1-gprocida@google.com/
> > 4.9: https://lore.kernel.org/stable/20200608094030.87031-1-gprocida@google.com/
>
> As per the git commit id in those emails, you should be able to
> determine the same thing that I can, namely that that patch is in the
> following stable releases:
>         4.4.224 4.9.219 4.14.176 4.19

Both those commits contain the text:

"Backporting Notes

This is a re-backport, landing synchronize_rcu in the right place."

If there's a special procedure for fixing back-ports, let me know,
'cos I haven't found one!

Cheers,
Giuliano.

> thanks,
>
> greg k-h
