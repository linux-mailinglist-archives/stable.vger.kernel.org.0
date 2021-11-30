Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6C4463DBB
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 19:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245413AbhK3SZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 13:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245244AbhK3SZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 13:25:06 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425D8C061574
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 10:21:47 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id p65so3319466iof.3
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 10:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BEltFXULxNYFVsP4eGm3kbct7+jVmIitoqiNJzsq4Rw=;
        b=oVveweJbpqMfac0CI2tRpgA9ovwMDwKpWz4+/sBGm+Eai0m1BWi+FfOOTRJFpUtc9J
         t9/kUK4q/4YG6sWCu+eBdY6AMOT0bbjzCt2gqAvQLmV/gyZhuzh1m/+feYuXSJTiaLb0
         21JBxcCiv8zL/Vb5pjTbJSCCMnH7+ZEG5IcbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BEltFXULxNYFVsP4eGm3kbct7+jVmIitoqiNJzsq4Rw=;
        b=KGT3yHOLcdpnJxP3qszcP3Tz2Erf73X7t7J1/a7BxlD2aXm3YeCK4fGgD9aKmvStq9
         Ksb/5B8UqI2sqS6Oe/Gmfu4k+X+cjQpnl7gfJWbhP7ZbpfqKn/dUQLkI837Ch9B/BpJr
         sopLrMr3XU5CnqffU+Rbsdk8ow76IECwnqrNPECn1RYQQI+Uap0tTu6crQJTxriqx7LC
         U+suys2Cqd6qa5TGw+sYI1BK69UUPPqnLsqrIwgB+DmVJ1NJBbh0AlVHfGACFvRZ3zrz
         xQnU6+P9HNY6nqb/1QVd4T6U51X7xMd1tFaU7iXECFkODFfIlZ+7GSsY0wZKnwsou0sC
         wxGQ==
X-Gm-Message-State: AOAM53022d7zPDRm7WlvCU0Rq1niy2Y+pmlNZo2zfGeseoQzW2z630Kt
        n+CHftbT1oOiYrgxCxEZqhYF2HyzYA7iEQ==
X-Google-Smtp-Source: ABdhPJz4ghragmmWVHzGCGuL0A3fLHx+pErrU8ahCNbD8Mye+oH2ZINpL6k/nGPmb471+daHzzurOQ==
X-Received: by 2002:a05:6638:2484:: with SMTP id x4mr1462843jat.51.1638296506377;
        Tue, 30 Nov 2021 10:21:46 -0800 (PST)
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com. [209.85.166.45])
        by smtp.gmail.com with ESMTPSA id h14sm11374373ild.16.2021.11.30.10.21.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 10:21:46 -0800 (PST)
Received: by mail-io1-f45.google.com with SMTP id v23so27295867iom.12
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 10:21:45 -0800 (PST)
X-Received: by 2002:a6b:d904:: with SMTP id r4mr1204199ioc.52.1638296505145;
 Tue, 30 Nov 2021 10:21:45 -0800 (PST)
MIME-Version: 1.0
References: <20211029122359.1.I1e23f382fbd8beb19fe1c06d70798b292012c57a@changeid>
 <CAE=gft4MRvq-VCBW4EX4dGfPi4s7Lco8h6Z_ejRH5A1e-K2-yA@mail.gmail.com>
 <CAJZ5v0hsGFHxcTb8PUkGSm9oas1wdquB=euofS19zriRc1CXYw@mail.gmail.com>
 <CAE=gft6CjUhkcrmcjVEOp5S+rgqN1_ZGTKbK0DierTanu0d16A@mail.gmail.com>
 <CAJZ5v0gamixc4dkBEXJjjw5zQynuz8BkQ9xv8YpbjkTkdMb2TQ@mail.gmail.com>
 <CAE=gft6o0JxhDgazPA5DVbL6hQ+36D_GkzgN-AuR3YA43NSqaw@mail.gmail.com> <CAJZ5v0ixOCnT_JyQ1gpvc9rdH_zK7gLrke0wJSLUagd=-qf0sA@mail.gmail.com>
