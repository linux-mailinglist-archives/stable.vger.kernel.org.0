Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1433CCC3F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 04:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhGSCa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 22:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhGSCa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 22:30:56 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12066C061762;
        Sun, 18 Jul 2021 19:27:56 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ca14so21778748edb.2;
        Sun, 18 Jul 2021 19:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vU0E8MKFRQc5K71Zlz7p0MAFOgnAONKIzFrXpHRGGi0=;
        b=WCAyRpCcs5d/MKa3u46Yycnh4a/Gp4yK2fPNhcjjD90KeXiO34OHhGmg5Xh3yPYbs0
         ase1rSVB43YnUk2XvDiWIm9gVhy2ccVjB7dpgs4jSd4abfCBxtqJCkNdf1CmtP8vKoXX
         P1ykNsaOu4GNsHdxzjATRdt83cQnd/f3ZCCULc2l7HXNTqtd8bnUdPt4si5W+zGhuXjT
         EeT9skFcR4xjdLJJhVemI1LnFATXXrJkmhxsflqXeU5RReUMeVqu6L5Tg+Cj0xRtKJw2
         g5bw6BvntBw0Q3qySpLZ+bl0M0fkCsCc37UeYR8ZvKg6E4lyabXLqwYRt6JJQztc9XoM
         gSag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vU0E8MKFRQc5K71Zlz7p0MAFOgnAONKIzFrXpHRGGi0=;
        b=aj3ZBUa1G9YqlQncmHukzxsdySxagy0ISq7MK6pXeRHQ4D1yEbXfczPDSEOraWrVLA
         iBC6ohLpS17PHPCs3zmHGFeyFiJDPIkinvd5xzOWHWA4oXyAZhEaxU2+0xONg4eTqiEt
         5CCJxE4+nj7YsDhzROocj1ZoknNDVKyCoRxahDqtIBBg+l2DiJFrei0DJeG2gHxtspCk
         /zkD5s8/h4HgldQrGhovGuY7+rwpvzUUytEP9kJgI6SNIKYteWLqOr6egU0KVSqDwmUt
         9V9310XUD3WRT4Gmp3IPe/hk8QjifszOUvWDL2SdGGZ5PXuKOlWw+xE6+pnweyy7swox
         wqlg==
X-Gm-Message-State: AOAM533AQk2gOIBIVkV0743wtmSvvsOfhpfLSfN+N8bZH4SpvO8MAZaP
        TFMgtdq8WTTgNWfCJy2v6o3nRBC+guI2xPKc5/Y=
X-Google-Smtp-Source: ABdhPJwVqaQ0utHHnZ+CEhjr27gk3iYhwEDrNlh7JdlR+pY1ZfQfuuG3Kr4HwdgmE5P7cP1bVxJ1wHQvH4rDZh0/Qj0=
X-Received: by 2002:aa7:c7d0:: with SMTP id o16mr31528943eds.75.1626661674680;
 Sun, 18 Jul 2021 19:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name> <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1> <YPSweHyCrD2q2Pue@casper.infradead.org>
 <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1> <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
In-Reply-To: <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Mon, 19 Jul 2021 10:27:43 +0800
Message-ID: <CAABZP2yrK-Jqg2m8zWrBbRTMk7wF4dfwG=Dou_qCDDpgB9XBqA@mail.gmail.com>
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
To:     paulmck@kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 10:24 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>
> On Mon, Jul 19, 2021 at 9:53 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Sun, Jul 18, 2021 at 11:51:36PM +0100, Matthew Wilcox wrote:
> > > On Sun, Jul 18, 2021 at 02:59:14PM -0700, Paul E. McKenney wrote:
> > > > > > https://lore.kernel.org/lkml/CAK2bqVK0Q9YcpakE7_Rc6nr-E4e2GnMOgi5jJj=_Eh_1k
> > > > > > EHLHA@mail.gmail.com/
> > > >
> > > > But this one does show this warning in v5.12.17:
> > > >
> > > >     WARN_ON_ONCE(!preempt && rcu_preempt_depth() > 0);
> > > >
> > > > This is in rcu_note_context_switch(), and could be caused by something
> > > > like a schedule() within an RCU read-side critical section.  This would
> > > > of course be RCU-usage bugs, given that you are not permitted to block
> > > > within an RCU read-side critical section.
> > > >
> > > > I suggest checking the functions in the stack trace to see where the
> > > > rcu_read_lock() is hiding.  CONFIG_PROVE_LOCKING might also be helpful.
> > >
> > > I'm not sure I see it in this stack trace.
> > >
> > > Is it possible that there's something taking the rcu read lock in an
> > > interrupt handler, then returning from the interrupt handler without
> > > releasing the rcu lock?  Do we have debugging that would fire if
> > > somebody did this?
> >
> > Lockdep should complain, but in the absence of lockdep I don't know
> > that anything would gripe in this situation.
> I think Lockdep should complain.
> Meanwhile, I examined the 5.12.17 by naked eye, and found a suspicious place
I examined 5.13.2 the unpaired rcu_read_lock is still there
> that could possibly trigger that problem:
>
> struct swap_info_struct *get_swap_device(swp_entry_t entry)
> {
>      struct swap_info_struct *si;
>      unsigned long offset;
>
>      if (!entry.val)
>              goto out;
>     si = swp_swap_info(entry);
>     if (!si)
>        goto bad_nofile;
>
>    rcu_read_lock();
>   if (data_race(!(si->flags & SWP_VALID)))
>      goto unlock_out;
>   offset = swp_offset(entry);
>   if (offset >= si->max)
>    goto unlock_out;
>
>   return si;
> bad_nofile:
>   pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> out:
>   return NULL;
> unlock_out:
>   rcu_read_unlock();
>   return NULL;
> }
> I guess the function "return si" without a rcu_read_unlock.
>
> However the get_swap_device has changed in the mainline tree,
> there is no rcu_read_lock anymore.
>
> >
> > Also, this is a preemptible kernel, so it is possible to trace
> > __rcu_read_lock(), if that helps.
> >
> >                                                         Thanx, Paul
> Thanx
> Zhouyi
