Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0672FDB25
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 21:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388697AbhATUr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 15:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388807AbhATUrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 15:47:41 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFC8C0613CF
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 12:47:01 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m2so3945760wmm.1
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 12:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FuVKEjQez4IgvhTSGsdofKZoh+yL5vcdn6sFuKQVNEc=;
        b=Pm+Tk+XH56AJLV4R9q8ryuaX/PS5v2qdPsQr0bB+Spl24KGCLqt7Nlmq9SE2i086Qj
         7NKz6u6EF3+gHIIsTajqFsRUUFa+S8l13K9mSh/CzsgxDbMsiMDr+a4dJ8DUpxqUGeG4
         X4P43o46XC3TBQsZRzKJ8Ms1Y1I5TWpJAKDhYdHhIjY64cp60MAKDLu3dmxh7PRL2rVG
         lP81NSAfyw/WC4Y1FXusX7fNzCmZJzK+miggd9n3eJixh8SBeKfo75KSRBT9TMbIh2Fs
         0p11l7CZ0IuUWukJQ+6vghvwx+j/uAPW+VAZvjfvYUgkn5HTC6h6pXHljcf9Y2S/ix7B
         m5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FuVKEjQez4IgvhTSGsdofKZoh+yL5vcdn6sFuKQVNEc=;
        b=IgtbvGCvQzkRUbd9dJCTds1t1ZT6cDBLKKfJU/PKaxW9O7lWhvbnbBpZf7tO2kjAWo
         TqM/QFeg2JghxXarOnQOxI2dl74q1Mmq9vt7PgPkK3a5TTD9Yg/8h5oSh1aKKAFQJgtG
         EqVZaCtIAMkagMsxWk52QYXPPZsYk1x/VyEi4pT4Ho/Vst13NK0X0MfKNeKagRqZJQpb
         8XdkubBZw4Tgr7dR69LtbRxLLu89zMXEUg8OsF8Fxqx+7yVdkpQxNkHmDasGtB2AzNYa
         Xx6YcMPqnfAg13GFNnaHXlWAIMlTj7jIOfQMn9xiFrnoJs27Y3/jinGtt8et8G+rPOS9
         Tjog==
X-Gm-Message-State: AOAM530Mi1RhKnU/LFKxqi4bXhChjyTZSNhezB/7RufC0PYK+fkKIV/x
        yCeJRqHDSBaEFNZqSoLkmkN6cvmA4AHJGz3hIZTMKA==
X-Google-Smtp-Source: ABdhPJyBFoVRDSOLju9neMiSyjpiaTkAvoBDWAfuuwRF/m5A/7eY+fbOWSMC7QEP3jUYNkdOESXE/cU2L3tylXJsXo8=
X-Received: by 2002:a1c:9dd5:: with SMTP id g204mr5955507wme.37.1611175619858;
 Wed, 20 Jan 2021 12:46:59 -0800 (PST)
MIME-Version: 1.0
References: <20210111170622.2613577-1-surenb@google.com> <20210112074629.GG22493@dhcp22.suse.cz>
 <20210112174507.GA23780@redhat.com> <CAJuCfpFQz=x-LvONO3c4iqjKP4NKJMgUuiYc8HACKHAv1Omu0w@mail.gmail.com>
 <20210113142202.GC22493@dhcp22.suse.cz> <CAG48ez0=QSzuj96+5oVQ2qWqfjedv3oKtfEFzw--C8bzfvj7EQ@mail.gmail.com>
 <CAJuCfpHb6PjTJBf67BZrBwSgbavKTeDz1S5bn9msEL4k8NtbVQ@mail.gmail.com>
In-Reply-To: <CAJuCfpHb6PjTJBf67BZrBwSgbavKTeDz1S5bn9msEL4k8NtbVQ@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 20 Jan 2021 12:46:49 -0800
Message-ID: <CAJuCfpGBeXuQK4y1ER-rXn6W5p0dgyzArM_21JgX2Qo28NYUSA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm/madvise: replace ptrace attach requirement for process_madvise
To:     Jann Horn <jannh@google.com>
Cc:     Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?Q?Edgar_Arriaga_Garc=C3=ADa?= <edgararriaga@google.com>,
        Tim Murray <timmurray@google.com>,
        linux-mm <linux-mm@kvack.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 8:57 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Wed, Jan 20, 2021 at 5:18 AM Jann Horn <jannh@google.com> wrote:
