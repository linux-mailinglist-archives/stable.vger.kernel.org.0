Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAED5532F03
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239793AbiEXQaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239794AbiEXQat (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:30:49 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4334D5EBD5;
        Tue, 24 May 2022 09:30:37 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n18so16291780plg.5;
        Tue, 24 May 2022 09:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q2gMJw1ZmAVIkKFyONaRXBbSho1N5Bi+EIY2WJ8x/7M=;
        b=HWkf7rdLEBVd4E1jJ9d2FhSSavnGuCpYLmnGdO1TuU/mxAjVldST3aAKO8z9NDxyxa
         ZWwrFEc12bmH1VRGPylO30y3klkyRFqIydGo0g2k4RmKJjeVRAnq9S1Im/+yXZIs27YP
         4k6Az4yUX8QNu0Twsht/N4T8ZUCy7pm5KAAm0W+L0zofJVA2VGC3cKpFc0PmQX5a0LjR
         m5YU4HAx4rbf73+j7vBiFMrb3Ir9CeR8MUmVwjzSifyywVtvd27z6r3098tTP+NamfUa
         cMxd//1+bL88jE5rWuLPLwIhGPKtHUvbAsahXa/GMrS0ymUN9ICJpeTN0rl+JzZRjtV8
         m1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q2gMJw1ZmAVIkKFyONaRXBbSho1N5Bi+EIY2WJ8x/7M=;
        b=sw4YeEdz3jHp1xyGmEbsP70s2PmXdrUP/ELf8PnoTHoR/y8Ki/eFY/0V4X/ThMa3Qd
         CqGXg6GbaGmh3wTzTAUOa42UbgeVYx0rNpQV9VUval4eQ+tUe50IaMtQbAVKsr8HK/0J
         InCb0m3wmu/IlW5F0P/eiN6GXlmrkmfAenzMRyjJx/g2yNoxAY6oZyIiwgQ/1wKV+yJ3
         66xXPoUUreVt78CN0z2krGnj/ueafEtWO3hYH3KK+r1cjhq91UrdSOzS0dbsGvRLkkgW
         pZtwLzf9EoKdwpJx3zfWwfSaE/99hh5VZ18Yf91WxEZgZJjjNHyo/epsXvMDVsw6YbhE
         s8kg==
X-Gm-Message-State: AOAM5332VoFCTDWzI7Y0Kb13mlj9M6eutJ4l+nDNs5tHgySFP87o/zG9
        /NoDsi/S1JwCgalEq8UkKUE=
X-Google-Smtp-Source: ABdhPJxxjt9PhhF/Qfg1O/+UB6ZOEnQgdywnFvtHUQP92Hky43iajQQzzW1PGKxcC8S/JknBAeF8aQ==
X-Received: by 2002:a17:902:cec9:b0:162:43f0:ba8a with SMTP id d9-20020a170902cec900b0016243f0ba8amr3273966plg.85.1653409836325;
        Tue, 24 May 2022 09:30:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ev8-20020a17090aeac800b001cb6527ca39sm9630pjb.0.2022.05.24.09.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 09:30:35 -0700 (PDT)
Message-ID: <883fc4cf-dce0-a433-5cf7-7de68be17ffb@gmail.com>
Date:   Tue, 24 May 2022 09:30:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Hunter <jonathanh@nvidia.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220523165743.398280407@linuxfoundation.org>
 <6f4034a5-f692-8a64-a09d-8bfe49767b78@nvidia.com>
 <YozK4DvamHBJ1qdX@kroah.com>
 <fbeb9833-4166-1919-e6ab-9ac7625a21d6@nvidia.com>
 <Yoz0Xv59MrUwFkMT@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Yoz0Xv59MrUwFkMT@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/22 08:06, Greg Kroah-Hartman wrote:
> On Tue, May 24, 2022 at 03:55:58PM +0100, Jon Hunter wrote:
>>
>> On 24/05/2022 13:09, Greg Kroah-Hartman wrote:
>>
>> ...
>>
>>>> I am seeing a boot regression on tegra124-jetson-tk1 and reverting the above
>>>> commit is fixing the problem. This also appears to impact linux-4.14.y,
>>>> 4.19.y and 5.4.y.
>>>>
>>>> Test results for stable-v4.9:
>>>>       8 builds:	8 pass, 0 fail
>>>>       18 boots:	16 pass, 2 fail
>>>>       18 tests:	18 pass, 0 fail
>>>>
>>>> Linux version:	4.9.316-rc1-gbe4ec3e3faa1
>>>> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>>>>                   tegra210-p2371-2180, tegra30-cardhu-a04
>>>>
>>>> Boot failures:	tegra124-jetson-tk1
>>>
>>> Odd.  This is also in 5.10.y, right?  No issues there?  Are we missing
>>> something?
>>
>>
>> Actually, the more I look at this, the more I see various intermittent
>> reports with this and it is also impacting the mainline.
>>
>> The problem is that the commit in question is causing a ton of messages to
>> be printed a boot and this sometimes is causing the boot test to fail
>> because the boot is taking too long. The console shows ...
>>
>> [ 1233.327547] CPU0: Spectre BHB: using loop workaround
>> [ 1233.327795] CPU1: Spectre BHB: using loop workaround
>> [ 1233.328270] CPU1: Spectre BHB: using loop workaround
>> [ 1233.328700] CPU1: Spectre BHB: using loop workaround
>> [ 1233.355477] CPU2: Spectre BHB: using loop workaround
>> ** 7 printk messages dropped **
>> [ 1233.366271] CPU0: Spectre BHB: using loop workaround
>> [ 1233.366580] CPU0: Spectre BHB: using loop workaround
>> [ 1233.366815] CPU1: Spectre BHB: using loop workaround
>> [ 1233.405475] CPU1: Spectre BHB: using loop workaround
>> [ 1233.405874] CPU0: Spectre BHB: using loop workaround
>> [ 1233.406041] CPU1: Spectre BHB: using loop workaround
>> ** 1 printk messages dropped **
>>
>> There is a similar report of this [0] and I believe that we need a similar
>> fix for the above prints as well. I have reported this to Ard [1]. So I am
>> not sure that these Spectre BHB patches are quite ready for stable.
> 
> These patches are quite small, and just enable it for this known-broken
> cpu type.
> 
> If there is an issue enabling it for this cpu type, then we can work on
> that upstream, but there shouldn't be a reason to prevent this from
> being merged now, especially given that it is supposed to be fixing a
> known issue.

Jonathan any chance this is Tegra specific? Our ARCH_BRCMSTB SoCs which 
use a Brahma-B15 which uses nearly the same ca15 processor functions 
defined in arch/arm/mm/proc-v7.S reports the following *before* changes:

[    0.001641] CPU: Testing write buffer coherency: ok
[    0.001685] CPU0: Spectre v2: using ICIALLU workaround
[    0.001703] ftrace: allocating 30541 entries in 120 pages
[    0.044600] CPU0: update cpu_capacity 1024
[    0.044633] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.044662] Setting up static identity map for 0x200000 - 0x200060
[    0.047410] brcmstb: biuctrl: MCP: Write pairing already disabled
[    0.048974] CPU1: update cpu_capacity 1024
[    0.048978] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.048981] CPU1: Spectre v2: using ICIALLU workaround
[    0.050234] CPU2: update cpu_capacity 1024
[    0.050238] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.050241] CPU2: Spectre v2: using ICIALLU workaround
[    0.051437] CPU3: update cpu_capacity 1024
[    0.051441] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    0.051444] CPU3: Spectre v2: using ICIALLU workaround
[    0.051532] Brought up 4 CPUs

