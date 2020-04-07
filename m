Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0471A1168
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 18:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgDGQcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 12:32:04 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38639 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgDGQcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 12:32:04 -0400
Received: by mail-io1-f66.google.com with SMTP id e79so4027092iof.5
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 09:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9qozCo0g6DTPWnm+nziFFnw+X2X0ZN+yY9IUp6m4q4U=;
        b=Uah+xIOn9wpwKhnvPE5jUvhL2NIPZo+2V9rVebm4So00+on57nbm/iGnasgqaAsa5i
         9R9YnZaX42msDPwKp+KaMT4S74bm/zPC2hWSuECwp35kxkRmp+nG0JIbKZR9FepiekZw
         MBifJTT64ylEXmLlZkBCf+78pq1yWGewAnTUPmKf2qZOFSf1JrKLt3nYAPvEHny4zVL7
         ghCaVRzzhVHQ3J41leK/295+7THr68M3AV2AssAlBrkd3O7YoHmYPlko/Z4Jr5t8elOB
         Zlcit7dQznAjaI0yNv+54IYEQvuhkyklVcubvo5yuEUFH5xgUicxsvY9qzZbACTvZK3h
         rMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9qozCo0g6DTPWnm+nziFFnw+X2X0ZN+yY9IUp6m4q4U=;
        b=fEtzOowTDIrzebNjromuUsoLH/85EbBJon3VdE3O9z4i5QiVUk4QrsutLZ4eNrNwMS
         H9jZvJ6CPoFqVe8O/5K5WxE04I4jszGLAbyxWGd9Tm0Uc69Z/bDaYZFdIjYQ5pNKADZc
         reN6xz3cjWOhiPBUuu5OQMVeMKFEFPLtnZTtkTw37QPaq2bXCHgTjFmMIHR1v4NLzFXl
         PcfDkGMATgfY3Au6PDn56kcIUs8EQuDySQiK1dwaQ7OG9F+d/sgrLws7KZmmTLstIDTs
         9fJZmdhDoobpxpzsm+9RBgBOQhiH0QlfCnzJevqvsN9+5PQfGiTNHXUBCdsSOuHQBrYY
         xsIA==
X-Gm-Message-State: AGi0PubQ6nntXoUK/hyp892IZomkdR49fGZ00r52V04xnbVOF0qTZXTF
        mBTmQpR2Li02aS2veSYxH9O3MQyq9+pRhyhk2PFI7w==
X-Google-Smtp-Source: APiQypKDecBW4VRPvV6oA3ouBnZe/R+6npUYGO1Js9O1l17if7iBFDwGrM+CBN0kNPH0GGueGpEH7qGNJadHPYAFaOU=
X-Received: by 2002:a6b:3883:: with SMTP id f125mr1649425ioa.92.1586277122932;
 Tue, 07 Apr 2020 09:32:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAGvU0HkVUE_mQY8AUjieRcRrD38gdJRE+CbDuenMxnU6DAFOSA@mail.gmail.com>
 <20200403092032.GE3740897@kroah.com> <CAGvU0H=+KrQRV7SUkVjWudKi7i1LqmGheRfVofKDV0i8Qgd=bg@mail.gmail.com>
In-Reply-To: <CAGvU0H=+KrQRV7SUkVjWudKi7i1LqmGheRfVofKDV0i8Qgd=bg@mail.gmail.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Tue, 7 Apr 2020 17:31:46 +0100
Message-ID: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Subject: Re: backport request for use-after-free blk_mq_queue_tag_busy_iter
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg.

On Fri, 3 Apr 2020 at 23:30, Giuliano Procida <gprocida@google.com> wrote:
>
> Hi Greg.
>
> I also have 4.14 and 4.9, I'll send them on for comparison.

I've done this.

> I will try 4.4 but, as one call site doesn't exist and the other
> didn't have any locking to start with, I'd like to try to reproduce
> the issue first.

I have failed to build a bootable 4.4 kernel which is surprising /
embarrassing, as my current toolchain (even after working around
various known issues) compiles kernels that either panic or
triple-fault (apparently, as there's no log output, just a reboot) on
my amd64 hardware. Running an old live distribution with a 4.4 kernel,
I wasn't able to reproduce the issue apparently resolved by these
fixes after several hours of running.

I've also spent most of 2 days looking at unfamiliar code.

The code in 4.4 uses a timer instead of a workqueue for timeout
callbacks. The callbacks have also have blk_queue_enter/exit
protection in 4.9 but not 4.4. I'm guessing, but don't know, that the
execution contexts are sufficiently similar between timers and
workqueues that this protection should be back-ported to 4.4. This is
relatively simple, it's bits of a couple of extra commits.

f5bbbbe4d635 adds to blk_mq_queue_tag_busy_iter an RCU-protected test
to see if the blk_queue is held before doing any work. It also adds
RCU synchronisation to code that manipulates the number of hardware
queues. The follow-up 530ca2c9bd more sensibly just (possibly
recursively) does try-to-enter/exit instead. 4.4 doesn't have code
that manipulates the number of hardware queues. However, the
blk_mq_queue_tag_busy_iter locking may be enough to prevent
ioctl/procfs concurrency.

To this end, I've put together patches for 4.4. They are completely
untested. Once I've verified they actually compile I'll send them on.

Giuliano.

> I should have some spare time for this soon.
>
> Giuilano.
>
> On Fri, 3 Apr 2020 at 10:20, Greg KH <greg@kroah.com> wrote:
> >
> > On Wed, Apr 01, 2020 at 05:47:02PM +0000, Giuliano Procida wrote:
> > > This issue was found in 4.14 and is present in earlier kernels.
> > >
> > > Please backport
> > >
> > > f5bbbbe4d635 blk-mq: sync the update nr_hw_queues with
> > > blk_mq_queue_tag_busy_iter
> > > 530ca2c9bd69 blk-mq: Allow blocking queue tag iter callbacks
> > >
> > > onto the stable branches that don't have these. The second is a fix
> > > for the first. Thank you.
> > >
> > > 4.19.y and later - commits already present
> > > 4.14.y - f5bbbbe4d635 doesn't patch cleanly but it's still
> > > straightforward, just drop the comment and code mentioning switching
> > > to 'none' in the trailing context
> > > 4.9.y - ditto
> > > 4.4.y - there was a refactoring of the code in commit
> > > 0bf6cd5b9531bcc29c0a5e504b6ce2984c6fd8d8 making this non-trivial
> > > 3.16.y - ditto
> > >
> > > I am happy to try to produce clean patches, but it may be a day or so.
> >
> > I have done this for 4.14.y and 4.9.y, can you please provide a backport
> > for 4.4.y that I can queue up?
> >
> > thanks,
> >
> > greg k-h
