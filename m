Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA643181BD8
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 15:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbgCKO4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 10:56:35 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38022 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729521AbgCKO4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 10:56:34 -0400
Received: by mail-ot1-f65.google.com with SMTP id i14so2239326otp.5
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 07:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ouxKLWRXOtqbKDl0q+UmOju78v5owF0LnUPYL3Cn3Kg=;
        b=Xc7KTwBmSvnyR04w7xAsoM4QolF0XcaryYGGSqywW6r0XlqYx9XvikGX4w7bLlxxLJ
         7Q9AwD+7i/TJ2mStAI9eb2ob9VCt6KgwBw+LR3gAYpgM3S9uQWoNLD+xlKhWnCsJiDsd
         gQ/4BkYOpVHRSRCowJu6XRQFruet41lwL6gwC6z3ZSErV3n8O+X2f+eZSuo5E01C3UV8
         tyeHf9B1wPr69eyCIlYMAQR5+WIsB75Z+R5FBKu1iRw02ws17iiqnH3dVPNo9lJU7J88
         tpacvkSbf6Ri5ZPR6z68IF56hdGSxpTT8rbI4/vpexPf/ozipoU+b1l6PAcyKYZfa7Y6
         rVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ouxKLWRXOtqbKDl0q+UmOju78v5owF0LnUPYL3Cn3Kg=;
        b=rKIF9ic2JHOBJAr/wlVI6TTbeTLZCLrXI81sjzo8Iqpu8REpzU4PcLQZ4qSfRuiphA
         FjcqN2hp5EXU7gZc6DUH3mAFgdX0wRsipGhu/R8QDsBIQv6bxf1EIJZ6EE/l5WBb7tBH
         mlS2es2STn3K5Q706McdNfAfSApwNDSlGmLs0iG81D+u2nKrS50L39KNQBvtpJSnMk4O
         64V7bBFusHXZdZIJbO66JkjWko0xX8bMXLx7ZPSb7o217lgTGftMRZi2AA2DeQqtwqvO
         A8kSkbMQIVPgrkY3VqKBDcssME187mRj9l5GvhDyENah/Bz4p8oOQ2ekHpMWnbQWWkpK
         23kg==
X-Gm-Message-State: ANhLgQ0xY+L+lbS60IuhwkQBxmhEAHF5B3nsUR6zPWtxzWvVuI2GDNw/
        9OjmQYvdSYbXh8+zpk1j2DNlm8GOlIYU/nq6v4gfkA==
X-Google-Smtp-Source: ADFU+vsoVPEYUzYAEvw3qgsbNcHFvKCUWY2EnYgxb3/1wEn7Xj5CByupWPUTgv6N0jalxR0NpVo1qN7c0CgaHTbYtAA=
X-Received: by 2002:a4a:a8c6:: with SMTP id r6mr553536oom.21.1583938593523;
 Wed, 11 Mar 2020 07:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <87r1y8dqqz.fsf@x220.int.ebiederm.org> <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org> <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87eeu25y14.fsf_-_@x220.int.ebiederm.org> <20200309195909.h2lv5uawce5wgryx@wittgenstein>
 <877dztz415.fsf@x220.int.ebiederm.org> <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
 <87k13txnig.fsf@x220.int.ebiederm.org> <20200310085540.pztaty2mj62xt2nm@wittgenstein>
 <87wo7svy96.fsf_-_@x220.int.ebiederm.org> <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
 <87k13sui1p.fsf@x220.int.ebiederm.org> <CAG48ez2vRgaEVJ=Rs8gn6HkGO6syL8MpSOUq7BNN+OUE1uYxCA@mail.gmail.com>
 <CAG48ez1LjW1xAGe-5tNtstCWxG2bkiHaQUMOcJNjx=z-2Wc2Jw@mail.gmail.com>
 <AM6PR03MB5170AF454A8A9C37891B12B2E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <5a8b2794-b498-af33-1327-ff2861cff83f@hotmail.de>
In-Reply-To: <5a8b2794-b498-af33-1327-ff2861cff83f@hotmail.de>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 11 Mar 2020 15:56:07 +0100
Message-ID: <CAG48ez33hx0NavmLub1QjzTw_DJuyRtkB71Mm35Hmp1x+DjmFA@mail.gmail.com>
Subject: Re: [PATCH] pidfd: Stop taking cred_guard_mutex
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "avagin@gmail.com" <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "duyuyang@gmail.com" <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "christian@kellner.me" <christian@kellner.me>,
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
        "sargun@sargun.me" <sargun@sargun.me>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 7:12 AM Bernd Edlinger
<bernd.edlinger@hotmail.de> wrote:
> On 3/10/20 9:22 PM, Bernd Edlinger wrote:
> > On 3/10/20 9:10 PM, Jann Horn wrote:
> >> On Tue, Mar 10, 2020 at 9:00 PM Jann Horn <jannh@google.com> wrote:
> >>> On Tue, Mar 10, 2020 at 8:29 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >>>> Jann Horn <jannh@google.com> writes:
> >>>>> On Tue, Mar 10, 2020 at 7:54 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >>>>>> During exec some file descriptors are closed and the files struct is
> >>>>>> unshared.  But all of that can happen at other times and it has the
> >>>>>> same protections during exec as at ordinary times.  So stop taking the
> >>>>>> cred_guard_mutex as it is useless.
> >>>>>>
> >>>>>> Furthermore he cred_guard_mutex is a bad idea because it is deadlock
> >>>>>> prone, as it is held in serveral while waiting possibly indefinitely
> >>>>>> for userspace to do something.
> >> [...]
> >>>>> If you make this change, then if this races with execution of a setuid
> >>>>> program that afterwards e.g. opens a unix domain socket, an attacker
> >>>>> will be able to steal that socket and inject messages into
> >>>>> communication with things like DBus. procfs currently has the same
> >>>>> race, and that still needs to be fixed, but at least procfs doesn't
> >>>>> let you open things like sockets because they don't have a working
> >>>>> ->open handler, and it enforces the normal permission check for
> >>>>> opening files.
> >>>>
> >>>> It isn't only exec that can change credentials.  Do we need a lock for
> >>>> changing credentials?
> >> [...]
> >>>> If we need a lock around credential change let's design and build that.
> >>>> Having a mismatch between what a lock is designed to do, and what
> >>>> people use it for can only result in other bugs as people get confused.
> >>>
> >>> Hmm... what benefits do we get from making it a separate lock? I guess
> >>> it would allow us to make it a per-task lock instead of a
> >>> signal_struct-wide one? That might be helpful...
> >>
> >> But actually, isn't the core purpose of the cred_guard_mutex to guard
> >> against concurrent credential changes anyway? That's what almost
> >> everyone uses it for, and it's in the name...
> >>
> >
> > The main reason d'etre of exec_update_mutex is to get a consitent
> > view of task->mm and task credentials.
> > > The reason why you want the cred_guard_mutex, is that some action
> > is changing the resulting credentials that the execve is about
> > to install, and that is the data flow in the opposite direction.
> >
>
> So in other words, you need the exec_update_mutex when you
> access another thread's credentials and possibly the mmap at the
> same time.

Or the file descriptor table, or register state, ...

> You need no mutex at all when you are just accessing or
> even changing the credentials of the current thread.  (If another
> thread is doing execve, your task will be killed, and wether
> or not the credentials were changed does not matter any more)

Only if the only access checks you care about are those related to mm access.
