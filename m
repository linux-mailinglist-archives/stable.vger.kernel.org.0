Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08BD58C966
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 15:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243296AbiHHN1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 09:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243191AbiHHN1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 09:27:37 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DB56362;
        Mon,  8 Aug 2022 06:27:33 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0CCB85C010C;
        Mon,  8 Aug 2022 09:27:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 08 Aug 2022 09:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1659965250; x=1660051650; bh=9yU/BD+Nhh
        IlGGIBK5KPsqfAE+489H5LReRNuTWOVDo=; b=S4K0ZtoLpU2ZL0shDvQiUIHluo
        gU5H1JqzEzsN30ue2QU95fyjzYY9gq2Gu0pHZwv8mNvURMx6RG/pN2P8SqlBxMRm
        K5JOdT/jPJs4fQrSp94I1DdJqbj+KRm+/HA3NKEvihgEVHVMGozcF3YUUEDCtjtD
        0+ys4wqfqmOkjEUf83p/DkYRcWCFHLp4Xywl4XUExXzEb7O5YzA4pyw1AXk1HiGh
        a7EXr5Ut5PGwkXOS9w4zgLa0hAACMOvE3b7VQbNt+QHSNiLblq18KTtMm2ma4+6i
        DPp+cP7DO6nB8NwV0R/Vn+SL1ktdIZBETgw6ZDmjjHTJRrqKGXFwZ0nh+CQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1659965250; x=1660051650; bh=9yU/BD+NhhIlGGIBK5KPsqfAE+48
        9H5LReRNuTWOVDo=; b=K5cws8jLKke4gFuXucb8s9F9NVckpYdf7U+Ojz4g0VLW
        ALkDdYdCe+ljK9b9CmwR0xGtOoq2eRU8LMwNL3IcTksx+hJXl+jw8LvpnfKXG65e
        DsSTs7ahPCsUmpJO3RBw2+9vXjwxixS5Sh0itDOyxA1hdVhE09lZBR328l46hO72
        2uPdP6As35hNzaEUNeLx950i+/Q50liQrGKBXZc46V26e2aAYv+IXTnqh6tb+DHB
        WPqivKDANNrhBCrKujvMs21zubxo/twJ/XSnvVTV3LS7kMhwtlis1Cwui3dorjJr
        Qfua2P3VwEU8l4tCNayYNGopnrFBe1knITdtFN+VwQ==
X-ME-Sender: <xms:QQ_xYkTRAUHpZXpojcHEjJqelgeVa_YwoYzRGv8BFanANcjxynrlow>
    <xme:QQ_xYhxOb3q4qrtRxpvuwdsy82OUTgzgT1J2CTz6LWAi29H5Vlps-xENhXwcrRig5
    GU2Qd4AhWAHzQ>
X-ME-Received: <xmr:QQ_xYh3CwWKYTQ3c9jcH-rs4a5YX4559U4vCPpTtqDd_uDiku4rtKBjJ6KklW-rn87dIyjoPosDZMHFidCtEDqSWjVJCX_8y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdefkedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:QQ_xYoAghX4a1DxESDFtKSRsbNbPj53FywO-2eyhM3ClovXc-TGLPQ>
    <xmx:QQ_xYtiaJawR6zx-7Z3v3OftLrqhaUz9Nrah1MmrqivPqkizL8AfKQ>
    <xmx:QQ_xYkqaJ6Vf4J8ecytf1prN03wBfRPJW0lECRWqUqo69FMVlChyaw>
    <xmx:Qg_xYiaTCLvBPBQUPYH-I24lm9Is7KpND-QHwWjqERCix3pPUOfARQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Aug 2022 09:27:29 -0400 (EDT)
Date:   Mon, 8 Aug 2022 15:27:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, wenst@chromium.org,
        hverkuil-cisco@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 5.4 1/1] media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on
 MMAP buffers across ioctls
Message-ID: <YvEPPU5YjddehpiZ@kroah.com>
References: <20220808124130.1928411-1-ovidiu.panait@windriver.com>
 <20220808124130.1928411-2-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808124130.1928411-2-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 03:41:30PM +0300, Ovidiu Panait wrote:
> From: Chen-Yu Tsai <wenst@chromium.org>
> 
> commit 8310ca94075e784bbb06593cd6c068ee6b6e4ca6 upstream.
> 
> DST_QUEUE_OFF_BASE is applied to offset/mem_offset on MMAP capture buffers
> only for the VIDIOC_QUERYBUF ioctl, while the userspace fields (including
> offset/mem_offset) are filled in for VIDIOC_{QUERY,PREPARE,Q,DQ}BUF
> ioctls. This leads to differences in the values presented to userspace.
> If userspace attempts to mmap the capture buffer directly using values
> from DQBUF, it will fail.
> 
> Move the code that applies the magic offset into a helper, and call
> that helper from all four ioctl entry points.
> 
> [hverkuil: drop unnecessary '= 0' in v4l2_m2m_querybuf() for ret]
> 
> Fixes: 7f98639def42 ("V4L/DVB: add memory-to-memory device helper framework for videobuf")
> Fixes: 908a0d7c588e ("[media] v4l: mem2mem: port to videobuf2")
> Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> [OP: backport to 5.4: adjusted return logic in v4l2_m2m_qbuf() to match the
> logic in the original commit: call v4l2_m2m_adjust_mem_offset() only if !ret
> and before the v4l2_m2m_try_schedule() call]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 60 ++++++++++++++++++++------
>  1 file changed, 46 insertions(+), 14 deletions(-)

Now queued up, thanks.

greg k-h
