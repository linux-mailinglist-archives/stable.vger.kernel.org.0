Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215976509F3
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 11:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbiLSKSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 05:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiLSKRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 05:17:52 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C76DFF1;
        Mon, 19 Dec 2022 02:17:45 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id D253A580108;
        Mon, 19 Dec 2022 05:17:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 19 Dec 2022 05:17:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1671445062; x=1671452262; bh=fgJpD5UpCl
        Ln/YQQSaCgxLEoTAIdNYkTyp1io2SyGro=; b=va+/8G9ABffa8iE8Ef/xT4D79l
        xcUirBK5yU76M+dai+1doV7MVnGsYvy3Wq2ovw9OpHGQIdGp4gNZ6JqIP72MCKmQ
        b9alGGd49E73osu8mV1ltBigx9WwvbIK7Yy4F81fAB9lrROaqDjRPKNCRKprKo42
        viXDuEppo/06gzG8R0aPnlZvq6O0n3dKtvgxvvWiFwmzRCpJfF9rth0kwViCGy+q
        P1PsTjDhd0PxyQ1g4BnjD63WsNVHFQlBK25j7Lbw7qLlDDXsvb14G+MK8nkDeZCH
        D+H0SFojd8c8PQroSALVk5lkb4eyhMnPAGE3I2pn8DcCqnta+UGjnRiv1Kcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671445062; x=1671452262; bh=fgJpD5UpClLn/YQQSaCgxLEoTAId
        NYkTyp1io2SyGro=; b=C/e+3ah36yKkFpO3JF7+nfBc5JgWZCTNbKxVOtEiQcQY
        AdKn2ioP/7d/1IlsDd8LLDeFlvRJvkMejA8D/d3jsb5bfPodD2HtRRiUONS01ppe
        AwZoZGsVGNbrZa26ifiEHQGNkuwTUgPj68zU0ZhJQTCM7b74fOiF/catd/L6Hj7O
        E8i9tykNM+HkvdYQR8IXaH3c55zRT+VLEX5YKaVaXxeLQuTBpppXv7er6PvUYYSU
        mB9UT2aJnzanL6rnou8rC8xRUKyROG3sfYvCyj6XJ6kCl4GnMAtlzRswgy6UV7AX
        +8hmWZFu6c1QlCG11coZv3Jv12QEI+3bOUsdt5LnWw==
X-ME-Sender: <xms:RjqgY13qxT9bvsBlPdQ-jVvSUbhzUcZTbI-x-TiWwpWHtvKt3wvF1A>
    <xme:RjqgY8FzhvPEMdqudqPd6sejDygAvbnO7qcCKjtyo6yJK718mU4P9zz8F4QqQMLxM
    hdMw5y4ai-T6A>
X-ME-Received: <xmr:RjqgY14Hi4fa97pkJcd8B7KvSWHcQvfloUCFTQEJdNNaZqonoAbK07-_WQ6178SYnRk7GHbMD5g_8JvhJ4-U966CTqOLZTCX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeduieefve
    ehhfdvtdeihfdvvefhleelfeeifeefkeeigefgtefhvdduteefteffkeenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:RjqgYy0DXDJrkJk5v4FwpROKwgry4zWkxLlFD02nMfeY0PGhduOwVQ>
    <xmx:RjqgY4GMx0uoKH96qVed6v9NR9cVofU1xA_fok_yPm9EKdRYlpLSzw>
    <xmx:RjqgYz9VBXJJxJD85B7ajprr_zI3g7xym63KcT7NA7sE_KvvIPae5A>
    <xmx:RjqgY6lYEg8q2uqycRF3wSmlCYKWpGjSdMS8_rzV3UyF3Abgui_r7Q>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Dec 2022 05:17:41 -0500 (EST)
Date:   Mon, 19 Dec 2022 11:17:39 +0100
From:   Greg KH <greg@kroah.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net,
        kernel-dev@igalia.com, kernel@gpiccoli.net, fenghua.yu@intel.com,
        joshua@froggi.es, pgofman@codeweavers.com, pavel@denx.de,
        pgriffais@valvesoftware.com, zfigura@codeweavers.com,
        cristian.ciocaltea@collabora.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andre Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH 6.0.y / 6.1.y] x86/split_lock: Add sysctl to control the
 misery mode
Message-ID: <Y6A6Q57/qz7w7cxM@kroah.com>
References: <20221218234400.795055-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221218234400.795055-1-gpiccoli@igalia.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 18, 2022 at 08:44:00PM -0300, Guilherme G. Piccoli wrote:
> commit 727209376f4998bc84db1d5d8af15afea846a92b upstream.
> 
> Commit b041b525dab9 ("x86/split_lock: Make life miserable for split lockers")
> changed the way the split lock detector works when in "warn" mode;
> basically, it not only shows the warn message, but also intentionally
> introduces a slowdown through sleeping plus serialization mechanism
> on such task. Based on discussions in [0], seems the warning alone
> wasn't enough motivation for userspace developers to fix their
> applications.
> 
> This slowdown is enough to totally break some proprietary (aka.
> unfixable) userspace[1].
> 
> Happens that originally the proposal in [0] was to add a new mode
> which would warns + slowdown the "split locking" task, keeping the
> old warn mode untouched. In the end, that idea was discarded and
> the regular/default "warn" mode now slows down the applications. This
> is quite aggressive with regards proprietary/legacy programs that
> basically are unable to properly run in kernel with this change.
> While it is understandable that a malicious application could DoS
> by split locking, it seems unacceptable to regress old/proprietary
> userspace programs through a default configuration that previously
> worked. An example of such breakage was reported in [1].
> 
> Add a sysctl to allow controlling the "misery mode" behavior, as per
> Thomas suggestion on [2]. This way, users running legacy and/or
> proprietary software are allowed to still execute them with a decent
> performance while still observing the warning messages on kernel log.
> 
> [0] https://lore.kernel.org/lkml/20220217012721.9694-1-tony.luck@intel.com/
> [1] https://github.com/doitsujin/dxvk/issues/2938
> [2] https://lore.kernel.org/lkml/87pmf4bter.ffs@tglx/
> 
> [ dhansen: minor changelog tweaks, including clarifying the actual
>   	   problem ]
> 
> Fixes: b041b525dab9 ("x86/split_lock: Make life miserable for split lockers")
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Andre Almeida <andrealmeid@igalia.com>
> Link: https://lore.kernel.org/all/20221024200254.635256-1-gpiccoli%40igalia.com
> ---
> 
> 
> Hi folks, I've build tested this on both 6.0.13 and 6.1, worked fine. The
> split lock detector code changed almost nothing since 6.0, so that makes
> sense...
> 
> I think this is important to have in stable, some gaming community members
> seems excited with that, it'll help with general proprietary software
> (that is basically unfixable), making them run smoothly on 6.0.y and 6.1.y.

What specific programs have this problem and what are the exact results
of it?

Also, this is really a new feature and not really a "fix", but one could
argue a lot that this is a "resolve a performance problem" if you want
to and have the numbers to back it up  {hint}

thanks,

greg k-h