> >
> > On Wed, Jan 13, 2021 at 3:22 PM Michal Hocko <mhocko@suse.com> wrote:
> > > On Tue 12-01-21 09:51:24, Suren Baghdasaryan wrote:
> > > > On Tue, Jan 12, 2021 at 9:45 AM Oleg Nesterov <oleg@redhat.com> wrote:
> > > > >
> > > > > On 01/12, Michal Hocko wrote:
> > > > > >
> > > > > > On Mon 11-01-21 09:06:22, Suren Baghdasaryan wrote:
> > > > > >
> > > > > > > What we want is the ability for one process to influence another process
> > > > > > > in order to optimize performance across the entire system while leaving
> > > > > > > the security boundary intact.
> > > > > > > Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ
> > > > > > > and CAP_SYS_NICE. PTRACE_MODE_READ to prevent leaking ASLR metadata
> > > > > > > and CAP_SYS_NICE for influencing process performance.
> > > > > >
> > > > > > I have to say that ptrace modes are rather obscure to me. So I cannot
> > > > > > really judge whether MODE_READ is sufficient. My understanding has
> > > > > > always been that this is requred to RO access to the address space. But
> > > > > > this operation clearly has a visible side effect. Do we have any actual
> > > > > > documentation for the existing modes?
> > > > > >
> > > > > > I would be really curious to hear from Jann and Oleg (now Cced).
> > > > >
> > > > > Can't comment, sorry. I never understood these security checks and never tried.
> > > > > IIUC only selinux/etc can treat ATTACH/READ differently and I have no idea what
> > > > > is the difference.
> >
> > Yama in particular only does its checks on ATTACH and ignores READ,
> > that's the difference you're probably most likely to encounter on a
> > normal desktop system, since some distros turn Yama on by default.
> > Basically the idea there is that running "gdb -p $pid" or "strace -p
> > $pid" as a normal user will usually fail, but reading /proc/$pid/maps
> > still works; so you can see things like detailed memory usage
> > information and such, but you're not supposed to be able to directly
> > peek into a running SSH client and inject data into the existing SSH
> > connection, or steal the cryptographic keys for the current
> > connection, or something like that.
> >
> > > > I haven't seen a written explanation on ptrace modes but when I
> > > > consulted Jann his explanation was:
> > > >
> > > > PTRACE_MODE_READ means you can inspect metadata about processes with
> > > > the specified domain, across UID boundaries.
> > > > PTRACE_MODE_ATTACH means you can fully impersonate processes with the
> > > > specified domain, across UID boundaries.
> > >
> > > Maybe this would be a good start to document expectations. Some more
> > > practical examples where the difference is visible would be great as
> > > well.
> >
> > Before documenting the behavior, it would be a good idea to figure out
> > what to do with perf_event_open(). That one's weird in that it only
> > requires PTRACE_MODE_READ, but actually allows you to sample stuff
> > like userspace stack and register contents (if perf_event_paranoid is
> > 1 or 2). Maybe for SELinux things (and maybe also for Yama), there
> > should be a level in between that allows fully inspecting the process
> > (for purposes like profiling) but without the ability to corrupt its
> > memory or registers or things like that. Or maybe perf_event_open()
> > should just use the ATTACH mode.
>
> Thanks for additional clarifications, Jann!
> Just to clarify, the documentation I'm preparing is a man page for
> process_madvise(2) which will list the required capabilities but won't
> dive into all the security details.
> I believe the above suggestions are for documenting different PTRACE
> modes and will not be included in that man page. Maybe a separate
> document could do that but I'm definitely not qualified to write it.

Folks, I posted the man page here:
https://lore.kernel.org/linux-mm/20210120202337.1481402-1-surenb@google.com/

Also I realized that this patch is not changing at all and if I send a
new version, the only difference would be CC'ing it to stable and
linux-security-module.
I'm CC'ing stable (James already CC'ed LSM), but if I should re-post
it please let me know.

Cc: stable@vger.kernel.org # 5.10+
