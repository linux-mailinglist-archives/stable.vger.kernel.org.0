Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF8F16F7E4
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 07:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgBZGOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 01:14:41 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35721 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgBZGOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 01:14:40 -0500
Received: by mail-qk1-f196.google.com with SMTP id 145so1639620qkl.2;
        Tue, 25 Feb 2020 22:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ldFSenbRaobXFFVp1f9QUTi/39L2YQ/OqXM/JGo52LQ=;
        b=fzly5Bt0lxR+i2u0c1cZjYUfRjnq/3BWstDBcDQuvUw7FMyh4CbKJrPP6EKDoQsLdN
         W3anSQ2tt+1+OR2LXca+GDf1UpOl1qYJUzHV1o5nwtIR9CKp0RvPV0EV9BLhaJ+x8I0C
         QZgxhDXe5yhh7N5NvxRvtM8EFqHsmGBf5R47CYyawj/TfRBjYzSTd90jRmeiHy08rpIm
         kuyTxG/BD0VCt70AsDgCttd1JX0rm6Cbjxtoy6N6fH2T392+pgIkiu46ldMi1f5ZLPF/
         a7jxIsKM6GhdXLeC8BWfwhhgW4ZzlnB92H3G1zmcP1uMVsLtXVi+PGLxHfODd8+fowbm
         bgeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ldFSenbRaobXFFVp1f9QUTi/39L2YQ/OqXM/JGo52LQ=;
        b=p8s6p67E+vw7ss41iom/EDaPpWIjNmOBGO4i9BQfSpkV6uhrk3gS/GD/+3SOMovCWF
         vKmNlM889WNM+VYPCQb6rT/nPIY/CtnxwafWn8Fz13VmUuLukKoHef8LEsSCJaLlVRw/
         VfaPFfyIh6GTthq/HIuXfb4XgDeL1gPCw80XNmzc5ZUmMB3e8ORMEsVsTF4GhcowF44V
         /Wwc8ZX7goKXk7zcg6+ZHtRP49Qd74H6XqBDclLUXfwqgN5joCXmZ5NXog0IScTR1IvS
         Q9aiu2xVMe+/eaqYmo4wzXDEOSDply1hG5FdzjUB/5udb+Dozuc+Li3VCzVHeXK/lsQP
         /Hxg==
X-Gm-Message-State: APjAAAUu0rUMPyTbRR5TqvcXvIGqpQZtAMQ9nYjp7upTq36W21GTM82u
        hgmrxKNbe51UjHHRyfbxwCc=
X-Google-Smtp-Source: APXvYqx+agJq5UAQQvCSqKYB0p4U2JJemof53VRAGUqT5ucpZVf+jarRYWQ9o50sXaLQuzeDW34nLg==
X-Received: by 2002:a05:620a:686:: with SMTP id f6mr3628750qkh.86.1582697679383;
        Tue, 25 Feb 2020 22:14:39 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id x22sm565383qtq.30.2020.02.25.22.14.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 22:14:38 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 1744E21B2C;
        Wed, 26 Feb 2020 01:14:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 01:14:37 -0500
X-ME-Sender: <xms:yQxWXrUZKMDVe39paIRKBNibCbCC3yny502xUEnhPZzHBltNApQV9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucfkphephedvrd
    duheehrdduuddurdejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqd
    eiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhl
    rdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:yQxWXreaspuYoRdWEIVK1yjKzgvGyg6PW7KnOpZQ5HVXXK_27Q1LHA>
    <xmx:yQxWXmypc8hXxsjbgLnwyCVQ1uuJkxBTAiTRs4MSCbSIq6dAHSQrXQ>
    <xmx:yQxWXuGyVy_Rm31dVn3Nhi-_sWJ0UyyKsGDpknVVLSwfkOoSdbOV9w>
    <xmx:zQxWXgKVOnzbvV5I1t3YylBWvcaA3DdsuyOc_aDV46N4CwHC1avBrwtI3kU>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id B03DE3060D1A;
        Wed, 26 Feb 2020 01:14:32 -0500 (EST)
