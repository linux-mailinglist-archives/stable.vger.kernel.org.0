Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71799643857
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 23:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbiLEWs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 17:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbiLEWsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 17:48:15 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E2FB494;
        Mon,  5 Dec 2022 14:48:08 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o12so12652511pjo.4;
        Mon, 05 Dec 2022 14:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FIM8cOZnFf+hJ/RzssfzC4c3e6l34LrRCuOKeBtFZkw=;
        b=Uy3vLli75PvUovwv3R6LxBei9NdEpaSxYl0ovO9Si0tXUgAvolVy6v0AHA6gcaXEGe
         SRc5mROuDqeN/io4TtI2jn9JiS16HLdfoCIysIB8RunhhKSOQLvO3OB7xAM5SdiKXYOk
         npQhkIKbKT2AHFIFewvc74aSLPdBLMC5B0Cy9iFxg63hPfFB3b2h9YRwkcaB1N/Q8eNB
         UkC/60IJH3svb64yV1WlhXTT5yz/7pNlADVF95oMtBXiF9n7dxcurBoSpC9UxW4c+F1J
         QfIIcsKex4Hgxr0AgGYu/tV0PGEPSujao98o6gioSm02HZZ1tJUOb6/FRwCJm7GhxGdp
         MtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FIM8cOZnFf+hJ/RzssfzC4c3e6l34LrRCuOKeBtFZkw=;
        b=66rbDRdk3M7aNkWC8X1UEsdEDwvMW2M4i2AF2WilJKBxuniX2FobgF1/VeEZPaJ3AK
         kdairNyf7FUzvfJ4CQNf2OFUtQoXjAtvq2kFY4cDHh69uTc3N6nNJnP+V7A3Pjr3+5ta
         gcgr/l3tiYHL2yJ5PLhCmPq2aS8y9ecbhjNWEmbzhzYe0v4UHsAT4SxkPEPT4i5SsMSi
         BsLdnxKw75NeiimPLVtsMWvRsFdDCsxoEJXyi2vueoInAifMnBvx/SC7/JH3/rDlfQrN
         AiMtHVwabWNIYXQcjCxUsYrJVsKcDMAH7m06pWWybGVxSnFBbAynj7M3zbGODvPndtM/
         SENg==
X-Gm-Message-State: ANoB5pkHvvg38VmxFhkVHPazMwSzT22gCA7l0uBC9vfdtjwgaYm6UMbx
        zLfBzkN/FefcFc7uqtgTC+o=
X-Google-Smtp-Source: AA0mqf414ZUiW8PrWeib6fKdHGgyKZi5tmPVx/zBfMsY62OY/7jl9MeCItNH0XOcxs9Aouhu7tMaug==
X-Received: by 2002:a17:90b:108:b0:219:36d3:678d with SMTP id p8-20020a17090b010800b0021936d3678dmr41751133pjz.187.1670280487958;
        Mon, 05 Dec 2022 14:48:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a3-20020a170902710300b0018963b8e131sm1814407pll.290.2022.12.05.14.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 14:48:07 -0800 (PST)
Message-ID: <2bb37989-7c22-ae06-6568-8419ce57e44b@gmail.com>
Date:   Mon, 5 Dec 2022 14:48:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/62] 4.9.335-rc1 review
Content-Language: en-US
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
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <80305ea1-4d52-b1d3-e078-3c1084d96cc7@nvidia.com>
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

On 12/5/22 14:28, Jon Hunter wrote:
> Hi Greg,
> 
> On 05/12/2022 19:08, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.9.335 release.
>> There are 62 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>      Linux 4.9.335-rc1
>>
>> Adrian Hunter <adrian.hunter@intel.com>
>>      mmc: sdhci: Fix voltage switch delay
> 
> 
> I am seeing a boot regression on a couple boards and bisect is pointing 
> to the above commit.

Same thing here, getting a hard lock for our devices with the SDHCI 
controller enabled, sometimes we are lucky to see the following:

[    4.790367] mmc0: SDHCI controller on 84b0000.sdhci [84b0000.sdhci] 
using ADMA 64-bit
[   25.802351] INFO: rcu_sched detected stalls on CPUs/tasks:
[   25.807871]  1-...: (1 GPs behind) idle=561/140000000000000/0 
softirq=728/728 fqs=5252
[   25.815892]  (detected by 0, t=21017 jiffies, g=61, c=60, q=55)
[   25.821834] Task dump for CPU 1:
[   25.825069] kworker/1:1     R  running task        0   509      2 
0x00000002
[   25.832164] Workqueue: events_freezable mmc_rescan
[   25.836974] Backtrace:
[   25.839440] [<ce32fea4>] (0xce32fea4) from [<ce32fed4>] (0xce32fed4)
[   25.845803] Backtrace aborted due to bad frame pointer <cd2f0a54>

Also confirmed that reverting that change ("mmc: sdhci: Fix voltage 
switch delay") allows devices to boot properly.

Had not a chance to test the change when submitted for mainline despite 
being copied, sorry about that.

Since that specific commit is also included in the other stable trees 
(5.4, 5.10, 5.15 and 6.0) I will let you know whether the same issue is 
present in those trees shortly thereafter.
-- 
Florian

