Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207BE53E6AC
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbiFFMJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbiFFMI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:08:59 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEDD13E20;
        Mon,  6 Jun 2022 05:08:58 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E806C5C0129;
        Mon,  6 Jun 2022 08:08:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 06 Jun 2022 08:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1654517334; x=1654603734; bh=e6S+D7pnoC
        BOsJkxb8MpQXTdJdiKsdb6ker+S/GBkJQ=; b=WL/j031teBBQfO8qk4FT+nxnPC
        Y712qAlXLmvF++ZZI1V97ADRpR541FSY1IOKpQQtZha197GSuAooz81UGD+cNAkp
        OqhEGjRp5HCclFiJaSTPcPKaImrmhXompvVymZRm/Nh9UUHqejd7X2BkxvtDfDSS
        cx+bFnSWV+NRW3mElWYfS8YAdGIVvfnDrESIENO5tAJvnvgp1Jdao2wI3MTz7Rx2
        ZEiRFMeXHNLgyo5wtBC29h1QtB7iWcH6xLqn5zitbX3sCXgBKHHZtELBMlY4zcvE
        WqtAGebNn/4FUHlacA0IOe5Eot3ORX+WhWEja6XWa18mAiSf8A0SdGkieYBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1654517334; x=1654603734; bh=e6S+D7pnoCBOsJkxb8MpQXTdJdiK
        sdb6ker+S/GBkJQ=; b=Y/0dvS3FKw5kA01GayLjJxSLrsZNDDnpQDfIeXj74vsX
        /8mG34Zmb949u5efxDh+YjAurmZzSlt7abNDvyl440BHvHPZu6Phcs2yNgZP9kTb
        kIPe7qVp9h+Zr9fdyPjg99CHrqIW7WUaHF8R/6PtkkMqxFq1I85Li6gZOfkfpzUi
        6g08gxBDgmsEB19Kyar15nSUYMtr5lsBjtp4cIZyhb9zNZqWHLweDacYNcUf1ymR
        fbEneJigoeCGfBfoGU5ih5WM+AuSw8aDeYK36nEzZ2scNgFX5Ub5rK4llKOzpJ9Q
        zqPeV6AdMF15+cb1zr1Vi/cNZSzooygj3xAUOgQ8mA==
X-ME-Sender: <xms:Vu6dYlW-gpFLQbrgB1GsK7cPAJ9zrBpBBEyIFTBIuMaVLT-2lNnBew>
    <xme:Vu6dYlmE_d-06gRWk3itCIR24WK9rA6hX2i6OQoCqEeKzQG6LPDiZbuRV8s9CKBa0
    T8SiSzmH7fgnw>
X-ME-Received: <xmr:Vu6dYhaoRUt7o8rT5XbZ8BxPKjIX1rPn0qRQi3RlA2-6BE9oduPox2E_3GflR8A1PqksjtL_YrXgEMdy4bKDzqkMmi-jOFfD>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddtvddggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:Vu6dYoXB1-7c_tb_VaVnmiOQTcMjtKm9_WAOAkYCQefPno_bWNdIeQ>
    <xmx:Vu6dYvmnmoJjqkhkcXr1z5oQx1hETiwH__bgV31UUEFBT5-gVfEaHQ>
    <xmx:Vu6dYlfXNdeO74cIVeQ1I_rn-gqYrGny8jkllJAut1mCj-FtRkUyzA>
    <xmx:Vu6dYj1NgJ9QgfZ_yAtdSaJS00oLs5EuhIZK1gtLV6QwiYl59d9iJw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jun 2022 08:08:53 -0400 (EDT)
Date:   Mon, 6 Jun 2022 14:08:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     stable@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, netfilter-devel@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        anishs@vmware.com, vsirnapalli@vmware.com, er.ajay.kaher@gmail.com
Subject: Re: [PATCH v5.4.y] netfilter: nf_tables: disallow non-stateful
 expression in sets earlier
Message-ID: <Yp3uURb8M7XWFw3E@kroah.com>
References: <1654503264-47182-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654503264-47182-1-git-send-email-akaher@vmware.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 01:44:24PM +0530, Ajay Kaher wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> commit 520778042ccca019f3ffa136dd0ca565c486cedd upstream.
> 
> Since 3e135cd499bf ("netfilter: nft_dynset: dynamic stateful expression
> instantiation"), it is possible to attach stateful expressions to set
> elements.
> 
> cd5125d8f518 ("netfilter: nf_tables: split set destruction in deactivate
> and destroy phase") introduces conditional destruction on the object to
> accomodate transaction semantics.
> 
> nft_expr_init() calls expr->ops->init() first, then check for
> NFT_STATEFUL_EXPR, this stills allows to initialize a non-stateful
> lookup expressions which points to a set, which might lead to UAF since
> the set is not properly detached from the set->binding for this case.
> Anyway, this combination is non-sense from nf_tables perspective.
> 
> This patch fixes this problem by checking for NFT_STATEFUL_EXPR before
> expr->ops->init() is called.
> 
> The reporter provides a KASAN splat and a poc reproducer (similar to
> those autogenerated by syzbot to report use-after-free errors). It is
> unknown to me if they are using syzbot or if they use similar automated
> tool to locate the bug that they are reporting.
> 
> For the record, this is the KASAN splat.
> 
> [   85.431824] ==================================================================
> [   85.432901] BUG: KASAN: use-after-free in nf_tables_bind_set+0x81b/0xa20
> [   85.433825] Write of size 8 at addr ffff8880286f0e98 by task poc/776
> [   85.434756]
> [   85.434999] CPU: 1 PID: 776 Comm: poc Tainted: G        W         5.18.0+ #2
> [   85.436023] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
> 
> Fixes: 0b2d8a7b638b ("netfilter: nf_tables: add helper functions for expression handling")
> Reported-and-tested-by: Aaron Adams <edg-e@nccgroup.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> [Ajay: Regenerated the patch for v5.4.y]
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  net/netfilter/nf_tables_api.c | 16 ++++++++++------
>  net/netfilter/nft_dynset.c    |  3 ---
>  2 files changed, 10 insertions(+), 9 deletions(-)

Both backports now queued up, thanks.

greg k-h
