Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C35611B60
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 22:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiJ1UG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 16:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiJ1UG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 16:06:26 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988A78A7F1;
        Fri, 28 Oct 2022 13:06:24 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id e15so259270qts.1;
        Fri, 28 Oct 2022 13:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cpn6PgpH/B8a8nYankJVLNowGT2ZkREma3yqGiooSAQ=;
        b=B+O1SK60peeYYFs3b2JAF4gyW90Zfo5Bg3AXn1pyODIHPCCXWOzNTLkyAQ4jz1MCYq
         rTSG6EHhx4y1XzzlAShRZEwhJ5mTsL00KLxVg5Rk2VzfuMJggiQCfUaaujrDWEzL64zh
         dNShAzxPPvtTihG75J9Usc/6YZwQS3aNDBEVZ7NyxcJYzibp/46sa2GI1/vxpNQjnbDv
         JSChDTyzDGny6JZqvCdbtPPrfFBX6XsPd/87FtGptAqkGiXeYnp+ZkhUMImBbQOKMlYm
         3ci35Mf7+oNZpr2kVvKT290jHS50epcODfPeAZqNGKqX/OGG4s+f703UpdyGJINfXL2E
         vWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cpn6PgpH/B8a8nYankJVLNowGT2ZkREma3yqGiooSAQ=;
        b=xGfQ9tVy2XR9FK8MIDwllmAEO49r2gHvQmGL+CV8/nII35ZKjuAfVRc/UV6UTxmFCq
         Wbh6glC7YJSMjpQYVPjkRreGjG/NKkSDgLl/ft3/D70PsmJcxLDL33a+o/C1HTKpThv2
         tQZFT0CxIuTjWvb6uvPR4OLF4flGPcsgLcR7mxU5hAtxCpbZRQkbxNig6UsfRdvUokgL
         +fqKbNuHU8P3x8Ksf1KDNSuMDm0MS4tei0kJNqe0AMCZTYu1l/Dpf9qJL3smlHxvzDEo
         pctc1n4eLUSpa0U2mmghjY4KAKfN2TQwzvxS1IcCOa4mNIaRkY4c9jegu5ae5Faps/Oc
         /+AQ==
X-Gm-Message-State: ACrzQf16yCVX+MMaNtqGc5VIHdaM4BDQPwNNXvi6DcBtDru3wTp6wVaE
        QsXCL7MGDUpVKRvOc08xjko=
X-Google-Smtp-Source: AMsMyM4VGe5aWNBH5jRVYBWfOHWmm9O2JhL/QG1gyqpMfaD2w7AXAK43Lfd7LPByXKV4w6snM+xxgA==
X-Received: by 2002:a05:622a:355:b0:39c:cb1c:e66a with SMTP id r21-20020a05622a035500b0039ccb1ce66amr1134903qtw.22.1666987583628;
        Fri, 28 Oct 2022 13:06:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k26-20020ac8605a000000b0039a55f78792sm2806569qtm.89.2022.10.28.13.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 13:06:22 -0700 (PDT)
Message-ID: <3dd0af6d-af86-ab65-36a9-d5b068977641@gmail.com>
Date:   Fri, 28 Oct 2022 13:06:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 00/53] 5.4.221-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221027165049.817124510@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/22 09:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.221 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.221-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

