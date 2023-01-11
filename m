Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F4F6655D4
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 09:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjAKISd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 03:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjAKIS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 03:18:27 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0467A5F88;
        Wed, 11 Jan 2023 00:18:25 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 43945320095D;
        Wed, 11 Jan 2023 03:18:22 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 11 Jan 2023 03:18:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1673425101; x=
        1673511501; bh=XKgo32eBKf4n2shX8Ii4Fh607OuEYZIvIY/YMhXRHz8=; b=N
        slmSf3kKzUZFP1UhEgwnXiC6vEs3eYtYwzSKP9urcK4b6KggCO6UfN8n7hRj2ih+
        FseJAx9REurJgEfRKViFWCjRAJzsgv+nvSxO6YkfQz4sHyYypEDK/kXV1hem1R/t
        Sx9lg4+AS1E4VL+Wclgoaddq7khMdj5eRwdZXCR1RyY3Pa52rsEpqBGbmVHrx6wF
        1NijJKKJfoMfq4bvwu27avyB82QVxKZk28dRAvb0GxBU/wKoR5K6IVCnsQU4LRoq
        2j1uSap8nxv+rYRij+1lQkQ+KjmNQ2tbQPIn1JeuTzgodJ3jSyBDN50kaGw71QOv
        +ZGxnN1ooj1Flx6WUugng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1673425101; x=
        1673511501; bh=XKgo32eBKf4n2shX8Ii4Fh607OuEYZIvIY/YMhXRHz8=; b=f
        tBTA1DDhlvJNVZytWHJ2b33+IOQ4XZDAkNNhMh0+sYrDX2zpJC+wavVS2HCBkeQZ
        pODo3/zQTLkYXXcSYP9MR0AvLEI5lxgkID2SDNudRZLptbuuGMXnglsPEhfk+R57
        pZ58awFzBjwbB4u4I/8rdkfLacLpSqmxW0Ij6ikj9wH+LgrnAicJL6iDloOggnGy
        Ow4mPnID7MoJROqRJnwm4tkq12jrNjL69EsUrji611AIha7cL4UiQ3rDZf/IvTmZ
        KQ2dQzgqU8RGF5t45MGBAFYHgA+fewzexueJQSrW3rK8V2I+LjdjhI6GgShQd/jd
        GcZF/BLm86mrGYa1/QqGQ==
X-ME-Sender: <xms:zXC-Yw_EAtnt6guQ1VpVp5H8Edan5yFOhQlGYJr5WHtxZrJz5EKtgg>
    <xme:zXC-Y4sQHeqVVzQZkas8sj8cAHXMw96JEnEOpiybUncl5GYJLBeBmg7rJvr0_7q9U
    xftuA5crYA7dl3QsrI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleefgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeektdegueffheefgeetvdeuhedvledttefgudefteejheeugefhtdduvdff
    jeekffenucffohhmrghinhepthhugihsuhhithgvrdgtohhmnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:zXC-Y2BFwYyHDWGNaQjM4jBISEhc0E_d8VN2oQ9a2kqkcWz3klu54Q>
    <xmx:zXC-Ywc2AgzQw6QlIiIzAtGLznxyzyw3MI4hQMD0vHC_LTTwDa_DsQ>
    <xmx:zXC-Y1MPMzaKuSIk6Tlolv-vuF_BxcNM9IjIyabpqzKp065hxhNgaQ>
    <xmx:zXC-Y2sppElqP-0va7-emHGCkmmvfqTPZAWr8XcfmNUsWjsZYz5RLg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 6E2EDB60086; Wed, 11 Jan 2023 03:18:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <bd62bccb-6970-4cdb-ae23-792b5867705d@app.fastmail.com>
In-Reply-To: <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
References: <20230110180017.145591678@linuxfoundation.org>
 <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
Date:   Wed, 11 Jan 2023 09:18:01 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Guenter Roeck" <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        "Pavel Machek" <pavel@denx.de>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        "Mark Brown" <broonie@kernel.org>
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023, at 07:16, Naresh Kamboju wrote:
> On Tue, 10 Jan 2023 at 23:36, Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org> wrote:
>>
>
> Results from Linaro=E2=80=99s test farm.
> Regressions on arm64 Raspberry Pi 4 Model B.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> While running LTP controllers cgroup_fj_stress_blkio test cases
> the Insufficient stack space to handle exception! occurred and
> followed by kernel panic on arm64 Raspberry Pi 4 Model B with
> clang-15 built kernel Image.
>
> The full boot and test log attached to this email and build and
> Kconfig links provided in the bottom of this email.
>
> I will try to reproduce this reported issue and get back to you.

I looked at the log between 6.0.18 and 6.0.19-rc1, but don't see
any arm64 or memory management patches that could result in this.
Do you know if 6.0.18 ran successfull
> [ 2893.044339] Insufficient stack space to handle exception!
> [ 2893.044351] ESR: 0x0000000096000047 -- DABT (current EL)
> [ 2893.044360] FAR: 0xffff8000128180d0
> [ 2893.044364] Task stack:     [0xffff800012a18000..0xffff800012a1c000]
> [ 2893.044370] IRQ stack:      [0xffff80000a798000..0xffff80000a79c000]
> [ 2893.044375] Overflow stack: [0xffff0000f77c4310..0xffff0000f77c5310]
...
> [ 2893.044413] pc : el1h_64_sync+0x0/0x68
> [ 2893.044430] lr : wp_page_copy+0xf8/0x90c
> [ 2893.044445] sp : ffff8000128180d0
...
> [ 2893.044692]  el1h_64_sync+0x0/0x68
> [ 2893.044700]  do_wp_page+0x4a0/0x5c8
> [ 2893.044708]  handle_mm_fault+0x7fc/0x14dc
> [ 2893.044718]  do_page_fault+0x29c/0x450
> [ 2893.044727]  do_mem_abort+0x4c/0xf8
> [ 2893.044741]  el0_da+0x48/0xa8
> [ 2893.044750]  el0t_64_sync_handler+0xcc/0xf0
> [ 2893.044759]  el0t_64_sync+0x18c/0x190

It claims that the stack overflow happened in do_wp_page(),
but that has a really short call chain. It would be good
to have the source line for do_wp_page+0x4a0/0x5c8 and
wp_page_copy+0xf8/0x90c to see where exactly it was.


> [ 2893.285975] WARNING: CPU: 2 PID: 315758 at kernel/sched/core.c:3119
> set_task_cpu+0x14c/0x208
....
> [ 2893.286117] CPU: 2 PID: 315758 Comm: cgroup_fj_stres Not tainted
> [ 2893.286416]  arch_timer_handler_phys+0x44/0x54
> [ 2893.286427]  handle_percpu_devid_irq+0x90/0x220
> [ 2893.286439]  generic_handle_domain_irq+0x38/0x50
> [ 2893.286447]  gic_handle_irq+0x68/0xe8
> [ 2893.286455]  el1_interrupt+0x88/0xc8
> [ 2893.286464]  el1h_64_irq_handler+0x18/0x24
> [ 2893.286474]  el1h_64_irq+0x64/0x68
> [ 2893.286482]  panic+0x2d8/0x374

This is apparently a second unrelated bug -- it still processes timer
interrupts after calling panic() and this apparently fails because
the system is already unusable.

>   artifact-location:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2K9JDtix2mHMoYR=
jNkBef3oR5JT

file not found. I tried to get the vmlinux file to look at the disassemb=
ly
but the artifacts appear to be gone already.

     Arnd