Date:   Wed, 26 Feb 2020 14:14:30 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, mingo@kernel.org, jiangshanlai@gmail.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com,
        oleg@redhat.com, joel@joelfernandes.org,
        "# 5 . 5 . x" <stable@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 30/30] rcu: Make rcu_barrier() account for
 offline no-CBs CPUs
Message-ID: <20200226061430.GG110915@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200214235536.GA13364@paulmck-ThinkPad-P72>
 <20200214235607.13749-30-paulmck@kernel.org>
 <20200225102436.GF110915@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
 <20200226031455.GZ2935@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226031455.GZ2935@paulmck-ThinkPad-P72>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 07:14:55PM -0800, Paul E. McKenney wrote:
> On Tue, Feb 25, 2020 at 06:24:36PM +0800, Boqun Feng wrote:
> > Hi Paul,
> > 
> > On Fri, Feb 14, 2020 at 03:56:07PM -0800, paulmck@kernel.org wrote:
> > > From: "Paul E. McKenney" <paulmck@kernel.org>
> > > 
> > > Currently, rcu_barrier() ignores offline CPUs,  However, it is possible
> > > for an offline no-CBs CPU to have callbacks queued, and rcu_barrier()
> > > must wait for those callbacks.  This commit therefore makes rcu_barrier()
> > > directly invoke the rcu_barrier_func() with interrupts disabled for such
> > > CPUs.  This requires passing the CPU number into this function so that
> > > it can entrain the rcu_barrier() callback onto the correct CPU's callback
> > > list, given that the code must instead execute on the current CPU.
> > > 
> > > While in the area, this commit fixes a bug where the first CPU's callback
> > > might have been invoked before rcu_segcblist_entrain() returned, which
> > > would also result in an early wakeup.
> > > 
> > > Fixes: 5d6742b37727 ("rcu/nocb: Use rcu_segcblist for no-CBs CPUs")
> > > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > > Cc: <stable@vger.kernel.org> # 5.5.x
> > > ---
> > >  include/trace/events/rcu.h |  1 +
> > >  kernel/rcu/tree.c          | 32 ++++++++++++++++++++------------
> > >  2 files changed, 21 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
> > > index 5e49b06..d56d54c 100644
> > > --- a/include/trace/events/rcu.h
> > > +++ b/include/trace/events/rcu.h
> > > @@ -712,6 +712,7 @@ TRACE_EVENT_RCU(rcu_torture_read,
> > >   *	"Begin": rcu_barrier() started.
> > >   *	"EarlyExit": rcu_barrier() piggybacked, thus early exit.
> > >   *	"Inc1": rcu_barrier() piggyback check counter incremented.
> > > + *	"OfflineNoCBQ": rcu_barrier() found offline no-CBs CPU with callbacks.
> > >   *	"OnlineQ": rcu_barrier() found online CPU with callbacks.
> > >   *	"OnlineNQ": rcu_barrier() found online CPU, no callbacks.
> > >   *	"IRQ": An rcu_barrier_callback() callback posted on remote CPU.
> > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > index d15041f..160643e 100644
> > > --- a/kernel/rcu/tree.c
> > > +++ b/kernel/rcu/tree.c
> > > @@ -3098,9 +3098,10 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
> > >  /*
> > >   * Called with preemption disabled, and from cross-cpu IRQ context.
> > >   */
> > > -static void rcu_barrier_func(void *unused)
> > > +static void rcu_barrier_func(void *cpu_in)
> > >  {
> > > -	struct rcu_data *rdp = raw_cpu_ptr(&rcu_data);
> > > +	uintptr_t cpu = (uintptr_t)cpu_in;
> > > +	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
> > >  
> > >  	rcu_barrier_trace(TPS("IRQ"), -1, rcu_state.barrier_sequence);
> > >  	rdp->barrier_head.func = rcu_barrier_callback;
> > > @@ -3127,7 +3128,7 @@ static void rcu_barrier_func(void *unused)
> > >   */
> > >  void rcu_barrier(void)
> > >  {
> > > -	int cpu;
> > > +	uintptr_t cpu;
> > >  	struct rcu_data *rdp;
> > >  	unsigned long s = rcu_seq_snap(&rcu_state.barrier_sequence);
> > >  
> > > @@ -3150,13 +3151,14 @@ void rcu_barrier(void)
> > >  	rcu_barrier_trace(TPS("Inc1"), -1, rcu_state.barrier_sequence);
> > >  
> > >  	/*
> > > -	 * Initialize the count to one rather than to zero in order to
> > > -	 * avoid a too-soon return to zero in case of a short grace period
> > > -	 * (or preemption of this task).  Exclude CPU-hotplug operations
> > > -	 * to ensure that no offline CPU has callbacks queued.
> > > +	 * Initialize the count to two rather than to zero in order
> > > +	 * to avoid a too-soon return to zero in case of an immediate
> > > +	 * invocation of the just-enqueued callback (or preemption of
> > > +	 * this task).  Exclude CPU-hotplug operations to ensure that no
> > > +	 * offline non-offloaded CPU has callbacks queued.
> > >  	 */
> > >  	init_completion(&rcu_state.barrier_completion);
> > > -	atomic_set(&rcu_state.barrier_cpu_count, 1);
> > > +	atomic_set(&rcu_state.barrier_cpu_count, 2);
> > >  	get_online_cpus();
> > >  
> > >  	/*
> > > @@ -3166,13 +3168,19 @@ void rcu_barrier(void)
> > >  	 */
> > >  	for_each_possible_cpu(cpu) {
> > >  		rdp = per_cpu_ptr(&rcu_data, cpu);
> > > -		if (!cpu_online(cpu) &&
> > > +		if (cpu_is_offline(cpu) &&
> > >  		    !rcu_segcblist_is_offloaded(&rdp->cblist))
> > >  			continue;
> > > -		if (rcu_segcblist_n_cbs(&rdp->cblist)) {
> > > +		if (rcu_segcblist_n_cbs(&rdp->cblist) && cpu_online(cpu)) {
> > >  			rcu_barrier_trace(TPS("OnlineQ"), cpu,
> > >  					  rcu_state.barrier_sequence);
> > > -			smp_call_function_single(cpu, rcu_barrier_func, NULL, 1);
> > > +			smp_call_function_single(cpu, rcu_barrier_func, (void *)cpu, 1);
> > > +		} else if (cpu_is_offline(cpu)) {
> > 
> > I wonder whether this should be:
> > 
> > 		  else if (rcu_segcblist_n_cbs(&rdp->cblist) && cpu_is_offline(cpu))
> > 
> > ? Because I think we only want to queue the barrier call back if there
> > are callbacks for a particular CPU. Am I missing something subtle?
> 
> I don't believe that you are missing anything at all!
> 
> Thank you very much -- this bug would not have shown up in any validation
> setup that I am aware of.  ;-)
> 
> 							Thanx, Paul
> 
> > Regards,
> > Boqun
> > 
> > > +			rcu_barrier_trace(TPS("OfflineNoCBQ"), cpu,
> > > +					  rcu_state.barrier_sequence);
> > > +			local_irq_disable();
> > > +			rcu_barrier_func((void *)cpu);
> > > +			local_irq_enable();

Another (interesting) thing I found here is that we actually don't need
the irq-off section to call rcu_barrier_func() in this branch. Because
the target CPU is offlined, so only the cblist is only accessed at two
places, IIUC, one is the rcuo kthread and one is here (in
rcu_barrier()), and both places are in the process context rather than
irq context, so irq-off is not required to prevent the deadlock.

But yes, I know, if we drop the local_irq_disable/enable() pair here,
it will make lockdep very unhappy ;-)

Regards,
Boqun

> > >  		} else {
> > >  			rcu_barrier_trace(TPS("OnlineNQ"), cpu,
> > >  					  rcu_state.barrier_sequence);
> > > @@ -3184,7 +3192,7 @@ void rcu_barrier(void)
> > >  	 * Now that we have an rcu_barrier_callback() callback on each
> > >  	 * CPU, and thus each counted, remove the initial count.
> > >  	 */
> > > -	if (atomic_dec_and_test(&rcu_state.barrier_cpu_count))
> > > +	if (atomic_sub_and_test(2, &rcu_state.barrier_cpu_count))
> > >  		complete(&rcu_state.barrier_completion);
> > >  
> > >  	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
> > > -- 
> > > 2.9.5
> > > 
