Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1761B2F0687
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbhAJK74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 05:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbhAJK74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 05:59:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 908A023B28;
        Sun, 10 Jan 2021 10:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610276349;
        bh=m1/qjHW7YEW9Myks3uqNedgTmWTqLdt8G6Pyn5TdNu4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uzKfYXZ9nd1s5rMtiJdnyAJ650G/z1k8fMp06QyF1xD3bbfl1aW/Ub8Dgc1gyn+WM
         QYKDmxis3lqwYS/ovixQ+F9WDBfrH7ZTZ7335GrHJfTCGmvYKUXi8rwYv8jJZc203z
         mJi5FaPu7kVhn1Qti3Kvtm72sewqnMA8SBSTl2B2UHW65dIMnBY1H1mEEKzLmd7kdn
         RknqtbUs0SwI0SYpS9ZpkBKVPWv+KDpL8l8gohWcM0VC9IpakIVKHF98/wvgTuRUu9
         LTk4qqAaayw9TMjNxXj5q1yVWT+7yUGJMbWkbW89aX1r/bOncPUzVBJ1ta04RoOyOQ
         Sf6iAtYMYTlFA==
Date:   Sun, 10 Jan 2021 11:59:06 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 1/8] rcu: Remove superfluous rdp fetch
Message-ID: <20210110105906.GB204287@lothringen>
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-2-frederic@kernel.org>
 <X/lxZTsaMCV0yd9U@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/lxZTsaMCV0yd9U@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 09, 2021 at 10:03:33AM +0100, Greg KH wrote:
> On Sat, Jan 09, 2021 at 03:05:29AM +0100, Frederic Weisbecker wrote:
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar<mingo@kernel.org>
> > ---
> >  kernel/rcu/tree.c | 1 -
> >  1 file changed, 1 deletion(-)
> 
> I know I will not take patches without any changelog comments, maybe
> other maintainers are more lax.  Please write something real.

I must admit I've been lazy. Also I shoudn't have Cc'ed stable on
this one. Only a few commits are tagged for stable in this set. I'll
fix that on the next round.

Thanks!

> 
> And as for sending this to stable@vger, here's my form letter:
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
