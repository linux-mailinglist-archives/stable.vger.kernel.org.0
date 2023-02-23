Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A315A6A13CF
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 00:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjBWXcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 18:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBWXcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 18:32:01 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4180458B48
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 15:32:00 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id g6so1360211iov.13
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 15:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677195119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zyIeyBryi+yhauAhwwFawA2z6cP5sXH4pUcK8IFs2AE=;
        b=bPy644GfIaOOOc10/Rs26frvMcI3dhK1RUvMhRPlw2m8VdbASF4Kibt63D3DVCP9PG
         U1pMP1jrme+ifTk2eWfkwxSHPrO/rYvXvj96PStwL3Fob+ynXmOFg4JeY780tcd+NORt
         Snl/oc/4qk8UwRIxa7b7P56EFYHiyuc7bCfA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677195119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zyIeyBryi+yhauAhwwFawA2z6cP5sXH4pUcK8IFs2AE=;
        b=Tt5IC85waqtoq3Z4kV0hUpOLOwn4uRYqdDEcbpnzHndK5RwbSuTMENSjXX/RAme40j
         31A5l51NaWkjqQQVkgqmXsYJQp4+din7A7CbUohD4mGr5zt66I7NDUhAEmr4K0qq8KgV
         ffuLmynchgRZaL+HD0mB/R1FU0u+gzOQoXp9a2vJSO5GRRFGZWHxkzeAbiCsQ4nrysYC
         jlwwbB/swx2jVXNoQYfoOaxRbOmOaJ6yhiuEN9tQcZghwS+lts4z+2Z47BiuWfAT4l3n
         SEpCF6ED5N6/8whPZ9pFWA+cYDUounK4wdfpYaDFBXyEU4HqIpNz31pCUQoEKqxIw9R0
         F2uQ==
X-Gm-Message-State: AO0yUKV4giLPiSE1WwyjYM8AMl/BvSZnu9VFts3KSg4EF1rsSECThwAe
        2asI7wgPRLHngq6NzstzPUOvCw==
X-Google-Smtp-Source: AK7set/hXUVxXyif8mLIBAsHQeDvpW1mt0LvgboM2uPhHYzyJVXPgi311z0/1ab41iGINi5AYCk+Sw==
X-Received: by 2002:a6b:8d45:0:b0:746:190a:138f with SMTP id p66-20020a6b8d45000000b00746190a138fmr7395194iod.2.1677195119341;
        Thu, 23 Feb 2023 15:31:59 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id 14-20020a5ea50e000000b0073fe9d412fasm3304295iog.33.2023.02.23.15.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:31:58 -0800 (PST)
Message-ID: <e78f73df-e62b-a33c-77c8-75d1f946f6ad@linuxfoundation.org>
Date:   Thu, 23 Feb 2023 16:31:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
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
References: <20230223141539.893173089@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
