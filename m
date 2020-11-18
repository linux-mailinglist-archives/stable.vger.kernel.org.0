Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552002B73BC
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 02:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgKRB0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 20:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgKRB0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 20:26:55 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FE1C061A48;
        Tue, 17 Nov 2020 17:26:55 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id p12so482679qtp.7;
        Tue, 17 Nov 2020 17:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+siBgeigTKwgqdEodZxPcEagNIOErMs+YIxpJIhQK+A=;
        b=Q4vXCLZE0FH5W+mM/S9FBKFN/h/p/b++zSG9LBW01PsX76cVZmOsXACYsGeTQLBzsa
         Kv3yvUJ7wICXYQT517nE081xalHJ6Y9q3pQ7230iWpvrK/9J6lMjHJptYqjGR5oCCakU
         7/zV3/nCTtMng8oYIPRu6O1MqxyfEQTkq3OqlH/eDMeEBcC4sNc+kZV79KOV0gJe8tpR
         CNhfBxjitKbbV6CbC2Rjz+Lnpm7JWg51rKQyyxlRKlE9Bv0wZchoZX6DO13TLOyoDcXZ
         pmRXRdKidA0F4Iw9IAitHzbBb2EN+gd6RXtq2/l47/UKGwrU0YMgL8yuLOBR3CZi59hk
         y8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+siBgeigTKwgqdEodZxPcEagNIOErMs+YIxpJIhQK+A=;
        b=sSfmJnvU8LQsYVOqlYxgcVWN9FyUzal7Et+YfiADfkRNPzmFSCFQN+B+gQQaACXNxJ
         RCrFO7J7t55GCmfHU6sYS7VZ9onn8C96y1/NMJDwMqYmobylozGnPQpUmOi59AWQj+mT
         nb8gOeaiKCKGFlbvBkmko5jNUFO5cKJLI4VB9TPdXW+vWDYW9qC0QbAy2G4Z/tJp4L/3
         HxNnmO/yvZYON2HXzzhJUIfmX0pHnI1K+SMljfLHENQouNzdnGkEX8ig+5W+xq0brCCR
         bUiW4d3rkuOOa9C1CCQr/cE5P5OyQw+i+b5x2d8l43x2VoJChXJG8BcPdfcwcAVqwPNb
         1vxw==
X-Gm-Message-State: AOAM532Vi8Ao1jkvOTcHWlXc6hxAmb1YmZAQ7cAmjpNFpl27xHdq5JVz
        765MMi4ap/iLHcwjJFUKyR0=
X-Google-Smtp-Source: ABdhPJyzWuEpVf76Vk7KR2aXHB0bdZgvmt/rN0dpaGHYSKvETbq/rL5dCfTLzmWWka/bM3DUVGjGxA==
X-Received: by 2002:ac8:6f42:: with SMTP id n2mr2650380qtv.17.1605662814175;
        Tue, 17 Nov 2020 17:26:54 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id k4sm6689552qtp.5.2020.11.17.17.26.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Nov 2020 17:26:53 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id 98E8A27C005B;
        Tue, 17 Nov 2020 20:26:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 17 Nov 2020 20:26:52 -0500
X-ME-Sender: <xms:XHi0Xw6LSJg0S2CLMijYGNXBt_o9Eca2CM_xoNLn-WbDdleTTik9ZA>
    <xme:XHi0Xx7lr6AzjQemi8eLGYMInZuMLwPTQqPF265ZZNs2GWdZg4X53AUes5NtJXMEL
    feIiHSUxPKUFDV8dA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepveeijedthfeijeefudehhedvveegudegteehgffgtddvuedtveegtedvvdef
    gedtnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepudeijedrvddvtddrvd
    druddvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:XHi0X_fZxaVmDhDqm3FV_ylKnULwCgYmKAICkI5rqvVfpClGcRsbsQ>
    <xmx:XHi0X1Ikqb3rrK7BetWEUduOpHsBXyTW21Wv-0cgXPUZUXeun7IV7w>
    <xmx:XHi0X0LngYtTtiL699hGqafz6wfztAXzBzAGhAFtHdOc1WmVQ8tSag>
    <xmx:XHi0X43Gx1CtpvCuA9W5vh09AIUt1zfhgkc6r67zdvumhuUojugqyw>
