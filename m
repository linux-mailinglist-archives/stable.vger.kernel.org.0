Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB165421A07
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 00:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhJDWbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 18:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbhJDWbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 18:31:15 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5153BC061753
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 15:29:25 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y26so78353172lfa.11
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 15:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=um4Fcr2fRzJCbuqb6umRyrAwaJXGfwl9VTVZmIntFmY=;
        b=azmyGfTEmdbEJHm+SlhRjjeQax/I1DRRaIkHgTN4T7Jcza4Q0DN4yXcxnjzsUyiSIO
         wesrHq+r64z1z1P6Ck+CGOVWAIhXFEk/k5e/E2RvXZi+fUhkoeZRV9ifX8bxLC30LI7a
         yey+Enhe6gT/eAg03pHu9jiX6/WexDBqOn0KFD9sNQXxoS8I+Zcd93ndmcs+opzvMtOt
         67065Q6A2selnkErXNaPY46ULEyJevFiohL8dCMnW1syunxS+Q3JyZ7XYBR6yGcxHzO9
         G2tGr+dHvGy4+QQoXusqgtaIGAlPdnfbpq2MR3df2xhvmf2DSSibzNom38jGEHLBKcgt
         UmWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=um4Fcr2fRzJCbuqb6umRyrAwaJXGfwl9VTVZmIntFmY=;
        b=PMEttxCMblm4+hZ1we9ffiihhlxZ38P8wbMbJ49RvxmKVU8YL1wufXtjqcgeeSpKDX
         NNV5MzPfEJXCxS2/V+qSDOspPsQkFURp8urQmIge5EKeZjW8GOzRQtpHmIByYR/8PiDD
         AwzhO8nP7Gl5Emi6ybprLkVIxwuMk4hlEF1t+0Zw4A2WBkz9Y+kSjbIVIhdUNFH5ntEv
         pjEw4HU4OTlu7Puve7u2mWsSwuZeMGGMvHy3ixnXUgemCCfgJrQnK4nkZ+ADH8JCNgJz
         jxqvmTkQUam+U+GvzwynGPUj8L8QsuYebOaO+yDtcQHNxjE6G0MzwTVHpI4SZs3Dml7X
         WJCw==
X-Gm-Message-State: AOAM5335bxXb+aryIVKeZrLK8bmtdYkpoWtYyBDwZBMBnw/bOAVmqaES
        pRxT9iridUq5DM7MWnPG4ofFxChXratXKOLPk4Z9sw==
X-Google-Smtp-Source: ABdhPJykxc+U57C0bYOepxwQRGK6sUfG/2fmg1ryrkmQhSafCwiTubKiNfdXkMC9JaMoYBco6qzyBu7W+0Rrjgm8A2U=
X-Received: by 2002:ac2:4f92:: with SMTP id z18mr16805817lfs.354.1633386563407;
 Mon, 04 Oct 2021 15:29:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211001175521.3853257-1-tkjos@google.com> <c6a650e4-15e4-2943-f759-0e9577784c7a@schaufler-ca.com>
 <CAG48ez2tejBUXJGf0R9qpEiauL9-ABgkds6mZTQD7sZKLMdAAQ@mail.gmail.com>
 <CAG48ez1SRau1Tnge5HVqxCFsNCizmnQLErqnC=eSeERv8jg-zQ@mail.gmail.com>
 <f59c6e9f-2892-32da-62f8-8bbeec18ee4c@schaufler-ca.com> <CAG48ez0yF0u=QBLVL2XrGB8r8ouQj-_aS9SScu4O4f+LhZxCDw@mail.gmail.com>
 <e0c1fab9-cb97-d5af-1f4b-f15b6b2097fd@schaufler-ca.com>
