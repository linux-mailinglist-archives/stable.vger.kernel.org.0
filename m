Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35FB3FD6B8
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243473AbhIAJZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243420AbhIAJZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 05:25:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D09E760243;
        Wed,  1 Sep 2021 09:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630488282;
        bh=3Ub5TuLCETYGSlCwYWm/uyw/bnQeicSeTu3XhHBG160=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xPA+8vmSKq55EsCti4I/UTvMgoD3n5RwGkfW1U5KAto4/vpVayhOmORYiPMEpuDo5
         xK95dJOIr4WQNwVokMeQ9XdAaoT9pe4woTggPTAzUk2fjtxL6lWUKfBHmfaFU9Tb20
         z2PsrYvrPL1Q9gu3RYAqxU/Cq6Zv1Umu+hScRdGY=
Date:   Wed, 1 Sep 2021 11:24:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        metze@samba.org, mingo@redhat.com, peterz@infradead.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracepoint: Use rcu get state and cond
 sync for static call" failed to apply to 5.10-stable tree
Message-ID: <YS9G0kzfRNmi0hiI@kroah.com>
References: <1628500832155134@kroah.com>
 <20210819170933.5c4c6a38@oasis.local.home>
 <20210819204204.00f9ad28@rorschach.local.home>
 <20210820175738.GH4126399@paulmck-ThinkPad-P17-Gen-1>
 <20210820181306.72467e4a@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820181306.72467e4a@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 06:13:28PM -0400, Steven Rostedt wrote:
> On Fri, 20 Aug 2021 10:57:38 -0700
> "Paul E. McKenney" <paulmck@kernel.org> wrote:
> 
> > > Paul, do you have any issues with these four patches getting backported?  
> > 
> > I believe that you also need to backport 74612a07b83f ("srcu: Make Tiny
> > SRCU use multi-bit grace-period counter").  Otherwise, Tiny SRCU polling
> > grace periods will be at best working by accident.
> > 
> > This will also make your small conflict go away.
> 
> Thanks for looking at this Paul. Yes, that commit helps where I don't
> have to do any fixes.
> 
> Greg,
> 
> Can you please backport the following commits to 5.10, and then reapply
> this patch?
> 
> 29d2bb94a8a1 ("srcu: Provide internal interface to start a Tree SRCU grace period")
> 5358c9fa54b0 ("srcu: Provide polling interfaces for Tree SRCU grace periods")
> 1a893c711a60 ("srcu: Provide internal interface to start a Tiny SRCU grace period")
> 74612a07b83f ("srcu: Make Tiny SRCU use multi-bit grace-period counter")
> 8b5bd67cf642 ("srcu: Provide polling interfaces for Tiny SRCU grace periods")

Now done, thanks.

greg k-h