and this *after* merging 4.9.316-rc1:

[    0.001626] CPU: Testing write buffer coherency: ok
[    0.001670] CPU0: Spectre v2: using ICIALLU workaround
[    0.001689] CPU0: Spectre BHB: using loop workaround
[    0.001705] ftrace: allocating 30542 entries in 120 pages
[    0.043752] CPU0: update cpu_capacity 1024
[    0.043784] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.043813] Setting up static identity map for 0x200000 - 0x200060
[    0.046547] brcmstb: biuctrl: MCP: Write pairing already disabled
[    0.048121] CPU1: update cpu_capacity 1024
[    0.048124] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.048129] CPU1: Spectre v2: using ICIALLU workaround
[    0.048165] CPU1: Spectre BHB: using loop workaround
[    0.049398] CPU2: update cpu_capacity 1024
[    0.049402] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.049405] CPU2: Spectre v2: using ICIALLU workaround
[    0.049440] CPU2: Spectre BHB: using loop workaround
[    0.050613] CPU3: update cpu_capacity 1024
[    0.050617] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    0.050619] CPU3: Spectre v2: using ICIALLU workaround
[    0.050653] CPU3: Spectre BHB: using loop workaround
[    0.050722] Brought up 4 CPUs
[    0.050738] SMP: Total of 4 processors activated (216.00 BogoMIPS).
[    0.050753] CPU: All CPU(s) started in HYP mode.
-- 
Florian
