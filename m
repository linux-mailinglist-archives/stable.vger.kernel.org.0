Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0079FC97D7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 07:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbfJCFPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 01:15:40 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39456 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfJCFPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 01:15:40 -0400
Received: by mail-io1-f67.google.com with SMTP id a1so2619842ioc.6
        for <stable@vger.kernel.org>; Wed, 02 Oct 2019 22:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=arfiB0rYZ0MPbU7mGGsbcPeLseG6XfgANjMHm5aVa9o=;
        b=vH64tjMIxBBsKDxRwx9JUTYrFGxOz0A3Q7XUMzI9DTXezwRou1nEf233+WuvW3MCoQ
         tLBJiuJsZEURf4pxCizdRxUSK7NLdDANa05crmC3EKZUUHV3mRFk51gM3VC7io1NpjhE
         TQj6FtKkCVk8v8v8f4IB+l/4UgPd+latYHueE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=arfiB0rYZ0MPbU7mGGsbcPeLseG6XfgANjMHm5aVa9o=;
        b=t0eA0jaeBaCUvPQsXyJsKdfhnHuKF5TLaiwtnwSrgpp0i1XDiOe8WWXK9qtpE7FJcM
         MV01qcvoROJplOGZob5vH4l0ebr5h1IeeWu7Wkal271woNeegs3adDWMmdekKoew+qsz
         SV0Gfq+1jBFFbplfVpuJrzsNIolEUO/lg5O44MHp3MPsPcWn9B1rytdcP5Ok2VJTi5zf
         dBmGlxvBs0SY9r8EXI3G8Cc2+fnUBZ9b5iVoB9M8PMumdDhlbbGBwnZc/nRxXIZ4oHrM
         9QXSYZvKJN0nmRr1M9KrBuSKrQIe5F0GKHDB9kIVAxdmDoXy6p+7kuWeO1yJ5EAkm00B
         P9rA==
X-Gm-Message-State: APjAAAXvFkmjr5AqkrONnIZT+Eq5VUJ20TA/zby6taySYau0lddPJfWf
        l6Ac59vLTTsl/t1uolzWz6l3bMsPID83mNxC/HGnVg==
X-Google-Smtp-Source: APXvYqwjR3jr4gTAzVO+/njT3bFHUdfzFNzs0LQJDTdrKZyJXsvBxoLyu1terBvpgiRuc2/01qWoROb3H/82e3gAK+A=
X-Received: by 2002:a92:d847:: with SMTP id h7mr8033316ilq.85.1570079737816;
 Wed, 02 Oct 2019 22:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
 <20190925064414.GA1449297@kroah.com> <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
 <20190927131332.GO8171@sasha-vm>
In-Reply-To: <20190927131332.GO8171@sasha-vm>
From:   Dave Chiluk <chiluk+linux@indeed.com>
Date:   Thu, 3 Oct 2019 00:15:02 -0500
Message-ID: <CAC=E7cVyO=j8FKBKkdOU2KOM_O=3XmXZd0OoyYCDWez_twuk-A@mail.gmail.com>
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage with
 high throttling by removing expiration of cpu-local slices
To:     Greg KH <greg@kroah.com>
Cc:     Ben Segall <bsegall@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

@Greg KH, Qian Cai's compiler warning fix has now been integrated into
Linus' tree as commit: 763a9ec06c409

Both de53fd7aedb1 and 763a9ec06c40 are now apart of v5.4-rc1.  Can you
please queue up these fixes for backport to all stable kernels.

Thank you,
Dave Chiluk

On Fri, Sep 27, 2019 at 8:13 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Fri, Sep 27, 2019 at 01:12:40AM -0500, Dave Chiluk wrote:
> >On Wed, Sep 25, 2019 at 1:44 AM Greg KH <greg@kroah.com> wrote:
> >>
> >> On Wed, Sep 25, 2019 at 12:53:48AM -0500, Dave Chiluk wrote:
> >> > Commit de53fd7aedb1 ("sched/fair: Fix low cpu usage with high
> >> > throttling by removing expiration of cpu-local slices") fixes a major
> >> > performance issue for containerized clouds such as Kubernetes.
> >> >
> >> > Commit de53fd7aedb1 Fixes commit : 512ac999d275 ("sched/fair: Fix
> >> > bandwidth timer clock drift condition").
> >> >
> >> > This should be applied to all stable kernels that applied commit
> >> > 512ac999d275, and should probably be applied to all others as well.
> >>
> >> As this commit isn't in a released kernel just yet, we should wait to
> >> see what happens when it hits people's machines, right?
> >
> >I think waiting till 5.4 is released would be irresponsible on this
> >one.  512ac999 was recently pushed back into many of the distro
>
> The "released kernel" statement means 5.4-rc1 rather than 5.4, which is
> just a few days away.
>
> --
> Thanks,
> Sasha
