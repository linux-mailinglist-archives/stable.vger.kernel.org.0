Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873AC16BE95
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 11:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgBYKYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 05:24:47 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36686 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730157AbgBYKYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 05:24:47 -0500
Received: by mail-qt1-f193.google.com with SMTP id t13so8709904qto.3;
        Tue, 25 Feb 2020 02:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IWmm0RM6Eem/mETlAcEzwBRn4TiPqU8Kiq3aLckBMjI=;
        b=Vf81POjzNA3mQl4YsVcpJxS/XnR4ztifIm2ZfLJI92F60s92E3MQKUh+N9XmumHMO0
         Gjs0iIJ5GDMAxxhm1NRDdf9OGCjM/rWKH6zUovDWWFvmbCXJBCM22DUC0IUgu3eiRcbB
         6j3kNA8W+ZhhY3WrcTyNpdLGWfJPkOCwB9IoDtdl2JBGKWBBPwLtiyzUNQnN7YJWwXLn
         GbGilrQIdTk9c340/qgpiTCnaEWmx9Uav40syU/gTQAKYfMwE8pNMO/cfh6NoDE/cMDR
         76qqU37maVDXNELoZwMftJb+E5teNDSI7+GwgqCDuYiLtfhBLs5AA2v25UNTqB1UaocC
         4h9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IWmm0RM6Eem/mETlAcEzwBRn4TiPqU8Kiq3aLckBMjI=;
        b=dpRZrqjk2wGpwtBG28MDCUVWLgqLJ8oxYuKmb8ESJvDI4371hWrxor8oRwZ3+Hqe24
         KE3bpClo70+2vQaUrviGqtUWQCsICxzR6WEX5y6rXpRjz+58EWfrgd7Z6lrR/ZONZ6L2
         bgIexgwElpqldzPiqNePd1BepXuD4xW4VATi56eDO6c6alyPy5EKOrUNzFo2VMmBEVTG
         +Tyg+DNL6+AGf1ls8vH5wnJLqr2xLfBUGe18Iq6oVTvvsbGcm/8t+pBX65oOTjqR3X3e
         /TEUSgbKIR/RSlIvLaVUDuBh7P6KSPlY4ynWlrK5mVusFsh+tgWUGhtawSpclUChPUMf
         c0Qg==
X-Gm-Message-State: APjAAAVr10Bi9kiakn8Fu1vI3nqec6cI+18WbKtvAPxOEVEwKBXZcU4i
        ql5IY/KmtAGLyCfLYbfvabM=
X-Google-Smtp-Source: APXvYqzVgfWFtbnOKHINaW2TQVnhbpbHVOYc+gfh2F1YxIpouDKHYHKfVR8g6jsx+Lp5r99siIgZMA==
X-Received: by 2002:aed:2f45:: with SMTP id l63mr54545857qtd.221.1582626285231;
        Tue, 25 Feb 2020 02:24:45 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id i13sm7192847qki.70.2020.02.25.02.24.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 02:24:44 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id D3F45220C9;
        Tue, 25 Feb 2020 05:24:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 25 Feb 2020 05:24:43 -0500
X-ME-Sender: <xms:5vVUXnwCVFgj5Dd_-C8O27nPZO9vvzz3AbXDzz6WdQv6l7M_z9_pww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrledvgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhm
    rghilhdrtghomheqnecukfhppeehvddrudehhedrudduuddrjedunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhp
    rghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsg
    hoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:5vVUXnUc21exFTI09saCkjrOT_NT136qProL0dnyZw0Rdm24rf8RWw>
    <xmx:5vVUXmfxFju-kyMI-cYt1TXnXht7ESEmc76C67TQrOykolpJwhRZYA>
    <xmx:5vVUXtHkwUsOh4I6u6Quwd8RNDZnA7a4M0qINLRy3K2huOtM4DgS_A>
    <xmx:6_VUXge0gJQFIR65rbMeioq_p1wcSwHkSBn6WlauSuhpAjtUEeCfxAn5KKk>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id A21A3328005D;
        Tue, 25 Feb 2020 05:24:37 -0500 (EST)
Date:   Tue, 25 Feb 2020 18:24:36 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     paulmck@kernel.org
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
Message-ID: <20200225102436.GF110915@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200214235536.GA13364@paulmck-ThinkPad-P72>
 <20200214235607.13749-30-paulmck@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214235607.13749-30-paulmck@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On Fri, Feb 14, 2020 at 03:56:07PM -0800, paulmck@kernel.org wrote:
