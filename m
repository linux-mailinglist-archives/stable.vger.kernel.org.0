Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEDB32C84C
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383283AbhCDAfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348472AbhCDAKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 19:10:44 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948D1C0610D1
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 16:04:09 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id u18so17392849ljd.3
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 16:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ceup2ELLjDnFJ06fQQ0lsYthFUpucW8YYDBv0vOH6+k=;
        b=f8BsBaBJ2vWqpGhz4HPJDO9IjoyxHuvG5ptqH1W/xcRA5gyR+8lLKjqWGSeXDNuWFU
         eCiqY+xK6fw7ZF3MvGxyI3fOx0eVUb8ppZiqipJliZb4szya0eYHzm78aOGmBACkKH6w
         NDHbSqQEfPvMFLVz2VDkgXNH2W8UxUt6njwak+RccGTrHFtwWBLBXXvpQmQzZWN+0yka
         XHTXR7FtqCU5/xiV4ET7/xw3Xcqi+NsxF8h49IuCgSl7/W/ud6ntWrjDMUpRywaD/B53
         Q/YBlQAS1o1DEBglU+5hlbHogKectpiSzN15zBPuRRFB1ybW/1+f+US1v71Z0OAoDnAH
         AaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ceup2ELLjDnFJ06fQQ0lsYthFUpucW8YYDBv0vOH6+k=;
        b=SqWwJniDFMw89Mf4wr5a2kvWC/0y+usYlUkBZ/pBl4IA5KH11LZQ1fJNHTXBRQFvbH
         /0Plab02G13ECN4xtk8FdMDz+emXYuexoeUgIPytF+vJYBSQxgrQi9qEWFvxfbmuTDMB
         hKBOGVrBgoCUXdpKaxPKD8P4ZhgklIhRabBt4T2uclMgjTND5iO6TTnl2dqaQAe/lEA8
         48X9HzB3HbkhLUk+weEK/cWdPCqD/AnznysF18g0NjL2l7l3el/OFDJrvFK0BgdkiqGl
         sfYvn0rePUYUdu6pTKIpjJQ7VNUd+o7TrwkJ0vuSqgz4bcwYx2u9/90bgV+rbJ2Y05zJ
         pVTw==
X-Gm-Message-State: AOAM533DXNim8+OO2Rq2QPvXfFbI7bG55coTP7ZHyVX7Icp7mhBEDyjV
        bnlQBjXMXJx0gxTpZl8L+PlUAi6IFzbqNisQ7xvsaA==
X-Google-Smtp-Source: ABdhPJx2weRFbxLQLgFWRtqxUg2Q6QYYcT532fje/GyefK5aUQavlXnREOanXtDpYaJAYez4mwGpwXy04sK2G8mQxAY=
X-Received: by 2002:a2e:9c0b:: with SMTP id s11mr797879lji.122.1614816247794;
 Wed, 03 Mar 2021 16:04:07 -0800 (PST)
MIME-Version: 1.0
References: <20210303185807.2160264-1-surenb@google.com> <CALvZod73Uem8jzP3QQdQ6waXbx80UUOTJQS7WBwnmaCdq++8xw@mail.gmail.com>
 <CAJuCfpFgDRezmQMjCajXzBp86UbMLMJbqEaeo0_J+pneZ5XOgg@mail.gmail.com>
In-Reply-To: <CAJuCfpFgDRezmQMjCajXzBp86UbMLMJbqEaeo0_J+pneZ5XOgg@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 3 Mar 2021 16:03:54 -0800
Message-ID: <CALvZod4nZ6W05N-4ostUEz5EbCuEvuBpc4LRYfAFgwQU-wb9dQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mm/madvise: replace ptrace attach requirement for process_madvise
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?Q?Edgar_Arriaga_Garc=C3=ADa?= <edgararriaga@google.com>,
        Tim Murray <timmurray@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        James Morris <jmorris@namei.org>,
        Linux MM <linux-mm@kvack.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 3, 2021 at 3:34 PM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Wed, Mar 3, 2021 at 3:17 PM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Wed, Mar 3, 2021 at 10:58 AM Suren Baghdasaryan <surenb@google.com> wrote:
> > >
> > > process_madvise currently requires ptrace attach capability.
> > > PTRACE_MODE_ATTACH gives one process complete control over another
> > > process. It effectively removes the security boundary between the
> > > two processes (in one direction). Granting ptrace attach capability
> > > even to a system process is considered dangerous since it creates an
> > > attack surface. This severely limits the usage of this API.
> > > The operations process_madvise can perform do not affect the correctness
> > > of the operation of the target process; they only affect where the data
> > > is physically located (and therefore, how fast it can be accessed).
> > > What we want is the ability for one process to influence another process
> > > in order to optimize performance across the entire system while leaving
> > > the security boundary intact.
> > > Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ
> > > and CAP_SYS_NICE. PTRACE_MODE_READ to prevent leaking ASLR metadata
> > > and CAP_SYS_NICE for influencing process performance.
> > >
> > > Cc: stable@vger.kernel.org # 5.10+
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > > Acked-by: Minchan Kim <minchan@kernel.org>
> > > Acked-by: David Rientjes <rientjes@google.com>
> > > ---
> > > changes in v3
> > > - Added Reviewed-by: Kees Cook <keescook@chromium.org>
> > > - Created man page for process_madvise per Andrew's request: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=a144f458bad476a3358e3a45023789cb7bb9f993
> > > - cc'ed stable@vger.kernel.org # 5.10+ per Andrew's request
> > > - cc'ed linux-security-module@vger.kernel.org per James Morris's request
> > >
> > >  mm/madvise.c | 13 ++++++++++++-
> > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > index df692d2e35d4..01fef79ac761 100644
> > > --- a/mm/madvise.c
> > > +++ b/mm/madvise.c
> > > @@ -1198,12 +1198,22 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
> > >                 goto release_task;
> > >         }
> > >
> > > -       mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
> > > +       /* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
> > > +       mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
> > >         if (IS_ERR_OR_NULL(mm)) {
> > >                 ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
> > >                 goto release_task;
> > >         }
> > >
> > > +       /*
> > > +        * Require CAP_SYS_NICE for influencing process performance. Note that
> > > +        * only non-destructive hints are currently supported.
> >
> > How is non-destructive defined? Is MADV_DONTNEED non-destructive?
>
> Non-destructive in this context means the data is not lost and can be
> recovered. I follow the logic described in
> https://lwn.net/Articles/794704/ where Minchan was introducing
> MADV_COLD and MADV_PAGEOUT as non-destructive versions of MADV_FREE
> and MADV_DONTNEED. Following that logic, MADV_FREE and MADV_DONTNEED
> would be considered destructive hints.
> Note that process_madvise_behavior_valid() allows only MADV_COLD and
> MADV_PAGEOUT at the moment, which are both non-destructive.
>

There is a plan to support MADV_DONTNEED for this syscall. Do we need
to change these access checks again with that support?
