Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB09750E98A
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 21:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242465AbiDYTgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 15:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244965AbiDYTgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 15:36:17 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F56111151;
        Mon, 25 Apr 2022 12:33:12 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: shreeya)
        with ESMTPSA id 7FB321F4340D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1650915191;
        bh=tNszbkE7kCyH/UzDhy10Hc7U2osXd60mq5AVxQTCcYo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jFkBSoIfsu392YSYoIv4r/UD7/JWpjsxZrYYol3TMGULTsvBlYm3C6FveCI3VBr8s
         sC9hOUdqFHFgnxb2CtpVWgBrVtYoGBxe3hkpLI6zVKNDhCX7q2pl0VDutAlpXGjfqU
         lXEbjxdU5X3CgCXMin9nNtx4MH8mlkjkAv7bmInKjtDIiRaIbb6s/UVJDkP74SUvV1
         JkogL9OncVWrqODQzb64u8ONT6vRKxVBskDu4ETnB2EWFJpI6NmSAMm+3aJOpHrJTo
         tG21BB1OJ7teFmxC0yDdJ98z+xvcHwQti2ekYxBr16eDX40km3AUXpTgdgmcM8RZ+d
         JKkIonJDKOgZw==
Message-ID: <d414eda8-3745-515a-8c4e-cda9b74f752c@collabora.com>
Date:   Tue, 26 Apr 2022 01:03:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Resend: Regression in 5467801f1fcbd
Content-Language: en-US
To:     Daniel Harding <dharding@living180.net>
Cc:     linux-gpio@vger.kernel.org, stable@vger.kernel.org,
        andy.shevchenko@gmail.com,
        Mario Limonciello <mario.limonciello@amd.com>,
        Collabora Kernel ML <kernel@collabora.com>, brgl@bgdev.pl,
        linus.walleij@linaro.org
References: <34212129-bb2e-46d4-4536-28f11b1c61ca@living180.net>
 <e8ea254c-08db-06df-1101-4af1777d174b@living180.net>
From:   Shreeya Patel <shreeya.patel@collabora.com>
In-Reply-To: <e8ea254c-08db-06df-1101-4af1777d174b@living180.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 26/04/22 00:48, Daniel Harding wrote:
> [Apologies for the original HTML email]
>
> The commit "Restrict usage of GPIO chip irq members before 
> initialization" breaks suspend on a Dell Inspiron 5515 laptop in a 
> very severe way.  Suspending with this commit present causes the 
> machine to lock up hard.  The only way to recover is to disconnect 
> mains power, open up the case, disconnect the battery, and hold down 
> the power button.  Bisecting pointed to 
> 2c1fa3614795e2b24da1ba95de0b27b8f6ea4537 in 5.16.20.  Testing with the 
> source commit, 5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320 confirmed that 
> it was the one that introduced the problem. Unfortunately, this commit 
> was backported to multiple stable kernels:  5.17.3, 5.16.20, 5.15.34, 
> and 5.10.111.
>
> I have not yet done any debugging to determine exactly why this commit 
> causing things to break, but am happy to try out any fixes over the 
> next couple of days until I put my laptop back together properly.
>
Hi Daniel,

FYI, The fix for the bug has already been sent by Mario and it has been 
picked up by Linus.
https://lore.kernel.org/lkml/20220422131452.20757-2-mario.limonciello@amd.com/


Thanks,
Shreeya Patel

> Regards,
>
> Daniel Harding
