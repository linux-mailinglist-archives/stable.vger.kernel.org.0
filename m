Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88CD6416F4
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLCNdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiLCNdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:33:01 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9485194
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 05:32:42 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 305C25C00CF;
        Sat,  3 Dec 2022 08:32:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 03 Dec 2022 08:32:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670074362; x=1670160762; bh=W90uSH1VWI
        xwxESbT4oTqBt0gbz7nt4AZIDPo7xpVgY=; b=UIy2YTVKmvTb05QB1mJFPWlHxO
        gbn9cOZlni5o+7bwh1Qyrub7Ub0IjOXV0MeDsLpPlnRN56r/fagDcNByqAECMfSo
        NYbM4uZ6xz8M1dYaOMnEUoDqsNx9PMJuHROXVQAet/ItCv0C87LHINq79Dl1jwRg
        secS01ytEKogRKDACpPztWSTw02C7uRCaZpXfrDhL11XT2tULirJ/PWkCnHQ20oi
        b/3QVBwSkeTQYRZo25Y6ZrYF6D8i1FeWDXZC82zla+jR48cxh5788dr0G4JKEDSO
        0QRo5h9ppQVKcZ8u/rCTyKpMs7GeLF1eibIjIAahDxroAyJh3qBhFTCLQOrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670074362; x=1670160762; bh=W90uSH1VWIxwxESbT4oTqBt0gbz7
        nt4AZIDPo7xpVgY=; b=RhDd5hRMk7i5fw6MgfjTnFIaM4oB0jzkj324WNRzkKt9
        DRGH9iWxl6zIG5Tn9QnCMrupuhzM2ckoKJv0ZDJ+2Xkp7U3IPt6/PMrdDouQSZ54
        QTj9/1+iG9NnzDZatn61EJwCbzzB4LoHoRd1yRtMVVSyy+enc2etALL/DkNB8CTX
        RYtA6OHEbXzRC2QWolNnQ73tNKZw5IBy0n+fDYfgcMBdKZsTVIkiSbJ+bXUXz/h1
        HhwL08qOzewkWFwkN/6hycKPD6tOZ2IFPpnpUMImqzisjKCj0iQ3PcvQPyG/+eeK
        pAO6GtRg+JmQcaxggNyy3V6AHpT+0XP0Hzda8s788g==
X-ME-Sender: <xms:-U-LY_frED03WkHBF2VwKQ54KXrAv6qTRjeGHMcD7hooR1Ib4vH9EQ>
    <xme:-U-LY1N-3jWljI9t0GLSdxfWUQVkIz5kShYUzS2D9f9hXAOfQahz6p-JBop0cqKJE
    StzT0vyIMZqig>
X-ME-Received: <xmr:-U-LY4izHjvttu_6t_NCUhW9J24houXHttgIHTqTD94ehFMp70Y_UJBPkt1_KTiI1W3aZgFft2P058uEizW8og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:-U-LYw8Nonf4HwsRU8B--vW7mHFvdzetuQOrqND-eb7BFVlx-JPo3A>
    <xmx:-U-LY7vN0s9l_YlkIR5z5_-zwkHfLdGIddft7b1y3K1YJIdgMoQcrw>
    <xmx:-U-LY_E24jRyl65KJvOSdlISEbokRTRxRcC-CN_w8RyEjtfnl_1AFA>
    <xmx:-k-LY_g8fdqeje3xo1isaojVgUaJ7AD303dCWSDBD-C0-e8lzHTeWA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 3 Dec 2022 08:32:41 -0500 (EST)
Date:   Sat, 3 Dec 2022 14:32:39 +0100
From:   Greg KH <greg@kroah.com>
To:     James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [stable:PATCH v5.4.225 0/2] arm64: errata: Spectre-BHB fixes
Message-ID: <Y4tP9+uUkOPhvSUZ@kroah.com>
References: <20221130182819.739068-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130182819.739068-1-james.morse@arm.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30, 2022 at 06:28:17PM +0000, James Morse wrote:
> Hello!
> 
> The first patch fixes an issue reported by Sami, where linux panic()s
> when bringing secondary CPUs online. The problem was the Spectre
> workarounds trying to allocate a new slot for mitigating KVM when
> those pages are no longer writeable.
> 
> While debugging that issue, I spotted the Spectre-BHB KVM mitigation was
> over-riding the Spectre-v2 KVM Mitigation. It's supposed to happen the
> other way round.
> 
> The backports aren't the same as mainline because the spectre mitigation code
> was totally rewritten for v5.10, and prior to that the KVM infrastructure
> is very different.

All now queued up, thanks.

greg k-h
