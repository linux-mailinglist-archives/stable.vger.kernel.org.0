Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A7365C63A
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbjACS1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238871AbjACS10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:27:26 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F022213F3F;
        Tue,  3 Jan 2023 10:27:13 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id u2so8284992qvo.12;
        Tue, 03 Jan 2023 10:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DPjL2DQSLlszqw4OiVvbsdD+JxAFXBGfR8THZOT0Qic=;
        b=nRUxmkVmBZP9/mQBq8rGwpgfeNsx/BibdY+eDd+QVg8C87tH24tMxOgIM4YK1UvVoq
         hFMe9m75SK5LJIxUJn/JgbRt41A0mBBUBrfqOZMsoOYvXlJBSQbzypPHJpWT7lNmiYyp
         VTzHuTN8R/ZEX1Ih1ImwJ0JkP1ERvWO/20NyHpGA7oMPkplybv6gNpCYzhVybiLcXp16
         gU1MZYK5w3vyW1uusn/boLxuq4zcHL1J4H9ZQdsMstiryZSwwvqPxJ/MH6iLp4bk5fCh
         1bld3qNaXhrjT757mim6vtiuWGOmM4fUNExOjzuAAoDhsJ+tL+ol6iYQC8vinz7hXxM7
         jk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPjL2DQSLlszqw4OiVvbsdD+JxAFXBGfR8THZOT0Qic=;
        b=4rK/X4sThdRZdJco11gAXTuwc0oGJh6iG9vVQ7P1L7nq3ktK2o8Xif9aqPooaVt9uF
         TN5z+/FmDrjGLF5LSuGSqy2NUOXSJDFxoYtN0kz/cFfq4F50kAMpZbUrpmbX7YEPLeKZ
         IwCuDGiWf9u8/WntwjNTqIfbRWGsnHpnsZwzinQHc1uxFjvCJN2VtVMmfMVdZmdIZ/WN
         K9Gdjk6BmIA+pIZDP7j43DRul41qK+SJjXvRx/1hXDnLP1duE8nlId7OqyAq3cH5qLHJ
         llCdDS4B6t0vnUlBzQVJxoUuX555N0TuwgpHj0oKsjMlpxJAa4TSDF/BefBlx/AhNlXT
         S0qw==
X-Gm-Message-State: AFqh2ko334/CKBkyuFObBUArQ9TTYWjLJEv0PKMXkpy7APmIMKb4xBr/
        NyT+c9ysUfB2ORc3Bir8xWM=
X-Google-Smtp-Source: AMrXdXszGK+QQ4gGy4N/pb22uhf2admBnpdD3b4j7xxC/55IaUnuPnAYy0JxYU//O3wCC+z9YYuAjA==
X-Received: by 2002:a05:6214:390a:b0:4bc:176f:a50d with SMTP id nh10-20020a056214390a00b004bc176fa50dmr66266818qvb.3.1672770432433;
        Tue, 03 Jan 2023 10:27:12 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pj8-20020a05620a1d8800b006cfc7f9eea0sm22142411qkn.122.2023.01.03.10.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 10:27:11 -0800 (PST)
Message-ID: <581e7c54-d10a-23d6-96ca-f6ec6a4326e3@gmail.com>
Date:   Tue, 3 Jan 2023 10:27:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230103081308.548338576@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/3/23 00:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.162 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.162-rc1.gz
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

