Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E093B2EFF
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 14:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhFXMeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 08:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhFXMdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 08:33:47 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C16C061767
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 05:31:25 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id z22so7496626ljh.8
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 05:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntc5rp5Qo89ApXwL9l1/cL9VK38RT4hK4RWM0GfRIGE=;
        b=irTXJ9/aAsEha6NU0r4G49gUv6Bco2ucKVONHHsYYZpdZDbceq49ae9chyRJAbuZrz
         yATeTESuhflHZh16/KtE7OFQxA37Te19oyQuC2t4WIHaHdAKlmyvTpI8rPZwCk0/hE+k
         KVBhbTfcbX50N+eZTDddq3vVGoXX0EU+yBd6Hqv8H2lL+TedkMq1xfR9bI4QMmsQ/qxM
         bT/fKz0hPxouxnvJL8G7xO3itXm8bZcsNHEOvEtGFtOW9pm57fHjBLK9fsLFAwWz/uqm
         h10c/gEwufecT3Yj2zCcFNIMXWsEvVNSEWxp96ZdludFvvdtl+3jCv8vaCV0v1QzJKIs
         xVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntc5rp5Qo89ApXwL9l1/cL9VK38RT4hK4RWM0GfRIGE=;
        b=k5k43bktqp5c/4r8wzU5gRksbsf94XHMkVpUpAeO3OfkTy+iMDfqIWRY0cUpOs5Mue
         TFp44hwNSSt0DIZBijkB1muX3ySJt6iThF8zjTwtgTfsS6+BOyr/lPqMYcuf4rgcx87l
         jF6eVfpci2Z6JBdnaNWvj7Xm0mFwDAqHv4dj3TcypYYIx9bOnrXZ2G00Lhf42Gjh/yo8
         vbPLmXIHpD5eWmjQLrUCv005YqjjZAeUA/WGdJ8WeHWl7Rd86nAFEwQlkgIqa6N6EXIf
         mbb6EHLW6Vq6hoEGScN/Q12igOZ9782zhDvYR81xYaBxZUP7osnu4cVSp5hmJyeWVEws
         LRyg==
X-Gm-Message-State: AOAM53377O/Vfkb74MJwnocrTZu8kJ2eCew+XsH4CmxCyXABQp1tee30
        VLtOqCIWql/fBmSUo//ZY5gLQXKPMz8uO2IB2zcbSA==
X-Google-Smtp-Source: ABdhPJxw3m7kanIA/XXScoeRBdjTNFdQBARRSUQJGtWpUzaeVEmGPjBwEdSn2x/HyX0Us4OWrS2JQ7u8hJrAm3JKflY=
X-Received: by 2002:a2e:9a8a:: with SMTP id p10mr3746079lji.221.1624537884197;
 Thu, 24 Jun 2021 05:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <17fc60a3-cc50-7cff-eb46-904c2f0c416e@canonical.com>
 <20201118235015.GB6015@geo.homenetwork> <20201119003319.GA6805@geo.homenetwork>
 <CAKfTPtBYm8UtBBnbc7qddA2_OAa3vwH=KoHNgvsQJ9zO2KocYQ@mail.gmail.com>
 <7c9462c9-8908-8592-0727-9117d4173724@canonical.com> <CAKfTPtAfzxbm0qM+8r2i+3jWjpJ2OLbU4F1WE8GrzTZH6Ck7FA@mail.gmail.com>
 <CAMy_GT88PgfH9F4Mo95wPSCTpGYJfRFpruc1QYg77t=HPBDaLQ@mail.gmail.com>
In-Reply-To: <CAMy_GT88PgfH9F4Mo95wPSCTpGYJfRFpruc1QYg77t=HPBDaLQ@mail.gmail.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Thu, 24 Jun 2021 14:31:12 +0200
Message-ID: <CAKfTPtDknAbQdx6E6LhOn3AaBcN5v9TSnR=FP_rEXvrJq7kPww@mail.gmail.com>
Subject: Re: [PATCH v3] sched/fair: fix unthrottle_cfs_rq for leaf_cfs_rq list
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Tao Zhou <t1zhou@163.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        SeongJae Park <sjpark@amazon.com>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Tao Zhou <ouwen210@hotmail.com>, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavan Kondeti <pkondeti@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Gavin Guo <gavin.guo@canonical.com>, halves@canonical.com,
        nivedita.singhvi@canonical.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 24 Jun 2021 at 12:29, Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
