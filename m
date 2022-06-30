Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DE0561B3F
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiF3NZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiF3NZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:25:06 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C273120B
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 06:25:04 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 25E333200BC2;
        Thu, 30 Jun 2022 09:25:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 30 Jun 2022 09:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1656595500; x=1656681900; bh=y+GetT8fyP
        yDGQWNdMg82F249PFA78/nBcsVu/2VATM=; b=HOz07woRzW7x5AXr70puUfLtix
        /P7p9wxmaE4fPW18m0TCahiKth/okaDNscWjuJIv91wG+1UI9FzT9yW8q5Nrzyhr
        KC1dAxIDC6ABTH/YJSTg+9wM+3oPSrjMXvs+AR/AHwU1uwtYsXdkZCtgXBuCuWg9
        IxM2lqXaEPMu9dPy5dDwlIz0KsOJMbm2DlQHCdk6E8U5pftUnz8TYKwG1Y/6G9ue
        yjgPuDjrXtyhB3YKns4sQqWQmvxDua7NFpTFXCSHKctlLClmbtjJAADkyqYfNByK
        cn9KqvMvbfmiUpxTroJxwqhdSGv8l1BrEC8tq3SmYOzBkuYf2zEX01Zc54vQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1656595500; x=1656681900; bh=y+GetT8fyPyDGQWNdMg82F249PFA
        78/nBcsVu/2VATM=; b=VqTzUUtkkDP6jHWPGk89ZnsS68AqDGMrPt6bzfssMsca
        zFaEHbqLBo52NjPCuYtJDwDIeLGvCgdkn4tTNjYDchUYmn8qBuXAvn/hq9YBryND
        QttgEhf/u+wG7EGl+JKvqvI/o401XLnLXxlNJ54bj5TfqEVNx5Yv37af7BdG1KAB
        BQKqWrK4bgRYVcXHfKcilKo41ZKWPMlrwoGNHmad3pe9GClIbASxkikld7MuK87w
        fVR0y5q2D4JTNgatEXkyHO8q9Ee6Qm8C//M2/emY3+4VnsHJB7s6huuG/Ud0Wf8O
        aD/zqV4w2O0dBr0JPydUb2ezw9iZvf/y5EUYE96UBw==
X-ME-Sender: <xms:LKS9YhvcxTA4v95E4Shgi4H4Cv1golnTNCDhO2NWJk-fbIO1R9a-ew>
    <xme:LKS9YqcV2SLBvPTRKm4T_YAcy_4tvaoorGgWrhKeqteQZKXwTVd5bHwMqoTAcPr9O
    X2z-QrnlMZlnA>
X-ME-Received: <xmr:LKS9YkyaNp-q7gMWE_rjn5nUbCHFtWRNvM_sXzrXjR0C2W2aWDc4XYQdx-6rGc85xdyQZUZyHueksSVdkigHS459HtCGZNZ5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehuddgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepjeduge
    fggffffffhhfdvhffghedvteegteeuhfeifefhueevvdeffedugeehgfeknecuffhomhgr
    ihhnpeguvggsihgrnhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:LKS9YoNm00PFtMu3_ZGCKBV3KxjBGbCBB2Ck11zGJ82tQHzZl0f0Ew>
    <xmx:LKS9Yh8cJCYSMyHcWXzmv1jqoYgjLlmvgHbnq6iVCmNyImXwawv_jg>
    <xmx:LKS9YoVvHv4P7L2ZpVwtsifcI_FdSRrrMaXc_Zn6xQDtZw2BXhjAmQ>
    <xmx:LKS9Yhx-nnVkzV3cG9PFRcoBxuJI-WVWQAUkqXaUl9C4nI-vHA5uRQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Jun 2022 09:24:59 -0400 (EDT)
Date:   Thu, 30 Jun 2022 15:24:57 +0200
From:   Greg KH <greg@kroah.com>
To:     Diederik de Haas <didi.debian@cknow.org>
Cc:     stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Thorsten Glaser <tg@mirbsd.de>
Subject: Re: [PATCH] [4.19.y] net/sched: move NULL ptr check to qdisc_put()
 too
Message-ID: <Yr2kKTl/Vxg6hjYR@kroah.com>
References: <20220629224938.7760-1-didi.debian@cknow.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629224938.7760-1-didi.debian@cknow.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 30, 2022 at 12:49:38AM +0200, Diederik de Haas wrote:
> In commit 92833e8b5db6c209e9311ac8c6a44d3bf1856659 titled
> "net: sched: rename qdisc_destroy() to qdisc_put()" part of the
> functionality of qdisc_destroy() was moved into a (for linux-4.19.y)
> new function qdisk_put(), and the previous calls to qdisc_destroy()
> were changed to qdisk_put().
> This made it similar to f.e. 5.10.y and current master.
> 
> There was one part of qdisc_destroy() not moved over to qdisc_put() and
> that was the check for a NULL pointer, causing oopses.
> (See upstream commit: 6efb971ba8edfbd80b666f29de12882852f095ae)
> This patch fixes that.
> 
> Fixes: 92833e8b5db6c209e9311ac8c6a44d3bf1856659
> Reported-by: Thorsten Glaser <tg@mirbsd.de>
> Link: https://bugs.debian.org/1013299
> Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
> ---
>  net/sched/sch_generic.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
