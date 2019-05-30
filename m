Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BE83007F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 18:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfE3Q7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 12:59:20 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:51836 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Q7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 12:59:19 -0400
Received: by mail-it1-f195.google.com with SMTP id m3so11099500itl.1;
        Thu, 30 May 2019 09:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pnobng2gi3rGJg7lXjPJmItCYfW7DKyQeE9acJ+cdtU=;
        b=stBVtq2ifj+amgGeFGtMkDBmRyAt4VYbME5ABSMYsmEEUGPwQRZUs0Lq02rdfc/ARr
         QlJ//UHU2yERD9GqwdwV4Kg0Ehts8XeFoXusWp9nPNVWp6e0k+556ZqRhdOWQtkiN6gS
         v+SZpdzk14Ja+j4/fPjIzuQ3MeC8BqH6k2+0WRltWQ7CodeiTuPIvMQsOBf4Ee6806K/
         b10b+vo1cuk93M3HBsiVxsOBvIg1zOUX6Q08aSsJq3hHD7YZUtZYyu8bQ6Rcdst2Mkjp
         zjUADoH/veZOtEg7UqvSxSpjPOqEeKi/AlfJZZrY9/o3hUJejeI6hIU8gMQNsunvxbwo
         JNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pnobng2gi3rGJg7lXjPJmItCYfW7DKyQeE9acJ+cdtU=;
        b=rEF6ReIBI32UR/Opqs7YjXjuBexsgw8HysCIo1z2PmOFtiLeTyWnpYhLA3H6f9g4+X
         LbrFGZAZvlQVLs3hLq6VDwxpz6FTpoZmHeTgUeXuus8RXvkeCDl/GoPkuaQ+aw0g78Ff
         whKmpsT+HRWpwPCxYE8+1zsiTOZWWVzEH8NWoFbOrUzjX2a0OHPkZ25YPo7mEiM/dl+9
         xzd0DJEvZ3U/RnK4AXU4A5d2TzYJCqSLAinbM5lEOFa5WJ6tx2YrL3g70p/zffoXeYH2
         0mJ80ZA0ojKUOrj069zgrKSl+esizGgau5137+leqX3S9Cl5i2R7D6tdVnCltdPjvL/A
         Ax6A==
X-Gm-Message-State: APjAAAUEbPvhl0hpSh5+1y+4zyuOSklBR6Y76eYZ6EmsMNGZ4tR7nRVJ
        BC6qVbhITaTF+mC1SkrMxJppoVE2ayuBzR0/WV8=
X-Google-Smtp-Source: APXvYqxjoDHIfEGfCFMFLMpPgv+YNiv3xf18azNUb7eYdVVXA2udc6ppfyaqiDURJX8QX96FxMl5W2yWNB0YB1Bee2Y=
X-Received: by 2002:a02:bb83:: with SMTP id g3mr3158555jan.139.1559235558647;
 Thu, 30 May 2019 09:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <87woi8rt96.fsf@xmission.com>
 <871s0grlzo.fsf@xmission.com> <CABeXuvoRmWXVk3KTKO3MLoLxxw7TU2G1YQVOe_ATAqBkjcROsA@mail.gmail.com>
In-Reply-To: <CABeXuvoRmWXVk3KTKO3MLoLxxw7TU2G1YQVOe_ATAqBkjcROsA@mail.gmail.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Thu, 30 May 2019 09:59:08 -0700
Message-ID: <CABeXuvq12z3PFYpNXjNPSCp7pYmoT90pC0BdugPiw-0k22J4NQ@mail.gmail.com>
Subject: Re: pselect/etc semantics
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, dbueso@suse.de, axboe@kernel.dk,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 8:48 AM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>
> > On May 30, 2019, at 8:38 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> > ebiederm@xmission.com (Eric W. Biederman) writes:
> >
> >> Which means I believe we have a semantically valid change in behavior
> >> that is causing a regression.
> >
> > I haven't made a survey of all of the functions yet but
> > fucntions return -ENORESTARTNOHAND will never return -EINTR and are
> > immune from this problem.
> >
> > AKA pselect is fine.  While epoll_pwait can be affected.
>
> This was my understanding as well.

I think I was misremembered here. I had noted this before:
https://lore.kernel.org/linux-fsdevel/CABeXuvq7gCV2qPOo+Q8jvNyRaTvhkRLRbnL_oJ-AuK7Sp=P3QQ@mail.gmail.com/

"sys_io_pgetevents() does not seem to have this problem as we are still
checking signal_pending() here.
sys_pselect6() seems to have a similar problem. The changes to
sys_pselect6() also impact sys_select() as the changes are in the
common code path."

This was the code replaced for io_pgetevents by 854a6ed56839a40f6b is as below.
No matter what events completed, there was signal_pending() check
after the return from do_io_getevents().

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2110,18 +2110,9 @@ SYSCALL_DEFINE6(io_pgetevents,
                return ret;

        ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
-       if (signal_pending(current)) {
-               if (ksig.sigmask) {
-                       current->saved_sigmask = sigsaved;
-                       set_restore_sigmask();
-               }
-
-               if (!ret)
-                       ret = -ERESTARTNOHAND;
-       } else {
-               if (ksig.sigmask)
-                       sigprocmask(SIG_SETMASK, &sigsaved, NULL);
-       }
+       restore_user_sigmask(ksig.sigmask, &sigsaved);
+       if (signal_pending(current) && !ret)
+               ret = -ERESTARTNOHAND;

Can I ask a simple question for my understanding?

man page for epoll_pwait says

EINTR
The call was interrupted by a signal handler before either any of the
requested events occurred or the timeout expired; see signal(7).

But it is not clear to me if we can figure out(without race) the
chronological order if one of the requested events are completed or a
signal came first.
Is this a correct exectation?

Also like pointed out above, this behavior is not consistent for all
such syscalls(io_pgetevents). Was this also by design?

-Deepa
