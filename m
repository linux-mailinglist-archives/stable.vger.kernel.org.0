Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF1B4FEA94
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 01:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiDLXfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 19:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiDLXco (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 19:32:44 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA0EC12EF
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 15:19:38 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id 9so23915658iou.5
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 15:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QYfke9cQ37ascPzVzI8WQsr0KDmS2lmrJZHbSR7rmzc=;
        b=CJcyS7cB4IV4VT9pHwMg4WD5hVcCmgTMeqpnKGqQMzmnllLkKGWOoKAalQb+2+5HEP
         oFRGPD4/AJEJ0hrwmR+2AL2srBfRrlq9uIh7cjBkn4uOHfs+rBxMSqdatLOaJQ/KeCG+
         lS7hZJnEbIfOv+V+ztyiX6Uf8ytIqsz5TW8X0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QYfke9cQ37ascPzVzI8WQsr0KDmS2lmrJZHbSR7rmzc=;
        b=1lgAzYbe85AMxUR7nEL2BLCr0Gpqyawd33jtMyi36Q+Q9ykqwo4m7nVEHY5MtwhGWu
         l6L9yzWJ/aXzfzM5hKQwkZzyCPWn+fmb72VqTA/YKGmcmk+k/2F/nFhqp4buQGipcpEI
         azxhHRtrq01MCvg4kpkW0EWpPdH1GtcglM5u0deX0UVsILS1CpBx79CPhJpEuHo7swoG
         l8ZVJAspG3PLMy+XRRSYimyyKC4BOuOuTFX56D5u6DM5GpLR1ULzc5F3OGbcHnemMTXZ
         j1kg+Gu6uiz9IkVEbt5GH0u/k4d0OlsGFZsW2bJ93wh8BKieWO0W0z+WZIjOwEr7035n
         E4Iw==
X-Gm-Message-State: AOAM5332FyRJl4POFBDzdC9hsPu1Qu14U6U88aeDfc+zpnHgy2bNwQzw
        w9A2mgZyEzN27tLtTgeoOk8rWw==
X-Google-Smtp-Source: ABdhPJxaiPnXmbQxtgSjy5SJs+0QkjEymVY455S1XO+9MvSqdxQuJLaq4dY4gqricFC0yjkcJ/ydzw==
X-Received: by 2002:a5e:aa0b:0:b0:649:4cff:38e3 with SMTP id s11-20020a5eaa0b000000b006494cff38e3mr16663892ioe.78.1649801977839;
        Tue, 12 Apr 2022 15:19:37 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id m6-20020a923f06000000b002ca74f4fab2sm10764983ila.14.2022.04.12.15.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 15:19:37 -0700 (PDT)
Subject: Re: [PATCH 5.17 000/343] 5.17.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8ef71886-028a-8ae3-aaf8-9110e0535163@linuxfoundation.org>
Date:   Tue, 12 Apr 2022 16:19:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/22 12:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.3 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
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
