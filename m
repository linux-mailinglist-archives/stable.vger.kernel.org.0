Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C52B6586F3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 22:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiL1VPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 16:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiL1VPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 16:15:05 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BD313EA7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:15:03 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id v70so15772157oie.3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u61catlXVW5wFymBQzKgemYTpBvwIjho7UirvKaMj6s=;
        b=GJn/+f/zSq4Sj1Jy5I7R7pzdtBAYQj/fHvpunvZvo6+d4ZIVzK1RydQT4AkNxsAUqH
         62BtU1qKw8UmOR1rCLQkwd1luBZeeG+xEmJH1un6vgWHAsSOnGOIOIeNr7/LcpKCzNsy
         4vH5KtfRC+FkayOrE7CDm9ViKw81nIwEUl1E/MapYHw31K5enZlwC0hczo54VhHIl+80
         KuHi2ZZl9cSwo2FmsewEBVbCBhmrLeLCdSc2H46hQtIJKj7EtonhPQYY7iWFRLB+o25g
         VFdc5oVOGjmS9qPZm0KY0zKtJ567MiNrJ6KzdCaYEUJuhU8Hai4YjynfnttUUFELW5q1
         Y+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u61catlXVW5wFymBQzKgemYTpBvwIjho7UirvKaMj6s=;
        b=s1wI5c/Wkqwk3D8v2pckKcgGSJwSlB145Uh6dVuqGpupnZnnKJ1w95uqSzXC72a6dJ
         sgSYg3WggZHa0+jdNECAUUA8o7Dex8afL6eBxD3CC+mLKT6rkfgNjVDb6DfRAho4Xclj
         QRYBXDTdeSwZOdnCT8ZZpK2NntLbYQb1ipQ8wWfwMKzpzFCrFutDfjcD/HP+bY1fBKLh
         PD50Jq9Xl9XcFfQMDtnXCDio/GOU3U3+IPIqO5B0sQuGEfX14Dx9RxNf8vycCnRWm2d8
         usO4md/tTwHniIb0NwndFwT8bFf5+ZQ8WmFH5g390DZv4dLTwJU6zP5tqXmz+Eop2/yC
         /rPQ==
X-Gm-Message-State: AFqh2kq+d/SbePA34FnOFEatFghuGpOujZ16bQ5HcRhR7l2O5alCpiZP
        vWfKNgf2Sz5eubr+YU07eX1ZRg==
X-Google-Smtp-Source: AMrXdXvjsN/jTj/sK+n2xZm0y1XctLSMEEFFh1I46UezAZgLU8ZmXZK9DIWXil/6O6GaUT28xYetxQ==
X-Received: by 2002:aca:4009:0:b0:360:ceb6:1f6f with SMTP id n9-20020aca4009000000b00360ceb61f6fmr9928171oia.54.1672262103112;
        Wed, 28 Dec 2022 13:15:03 -0800 (PST)
Received: from [192.168.17.16] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id c17-20020a056808139100b003546fada8f6sm7400869oiw.12.2022.12.28.13.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 13:15:02 -0800 (PST)
Message-ID: <9560136e-d6e9-995a-141a-61dd05a62b8a@linaro.org>
Date:   Wed, 28 Dec 2022 15:15:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221228144330.180012208@linuxfoundation.org>
Content-Language: en-US
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!


On 28/12/22 08:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We're seeing the already reported problem with the unused variable 'rpm', but also seeing this on Arm, i386, MIPS, PA-RISC:

| /builds/linux/drivers/pwm/pwm-tegra.c: In function 'tegra_pwm_config':
| /builds/linux/drivers/pwm/pwm-tegra.c:148:53: error: result of '1000000000 << 8' requires 39 bits to represent, but 'long int' only has 32 bits [-Werror=shift-overflow=]
|    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
|                                                      ^~
| /builds/linux/include/linux/math.h:40:32: note: in definition of macro 'DIV_ROUND_DOWN_ULL'
|   ({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
|                                 ^~
| /builds/linux/drivers/pwm/pwm-tegra.c:148:23: note: in expansion of macro 'DIV_ROUND_UP_ULL'
|    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
|                        ^~~~~~~~~~~~~~~~
| cc1: all warnings being treated as errors

Those are with GCC-8 and allmodconfig.

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

