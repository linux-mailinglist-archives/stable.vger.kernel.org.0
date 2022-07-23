Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D4257EF51
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 15:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiGWNzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 09:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiGWNzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 09:55:04 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4D11A3B7;
        Sat, 23 Jul 2022 06:55:03 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id AEE8932004CE;
        Sat, 23 Jul 2022 09:54:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 23 Jul 2022 09:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1658584499; x=1658670899; bh=Q+8K3gHBNF
        qHeIbtVzIb073wzdSnjciqKKDdNQyLlEY=; b=Ag2UIiZRazRWQyd3DdhVMX55en
        2fA7Qg3pHLmXjadGIlcG29CVBtJtYiUchJD+57V30Du+xx7W49LtKiYRpjAGqAsa
        CccWWsPhSBmimy6twPZ1c/BKKaG2O52EL1zYsfvdYRU/xpQ5xZ0dRcoSQxek+ydM
        rQDNNUVuVaIT83xDnTEZTK4M3f1FI4hxcXtVkW1KqVEIcTn9DFOSUjpPlI85L2RQ
        y56fHi5EzMV7n76vEHlb/4ot1wgymFipobvqhyHiXpzjUztn2ncCLhnz9FyZPAcy
        W9SDqp8niXAA19X/N1O5zouw/nIQbLNmOVzTmx7zVRrbRQddnMygEaIYuSGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1658584499; x=1658670899; bh=Q+8K3gHBNFqHeIbtVzIb073wzdSn
        jciqKKDdNQyLlEY=; b=t+MLJeKgT1TY1aE4NMp4Ns1iigNgfhEqqgBchwkwTG8e
        yhRXzuWs2O0KH25O8D6NKtpzj5pR8NQ43buap1JbmlaG3Dw38K0HGOqNfbinPCeY
        0xJzxSuvkSBcImYeqVVLUnhUfVVErgkdbzgMhj4hGi8k5ZX3jnYMfocRQi4D54tu
        eDhkr7Tl6ZJEFceiG9fPUlGk3NCGthGSP+suBxX/nE9XiO+dYGqfCqb7Na51BgEK
        3zOc9cfu/ibu0bHZX0CaqvOvoWYln3VLsvZA+UuAOsJoSPF0dx+bTMuetltIzn02
        9iDMgbLD0G1imx59Uxkz/7dOJtTKH2LfVwF1l5+BTw==
X-ME-Sender: <xms:sv3bYjo5z8BMdXyJ1MUFaWQ2Ji8EOtX_Sz5taB4ux0-fHDRE2aa7gw>
    <xme:sv3bYtqVE5vv2eAnuHfVNt8kruVh20hgaodX_eLkpPMgjPkzVQRPWZZjyP4YWVHVw
    RrTgtCNjktf3A>
X-ME-Received: <xmr:sv3bYgMCUcggTFAMcn1ALFaQexyxaVUbHCDS6QrxYJgr0T0se7SK_Q8FRAk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtgedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:sv3bYm7588vIXc-S6UM7WFR5XssKtopKZLUy3Xw5lNnkGAvNrsZJSQ>
    <xmx:sv3bYi7MpZqFQS_LWxDLSJir6Jfk17eC_mPiiJDDc3OSp0jEuk3d2g>
    <xmx:sv3bYujfV22KmAIzouaodBqpFzn7LJVoQtfGe6b9J0gBy0DYPPPesA>
    <xmx:s_3bYizHWq0PcaSwzia3gg2A7Fx0zU5fKFToj1q3Xxh_Gemq6r32Gg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 23 Jul 2022 09:54:58 -0400 (EDT)
Date:   Sat, 23 Jul 2022 15:54:57 +0200
From:   Greg KH <greg@kroah.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Lee Jones <lee@kernel.org>, stable@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5.10 1/1] io_uring: Use original task for req identity
 in io_identity_cow()
Message-ID: <Ytv9sdsy9iGcUrVy@kroah.com>
References: <20220719115251.441526-1-lee@kernel.org>
 <17dba691-2a2b-4b20-40c3-ec77282179b0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17dba691-2a2b-4b20-40c3-ec77282179b0@kernel.dk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 20, 2022 at 06:48:09AM -0600, Jens Axboe wrote:
> On 7/19/22 5:52 AM, Lee Jones wrote:
> > This issue is conceptually identical to the one fixed in 29f077d07051
> > ("io_uring: always use original task when preparing req identity"), so
> > rather than reinvent the wheel, I'm shamelessly quoting the commit
> > message from that patch - thanks Jens:
> > 
> >  "If the ring is setup with IORING_SETUP_IOPOLL and we have more than
> >   one task doing submissions on a ring, we can up in a situation where
> >   we assign the context from the current task rather than the request
> >   originator.
> > 
> >   Always use req->task rather than assume it's the same as current.
> > 
> >   No upstream patch exists for this issue, as only older kernels with
> >   the non-native workers have this problem."
> 
> Greg, can you pick this one up for 5.10-stable? Thanks!

Now queued up, thanks.

greg k-h
