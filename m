Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF9468A0CD
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 18:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjBCRur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 12:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjBCRup (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 12:50:45 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA11783F8;
        Fri,  3 Feb 2023 09:50:42 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id g8so6311820qtq.13;
        Fri, 03 Feb 2023 09:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X98XwPHCATAqoyCJbroZ3zmbYV9N3z/uPBJxyFU6PR8=;
        b=qKwT99gXJUlK8jpfdkOFgWa74gVxy/H0hDP+O6VTX2V5uEipX1eD4IrZ0/zqXiqHKx
         sbvaAQ91J4eXgP1uP9vAp1lhAGYIEVGcBxeEUaKX9edpPSJinWQdV0Hm0UCqaYsH/39q
         T17gYDxcpA5KJQ5cWAiO+Y9bWqg5LaFrPG5MUpi1xhzRSkFHATUJqG0YXsjMp0xh7tS1
         J/V+xpNxHzPODmsVESM1t2ghJBEvAXpJ/wMx65mHALSfwAE3EuI4NtgoTWAIfkkg3tj/
         ycgiS1ZR6LMebI/QLGMEzsElInyVkhHRkwAG1XVOfpuYmtcXeBKG/q8M3xCRmROqTD1j
         OxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X98XwPHCATAqoyCJbroZ3zmbYV9N3z/uPBJxyFU6PR8=;
        b=yY1ARJXQZ/kRqX9RHLlJmu/cwnQi8Ed70J/AaXAyQ8nuT4TAC2yEQuhPUQzJIVlmP3
         b8bXHPBca3VCsraK4BUxDTWlayT27cQZxeDWvUUeaL15Jh+qt9yyC7pJAoKHVhBgTE0r
         9vMg7wJdlCz7gfhjld0Ig3M9E1lweiJ11ZSuB6HDb4eiaMAYUbRRns3PFmpXHY1wOeTb
         TawNMWt/4R0C0K53wLfIV6duqbmFwW/NlB2iVZyu0X+MscNcKJ7ATVWKC05TWkuKPUgR
         XI/j9WGJpcFUaoyqYhWGJlbBab5wQK8uVfuMoG8XuqbZOHTHO36p0jaAGxGXIoIEt5yq
         YOWQ==
X-Gm-Message-State: AO0yUKXRGNoo2tg84I9oC+KyKS+SDWCFfG/HT2h7mf4m5H/vNF9SMReh
        E9CySK15EabQw9Kr1dPPZNg=
X-Google-Smtp-Source: AK7set+pwTCJGnVY1tSsiOxjAN7/Pvsx4cx3hcJic7vMvYqUuWK7aMxHvORkCbE52P788Ugn+r6gkA==
X-Received: by 2002:ac8:584e:0:b0:3b9:a4c8:d57a with SMTP id h14-20020ac8584e000000b003b9a4c8d57amr21058494qth.32.1675446641849;
        Fri, 03 Feb 2023 09:50:41 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 63-20020a370a42000000b00719d9f823c4sm2206530qkk.34.2023.02.03.09.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 09:50:39 -0800 (PST)
Message-ID: <075c6ee2-fc1d-1b95-4cc6-4caec754dab7@gmail.com>
Date:   Fri, 3 Feb 2023 09:50:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH stable 5.4] usb: host: xhci-plat: add wakeup entry at
 sysfs
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Matthias Kaehlcke <mka@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "open list:USB XHCI DRIVER" <linux-usb@vger.kernel.org>
References: <20230201174404.32777-1-f.fainelli@gmail.com>
 <20230201174404.32777-3-f.fainelli@gmail.com> <Y9qsZysFUFnq7VQW@kroah.com>
 <319ebea0-61dc-2e08-f48b-4555b8fb894a@gmail.com> <Y9y+wRPYzQVwb3JS@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y9y+wRPYzQVwb3JS@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/2/23 23:58, Greg Kroah-Hartman wrote:
> On Wed, Feb 01, 2023 at 03:19:08PM -0800, Florian Fainelli wrote:
>> On 2/1/23 10:16, Greg Kroah-Hartman wrote:
>>> On Wed, Feb 01, 2023 at 09:44:04AM -0800, Florian Fainelli wrote:
>>>> From: Peter Chen <peter.chen@nxp.com>
>>>>
>>>> commit  4bb4fc0dbfa23acab9b762949b91ffd52106fe4b upstream
>>>>
>>>> With this change, there will be a wakeup entry at /sys/../power/wakeup,
>>>> and the user could use this entry to choose whether enable xhci wakeup
>>>> features (wake up system from suspend) or not.
>>>>
>>>> Tested-by: Matthias Kaehlcke <mka@chromium.org>
>>>> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
>>>> Signed-off-by: Peter Chen <peter.chen@nxp.com>
>>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>>> Link: https://lore.kernel.org/r/20200918131752.16488-6-mathias.nyman@linux.intel.com
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>> ---
>>>>    drivers/usb/host/xhci-plat.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> Why is this new feature needed on these older kernels?  What does it fix
>>> that is broken?
>>
>> It fixes the inability to make the XHCI controller a wake-up device since
>> there is no /sys/*/*xhci/power/wakeup sysfs entry to manipulate unless this
>> patch is applied.
> 
> But that is a new feature, not a bugfix.

Support for wake-up was already there in the xhci driver, just there was 
no way to activate it from user-space, that seems like a fix to me.

> 
> What systems need this for these older kernels that will actually update
> to them in order to pick up this change?

Some NXP systems required that, and all of our ARCH_BRCMSTB SoCs also 
have that capability, I see you applied those patches, thanks!
-- 
Florian

