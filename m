Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA36F680A7F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 11:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjA3KKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 05:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjA3KKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 05:10:51 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23766EB5;
        Mon, 30 Jan 2023 02:10:50 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 55EB75C00BF;
        Mon, 30 Jan 2023 05:10:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 30 Jan 2023 05:10:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1675073450; x=1675159850; bh=QPmaKWErOb
        HkxJKtSJxn4Y5wlbv/BaNd6xEYn+UsHbM=; b=P+gH9Ba6/DyA6PSs63/IOMttKh
        9hC6WqvOWDyIuMlC15RpVFOS1KgbmbVh990RCyjR2t+M+TSnaBvrsA5HiSdsdwkU
        Q5uQRoMuAdq3za2TWrFWjQ8qWiXB7sFc8k5ZCnBbhd/z1HmTIf55+xnpGwbT3wUm
        SgsRl8MffYsrRvKWIbXx3A3t6faaR5EnG8DHgz2Te6qPn/FC61VqU3BH4f6jQ4so
        vkgSqp37a5kXtOLGXyvcwFImC9WJzZ8j4JAWc3scW8kE3IKEHLVwT1Y7LD/k2Xhf
        f8iTypc8K2PL5jvORCkcgHHhgQjEa0bFT47BoivmqmSK9hNYQtd0GdsO9+7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675073450; x=1675159850; bh=QPmaKWErObHkxJKtSJxn4Y5wlbv/
        BaNd6xEYn+UsHbM=; b=rojJCwKzG9kPamWKFf+0y2mpW+n0+tE8MV41T7Qmx3w8
        drxeLJ4qBfv09lKg7IvwnCF2dDsjAaqGnNoWysYeM61EvlCPYmCr2WxyH4MvasMy
        WxAowF9nl2G+2vuMdA20naZbe/ZX+EH+J0g5IzDBqlIskmtt6KbGH970IP535YzL
        W7gzvjaP1Z6bRIZiL8o9uV4+hi8dma85fJAPguA679W/RhDu/Gzx2ggmMVfYcRht
        Ch8n0LxdrlwjyztENSdzCfwRGm/XS019foKtuvkDrAQc/+8bmJaboPfX8slt8KAZ
        OF242WmgKDb2z/f7+iqX1kS2Vd2n8WZJI7y6dZx5BA==
X-ME-Sender: <xms:qZfXY7nsvofMFnNRPLiYK4Uw7SlvuaWjGJJouKOAsumxDMb-mWtuGA>
    <xme:qZfXY-0ce0UYGv-R1dCZJDbBNfWHJvmor1HmpO6k59kCoIjTGz7PKE8YAUJNfu6vK
    JbWPX6n06pfow>
X-ME-Received: <xmr:qZfXYxqXRFm1McVTvp_1Sr-st1nKADJEkXnd4hkIxnoz2e1IyhE6_qR25BPjnBDrmXoXPjY4Zqa0md6G2nLGWsw0cezkA5Y3w7bO-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefvddgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:qZfXYzke0b7U3_lG-513eWps3zKdt-I6VMvbqfHeGLoTm0tQH40laQ>
    <xmx:qZfXY53YAKd0KEAk1EJ8YbKUi2BuOieIxNBPMRV8wH4bYecCyYt1dg>
    <xmx:qZfXYyvlmzXCAEbRa6iyiqqT2fWdNrj1_HmpvDe6W1GDEpvGhzCg3g>
    <xmx:qpfXYyvMcgAIpZz7oOW9WzujimJgZkBlEfY5rf_5vUakPlmIUsyyrg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Jan 2023 05:10:49 -0500 (EST)
Date:   Mon, 30 Jan 2023 11:10:46 +0100
From:   Greg KH <greg@kroah.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Nikos Tsironis <ntsironis@arrikto.com>,
        linux-stable <stable@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: Re: [PATCH 5.4 0/1] nfsd: Ensure knfsd shuts down when the "nfsd"
 pseudofs is unmounted
Message-ID: <Y9eXpnXocP0IfHBE@kroah.com>
References: <20230123152822.868326-1-ntsironis@arrikto.com>
 <D98E42F0-3329-41DA-940B-4496AFC26340@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D98E42F0-3329-41DA-940B-4496AFC26340@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 03:42:55PM +0000, Chuck Lever III wrote:
> 
> 
> > On Jan 23, 2023, at 10:28 AM, Nikos Tsironis <ntsironis@arrikto.com> wrote:
> > 
> > The bug that upstream commit c6c7f2a84da45 ("nfsd: Ensure knfsd shuts
> > down when the "nfsd" pseudofs is unmounted") fixes in kernel v5.13
> > exists in kernel v5.4 too.
> > 
> > That is, knfsd threads are left behind once the nfsd pseudofs is
> > unmounted, e.g. when the container is killed.
> > 
> > I backported the patch to kernel v5.4, and tested it.
> 
> Nikos, thanks for taking care of this!

Both now queued up, thanks.

greg k-h