Received: from localhost (unknown [167.220.2.126])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA02F3280064;
        Tue, 17 Nov 2020 20:26:51 -0500 (EST)
Date:   Wed, 18 Nov 2020 09:26:34 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH AUTOSEL 5.9 13/21] lockdep: Avoid to modify chain keys in
 validate_chain()
Message-ID: <20201118012634.GF286534@boqun-archlinux>
References: <20201117125652.599614-1-sashal@kernel.org>
 <20201117125652.599614-13-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117125652.599614-13-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

I don't think this commit should be picked by stable, since the problem
it fixes is caused by commit f611e8cf98ec ("lockdep: Take read/write
status in consideration when generate chainkey"), which just got merged
in the merge window of 5.10. So 5.9 and 5.4 don't have the problem.

Regards,
Boqun

On Tue, Nov 17, 2020 at 07:56:44AM -0500, Sasha Levin wrote:
> From: Boqun Feng <boqun.feng@gmail.com>
> 
> [ Upstream commit d61fc96a37603384cd531622c1e89de1096b5123 ]
> 
> Chris Wilson reported a problem spotted by check_chain_key(): a chain
> key got changed in validate_chain() because we modify the ->read in
> validate_chain() to skip checks for dependency adding, and ->read is
> taken into calculation for chain key since commit f611e8cf98ec
> ("lockdep: Take read/write status in consideration when generate
> chainkey").
> 
> Fix this by avoiding to modify ->read in validate_chain() based on two
> facts: a) since we now support recursive read lock detection, there is
> no need to skip checks for dependency adding for recursive readers, b)
> since we have a), there is only one case left (nest_lock) where we want
> to skip checks in validate_chain(), we simply remove the modification
> for ->read and rely on the return value of check_deadlock() to skip the
> dependency adding.
> 
> Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lkml.kernel.org/r/20201102053743.450459-1-boqun.feng@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/locking/lockdep.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 3eb35ad1b5241..f3a4302a1251f 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -2421,7 +2421,9 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
>   * (Note that this has to be done separately, because the graph cannot
>   * detect such classes of deadlocks.)
>   *
> - * Returns: 0 on deadlock detected, 1 on OK, 2 on recursive read
> + * Returns: 0 on deadlock detected, 1 on OK, 2 if another lock with the same
> + * lock class is held but nest_lock is also held, i.e. we rely on the
> + * nest_lock to avoid the deadlock.
>   */
>  static int
>  check_deadlock(struct task_struct *curr, struct held_lock *next)
> @@ -2444,7 +2446,7 @@ check_deadlock(struct task_struct *curr, struct held_lock *next)
>  		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
>  		 */
>  		if ((next->read == 2) && prev->read)
> -			return 2;
> +			continue;
>  
>  		/*
>  		 * We're holding the nest_lock, which serializes this lock's
> @@ -3227,16 +3229,13 @@ static int validate_chain(struct task_struct *curr,
>  
>  		if (!ret)
>  			return 0;
> -		/*
> -		 * Mark recursive read, as we jump over it when
> -		 * building dependencies (just like we jump over
> -		 * trylock entries):
> -		 */
> -		if (ret == 2)
> -			hlock->read = 2;
>  		/*
>  		 * Add dependency only if this lock is not the head
> -		 * of the chain, and if it's not a secondary read-lock:
> +		 * of the chain, and if the new lock introduces no more
> +		 * lock dependency (because we already hold a lock with the
> +		 * same lock class) nor deadlock (because the nest_lock
> +		 * serializes nesting locks), see the comments for
> +		 * check_deadlock().
>  		 */
>  		if (!chain_head && ret != 2) {
>  			if (!check_prevs_add(curr, hlock))
> -- 
> 2.27.0
> 
