Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6700E334B24
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhCJWId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 17:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233493AbhCJWIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 17:08:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5636964E27;
        Wed, 10 Mar 2021 22:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615414091;
        bh=7DgS4RMA6sw3/cVUzknsVlM4gDfY7Ai2f4HejB8VsOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eCRD/Pu/fzPu7c54D8GC3G8AfxKorBs43jwNo7LYLzovcCoxjNgdsbbSF6xqjGHIf
         2kZ8AuOGzmPrQ6qZJr2lnLNCifIoCFvMOSOGp0HQGotg57ggsnLyF0dTNLmlOTHsBr
         KzOy2zl4xfxrrXZS9bUQDTEp5d0eT4+69oMC3HWYwc4EZVhF3F/Piu6NjDoIWRZKnd
         EJ7Tb6j05EfQVT9MCjfbtSdvXkm8L4kjlb9wkyB4Zk1vPI/Ec9tdjGCu48/UiR7AeB
         /Mj2VF4dKSyghotVTEN2vgOuCsYDCIaVE/mtKyAc+hqR754sWbnXjP6GsIOJKSbw0Y
         4KIOvP6hAP+WA==
Date:   Wed, 10 Mar 2021 23:08:09 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 11/13] rcu/nocb: Only cancel nocb timer if not polling
Message-ID: <20210310220809.GB2949@lothringen>
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-12-frederic@kernel.org>
 <20210303012229.GB20917@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303012229.GB20917@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 05:22:29PM -0800, Paul E. McKenney wrote:
> On Tue, Feb 23, 2021 at 01:10:09AM +0100, Frederic Weisbecker wrote:
> > No need to disarm the nocb_timer if rcu_nocb is polling because it
> > shouldn't be armed either.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> > Cc: Joel Fernandes <joel@joelfernandes.org>
> > Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> > Cc: Boqun Feng <boqun.feng@gmail.com>
> 
> OK, so it does make sense to move that del_timer() under the following
> "if" statement, then.  ;-)

Right, probably I should have handled that in the beginning of the patchset
instead of the end but heh, my mind is never that clear.

Thanks.
