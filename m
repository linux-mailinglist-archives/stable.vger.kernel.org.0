Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDE6540292
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiFGPfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 11:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236329AbiFGPfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 11:35:38 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA2BF68AB
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 08:35:37 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n185so9531787wmn.4
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 08:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=UzAFOh0dSi5b7YcRWFXZow4QCyM7X3zyC4kDiKLs6oA=;
        b=T5kR40O4jIf93Fzt2vVjHZsWJdRsDbXUsWf+mvn1wIXbxiVgaP5IefQAlFt7hUxPLw
         rUHJnaENpHIaQQ5LD5GYbGFLr/ivNwinMXUz3J/LMQc0uSeEv5klV5kQgxojKKCrqT6K
         z8O5hGcPPFVeRibn0sn6StjcyJugXjVuKtNDos/NoE4mFB64LDwtgd4zef/99rLnWwm4
         vQIC98SKhKJePLMpRBVse3kuDKRKqQvLkTE3ABXMs6kjiVEwmUQzkVohuwLxerT1z9sa
         0mFV7MhEypGwD8gH/3TNX6QqtchzS5h+UoteVBwLpPaJlUYlXl00HMEKhepD5Y/Nbv7U
         0HvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UzAFOh0dSi5b7YcRWFXZow4QCyM7X3zyC4kDiKLs6oA=;
        b=c9WqgBIuJP31FPHepfefbJmcCW/hThn8iNBI9S8RXuD3LY1KxNgH5Xx4/62v1YgQHk
         fHnYGLUwxccyCNn4C/vl1DJ+wAb9G+lgvaFAs5b8QYaxCsFeGUKZ69NpjzALKpd5x8V+
         h1wEw+0sO1KRm3hrinpFoKi6iONaiAvi26oKK0ykMZgs/3Dx1lVUPcfQ5k4tMctuZ9Kr
         ben6BjOLlrlUEclVfrFvdAlEKb9MTldi2G9p0ZVCnGVvg4YPAzC9yToSt3srOOxmOZj9
         NzQbv3kIkEjcMUgr1moXIdscbnfKULUZQhI+GN4t8sMYftjefzM+K6BbyJo5DfFnOxF8
         nOFQ==
X-Gm-Message-State: AOAM5300StfZvUiSGvlHY5PlwJH+Mufl93lRInm3EzUIHOVoitcild82
        4U2TPbbfUqfRyQ8w8dQpvEoz4w==
X-Google-Smtp-Source: ABdhPJy6bavYQeyfic2q5zoBbUISR1gSP0m3TPaWhyrDKXYy9SywIwfxjCPR6erasubUzeaAz8h6gQ==
X-Received: by 2002:a05:600c:2054:b0:39c:3f73:3552 with SMTP id p20-20020a05600c205400b0039c3f733552mr23997611wmg.15.1654616135853;
        Tue, 07 Jun 2022 08:35:35 -0700 (PDT)
Received: from [192.168.187.211] ([86.12.200.143])
        by smtp.gmail.com with ESMTPSA id s13-20020a5d6a8d000000b0020c5253d8f7sm18217141wru.67.2022.06.07.08.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 08:35:35 -0700 (PDT)
Message-ID: <25c1a57e-af67-ebc8-ab13-6532bf6e6e75@raspberrypi.com>
Date:   Tue, 7 Jun 2022 16:35:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9o6R2RRdwzB9f+464xH+Aw-9wx2dm=ZsQYFbTk_-66yJw@mail.gmail.com>
 <8c3fe744-0181-043a-3af9-dd00165a6356@raspberrypi.com>
 <Yp9rc1G6xfTSSUjF@zx2c4.com>
From:   Phil Elwell <phil@raspberrypi.com>
In-Reply-To: <Yp9rc1G6xfTSSUjF@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jason,

On 07/06/2022 16:14, Jason A. Donenfeld wrote:
> Hey again,
> 
> On Tue, Jun 07, 2022 at 10:15:27AM +0100, Phil Elwell wrote:
>> On 07/06/2022 09:43, Jason A. Donenfeld wrote:
>>> Hi Phil,
>>>
>>> On Tue, Jun 7, 2022 at 10:29 AM Phil Elwell <phil@raspberrypi.com> wrote:
>>>>
>>>> This patch is fatal for me in the downstream Raspberry Pi kernel - it locks up
>>>> on boot even before the earlycon output is available. Hacking jump_label_init to
>>>> skip the jump_entry for "crng_is_ready" allows it to boot, but is likely to have
>>>> consequences further down the line.
>>>
>>> Also, reading this a few times, I'm not 100% sure I understand what
>>> you did to hack around this and why that works. Think you could paste
>>> your hackpatch just out of interest to the discussion (but obviously
>>> not to be applied)?
>>
>> This is the minimal version of my workaround patch that at least allows the
>> board to boot. Bear in mind that it was written with no previous knowledge of
>> jump labels and was arrived at by iteratively bisecting the list of jump_labels
>> until the first dangerous one was found, then later working out that there was
>> only one.
> 
> Looks like this patch fails due to CONFIG_STRICT_KERNEL_RWX.
> Investigating deeper now, but that for starters seems to be the
> differentiating factor between my prior test rig and one that reproduces
> the error. I assume your raspi also sets CONFIG_STRICT_KERNEL_RWX.

Yes, it does, as does multi_v7_defconfig.

Phil
