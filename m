Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD6262395D
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 02:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbiKJB4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 20:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiKJB4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 20:56:19 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6472A940
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 17:55:57 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id r2so364002ilg.8
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 17:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7DeNYIUBWTywG/gDOlDG5B77j0lwFlK62VoqsKy0P/s=;
        b=YzC5pl2/YElPt/nUcBH5Pbu91V4MS+zBf2si4gSI/KzE/Vn8UIP8mCCpqrEULGhPAz
         WDfp+yLTPMQyNDZQA63T0ZDgaTpNpFj2hxQmQ8thhvR+XBzHXJlLiC+y4d8TPlwR9Sq0
         XiYcYoT6a+PgvkIKwAAWn8qVpdxXE1VvVigYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7DeNYIUBWTywG/gDOlDG5B77j0lwFlK62VoqsKy0P/s=;
        b=a9xlmbhYg3AibXpvqOrtv0HEsPn5CuM6WKcv4ibmSIn9qEEwQWdXQXb6cN02usKUTe
         l+lOwm6zbNZXAMYm+HcW1lwr9pbBh+LvFgu6i5lO+IQFg/D5jvuolmhHMqfRk1Qzh63w
         7gRwS7mhbTOO5UaP6bs2oHxtpFLzAxx9dnBg+LX2dYYRISE/u8P4XzGG6M9R8+9vB9nx
         UTGbh2WBgi+l3t7OwR2pqipdrYf+p+ffMbIXwxoUA2WSGflQPKfKSAYLCar16o5VsjB3
         h6i2wMhako1F+zvVtwZv1EIu3AOePGYAAOY4NEjfIEN1lpCPvkAXNlyUM6ULf1VquwnT
         ljaw==
X-Gm-Message-State: ACrzQf0UAlo4Zf/lSF1jFpSzivz2Hak5+nv0svHUrcAy04cx0qsdRyAD
        Xzdfj5blR5MBmqi2aD8EEM+hYQ==
X-Google-Smtp-Source: AMsMyM7fmqkJeiOtkQvq3BG/4R7lEavjiOcezpN8LETzccWoghHLFNxwWwOFZtHp30LZW14wF3ymPA==
X-Received: by 2002:a92:c910:0:b0:300:bfb8:65fa with SMTP id t16-20020a92c910000000b00300bfb865famr25830028ilp.276.1668045342797;
        Wed, 09 Nov 2022 17:55:42 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b7-20020a02a587000000b00374cd28d842sm5369180jam.104.2022.11.09.17.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:55:42 -0800 (PST)
Message-ID: <43495c69-8110-0e51-3cbb-2f96c7d41c08@linuxfoundation.org>
Date:   Wed, 9 Nov 2022 18:55:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 00/74] 5.4.224-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/22 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.224 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.224-rc1.gz
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
