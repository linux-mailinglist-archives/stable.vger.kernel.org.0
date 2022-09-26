Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2A25EB2FB
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 23:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiIZVTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 17:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIZVTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 17:19:06 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27361923CE;
        Mon, 26 Sep 2022 14:19:05 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id y2so4938957qkl.11;
        Mon, 26 Sep 2022 14:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=VVUjmz1hoFowKQ6QM7tIE2P/0CGkXUoXfbvA34cB+tc=;
        b=UsoV1yiTZpZjeNPvmXslBo0c4rLczWSStCW5pQQQmjQ4tFPFwenrSv03TkIaVRJAUN
         BgTSsA+QEOt5fxkQTqnJUkhghK8TMiheju01PshPtzg/731q+R9VxC9p/Oyi/o/FDqWP
         xMu31gX8a+qVdu/mCwRughmKo0Wr2TnYRQYuu2N2mgIuj8fl+2oE1FwCxAMnYK9Tc6Jq
         oP8c0UzPk0sV4pYBI5JftncvDQUPFsjbsf7Z8BqSB3dQscqfWLZVxpOb9gE1nIUBpEkh
         2E7DIQF2pZWMSduvTsh6NQobBcY6N6tcjztpAd3DOE+MGKbd8cEzSP/OUNYPAdLsghnL
         2kbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=VVUjmz1hoFowKQ6QM7tIE2P/0CGkXUoXfbvA34cB+tc=;
        b=sjNdWItWNEcm57A3ichE1Lg1RlmmJ7b04kvgNEO4lDf0ObWZwuAJlRMzQpoBVP2G+O
         VDpHVZD3AEkgcwXO2VyCuECTIiUHkHANtFKj2cd+3GHhq5NIBeB5bbV/2CxJQCix/jxR
         2IAJyb9DTgLYU43HECXpjVtGZMhygvHC6HApzz+OhB6giipIcqmUvuurQq76X7LwtOO9
         aBv+zxitHNw5cAHmPCUD3Y5bx9yu+N3Gp1jwWkIKQNGenO7jO4g4fIoWbvrodkGQGDEL
         vjoLqVoCSvutEL6dUc8wPxzBNfbka2b2yElVXTb+Q/hmZwTB1wBqForeAVwx4WJqpMZc
         +9oA==
X-Gm-Message-State: ACrzQf0+C8AkXfaXGarJQmN6bKxulBlias8J9S8yY/o6t7CeLSYQV0MW
        54YIZHYQ6s2ildLoLOBcylgGx8wWvf8=
X-Google-Smtp-Source: AMsMyM6+PA/g2V7qZItzLrlPdpP+bHrWNAXy18p53VEdwvOV/abj8bQ5NfFwZIvlSeCY/MCkp0/UDQ==
X-Received: by 2002:a05:620a:981:b0:6ce:b71a:e128 with SMTP id x1-20020a05620a098100b006ceb71ae128mr15558472qkx.156.1664227144228;
        Mon, 26 Sep 2022 14:19:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x15-20020a05620a448f00b006a5d2eb58b2sm12972908qkp.33.2022.09.26.14.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 14:19:03 -0700 (PDT)
Message-ID: <f9bf357d-4c6c-eaaa-a047-5a2d019e207b@gmail.com>
Date:   Mon, 26 Sep 2022 14:19:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 000/143] 5.15.71-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220926163551.791017156@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220926163551.791017156@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 09:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.71-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
