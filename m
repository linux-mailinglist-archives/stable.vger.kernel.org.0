Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71AFCFD92
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfJHP1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:27:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51378 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfJHP1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:27:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so3653453wme.1;
        Tue, 08 Oct 2019 08:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WDFIiBm6S5uX2XE3I5+IySEfki9AKpBX9TiLxyljV3U=;
        b=IGz3sYfSWyEG7OKqMSydcmvm2GIVX2zE8cgFlsOcHDe26KYTeTwFG+pGeO8TvoLe6a
         t/UXA4JpJ2a4sENtAVbCuWA4I1dSIS7RK+ZKs80W8NPTZRQjOMoRuvKa3Ah3hLqyylw8
         b/H5vJO/lBYJQHGTCVOd9fDZj9fDUVu+zSYo/A7WbPx1wTtO8s00hr2kjN8OmcLTEPaM
         jz5FiE+vGh47exGi828yqA08wl4FhXZlkmQ5QiXWogpB8Q/s3hyIWXi3rufq8DmQENFa
         +03hG6uZqtdHAwUFMOUfH0t1kJVZ9w5sLYxSUOa99AbFCVGw0txm2YFlHYVuqNn9Wr+P
         7B6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WDFIiBm6S5uX2XE3I5+IySEfki9AKpBX9TiLxyljV3U=;
        b=j/bmqQVCn13JaoksQ+MNH+963KWUOmnwYl4KpjB080fGeft9eHRmnEAbx5dEUJ42Jr
         +tTPSfzCuPFe9BSUnwnpfqSrUf4JoE5l9rKNk4DPIOAg76QTHuloPhRsUlsIkUCH6CvH
         8Pm920j2B6CliMmTbqKX33APkaqJ5ggBxa/YFhCvW9WE78dBuOY2RKaSRZ0MuHL9KDyv
         ZS++03kZ5jkLJFk6/6Wy3X47rKty7qCoO9YWzscS6l2jl5F4NGrMVpEsjNW+oPppAjFb
         p80tGWO8JjjiQFvNlMHrZmJkqVY+/m4+ACG5JKUTMFlgvzMadFk0RE2iSHYIQkk4A4Pd
         rPow==
X-Gm-Message-State: APjAAAWRMg5ysbwbsuJKXSQZokC1a8es2haWLS5lDw/WYhmjOcGN0ade
        OAzqQ/sbceSQq6MfM5HlvWU=
X-Google-Smtp-Source: APXvYqx3AdwmMv/ayfbiGTrjx2iPFPG7L8KQ1wMzV1TAfuIEf2Px3KCgi9Nv6elnX39C+/by1KaT4Q==
X-Received: by 2002:a1c:4085:: with SMTP id n127mr4478793wma.68.1570548426151;
        Tue, 08 Oct 2019 08:27:06 -0700 (PDT)
Received: from andrea (userh648.uk.uudial.com. [194.69.103.21])
        by smtp.gmail.com with ESMTPSA id h63sm5575050wmf.15.2019.10.08.08.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:27:05 -0700 (PDT)
Date:   Tue, 8 Oct 2019 17:26:59 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] taskstats: fix data-race
Message-ID: <20191008152659.GA16065@andrea>
References: <20191007104039.GA16085@andrea.guest.corp.microsoft.com>
 <20191007110117.1096-1-christian.brauner@ubuntu.com>
 <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
 <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com>
 <20191007141432.GA22083@andrea.guest.corp.microsoft.com>
 <CACT4Y+avbYvtF9mHiX=R8Y2=YsP1_QsN6i_FpjLM7UxCKv6vxA@mail.gmail.com>
 <20191008142035.GA13564@andrea.guest.corp.microsoft.com>
 <20191008142413.h5kczta7jo4ado6u@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008142413.h5kczta7jo4ado6u@wittgenstein>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 04:24:14PM +0200, Christian Brauner wrote:
> On Tue, Oct 08, 2019 at 04:20:35PM +0200, Andrea Parri wrote:
> > On Mon, Oct 07, 2019 at 04:18:26PM +0200, Dmitry Vyukov wrote:
> > > On Mon, Oct 7, 2019 at 4:14 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> > > >
> > > > > > >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> > > > > > >  {
> > > > > > >       struct signal_struct *sig = tsk->signal;
> > > > > > > -     struct taskstats *stats;
> > > > > > > +     struct taskstats *stats_new, *stats;
> > > > > > >
> > > > > > > -     if (sig->stats || thread_group_empty(tsk))
> > > > > > > -             goto ret;
> > > > > > > +     /* Pairs with smp_store_release() below. */
> > > > > > > +     stats = READ_ONCE(sig->stats);
> > > > > >
> > > > > > This pairing suggests that the READ_ONCE() is heading an address
> > > > > > dependency, but I fail to identify it: what is the target memory
> > > > > > access of such a (putative) dependency?
> > > > >
> > > > > I would assume callers of this function access *stats. So the
> > > > > dependency is between loading stats and accessing *stats.
> > > >
> > > > AFAICT, the only caller of the function in 5.4-rc2 is taskstats_exit(),
> > > > which 'casts' the return value to a boolean (so I really don't see how
> > > > any address dependency could be carried over/relied upon here).
> > > 
> > > This does not make sense.
> > > 
> > > But later taskstats_exit does:
> > > 
> > > memcpy(stats, tsk->signal->stats, sizeof(*stats));
> > > 
> > > Perhaps it's supposed to use stats returned by taskstats_tgid_alloc?
> > 
> > Seems reasonable to me.  If so, replacing the READ_ONCE() in question
> > with an smp_load_acquire() might be the solution.  Thoughts?
> 
> I've done that already in my tree yesterday. I can resend for another
> review if you'd prefer.

Oh nice!  No need to resend of course.  ;D FWIW, I can check it if you
let me know the particular branch/commit (guessing that's somewhere in
git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git, yes?).

Thanks,
  Andrea
