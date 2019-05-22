Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C8025B2E
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 02:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfEVAfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 20:35:51 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:33912 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfEVAfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 20:35:51 -0400
Received: by mail-it1-f194.google.com with SMTP id g23so4095086iti.1;
        Tue, 21 May 2019 17:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dmn24KC+m6x18zOYziZWDo5rYFdprsz28GNXc60VqcM=;
        b=Et3SEPfqDEkMJQkdWI5NcbgBXFwSnmgc4IkpkyXuP/wF0TfGB6e1Pofok9i3gQVCdC
         41wcVBJIud8W8bHbEYF6lYxT7DfMeuDvr8KHC10JS69ZipKHxoLbas7ffdXmSFC2dLWZ
         4bN2MC0kFc2EOqpUsixIw6zd78MsPnS55mIhw0opNmNKfSNukaHmnnGdD3ZQH4VFykRW
         J8Hi0Mz3vPUcCJRgdQhxjUFgnOqxI+rry97EhQ+7EsjThzESIYE/9TZ0xRWyjvElLGen
         EafVNr3LpPZ9kutDJWNTeUD89h0GEuriOYD20CZRoqD3aeVsFh6X6Tqw433QgGcu3kJa
         D+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dmn24KC+m6x18zOYziZWDo5rYFdprsz28GNXc60VqcM=;
        b=o1lL7xMdPRrJzUhduox4MahqrF2zhI3RgUvvYVN4kzXacUvxrk58w/1sho1o4OvO3/
         7WKA9UUZudGldE9eeVUIwXxTeAOR6PvRKsa9WfkIf7+wAQWuECNJFTM82HL4FPDfwmPS
         1MYPdcmSFVw+97vCsl3CmUG9Pg2s5wwjF8FKEsw2RIrGfYCKJNulLtKd/QnjiRQIx5XA
         xBsj6nK/sEdo9eD14nRRBtm9zPPWQxmd0xEDRuWAtkewGhr8lz+RPYk3Yb61r3LkfDAM
         WJjB10LxQ0BSE4JYlA74LruoYujePK2H44ZWduPm6ldCDqP0R5UFWZPPAI25e/UwOsFt
         6Cdw==
X-Gm-Message-State: APjAAAVBCdNGVzI7qxRiLr4UdjLTJV5BN0xpV/lNXhBHQAjIOYLFmFqC
        4uOJDL8gRtcjR/Nelple2xNZDhPQ03gHxAmlKFXNwJjb
X-Google-Smtp-Source: APXvYqyhSur7RLYxkPauMes6/6zkMTMY5/tOriifV/CCLRD7QPPwvlQNLkfOoChDXo2OFZFy/GRDNWQ0C4EnMYOBZhM=
X-Received: by 2002:a02:94e7:: with SMTP id x94mr21163035jah.5.1558485350392;
 Tue, 21 May 2019 17:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190507043954.9020-1-deepa.kernel@gmail.com> <20190521092551.fwtb6recko3tahwj@dcvr>
 <20190521152748.6b4cd70cf83a1183caa6aae7@linux-foundation.org> <20190521233319.GA17957@dcvr>
In-Reply-To: <20190521233319.GA17957@dcvr>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Tue, 21 May 2019 17:35:38 -0700
Message-ID: <CABeXuvoOGwOGmSz_vgTugLD1NPE=2ULvmESPTtK9d6r8S+WVdQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] signal: Adjust error codes according to restore_user_sigmask()
To:     Eric Wong <e@80x24.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, dbueso@suse.de, axboe@kernel.dk,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > > It's been 2 weeks and this fix hasn't appeared in mmots / mmotm.
> > > I also noticed it's missing Cc: for stable@ (below)
> >
> > Why is a -stable backport needed?  I see some talk above about lost
> > signals but it is unclear whether these are being observed after fixing
> > the regression caused by 854a6ed56839a.
>
> I guess Deepa's commit messages wasn't clear...
> I suggest prepending this as the first paragraph to Deepa's
> original message:
>
>   This fixes a bug introduced with 854a6ed56839a which caused
>   EINTR to not be reported to userspace on epoll_pwait.  Failure
>   to report EINTR to userspace caused problems with user code
>   which relies on EINTR to run signal handlers.

This is not what the patch fixed.

The notable change is userspace is that now whenever a signal is
delivered, the return value is adjusted to reflect the signal
delivery.
Prior to this patch, there was a window, however small it might have
been, when the signal was delivered but the errono was not adjusted
appropriately.
This is because of the regression caused by 854a6ed56839a, which
extended the window of delivery of signals that was delivered to
userspace.
The patch also fixes more than sys_epoll_pwait().

I will post a follow up patch.

>
> > IOW, can we please have a changelog which has a clear and complete
> > description of the user-visible effects of the change.
> >
> > And please Cc Oleg.

I will cc Oleg.