In-Reply-To: <e0c1fab9-cb97-d5af-1f4b-f15b6b2097fd@schaufler-ca.com>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 5 Oct 2021 00:28:57 +0200
Message-ID: <CAG48ez3qc+2sc6xTJQVqLTRcjCiw_Adx13KT3OvPMCjBLjZvgA@mail.gmail.com>
Subject: Re: [PATCH v2] binder: use cred instead of task for selinux checks
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Todd Kjos <tkjos@google.com>, gregkh@linuxfoundation.org,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, keescook@chromium.org, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 4, 2021 at 6:19 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 10/1/2021 3:58 PM, Jann Horn wrote:
> > On Fri, Oct 1, 2021 at 10:10 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> On 10/1/2021 12:50 PM, Jann Horn wrote:
> >>> On Fri, Oct 1, 2021 at 9:36 PM Jann Horn <jannh@google.com> wrote:
> >>>> On Fri, Oct 1, 2021 at 8:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>>> On 10/1/2021 10:55 AM, Todd Kjos wrote:
> >>>>>> Save the struct cred associated with a binder process
> >>>>>> at initial open to avoid potential race conditions
> >>>>>> when converting to a security ID.
> >>>>>>
> >>>>>> Since binder was integrated with selinux, it has passed
> >>>>>> 'struct task_struct' associated with the binder_proc
> >>>>>> to represent the source and target of transactions.
> >>>>>> The conversion of task to SID was then done in the hook
> >>>>>> implementations. It turns out that there are race conditions
> >>>>>> which can result in an incorrect security context being used.
> >>>>> In the LSM stacking patch set I've been posting for a while
> >>>>> (on version 29 now) I use information from the task structure
> >>>>> to ensure that the security information passed via the binder
> >>>>> interface is agreeable to both sides. Passing the cred will
> >>>>> make it impossible to do this check. The task information
> >>>>> required is not appropriate to have in the cred.
> >>>> Why not? Why can't you put the security identity of the task into the creds?
> >>> Ah, I get it now, you're concerned about different processes wanting
> >>> to see security contexts formatted differently (e.g. printing the
> >>> SELinux label vs printing the AppArmor label), right?
> >> That is correct.
> >>
> >>> But still, I don't think you can pull that information from the
> >>> receiving task. Maybe the easiest solution would be to also store that
> >>> in the creds? Or you'd have to manually grab that information when
> >>> /dev/binder is opened.
> >> I'm storing the information in the task security blob because that's
> >> the appropriate scope. Today the LSM hook is given both task_struct's.
> > Which is wrong, because you have no idea who the semantic "recipient
> > task" is - any task that has a mapping of the binder fd can
> > effectively receive transactions from it.
> >
> > (And the current "sender task" is also wrong, because binder looks at
> > the task that opened the binder device, not the task currently
> > performing the action.)
>
> I'm confused. Are you saying that the existing binder code is
> completely broken? Are you saying that neither "task" is correct?

Yeah, basically - but luckily the actual impact this has is limited by
the transitions that SELinux permits. If domain1 has no way to
transition to domain2, then it can't abuse this bug to pretend to be
domain2. I do have a reproducer that lets Android's "shell" domain
send a binder transaction that appears to come from "runas", but
luckily "runas" has no interesting privileges with regards to binder,
so that's not exploitable.

> How does passing the creds from the wrong tasks "fix" the problem?

This patch is not passing the creds from the "wrong" tasks at all. It
relies on the basic idea that when a security context opens a
resource, and then hands that resource to another context for
read/write operations, then you can effectively treat this as a
delegation of privileges from the original opener, and perform access
checks against the credentials using which the resource was opened.

In particular, we already have those semantics in the core kernel for
->read() and ->write() VFS operations - they are *not allowed* to look
at the credentials of the caller, and if they want to make security
checks, they have to instead check against file->f_cred, which are the
credentials using which the file was originally opened. (Yes, some
places still get that wrong.) Passing a file descriptor to another
task is a delegation of access, and the other task can then call
syscalls like read() / write() / mmap() on the file descriptor without
needing to have any access to the underlying file.

You can't really attribute binder transactions to specific tasks that
are actually involved in the specific transaction, neither on the
sending side nor on the receiving side, because binder is built around
passing data through memory mappings. Memory mappings can be accessed
by multiple tasks, and even a task that does not currently have it
mapped could e.g. map it at a later time. And on top of that you have
the problem that the receiving task might also go through privileged
execve() transitions.

> >> It's easy to compare to make sure the tasks are compatible.
> > It would be, if you actually had a pair of tasks that accurately
> > represent the sender and the recipient.
> >
> >> Adding the
> >> information to the cred would be yet another case where the scope of
> >> security information is wrong.
> > Can you elaborate on why you think that?
>
> The information identifies how the task is going to display
> the security "context". It isn't used in access checks.

But it is data that AFAICS needs to be preserved in the same places
where the creds need to be preserved, and it is also related to
security labels, so isn't "struct cred" a logical place to stuff it
anyway?
