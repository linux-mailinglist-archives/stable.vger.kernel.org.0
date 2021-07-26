Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BA83D684C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 22:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhGZUMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 16:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhGZUMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 16:12:20 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49676C061757;
        Mon, 26 Jul 2021 13:52:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c16so7587362plh.7;
        Mon, 26 Jul 2021 13:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sc951ASfu1oxq/560DhQUbxoK+Q3x0g+kN6389VJpvk=;
        b=X543/zH07v/0ssv16vK/oSEYZ8inVOgEM+phljgxuXMEgvNO1ZyZIzng11w9b+WZ7+
         9KPPSz7594g+D1bgRuJGy0DIxgasGoB1lRvfpVponWTECkwVRqNY/NJhDSduJQu7kZdr
         238AyfZspdcQq0ufUbJHIGI9qI8n+OzXXCGSpVpqQ6Pz3ulgR3JMjS2WGPxCzrQSUJM0
         Xxgdpv6x1y1AR7VcrvdnzshGocWLXUurhSvULUXyuyhxbJeQn1ofK1vWdY62RYZ8U8o2
         hYMtmf5E5TkgSpwKOYWaQrS51Wt9iBvRUJw8mft6XXxb4Nb8bHEDXuKpk7/ZJlSK9vlv
         pT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sc951ASfu1oxq/560DhQUbxoK+Q3x0g+kN6389VJpvk=;
        b=Nsrj5zhsvb18PNzhuTJXpIh0i1Emb0LJTKDwPePN30LTfSSvgf8+f3Wu6oMkq+pX4g
         o+yewAhJCH/57wDqNtVOzFyq0PlTAxAL5k+64DDlNzFJ+MWxE/MsZ5awFnio3m5Yx0y/
         OPZ4ibSGMUR0s9HhmPhGDQ6fHo/qBr0rLS/v9l/9dr8QARePvNdX5a8GR6fmEuJgzkfi
         U71JJ8wxAQRZwKrWoUTDXR0ZWzFrsAdEwsE6Su+Vm/JlqUHdvgBuck9i2e5zkz5bs5rh
         RSq0jC+EOeijhUSMw3AKidJifY3xWnFyq0fnZqTxaWM/riNAiBaXQ8qXFfscx5dQX64m
         c68Q==
X-Gm-Message-State: AOAM533b+3KHs2HCtOb5jwxRQu7hRE19bZwTzsiN2XxzACsyexi6aoQA
        kOsoYvrju3WWrORUPiJHsPvNLdM08g8=
X-Google-Smtp-Source: ABdhPJylABnDgnNYPWC/m9X+LqMZ1ejiMY+mBL6yIdoMLGVHhs+BUujNvC5jOrsEQl6RUXs0cg24wg==
X-Received: by 2002:a17:902:830b:b029:12a:dd1b:74bf with SMTP id bd11-20020a170902830bb029012add1b74bfmr15886309plb.44.1627332767335;
        Mon, 26 Jul 2021 13:52:47 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k1sm750465pga.70.2021.07.26.13.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 13:52:46 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/60] 4.9.277-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210726153824.868160836@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <849f5079-9f9e-6413-39da-4cfccddd66bc@gmail.com>
Date:   Mon, 26 Jul 2021 13:52:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 8:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.277 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.277-rc1.gz
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
