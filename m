Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971763F364B
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 00:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhHTWOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 18:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232211AbhHTWOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 18:14:14 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2872061029;
        Fri, 20 Aug 2021 22:13:35 +0000 (UTC)
Date:   Fri, 20 Aug 2021 18:13:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     gregkh@linuxfoundation.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        metze@samba.org, mingo@redhat.com, peterz@infradead.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracepoint: Use rcu get state and cond
 sync for static call" failed to apply to 5.10-stable tree
Message-ID: <20210820181306.72467e4a@oasis.local.home>
In-Reply-To: <20210820175738.GH4126399@paulmck-ThinkPad-P17-Gen-1>
References: <1628500832155134@kroah.com>
        <20210819170933.5c4c6a38@oasis.local.home>
        <20210819204204.00f9ad28@rorschach.local.home>
        <20210820175738.GH4126399@paulmck-ThinkPad-P17-Gen-1>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Aug 2021 10:57:38 -0700
"Paul E. McKenney" <paulmck@kernel.org> wrote:

> > Paul, do you have any issues with these four patches getting backported?  
> 
> I believe that you also need to backport 74612a07b83f ("srcu: Make Tiny
> SRCU use multi-bit grace-period counter").  Otherwise, Tiny SRCU polling
> grace periods will be at best working by accident.
> 
> This will also make your small conflict go away.

Thanks for looking at this Paul. Yes, that commit helps where I don't
have to do any fixes.

Greg,

Can you please backport the following commits to 5.10, and then reapply
this patch?

29d2bb94a8a1 ("srcu: Provide internal interface to start a Tree SRCU grace period")
5358c9fa54b0 ("srcu: Provide polling interfaces for Tree SRCU grace periods")
1a893c711a60 ("srcu: Provide internal interface to start a Tiny SRCU grace period")
74612a07b83f ("srcu: Make Tiny SRCU use multi-bit grace-period counter")
8b5bd67cf642 ("srcu: Provide polling interfaces for Tiny SRCU grace periods")

Thanks,

-- Steve
