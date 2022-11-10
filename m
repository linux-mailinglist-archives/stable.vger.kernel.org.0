Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835D2623970
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 03:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiKJCDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 21:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbiKJCCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 21:02:07 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384FA27DF8
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 17:59:38 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id r81so284380iod.2
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 17:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PbW75S+tRPPiGdyoY3SVPUPsbPk7wXUtzpehNZARJL8=;
        b=JlFStz2Zk0UsrmExFMWCby9tveb5FxDaIvBD0LfyI3hofXqZn2f2nFBxZK101BqrCP
         XcOT8QhXuRt7e9pj/59OAiDVHEGlGeECKTo3MmLl31E+OivxAixW9C02zSb5B8GcKcPU
         Mnq7KzhUV+8AHus6x9vyqfPLobuJOt16PODKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PbW75S+tRPPiGdyoY3SVPUPsbPk7wXUtzpehNZARJL8=;
        b=hdEkhWKk5SqWLYlduTh7ak0G2Rwa2OKUJx/P1CD1ys6wRs3D/MPrRo3zYCkOoyH6tL
         +f4wpy4C5NbtGixs6tMZr5ldSqL33NHhG//0BR3wZQd/udJU7u5bW4TakYLUMyGjV9nW
         3sjkL/8LO7Xx0HZV1zNdhf8xbYabJKJEI+bxie7/2aLnHblb7iMjqg32PizK8WIis2YB
         a0xhZYzeyD/Wx7/rFAliUNojobpUkLKR1LLej/nZSRZHv9HIuavvJhiqXo6QTEVK/P3N
         odgolDcB7mh+L+ffhVU5rqWGHV0+eG5xbtvkh+vaF6wssR/Huj5EqfjoGP3cMge70zHI
         piCw==
X-Gm-Message-State: ACrzQf1Aa31y5oLlQNGpVPT682/rB/lKebh9PxKrEMraa4QRnjp06agP
        kfTPNLlwqRdgqfXc/Bqe6+gCdg==
X-Google-Smtp-Source: AMsMyM5c3dycfwbkRls4PsSnfsWYdiHC1WLvxp7ggFmrJlbC3hSbBdKVyjTWwpvjnUyCS003J79Yeg==
X-Received: by 2002:a05:6638:1a8f:b0:375:1ad6:e860 with SMTP id ce15-20020a0566381a8f00b003751ad6e860mr2538742jab.191.1668045577587;
        Wed, 09 Nov 2022 17:59:37 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n2-20020a027102000000b00363ad31c149sm5284887jac.110.2022.11.09.17.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:59:37 -0800 (PST)
Message-ID: <613fefce-632d-be3e-30d4-d1c5a3cf2618@linuxfoundation.org>
Date:   Wed, 9 Nov 2022 18:59:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4.9 00/30] 4.9.333-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/22 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.333 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.333-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
