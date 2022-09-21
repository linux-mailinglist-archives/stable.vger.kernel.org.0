Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1527F5E5667
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 00:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiIUWzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 18:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIUWzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 18:55:41 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C519788DD3
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:55:40 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e205so6364403iof.1
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Oo5ba8VF0i4/ApVVKpEPzYH8kkUr0H2xAd6tR372RjU=;
        b=Y7KcWfpeFeKCHzBbHesKewEj3VKu5oTMrH5RgNQLibp5jqJ1e5A0rrgEwKxu46EWV4
         qSrgF8SCytwrAlULLrhOV81XH9mM1IRKQJD0Welqs4YtbLGVP5lXj46XjNXjMZcMjS7Z
         HoduvhcADmnXV+7hcjXmpzvvPnMa9FyNAAoeY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Oo5ba8VF0i4/ApVVKpEPzYH8kkUr0H2xAd6tR372RjU=;
        b=pR9hkG7nLPSdkG2NAlTaPpL2p36liEtfXO+Rzz4w8tgMlONunk5Z8fILqiesn5KAKP
         1HoYQUfYPtBX6YbTdqUzq/3PLUqS/0EsJbjzLmfASi979GqEzRCReadFQ/+KCaM7MvYr
         Wx5HZWSICedmV50yPWRvF+Ax5XgLzQRodCAGrpeXfIvgMcqGJZSvhTLcKG9+Ql1WlcqG
         8GEWJbkWKrswdlVyrCe8gYOV263TpbD3pExIg85ohnpePtN0XHWDQOVmenw2oWq4M1Ml
         53SYdOVpQbs67OQ42iKeHnwUTTxdw5DUPivPlaOCm9K0nrOsDfAMS5WUIAh2jWpr8xRa
         Vp+w==
X-Gm-Message-State: ACrzQf2ueoQ8fW1CuW9BakyGMWjkvvZgt3ABINnD10imFA2rh4MMKXjo
        T+lu3iaziegCZnW+0m49mRH5TQ==
X-Google-Smtp-Source: AMsMyM7gszfi3xajP9K3eqCcIEqbH7dT9z/6v5yYknusbkgQBkbYJuTm1Rg+xItjMQ67MXirgycXZA==
X-Received: by 2002:a05:6638:168a:b0:35a:6acf:f94 with SMTP id f10-20020a056638168a00b0035a6acf0f94mr329273jat.106.1663800940095;
        Wed, 21 Sep 2022 15:55:40 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c69-20020a02964b000000b0035a41631f28sm1491922jai.78.2022.09.21.15.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 15:55:39 -0700 (PDT)
Message-ID: <79ff0f22-df09-ecf0-40b5-18e09a33df30@linuxfoundation.org>
Date:   Wed, 21 Sep 2022 16:55:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/21/22 09:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.70 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.70-rc1.gz
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