>
> Hello Vincent,
>
> sorry to resurrect this thread again,
> I was trying to backport this patch and corresponding fixes to our
> Ubuntu 4.15 kernel [1] to fix an issue report by LTP cfs_bandwidth01
> test[2], my colleague Guilherme told me there once a discussion about
> backporting this on this thread.
>
> You mentioned here this should not be backported to earlier stable
> kernel, I am curious if there is any specific reason of it? Too risky
> maybe?

Yes, IIRC there are some dependencies with other patchsets that make
the backport complex and not straight forward


> Thanks!
> PHLin
>
> [1] https://lists.ubuntu.com/archives/kernel-team/2021-June/121571.html
> [2] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/sched/cfs-scheduler/cfs_bandwidth01.c
>
>
> On Thu, Nov 19, 2020 at 9:25 PM Vincent Guittot
> <vincent.guittot@linaro.org> wrote:
> >
> > On Thu, 19 Nov 2020 at 12:36, Guilherme G. Piccoli
> > <gpiccoli@canonical.com> wrote:
> > >
> > >
> > >
> > > On 19/11/2020 05:36, Vincent Guittot wrote:
> > > > On Thu, 19 Nov 2020 at 01:36, Tao Zhou <t1zhou@163.com> wrote:
> > > >>
> > > >> On Thu, Nov 19, 2020 at 07:50:15AM +0800, Tao Zhou wrote:
> > > >>> On Wed, Nov 18, 2020 at 07:56:38PM -0300, Guilherme G. Piccoli wrote:
> > > >>>> Hi Vincent (and all CCed), I'm sorry to ping about such "old" patch, but
> > > >>>> we experienced a similar condition to what this patch addresses; it's an
> > > >>>> older kernel (4.15.x) but when suggesting the users to move to an
> > > >>>> updated 5.4.x kernel, we noticed that this patch is not there, although
> > > >>>> similar ones are (like [0] and [1]).
> > > >>>>
> > > >>>> So, I'd like to ask if there's any particular reason to not backport
> > > >>>> this fix to stable kernels, specially the longterm 5.4. The main reason
> > > >>>> behind the question is that the code is very complex for non-experienced
> > > >>>> scheduler developers, and I'm afraid in suggesting such backport to 5.4
> > > >>>> and introduce complex-to-debug issues.
> > > >>>>
> > > >>>> Let me know your thoughts Vincent (and all CCed), thanks in advance.
> > > >>>> Cheers,
> > > >>>>
> > > >>>>
> > > >>>> Guilherme
> > > >>>>
> > > >>>>
> > > >>>> P.S. For those that deleted this thread from the email client, here's a
> > > >>>> link:
> > > >>>> https://lore.kernel.org/lkml/20200513135528.4742-1-vincent.guittot@linaro.org/
> > > >>>>
> > > >>>>
> > > >>>> [0]
> > > >>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe61468b2cb
> > > >>>>
> > > >>>> [1]
> > > >>>> https://lore.kernel.org/lkml/20200506141821.GA9773@lorien.usersys.redhat.com/
> > > >>>> <- great thread BTW!
> > > >>>
> > > >>> 'sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list" failed to apply to
> > > >>> 5.4-stable tree'
> > > >>>
> > > >>> You could check above. But I do not have the link about this. Can't search it
> > > >>> on LKML web: https://lore.kernel.org/lkml/
> > > >>>
> > > >>> BTW: 'ouwen210@hotmail.com' and 'zohooouoto@zoho.com.cn' all is myself.
> > > >>>
> > > >>> Sorry for the confusing..
> > > >>>
> > > >>> Thanks.
> > > >>
> > > >> Sorry again. I forget something. It is in the stable.
> > > >>
> > > >> Here it is:
> > > >>
> > > >>   https://lore.kernel.org/stable/159041776924279@kroah.com/
> > > >
> > > > I think it has never been applied to stable.
> > > > As you mentioned, the backport has been sent :
> > > > https://lore.kernel.org/stable/20200525172709.GB7427@vingu-book/
> > > >
> > > > I received another emailed in September and pointed out to the
> > > > backport : https://www.spinics.net/lists/stable/msg410445.html
> > > >
> > > >
> > > >>
> > >
> > > Thanks a lot Tao and Vincent! Nice to know that you already worked the
> > > backport, gives much more confidence when the author does that heheh
> > >
> > > So, this should go to stable 5.4.y, but not 4.19.y IIUC?
> >
> > Yeah. they should be backported up to v5.1 but not earlier
> >
> > Regards,
> > Vincent
> >
> > > Cheers,
> > >
> > >
> > > Guilherme
