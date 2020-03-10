Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E491808A7
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgCJUAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:00:55 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36777 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgCJUAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:00:55 -0400
Received: by mail-ot1-f67.google.com with SMTP id j14so14475625otq.3
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 13:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zIAAqBT5cH5cbbW3GFto6v7mD8pF39ecAMkC8oTgutI=;
        b=lToTywfF6/WNafCRISYFb5qIPhLOZD7H3m7K11tcVGoSy0sDMKZ5AOMrdtIh1Zcm+N
         FsSDckkbtI4yqMRWo5Fjqdg64HXXgblPk8H7PM2B/BLCmb4xHoUig7plVH7TGc1gK2Cr
         kNb3g6Is4ZWWVGTXV2n1kZH9gibgqCnEAvqkgY/U8QdWJYyuzGJ5/NKmku3+6X9qrx4w
         ahi9XPBSsYLPDacA5iChtNW4lQKX1M3pK4Y+gCGh2NS8fv2rmtdk2F6Wa83/mGUwm7si
         i9wYysP5fygg3ep0iX3jaDt/BGsNFKQNDX1evsDSMAIoQCH29ffsppjtETxuQHNKCs5q
         BGiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zIAAqBT5cH5cbbW3GFto6v7mD8pF39ecAMkC8oTgutI=;
        b=GoKo0NHHTU1ZQN0PNHpFOW6ApO4ivdXuofeTRSo1z8ehewu/+NK+0mKcmA5UHgFJgO
         rvpENyM+FzjwO+RRmj1ZEjIRxoYw1J8dN9nSbuLpc1gE7p0UVOuOphs++Af8fh9QcU9B
         iMNc4qSv5huFkkgMpXR7HxiXcEqByC+u61idObCzsdoSvDg+1J0Y1tqGOEIqQfNFz0XK
         S57ZVRrOVZ/qTX0+8lpNUstBTQcJOeFkN9c7ESUQvypBAudi8Y17ORpSwvTDE+cpX1QS
         LhAIoRMsVHi+8iYfAmNzFYOsoAAqCw3MF+5C2Jc980YfCet1F6uHMwkHhb2lbTzxif4L
         dbNA==
X-Gm-Message-State: ANhLgQ3DQIetaPL2C613UYHxAqsBBd9nfBKt1h3Sxlgp67f5Z7Gm98tT
        3Jl0T0bQ6+KjsLi6T5azVXlaXiBLwDs1647DlGDbvw==
X-Google-Smtp-Source: ADFU+vtcsmeizoaiKSlTHolQlrAnABBwhEpSV9VVyJB0PvpgO9H1QULcgU81RJuwJLNtl9eG+n2+fGb/mXJ4ROrh4fc=
X-Received: by 2002:a05:6830:1d6e:: with SMTP id l14mr17776467oti.32.1583870453922;
 Tue, 10 Mar 2020 13:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <87r1y8dqqz.fsf@x220.int.ebiederm.org> <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org> <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87eeu25y14.fsf_-_@x220.int.ebiederm.org> <20200309195909.h2lv5uawce5wgryx@wittgenstein>
 <877dztz415.fsf@x220.int.ebiederm.org> <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
 <87k13txnig.fsf@x220.int.ebiederm.org> <20200310085540.pztaty2mj62xt2nm@wittgenstein>
 <87wo7svy96.fsf_-_@x220.int.ebiederm.org> <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
 <87k13sui1p.fsf@x220.int.ebiederm.org>
In-Reply-To: <87k13sui1p.fsf@x220.int.ebiederm.org>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 10 Mar 2020 21:00:27 +0100
Message-ID: <CAG48ez2vRgaEVJ=Rs8gn6HkGO6syL8MpSOUq7BNN+OUE1uYxCA@mail.gmail.com>
Subject: Re: [PATCH] pidfd: Stop taking cred_guard_mutex
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 8:29 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Jann Horn <jannh@google.com> writes:
> > On Tue, Mar 10, 2020 at 7:54 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> During exec some file descriptors are closed and the files struct is
> >> unshared.  But all of that can happen at other times and it has the
> >> same protections during exec as at ordinary times.  So stop taking the
> >> cred_guard_mutex as it is useless.
> >>
> >> Furthermore he cred_guard_mutex is a bad idea because it is deadlock
> >> prone, as it is held in serveral while waiting possibly indefinitely
> >> for userspace to do something.
> >
> > Please don't. Just use the new exec_update_mutex like everywhere else.
> >
> >> Cc: Sargun Dhillon <sargun@sargun.me>
> >> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> ---
> >>  kernel/pid.c | 6 ------
> >>  1 file changed, 6 deletions(-)
> >>
> >> Christian if you don't have any objections I will take this one through
> >> my tree.
> >>
> >> I tried to figure out why this code path takes the cred_guard_mutex and
> >> the archive on lore.kernel.org was not helpful in finding that part of
> >> the conversation.
> >
> > That was my suggestion.
> >
> >> diff --git a/kernel/pid.c b/kernel/pid.c
> >> index 60820e72634c..53646d5616d2 100644
> >> --- a/kernel/pid.c
> >> +++ b/kernel/pid.c
> >> @@ -577,17 +577,11 @@ static struct file *__pidfd_fget(struct task_struct *task, int fd)
> >>         struct file *file;
> >>         int ret;
> >>
> >> -       ret = mutex_lock_killable(&task->signal->cred_guard_mutex);
> >> -       if (ret)
> >> -               return ERR_PTR(ret);
> >> -
> >>         if (ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS))
> >>                 file = fget_task(task, fd);
> >>         else
> >>                 file = ERR_PTR(-EPERM);
> >>
> >> -       mutex_unlock(&task->signal->cred_guard_mutex);
> >> -
> >>         return file ?: ERR_PTR(-EBADF);
> >>  }
> >
> > If you make this change, then if this races with execution of a setuid
> > program that afterwards e.g. opens a unix domain socket, an attacker
> > will be able to steal that socket and inject messages into
> > communication with things like DBus. procfs currently has the same
> > race, and that still needs to be fixed, but at least procfs doesn't
> > let you open things like sockets because they don't have a working
> > ->open handler, and it enforces the normal permission check for
> > opening files.
>
> It isn't only exec that can change credentials.  Do we need a lock for
> changing credentials?

Hmm, I guess so? Normally, a task that's changing credentials becomes
nondumpable at the same time (and there are explicit memory barriers
in commit_creds() and __ptrace_may_access() to enforce the ordering
for this); so you normally don't see tasks becoming ptrace-accessible
via anything other than execve(). But I guess if someone opens a
root-only file, closes it, drops privileges, and then explicitly does
prctl(PR_SET_DUMPABLE, 1), we should probably protect that, too.

> Wouldn't it be sufficient to simply test ptrace_may_access after
> we get a copy of the file?

There are also setuid helpers that can, after having done privileged
stuff, drop privileges and call execve(); after that,
ptrace_may_access() succeeds again. In particular, polkit has a helper
that does this.

> If we need a lock around credential change let's design and build that.
> Having a mismatch between what a lock is designed to do, and what
> people use it for can only result in other bugs as people get confused.

Hmm... what benefits do we get from making it a separate lock? I guess
it would allow us to make it a per-task lock instead of a
signal_struct-wide one? That might be helpful...
