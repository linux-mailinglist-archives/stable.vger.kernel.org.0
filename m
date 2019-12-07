Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847CB115AAA
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 02:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfLGBrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 20:47:25 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42769 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfLGBrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 20:47:25 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so9720671wrf.9
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 17:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bXoFYxa/HU0l3UTgbmHzvOXU9PixllEMC1k6yIvx6bQ=;
        b=Gi88g4P3H/COiZ9qZX2Sms6efUljo4YTH0oGUc/GZUzhkFpp/SFZuQ5mxjzu2LxHUB
         rlWwTlIPMXC18vdbqk4DC9osCKNmmIlZfOTkDnbHa/W81D59FKuof1G+O8GIZ1+uX+mm
         VlLEjS2x0ubJylolyODaNILdJOXDs7ssBCXF1STTvWcaK9LRBK448RYjndTbgBRuXY/i
         0H8DUQNpsjHgLQym4+15twOII8rQQktKYLJuwfys8oDLPwnBF0aOXNxu29UzcLYil7jS
         9jYZh+6Fj1mwD7JOuz+zFTJTYcyQZw82cDD3TbND2mX/p8Qb1KkU9i1CcmR4MKR9uFGL
         cTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bXoFYxa/HU0l3UTgbmHzvOXU9PixllEMC1k6yIvx6bQ=;
        b=p69p/kfcVnJwe8D4xfgIMQre/EzIYsRO0aIzYYkBnF0uiVEk9K6DH87x8/Ouc7Tj0N
         O656xYmP77Trn1+ceyCQe0UQsR9sq8G+8buWvMKtTj9AgLIMmBk9OveYyHWgEHENVGIa
         WlYMn/oiuzrUOORX9vBjj4dG2f1j6Ch7VadPdDH5ClxzyIlfkcp0TN6zPXepDT3cqlx6
         Vcj3iBqw0g3isEP1hj+OT0liUjzry/IwcNtKonwSKq7p9gxnXl4YVuo0yLZnf/iFJQP9
         4AFo+6IX12r8FFxL1XVD4mPFHGRYsk+spAPQSVHTFl+f0UPoi1uRNB/iOEvyTmGSJvxn
         pPSg==
X-Gm-Message-State: APjAAAUIb+YJVsgrOhzTizxSBVuA8k0NrlZfumK/jctd7OxwN9jibsvv
        M6UPjZDtOSrSrxoYnJ2ZrG9B5Rnhzl9V77qhQvSavA==
X-Google-Smtp-Source: APXvYqzpsu8pMlezons2FdoBiJmLg9xwrSGR+0LHuVtKc7ddtAMB+Iwa0AJbraOGRYbUb3JC6DkXHb3UvIIAHLBrF9c=
X-Received: by 2002:a5d:4392:: with SMTP id i18mr19272317wrq.199.1575683241240;
 Fri, 06 Dec 2019 17:47:21 -0800 (PST)
MIME-Version: 1.0
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com> <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
 <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com> <20191206141129.GA9376@kroah.com>
In-Reply-To: <20191206141129.GA9376@kroah.com>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Fri, 6 Dec 2019 17:47:10 -0800
Message-ID: <CAPtwhKrZwkp_wmW38ks23ssqn3GShto_tfAL=jTU_Tiy97c-ZQ@mail.gmail.com>
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 6, 2019 at 6:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 03, 2019 at 03:30:05PM -0800, Xuewei Zhang wrote:
> > Backport patch that cleanly applies for 4.19, 4.14, 4.9, 4.4 stable trees:
>
> Did you send this twice?

Yes, sorry it's by accident.

>
> And the patch is totally corrupted:
>
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index f77fcd37b226..f0abb8fe0ae9 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4868,20 +4868,28 @@ static enum hrtimer_restart
> > sched_cfs_period_timer(struct hrtimer *timer)
> >   if (++count > 3) {
> >   u64 new, old = ktime_to_ns(cfs_b->period);
> >
> > - new = (old * 147) / 128; /* ~115% */
> > - new = min(new, max_cfs_quota_period);
> > -
> > - cfs_b->period = ns_to_ktime(new);
> > -
>
> All of your leading whitespace is gone.
>
> You can't use the web client of gmail to send patches inline, sorry.
>
> Can you fix this up and resend all of the backports, none of these
> worked :(

Sorry for the formatting problem Greg.

I just used `git send-email` to sent out the backports. They are at:
v4.19: https://www.spinics.net/lists/stable/msg347573.html
v4.14: https://www.spinics.net/lists/stable/msg347576.html
v4.9: https://www.spinics.net/lists/stable/msg347577.html
v4.4: https://www.spinics.net/lists/stable/msg347578.html
v3.16: https://www.spinics.net/lists/stable/msg347579.html

Hopefully that could work for you. But if they are still broken somehow
(for which I'd be very sorry), you could consider cherry-picking the patch
from my Github repository (forked from yours):

v4.19: https://github.com/xueweiz/linux/commit/1f2c7fd411a4c332629338571911ae63d3804d0e
v4.14: https://github.com/xueweiz/linux/commit/ccec07bf7842d7ab859fdbbfb79781028e0c1f0d
v4.9: https://github.com/xueweiz/linux/commit/548cd3b8d6a1e663d4a5870daee45f236d75322e
v4.4: https://github.com/xueweiz/linux/commit/1d3b43c3c6612901f5384b8ced4e733072175721
v3.16: https://github.com/xueweiz/linux/commit/f31487e819b78515b3173145d13265b746c72815

Each commit is already based on the current HEAD of the respective branches
in your stable kernel repo.

Please let me know if they still don't work.

Best regards,
Xuewei

>
> greg k-h
