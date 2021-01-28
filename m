Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2992307F04
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 21:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhA1UBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 15:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhA1T7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 14:59:38 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46577C061788
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 11:51:32 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d16so6593232wro.11
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 11:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EyD3wHKnz4mNZyyvJbfB06klVKrdyE3VJ5F5elJU0p4=;
        b=dE6DkK29jp1+2E1wW4vsdERPnjCiGfWiDO/sMZTB7Ak26IuFMJQv59WorheyAZjC+A
         WMGzKQl2IPb8WDCumWHWk0exXWe0DR5W2MXc2boIjmbvsHkTup0MURQuP6O2xaeiaG/i
         cQwicLWx+9CXz/RGIKJlXjhC+4lDsFMlMuCnpdvB1E5iWsvRwylRX2XGyr03u7bYW/dg
         aHCQsUX0XfLFEDRER1WS9zZumqHSOUR4kqOcb4e914Uj3aH8XZ3+1aU/+IJ32eTCjPWP
         7ydfG7rlPVXbzmI7RNdrj/LykQawxAQyc3Bs9MpJaSeLB5oHkOaUbHXgDhkaktLGjFna
         o2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EyD3wHKnz4mNZyyvJbfB06klVKrdyE3VJ5F5elJU0p4=;
        b=GrH8VwYWnmI2qKzs0ZiRxck7SlSHicE2uy4aHZ5FzdtwuJDymHjphsZFJRnKKcEcTf
         mjfgkulGZ4jpzSfvoyPFBzLy8Os/yRB3Lc7nQTIVLtdx2rrggNaL7TC3Ku0SaE6GaDul
         mmLT4m+XIhBVmR/1nPIY5GvcZUEkb6hGGtdhtGb0BJcKIHfL3xNwFtpKWBgzqTFD94ch
         kGCI3XyCTS7KjSUroc3Jwv/XuNg1kel9QFuGfG4rXLjBe/iCpmN2MHTR9lbqUvfbd+7P
         q0HNs3nN86SJYWmHxLW56psM+xw2XaqPy8b51K3rwZL+E3pMJGvyjBkCJWaXyVcHGRdm
         DWpg==
X-Gm-Message-State: AOAM5304onpqdRw6eV3GAJ9A1dzF4fHR2nlOkEs/aPZZvpTAZt2jnQmt
        00rh6LdpYal0yQKAyBt4UMyGKrYLc3MiRjaiTEbcSg==
X-Google-Smtp-Source: ABdhPJxFwy5Z8MQNDvk+8YAnLtFQ3tf9xJlcNP6VxscFRdyqIQPeQC47UCqkw9kazNJmLs+Te6L/YObeg7RsVtG7o9Y=
X-Received: by 2002:a5d:453b:: with SMTP id j27mr808169wra.92.1611863490625;
 Thu, 28 Jan 2021 11:51:30 -0800 (PST)
MIME-Version: 1.0
References: <20210111170622.2613577-1-surenb@google.com> <20210112074629.GG22493@dhcp22.suse.cz>
 <20210112174507.GA23780@redhat.com> <CAJuCfpFQz=x-LvONO3c4iqjKP4NKJMgUuiYc8HACKHAv1Omu0w@mail.gmail.com>
 <20210113142202.GC22493@dhcp22.suse.cz> <CAG48ez0=QSzuj96+5oVQ2qWqfjedv3oKtfEFzw--C8bzfvj7EQ@mail.gmail.com>
 <20210126135254.GP827@dhcp22.suse.cz>
In-Reply-To: <20210126135254.GP827@dhcp22.suse.cz>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 28 Jan 2021 11:51:19 -0800
Message-ID: <CAJuCfpEnMyo9XAnoF+q1j9EkC0okZfUxxdAFhzhPJi+adJYqjw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm/madvise: replace ptrace attach requirement for process_madvise
To:     Michal Hocko <mhocko@suse.com>
Cc:     Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
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

On Tue, Jan 26, 2021 at 5:52 AM 'Michal Hocko' via kernel-team
<kernel-team@android.com> wrote:
>
> On Wed 20-01-21 14:17:39, Jann Horn wrote:
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
> Thanks for the clarification. I still cannot say I would have a good
> mental picture. Having something in Documentation/core-api/ sounds
> really needed. Wrt to perf_event_open it sounds really odd it can do
> more than other places restrict indeed. Something for the respective
> maintainer but I strongly suspect people simply copy the pattern from
> other places because the expected semantic is not really clear.
>

Sorry, back to the matters of this patch. Are there any actionable
items for me to take care of before it can be accepted? The only
request from Andrew to write a man page is being worked on at
https://lore.kernel.org/linux-mm/20210120202337.1481402-1-surenb@google.com/
and I'll follow up with the next version. I also CC'ed stable@ for
this to be included into 5.10 per Andrew's request. That CC was lost
at some point, so CC'ing again.

I do not see anything else on this patch to fix. Please chime in if
there are any more concerns, otherwise I would ask Andrew to take it
into mm-tree and stable@ to apply it to 5.10.
Thanks!


> --
> Michal Hocko
> SUSE Labs
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
