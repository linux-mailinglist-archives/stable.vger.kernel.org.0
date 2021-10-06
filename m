Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92C442356A
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 03:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhJFB2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 21:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbhJFB2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 21:28:12 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC43C061755
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 18:26:21 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id 66so1172293vsd.11
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 18:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hOmszyBrN18jbtk+dy9rpQ8byKmiyB5Wa60iraBOQC4=;
        b=U9qnTD/yZkEwDB2ELWFT0fu5Bl2EFxl0ursnvpCPvodkrzBzjBEtk02N1XSxjMcR3E
         qLz0icDyp0/5rmAkL/ioSylXy4DUTpCk6ciAHZ41pqAhbSaqDeDd7ZsIcAabgxTf1KVC
         XyvqljQ+ma6c85ngGfS7DSSNVgLb3SuoXzMHa/7oao/AZDxep5HEfeonkIQQMB3cHIwA
         GJ/oosLYTQCzKnfsLf8TYYNe5DoYrvlS7vYBk6dTPk3P2Z4zuW2FrGCcA1WunPOqSCQu
         PJayjUFMQv0ZFhIoKW9KO1gZ68QwzwD+FLfzThuUSGoTdIpT7Xc6FkPfqP2OkuTGFQE0
         +hhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hOmszyBrN18jbtk+dy9rpQ8byKmiyB5Wa60iraBOQC4=;
        b=8DV1G/EO1b/p/TwtQOkvbmG/F3AFzF2+wnhwEjq0pALh+5PZszDC1LELRSa5IzRGL6
         niYvNWOrBLSMM+WUS1AqdSaKkiNp5nvjjFzsCnRj6ZNni6UGP597vZiWxs3Sg/qw3OHE
         EOP++7hpKTOtSgxu9YvAnTFhY6cKt1MoRfQpDBr3cYyPBkhAQkhUsuCWimhCMCywPfIw
         NdJp9a5+0bbxCLrySHGXQ/St0bvNsJaEreZMCGuMsZXAeWS+2Gug1jx6nuLQBOzzkGt3
         bbLmQazpM66xpjWYdaVrKDvmTgWXpNdJ4IF4EwQs8H6qg0UlwFTWUUClhCuuZ4wLiOiA
         yGmw==
X-Gm-Message-State: AOAM532AeEYXTLwIfuScm9stMIqJUANjDLNk9lZnmkjCLrEF693N3g0W
        K2NUTVQjsOjnUOSJc+zNGvRTDefM0CklTGqMRH5M4A==
X-Google-Smtp-Source: ABdhPJyIdXV8PVV0sKWp8zvNpXfjTed55Xf9XW5lv9g1Trs5X4bqu9OuJsJh/1vw8/CEYlr3KQUz8vHJ2CMVf6LtukQ=
X-Received: by 2002:a67:fd67:: with SMTP id h7mr259923vsa.52.1633483580393;
 Tue, 05 Oct 2021 18:26:20 -0700 (PDT)
MIME-Version: 1.0
References: <20211001175521.3853257-1-tkjos@google.com> <c6a650e4-15e4-2943-f759-0e9577784c7a@schaufler-ca.com>
 <CAG48ez2tejBUXJGf0R9qpEiauL9-ABgkds6mZTQD7sZKLMdAAQ@mail.gmail.com>
 <CAG48ez1SRau1Tnge5HVqxCFsNCizmnQLErqnC=eSeERv8jg-zQ@mail.gmail.com>
 <f59c6e9f-2892-32da-62f8-8bbeec18ee4c@schaufler-ca.com> <CAG48ez0yF0u=QBLVL2XrGB8r8ouQj-_aS9SScu4O4f+LhZxCDw@mail.gmail.com>
 <e0c1fab9-cb97-d5af-1f4b-f15b6b2097fd@schaufler-ca.com> <CAG48ez3qc+2sc6xTJQVqLTRcjCiw_Adx13KT3OvPMCjBLjZvgA@mail.gmail.com>
 <6bd2de29-b46a-1d24-4c73-9e4e0f3f6eea@schaufler-ca.com> <CAG48ez0RM6NGZLdEjaqU9KmaOgeFR6cSeNo50XG9oaFxC_ayYw@mail.gmail.com>
 <CAEjxPJ4X4N_zgH4oRbdkZi21mvS--ExDb_1gad09buMHshB_hQ@mail.gmail.com>
