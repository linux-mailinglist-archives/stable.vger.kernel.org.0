Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37F33AEA8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 10:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCOJZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 05:25:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55287 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229672AbhCOJZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 05:25:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7A95B5C0115;
        Mon, 15 Mar 2021 05:25:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 05:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=3EXiKnMUAFuuHGuDHVs6YRf1KCS
        bni1xY81yRpdy6J8=; b=lDXE5XM53fwgR/eOCFkIKddzSlEmV6Cw9BfnugDrHDO
        y83DzG8xCbt3uxHeV5Ex+yywTXL5iiLsQTxxckCq8h00igARBw7S0h6bhbA/KM1V
        1lqGp6xIu2zmhMqRsnUKtB/nDWWdPSl4b0MVr6xpN3Z6W9K+DVVxtdvFfvsQDQ31
        W/NhiXqsLWbHiNA5+DK53/5oiGsrzNlOo5fzTnQcCjNzbhSm3LlIYjRb+fMkIdoI
        uSYjszJ0NdEVENusW2PnJV1DOBwoP7c0DwxSYFy53J+s96kExYJZ6Sm0/ph5V7KO
        NtTuD2o1ft29tx1jlTD0y+vGdabr9NAxaNSRD+9zxEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3EXiKn
        MUAFuuHGuDHVs6YRf1KCSbni1xY81yRpdy6J8=; b=g4pYWbcxYN6hkThivDxP1l
        Py+EVbqcxLBqX2Fa8/atNA/9VYg1lRFsZstRp89m4twDP1fI26OxmTa3FHkpb+5o
        D9+pKTAdtQHifCl0qtFoxexRsHCwYjsb7GFh1QfH92ensvqfazAZQCDiyhRAX6na
        aJWirOrmxlMIAp4fuooYU1D47s+rfxHyL1o+fDUDDIWUrBIFPmqoTHXMmunF8dp8
        S2V5YE4jet2WOuEMJMwJXA5i0WOh9I7C//nbr2jv8wf88QFlyUawyq0qPJEA53bL
        gRznFekmqXtZOnvE/VHXRtIH5gwFEuAR1B0agsdsUjb6OfRqFFgPHzqT4t1vSexQ
        ==
X-ME-Sender: <xms:DyhPYNFl4JS0dZcvi0E2KVMEQNexfT-zmJZVenMK5IXv9TXdM3V6LQ>
    <xme:DyhPYCU8p2Fi1c9dX87jZT0sWPJKyhHLCxZZc6gJA3-HkSkHzOOe0Vmeo8kSe4vri
    LevWDM4nq7JWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvledgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:DyhPYPIxulMvvDWBqj2ghmq1T9mfHrlUAI_D8Q3od_3SAwXi77kAcQ>
    <xmx:DyhPYDEcIhszRTCo9wO9llEnm1lAoc8WdYSgw3iIbHCqDMDRYgoFlQ>
    <xmx:DyhPYDXLSepIKBLao8NMh7_2FRJaCnRjTxD_JYmyygnc8akQ-uvRZg>
    <xmx:EChPYOQeXchmwp-Eo0_Spk8l9g3DBWm6HDK4sDawMDqyEKdJzIL_0A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 983431080064;
        Mon, 15 Mar 2021 05:25:35 -0400 (EDT)
Date:   Mon, 15 Mar 2021 10:25:33 +0100
From:   Greg KH <greg@kroah.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org, Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH stable v4.4] media: hdpvr: Fix an error handling path in
 hdpvr_probe()
Message-ID: <YE8oDRvktU6GOLD6@kroah.com>
References: <20210315083943.11685-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315083943.11685-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 09:39:43AM +0100, Krzysztof Kozlowski wrote:
> From: Arvind Yadav <arvind.yadav.cs@gmail.com>
> 
> commit c0f71bbb810237a38734607ca4599632f7f5d47f upstream.
> 
> Here, hdpvr_register_videodev() is responsible for setup and
> register a video device. Also defining and initializing a worker.
> hdpvr_register_videodev() is calling by hdpvr_probe at last.
> So no need to flush any work here.
> Unregister v4l2, free buffers and memory. If hdpvr_probe() will fail.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Tested-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> [krzk: backport to v4.4, still using single thread workqueue which
>        is drained/destroyed now in proper step so it cannot be NULL]
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> ---
> 
> Backport needed for v4.4. v4.9 has it already.

Now queued up, thanks.

greg k-h
