Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A6919C893
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 20:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387699AbgDBSM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 14:12:58 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43376 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgDBSM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 14:12:57 -0400
Received: by mail-ed1-f65.google.com with SMTP id bd14so5470105edb.10
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 11:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RlBOg0dum66ebZmfIZrWlU1IBkKC8efn4oYc6hOU1L0=;
        b=hvEITigZV32UOF8ubiUjd+p22kCZAiMJFfBqDEEHBqM8+KyLyY3+cjtQPsswx+RUpm
         HJ1KgeDiJRSfzbkwXPk1cZ6pfQGvYJULSwuj6II4fCP3quqyDwcIFxIxB2CVRWFVsr87
         Cmk6cMB40cebsPRptNEHYRfJuiAA45R2UT23k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RlBOg0dum66ebZmfIZrWlU1IBkKC8efn4oYc6hOU1L0=;
        b=auIDgWCTRRAXmlUiKIAdCEiOzjwTKQ8rtrgcXarfX8RD+i+NnkWjVi8g7HdAf5ZrGy
         pexlr2OhH8tFo1MUT6xGHIGXqPEOgSKCpzd4ONu49rNMDJVwEfKQJEPOSfhQc+EPXRs4
         +U387OYZsfGjNCeB3QtgB9xaXvTV2gfRWIia1sUcmO4umzZ9MuWkAxPpArUz3cZ1uGP0
         rWwivv6s2bayl1CJr2leseQt1d+jW/N2yV8BNHh8CCW5r9Mq+rF9H+6bEQzHJiUH1Dkp
         vPuZITAw6qaNpiu4PAdJJMNqhBIsu8kntbYjYOZBlSM5o5HCrSUd8K52v9ONB9PdPNTh
         E4+Q==
X-Gm-Message-State: AGi0PuZggtE0AkYg8zf8FV6kbtfBHQh2boHY0KdpXoQLG9M5aXzz0ggn
        NXrecH7UWQqHOC+nuwhnCvcVbh0as1g=
X-Google-Smtp-Source: APiQypK9J1CDu5YU6vfPLfUpO+EcnXAKqlNQkwLXOix83IK2Q39N0t4DiiqW//1qWxpvbFCEJv5cTw==
X-Received: by 2002:a17:907:20b4:: with SMTP id pw20mr4340142ejb.113.1585851175127;
        Thu, 02 Apr 2020 11:12:55 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id y21sm1061704edu.48.2020.04.02.11.12.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2020 11:12:54 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id cf14so5454084edb.13
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 11:12:54 -0700 (PDT)
X-Received: by 2002:a2e:8652:: with SMTP id i18mr2793744ljj.265.1585850802219;
 Thu, 02 Apr 2020 11:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org> <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
 <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
 <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
 <CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
 <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com> <877dyym3r0.fsf@x220.int.ebiederm.org>
In-Reply-To: <877dyym3r0.fsf@x220.int.ebiederm.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Apr 2020 11:06:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiOS4Fi2tsXQrvLOiW69g4HiJYsqL6RPeTd14b4+2-Ykg@mail.gmail.com>
Message-ID: <CAHk-=wiOS4Fi2tsXQrvLOiW69g4HiJYsqL6RPeTd14b4+2-Ykg@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jann Horn <jannh@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Adam Zabrocki <pi3@pi3.com.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 2, 2020 at 6:14 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> > tasklist_lock is aboue the hottest lock there is in all of the kernel.
>
> Do you know code paths you see tasklist_lock being hot?

It's generally not bad enough to show up on single-socket machines.

But the problem with tasklist_lock is that it's one of our remaining
completely global locks. So it scales like sh*t in some circumstances.

On single-socket machines, most of the truly nasty hot paths aren't a
huge problem, because they tend to be mostly readers. So you get the
cacheline bounce, but you don't (usually) get much busy looping. The
cacheline bounce is "almost free" on a single socket.

But because it's one of those completely global locks, on big
multi-socket machines people have reported it as a problem forever.
Even just readers can cause problems (because of the cacheline
bouncing even when you just do the reader increment), but you also end
up having more issues with writers scaling badly.

Don't get me wrong - you can get bad scaling on other locks too, even
when they aren't really global - we had that with just the reference
counter increment for the user signal accounting, after all. Neither
of the reference counts were actually global, but they were just
effectively single counters under that particular load (ie the count
was per-user, but the load ran as a single user).

The reason tasklist_lock probably doesn't come up very much is that
it's _always_ been expensive. It has also caused some fundamental
issues (I think it's the main reason we have that rule that
reader-writer locks are unfair to readers, because we have readers
from interrupt context too, but can't afford to make normal readers
disable interrupts).

A lot of the tasklist lock readers end up looping quite a bit inside
the lock (looping over threads etc), which is why it can then be a big
deal when the rare reader shows up.

We've improved a _lot_ of those loops. That has definitely helped for
the common cases. But we've never been able to really fix the lock
itself.

                 Linus
