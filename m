Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE11D61EE30
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 10:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiKGJHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 04:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiKGJHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 04:07:10 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5218165A8;
        Mon,  7 Nov 2022 01:07:09 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id BE1EB3200917;
        Mon,  7 Nov 2022 04:07:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 07 Nov 2022 04:07:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1667812028; x=1667898428; bh=Y+fwo5ogt2
        hEC8XQrIGKmX7N9BvjyB33Eh+j6hGdeng=; b=lxcyVL50KwYoRMJ4fIvZDvbm1j
        2doUNdnfdTwwCIBh7mfDiaAuRePxDrb1S21eudr7rMKbOsD6Sd4KSsH6JpLumkPr
        PCp64sA9cH7hsv932x62vL8Tq0QnAX/REWg+jAtnnLq6W/rAcWxo5qostmM0JXLK
        L3d9syF2sTTaw92xuO+8J3Ab0Qsn7JnWAirRUEpZ1aaNOqW+2EnAmZPWx7mry9Uh
        h0CrREkdcHidePEptzAAam9/lyz/p0lfSjVVISMs4EPCCF5LDii3RdBK9hSPsrKS
        LPplXcKNayX/33eZJW13RZc1PMfufPfZR6WKG5VqJjM3sYRVe0IXhbSvIeBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667812028; x=1667898428; bh=Y+fwo5ogt2hEC8XQrIGKmX7N9Bvj
        yB33Eh+j6hGdeng=; b=gtI8Sb2Noh15XiXJe1HmArm3wkBE/AA8RmCP3UU/DxeK
        dZaSPdN9lIrUgTiJdGov2/6+SrzIt5vCLHxmIpW2M6e1s7YkAwIyxfXYDB7WbNZF
        npxH4rZebinTasn6yq5mgNiww4TcjKbG+pGIJh4G1mriYxBbGaJSjCajeQRsOmxa
        MzHouANadO7wAkKjNj1RS4MHQJdxmDaSFMeLEotcfgEvGb/XnmARqlNeIW8PSd+c
        j9MdHLgrAoEF61vsN4cH8KbBcntQLKuBlulOJiLRcPX2y07L5fn1NEWltQ5NIipH
        ytuGMR7s75OXCG1I4pJd5WT9OngTQxGwqutGJzYHHQ==
X-ME-Sender: <xms:vMpoY--oOw0SJVt-9u04Pdz9QZn6gSTeqHtZa5Nb17kIGInpg3S-ZA>
    <xme:vMpoY-vDd4KG-ZFWBCiQOjX7nT7KScaa6_OqleH8jKwRXlEFOIAOPQa0wqwocSqZ3
    oHPht-Z2W3eWA>
X-ME-Received: <xmr:vMpoY0DlB4WF9wPa_Wu5lc_V50Mk3kTOKtMXnHpFqfMjt4Z5KYZTpjaSHaN0uIh4nkhgMcgcclIc1wZ0eielCjzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdejgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:vMpoY2eIN9j9mXpVCv6-7thMRnSFn4nM0T8AxOgJmUKDncUuAkA4kw>
    <xmx:vMpoYzNiaUH8aBWWcEGW0l6tH-LIT5tdEuOg1V9ju8-qFMt9SH4O5g>
    <xmx:vMpoYwk-A8rh_x89vzMkzxyxrTyrRISjcIox1YFEypvHPVR7ecNErA>
    <xmx:vMpoY4pQyd5XgaS1oCjIdklRpH99v-W3FlIn2QHWnYzt_aotGrlorA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 04:07:07 -0500 (EST)
Date:   Mon, 7 Nov 2022 10:07:06 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 5.15 0/2] fscrypt fixes for stable
Message-ID: <Y2jKuoFKsbu85plA@kroah.com>
References: <20221104231245.377347-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104231245.377347-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 04, 2022 at 04:12:43PM -0700, Eric Biggers wrote:
> Please apply these to 5.15-stable.

Now queued up, thanks.

greg k-h
