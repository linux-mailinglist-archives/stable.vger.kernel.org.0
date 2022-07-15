Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708A8576379
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbiGOOOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbiGOOOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:14:12 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E3714091;
        Fri, 15 Jul 2022 07:14:10 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EA2735C00ED;
        Fri, 15 Jul 2022 10:14:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 15 Jul 2022 10:14:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1657894447; x=1657980847; bh=xUs+Fa77kr
        OyO5S4vACFreFi4W0sYUD0E2jG/FaLPJ0=; b=uaewZsONjI/FGiYO1CmrPp94pQ
        +EbTpYs0zltsiN2zMcbuHKqz+tMuJBG+Sfyoi+Aqaea1aUVFy353BG9zI0sp+lPQ
        d4ikMUtESrDAACgDP8/Mwa0TB18rkhZyhHvR8tHBlnCeadx80VWnpbJ9ChQY4oZx
        5IDXfBc9IufgaZsEr80vvyqBgtHfEuRuL87trpnzs/jzyZRdD0gpNll6V2t7XNac
        0+ybP8HVbyc9Q/xc/9+WymO1XojBSD+/gziOUM/S1Vo3J7bLVaJRD8il3c3BLYPr
        ui9ozAf8Bg8fSr/ZmSCltcx2Fy5vTF50KUYT/+Np7PzNSO1yxuJlBXKIZQXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1657894447; x=1657980847; bh=xUs+Fa77krOyO5S4vACFreFi4W0s
        YUD0E2jG/FaLPJ0=; b=SNTD2mKFMG7hVD/tArK44XjJLKLmu4pB0SPLWpq46sWe
        xuTJBQp/aMsPpt/b+0ZAQEGh+1j/d+mGrvkNWDtJYlHim4UJSXAHP/wAhtFIfmiX
        Fu8NoCYXo3mq/eywmwzNuNn44Q8c37zpLSxI7ktB2V0gz4819KN69EwQFuUNNNi+
        3JDTxUeruv+F9+yU892LZslG2HkThCroJktB5kAmjKGtwq1NJYE9rAG1R9mXucU2
        DMj/r+Q8p08ZWN/STNeSgyogRekKO1/LKNZQ5A4TbTLzU7arSL7HqXr+L3IMnw10
        KpEjSsePRapzvA4eHB0QuiyG3tgGCzAsKvN21FH3qg==
X-ME-Sender: <xms:LnbRYu6JK8A7QOtt4SbNnQ449ycSfQ-JE4mnwika5sFRRGpmZ3ndbA>
    <xme:LnbRYn6q08OotmzFw85NojQZ2m5YZBrs6LSjBHegrMScM4FptF699GdBiQcCqE4xW
    R873XoyMPHtng>
X-ME-Received: <xmr:LnbRYtcj1fNhVrkPq-fKecq3nK8fQ7RAm0DWiSsTMrCjip7kqTqMCjBpLuSmWUljeQSpc3TWJt-OM_17kQJezGwSFcfy-lua>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekuddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:LnbRYrLYChHAFVJRn5QfggQl0gIp_TOWK68oBJDa1Y4UMJKfYfVELw>
    <xmx:LnbRYiL0qVztBl62gRF6IhfIHg8tDmlBEc8UPnVlHzdLXyy5CVwEgg>
    <xmx:LnbRYswa8jHVHu00hk_UZQ7a2SMFNuB-8zFP31uv4XaGkDwV1emNJA>
    <xmx:L3bRYhUmyk13avp4LuEqBpwv2OrsMg-Hv7rezY9IfN7Ze7iviscOGw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 Jul 2022 10:14:05 -0400 (EDT)
Date:   Fri, 15 Jul 2022 16:14:01 +0200
From:   Greg KH <greg@kroah.com>
To:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        yj.chiang@mediatek.com,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 5.4] sched/rt: Disable RT_RUNTIME_SHARE by default
Message-ID: <YtF2KVJkAnUlx5li@kroah.com>
References: <20220714073055.15049-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714073055.15049-1-mark-pk.tsai@mediatek.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 03:30:52PM +0800, Mark-PK Tsai wrote:
> From: Daniel Bristot de Oliveira <bristot@redhat.com>
> 
> commit 2586af1ac187f6b3a50930a4e33497074e81762d upstream.
> 
> The RT_RUNTIME_SHARE sched feature enables the sharing of rt_runtime
> between CPUs, allowing a CPU to run a real-time task up to 100% of the
> time while leaving more space for non-real-time tasks to run on the CPU
> that lend rt_runtime.
> 
> The problem is that a CPU can easily borrow enough rt_runtime to allow
> a spinning rt-task to run forever, starving per-cpu tasks like kworkers,
> which are non-real-time by design.
> 
> This patch disables RT_RUNTIME_SHARE by default, avoiding this problem.
> The feature will still be present for users that want to enable it,
> though.
> 
> Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Tested-by: Wei Wang <wvw@google.com>
> Link: https://lkml.kernel.org/r/b776ab46817e3db5d8ef79175fa0d71073c051c7.1600697903.git.bristot@redhat.com
> Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> Cc: stable@vger.kernel.org
> ---
>  kernel/sched/features.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
