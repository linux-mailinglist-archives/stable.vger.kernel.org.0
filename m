Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367AD29ACB
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 17:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389303AbfEXPQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 11:16:40 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:52357 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389079AbfEXPQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 11:16:40 -0400
Received: by mail-it1-f196.google.com with SMTP id t184so16345783itf.2;
        Fri, 24 May 2019 08:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ue5iAQh3o+RrZq+T4VgTKmLqWN6Wlxd8oVLaY6JmVVo=;
        b=gCMAYpHJfYJUrKtc5oOniur8lpNW+N8uTuzjZHgP4or1AcKLVGkYZ2hbf2zteQLJ/m
         jg76i3nOzn+IbZxbv9LoKRkSgtNnVhHve6C+dLnYj7BV8WPhGpddv1RufLS3jhn3r0tU
         ZM3dUTSV9xcGr0h3RfQKPjNokDHrUTwCofbQJffzfQPs22BUW3cVaDM06QFHsExF4kny
         X3VBDYAQEbBjGc7PJkT+cNO+4snLWNICiBwGBJTDJOGhoibDfZY5NkUf032uNqT0Yunx
         OfAfdaueUXCZfV/9fljZSkcppYLcmXdv3Tk/TZQ3ij/EyjMDd6Kftsrv1rDCivBoazpE
         FnGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ue5iAQh3o+RrZq+T4VgTKmLqWN6Wlxd8oVLaY6JmVVo=;
        b=KrAUR/3sUqFhS2fCA07BIQfUfTQsa39xhUDOdWsDsyVfdlreBPKV8b9qvhPDDlZ8dW
         z3z07GBorW1c0TV6bwmTkP17mXuPcLVz7XOALHTFuSQJrS45yRX0PcPdMuBS0voS4QPn
         ShqBwVQlLros5JjeV+dsT1sQW9wsP1vtRJxn2NOCUPGfGDoO4GJpV7EKvrkGu2A7wJus
         S5rK1Hgxhl/96VLE81BpkSDy//jfGAi60Jtf7Dch24dM0a5S6u4vL8Ic8c26ddvGTlWc
         y1ZnreJMpZkyjrUgJRUYXNq9TSgU4i8iycBZQUhZX2qcbOAVwZ5lWozehfvMTkvLM18U
         JIqw==
X-Gm-Message-State: APjAAAXDf35vNMhjj7IOuX/1akj+pDcPZra0QqPl32X82aS8nGYnQ6VR
        qKWy16ckcaX11PNEJXddrBaYgAMLvfeDyoIlp6E=
X-Google-Smtp-Source: APXvYqxR6m7vbnGIM+BEYmZgfSpPLI1ndiLHiIaQVaa2rr9P87vKtLr6igqahreqyvbvw7yowifJCB5gCbe0P38NhbY=
X-Received: by 2002:a24:e084:: with SMTP id c126mr17512124ith.124.1558710998913;
 Fri, 24 May 2019 08:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190522150505.GA4915@redhat.com> <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com> <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com> <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com> <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com> <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141054.GB2655@redhat.com>
In-Reply-To: <20190524141054.GB2655@redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Fri, 24 May 2019 08:16:23 -0700
Message-ID: <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com>
Subject: Re: [PATCH v2] signal: Adjust error codes according to restore_user_sigmask()
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 7:11 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 05/23, Deepa Dinamani wrote:
> >
> > Ok, since there has been quite a bit of argument here, I will
> > backtrack a little bit and maybe it will help us understand what's
> > happening here.
> > There are many scenarios being discussed on this thread:
> > a. State of code before 854a6ed56839a
>
> I think everything was correct,

There were 2 things that were wrong:

1. If an unblocked signal was received, after the ep_poll(), then the
return status did not indicate that. This is expected behavior
according to man page. If this is indeed what is expected then the man
page should note that signal will be delivered in this case and return
code will still be 0.

"EINTR
The call was interrupted by a signal handler before either any of the
requested events occurred or the timeout expired; see signal(7)."

2. The restoring of the sigmask is done right in the syscall part and
not while exiting the syscall and if you get a blocked signal here,
you will deliver this to userspace.

> > b. State after 854a6ed56839a
>
> obviously buggy,

Ok, then can you point out what specifically was wrong with
854a6ed56839a? And, not how it could be more simple?

> > c. Proposed fix as per the patchset in question.
>
> > As per [a] and let's consider the case of epoll_pwait only first for simplicity.
> >
> > As I said before, ep_poll() is what checks for signal_pending() and is
> > responsible for setting errno to -EINTR when there is a signal.
>
> To clarify, if do_epoll_wait() return -EINTR then signal_pending() is true,
> right?

Yes, the case I'm talking about is when do_epoll_wait() returns 0 and
then you get a signal.

> > So if a signal is received after ep_poll() and ep_poll() returns
> > success, it is never noticed by the syscall during execution.
>
> What you are saying looks very confusing to me, I will assume that you
> meant something like
>
>         - a signal SIG_XXX was blocked before sys_epoll_pwait() was called
>
>         - sys_epoll_pwait(sigmask) unblocks SIG_XXX according to sigmask
>
>         - sys_epoll_pwait() calls do_epoll_wait() which returns success
>
>         - SIG_XXX comes after that and it is "never noticed"
>
> Yes. Everything is correct. And see my reply to David, SIG_XXX can even
> come _before_ sys_epoll_pwait() was called.

No, I'm talking about a signal that was not blocked.

> > So the question is does the userspace have to know about this signal
> > or not.
>
> If userspace needs to know about SIG_XXX it should not block it, that is all.

What should be the return value if a signal is detected after a fd completed?

> > What [b] does is to move the signal check closer to the restoration of
> > the signal.
>
> FOR NO REASON, afaics (to simplify, lets forget the problem with the wrong
> return value you are trying to fix).

As I already pointed out, the restoring of the sigmask is done during
the syscall and not while exiting the syscall and if you get a blocked
signal here, you will deliver this to userspace.

> And even if there were ANY reason to do this, note that (with or without this
> fix) the signal_pending() check inside restore_user_sigmask() can NOT help,
> simply because SIG_XXX can come right after this check.

This I pointed out already that we should probably make this sequence atomic.


-Deepa