In-Reply-To: <CAJZ5v0ixOCnT_JyQ1gpvc9rdH_zK7gLrke0wJSLUagd=-qf0sA@mail.gmail.com>
From:   Evan Green <evgreen@chromium.org>
Date:   Tue, 30 Nov 2021 09:44:02 -0800
X-Gmail-Original-Message-ID: <CAE=gft7WjMJb1NUUrusoaP4YRiz5Sbsb898Yi_ekJTFCBFz_ng@mail.gmail.com>
Message-ID: <CAE=gft7WjMJb1NUUrusoaP4YRiz5Sbsb898Yi_ekJTFCBFz_ng@mail.gmail.com>
Subject: Re: [PATCH] PM / hibernate: Fix snapshot partial write lengths
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 30, 2021 at 3:46 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Mon, Nov 29, 2021 at 5:50 PM Evan Green <evgreen@chromium.org> wrote:
> >
> > On Wed, Nov 24, 2021 at 4:54 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > >
> > > On Tue, Nov 16, 2021 at 9:22 PM Evan Green <evgreen@chromium.org> wrote:
> > > >
> > > > On Tue, Nov 16, 2021 at 9:54 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > > >
> > > > > On Mon, Nov 15, 2021 at 6:13 PM Evan Green <evgreen@chromium.org> wrote:
> > > > > >
> > > > > > Gentle bump.
> > > > > >
> > > > > >
> > > > > > On Fri, Oct 29, 2021 at 12:24 PM Evan Green <evgreen@chromium.org> wrote:
> > > > > > >
> > > > > > > snapshot_write() is inappropriately limiting the amount of data that can
> > > > > > > be written in cases where a partial page has already been written. For
> > > > > > > example, one would expect to be able to write 1 byte, then 4095 bytes to
> > > > > > > the snapshot device, and have both of those complete fully (since now
> > > > > > > we're aligned to a page again). But what ends up happening is we write 1
> > > > > > > byte, then 4094/4095 bytes complete successfully.
> > > > > > >
> > > > > > > The reason is that simple_write_to_buffer()'s second argument is the
> > > > > > > total size of the buffer, not the size of the buffer minus the offset.
> > > > > > > Since simple_write_to_buffer() accounts for the offset in its
> > > > > > > implementation, snapshot_write() can just pass the full page size
> > > > > > > directly down.
> > > > > > >
> > > > > > > Signed-off-by: Evan Green <evgreen@chromium.org>
> > > > > > > ---
> > > > > > >
> > > > > > >  kernel/power/user.c | 2 +-
> > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/kernel/power/user.c b/kernel/power/user.c
> > > > > > > index 740723bb388524..ad241b4ff64c58 100644
> > > > > > > --- a/kernel/power/user.c
> > > > > > > +++ b/kernel/power/user.c
> > > > > > > @@ -177,7 +177,7 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
> > > > > > >                 if (res <= 0)
> > > > > > >                         goto unlock;
> > > > > > >         } else {
> > > > > > > -               res = PAGE_SIZE - pg_offp;
> > > > > > > +               res = PAGE_SIZE;
> > > > > > >         }
> > > > > > >
> > > > > > >         if (!data_of(data->handle)) {
> > > > > > > --
> > > > >
> > > > > Do you actually see this problem in practice?
> > > >
> > > > Yes. I may fire up another thread to explain why I'm stuck doing a
> > > > partial page write, and how I might be able to stop doing that in the
> > > > future with some kernel help. But either way, this is a bug.
> > >
> > > OK, patch applied as 5.16-rc material.
> > >
> > > I guess it should go into -stable kernels too?
> >
> > Yes, putting it into -stable would make sense also. I should have CCed
> > them originally, doing that now.
>
> Well, you need to point them to the upstream commit to backport.
>
> In this particular case it would be
>
> commit 88a5045f176b78c33a269a30a7b146e99c550bd9 (pm-sleep)
> Author: Evan Green <evgreen@chromium.org>
> Date:   Fri Oct 29 12:24:22 2021 -0700
>
>    PM: hibernate: Fix snapshot partial write lengths
>
> I'll send an inclusion request for this.  I guess it should go into
> all of the applicable -stable series, right?

Correct. From what I can tell this code and simple_write_to_buffer()
haven't changed since its introduction in 2010, so my patch should
have had a fixes tag like:

Fixes: d3c1b24c50e8 ("PM / Hibernate: Snapshot cleanup")

Thanks for doing that Rafael, sorry for flubbing the stable aspect.

-Evan
