Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE236439CE
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 01:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLFALR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 19:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbiLFALQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 19:11:16 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430051D64B;
        Mon,  5 Dec 2022 16:11:15 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id cm20so12826579pjb.1;
        Mon, 05 Dec 2022 16:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JRyxz3UgR2mRadDM/LBh0imbbNc2xyuMYZ0S1rjZ06g=;
        b=lz/6eOjEqgst1epv8QMlPhHczfA8/1jjLqBIv4XJX41943Ig+ZiZkfHl3EUeOUCGGI
         s3hh+8aH9lRV7qNuQ2HJuJeD+lDPENEk9SILUGZncxng1ix5YUjSWjWSpPHYRqAoV+pd
         vgm60lwMYKc6NDSbM2FINHdRGkqsrnWLgNwiPDH83EoP9RIsDz+vOVmh8Jydc9iq5/ys
         IdyPgFZ4rkRZMsFL3q3q/ur3Y43wZLP1QAiyZjHIfRSHL8Iyh4Jf5MYxuEdSsSFZthB2
         V9AWfziEQAmXbBkAZIhdKyZWSb/1Eq1N7MIDrOT5tlW3dNDQzyw30pBcxt5R8xXC9RMS
         H79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JRyxz3UgR2mRadDM/LBh0imbbNc2xyuMYZ0S1rjZ06g=;
        b=M4UXcHhv2AjQfuMLu5H/a0uSV7KUUVYLZvUdCRKw8vOI3GHirRUeNMaI+hJRNN7SmY
         mbeMvn7BNIh8rgVtXfleTAAfWjH3IBy++L1DdWt+esqSIkEBzbgDR02UEvJFU4nYL+Kw
         J5WcCgSd3wtYKm+Y4iX23SQs5BkeFFOFR+Id1fEhdeb6XYVRf/4zVcsSk77AFQUCW4fS
         Md0iN4GFNt0NdyDE7TIcTS734HxyFlW95DMGGLT9/iAupglQaMsY2eVTrhFyH1ToZ9qu
         z4b2QgieufMfsVnIw6hPQ250FmeslO48JR+sQGKWYpwfdHzVQXtvSE7GymtdIoO2re0U
         1eZQ==
X-Gm-Message-State: ANoB5plLxrgtz1zvm6rOKobjsl4n51zYhP+kDdCCYBb/jZ2v0pNAprTU
        9bso0vA945vlcmrQyUbkq5M=
X-Google-Smtp-Source: AA0mqf5FJWQmzZFm7pTin0C/dV3xql4UirmSv7fGXJ1SYvhpdj48R0WrLSgzMXqvXhce4zZbgdFguQ==
X-Received: by 2002:a17:90a:c003:b0:219:8d13:2898 with SMTP id p3-20020a17090ac00300b002198d132898mr18612240pjt.124.1670285474707;
        Mon, 05 Dec 2022 16:11:14 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e30-20020a63501e000000b00478ca052819sm1493269pgb.47.2022.12.05.16.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 16:11:13 -0800 (PST)
Message-ID: <e00f6e66-fd51-5b55-6cd1-ec9abe038022@gmail.com>
Date:   Mon, 5 Dec 2022 16:11:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/62] 4.9.335-rc1 review
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190758.073114639@linuxfoundation.org>
 <80305ea1-4d52-b1d3-e078-3c1084d96cc7@nvidia.com>
 <2bb37989-7c22-ae06-6568-8419ce57e44b@gmail.com>
In-Reply-To: <2bb37989-7c22-ae06-6568-8419ce57e44b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 14:48, Florian Fainelli wrote:
> On 12/5/22 14:28, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 05/12/2022 19:08, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.9.335 release.
>>> There are 62 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>>> Pseudo-Shortlog of commits:
>>>
>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>      Linux 4.9.335-rc1
>>>
>>> Adrian Hunter <adrian.hunter@intel.com>
>>>      mmc: sdhci: Fix voltage switch delay
>>
>>
>> I am seeing a boot regression on a couple boards and bisect is 
>> pointing to the above commit.
> 
> Same thing here, getting a hard lock for our devices with the SDHCI 
> controller enabled, sometimes we are lucky to see the following:
> 
> [    4.790367] mmc0: SDHCI controller on 84b0000.sdhci [84b0000.sdhci] 
> using ADMA 64-bit
> [   25.802351] INFO: rcu_sched detected stalls on CPUs/tasks:
> [   25.807871]  1-...: (1 GPs behind) idle=561/140000000000000/0 
> softirq=728/728 fqs=5252
> [   25.815892]  (detected by 0, t=21017 jiffies, g=61, c=60, q=55)
> [   25.821834] Task dump for CPU 1:
> [   25.825069] kworker/1:1     R  running task        0   509      2 
> 0x00000002
> [   25.832164] Workqueue: events_freezable mmc_rescan
> [   25.836974] Backtrace:
> [   25.839440] [<ce32fea4>] (0xce32fea4) from [<ce32fed4>] (0xce32fed4)
> [   25.845803] Backtrace aborted due to bad frame pointer <cd2f0a54>
> 
> Also confirmed that reverting that change ("mmc: sdhci: Fix voltage 
> switch delay") allows devices to boot properly.
> 
> Had not a chance to test the change when submitted for mainline despite 
> being copied, sorry about that.
> 
> Since that specific commit is also included in the other stable trees 
> (5.4, 5.10, 5.15 and 6.0) I will let you know whether the same issue is 
> present in those trees shortly thereafter.

This only appears to impact 4.9, Adrian is there a missing functional 
dependency for "mmc: sdhci: Fix voltage switch delay" to work correctly 
on the 4.9 kernel?
-- 
Florian

