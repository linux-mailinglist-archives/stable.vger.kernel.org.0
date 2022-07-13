Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80882573C79
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 20:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbiGMSYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 14:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbiGMSYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 14:24:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220F818E0F;
        Wed, 13 Jul 2022 11:24:20 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so5039824pjl.5;
        Wed, 13 Jul 2022 11:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IQYaS9k5ojuuAez/KlcCMDap25vy0a+Fzv+USTDn99U=;
        b=B9moJQ9cFhCxVBbJjcGabuBEjnJexLChQq1/dICXG2G16Mow8XDCwKK0LgGMJB+ODG
         OJOkVQTIDJjhlkjkgLFh2lN4F7QqP6RlbFUnCTFw61NpW/ZF8brq/8kg2moSwP3vDued
         K6vfUlo5tYZ372hsgyGfgdRbuyiv9pSsnn7tTiZXrEK3Lsd8CxykD7nDDQDx7r95SNdO
         kGvcDenkEoLbBU2pf+kUz4UPWLNlzAhcGOhX6NVtmxbFgyZQNY4/gLpa45ETuuIyhl58
         ZCL5gnlXqJwB+7wkShoEQ63r29ABnRwNKOaP/JGh68empXbFElP4VTje/unXO1g29tgi
         pEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IQYaS9k5ojuuAez/KlcCMDap25vy0a+Fzv+USTDn99U=;
        b=i1Mu32ca8NtjNVfblkkDyiiUwwH0HO58iYnML2RuFpRHyUCZpuYXxIxM9BzLfjgQaz
         1Jdg0ViJvMe5fL3euAXHyIVPH2JRAJpjJrMEHiNvwLC6sw08kRGXf8T35aFxc7+rENVm
         Q5ZJBBS6ibT75cMirz1riNe7poYLO/ub94a9TrRYrxkov7pcDt498ab1jcSYHJ3t7KKs
         xYbl2ySZsWaolc3jSG8apivXLVtC36pqu3alb1DCyUntnqOQLyC/w+ceuMFA9HLU7851
         podBSY/nGUrJCSzCAHoSRmmSaWljAxempN+LTsTE+N54ww70R/FkDzQIwetn/GE9Bev1
         yaLg==
X-Gm-Message-State: AJIora82rqOhKZB7lOAl53KLkXFg4GtdO1wWWpBUJsaH3l0/zJC2CkXw
        0/FNnw2c+tKBzQSgdq7Anpw=
X-Google-Smtp-Source: AGRyM1vcvr5UFFx0SqGohZovZlt1Wg+FldYoEgrWgQRCQ+x7RP2JfD8lZaMRkmpoqK1vnKWWcdFNsg==
X-Received: by 2002:a17:902:cf11:b0:16b:e1a5:aee with SMTP id i17-20020a170902cf1100b0016be1a50aeemr4377856plg.132.1657736659471;
        Wed, 13 Jul 2022 11:24:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170902d48500b001638a171558sm9151471plg.202.2022.07.13.11.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 11:24:18 -0700 (PDT)
Message-ID: <d7c01069-0b6a-447b-442a-b911a6375156@gmail.com>
Date:   Wed, 13 Jul 2022 11:24:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 000/131] 5.10.131-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220713094820.698453505@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220713094820.698453505@linuxfoundation.org>
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

On 7/13/22 06:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 Jul 2022 09:47:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.131-rc2.gz
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
