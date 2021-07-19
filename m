Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48E33CCC72
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 04:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbhGSDCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 23:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSDCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 23:02:15 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DB5C061762;
        Sun, 18 Jul 2021 19:59:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id k27so21814301edk.9;
        Sun, 18 Jul 2021 19:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nYVwyV2u8gzZBQODuuL7mZYv5EOHG+se5X56gjvhVXE=;
        b=SsYjEoFuizERfhFl5Tci5jvZbYST2y97nSOPA/5WBm074B3608+v1ejOxkTL3B33b/
         mWpODtNYXyVnOLRYUKbe11Wwy4pJE3YMEBjlVlJHeKnpTHl58dP7V9EunCUCxV7xHlx2
         nQijqxGcBr6SHPlXIEOMsjI0QVZhoBxLxc4JtpJjRU+Cxe9YZE1QfUTx4yAfPmTnW4Ep
         VJJO+K9pUPzJBtavUZ0wu+yBQ970JJbPpt7dLfQ/KvY30OT0vE2L32vHVfwTAi4PcpPN
         gkKuFvhCqzBUdkd9HumC+yl/PCcydP5xjv9qIn79XgRJ8jjPHrmT/XuNtzAZ/wFwLopH
         a8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nYVwyV2u8gzZBQODuuL7mZYv5EOHG+se5X56gjvhVXE=;
        b=eZhYYHxfcdliWHxMoPfLh5RY2yYpZXVOoKUn7JqQSaMubNRJS/Y/cTA0qetD9dQUW1
         k+nWJsbRWTYSwahkNKeHHvuPYYV/eG1GwmH7SqOoPYv/qtaYEUF7as5BGGUjYjwMcRUs
         hdh4kfocxGNqHEA9Mgx3RDSlHNgqgvZx758mlSdh+P3HiEvQfF2YQrQeCa/sPipbBuKA
         iLS9udPle5M/8scxQ7Db8VgvKtxM4/oNsBTHi12SBeRrSo+Vxjf1GXcbNBkkrhcNr+zj
         nBJzGjrTYygOMpyni2ouQ8FMDdGRSYX/ZHyvanbpcgmZ9g4iYaT3m2tMM8UAFJ/9HFIE
         Qlog==
X-Gm-Message-State: AOAM530vAhDi0Pe10HC6XV5+rLq7cN/2evDo+xCMkdNFXiYvCKHDU8PT
        2s7B9ONFgdrdps/k+aCv8DVcHkLh8pPwiLsEFrY=
X-Google-Smtp-Source: ABdhPJxSSKb79/S9KJ9skDqnDIkFKdKt19bv9pTS7aYFsq0K6EQF7spJo5XbpBWa42Zv96DgrV9EkbaqwPB1746h47A=
X-Received: by 2002:a05:6402:3192:: with SMTP id di18mr32589202edb.186.1626663553733;
 Sun, 18 Jul 2021 19:59:13 -0700 (PDT)
MIME-Version: 1.0
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name> <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1> <YPSweHyCrD2q2Pue@casper.infradead.org>
 <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1> <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
 <YPTmtNMJpykEpzx6@casper.infradead.org>
In-Reply-To: <YPTmtNMJpykEpzx6@casper.infradead.org>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Mon, 19 Jul 2021 10:59:02 +0800
Message-ID: <CAABZP2zDwQXyBv5vmcRVD5a45D77Fp1UsQRCyOn_-oL3B5c4+w@mail.gmail.com>
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
To:     Matthew Wilcox <willy@infradead.org>
Cc:     paulmck@kernel.org, Oleksandr Natalenko <oleksandr@natalenko.name>,
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

On Mon, Jul 19, 2021 at 10:44 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Jul 19, 2021 at 10:24:18AM +0800, Zhouyi Zhou wrote:
> > Meanwhile, I examined the 5.12.17 by naked eye, and found a suspicious place
> > that could possibly trigger that problem:
> >
> > struct swap_info_struct *get_swap_device(swp_entry_t entry)
> > {
> >      struct swap_info_struct *si;
> >      unsigned long offset;
> >
> >      if (!entry.val)
> >              goto out;
> >     si = swp_swap_info(entry);
> >     if (!si)
> >        goto bad_nofile;
> >
> >    rcu_read_lock();
> >   if (data_race(!(si->flags & SWP_VALID)))
> >      goto unlock_out;
> >   offset = swp_offset(entry);
> >   if (offset >= si->max)
> >    goto unlock_out;
> >
> >   return si;
> > bad_nofile:
> >   pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> > out:
> >   return NULL;
> > unlock_out:
> >   rcu_read_unlock();
> >   return NULL;
> > }
> > I guess the function "return si" without a rcu_read_unlock.
>
> Yes, but the caller is supposed to call put_swap_device() which
> calls rcu_read_unlock().  See commit eb085574a752.
I see, sorry for the mistake
