Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50285562661
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 01:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiF3XDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 19:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiF3XDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 19:03:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F47D53ECD;
        Thu, 30 Jun 2022 16:03:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b2so695197plx.7;
        Thu, 30 Jun 2022 16:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VXyzkJ1yFKxSftjXXIqMfOe5cFVJA1hKHC9vOG9MyrM=;
        b=UrRDVCt+s0fKE+58WMZ9vq/VOPypqAmGSC0Cl0gZaI2j3yRt4WkZxkpb0eyqqDs50g
         /gEerFkgEVL3pvK0omK9ZWPlr7d9JBaWVMeMwVWGJx2jRvofDMqGGhWH1OHLXXH2x0LP
         4lg9javO8t06SUF1pMAK00XOJjNYzezwzBywgqnrgF3gY2p/FcDUoW9iElq2D4Jpdqjr
         61GicC8kl2BXst4pCQl2rSk4UhZeDPuxggLYxzf8eccO7PUMttQa8XsHyx4HYqoC5uw+
         f/G0L7GpV8ZHVlYtd7LeLPnP1gUr6V4usxONcSYBWULHPRhPjJZqG3iTjr76VYyg/ItE
         HaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VXyzkJ1yFKxSftjXXIqMfOe5cFVJA1hKHC9vOG9MyrM=;
        b=Zs+FcR5sqVxzzQXAIKWYSKg3slL4qosm4WBTSawDIBBCxW21PXoiR1eAoLk2yujnKq
         WH76822kk5YacUHTyDzPQ7l8eqpWh/A/HfX7wQEr5he4x28sOCwQs5gEZKtDGLW2jyRC
         fMdY9RUQBBTg1dIsrEwADmZkWJWFPgkLovcVgxI9SkUcCoNIhbT+HMWBjp00qqe4/uMj
         HxPP9GiFtUdCcsHdQr/kz6bqQm5+ujGtEoasbLrqkZIeSwGDkrUzHKnp3VAo5Lb3zGnN
         ambg5WTIAkNXG3kFSN8VGgeLOC3Z+Y+1uqhyQN7DpkJ/gcld1vuk4RFBw/1ODXTV4X4T
         Mn7Q==
X-Gm-Message-State: AJIora8l+rLAQ8nwtcGcN6pxkrPjfXRHuqMV1iwJN0DSqzHiV+6NR3Y8
        o6Z/duJwGPZSfvG7OP9Scuk=
X-Google-Smtp-Source: AGRyM1sME5R/coJzsav052ZF3AGkBqactyHBSyAo++l6YlMvIo5pkscp8X2SSC58hkgKd4Ji937poA==
X-Received: by 2002:a17:903:240b:b0:16b:8e84:f22d with SMTP id e11-20020a170903240b00b0016b8e84f22dmr17229891plo.128.1656630217915;
        Thu, 30 Jun 2022 16:03:37 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902bd0a00b00161ac982b9esm13995452pls.185.2022.06.30.16.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 16:03:37 -0700 (PDT)
Message-ID: <6658b2b0-a8c5-372c-1fbe-9fbe69fe52fe@gmail.com>
Date:   Thu, 30 Jun 2022 16:03:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/12] 5.10.128-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220630133230.676254336@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/30/2022 6:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.128 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.128-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
