Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD8D30B724
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 06:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBBFfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 00:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhBBFfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 00:35:06 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B29C0613ED
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 21:34:25 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id f16so1218879wmq.5
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 21:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lD+9VdFDDbbGKdh4Zlx/S6kSI7nJIlJMTXOt77nYf50=;
        b=c6ADmGsDwHXz5pqsJbysFZOPf2sccXandZLMCxhV2SBY5AeEWS9MvAu3A1L3a1CjhL
         NPCrbMA6t0stZ0Eq6KILOn6lTLJd6/Wparn+DKG1OEOl7DvoDnjdCBw3yGA2b/DkOxFj
         bDCLUPdLOGT6qFlvKp4N/U8LR5N9kYRS8GlSn6HOoZsKSUBhyH3zg3zWYV6D2hSPkANy
         sGFrnNBfW/cxZ9vseIaZXp2D8HnVZrLnqj9nGpSdeiw60EG1qr/XVwEcZgcoBSScv83v
         r+F1d0el8pKgYroBTfOLfgDhOG7Hcutr8ToP92EmfFiSVg75RMkO4dr7oUpoGRoS3wRX
         HTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lD+9VdFDDbbGKdh4Zlx/S6kSI7nJIlJMTXOt77nYf50=;
        b=lLjL2HGKn5uEXIPnNWl1ZPXIXLrjH4FfeiUwmef5olZe9zwv/ucIrwKSo4PnrT+ro8
         1oQZFxAvIqPOpeGEuJOHOfj/it7hOBeLVGDITWGuY81G0/GdA/QGwHoGB//YxztHvFBE
         v1EYWL+I8ULgeUDADt04sSoLthdLt/65Ki4CHbxqFfmX4drpwOx7oqBU3huQYmVaYzgN
         MgrvjQdyNe3OpBDvZK8q0rVkRf822Lay35H1SyxkaowiPwoHglw55FDdzrHMtptx8x1G
         aBvyu19K7msZyhWKpdb7xJC7yxy47jH6Fa0dQFvDWvRFomf/H55Q9Gd/Eijc0SJhb+s9
         3tPw==
X-Gm-Message-State: AOAM533YY2k8TMQW7D4OYB8uQ8m1jJt+7R/5P6p3h/WSxSJL/MfpF8p5
        JXGQunp0pfl/nM7/LJQOasxt6HzSpsvjJMt/PVpBqg==
X-Google-Smtp-Source: ABdhPJz6ttAxWJJKNXWH8Zat2eIPwUyJ+Sf7ECY2vlX2Nz9RgCcMqIkMT272RDNbBCLgqaqpUVLQC9YR8N97KTCll7k=
X-Received: by 2002:a1c:acc9:: with SMTP id v192mr1888469wme.22.1612244064008;
 Mon, 01 Feb 2021 21:34:24 -0800 (PST)
MIME-Version: 1.0
References: <20210111170622.2613577-1-surenb@google.com> <20210112074629.GG22493@dhcp22.suse.cz>
 <20210112174507.GA23780@redhat.com> <CAJuCfpFQz=x-LvONO3c4iqjKP4NKJMgUuiYc8HACKHAv1Omu0w@mail.gmail.com>
 <20210113142202.GC22493@dhcp22.suse.cz> <CAG48ez0=QSzuj96+5oVQ2qWqfjedv3oKtfEFzw--C8bzfvj7EQ@mail.gmail.com>
 <20210126135254.GP827@dhcp22.suse.cz> <CAJuCfpEnMyo9XAnoF+q1j9EkC0okZfUxxdAFhzhPJi+adJYqjw@mail.gmail.com>
 <CAJuCfpF861zhp8yR_pYx8gb+WMrORAZ0tbzcKtKxaj7L=jzw+Q@mail.gmail.com>
In-Reply-To: <CAJuCfpF861zhp8yR_pYx8gb+WMrORAZ0tbzcKtKxaj7L=jzw+Q@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Mon, 1 Feb 2021 21:34:12 -0800
Message-ID: <CAJuCfpFzxiBXp1rdY=H=bX+eOAVGOe72_FxwC-NTWF4fhUO26g@mail.gmail.com>
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

