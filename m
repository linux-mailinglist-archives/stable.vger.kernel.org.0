Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23911521352
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 13:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbiEJLQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 07:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240661AbiEJLQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 07:16:50 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A93E1FD878;
        Tue, 10 May 2022 04:12:53 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 47ADF3200910;
        Tue, 10 May 2022 07:12:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 10 May 2022 07:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652181168; x=1652267568; bh=z/RHlzP93P
        tV/OpdlWjmbA2gD0PABkc9A9+fKWP+HBc=; b=MgRd/FgDuqSxndAuw4k4BtiQkw
        61iZDwNnU1UaOWU2ql4lfpiFgGrRG4dvIn2PPsW+4yaib4oLcaeMuOOMw+mOH6pL
        LxqRj+cnYYtOxJAfyFgrmwmT8fRnsu0BudgK6f98QC4iJ4Wzsja/HVFd49DYgXDJ
        do7umgVBlaKJceQclZjX7orpd8riMkO9zJTEQO9lHZxGa4R0Tck1OU1lPNNYwPXs
        ONGoVQbpXS+l1zHLcUZ98R6bPGdiyCgGMspPTjvbSXY78mxP+5EYphM0uHEX4q+Z
        6vhNCO+V0sl6havcErCBAwx6twfEJ0w3mbxYpwZUFIBdk0dxcNEpv7A1aY4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652181168; x=
        1652267568; bh=z/RHlzP93PtV/OpdlWjmbA2gD0PABkc9A9+fKWP+HBc=; b=q
        ceH2HMTRXXGzkPeQL6a1BO5UKymPS7hXdBazdjjeJVvPT39p/hrRttION1RzOxH0
        9P8KMgYyq5Mt1CCL0Egg+MJvO3zLlqxSnN4mZjnucJ34IQshP4DlR+/XT6v1Ok0v
        tbpgAbSRWItf1qq6QdYZUwnfX1PeMnN8XEIw+nnj3LYBMBuHKnNpMrDoVnSaynj9
        bZ5JqmS0qPQUzh96ku3Slezcw4AvH3QdxCQxJeSavwDspCSumkRTVkMbsOrt9xpv
        wGQyd7k+c6WwBe1Pc9NkOplibbQ6J5xZq9sJTG8eSy8klNUQHNPDH4oZI9Gw6Nw2
        HpMBP7kLe+EVpHEMX/33Q==
X-ME-Sender: <xms:sEh6YpcFuP5KSGVKxoXzZ689OxmjP2UcU4s_Lm-1GyFqNfnsofQxSg>
    <xme:sEh6YnMniirUYwcJdkK0yumAnw7ptygfHG6kiY1H5SVJWTmpmY11fxhg4p2iw6NwL
    dShzCfeUIsSbA>
X-ME-Received: <xmr:sEh6Yih2qEtld9XLbdGHI5OJQIXaFNQPeZxrslZwjfv3gn8_eY3skgRbdlInStfLlJs4N6jHCjar51_E-g2CzGUJTf2Wt0j8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedugdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:sEh6Yi-rpXKxX-fYGatK1ZqVf8hG1q4JSVssvedeheg1YNBF6NO3kw>
    <xmx:sEh6Ylvh7XVFPt12Uf2-OVovwtXn8zas1IHeetYCLFoVaZhHRqmxkQ>
    <xmx:sEh6YhFSixkPbGjrWCJpGfOsBnY-qmgX7kMmfmvXRcIzyxomfPwzUg>
    <xmx:sEh6Yu8I9H2klltEUJfis6DZbJZriP1YUZ7WJdQCneKVHUh5j4I3Xw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 May 2022 07:12:47 -0400 (EDT)
Date:   Tue, 10 May 2022 13:12:37 +0200
From:   Greg KH <greg@kroah.com>
To:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc:     stable@vger.kernel.org, RCU <rcu@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Neeraj Upadhyay <neeraj.iitr10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 0/2] RCU offloading vs scheduler latency(for 5.15 stable)
Message-ID: <YnpIpYgD7W4q+Nwj@kroah.com>
References: <20220503191709.155266-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503191709.155266-1-urezki@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 03, 2022 at 09:17:07PM +0200, Uladzislau Rezki (Sony) wrote:
> Motivation of backport:
> -----------------------
> 
> 1. The cfcdef5e30469 ("rcu: Allow rcu_do_batch() to dynamically adjust batch sizes")
> broke the default behaviour of "offloading rcu callbacks" setup. In that scenario
> after each callback the caller context was used to check if it has to be rescheduled
> giving a CPU time for others. After that change an "offloaded" setup can switch to
> time-based RCU callbacks processing, what can be long for latency sensitive workloads
> and SCHED_FIFO processes, i.e. callbacks are invoked for a long time with keeping
> preemption off and without checking cond_resched().
> 
> 2. Our devices which run Android and 5.10 kernel have some critical areas which
> are sensitive to latency. It is a low latency audio, 8k video, UI stack and so on.
> For example below is a trace that illustrates a delay of "irq/396-5-0072" RT task
> to complete IRQ processing:
> 
> <snip>
>   rcuop/6-54  [000] d.h2  183.752989: irq_handler_entry:    irq=85 name=i2c_geni
>   rcuop/6-54  [000] d.h5  183.753007: sched_waking:         comm=irq/396-5-0072 pid=12675 prio=49 target_cpu=000
>   rcuop/6-54  [000] dNh6  183.753014: sched_wakeup:         irq/396-5-0072:12675 [49] success=1 CPU:000
>   rcuop/6-54  [000] dNh2  183.753015: irq_handler_exit:     irq=85 ret=handled
>   rcuop/6-54  [000] .N..  183.753018: rcu_invoke_callback:  rcu_preempt rhp=0xffffff88ffd440b0 func=__d_free.cfi_jt
>   rcuop/6-54  [000] .N..  183.753020: rcu_invoke_callback:  rcu_preempt rhp=0xffffff892ffd8400 func=inode_free_by_rcu.cfi_jt
>   rcuop/6-54  [000] .N..  183.753021: rcu_invoke_callback:  rcu_preempt rhp=0xffffff89327cd708 func=i_callback.cfi_jt
>   ...
>   rcuop/6-54  [000] .N..  183.755941: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c5a968 func=i_callback.cfi_jt
>   rcuop/6-54  [000] .N..  183.755942: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c4bd20 func=__d_free.cfi_jt
>   rcuop/6-54  [000] dN..  183.755944: rcu_batch_end:        rcu_preempt CBs-invoked=2112 idle=>c<>c<>c<>c<
>   rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      Start context switch
>   rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      End context switch
>   rcuop/6-54  [000] d..2  183.755959: sched_switch:         rcuop/6:54 [120] R ==> migration/0:16 [0]
>   ...
>   migratio-16 [000] d..2  183.756021: sched_switch:         migration/0:16 [0] S ==> irq/396-5-0072:12675 [49]
> <snip>
> 
> The "irq/396-5-0072:12675" was delayed for ~3 milliseconds due to introduced side effect.
> Please note, on our Android devices we get ~70 000 callbacks registered to be invoked by
> the "rcuop/x" workers. This is during 1 seconds time interval and regular handset usage.
> Latencies bigger that 3 milliseconds affect our high-resolution audio streaming over the
> LDAC/Bluetooth stack.
> 
> Two patches depend on each other.

All now queued up, thanks.

greg k-h
