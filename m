Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB2B6A13DD
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 00:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBWXkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 18:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBWXkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 18:40:22 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF662D179
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 15:40:21 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id z5so2957152ilq.0
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 15:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SL0z9x2zUIufYQsB/HLcyg5XTH8HaFTQReJij2yCEP8=;
        b=SJzCjQBQU9Z5SQNuvDZSHLS4thJUMrfncnBMPYjZ3APB5RlSqcj7ebGh+MjLUzWMTX
         xnz1li7U6DY6lddE1ItjW5Qlzuod2X9K1C3sK6IeAtYhjKjFvdCxYJhiH23gKo5WlVHe
         Ck+ZL4TAA6dC/7bJvunZ9WbtWpIG1QMT4lvY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SL0z9x2zUIufYQsB/HLcyg5XTH8HaFTQReJij2yCEP8=;
        b=Uk4LPmj6oVRUh4KnRiniIHRCE8Cog34xjN855fdojr01Wnx0zbz8S7q930Cbir/Lnz
         LiRRbnGExCZtQQNFCPfWzvNKatNXyUh3iHPCqwHP/nBTGTnMlC0nB0GSI9w01xfxw7L1
         Rmidri9ImpN3s7QxXi/X8bQZwkrGo1P6R24L1V6+c5eG5isMn1+OC4n/tVwaaHoAX3NJ
         Z2PewBwjJSStoQJd17OtBIBwUtZPti2cDeo/zqU9pDayUCMJ8yiRm6XoYS3xWGLNx9DH
         rpPRMJIych5OYKD+jH1MB/yNf44mzwx0zzYS+XCAXIrIrPqD6wUgCLntiwfGYGYk+A5O
         oZwA==
X-Gm-Message-State: AO0yUKVZmcujBRVaJ4nlzaeatt3VYlYAEkulUjPtUmiKKwL30ZN1vC7z
        iGdWt91NlrtW9RGyNQinju/PCg==
X-Google-Smtp-Source: AK7set+UY8OPToN1EOx5FzoLtfSuFrXICfON+YwtZjlyx391Os6zmh5lO/NypWAW1Ke38B3k4UckeQ==
X-Received: by 2002:a05:6e02:17ca:b0:315:5436:a632 with SMTP id z10-20020a056e0217ca00b003155436a632mr9360401ilu.2.1677195621066;
        Thu, 23 Feb 2023 15:40:21 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o24-20020a02cc38000000b003c4eb8f862fsm3123944jap.66.2023.02.23.15.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:40:20 -0800 (PST)
Message-ID: <e5155c9d-b142-fd3f-0198-3fe4db83b350@linuxfoundation.org>
Date:   Thu, 23 Feb 2023 16:40:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 00/12] 4.19.274-rc2 review
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
References: <20230223141538.102388120@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141538.102388120@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 07:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.274 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.274-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
