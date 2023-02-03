Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E31D689164
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 08:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjBCH7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 02:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbjBCH6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 02:58:36 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0029F32528;
        Thu,  2 Feb 2023 23:58:34 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 5E0D03200917;
        Fri,  3 Feb 2023 02:58:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 03 Feb 2023 02:58:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1675411110; x=1675497510; bh=LhbWN0bu2m
        cFcY1A7Fmu3Enc1lagz2yeOOXyJiDDA6c=; b=l5pRfZunRw+kh9WhZZ35TBmgnJ
        N9yrZdvHgmVKeGrjCKCcP6UDZUP6aZ6Y0X+l+Ji44t0pUUVo4NWj6AcCUkfQmIx+
        eG+VrGzhGQnsrOWt0KVRw2/jhQ06FwBsxE7U+inFpL8FgTdbE4ZL8Tt12+cgOfhY
        LH47Cm2+xq8j8WaXMXNa1020WrdIQkQEFETex+ZDQrUgBzSJLMBzNc42naQdLrW0
        ryAprn8QQCaA41k5vknyMUArQX5ZayCCVwi/Mkx188oYpQ+U+xAByzzspHxOtgOM
        rJTbWuhBqXH8RNBZDzTD6PuCnriyg584KXxPPEGgXe2sZebQw8f3tNfzAqHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675411110; x=1675497510; bh=LhbWN0bu2mcFcY1A7Fmu3Enc1lag
        z2yeOOXyJiDDA6c=; b=NuknU8S4AZlE4O/FBMmo3oJtGTIe6aT5dDOzVIkU+6kt
        46NQ3svLkaX2tcx75RhLWudNiXjWIbSSUVUKSMQwEu2OU7dpcu8DDFJqjzOJnlW6
        eHkKCf0ArHK+Y1jEJL+LmYEDcMAzcYUMz1M2jOY2dPIaQ6sCLLSPF+HpUw8rEhGd
        Bd6kq+g8X9tMPF4g9aI9Uy47MQXRpslkV4tmUTsroD4pHjjvFrV/0mV5xNJn/bRC
        +TOu35ry3JdWEV0g45L8FRLvta8mb/pOTMMkWIyK32F4P1nSiXGLYugkkShE7Nor
        iFRP4nYTI87TiqVoua2W443+C/+Qxh0ymbHAyiU0iA==
X-ME-Sender: <xms:pr7cYxgiuGY_Exn4kAp8IvI7yjXGJ15O0wAdToixcGkQfgW-eypEhA>
    <xme:pr7cY2AwHrGJH-LHBzL4kiQilBoeXZEdA90zLDz6U6Ht8EPlIvKILLg99Hv97PAAy
    EI1bTkXLamSLw>
X-ME-Received: <xmr:pr7cYxExMVnxxf11B97JzF_BdVzOhVrCrYkwwqyUAl88OHu9090RvxHsXczrOZO7bX77floiBFegs2Bqs1DmWN43rlUN-0PhdoM16g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefledgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpeffhffvvefukfhfgggt
    uggjsehttdertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorg
    hhrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevkefghedvveegffefgfefffekvdff
    geeihefghfejhfdutdfhhfejleejieenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpd
    gslhhoghhsphhothdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pr7cY2SWlmpYkmUq_zfUkjxLxDUh8QscxK3lOClVkiJPkz7-DXl_RA>
    <xmx:pr7cY-ykr0WtWDUKah0MlChQ157MMxx57xk4hYrXPZh2XUqieu73kQ>
    <xmx:pr7cY87ca6zPvjoKCxFXBi9oJWXXRp5fVAW_v3OGSOBPba5ixyLt1w>
    <xmx:pr7cY_qIoxnaUiPd25ZiITXIVycAoGZD3ILXMxAwnm3ZarLPgY6okQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Feb 2023 02:58:29 -0500 (EST)
Date:   Fri, 3 Feb 2023 08:57:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 v2 00/15] Backport oops_limit to 4.14
Message-ID: <Y9y+g66x++h4kEXy@kroah.com>
References: <20230203003354.85691-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203003354.85691-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 02, 2023 at 04:33:39PM -0800, Eric Biggers wrote:
> This series backports the patchset
> "exit: Put an upper limit on how often we can oops"
> (https://lore.kernel.org/linux-mm/20221117233838.give.484-kees@kernel.org/T/#u)
> to 4.14, as recommended at
> https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html
> 
> Changed in v2:
>    - Fixed a build error in mm/kasan/report.c by dropping the patch "mm:
>      kasan: do not panic if both panic_on_warn and kasan_multishot set".

Both v2 series now queued up, let's see if they build...

thanks,

greg k-h
