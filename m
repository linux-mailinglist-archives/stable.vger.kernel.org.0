Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB113A1E9F
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 23:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhFIVNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 17:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhFIVNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 17:13:37 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FD1661029;
        Wed,  9 Jun 2021 21:11:41 +0000 (UTC)
Date:   Wed, 9 Jun 2021 17:11:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     James Wang <jnwang@linux.alibaba.com>,
        Liangyan <liangyan.peng@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        yinbinbin@alibabacloud.com, wetp <wetp.zy@linux.alibaba.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tracing: Correct the length check which causes memory
 corruption
Message-ID: <20210609171139.3fa05337@oasis.local.home>
In-Reply-To: <CAHk-=win1FaZQga_XYSkRLx0-mF6dSm-HhP2RQ9ZZ3S380SeOg@mail.gmail.com>
References: <20210607125734.1770447-1-liangyan.peng@linux.alibaba.com>
        <71fa2e69-a60b-0795-5fef-31658f89591a@linux.alibaba.com>
        <CAHk-=whKbJkuVmzb0hD3N6q7veprUrSpiBHRxVY=AffWZPtxmg@mail.gmail.com>
        <20210609165154.3eab1749@oasis.local.home>
        <CAHk-=win1FaZQga_XYSkRLx0-mF6dSm-HhP2RQ9ZZ3S380SeOg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Jun 2021 13:55:04 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I think the cleanups could be separate. I in no way _hate_ Liangyan's
> patch, it's just that when looking at it I just went "that code is
> very confusing".

OK, I'll do the clean up now for the next merge window.

> 
> So I'm certainly also ok with just getting that ugly fix, and then
> hope for a cleanup later. Maybe with a comment or two.

My tests are currently at the "allyesconfig" portion, and has other
tests to finish up after that. So I expect it will be done in a few
hours, and if there's no issues, I'll send it to you after it is
completed.

Thanks,

-- Steve
