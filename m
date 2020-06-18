Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F921FF6F3
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 17:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgFRPfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 11:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgFRPfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 11:35:21 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE49C06174E
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 08:35:21 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s18so7546422ioe.2
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 08:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BA5RnOXcxTj8hK9eSefXUNgaxNw2cPIOxfV7OKbWZJo=;
        b=OvYRTDZiWIx12SygT7T3rbcJhZ300TxFRhCHfP84sTWuSOxaAofcKzIuzpyzIq8kc/
         qBFCEny9VBUq8hwxXaB5mRQCP5f1h9SVPvTYkJumS8YS7FPe8vtI83yeWwIi4WYzODBE
         /7GSOaLcbdOFF/9/KqJr1upA6GIKGX6ljZnkd79UcVKdOW03e/aSHdtzjduGBsvV2RU+
         mjgrpcebU5C63lYtIGmEUBsiG5j1kiV2srCPRcHkJKKdoCOFQIEciS+Xjgzf8MDfU/9v
         jbd/wSMA/S3easB6HBHL7xpewYwY+zbuuslonYny8ZGG1WSekJ37MaQsxdqWzinN0MDL
         PcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BA5RnOXcxTj8hK9eSefXUNgaxNw2cPIOxfV7OKbWZJo=;
        b=jHGDD5LLKmeYnQ3/pQXAGko68aNaiW3hMSxS8BB6luR9oPYtC4eNxx4jNpOVJYch90
         00fSlWsFg+SHIHkWfN9vs4fvoED6UZdBZlxMeOnUXW+PNC+B4Q7eRT9tEm2vrwnahdBq
         IQrBgOGbbGgLYr2egjVcq7yCZdLFScPTJYcv6QNm+7fhp8S95PBtT9roQ5xXUZRqZWey
         FhzfZWeWeFPcVNri9pDfY97gqZA7Voj7xm7XH9egphnnxVb7YiGrHRAbJ+N3DakpWGpo
         gGP98BwESVoe1tSbNyZaEmUyyNcKZD4TawI5+5PjZgPGxYqnMXB3+2pX17jBUQx8jEoj
         uscQ==
X-Gm-Message-State: AOAM533tAQ/zzygi4DanLf66aMc/xXuIdoNvhaWUikZMwo9S8LZy1rwX
        rpEbjQBl2CZ+Tok2UNqi9sBitA5DPqJOBhfz16nqPg==
X-Google-Smtp-Source: ABdhPJzQIiGOwADOZRzvtxgBJzd3IfscQPuWF4bJxJoB3vza/ZN99xd7C6x/g3+ozZenw6HqPag3+Kbp4jfbfB+tjDk=
X-Received: by 2002:a02:4e42:: with SMTP id r63mr4854423jaa.46.1592494520481;
 Thu, 18 Jun 2020 08:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200608093950.86293-1-gprocida@google.com> <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
 <CAGvU0H=Gd5CUMMW35wBFV=ZaE4u6aiu3VKPCiJNujGcwOvy3WA@mail.gmail.com>
 <20200618073258.GA3856402@kroah.com> <CAGvU0HmmV9+bkavHqB7TPbGwgUWvygLfWrCCmLmJ0uVOSHXoQQ@mail.gmail.com>
 <20200618145904.GB3017232@kroah.com>
In-Reply-To: <20200618145904.GB3017232@kroah.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Thu, 18 Jun 2020 16:35:03 +0100
Message-ID: <CAGvU0HkAXae67ABKZQfjyc99u1ojeTmDTcykQa1O4jJ4B9iC4A@mail.gmail.com>
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

On Thu, 18 Jun 2020 at 15:59, Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jun 18, 2020 at 10:16:45AM +0100, Giuliano Procida wrote:
> > Hi.
> >
> > On Thu, 18 Jun 2020 at 08:33, Greg KH <greg@kroah.com> wrote:
> > >
> > >
> > > A: http://en.wikipedia.org/wiki/Top_post
> > > Q: Were do I find info about this thing called top-posting?
> > > A: Because it messes up the order in which people normally read text.
> > > Q: Why is top-posting such a bad thing?
> > > A: Top-posting.
> > > Q: What is the most annoying thing in e-mail?
> > >
> > > A: No.
> > > Q: Should I include quotations after my reply?
> > >
> > > http://daringfireball.net/2007/07/on_top
> > >
> > > :)
> >
> > I'm well aware of the above.
> > Alas, I haven't used mutt properly in about 15 years and I'm still
> > doing everything with Gmail.
>
> gmail can handle proper quoting, if you are stuck with that :)
>
> > Given that I was referring to the entire email thread, I punted on
> > finding a place to insert a comment.
> > BTW, there's a typo in the Q&A above. s/Were/Where/
>
> Ah, nice catch, first one to notice that in years!
>
> > > On Thu, Jun 18, 2020 at 08:27:55AM +0100, Giuliano Procida wrote:
> > > > Hi Greg.
> > > >
> > > > Is this patch (and the similar one for 4.9) queued?
> > >
> > > f5bbbbe4d635 ("blk-mq: sync the update nr_hw_queues with
> > > blk_mq_queue_tag_busy_iter") is in the following stable releases:
> > >         4.4.224 4.9.219 4.14.176 4.19
> > >
> > > Do you not see it there?
> >
> > We are referring to different "it"s.
> >
> > Yours: f5bbbbe4d635 is the upstream patch that went into v4.19-rc1 and
> > which you back-ported to at least some of these kernels. This is
> > clearly there.
>
> Great.
>
> > Mine: the commit sent earlier in this email thread - it's a
> > re-back-port, as I think the original back-port for 4.14 (and
> > similarly for 4.9) is incorrect. This has clearly not reached public
> > git, hence my question about whether the change was queued.
>
> I don't know what the git commit id you are looking for here, sorry.  I
> don't have the whole thread anywhere.
>
> > These are the ids of messages containing my commits:
> >
> > 4.14: 20200608093950.86293-1-gprocida@google.com
> > 4.9: 20200608094030.87031-1-gprocida@google.com
>
> Pointers to this on lore.kernel.org perhaps?
>

I wasn't aware stable was publicly archived. Here you go:

4.14: https://lore.kernel.org/stable/20200608093950.86293-1-gprocida@google.com/
4.9: https://lore.kernel.org/stable/20200608094030.87031-1-gprocida@google.com/

Regards,
Giuliano.

> thanks

> Remember, some of us get thousands of patches a week to handle,
> remembering old email thread, or even keeping them around, is
> impossible...
>
> greg k-h
