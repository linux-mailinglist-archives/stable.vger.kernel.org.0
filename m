Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5053628B83
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 22:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237752AbiKNVoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 16:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbiKNVoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 16:44:21 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEC1192B9;
        Mon, 14 Nov 2022 13:44:19 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p12so11344379plq.4;
        Mon, 14 Nov 2022 13:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bOVcJPF0rDwmg6uNcHoHwsdL2yI5JjV5qKek/QHhhas=;
        b=PGV8Mnh76gikDcv/oexMrfg//R4YrQ1sfbqGT+NKd554A2cTVlHN+59kodshelRBlC
         agXQo9n/ZFG37mxtY1JbYTuVoEs+mAAdFua9kuTzSb6xHcyrgErFYEw2R82a6ByOH4Wr
         uDdHHUPplSM0cY+zbzb6yotqVTmzDwUolRZ6rVP2ZB6qjaC5loU2joLwkUQEqy0Eltw6
         v0chZ7qf+MPq9B5xb4M1NsrmR3GE30BIEmmvcONKHP7rN5ltpQDk0B2YlxkFMm3iXLwW
         BkCIKf4BrCROlQgYULZtSoGYcWMq1iFawrs6lhQ6R/u6tPOdtOAGTgZnCd/WrHladFRg
         OnlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bOVcJPF0rDwmg6uNcHoHwsdL2yI5JjV5qKek/QHhhas=;
        b=Zv/GMdAhbl3+9ZfbpEhJWNet997R0aDJtiZm2ACWiS7YKdcYuJL9YoO5HNZ/UtEX8z
         Ol9l7x0HsyWcKxX39xrxvfDE1K3KIyQZu65wmHEEHsSBDyLMp3gvkZqmXu6m0uji5kev
         3Dgl1stUvbyFIoUkOpV0EFx8HSPKjQQE35dnDzrbvd3f3RJzBYWUOC7cI1ebLvXmc00A
         1pulk7Gpy4Ajk/M1DTTWg7bGUQg59/Tbc+4nLqaiQJF2vBZJiLPrVIVIuAcEjTpGLkyq
         Ta38O1IrjZTkZHIz9IUWiruzkkrt/Nk8JtzO+e7M3nos6w6NsymC1ovwTWxnK+Wh5NDG
         Xp3w==
X-Gm-Message-State: ANoB5pkNaeNljTV86XJpJHiSv+NMi49Of4wf0FBeeQ6eaEEq4OwAmGX3
        WXMs8tUpZqlB47UUKxx1aR0=
X-Google-Smtp-Source: AA0mqf6EENMJIP2xsd15+zaKPtpk8/8jH0LD4/kt+gjFZA6/t5rurRFBVd9Oo84qLS0WFjital4J6w==
X-Received: by 2002:a17:903:31ce:b0:186:f36a:63b2 with SMTP id v14-20020a17090331ce00b00186f36a63b2mr1016021ple.128.1668462258496;
        Mon, 14 Nov 2022 13:44:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 19-20020a170902c11300b0017f5c7d3931sm8003787pli.282.2022.11.14.13.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 13:44:17 -0800 (PST)
Message-ID: <760d85de-3426-f5c0-1aec-08586ab176d9@gmail.com>
Date:   Mon, 14 Nov 2022 13:44:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221114124442.530286937@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
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

On 11/14/22 04:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.155-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

