Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35B82E974A
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbhADO3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:29:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbhADO3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 09:29:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE4D21D93;
        Mon,  4 Jan 2021 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609770544;
        bh=UnN6xmAfP5UnHkpYHMpUU7bWMo1VDBoysDL7NDElD5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LvB3E/G+/vY0B/ZchZ3gSDMFER1Jen3/L5cjmb4b7dImV8pSsq0nJyg84fyzRhX24
         mQ1NCpVD1pVAfI2S+stGM9nf0S7Mar7ZZBzI7iJmKE2jE1LBxAE6hRLF8Njp2LoyFC
         SjOBo2idHwzfajpvYoRbrxx19g//dsM8eGb4ypihytml5ehcJiYIDCdtTITj6jA6Zf
         p59ksMHmgzGU27lNO/RrNg2pMVZOkuzug1wphz3tgaD6yU1mxF8TUuN0L59riA85c7
         b6ySrex6cgtaZuVslwEBzB6jeVYpXUFRai0djh+Il817o2lVzUn/4ZegZw2e9ZpoW9
         Vl1PXMa4qyy2w==
Date:   Mon, 4 Jan 2021 09:29:01 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <rmk+kernel@armlinux.org.uk>,
        Abbott Liu <liuwenliang@huawei.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 01/31] ARM: 9014/2: Replace string mem*
 functions for KASan
Message-ID: <20210104142901.GC3665355@sasha-vm>
References: <20201230130314.3636961-1-sashal@kernel.org>
 <25b25571-41d6-9482-4c65-09fe88b200d5@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <25b25571-41d6-9482-4c65-09fe88b200d5@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 03:18:13PM +0100, Ahmad Fatoum wrote:
>Hello Sasha,
>
>On 30.12.20 14:02, Sasha Levin wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> [ Upstream commit d6d51a96c7d63b7450860a3037f2d62388286a52 ]
>>
>> Functions like memset()/memmove()/memcpy() do a lot of memory
>> accesses.
>>
>> If a bad pointer is passed to one of these functions it is important
>> to catch this. Compiler instrumentation cannot do this since these
>> functions are written in assembly.
>>
>> KASan replaces these memory functions with instrumented variants.
>
>Unless someone actually wants this, I suggest dropping it.
>
>It's a prerequisite patch for KASan support on ARM32, which is new in
>v5.11-rc1. Backporting it on its own doesn't add any value IMO.

I'll drop it, thanks.

-- 
Thanks,
Sasha
