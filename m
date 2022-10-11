Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3835FBA6E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 20:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJKSeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 14:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiJKSeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 14:34:25 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9D95726C
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 11:34:23 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 518025C017D;
        Tue, 11 Oct 2022 14:34:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 11 Oct 2022 14:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1665513262; x=1665599662; bh=tUkvA6Sd73
        PXJdxu/HooEtnZSf+X5FncoEwQ1KQ3h9Q=; b=ApEQKSE/C8KOxaUdefxosdeeMB
        SYBLTO0p2oh3kH2ffYUaDbIhtNXM4gQjHERjSeenvsQgPTuH5HHsKhZ8q241OZu1
        Jw8zjHcW72qBsWbgrROrBKPfbSw5IGY3VgfTpUch2p96WA9v5aePwzom8daCUibe
        Zq2CWDxCm+Fxp+2i2Ats3m5PwTq8ufp0yVvE1znvazl90KygjEeDdyWMAkFHcIbc
        QL+LxaFpO1t7Bi5asOcvIAEqXvQc93+9p/ibip0ADa2fDGhehDo/tvUnK4YXcVWz
        bemvdyd5bY8Smb87G/KJuWf5t7594EUKMPoxCdPtht/PzlkVrJWJxRRUGpQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665513262; x=1665599662; bh=tUkvA6Sd73PXJdxu/HooEtnZSf+X
        5FncoEwQ1KQ3h9Q=; b=Bi6i5cDxY09EKCTGbQFj5mRcoNyPe3MG6xHAeB8OM5ed
        /2l6Zm/ANFywjCS0gGhvnuZJFZGJftaiemddg5dXGHUKpS4vXgHjfjC/LomwYfhY
        GoHJX4pGopVAnlulrAEcm9bgKUxDTALvAHgTD+ujIvB5z2CuL4lP0v4lD7k183Ia
        6ifm87E//xSR8It7kaPJZ04P4Uy0FNN86ITUyx+R/QeNUwpzeV1ylTA4KxP2C6xf
        jq8ewV8OozIdZrLLQ4BUESThNYCukvzdlB6AImF8bmMaNGT54P62VK1q+/f5GVcS
        bfNgR8KLWbFw27d2rSVxbyrGAwRjOw8OaD2V41NNgA==
X-ME-Sender: <xms:LrdFYwAWboXZbGwADsaYTt-VPON_PIpE1ChAAwcF306VD8g8FSljTg>
    <xme:LrdFYyh6mUerTFyxQkgrTFNCYsAVGQBtJWOx0hoO2LSGpCOFBN2ro7NJqQeHaCwoF
    eOBaT2YyOhaXA>
X-ME-Received: <xmr:LrdFYzlLWaROcQYtf-taAEd8xBiH2ozd7a-p5QdZG-_mvz4-yfJd-sxPGmo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejiedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:LrdFY2ypCT9xYt6hnjWdVgr0Nq-lqwhEtMg5HPA4zAyfBFhtfvvfWw>
    <xmx:LrdFY1TvJ5mWrqp1pSFKwVrgjwJo0UkrLJ31bWLxn2MzvfWsaV_bWw>
    <xmx:LrdFYxb7XBH7LmbfFKGhsecVkYx5W5s-avCAWM-48SOetiVdGXjecg>
    <xmx:LrdFY0H7jGCaLMCDXKoUcYBOzpdwEoOm9Y3qTIX6S9iR-BUFyidKyQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Oct 2022 14:34:21 -0400 (EDT)
Date:   Tue, 11 Oct 2022 20:35:04 +0200
From:   Greg KH <greg@kroah.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Vimal Agrawal <avimalin@gmail.com>, stable@vger.kernel.org,
        Vimal Agrawal <vimal.agrawal@sophos.com>
Subject: Re: [PATCH 4.14.y] netfilter: nf_queue: fix socket leak
Message-ID: <Y0W3WOGjj9na8yeQ@kroah.com>
References: <20221011172202.3709-1-vimal.agrawal@sophos.com>
 <20221011172902.GC19620@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011172902.GC19620@breakpoint.cc>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 07:29:02PM +0200, Florian Westphal wrote:
> Vimal Agrawal <avimalin@gmail.com> wrote:
> > Removal of the sock_hold got lost when backporting commit 4d05239203fa
> > ("netfilter: nf_queue: fix possible use-after-free") to 4.14
> > 
> > This was causing a socket leak and was caught by kmemleak.
> > Tested by running kmemleak again with this fix.
> 
> Thanks.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Now queued up, thanks.

greg k-h
