Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A689F115E3D
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 20:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfLGTf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 14:35:59 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37724 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLGTf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 14:35:58 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so10817350wmf.2
        for <stable@vger.kernel.org>; Sat, 07 Dec 2019 11:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cc/Vjbp7XQWFqTXGN3KZGw/OSdP5UCTgCgtGpCIWEfo=;
        b=Q+9W/4Ttx/2ByC7bGbm65PwHbDDZ2xrG5qkJ6a3N/qVc514hwWWOdxu7IZ3B85iJli
         O6jxYH0s26zP+oF+COGGQDqMtpDbKRm3wx00Du+fzV+Ly2Wwf2xEbUlh11XQEPtqaHx1
         3dFwoEMrW/LH8otNOX5ES2wIk+91Pe2aa3w+6f1pkAN8V06TXhTEvK6sjaDcUVNGqgKI
         eFuyoUwQbmxOECu/e9A5UyZNJCIvAU7FZGA+10F0vVcnWCXLmBdYG1WCxUdfY7ck1qqt
         kbI3ikf/KGmjV3HPAwNfDLhtaoS2guWNbFtWlofFs81jWuddRlb36vixKNdr8WropU9U
         A9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cc/Vjbp7XQWFqTXGN3KZGw/OSdP5UCTgCgtGpCIWEfo=;
        b=L2U5PZDdyI90+BX/saTehAJCy5/XegWMi+t/F3pVTRIEEoF4CzcwqJnHtWb4zML1MV
         be2DAOXY8EfRhTVQDBxeiFzurk5eiflwbM+FWE6w7fUuR4CF9F4c8yhEc79/vsYn+DVi
         gehYyHqFLn9HfsEPZlVvHjk0A4PXhQV7Jux0j+IFy99uKjAzh7mlMV6m5sWOXsyA7w6P
         aqr2ZEeUUXDjiDPVa7fWah+vt0AvKXe5qlgYALp3VYvm+vUhgg4hEO1uCj0L2xuThquL
         KId8kUTVhZ3YNPb5mFhTVGi34LqadGnYIIg9CAQtLSawuxMzGA6gFgYG3ktt2F6Qor3j
         QQJg==
X-Gm-Message-State: APjAAAWh72+dcrClXVNE5OKJgixbowv62oalOgge003NdgXgI5puLRFI
        mbL5TmuPS5HiabfioENBoLDrBo7RqneOA7ECSGtpGg==
X-Google-Smtp-Source: APXvYqzkkIYIVovRJ1tNWJwyYc7GVj7Og3P0rUAhUjo0TlA/IlLeL0auMRaYOWqaaSavw/emLXnuKFCw6Ftqd60VuA8=
X-Received: by 2002:a7b:c113:: with SMTP id w19mr16263068wmi.144.1575747356586;
 Sat, 07 Dec 2019 11:35:56 -0800 (PST)
MIME-Version: 1.0
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com> <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
 <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
 <20191206141129.GA9376@kroah.com> <CAPtwhKrZwkp_wmW38ks23ssqn3GShto_tfAL=jTU_Tiy97c-ZQ@mail.gmail.com>
 <20191207115754.GB325082@kroah.com>
In-Reply-To: <20191207115754.GB325082@kroah.com>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Sat, 7 Dec 2019 11:35:44 -0800
Message-ID: <CAPtwhKpi2OX4D1w3ncnnQV5fNeTfnhYcYN0YghLhpXPYWePbyg@mail.gmail.com>
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 7, 2019 at 3:57 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Dec 06, 2019 at 05:47:10PM -0800, Xuewei Zhang wrote:
> > On Fri, Dec 6, 2019 at 6:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Dec 03, 2019 at 03:30:05PM -0800, Xuewei Zhang wrote:
> > > > Backport patch that cleanly applies for 4.19, 4.14, 4.9, 4.4 stable trees:
> > >
> > > Did you send this twice?
> >
> > Yes, sorry it's by accident.
> >
> > >
> > > And the patch is totally corrupted:
> > >
> > > > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > > > index f77fcd37b226..f0abb8fe0ae9 100644
> > > > --- a/kernel/sched/fair.c
> > > > +++ b/kernel/sched/fair.c
> > > > @@ -4868,20 +4868,28 @@ static enum hrtimer_restart
> > > > sched_cfs_period_timer(struct hrtimer *timer)
> > > >   if (++count > 3) {
> > > >   u64 new, old = ktime_to_ns(cfs_b->period);
> > > >
> > > > - new = (old * 147) / 128; /* ~115% */
> > > > - new = min(new, max_cfs_quota_period);
> > > > -
> > > > - cfs_b->period = ns_to_ktime(new);
> > > > -
> > >
> > > All of your leading whitespace is gone.
> > >
> > > You can't use the web client of gmail to send patches inline, sorry.
> > >
> > > Can you fix this up and resend all of the backports, none of these
> > > worked :(
> >
> > Sorry for the formatting problem Greg.
> >
> > I just used `git send-email` to sent out the backports. They are at:
> > v4.19: https://www.spinics.net/lists/stable/msg347573.html
> > v4.14: https://www.spinics.net/lists/stable/msg347576.html
> > v4.9: https://www.spinics.net/lists/stable/msg347577.html
> > v4.4: https://www.spinics.net/lists/stable/msg347578.html
> > v3.16: https://www.spinics.net/lists/stable/msg347579.html
> >
> > Hopefully that could work for you. But if they are still broken somehow
> > (for which I'd be very sorry), you could consider cherry-picking the patch
> > from my Github repository (forked from yours):
>
> Those worked just fine from the emails you just sent (note, try using
> lore.kernel.org instead of other mail archives, as I could not pull a
> patch out of spinics.net).
>
> I'll let Ben take the 3.16 version, as he handles that tree.
>
> thanks,
>
> greg k-h

Thanks a lot Greg!

I will use lore.kernel.org next time. Thanks for the tips!

Best regards,
Xuewei
