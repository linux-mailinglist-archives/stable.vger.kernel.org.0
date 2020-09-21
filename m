Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E37E272B36
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgIUQLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:11:46 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50979 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727361AbgIUQLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 12:11:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2A597580231;
        Mon, 21 Sep 2020 12:11:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 21 Sep 2020 12:11:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=xQrSx4d0XhjREDqVDJQ2AwgtfiK
        I2i5h05Gyoz9jM4o=; b=cwvVz5vkKl/Xs8jFUfD9oiEVQvdifyVHewFH5VL0Hti
        /C1oA8c3jZ7FGo3J04f+q70gHDwSbQ5HVNC7470bQOlAjIISNiUg8Y4u5G0V5kF/
        0O7igqEwbGAp8VEXEJcCIJlYN/cR6BiT/menNcDiDhZArU8+7gEW8u6ehyh7mnmX
        nkl17k20gSArRqYGIwpGfP0HsgxlWlPJs1N6JJc/Jg6pl/eiIxus6gEt56xXiuTO
        E4KOBxtpGhcy9ZfEgLqqyrRiaI+0yD1zkcpcdS1nJwc6Ib4000Jov1AKe5Zin6GZ
        qxbLsKsj3cM9dFxP+PSrhbgvVhl0OlvJNTm0SdBxlJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xQrSx4
        d0XhjREDqVDJQ2AwgtfiKI2i5h05Gyoz9jM4o=; b=eNHufBtwKBHqpuKnGkwS0G
        dLXGggLdz7uJ/KOwpbwLDfzG0WtPEigOuPC6HropP0ZSdyi6gP7qY+cq+B+1lm2N
        LSIA5qgMyKnnB12S/Ks34/UN9iGngdHb+KolD+cXvg6Z/reu1GYYk5IetleJ3yHA
        8mE/LO0MUn/MXQsN99nhNad5lG6hfjQKQ/Bot2ytnVI1xonqsXA8zdEadNKNhYrw
        UcAxOkgn535uPFZrpyfqnEMLr7JURbo3NzS72rin2pLwXsLXBf9VONzFklFVbLl9
        jygXjP6ErSVDqDDJRC61V/rxMMPER8veRMVHE/IhGUdAUCvb4QqmJD+2tt/XVVmw
        ==
X-ME-Sender: <xms:wNBoX3UPk8-lMvNzsvxvyDjI6Drwn5BaUcUCSKvy8UhljCOq8gt_jg>
    <xme:wNBoX_nOUn-81VzgCcOLQVOuUEn73CtUHsoUQtSjCHtzgDREnamtfMqDV4HhnnhIw
    LZ5uXz2U1llQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:wNBoXzYuIk8s4tICIFhMpLQ_CNyXBUC1-PntvgBTd4F0bxv8BBJRiw>
    <xmx:wNBoXyWdvRl_PsrNtU1IHQ_t5Cc2giy7mfdeSg_xyJzD-aNoRsC0kA>
    <xmx:wNBoXxnrSoHU-ntEZ295EayKIiySDPbDDkaPCxhZaPpzGjCSfWdnnQ>
    <xmx:wdBoXyhRODZ2Fa5jqA4TgAaAAxwQG9Xs5ZqlqfJHxKeZasHhZs0H5A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2307306467D;
        Mon, 21 Sep 2020 12:11:43 -0400 (EDT)
Date:   Mon, 21 Sep 2020 18:12:05 +0200
From:   Greg KH <greg@kroah.com>
To:     Julius Hemanth Pitti <jpitti@cisco.com>
Cc:     akpm@linux-foundation.org, xlpang@linux.alibaba.com,
        mhocko@suse.com, vdavydov.dev@gmail.com, ktkhai@virtuozzo.com,
        hannes@cmpxchg.org, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH stable v5.8] mm: memcg: fix memcg reclaim soft lockup
Message-ID: <20200921161205.GC1096614@kroah.com>
References: <20200918011913.57159-1-jpitti@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918011913.57159-1-jpitti@cisco.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 06:19:13PM -0700, Julius Hemanth Pitti wrote:
> From: Xunlei Pang <xlpang@linux.alibaba.com>
> 
> commit e3336cab2579012b1e72b5265adf98e2d6e244ad upstream.
> 
> We've met softlockup with "CONFIG_PREEMPT_NONE=y", when the target memcg
> doesn't have any reclaimable memory.
> 
> It can be easily reproduced as below:
> 
>   watchdog: BUG: soft lockup - CPU#0 stuck for 111s![memcg_test:2204]
>   CPU: 0 PID: 2204 Comm: memcg_test Not tainted 5.9.0-rc2+ #12
>   Call Trace:
>     shrink_lruvec+0x49f/0x640
>     shrink_node+0x2a6/0x6f0
>     do_try_to_free_pages+0xe9/0x3e0
>     try_to_free_mem_cgroup_pages+0xef/0x1f0
>     try_charge+0x2c1/0x750
>     mem_cgroup_charge+0xd7/0x240
>     __add_to_page_cache_locked+0x2fd/0x370
>     add_to_page_cache_lru+0x4a/0xc0
>     pagecache_get_page+0x10b/0x2f0
>     filemap_fault+0x661/0xad0
>     ext4_filemap_fault+0x2c/0x40
>     __do_fault+0x4d/0xf9
>     handle_mm_fault+0x1080/0x1790
> 
> It only happens on our 1-vcpu instances, because there's no chance for
> oom reaper to run to reclaim the to-be-killed process.
> 
> Add a cond_resched() at the upper shrink_node_memcgs() to solve this
> issue, this will mean that we will get a scheduling point for each memcg
> in the reclaimed hierarchy without any dependency on the reclaimable
> memory in that memcg thus making it more predictable.
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Chris Down <chris@chrisdown.name>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Link: http://lkml.kernel.org/r/1598495549-67324-1-git-send-email-xlpang@linux.alibaba.com
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Fixes: b0dedc49a2da ("mm/vmscan.c: iterate only over charged shrinkers during memcg shrink_slab()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julius Hemanth Pitti <jpitti@cisco.com>
> ---
>  mm/vmscan.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

The Fixes: tag you show here goes back to 4.19, can you provide a 4.19.y
and 5.4.y version of this as well?

thanks,

greg k-h
