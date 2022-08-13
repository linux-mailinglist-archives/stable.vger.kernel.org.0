Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E8F591A77
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiHMNKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiHMNKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:10:09 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B8A20F65
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:10:05 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 78D965C0046;
        Sat, 13 Aug 2022 09:10:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 13 Aug 2022 09:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660396202; x=1660482602; bh=LhZpg/BSMq
        WRSJy3rXF4PDjn/GRXX04px6n1SJsjtnI=; b=OuIHnCShJ6v0Vrdx4KSOZI5zLU
        WCIPdVIseCJpCanGjT301SGw3foHdk+pWk7K1yTE02Y5zRCuVPIbSUB0DX3dnjJb
        B2YPAS/uooel/e3bTt0JwIrG9fCZQvCBZOppxjCG4KjOPxoCzPHIPlE4ZwOWfPcb
        FRQ/RFJUQgtf++oQZpmN1tJwbdEyJBBL0LsGOd0aK0S5UJosHclMc6PmQ3VCb5ub
        fJCBdBKS+f2cp9AwaTfYSVOS+qAXv/4LEOB9rVqq9cT0zlfdIMNUtAcZZ++QKWvB
        Lx0D7wQ5ytIom+u/5KlFX+J0/favDwSRd7Ka33hM41DLmxHxzqcquPkF8e+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660396202; x=1660482602; bh=LhZpg/BSMqWRSJy3rXF4PDjn/GRX
        X04px6n1SJsjtnI=; b=2Fid6fYBPkQKjSA6RwLrXofsyZaAathhsFvZbYHC5Gsv
        TlWHlDBK0uCAbdFZokM76KtY2+GIFQA/NqtRVDx2PmVxJHZXRxGcpmklIftm2Yvt
        K7xOupb0/WvtuMtJDa9TLqQ4bKtQKxQJiyRj4UQqtCdLdlP7Fh9OgPqN3SmgpJ/l
        KykNGeLD/p6iQzOCgJCUP0ROeGMHdFoejeWm8uFXGOw+lIv/nt+ykC/ZwQRL0F8I
        CTI8eOyuMJgjHmO0JJBBMdfEjfSn919v+4TBo2uRpjYYcrdChE/3GuoQ0ueLhobR
        0f/98kmOP7PyzbRy5YsHhZ0nkn2EKgWQXs/0O0x++w==
X-ME-Sender: <xms:qqL3YkKLUdi3toXZSg4sdsA5CDzArOuY1RLBs0Gnc929yDtWKuRlJA>
    <xme:qqL3YkKzo0I7NX6z1Owafo2grkVQ3BDJn1C1VauGC1oRniflz4WkkNx0iAdj6K_Yg
    wJ2JNN1cQ5FEA>
X-ME-Received: <xmr:qqL3Ykv3-OagNqHUtFDbmKV_D8S1YO3a097mu1WiGD4eLLqQZ7wizVRDsuPPS1jxHdiv0868kCNVWkAIno1UApfsozD7kD6c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdegkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:qqL3YhYZNk7AY7EZtuVn1jhW-BRuOnuQ7xKnixSLSG6oz8WCPRRl-w>
    <xmx:qqL3YrY2HljM1IUBr9TCjbVBpGEfqCUQzRNDDGND9nw-MltB19mVPQ>
    <xmx:qqL3YtBrs26yDMLXUFF2m3lSYU_j7PrHKdZai1nlwYQhYBums7Um1A>
    <xmx:qqL3YpNI0PzCQhOhpMi-8mjxnAyyiSzolOFu0gzj10EkEqW7m3Srvg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 13 Aug 2022 09:10:01 -0400 (EDT)
Date:   Sat, 13 Aug 2022 15:09:59 +0200
From:   Greg KH <greg@kroah.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.9] bpf: fix overflow in prog accounting
Message-ID: <Yveip6bBQ71zq1WL@kroah.com>
References: <20220812092211.14446-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812092211.14446-1-quentin@isovalent.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 12, 2022 at 10:22:11AM +0100, Quentin Monnet wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> [ Upstream commit 5ccb071e97fbd9ffe623a0d3977cc6d013bee93c ]
> 
> Commit aaac3ba95e4c ("bpf: charge user for creation of BPF maps and
> programs") made a wrong assumption of charging against prog->pages.
> Unlike map->pages, prog->pages are still subject to change when we
> need to expand the program through bpf_prog_realloc().
> 
> This can for example happen during verification stage when we need to
> expand and rewrite parts of the program. Should the required space
> cross a page boundary, then prog->pages is not the same anymore as
> its original value that we used to bpf_prog_charge_memlock() on. Thus,
> we'll hit a wrap-around during bpf_prog_uncharge_memlock() when prog
> is freed eventually. I noticed this that despite having unlimited
> memlock, programs suddenly refused to load with EPERM error due to
> insufficient memlock.
> 
> There are two ways to fix this issue. One would be to add a cached
> variable to struct bpf_prog that takes a snapshot of prog->pages at the
> time of charging. The other approach is to also account for resizes. I
> chose to go with the latter for a couple of reasons: i) We want accounting
> rather to be more accurate instead of further fooling limits, ii) adding
> yet another page counter on struct bpf_prog would also be a waste just
> for this purpose. We also do want to charge as early as possible to
> avoid going into the verifier just to find out later on that we crossed
> limits. The only place that needs to be fixed is bpf_prog_realloc(),
> since only here we expand the program, so we try to account for the
> needed delta and should we fail, call-sites check for outcome anyway.
> On cBPF to eBPF migrations, we don't grab a reference to the user as
> they are charged differently. With that in place, my test case worked
> fine.
> 
> Fixes: aaac3ba95e4c ("bpf: charge user for creation of BPF maps and programs")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [Quentin: backport to 4.9: Adjust context in bpf.h ]
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
> This fix was merged in Linux 4.10 but never backported to 4.9. The
> overflow has been occurring regularly when running Cilium's CI tests on
> kernel 4.9, so I would like to submit this patch for consideration to
> the 4.9 stable branch.
> 
> The initial patch applied with a minor conflict on include/linux/bpf.h,
> due to unprivileged_ebpf_enabled() backported in 6481835a9a5b
> ("x86/speculation: Include unprivileged eBPF status in Spectre v2
> mitigation reporting")

Now queued up, thanks.

greg k-h
