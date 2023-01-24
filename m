Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9874E678D26
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 02:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjAXBOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 20:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjAXBOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 20:14:04 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B3B6E90
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 17:14:04 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id r19so6476380ilt.7
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 17:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CCYNt7URGQ7oBqyQbd15UA8FF1tOX4zB7NKqLZYoh5A=;
        b=E2Nhqn0AphtGOlrnMlqIO1XTLWnQ7WRtNvzoix1QfdqN9k5oRhXWRE1Cm3waPhsYyJ
         DqhhHSL7w+GSMIgoha11/5DyfGkXAyHJpcSH4VtXOJu+lnIbNygUyfdHRkqUWw3OxT1O
         8vB/N0GlGP0u8Avm3q4EfdOYEVACxKvCMQC6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCYNt7URGQ7oBqyQbd15UA8FF1tOX4zB7NKqLZYoh5A=;
        b=IIwEF4sm0LLSR19AaleVKuP9QeL4P98Qq6L7KTQOJ1sqOiNd8nER3wVahHeVC0E/gN
         gvHVBaPoVyJbA3vgqgsYPfVzFXnhzmHfYiwUg5KA2tuxT05SZh2Y8J/NtAnwpiEzdq0d
         C8vEJTx1fCr113Kd4PznwX2sx/L/bPU0Nuhn4vGNbC4EvDQWIAXjL3kYSnderG52fOc/
         NbIDckcw25IvVhp+2S5sYqr5XeGTtUjT8+B6s5zscki86OfqVk8MwyyGKMdw4/UobRTh
         fOkbcz/jKHYUS0SEtDiAJeZcJtFeOXEIewdXzK5XS6s24HCJJYrRHfOABBN3GwffQLMQ
         JbCA==
X-Gm-Message-State: AFqh2ko32giAJgyNKNscKb+bgmpTYas/ZCIb3tF9Tx6qPRKtMraHLqjM
        SSIakSQjVi3MPt6k71BR6Mwr7Q==
X-Google-Smtp-Source: AMrXdXtg98qKzdHR3i1QLOOQbNk98aeenCp4sK3eBWGTI5KRfYQw404brU68awG65sVmE4XWhrahyg==
X-Received: by 2002:a05:6e02:ed1:b0:30d:c502:a9de with SMTP id i17-20020a056e020ed100b0030dc502a9demr3957277ilk.2.1674522843415;
        Mon, 23 Jan 2023 17:14:03 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e32-20020a026d60000000b003a174bd44eesm236174jaf.81.2023.01.23.17.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 17:14:02 -0800 (PST)
Message-ID: <d94fe79e-e7f2-a4e1-131a-715426e5d21e@linuxfoundation.org>
Date:   Mon, 23 Jan 2023 18:14:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 00/51] 5.4.230-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230123094907.292995722@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230123094907.292995722@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/23 02:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.230 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.230-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
