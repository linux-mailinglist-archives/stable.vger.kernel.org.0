Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBEB24F3B1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHXINB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:13:01 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43539 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgHXINA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 04:13:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 03FA55C0051;
        Mon, 24 Aug 2020 04:13:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 Aug 2020 04:13:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=RvCGeNJyv963/SIcAMWK6e9t3IX
        8XSfpkU2Fz7CplkE=; b=ijhWLsAOeZm62jywdoRsxrWxshHF+E94DV9BFYySu+i
        F+KQRvMnk99KT2CFyfzTGInKnn7nFX9hgulY63CvYVreScP70wmnUH2zl57b72oR
        7lPzi4639uBF0hd4r8F5KPHO+rkI5FL9KArDCkh7Bt5XcDFve7JarZrosYPr+sN8
        YAeg3nKFqrmmBayoDI1axu28PE2EVIdjK0fQZVo6L1uKDQmPa822C3uNUbLuR22K
        hhVXEbndH7DBOTK8bl3/ZmMkp6HAYC0iHYzzCKKiUIFqhVnAFz4eW0Lj9p5Sf91i
        u0L6Vw/dhPsPYDbtutkCia5/tKy2BwRwVr4JQPheiSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RvCGeN
        Jyv963/SIcAMWK6e9t3IX8XSfpkU2Fz7CplkE=; b=dxWv4Cmosf4Zg21ioBnq7c
        b1eWIagluWXl/n6sbCJwIl5aktTHPUqw8jbU0tZLa7Lvt8vbkckqRFlH6Gh0nkzJ
        w5ODcjythoC1agTpqbHC8At1YvxuL/JD0EGdlwosQ4AuAbMrdHtd07ULdzlvhO4r
        SwijXHTviO3y/lkKkO0389lQQPQs8weV1dqBBn42dAzxOIlHGdDGuNPcrw3o9SSS
        H/BYgzqYlW8/ww2qYDOrwZ2sF/zJAlVPycLVB4OS/adoA/hweXAjLZ2RDWDOBHPn
        0TtkmU55y4X1BsaafskDrXXNG1CwpT9Ho8PGmdNtuqIhYlXlDudFhqq/yjhFw8+w
        ==
X-ME-Sender: <xms:i3ZDX1y2dVVPJiQaZszdhulruNj4_jaw_3a9cSApKMpMHV2_pbS88A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddujedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:i3ZDX1Rpu1Ep6y6ydJ0_Pa2s54gzLLv5t5w_uJ5HSPfzHCqj3Gec2w>
    <xmx:i3ZDX_WoPRYpnNwBpKAnd4qc_hknOVJ7mWFcqFGv23X9hg0ESo6RPQ>
    <xmx:i3ZDX3h6zFrAMK_caG0WCalnuvTMUNCTLRm6zjlAjgV1JsDRU8asQQ>
    <xmx:jHZDX-P0N0vV9DJ_703wmiSVXoqhFdrgSsmmWOFTY4UnYTZMgM-NIw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5128030600A6;
        Mon, 24 Aug 2020 04:12:59 -0400 (EDT)
Date:   Mon, 24 Aug 2020 10:13:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org, xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Sarah Newman <srn@prgmr.com>, Chris Brannon <cmb@prgmr.com>
Subject: Re: [PATCH] xen: don't reschedule in preemption off sections
Message-ID: <20200824081318.GC92813@kroah.com>
References: <20200820065908.20592-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820065908.20592-1-jgross@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 08:59:08AM +0200, Juergen Gross wrote:
> For support of long running hypercalls xen_maybe_preempt_hcall() is
> calling cond_resched() in case a hypercall marked as preemptible has
> been interrupted.
> 
> Normally this is no problem, as only hypercalls done via some ioctl()s
> are marked to be preemptible. In rare cases when during such a
> preemptible hypercall an interrupt occurs and any softirq action is
> started from irq_exit(), a further hypercall issued by the softirq
> handler will be regarded to be preemptible, too. This might lead to
> rescheduling in spite of the softirq handler potentially having set
> preempt_disable(), leading to splats like:
> 
> BUG: sleeping function called from invalid context at drivers/xen/preempt.c:37
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 20775, name: xl
> INFO: lockdep is turned off.
> CPU: 1 PID: 20775 Comm: xl Tainted: G D W 5.4.46-1_prgmr_debug.el7.x86_64 #1
> Call Trace:
> <IRQ>
> dump_stack+0x8f/0xd0
> ___might_sleep.cold.76+0xb2/0x103
> xen_maybe_preempt_hcall+0x48/0x70
> xen_do_hypervisor_callback+0x37/0x40
> RIP: e030:xen_hypercall_xen_version+0xa/0x20
> Code: ...
> RSP: e02b:ffffc900400dcc30 EFLAGS: 00000246
> RAX: 000000000004000d RBX: 0000000000000200 RCX: ffffffff8100122a
> RDX: ffff88812e788000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffffff83ee3ad0 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000246 R12: ffff8881824aa0b0
> R13: 0000000865496000 R14: 0000000865496000 R15: ffff88815d040000
> ? xen_hypercall_xen_version+0xa/0x20
> ? xen_force_evtchn_callback+0x9/0x10
> ? check_events+0x12/0x20
> ? xen_restore_fl_direct+0x1f/0x20
> ? _raw_spin_unlock_irqrestore+0x53/0x60
> ? debug_dma_sync_single_for_cpu+0x91/0xc0
> ? _raw_spin_unlock_irqrestore+0x53/0x60
> ? xen_swiotlb_sync_single_for_cpu+0x3d/0x140
> ? mlx4_en_process_rx_cq+0x6b6/0x1110 [mlx4_en]
> ? mlx4_en_poll_rx_cq+0x64/0x100 [mlx4_en]
> ? net_rx_action+0x151/0x4a0
> ? __do_softirq+0xed/0x55b
> ? irq_exit+0xea/0x100
> ? xen_evtchn_do_upcall+0x2c/0x40
> ? xen_do_hypervisor_callback+0x29/0x40
> </IRQ>
> ? xen_hypercall_domctl+0xa/0x20
> ? xen_hypercall_domctl+0x8/0x20
> ? privcmd_ioctl+0x221/0x990 [xen_privcmd]
> ? do_vfs_ioctl+0xa5/0x6f0
> ? ksys_ioctl+0x60/0x90
> ? trace_hardirqs_off_thunk+0x1a/0x20
> ? __x64_sys_ioctl+0x16/0x20
> ? do_syscall_64+0x62/0x250
> ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Fix that by testing preempt_count() before calling cond_resched().
> 
> In kernel 5.8 this can't happen any more due to the entry code rework
> (more than 100 patches, so not a candidate for backporting).
> 
> The issue was introduced in kernel 4.3, so this patch should go into
> all stable kernels in [4.3 ... 5.7].

Now queued up, thanks!

greg k-h
