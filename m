Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC66572BD6
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 05:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiGMDTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 23:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiGMDTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 23:19:36 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94DBBF570
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:19:35 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z81so9820398iof.0
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1eLEJlOtG9KDwrHqZMuZJnRsBN4uQ/6Hx8l2S7ajiUg=;
        b=Yv3XjFfzzM9vni58Ze7ocZj80xYgzEk5xzjob1DPRyoeZ6u2xuu2xJ9Wf/z3JPoQ2l
         NJOzP8JYJu8Xq42nnv2M/TexPweAR34G8WTPC/UCCDKvRwjoC+C+iKu9uW93bis5zmnh
         RJzcsg4qpTTnpm2X2BU0VnC9QmWgWwOjUFVrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1eLEJlOtG9KDwrHqZMuZJnRsBN4uQ/6Hx8l2S7ajiUg=;
        b=2ZsApGjb5xiACozAsnuujLkg22jShmS6B/yVL6N+A4OE/sfjsNvHfuFQWIHAOTocIf
         81hBuDSFi+jw8ng2NoSaF+ikmqe9Tsnt9x7V/4GYEX2Q3lKNSkr3RqRfvTYMXhWMTKSg
         pu76KmKm5gNt7bJ+sgRUJ4ej6lZWMU/c6BJvm5PngcSTXwEY5JHVACShSGha3AGXtL3j
         /iyhNdy/vA8OgQz2X7QJjebERS10/j9GKDuwfhq4Mq9ojdKUdIGV3VKJsLsdFe4dgIDy
         +p1Urhbe8Vb9i4kTxK+ttsJ8bsK1Zgife76jYoPjtnCgieCI8oRJFuRW8EDKWGcdToj7
         fdEA==
X-Gm-Message-State: AJIora9/+MevxfzrM3oZaPnJp+w7UufyQeYg1ozksmgKBuxqHn5jkOX0
        7Qr2tOF1LRuDVCULMQ4tRdIH+Q==
X-Google-Smtp-Source: AGRyM1taQI8gfcG/cXmeOHsvPhurjL7ZCB23pZeT2DgjIYEJuXrwApj4ozHnxbbtCvrIWvXpjeaOZA==
X-Received: by 2002:a05:6602:29d0:b0:669:1723:c249 with SMTP id z16-20020a05660229d000b006691723c249mr861850ioq.208.1657682375173;
        Tue, 12 Jul 2022 20:19:35 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s14-20020a5d9a0e000000b006751347e61bsm5701831iol.27.2022.07.12.20.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 20:19:34 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <48416b47-80b8-3643-be4e-00b66367dd68@linuxfoundation.org>
Date:   Tue, 12 Jul 2022 21:19:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/22 12:38 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.55 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.55-rc1.gz
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