> From: "Paul E. McKenney" <paulmck@kernel.org>
> 
> Currently, rcu_barrier() ignores offline CPUs,  However, it is possible
> for an offline no-CBs CPU to have callbacks queued, and rcu_barrier()
> must wait for those callbacks.  This commit therefore makes rcu_barrier()
> directly invoke the rcu_barrier_func() with interrupts disabled for such
> CPUs.  This requires passing the CPU number into this function so that
> it can entrain the rcu_barrier() callback onto the correct CPU's callback
> list, given that the code must instead execute on the current CPU.
> 
> While in the area, this commit fixes a bug where the first CPU's callback
> might have been invoked before rcu_segcblist_entrain() returned, which
> would also result in an early wakeup.
> 
> Fixes: 5d6742b37727 ("rcu/nocb: Use rcu_segcblist for no-CBs CPUs")
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: <stable@vger.kernel.org> # 5.5.x
> ---
>  include/trace/events/rcu.h |  1 +
>  kernel/rcu/tree.c          | 32 ++++++++++++++++++++------------
>  2 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
> index 5e49b06..d56d54c 100644
> --- a/include/trace/events/rcu.h
> +++ b/include/trace/events/rcu.h
> @@ -712,6 +712,7 @@ TRACE_EVENT_RCU(rcu_torture_read,
>   *	"Begin": rcu_barrier() started.
>   *	"EarlyExit": rcu_barrier() piggybacked, thus early exit.
>   *	"Inc1": rcu_barrier() piggyback check counter incremented.
> + *	"OfflineNoCBQ": rcu_barrier() found offline no-CBs CPU with callbacks.
>   *	"OnlineQ": rcu_barrier() found online CPU with callbacks.
>   *	"OnlineNQ": rcu_barrier() found online CPU, no callbacks.
>   *	"IRQ": An rcu_barrier_callback() callback posted on remote CPU.
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index d15041f..160643e 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -3098,9 +3098,10 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
>  /*
>   * Called with preemption disabled, and from cross-cpu IRQ context.
>   */
> -static void rcu_barrier_func(void *unused)
> +static void rcu_barrier_func(void *cpu_in)
>  {
> -	struct rcu_data *rdp = raw_cpu_ptr(&rcu_data);
> +	uintptr_t cpu = (uintptr_t)cpu_in;
> +	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
>  
>  	rcu_barrier_trace(TPS("IRQ"), -1, rcu_state.barrier_sequence);
>  	rdp->barrier_head.func = rcu_barrier_callback;
> @@ -3127,7 +3128,7 @@ static void rcu_barrier_func(void *unused)
>   */
>  void rcu_barrier(void)
>  {
> -	int cpu;
> +	uintptr_t cpu;
>  	struct rcu_data *rdp;
>  	unsigned long s = rcu_seq_snap(&rcu_state.barrier_sequence);
>  
> @@ -3150,13 +3151,14 @@ void rcu_barrier(void)
>  	rcu_barrier_trace(TPS("Inc1"), -1, rcu_state.barrier_sequence);
>  
>  	/*
> -	 * Initialize the count to one rather than to zero in order to
> -	 * avoid a too-soon return to zero in case of a short grace period
> -	 * (or preemption of this task).  Exclude CPU-hotplug operations
> -	 * to ensure that no offline CPU has callbacks queued.
> +	 * Initialize the count to two rather than to zero in order
> +	 * to avoid a too-soon return to zero in case of an immediate
> +	 * invocation of the just-enqueued callback (or preemption of
> +	 * this task).  Exclude CPU-hotplug operations to ensure that no
> +	 * offline non-offloaded CPU has callbacks queued.
>  	 */
>  	init_completion(&rcu_state.barrier_completion);
> -	atomic_set(&rcu_state.barrier_cpu_count, 1);
> +	atomic_set(&rcu_state.barrier_cpu_count, 2);
>  	get_online_cpus();
>  
>  	/*
> @@ -3166,13 +3168,19 @@ void rcu_barrier(void)
>  	 */
>  	for_each_possible_cpu(cpu) {
>  		rdp = per_cpu_ptr(&rcu_data, cpu);
> -		if (!cpu_online(cpu) &&
> +		if (cpu_is_offline(cpu) &&
>  		    !rcu_segcblist_is_offloaded(&rdp->cblist))
>  			continue;
> -		if (rcu_segcblist_n_cbs(&rdp->cblist)) {
> +		if (rcu_segcblist_n_cbs(&rdp->cblist) && cpu_online(cpu)) {
>  			rcu_barrier_trace(TPS("OnlineQ"), cpu,
>  					  rcu_state.barrier_sequence);
> -			smp_call_function_single(cpu, rcu_barrier_func, NULL, 1);
> +			smp_call_function_single(cpu, rcu_barrier_func, (void *)cpu, 1);
> +		} else if (cpu_is_offline(cpu)) {

I wonder whether this should be:

		  else if (rcu_segcblist_n_cbs(&rdp->cblist) && cpu_is_offline(cpu))

? Because I think we only want to queue the barrier call back if there
are callbacks for a particular CPU. Am I missing something subtle?

Regards,
Boqun

> +			rcu_barrier_trace(TPS("OfflineNoCBQ"), cpu,
> +					  rcu_state.barrier_sequence);
> +			local_irq_disable();
> +			rcu_barrier_func((void *)cpu);
> +			local_irq_enable();
>  		} else {
>  			rcu_barrier_trace(TPS("OnlineNQ"), cpu,
>  					  rcu_state.barrier_sequence);
> @@ -3184,7 +3192,7 @@ void rcu_barrier(void)
>  	 * Now that we have an rcu_barrier_callback() callback on each
>  	 * CPU, and thus each counted, remove the initial count.
>  	 */
> -	if (atomic_dec_and_test(&rcu_state.barrier_cpu_count))
> +	if (atomic_sub_and_test(2, &rcu_state.barrier_cpu_count))
>  		complete(&rcu_state.barrier_completion);
>  
>  	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
> -- 
> 2.9.5
> 