In-Reply-To: <CAEjxPJ4X4N_zgH4oRbdkZi21mvS--ExDb_1gad09buMHshB_hQ@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 6 Oct 2021 03:25:53 +0200
Message-ID: <CAG48ez3tsZZYmcWVgE+gkR16XLH8mwuAUdaxHmLZn+3tJvb51A@mail.gmail.com>
Subject: Re: [PATCH v2] binder: use cred instead of task for selinux checks
To:     Stephen Smalley <stephen.smalley.work@gmail.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Todd Kjos <tkjos@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Kees Cook <keescook@chromium.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 5, 2021 at 5:21 PM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Mon, Oct 4, 2021 at 8:27 PM Jann Horn <jannh@google.com> wrote:
> > On Tue, Oct 5, 2021 at 1:38 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > > On 10/4/2021 3:28 PM, Jann Horn wrote:
> > > > On Mon, Oct 4, 2021 at 6:19 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > > >> On 10/1/2021 3:58 PM, Jann Horn wrote:
> > > >>> On Fri, Oct 1, 2021 at 10:10 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > > >>>> On 10/1/2021 12:50 PM, Jann Horn wrote:
> > > >>>>> On Fri, Oct 1, 2021 at 9:36 PM Jann Horn <jannh@google.com> wrote:
> > > >>>>>> On Fri, Oct 1, 2021 at 8:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > > >>>>>>> On 10/1/2021 10:55 AM, Todd Kjos wrote:
> > > >>>>>>>> Save the struct cred associated with a binder process
> > > >>>>>>>> at initial open to avoid potential race conditions
> > > >>>>>>>> when converting to a security ID.
> > > >>>>>>>>
> > > >>>>>>>> Since binder was integrated with selinux, it has passed
> > > >>>>>>>> 'struct task_struct' associated with the binder_proc
> > > >>>>>>>> to represent the source and target of transactions.
> > > >>>>>>>> The conversion of task to SID was then done in the hook
> > > >>>>>>>> implementations. It turns out that there are race conditions
> > > >>>>>>>> which can result in an incorrect security context being used.
> > > >>>>>>> In the LSM stacking patch set I've been posting for a while
> > > >>>>>>> (on version 29 now) I use information from the task structure
> > > >>>>>>> to ensure that the security information passed via the binder
> > > >>>>>>> interface is agreeable to both sides. Passing the cred will
> > > >>>>>>> make it impossible to do this check. The task information
> > > >>>>>>> required is not appropriate to have in the cred.
> > > >>>>>> Why not? Why can't you put the security identity of the task into the creds?
> > > >>>>> Ah, I get it now, you're concerned about different processes wanting
> > > >>>>> to see security contexts formatted differently (e.g. printing the
> > > >>>>> SELinux label vs printing the AppArmor label), right?
> > > >>>> That is correct.
> > > >>>>
> > > >>>>> But still, I don't think you can pull that information from the
> > > >>>>> receiving task. Maybe the easiest solution would be to also store that
> > > >>>>> in the creds? Or you'd have to manually grab that information when
> > > >>>>> /dev/binder is opened.
> > > >>>> I'm storing the information in the task security blob because that's
> > > >>>> the appropriate scope. Today the LSM hook is given both task_struct's.
> > > >>> Which is wrong, because you have no idea who the semantic "recipient
> > > >>> task" is - any task that has a mapping of the binder fd can
> > > >>> effectively receive transactions from it.
> > > >>>
> > > >>> (And the current "sender task" is also wrong, because binder looks at
> > > >>> the task that opened the binder device, not the task currently
> > > >>> performing the action.)
> > > >> I'm confused. Are you saying that the existing binder code is
> > > >> completely broken? Are you saying that neither "task" is correct?
> > > > Yeah, basically
> > >
> > > Well, hot biscuits and gravy!
> > >
> > > >  - but luckily the actual impact this has is limited by
> > > > the transitions that SELinux permits. If domain1 has no way to
> > > > transition to domain2, then it can't abuse this bug to pretend to be
> > > > domain2. I do have a reproducer that lets Android's "shell" domain
> > > > send a binder transaction that appears to come from "runas", but
> > > > luckily "runas" has no interesting privileges with regards to binder,
> > > > so that's not exploitable.
> > >
> > > You're counting on the peculiarities of the SELinux policy you're
> > > assuming is used to mask the fact that the hook isn't really doing
> > > what it is supposed to?  Ouch.
> >
> > I'm not saying I like the current situation - I do think that this
> > needs to change. I'm just saying it probably isn't *exploitable*, and
> > exploitability often hinges on these little circumstantial details.
> >
> > > >> How does passing the creds from the wrong tasks "fix" the problem?
> > > > This patch is not passing the creds from the "wrong" tasks at all. It
> > > > relies on the basic idea that when a security context opens a
> > > > resource, and then hands that resource to another context for
> > > > read/write operations, then you can effectively treat this as a
> > > > delegation of privileges from the original opener, and perform access
> > > > checks against the credentials using which the resource was opened.
> > >
> > > OK. I can understand that without endorsing it.
> > >
> > > > In particular, we already have those semantics in the core kernel for
> > > > ->read() and ->write() VFS operations - they are *not allowed* to look
> > > > at the credentials of the caller, and if they want to make security
> > > > checks, they have to instead check against file->f_cred, which are the
> > > > credentials using which the file was originally opened. (Yes, some
> > > > places still get that wrong.) Passing a file descriptor to another
> > > > task is a delegation of access, and the other task can then call
> > > > syscalls like read() / write() / mmap() on the file descriptor without
> > > > needing to have any access to the underlying file.
> > >
> > > A mechanism sufficiently entrenched.
> >
> > It's not just "entrenched", it is a fundamental requirement for being
> > able to use file descriptor passing with syscalls like write(). If
> > task A gives a file descriptor to task B, then task B must be able to
> > write() to that FD without having to worry that the FD actually refers
> > to some sort of special file that interprets the written data as some
> > type of command, or something like that, and that this leads to task B
> > unknowingly passing through access checks.
> >
> > > > You can't really attribute binder transactions to specific tasks that
> > > > are actually involved in the specific transaction, neither on the
> > > > sending side nor on the receiving side, because binder is built around
> > > > passing data through memory mappings. Memory mappings can be accessed
> > > > by multiple tasks, and even a task that does not currently have it
> > > > mapped could e.g. map it at a later time. And on top of that you have
> > > > the problem that the receiving task might also go through privileged
> > > > execve() transitions.
> > >
> > > OK. I'm curious now as to why the task_struct was being passed to the
> > > hook in the first place.
> >
> > Probably because that's what most other LSM hooks looked like and the
> > authors/reviewers of the patch didn't realize that this model doesn't
> > really work for binder? FWIW, these hooks were added in commit
> > 79af73079d75 ("Add security hooks to binder and implement the hooks
> > for SELinux."). The commit message also just talks about "processes".
>
> Note that in the same code path (binder_transaction), sender_euid is
> set from proc->tsk and security_ctx is based on proc->tsk. If we are
> changing the hooks to operate on the opener cred, then presumably we
> should be doing that for sender_euid and replace the
> security_task_getsecid_obj() call with security_cred_getsecid()?

Good point.

> NB Mandatory Access Control doesn't allow uncontrolled delegation,
> hence typically checks against the subject credential either at
> delegation/transfer or use or both. That's true in other places too,
> e.g. file_permission, socket_sendmsg.

The SELinux hook for sending binder transactions does actually have a
delegation check on the sending side, checking against the current
task, although that would be unreliable if another task in a different
security context also has access to the binder mapping. But the
security context used for the SELinux access check and delegation
check is read separately from the security context transmitted to the
other side, and if you race an execve() in between the two (which is
possible because the creds are read from another thread), you can
effectively bypass the delegation check with regards to the
transmitted security context.

binder_transfer_binder_ and binder_transfer_file are also effectively
covered by that delegation check.

The hook for setting the binder context manager also has a delegation
check against the current task.

If you actually wanted to prevent uncontrolled delegation, I think
you'd also have to check all the VMAs for forbidden file mappings,
ensure that in particular binder/io_uring/... FDs or VMAs can not be
shared across any kind of privilege transition (even if both sides of
the transition would've been allowed to have such an FD/VMA), and
completely prevent pin_user_pages() on mappings that wouldn't be
allowed to be inherited across a privilege transition (because
otherwise someone could abuse a subsystem like io_uring to grab a
reference to a bunch of pages from such a mapping and then write into
them later)?

At the moment, SELinux scans through file descriptors on transition
but not through memory mappings of files, which is kinda weird...
