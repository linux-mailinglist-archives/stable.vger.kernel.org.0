Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068673CCC3A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 04:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhGSC1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 22:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhGSC1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 22:27:30 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBDAC061762;
        Sun, 18 Jul 2021 19:24:31 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id dp20so23991664ejc.7;
        Sun, 18 Jul 2021 19:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9wzES5Rx2ZgzRi8sMt53q34HdjM7XoePxBK57UeE8d8=;
        b=J36+gfPPPmqsSoJjuFTqWEUpJXgmWG9bOuUDpbiS0u/OpAKPBeP1KG6Typ1hMF9tgw
         pTdpoZjE74JO3lopBR+7xX3lsERF2FyYaGeXW6TfJJ0TocBjxXiaUbQDtwrl/gouk3dp
         zL6nqKSkEhyV7SxuiHEteDiBG0wQwvehklTofwqGJYvk2vsIm6R0A3OJWpvPouVUzT/h
         xWRdBzoorFDGLq/ho08L3ZNz6OrY8pP7hGVPSjAupMLk+DybN231TrCB0wqbITnZYXlQ
         2VRcOAP0iC7TxMwzUABdQWnxAZSD3tYiDIS2h77HKyIx3Pl9tB5oupUA1i3DQUrnxCm3
         92Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9wzES5Rx2ZgzRi8sMt53q34HdjM7XoePxBK57UeE8d8=;
        b=HvZE39dXZgjPiO6/QhMWya0SXOsLDNXY+fsfpSNIrvCP+7UfR/gf7mWgB3vAuG1wms
         lYnt4kWpSgyWNCz2W1oAUGYjdU56R0Kzeb70j8FvzYAkqeXdXXcytkCw4HUqC1FUSMeC
         jE/vIcTKVC1N/j1iX8Ycx8+8uqoLZsrVQttDPo3PygH/KmFO13aBZ0TNDlacnoC8vbnU
         x9+z8d2gPfYnt2FysFl7QcKR/xDqz0oPxJlpnVJgwRPrpNQHauulhciogmFoqbQFnHzP
         tqOx2t1VMDghvLJxohDn5ceAXthB5osfWfdGtNR3pmobGucsmfsKAvh2PPXQrPvciz4S
         NrPg==
X-Gm-Message-State: AOAM530DpwYS/APrOHpIhijWEp0nUBcQgmcSVTwFrU414UCKraK7w7H/
        yoqsyoM7szfjOK2/DzFhesT9P8wCozauxz+ltDc=
X-Google-Smtp-Source: ABdhPJzE5sszq/Y+IWCCXRX9c9YvB8skD0LzV6nAalA52e/wOO6vfaqzuxRWdK5sXIrcR1ePFBGLIr0Lhi9JsBYWMBQ=
X-Received: by 2002:a17:906:1997:: with SMTP id g23mr24608539ejd.304.1626661469850;
 Sun, 18 Jul 2021 19:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name> <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1> <YPSweHyCrD2q2Pue@casper.infradead.org>
 <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Mon, 19 Jul 2021 10:24:18 +0800
Message-ID: <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
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

On Mon, Jul 19, 2021 at 9:53 AM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Sun, Jul 18, 2021 at 11:51:36PM +0100, Matthew Wilcox wrote:
> > On Sun, Jul 18, 2021 at 02:59:14PM -0700, Paul E. McKenney wrote:
> > > > > https://lore.kernel.org/lkml/CAK2bqVK0Q9YcpakE7_Rc6nr-E4e2GnMOgi5jJj=_Eh_1k
> > > > > EHLHA@mail.gmail.com/
> > >
> > > But this one does show this warning in v5.12.17:
> > >
> > >     WARN_ON_ONCE(!preempt && rcu_preempt_depth() > 0);
> > >
> > > This is in rcu_note_context_switch(), and could be caused by something
> > > like a schedule() within an RCU read-side critical section.  This would
> > > of course be RCU-usage bugs, given that you are not permitted to block
> > > within an RCU read-side critical section.
> > >
> > > I suggest checking the functions in the stack trace to see where the
> > > rcu_read_lock() is hiding.  CONFIG_PROVE_LOCKING might also be helpful.
> >
> > I'm not sure I see it in this stack trace.
> >
> > Is it possible that there's something taking the rcu read lock in an
> > interrupt handler, then returning from the interrupt handler without
> > releasing the rcu lock?  Do we have debugging that would fire if
> > somebody did this?
>
> Lockdep should complain, but in the absence of lockdep I don't know
> that anything would gripe in this situation.
I think Lockdep should complain.
Meanwhile, I examined the 5.12.17 by naked eye, and found a suspicious place
that could possibly trigger that problem:

struct swap_info_struct *get_swap_device(swp_entry_t entry)
{
     struct swap_info_struct *si;
     unsigned long offset;

     if (!entry.val)
             goto out;
    si = swp_swap_info(entry);
    if (!si)
       goto bad_nofile;

   rcu_read_lock();
  if (data_race(!(si->flags & SWP_VALID)))
     goto unlock_out;
  offset = swp_offset(entry);
  if (offset >= si->max)
   goto unlock_out;

  return si;
bad_nofile:
  pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
out:
  return NULL;
unlock_out:
  rcu_read_unlock();
  return NULL;
}
I guess the function "return si" without a rcu_read_unlock.

However the get_swap_device has changed in the mainline tree,
there is no rcu_read_lock anymore.

>
> Also, this is a preemptible kernel, so it is possible to trace
> __rcu_read_lock(), if that helps.
>
>                                                         Thanx, Paul
Thanx
Zhouyi
