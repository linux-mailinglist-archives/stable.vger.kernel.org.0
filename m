Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3CB0180C41
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 00:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCJXWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 19:22:19 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43156 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCJXWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 19:22:18 -0400
Received: by mail-oi1-f195.google.com with SMTP id p125so15755014oif.10
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 16:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0SG9alWkJ/Jgp88pmVWrlnAeORjU1Bi5WlBRFbHa1ck=;
        b=bXtZeMLwoJSnRz7jYAT9Nxgt4EjIpibQndWXUYf0e25pPrU5HPPn1B9ylL4DXV6Z1j
         qeFDlH1hFWzJQ70cTl0cuy/Fbm/L0h0EWDQjgHIniSeYfa1Uk+XmSZLW1QgEJFMKAzjF
         VZiHdDIDdWe5BnM+5Noagr/GdY5lI37UwcLgkyMdVfsD/fe+MFTuOxrTeJi1nX4i8HOg
         VUkKfaAU3TrdPfbXYQqboyCHbc0eyYBaRmxuH52Xn5Dh/TCm1e02ASC5dirfvTF1YxPx
         lzPE++XTCgEvyiX6oaF3wYDbxIDXkcGIqFCjOGk8cU/ivzDnxBuuRsxii0nf2rzn+eB4
         pQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0SG9alWkJ/Jgp88pmVWrlnAeORjU1Bi5WlBRFbHa1ck=;
        b=gH7Zj0L+3w4MIZAI5fxBwvLYlDvrwowz6HnZ3MWGbvwF0CT6OKm2/xVocCVgzTTXK4
         fI6tgGoiUgNVS29+qmv5uUvQoaZZSFKAc2uMp0iYXLPKU9ZearJsPWmgwbzn3lFSVmt0
         ikIATgg5A6PaEg9s+MhF7LFHQljT+dUuZMiX6E3sJyczJJ15eqELpt4W0zfGZCOZSY4S
         fJcoeZ5rNGJ46/DEyO49dpPn7uJdgb/A9MyrX9F6sJq+nwDMCdXLYI/Z/ss33zRSep0H
         mxIu2sBngzx0FyajgrU1/nGGHjTLPFT00kbuSLgfDe6SExDZ3Fn2xf+xt2Sd/xz34mDw
         9V0g==
X-Gm-Message-State: ANhLgQ34iEj23IZmjHAD/uk1mVoB8xrCP+VMBJcLoDPmLmCgE7BgMHub
        wwAwfqA6/h0ktZQFRlPH3hGh9DrFkT55stjhz/Acqw==
X-Google-Smtp-Source: ADFU+vuSiveurHJ3mWgzsiX28P2uFv4kQvFy5FChN7qEoSlaBMM2vSEC6fMHVo5v9rjlRZlpO64Dbc+u19jr17edDf0=
X-Received: by 2002:aca:1913:: with SMTP id l19mr51096oii.47.1583882536478;
 Tue, 10 Mar 2020 16:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org> <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org> <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org> <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook> <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org> <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org> <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org> <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org> <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org> <CAG48ez13XXWNRLrPFRHRsvPKSwSK1-6k+1F7QujWOJtVuk0QHg@mail.gmail.com>
 <87wo7roq2c.fsf@x220.int.ebiederm.org>
In-Reply-To: <87wo7roq2c.fsf@x220.int.ebiederm.org>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 11 Mar 2020 00:21:49 +0100
Message-ID: <CAG48ez1j2=pdj0nc1syHkh6X4d=aHuCH1srzA6hT7+32QD+6Gg@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 10:33 PM Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Jann Horn <jannh@google.com> writes:
> > On Sun, Mar 8, 2020 at 10:41 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
> >> over the userspace accesses as the arguments from userspace are read.
> >> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
> >> threads are killed.  The cred_guard_mutex is held over
> >> "put_user(0, tsk->clear_child_tid)" in exit_mm().
> >>
> >> Any of those can result in deadlock, as the cred_guard_mutex is held
> >> over a possible indefinite userspace waits for userspace.
> >>
> >> Add exec_update_mutex that is only held over exec updating process
> >> with the new contents of exec, so that code that needs not to be
> >> confused by exec changing the mm and the cred in ways that can not
> >> happen during ordinary execution of a process.
> >>
> >> The plan is to switch the users of cred_guard_mutex to
> >> exec_udpate_mutex one by one.  This lets us move forward while still
> >> being careful and not introducing any regressions.
> > [...]
> >> @@ -1034,6 +1035,11 @@ static int exec_mmap(struct mm_struct *mm)
> >>                         return -EINTR;
> >>                 }
> >>         }
> >> +
> >> +       ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
> >> +       if (ret)
> >> +               return ret;
> >
> > We're already holding the old mmap_sem, and now nest the
> > exec_update_mutex inside it; but then while still holding the
> > exec_update_mutex, we do mmput(), which can e.g. end up in ksm_exit(),
> > which can do down_write(&mm->mmap_sem) from __ksm_exit(). So I think
> > at least lockdep will be unhappy, and I'm not sure whether it's an
> > actual problem or not.
>
> Good point.  I should double check the lock ordering here with mmap_sem.
> It doesn't look like mmput takes mmap_sem

You sure about that? mmput() -> __mmput() -> ksm_exit() ->
__ksm_exit() -> down_write(&mm->mmap_sem)

Or also: mmput() -> __mmput() -> khugepaged_exit() ->
__khugepaged_exit() -> down_write(&mm->mmap_sem)

Or is there a reason why those paths can't happen?
