Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC7C1A171D
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 23:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgDGVCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 17:02:33 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:36317 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgDGVCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 17:02:33 -0400
Received: by mail-il1-f196.google.com with SMTP id p13so4681929ilp.3
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 14:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5pIRIKThZd3VBrBxpO1D+6KTHKNUV2wEvyxl6JYVXxQ=;
        b=TZCBxjNJBGU04awSfBZuq39Eg1r7LaU32EhNoHQE5Yf4fPxI4EmTxyQFYl5KmqCiD5
         GCuqcPx0IMFBzbu24W1Wb3zMQ7IwhjI57AB3GkFdBfsHUoTxWfivUxUOopomrNzQMMV3
         ydHEVL85gF3AZw3LGWJ2zAXqA4qzlADNCRihQo+NZnM2JyRvdJYI33qVhcTpoOjTX52z
         aUuD3t1ZsoE2kR8vLph9yMcYCP9xvdYZP2KKXA6g72x77k4VmVD2uX9WVm71VufS/ce/
         mgxVjlJdHgf+zoTI5m8LorwnfGAmTvYbifPy68kJUhsGpv7o9Fb9mRqY63qoFrMFwyWV
         VLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5pIRIKThZd3VBrBxpO1D+6KTHKNUV2wEvyxl6JYVXxQ=;
        b=plxvt5jJfe/uZ8gmUpD+L8jNudCtTYRw5YlmoL1gHeApUYQiAWbvhrs65oh7mMKY1n
         mlWQQKXnl4CU9RA8KRs2e102xwM2kfZauMGGe5uCtFHw3+S2qpS4/XEvbmyYfxJfF8/u
         6f9F7pNqo1RgTqf0Rtg59C0/pV+IReO7HeO9yiKmZfvDX7NRo6MNVhHSpAwsQyScoOpS
         niyTuVDIrGXWhu5LVMOVneAWyuy7KyxydlHLxUmetaJXofhdMzU5ynQixdOO3tPpLoCp
         UYIpJ94YooWYFv/WDUpdEF3PNDdazZs0c18lpuMWjIUuI3HMbZ53hBisPnFyN6HUIDO9
         8Yqw==
X-Gm-Message-State: AGi0PuYYN+n7RVhBmgNxg6DF32++k3LFG9FTg3p+7txfwp0wdQGGqUI9
        fss552FewqW+0lIhNoSyy0CMFMpKaxxPb9GVJ1uYeOugNV8=
X-Google-Smtp-Source: APiQypJdokQjJrAFvVujNjNzcyqd4HU+lABT/JSXZfYEUylKdoC+yG4RiD1+UwZ5Z66nhyKNtOoS2zK051urzadfvy8=
X-Received: by 2002:a92:364f:: with SMTP id d15mr4807381ilf.0.1586293351467;
 Tue, 07 Apr 2020 14:02:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAGvU0HkVUE_mQY8AUjieRcRrD38gdJRE+CbDuenMxnU6DAFOSA@mail.gmail.com>
 <20200403092032.GE3740897@kroah.com> <CAGvU0H=+KrQRV7SUkVjWudKi7i1LqmGheRfVofKDV0i8Qgd=bg@mail.gmail.com>
 <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Tue, 7 Apr 2020 22:02:14 +0100
Message-ID: <CAGvU0H=aPUKqLAbwuwoWzz60Q_RqHruxL4y7tZ4qOx39L_f7qw@mail.gmail.com>
Subject: Re: backport request for use-after-free blk_mq_queue_tag_busy_iter
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg.

Going back further to 3.16 or 3.18 looks like a lot of work and I have
low confidence of generating correct code.

There are changes like 3ef28e83ab15799742e55fd13243a5f678b04242 (from
4.3) which changed the locking from blk_mq_queue_enter to
blk_queue_enter.

I'm going to stand down here.

Sorry about this.
Giuliano.

On Tue, 7 Apr 2020 at 17:31, Giuliano Procida <gprocida@google.com> wrote:
>
> Hi Greg.
>
> On Fri, 3 Apr 2020 at 23:30, Giuliano Procida <gprocida@google.com> wrote:
> >
> > Hi Greg.
> >
> > I also have 4.14 and 4.9, I'll send them on for comparison.
>
> I've done this.
>
> > I will try 4.4 but, as one call site doesn't exist and the other
> > didn't have any locking to start with, I'd like to try to reproduce
> > the issue first.
>
> I have failed to build a bootable 4.4 kernel which is surprising /
> embarrassing, as my current toolchain (even after working around
> various known issues) compiles kernels that either panic or
> triple-fault (apparently, as there's no log output, just a reboot) on
> my amd64 hardware. Running an old live distribution with a 4.4 kernel,
> I wasn't able to reproduce the issue apparently resolved by these
> fixes after several hours of running.
>
> I've also spent most of 2 days looking at unfamiliar code.
>
> The code in 4.4 uses a timer instead of a workqueue for timeout
> callbacks. The callbacks have also have blk_queue_enter/exit
> protection in 4.9 but not 4.4. I'm guessing, but don't know, that the
> execution contexts are sufficiently similar between timers and
> workqueues that this protection should be back-ported to 4.4. This is
> relatively simple, it's bits of a couple of extra commits.
>
> f5bbbbe4d635 adds to blk_mq_queue_tag_busy_iter an RCU-protected test
> to see if the blk_queue is held before doing any work. It also adds
> RCU synchronisation to code that manipulates the number of hardware
> queues. The follow-up 530ca2c9bd more sensibly just (possibly
> recursively) does try-to-enter/exit instead. 4.4 doesn't have code
> that manipulates the number of hardware queues. However, the
> blk_mq_queue_tag_busy_iter locking may be enough to prevent
> ioctl/procfs concurrency.
>
> To this end, I've put together patches for 4.4. They are completely
> untested. Once I've verified they actually compile I'll send them on.
>
> Giuliano.
>
> > I should have some spare time for this soon.
> >
> > Giuilano.
> >
> > On Fri, 3 Apr 2020 at 10:20, Greg KH <greg@kroah.com> wrote:
> > >
> > > On Wed, Apr 01, 2020 at 05:47:02PM +0000, Giuliano Procida wrote:
> > > > This issue was found in 4.14 and is present in earlier kernels.
> > > >
> > > > Please backport
> > > >
> > > > f5bbbbe4d635 blk-mq: sync the update nr_hw_queues with
> > > > blk_mq_queue_tag_busy_iter
> > > > 530ca2c9bd69 blk-mq: Allow blocking queue tag iter callbacks
> > > >
> > > > onto the stable branches that don't have these. The second is a fix
> > > > for the first. Thank you.
> > > >
> > > > 4.19.y and later - commits already present
> > > > 4.14.y - f5bbbbe4d635 doesn't patch cleanly but it's still
> > > > straightforward, just drop the comment and code mentioning switching
> > > > to 'none' in the trailing context
> > > > 4.9.y - ditto
> > > > 4.4.y - there was a refactoring of the code in commit
> > > > 0bf6cd5b9531bcc29c0a5e504b6ce2984c6fd8d8 making this non-trivial
> > > > 3.16.y - ditto
> > > >
> > > > I am happy to try to produce clean patches, but it may be a day or so.
> > >
> > > I have done this for 4.14.y and 4.9.y, can you please provide a backport
> > > for 4.4.y that I can queue up?
> > >
> > > thanks,
> > >
> > > greg k-h