On Thu, Jan 28, 2021 at 11:08 PM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Thu, Jan 28, 2021 at 11:51 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Tue, Jan 26, 2021 at 5:52 AM 'Michal Hocko' via kernel-team
> > <kernel-team@android.com> wrote:
> > >
> > > On Wed 20-01-21 14:17:39, Jann Horn wrote:
> > > > On Wed, Jan 13, 2021 at 3:22 PM Michal Hocko <mhocko@suse.com> wrote:
> > > > > On Tue 12-01-21 09:51:24, Suren Baghdasaryan wrote:
> > > > > > On Tue, Jan 12, 2021 at 9:45 AM Oleg Nesterov <oleg@redhat.com> wrote:
> > > > > > >
> > > > > > > On 01/12, Michal Hocko wrote:
> > > > > > > >
> > > > > > > > On Mon 11-01-21 09:06:22, Suren Baghdasaryan wrote:
> > > > > > > >
> > > > > > > > > What we want is the ability for one process to influence another process
> > > > > > > > > in order to optimize performance across the entire system while leaving
> > > > > > > > > the security boundary intact.
> > > > > > > > > Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ
> > > > > > > > > and CAP_SYS_NICE. PTRACE_MODE_READ to prevent leaking ASLR metadata
> > > > > > > > > and CAP_SYS_NICE for influencing process performance.
> > > > > > > >
> > > > > > > > I have to say that ptrace modes are rather obscure to me. So I cannot
> > > > > > > > really judge whether MODE_READ is sufficient. My understanding has
> > > > > > > > always been that this is requred to RO access to the address space. But
> > > > > > > > this operation clearly has a visible side effect. Do we have any actual
> > > > > > > > documentation for the existing modes?
> > > > > > > >
> > > > > > > > I would be really curious to hear from Jann and Oleg (now Cced).
> > > > > > >
> > > > > > > Can't comment, sorry. I never understood these security checks and never tried.
> > > > > > > IIUC only selinux/etc can treat ATTACH/READ differently and I have no idea what
> > > > > > > is the difference.
> > > >
> > > > Yama in particular only does its checks on ATTACH and ignores READ,
> > > > that's the difference you're probably most likely to encounter on a
> > > > normal desktop system, since some distros turn Yama on by default.
> > > > Basically the idea there is that running "gdb -p $pid" or "strace -p
> > > > $pid" as a normal user will usually fail, but reading /proc/$pid/maps
> > > > still works; so you can see things like detailed memory usage
> > > > information and such, but you're not supposed to be able to directly
> > > > peek into a running SSH client and inject data into the existing SSH
> > > > connection, or steal the cryptographic keys for the current
> > > > connection, or something like that.
> > > >
> > > > > > I haven't seen a written explanation on ptrace modes but when I
> > > > > > consulted Jann his explanation was:
> > > > > >
> > > > > > PTRACE_MODE_READ means you can inspect metadata about processes with
> > > > > > the specified domain, across UID boundaries.
> > > > > > PTRACE_MODE_ATTACH means you can fully impersonate processes with the
> > > > > > specified domain, across UID boundaries.
> > > > >
> > > > > Maybe this would be a good start to document expectations. Some more
> > > > > practical examples where the difference is visible would be great as
> > > > > well.
> > > >
> > > > Before documenting the behavior, it would be a good idea to figure out
> > > > what to do with perf_event_open(). That one's weird in that it only
> > > > requires PTRACE_MODE_READ, but actually allows you to sample stuff
> > > > like userspace stack and register contents (if perf_event_paranoid is
> > > > 1 or 2). Maybe for SELinux things (and maybe also for Yama), there
> > > > should be a level in between that allows fully inspecting the process
> > > > (for purposes like profiling) but without the ability to corrupt its
> > > > memory or registers or things like that. Or maybe perf_event_open()
> > > > should just use the ATTACH mode.
> > >
> > > Thanks for the clarification. I still cannot say I would have a good
> > > mental picture. Having something in Documentation/core-api/ sounds
> > > really needed. Wrt to perf_event_open it sounds really odd it can do
> > > more than other places restrict indeed. Something for the respective
> > > maintainer but I strongly suspect people simply copy the pattern from
> > > other places because the expected semantic is not really clear.
> > >
> >
> > Sorry, back to the matters of this patch. Are there any actionable
> > items for me to take care of before it can be accepted? The only
> > request from Andrew to write a man page is being worked on at
> > https://lore.kernel.org/linux-mm/20210120202337.1481402-1-surenb@google.com/
> > and I'll follow up with the next version. I also CC'ed stable@ for
> > this to be included into 5.10 per Andrew's request. That CC was lost
> > at some point, so CC'ing again.
> >
> > I do not see anything else on this patch to fix. Please chime in if
> > there are any more concerns, otherwise I would ask Andrew to take it
> > into mm-tree and stable@ to apply it to 5.10.
> > Thanks!
>
> process_madvise man page V2 is posted at:
> https://lore.kernel.org/linux-mm/20210129070340.566340-1-surenb@google.com/

process_madvise man page V3 is posted at:
https://lore.kernel.org/linux-mm/20210202053046.1653012-1-surenb@google.com/

>
> >
> >
> > > --
> > > Michal Hocko
> > > SUSE Labs
> > >
> > > --
> > > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> > >
