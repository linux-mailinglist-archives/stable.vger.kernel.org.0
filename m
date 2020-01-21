Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9B81437EB
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 08:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgAUH4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 02:56:01 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:60067 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbgAUH4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 02:56:01 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 98F2E4F2;
        Tue, 21 Jan 2020 02:55:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 21 Jan 2020 02:56:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=pjxZsKCHbYV+yWcufdKiS+2H1Vi
        vNWsEeVgpRIYcua0=; b=cePp5eFUsZbD1x7hkhLArAVzW3z1ljH2udoAgAab3Rv
        LbzYwgzpRAAWsBnM4QOLAUXA1c+AOsrzNd3RX1v8cMK+XNodY0WpaPtRrzUJzHVL
        UsOUgyGoxp05O5dVFhJcIOe6MjLKHFnR2pll3AHlAdkw/kGWjhHNSmYIc6k6USLR
        pur+ND7wvXzN4DgegWj5aCw7C2pIH3lM1r4OKnoUDs6B0GLDz1HDIjTkh69Tniau
        Mu3KSLA9uarJumjptVjf0VGJXnwQTMKGYRQP+dSU0yAJyUUjrgeT+H188OffAT7y
        XlaDs6uXukcQPRxOdVG62IY8vkvT9AbcTh2LruTK0WA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pjxZsK
        CHbYV+yWcufdKiS+2H1VivNWsEeVgpRIYcua0=; b=kcLnRYPNByO9PYuwfDQJGO
        5RaYtZShyy3HybsdC+3khcqn4EdABmii0lVXaNsZcrTG/PNgsIW/KJjJORUvm57O
        s5bRL7FxBK0M3e6cLTEjQGsZ2fPB7XgtnW7/E01hOtwiGrdUnlW65Ah7rQocv0eC
        Fjpb0qjPuNH7TbDs+TWVslB4VlrsCBMsQ7EpQI+s4tar8pLAzNSw6EczwC7ipeti
        zFWlE70kb7xCWPYlUhiqyhgahhXqTu8AetI7QqI01jYsSwApWpcsPSWwPerHt5eh
        S3WJwvM2r50QpBzAGXXPXFfkML4OK2hL4cOMkCLlQ3rxEcCS/X8hedgWr75WdC1w
        ==
X-ME-Sender: <xms:jq4mXqNSKjlAzGUkjADRd7aLQQ-E3BLiB8aeZeeegTaBwnh7a0Q7NA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudejgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucffohhmrg
    hinhepvddutddrhhhofienucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnh
    grrhgriigvlhdruggv
X-ME-Proxy: <xmx:jq4mXhb8Si7d-PNXy98TxEBf-7yp2nNC1T3mi9Yn0jT8T3GW3YMj4w>
    <xmx:jq4mXhuJnnBSMq31fC_Yew5OCWk_OsLTE9Yd6dko8QGkkM81zWfS2Q>
    <xmx:jq4mXrNxCJiQZTmqD-fmDxRF8iXJR7wVlpM51P2-2UMDjxOZQK050A>
    <xmx:j64mXrPxZzMGak80u5S2dNbRkRXw1SCHEnNecmq5KYIO4bHbU21NZA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id C311C328005E;
        Tue, 21 Jan 2020 02:55:58 -0500 (EST)
Date:   Mon, 20 Jan 2020 23:55:58 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH 11/12] perf c2c: Fix return type for histogram sorting
 comparision functions
Message-ID: <20200121075558.qltcuwr464tzvfrw@alap3.anarazel.de>
References: <20200116134814.8811-12-acme@kernel.org>
 <20200119152655.A692A20679@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119152655.A692A20679@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2020-01-19 15:26:54 +0000, Sasha Levin wrote:
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 722ddfde366f ("perf tools: Fix time sorting").

> The bot has tested the following trees: v5.4.13, v4.19.97, v4.14.166, v4.9.210, v4.4.210.
> 
> How should we proceed with this patch?
> 
> v5.4.13: Build OK!
> v4.19.97: Build OK!
> v4.14.166: Build OK!
> v4.9.210: Failed to apply! Possible dependencies:
>     7aef3bf3daa1 ("perf c2c: Add c2c command")

> v4.4.210: Failed to apply! Possible dependencies:
>     7aef3bf3daa1 ("perf c2c: Add c2c command")

Looks like it doesn't need to be backpatched to the failing
branches. "Fixes" was approximate here anyway, since that commit just
exposed a pre-existing coding bug, that was masked by the fix in
722ddfde366f. And since 4.9/4.4 don't have c2c at all, there's nothing
to fix.

Greetings,

Andres Freund
