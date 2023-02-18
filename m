Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3A469B966
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 11:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjBRK3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 05:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBRK3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 05:29:31 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12491ADFA;
        Sat, 18 Feb 2023 02:29:30 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9955F5C00DE;
        Sat, 18 Feb 2023 05:29:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 18 Feb 2023 05:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1676716167; x=1676802567; bh=z7pNc7FSy/
        sM7V64UiBjw0RNRZzP3TFT4yJbRpLVQck=; b=ao4LI3p2TocAOyfJ+ZzxJbHYkM
        ldqO3P9ax0qEUturXm+56E5YhpddYVN0EP6amx0ZbTJeRJsg2DK+EE7YY1hpXxyf
        4UQdB+RPW8+Xpw8KJuQbqWKm2NAHJtmLarm4V0sZVXtZudY7omz+tjumusV8bC3C
        Qfu6aEo8Q/Tzl2b8QjsfljkrpiIXn3oYSh2E5D6Kk8qxBmajSWu+g//ZWgdnPi9K
        o82uarqfFFnJvQiaBFnBpNI1BWw6tzM5B5Df1BMperySMK49F0cfs44ab3tg80VO
        AprBWCo88VC4IfU8ltGAoWenc8pM1rIiplMFP3xO9a66Xt+81FADCHK7UWuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676716167; x=1676802567; bh=z7pNc7FSy/sM7V64UiBjw0RNRZzP
        3TFT4yJbRpLVQck=; b=cXuL0PJ5MID+F9HeeTemXNzUdzOIEIfJbB7hCGAOH0XP
        tKiqpHlU+3lpb7ZvzhS/9CVlNEKsAk0w1WmwbBm5h1sdSLUd8USBaw1BimnJ+2Ip
        hjqndKWPlRUr3DypLt6zgRlXSrvQYaUWuDqZ5NkgXMowTC1rO+Q/dRCifpGgGOQH
        UI0Q6MnIelED/7hj06uVk5bYN0rmKl51sZYFEx4PRwsiGkkKrFpWlavvfAx7yQGz
        lde27GUVXdPlEJYgqVEvVvq6VWWDzgcTaIWhHJ9iHXIE/waCelwzcX0wHcEb+PC5
        e6ansvlaPgly7VfIhogOjsEl8v21GWezlLnsR0Opmw==
X-ME-Sender: <xms:h6jwY2LR2APb2A-9U6wmfw5-16s1TQI80iXFjFiDTY-P4GzhQ_hKUA>
    <xme:h6jwY-JOvbmDRPtOyWCCeRZ7hCW-uHUIr_N-nQUR_Xae9zLosSjWIdYSywcEj6n0W
    ZO3LFzK9uoqNg>
X-ME-Received: <xmr:h6jwY2v6Mdb1j5kKMeKqGE5vqTQIPlT5O-jYmHmTX8dSF3-mN5QToJIu-IAWk3TgkhOaVmL4dklmOP50Pr57CxXfdCDKs8Lnhzci-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudejuddgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeegheeuhefgtdeluddtleekfeegjeetgeeikeehfeduie
    ffvddufeefleevtddtvdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:h6jwY7YtywMIk9wIII4a3QS8l499Dwrwfj0WUOk9AsC7pCSGG7aOHA>
    <xmx:h6jwY9a-n1yxCweiBxs8tasIwThIU9_rvoqT31u0iUmqfR0xuYQNUg>
    <xmx:h6jwY3Ahp_eyBxmw0cKjMkU5RklBvyozwpG1Jk90eOSu5F6-JLFK5A>
    <xmx:h6jwYxRobf6pQx3gx4e7KouGuwRfT7EOmh04-QvgI0LhdB77IrhL5g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Feb 2023 05:29:26 -0500 (EST)
Date:   Sat, 18 Feb 2023 11:29:24 +0100
From:   Greg KH <greg@kroah.com>
To:     Andrew Paniakin <apanyaki@amazon.com>
Cc:     stable@vger.kernel.org, luizcap@amazon.com, keescook@chromium.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [5.15] Please apply 'selftest/lkdtm: Skip stack-entropy test if
 lkdtm is not available'
Message-ID: <Y/CohO02rXPY4hzD@kroah.com>
References: <20230217221705.2525177-1-apanyaki@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217221705.2525177-1-apanyaki@amazon.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 17, 2023 at 02:17:05PM -0800, Andrew Paniakin wrote:
> commit 90091c367e74d5b58d9ebe979cc363f7468f58d3 upstream.
> 
> This patch fixes the stack-entropy.sh test to exit gracefully when the LKDTM is
> not available. Test will hang otherwise as reported in [1].
> 
> Applicability of this fix to other LTS kernels:
> - 4.14: No lkdtm selftest
> - 4.19: No lkdtm selftest
> - 5.4:  No lkdtm selftests
> - 5.10: Inital selftest version introduced in 46d1a0f03d661 ("selftests/lkdtm:
>   Add tests for LKDTM targets") is a single script which has the LKDTM
>   availability check
> - 6.1: Fix applied
> 
> This patch applies cleanly to stable-5.15 tree. Updated test was executed in
> Qemu VM with different kernels:
> - CONFIG_LKDTM not enabled. Test finished with status SKIP.
> - CONFIG_LKDTM enabled. Test failed (but not hanged) with error 'Stack entropy
>   is low'.
> - CONFIG_LKDTM enabled and randomize_kstack_offset=on boot argument provided.
>   Test succeed.
> 
> [1] https://lore.kernel.org/lkml/2836f48a-d4e2-7f00-f06c-9f556fbd6332@linuxfoundation.org

Now queued up, thanks.

greg k-h
