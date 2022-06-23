Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6433557F80
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiFWQNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiFWQNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:13:00 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E538266A
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:12:56 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D0D15C01AC;
        Thu, 23 Jun 2022 12:12:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 23 Jun 2022 12:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1656000775; x=
        1656087175; bh=jG85UEi7Lh5KTl3s+DyV293NCn1nDP8DQKV09gDoq2s=; b=Q
        PmWmOdoSggZ7B3IqicRi2wP9EbPewrrmBTJTZXovl0BHceHAj/t7vVZtF2Zi7o8E
        Io8C9TQ85oy1bAiy3x61YCn8JXkAQwDJLfSFlcqGde7CfRaeKWvSTWXHZHc7La9d
        LNpJ7nUZVFzCqjLq4PK13S0/ymPeujjNMWQWBmmjt+zdPxNQHdjnrL2kjxF2fVyn
        XfIpwMD/3BGnhJphwRPrLzzQl/u035c72yjVJAF16CG75NO4VEAzbsWMOeb8b1i+
        CGfH0solqDWMMD7KFgIvHbukaJqlfWOA0kP1Uw+TtOUgeE+e81L1VCkuS2V14HXa
        gri8EdYBmiis66EhkRhVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1656000775; x=
        1656087175; bh=jG85UEi7Lh5KTl3s+DyV293NCn1nDP8DQKV09gDoq2s=; b=C
        3WzHE4jKpd+FwkhERbfcWZCRYDN0lWpMFFxikxoHxF8WUPrORBtyhMVsE6/LaVi2
        nYCmrZrgidHh7QDBtA/4nDpGB+MT38RXD8Ra8jCOFgB2tfqlGBU9KeXtGapDjUMg
        KUVpDAXczcRLGH96Na914yRdq25E7BM8uxEfkFymtbjp02krxIFwe5ud5WlwgyQe
        7rJgzFmuP0fgd3xxVEXv4CoEKiUcyXqgXMByac5SP2K92DRjSZchRNdOb6FIBPoD
        tmArLH89BtrzU7lB3nqSXH5B2qSgvEiDC0oN9ejZphcSKIfmmc0jC0/u2N1/wfwR
        8rLKZE5C2BXeYu0dJ3M9Q==
X-ME-Sender: <xms:B5G0YnZpOLydgvqozl9e3jpYPkVO501QZBLGV_vsbDYmXWrwngDsRg>
    <xme:B5G0YmYHg6cuP78MfDM3MLAipZ8cVk0WNvckJHgHqxacPN51rSas8NHs_nhttMy9I
    bRbqYj3KWm1Tw>
X-ME-Received: <xmr:B5G0Yp8i2EiObkMo6wi0w7TBVPxa41JDN5mB_UoYEq7wqIuAh65pXNeeVUHjaqwW8UiSMXkEYHNzSY3sMHLJW7YUUxOduKPm>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudefjedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepge
    evveetgfevjeffffevleeuhfejfeegueevfeetudejudefudetjedttdehueffnecuffho
    mhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:B5G0YtoDmUR81UdUbD8WTfmwmVOlDORnOuWbJXtxHhdQqWofrVBpOQ>
    <xmx:B5G0YipE2IPKe7QePa1STDX0Rk7pBbbRi0TGIfdkWxAeM6z69Lih0A>
    <xmx:B5G0YjRe8TPfvFoCf0Gw8XyljKDf6oOKYlBGDJ3Emjk3m35sW3G5fA>
    <xmx:B5G0Yrk_SsDP7jIYCfgkt_nEadpMsuRUrsIIptyg92VOSF_19IJNIg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jun 2022 12:12:54 -0400 (EDT)
Date:   Thu, 23 Jun 2022 18:12:52 +0200
From:   Greg KH <greg@kroah.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     stable@vger.kernel.org, Simon Sundberg <simon.sundberg@kau.se>
Subject: Re: [PATCH 5.15 1/2] bpf: Fix calling global functions from
 BPF_PROG_TYPE_EXT programs
Message-ID: <YrSRBHQ6aZ6x9jZv@kroah.com>
References: <20220621201345.112137-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220621201345.112137-1-toke@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 10:13:44PM +0200, Toke Høiland-Jørgensen wrote:
> commit f858c2b2ca04fc7ead291821a793638ae120c11d upstream
> 
> The verifier allows programs to call global functions as long as their
> argument types match, using BTF to check the function arguments. One of the
> allowed argument types to such global functions is PTR_TO_CTX; however the
> check for this fails on BPF_PROG_TYPE_EXT functions because the verifier
> uses the wrong type to fetch the vmlinux BTF ID for the program context
> type. This failure is seen when an XDP program is loaded using
> libxdp (which loads it as BPF_PROG_TYPE_EXT and attaches it to a global XDP
> type program).
> 
> Fix the issue by passing in the target program type instead of the
> BPF_PROG_TYPE_EXT type to bpf_prog_get_ctx() when checking function
> argument compatibility.
> 
> The first Fixes tag refers to the latest commit that touched the code in
> question, while the second one points to the code that first introduced
> the global function call verification.
> 
> v2:
> - Use resolve_prog_type()
> 
> Fixes: 3363bd0cfbb8 ("bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support")
> Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
> Reported-by: Simon Sundberg <simon.sundberg@kau.se>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Link: https://lore.kernel.org/r/20220606075253.28422-1-toke@redhat.com
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> [ backport: open-code missing resolve_prog_type() helper, resolve context diff ]
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

All now queued up, thanks.

greg k-h
