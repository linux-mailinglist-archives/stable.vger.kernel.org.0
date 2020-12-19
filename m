Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A532DEEC9
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgLSMiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:38:05 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:57295 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgLSMiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 07:38:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 980B4608;
        Sat, 19 Dec 2020 07:36:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 19 Dec 2020 07:36:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=HXBxWTubP/lfXINd56IprsF/fqb
        6+dKOwrEVSr1ZwKc=; b=rmt/EJo9F9b+29ZROJME6cAMsXE+H39K406grVp2ecN
        oscJqYi60KnP79q5jwCldGmQPEGap4Msy7l6ANXwPUVwb7BTJtiBh//lT8rAn1ir
        HWNs6YteS/2xLAsVUVuyexSS4eDbALRTAiMcXwRbl1Ia0Pj5vzavTTvbyoLWZerr
        3FcpsJfHLaUh8HLs4itsF0cQ5ctTAIicDRHClq7p/XyDNDhtRlIEg7e5k6+6w8/2
        wjR/1XDKL5Ih+Lc1eDpac1nwDO1BnDlPxDJet9dtokUul5MJjzXiQL+LkrGWHKYk
        XN6ZdcLTtoK1KWyAjaw9D4KRWSHvSsmAQDL8d3F2fVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HXBxWT
        ubP/lfXINd56IprsF/fqb6+dKOwrEVSr1ZwKc=; b=pjimUa5IgfEghZ3tMCNtle
        7RHAV2zkeeS9ZgoLl9L8IlmTx30JpF/4RuGs/+Hb7N9odUrsJdfgjxJHICtoCrGj
        LKMzYPe5jQDOC8Re9BoHAdOTMXDlJaaKAS46SgZg/222atDqcFiB0zpAyOH67WDP
        KTuoo1/Cu13fANY14zjJl+2B/OlCkptKBa8u/9zeJ3UwoK+LH3lIsN4X8keTpOJt
        oIn7Hyckve10C8KjKX+xfvpo25y3z8L0JDqSYA6wXxD+BzRrlRyXVNItNSSz1hhI
        9OrITXMCjuG08GbFsXylrzmJVCSq7okQ3p8T70OtgA/XNohe1b7pDCZIkjfZfhtQ
        ==
X-ME-Sender: <xms:6vPdX2Md0j-7s_eD5xU3s5G1FS2GngslSPPAvpTKG6OW4VcPDdhLNA>
    <xme:6vPdX0-RFywIUaiOL78Hy-VQ6yKv_lgMy4iJKMkQd_l33yMz0P8W6FJxZBppSJLPa
    Iuu15IIbMv_dA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudelkedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:6vPdX9QwymDBZ3Jc-G4Imfs2jXz5G5pJHSscD-TctyvDzgqo8fEC1g>
    <xmx:6vPdX2uuSP5NdJXJIBWKl7Um2-ILBVirBsXUHPhkkQTQXG4P5Tz3Hw>
    <xmx:6vPdX-cpjmIMKmwM0CM807L_NA7nee9RX23IA3GuRrK-mLyvsfnAUg>
    <xmx:6vPdX_rsh0SdnGthTAgyUWVe8rOYaIEC3SfRLTrA4B3jXwjRxL3l6g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC4F2108005C;
        Sat, 19 Dec 2020 07:36:57 -0500 (EST)
Date:   Sat, 19 Dec 2020 13:38:19 +0100
From:   Greg KH <greg@kroah.com>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     stable@vger.kernel.org, fllinden@amazon.com, samjonas@amazon.com,
        surajjs@amazon.com
Subject: Re: [PATCH 4.14] mm: memcontrol: fix excessive complexity in
 memory.stat reporting
Message-ID: <X930O8w8w8VjCLP5@kroah.com>
References: <20201216221450.GB19206@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216221450.GB19206@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 16, 2020 at 10:14:50PM +0000, Shaoying Xu wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> [ Upstream commit a983b5ebee57209c99f68c8327072f25e0e6e3da ]
> 
> mm: memcontrol: fix excessive complexity in memory.stat reporting
> 
> We've seen memory.stat reads in top-level cgroups take up to fourteen
> seconds during a userspace bug that created tens of thousands of ghost
> cgroups pinned by lingering page cache.
> 
> Even with a more reasonable number of cgroups, aggregating memory.stat
> is unnecessarily heavy.  The complexity is this:
> 
>         nr_cgroups * nr_stat_items * nr_possible_cpus
> 
> where the stat items are ~70 at this point.  With 128 cgroups and 128
> CPUs - decent, not enormous setups - reading the top-level memory.stat
> has to aggregate over a million per-cpu counters.  This doesn't scale.
> 
> Instead of spreading the source of truth across all CPUs, use the
> per-cpu counters merely to batch updates to shared atomic counters.
> 
> This is the same as the per-cpu stocks we use for charging memory to the
> shared atomic page_counters, and also the way the global vmstat counters
> are implemented.
> 
> Vmstat has elaborate spilling thresholds that depend on the number of
> CPUs, amount of memory, and memory pressure - carefully balancing the
> cost of counter updates with the amount of per-cpu error.  That's
> because the vmstat counters are system-wide, but also used for decisions
> inside the kernel (e.g.  NR_FREE_PAGES in the allocator).  Neither is
> true for the memory controller.
> 
> Use the same static batch size we already use for page_counter updates
> during charging.  The per-cpu error in the stats will be 128k, which is
> an acceptable ratio of cores to memory accounting granularity.
> 
> [hannes@cmpxchg.org: fix warning in __this_cpu_xchg() calls]
> Link: http://lkml.kernel.org/r/20171201135750.GB8097@cmpxchg.org
> Link: http://lkml.kernel.org/r/20171103153336.24044-3-hannes@cmpxchg.org
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: stable@vger.kernel.org c9019e9: mm: memcontrol: eliminate raw access to stat and event counters
> Cc: stable@vger.kernel.org 2845426: mm: memcontrol: implement lruvec stat functions on top of each other
> Cc: stable@vger.kernel.org
> [shaoyi@amazon.com: resolved the conflict brought by commit 17ffa29c355658c8e9b19f56cbf0388500ca7905 in mm/memcontrol.c by contextual fix]
> Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
> ---
> The excessive complexity in memory.stat reporting was fixed in v4.16 but didn't appear to make it to 4.14 stable. When backporting this patch, there is a small conflict brought by commit 17ffa29c355658c8e9b19f56cbf0388500ca7905 within free_mem_cgroup_per_node_info() of mm/memcontrol.c and can be resolved by contextual fix.
> 
> include/linux/memcontrol.h |  96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------
> mm/memcontrol.c            | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------
> 2 files changed, 113 insertions(+), 84 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 1ffc54ac4cc9..882046863581 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -108,7 +108,10 @@ struct lruvec_stat {
>   */
> struct mem_cgroup_per_node {
> 	struct lruvec		lruvec;
> -	struct lruvec_stat __percpu *lruvec_stat;
> +
> +	struct lruvec_stat __percpu *lruvec_stat_cpu;
> +	atomic_long_t		lruvec_stat[NR_VM_NODE_STAT_ITEMS];
> +
> 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> 
> 	struct mem_cgroup_reclaim_iter	iter[DEF_PRIORITY + 1];


This patch is corrupted and can not be applied :(

Please fix up and resend.

thanks,

greg k-h
