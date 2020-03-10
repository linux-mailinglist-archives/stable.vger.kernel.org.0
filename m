Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614991807CA
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 20:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgCJTRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 15:17:15 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37512 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbgCJTRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 15:17:15 -0400
Received: by mail-oi1-f195.google.com with SMTP id w13so4605120oih.4
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 12:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TW/yj+hWXnFZH+cIOV6JEAyfHAcoNuoZqAljLHFkJp0=;
        b=qnpTPsDrlbR61cP6qwOtvwRo6RX3RcguUv4e0B4EPRv3lMbVxx87PrzuIty/LAuNGA
         1augL8bDQC+2Hgp+i4+8bOjr36RGS51J8cskswpHGlA6X6Tcgu5QhsxIBNt8a1DjhDkx
         BflQMoX3sKZF6vKlpOp4Q97mWTc0WRVR8sXyHC1HD8HOM++D8ZkJC/DxWDBawgvB0eG0
         c7CN/j7N/lduGOb8USG++EB+qLuRZ5ZmGvJgDndqyRfs2ncknuXH1XtvbZj9HyS3FKMN
         yJpRs7vrTdLLLXQsmXyrmLPA/+5a86cpumsh0BJi7WdP9qmCX8c1nFHsp7pZZKTS/iA3
         E1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TW/yj+hWXnFZH+cIOV6JEAyfHAcoNuoZqAljLHFkJp0=;
        b=qkfK+JArGf4MwXNfJz6/ddL5Ihy8IYklZHdzIFDFhuEvVFPqVwrZlC6+RnFhHMZyst
         ZML6BZOCDwH0yXPfHZtlxADkk0pON2zc9a/654Apv0CoD4I+XZwKaeQmnRFpVUVNy66E
         09gb1kRxWFR7gfxmxLo10Ay4rrGbGRX+PdQdpFavwbHyKtnOuVmfxqT/kz3yEqlQumPe
         I/bZUzS6SmROGEptL/nq6aAyNouvR4mBxxB1e7k+gNIrZO23ujejhlQfYhR/lXJt4exW
         hHmfe3EZh/RfSvP7CdkrGsrbnLxH67zTK0oh3L0NhqobspMizZc59QjeUHdOauLEVhYE
         WnDA==
X-Gm-Message-State: ANhLgQ0v3rkDW1dsgehcEkXAFS8fkIh0LOlnCmL2dnQm48kGOOzX7Dd0
        BnsjlXL5wZVL2ygoCjBPy1aDKctz/0MzmDafXeV6Rw==
X-Google-Smtp-Source: ADFU+vsLvhXTBZ0tYPXPJFbFEFKJ1zpqw9g6M/LvL7QhBPk7VyK2ei/FKMF/yhX24G0+fYimQ7ZdrPegjHcj9wiKoYo=
X-Received: by 2002:aca:bac1:: with SMTP id k184mr1869239oif.157.1583867833858;
 Tue, 10 Mar 2020 12:17:13 -0700 (PDT)
MIME-Version: 1.0
References: <87r1y8dqqz.fsf@x220.int.ebiederm.org> <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org> <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87eeu25y14.fsf_-_@x220.int.ebiederm.org> <20200309195909.h2lv5uawce5wgryx@wittgenstein>
 <877dztz415.fsf@x220.int.ebiederm.org> <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
 <87k13txnig.fsf@x220.int.ebiederm.org> <20200310085540.pztaty2mj62xt2nm@wittgenstein>
 <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 10 Mar 2020 20:16:47 +0100
Message-ID: <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
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

On Tue, Mar 10, 2020 at 7:54 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> During exec some file descriptors are closed and the files struct is
> unshared.  But all of that can happen at other times and it has the
> same protections during exec as at ordinary times.  So stop taking the
> cred_guard_mutex as it is useless.
>
> Furthermore he cred_guard_mutex is a bad idea because it is deadlock
> prone, as it is held in serveral while waiting possibly indefinitely
> for userspace to do something.

Please don't. Just use the new exec_update_mutex like everywhere else.

> Cc: Sargun Dhillon <sargun@sargun.me>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/pid.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> Christian if you don't have any objections I will take this one through
> my tree.
>
> I tried to figure out why this code path takes the cred_guard_mutex and
> the archive on lore.kernel.org was not helpful in finding that part of
> the conversation.

That was my suggestion.

> diff --git a/kernel/pid.c b/kernel/pid.c
> index 60820e72634c..53646d5616d2 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -577,17 +577,11 @@ static struct file *__pidfd_fget(struct task_struct *task, int fd)
>         struct file *file;
>         int ret;
>
> -       ret = mutex_lock_killable(&task->signal->cred_guard_mutex);
> -       if (ret)
> -               return ERR_PTR(ret);
> -
>         if (ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS))
>                 file = fget_task(task, fd);
>         else
>                 file = ERR_PTR(-EPERM);
>
> -       mutex_unlock(&task->signal->cred_guard_mutex);
> -
>         return file ?: ERR_PTR(-EBADF);
>  }

If you make this change, then if this races with execution of a setuid
program that afterwards e.g. opens a unix domain socket, an attacker
will be able to steal that socket and inject messages into
communication with things like DBus. procfs currently has the same
race, and that still needs to be fixed, but at least procfs doesn't
let you open things like sockets because they don't have a working
->open handler, and it enforces the normal permission check for opening files.
