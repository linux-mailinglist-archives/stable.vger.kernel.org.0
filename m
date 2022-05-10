Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77512522702
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 00:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiEJWmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 18:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbiEJWmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 18:42:43 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFF515BAD1
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:42:42 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id n24so662816oie.12
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7+KltJ7F34G8/AC3DOb6MTBB54rI+MST/Cj23S11o1s=;
        b=VLkccRon0Voxtemyy/FjFAx3KJOGoO7ZbHUYWXLISlf/SQJ0qKeJn7oEt0R4MwbM3P
         IUYO4hhLTjfodZMeR1J+xhUDoP2dqEz7wU/lnZrDSOjAMqGI+E5IVtQ8BFETiHrZQgA7
         lkrr88h66LQoyI0bgtpMusBqHx08GHzPIt/RI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7+KltJ7F34G8/AC3DOb6MTBB54rI+MST/Cj23S11o1s=;
        b=XkqDFoQNjAoHNb5lXgFvFuZnTja9KEY+y0el0n01yON8c3/Znj3TLJkz3z4BvMbYAs
         1VZo5BWFBTpOLal9K7yuarm/skObZuL3jTWmzJggrIN85+MB1tObsNg9IQSlfO8HQWta
         CFbMuynCcw7SvsKdCq+FALjTVhn/ndNkYuAWwO8SMkT8vrKPwuqHmqyWVlQQt66hfken
         e7P+Nt2QY6ffEixWOSY6FlyhmZLij79unrkWyVzIHCLBybpouhwCenxWJcAxylNV3oBK
         /wxZnpiXNg97hvFxRYZN27sDgcffPbGz5jf0wzbiu3Ia2zTFNkZI4iFNhR1CJumeM/Df
         UyMQ==
X-Gm-Message-State: AOAM533kKDlYdDrA6VMWapcwaC+C0Xm8m0gh9EYz61ubldr+7vQpoiJN
        szd0cbrnshZyNyzxu5r4XQDwCw==
X-Google-Smtp-Source: ABdhPJxb47ZCpyuPF1hbvN0++QLW6/mvOLD6412jYUK9qcSIHRUtxj9eOIrb3wzeSz3wb5XKRcKHlA==
X-Received: by 2002:a05:6808:ecc:b0:322:319c:cd3 with SMTP id q12-20020a0568080ecc00b00322319c0cd3mr1166653oiv.148.1652222561778;
        Tue, 10 May 2022 15:42:41 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u4-20020a4a9704000000b0035eb4e5a6b5sm308288ooi.11.2022.05.10.15.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 15:42:41 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/135] 5.15.39-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0e6f63a4-6070-805b-40e3-3198f960e7cd@linuxfoundation.org>
Date:   Tue, 10 May 2022 16:42:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/22 7:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.39 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

