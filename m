Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62757558947
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiFWTkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiFWTka (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:40:30 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EB87E00B;
        Thu, 23 Jun 2022 12:30:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o18so128467plg.2;
        Thu, 23 Jun 2022 12:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8BA2ydSLM+gEUBcVXdP2fqlOhTJGtm6qnmU9rgH3Z88=;
        b=qBy8lMAA9ufkyVDostGeyLiH8YzqTOMW/icfM3xLt9I9VsE9nJzDLoJvmjxSHTgwnG
         HKOYE82rVGPZBaGO5CBcPe3yx5/sYCDKHC80YRLB1x8IUiYBjqo1nVeq5NFKR4AfyhAo
         ttCOGEQUSkA9TKJ92HOvqpLN6jWgKIc+nQvI4KpH902ZYsid50Wq89GeCgaHKZLpMULZ
         f+iNJjUi/M0X2cLRs7N0RfWTJkMjWf1YjD7kx2yj1lO884XLMyCwXsBvARv7swd5fWmo
         +Kj+vxVegCUeAwEIi8cBpYH9e7dOc6D7a8ksDtjIqedb4jXjGwBPzjGm2QdwRFdMEikv
         TKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8BA2ydSLM+gEUBcVXdP2fqlOhTJGtm6qnmU9rgH3Z88=;
        b=RmHD8Rl/E04Y7JEHI67hQv8/UERZ7yPTW/2gw0DIuq0Jkx99CcijHkC/fIkmv59tuk
         6QF2qAKjzdPVn0Wfp1sVLpJZ+LMfmjOobY6i3ewKsY0eKUoLxRGy6LeJM+D/8gTKSNnt
         kw2MyA/muPn8+5cQz0fwPrmCLRDKal3IdwUB46UKKClEhEzrvKhDnC+2AGtmMpUuv9QV
         /q8gjBQwT6MIAl5T+HM+sc/IHD7Sg154v9RHEpiP97fyjLHSOMt4F5b1SJpJyeIFzugV
         OaYzj/ibP+JQzOFOYDpaRQkKEp0ff+JioV15lGrx8Ft2Pw1/3IGC4izpZFWc17FB0FY8
         kYJQ==
X-Gm-Message-State: AJIora8b0D79xJMLI6wzqM3+7WVY9mijyil4PqvtAVUmyXsVRAHqloSu
        2gErcarESx7aNEyw4nCPeJg=
X-Google-Smtp-Source: AGRyM1vMXWAoD1S5qmkfhnlDvVuIk7fMK/NFwCat9tHO+3GbdtgdImdWzupc3HQQ9CxipDAeHOX4cA==
X-Received: by 2002:a17:90b:4b0e:b0:1ed:196d:b691 with SMTP id lx14-20020a17090b4b0e00b001ed196db691mr2120333pjb.78.1656012616545;
        Thu, 23 Jun 2022 12:30:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w7-20020a63af07000000b0040caab35e5bsm9566886pge.89.2022.06.23.12.30.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 12:30:15 -0700 (PDT)
Message-ID: <41cc84ce-5f64-8b83-7d99-2a0564a6d99d@gmail.com>
Date:   Thu, 23 Jun 2022 12:30:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.9 000/264] 4.9.320-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220623164344.053938039@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
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

On 6/23/22 09:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.320 release.
> There are 264 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.320-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
