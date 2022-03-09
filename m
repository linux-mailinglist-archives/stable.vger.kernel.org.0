Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B7E4D3AFF
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 21:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbiCIU0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 15:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbiCIU0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 15:26:03 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B95C20
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 12:25:04 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id q11so4128644iod.6
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 12:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EzQG9AP/P4vkkpvfUhT5y9QvXBp8ABaWilkhPZ6aCkw=;
        b=YKykQGZHRzAZsaXcT7TJtlakh1uo5n3gVq/iyCYlbvqSGMGYQ3L6N1h0kg2zCbLMh1
         c/SitrC9KhUr3Fj5g+UJ2OtOXSgs00q1PZVDmxEvuDSBVBiCSycr1bQyCIgOjTU0SZXV
         iuXVgHRpGUt2uwBsADLXp806wGJjf4whjouNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EzQG9AP/P4vkkpvfUhT5y9QvXBp8ABaWilkhPZ6aCkw=;
        b=LAn56QgJNTdPb5X1haO2AVnE4GGlaFH/zxcw3g5ywMmWFA8LPh05S99QLNKIIx6zmG
         +T8Z9OIwZfQ9gHGhvQutolv/z+YI4bFMKdQ0o69lVsNQdpEOXXZYlXXT/V+HETCDS94Q
         b9nFfwDSy1VV6dGWQ18yrnVHw27gJhNmQZd8h/fFH0L1Qa+0v5E7+lODGOEKOmPEkdUK
         7jkux7X6xUq9Ju4JbiQG+XShS2iPp0sCs6cAxJVobXEZjQXMxP220eGcuh/c024hFDrV
         M8i8HRhTtcNmf8wZnnmHGB9MG4Uq5rm8pDKoII4HTmj1Zd/J7Lu6MrGfptZLKuRgdj0H
         BnxA==
X-Gm-Message-State: AOAM533dSwbXhnVWTf42Z/pTgN/8zwSlOWRq+D2Fip0mehCEwBViCOvz
        P2r5pyYNxqMKcXAzCZtYf8+g+A==
X-Google-Smtp-Source: ABdhPJyA3HO9R00JT4HG63cMjjmDIk4CL+AMk4Aoiz8xGpLnXMtpUSUGhCFjP6v5Wat0lCCbTM5dmQ==
X-Received: by 2002:a05:6638:1c0d:b0:317:6936:d648 with SMTP id ca13-20020a0566381c0d00b003176936d648mr1088340jab.12.1646857503598;
        Wed, 09 Mar 2022 12:25:03 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id l16-20020a5ed810000000b006454c2e65e7sm1450353iok.51.2022.03.09.12.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 12:25:03 -0800 (PST)
Subject: Re: [PATCH 5.4 00/18] 5.4.184-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220309155856.552503355@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f9cfdeef-bcc1-1333-5417-2ef007b3cef1@linuxfoundation.org>
Date:   Wed, 9 Mar 2022 13:25:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220309155856.552503355@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/22 8:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.184 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc1.gz
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
