Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A00143A45C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 22:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbhJYUW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237648AbhJYUWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 16:22:52 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515C2C0C02BA;
        Mon, 25 Oct 2021 12:55:57 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d5so11855995pfu.1;
        Mon, 25 Oct 2021 12:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=igjma0tV9/jk5OBN/hmjoQ1LiZBH4AJdgLhqkgHidAw=;
        b=nqOngVKJMjSYJgPtiIsrUsVpWrv6tZJtRSsERDIqiWQBmRhWsEesZfEPZm8s++DNnD
         DDV/iL20MOzO1Z+nTuLU2woZgca42ZYOZwXYQknzaBz11GNrJsFww+lKfmIzCzzRR44L
         7m6zY8CeoQtH7/7DM0rBqN8ZMq56rdYKx+E10GlhlJvSXz7efamAvIovX9lH77jUQSzh
         f3mZw1WW+u35mMp1bZ9vAjhI8NBxEItyX/rjrHKRPBeYk4VYKw/v9rIOHNGx06intmX6
         rLLNM8WNHCkRnmZ8FX8bwCxXr1jR5LXMrzhNRqWW8T3cNOiey1L762L31HQgdoeDRp6N
         ilbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=igjma0tV9/jk5OBN/hmjoQ1LiZBH4AJdgLhqkgHidAw=;
        b=iNGA85KLBe/p0d8GByWf+Cd/+jr1Ty+kMGT02c6a7P0A1J09P7zPUDPsGQT0zHQp8i
         O9WFOPEpzsFduilJi1zFT3LgX5aZYUd93YIIiJCdKtm2rbHUwN5VCKXagNoRhD2zz7/t
         nSILCto7QibivkTt6i6UBBmeqAQgkIClg/CqCShiOaqlB0Ut6NtKU9nkVZ4GmBfoPj1s
         MqeI6EuKhilB6PwbbTLD+DSDf1gxbdKzuKFhsgCmNYBsxyfDvUDp1yceQCLXdBMLUQFP
         AoUP3P1ZhMoAnIlbuwxi+vTtS/QlQ0hJdBd5heiKp3kAVJHXl93zUN0Ms7kTeUxYzUq9
         QpIQ==
X-Gm-Message-State: AOAM532h2nmiiGP9vU+QtxU2tEY6szy9hNOA9wGRVMyplbNkIDZdvcQu
        D3yI2Zvt1T3XI67E41ZOWbIica4Oowc=
X-Google-Smtp-Source: ABdhPJxVFhkNuFDp0fgTh/KFHiV+2+GRXp1Xn5OaVRTC4u7NTXvttd7zo6KjaZwFxj+lNOgMvUMdIQ==
X-Received: by 2002:a63:8ac7:: with SMTP id y190mr7405939pgd.55.1635191756393;
        Mon, 25 Oct 2021 12:55:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w12sm7821819pjq.2.2021.10.25.12.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 12:55:55 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/58] 5.4.156-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211025190937.555108060@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <da2f2fa8-0191-3769-a3b8-d4869be70543@gmail.com>
Date:   Mon, 25 Oct 2021 12:55:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 12:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.156 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.156-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
