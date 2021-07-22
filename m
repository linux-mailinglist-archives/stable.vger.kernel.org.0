Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0773D2B57
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhGVREE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 13:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhGVRED (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 13:04:03 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1934C061575;
        Thu, 22 Jul 2021 10:44:37 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bu12so9645577ejb.0;
        Thu, 22 Jul 2021 10:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FMX9cI2MjlCU1069Vd1zqMo3Kf3dMHKY0sEauUXVam0=;
        b=K3iQOQmHVqTjeZYKttIfv+zKQbNyn3kcu35ed4l06BkwQoodEPvM46rTRYaob2swFF
         M3uONQTNkd2ttJBI6rRncRJxgR6xKPT1Ge46sCEciUKYyf5vPQmWwkcCllIavSJErdVK
         aPDG491lsbGvi/fD7WhPjLuIxqdPHiKyxZhzZZE43Eum0K0tRPnjzcWThgtjmtjZuwHn
         pEcrfQfgIbx89SWq27cWFvFr1IOqI55cFRQAE/Hyay5Lmr7tDCMj4Y3Jh18orVJVcgbc
         iwrF2N8m+4P+wFTf63C5/sFJdCoWulrawmE3K//IwtH7RVFEPRV9nTkqbOMceKBQ3iX/
         DOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FMX9cI2MjlCU1069Vd1zqMo3Kf3dMHKY0sEauUXVam0=;
        b=rt+aAYCdr9pC4sWIUWyea8aBiU668WEkXfmNTNibZ5eOZYLzcUmAR/gLsOPKRXrBoN
         fHhie8rWUVznjKlM3v1BKhzSq0Zi2zBnLI7gUOqYT+FbPgEOMPTDuk9OsGLFJ2+0g9AO
         9lJGZAgXq1EYOtf0sMqTKnG9tTHvRcAgGaasDJDUH5PNv2ID3hg9hTnf+AquxnaL7ibz
         X2OIqWJGK/nN5AmqcJHySzvLl6DKvJM20PV4dLeH2eJAQMk9hjyTjWekGJI5+1bz+NIS
         Unr8dyt/wMt6mqTmuYSxIeLq+OUwgo9uVOKgFzkZhDk/22SL6sWww3ajoAUhqsFQRn8G
         SN0w==
X-Gm-Message-State: AOAM530z/r736oSxGyn0je2lV89vohFNgcd1hHDqB6E6O+ANdli5JVGM
        o4zKA3wx0Y7f5OwQn1zKRSNHSuAnbQwDCDcwc24=
X-Google-Smtp-Source: ABdhPJyQhva9QrVgQiB5Mc+CziB2BT/qgDSdx2J40cjOdBjA2hqReE/i9pS6idiXQHzybnSf9IhsYFQUpVZBkbXPaiA=
X-Received: by 2002:a17:906:830a:: with SMTP id j10mr965231ejx.11.1626975876310;
 Thu, 22 Jul 2021 10:44:36 -0700 (PDT)
MIME-Version: 1.0
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <5812280.fcLxn8YiTP@natalenko.name> <YPVtBBumSTMKGuld@casper.infradead.org>
 <2237123.PRLUojbHBq@natalenko.name> <CAABZP2w4VKRPjNz+TW1_n=NhGw=CBNccMp-WGVRy32XxAVobRg@mail.gmail.com>
 <CAABZP2yh3J8+P=3PLZVaC47ymKC7PcfQCBBxjXJ9Ybn+HREbdg@mail.gmail.com>
 <fb8b8639-bf2d-161e-dc9a-6a63bf9db46e@googlemail.com> <CAABZP2xST9787xNujWeKODEW79KpjL7vHtqYjjGxOwoqXSWXDQ@mail.gmail.com>
 <YPlmMnZKgkcLderp@casper.infradead.org>
In-Reply-To: <YPlmMnZKgkcLderp@casper.infradead.org>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Fri, 23 Jul 2021 01:44:24 +0800
Message-ID: <CAABZP2x_opmE2vh8GRweNvCqogFjJ09UcNq-8t6qZDMsGNY9vA@mail.gmail.com>
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Chris Clayton <chris2553@googlemail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Boqun Feng <boqun.feng@gmail.com>, paulmck@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I apologize sincerely for my irresponsible and hasty email.
I reverted the unnecessary backport of 2799e77529c2 and 2efa33fc7f6e,
tested on the same qemu box as before with the same C program, there
is no warning about RCU this time. dmesg only shows the backtrace of
OOM kill.

As for memory OOMs caused by grace period's undue ends, I found each
deletion of a inode will cause a leak.
1035    void security_inode_free(struct inode *inode)
1036    {
1037        integrity_inode_free(inode);
1038        call_void_hook(inode_free_security, inode);
1039        /*
1040         * The inode may still be referenced in a path walk and
1041         * a call to security_inode_permission() can be made
1042         * after inode_free_security() is called. Ideally, the VFS
1043         * wouldn't do this, but fixing that is a much harder
1044         * job. For now, simply free the i_security via RCU, and
1045         * leave the current inode->i_security pointer intact.
1046         * The inode will be freed after the RCU grace period too.
1047         */
1048        if (inode->i_security)
1049            call_rcu((struct rcu_head *)inode->i_security,
1050                    inode_free_by_rcu);
1051    }

I am willing to do any experiment if there is a need.

Sorry again
Best Wishes
Zhouyi

On Thu, Jul 22, 2021 at 8:36 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Jul 22, 2021 at 04:57:57PM +0800, Zhouyi Zhou wrote:
> > Thanks for reviewing,
> >
> > What I have deduced from the dmesg  is:
> > In function do_swap_page,
> > after invoking
> > 3385        si = get_swap_device(entry); /* rcu_read_lock */
> > and before
> > 3561    out:
> > 3562        if (si)
> > 3563            put_swap_device(si);
> > The thread got scheduled out in
> > 3454        locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
> >
> > I am only familiar with Linux RCU subsystem, hope mm people can solve our
> > confusions.
>
> I don't understamd why you're still talking.  The problem is understood.
> You need to revert the unnecessary backport of 2799e77529c2 and
> 2efa33fc7f6e
