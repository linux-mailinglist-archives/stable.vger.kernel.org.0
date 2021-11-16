Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F22C453A6C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240166AbhKPTws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhKPTwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 14:52:47 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24571C061570;
        Tue, 16 Nov 2021 11:49:50 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id n85so363586pfd.10;
        Tue, 16 Nov 2021 11:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kv3IYPiX5SnYfnO5a8CoHQzGWqarVJmmBtF2EGunec4=;
        b=k5zq7Qiwv0sVC50+hDQiqrw4Tbz2EWbNn2UkoGAK1kGG3XGGOvaN5FNSSvKe0pot2H
         7mH2K4F8xYJJBcDOr8MWaBkwrE02YMFngxvZDW+1eDLGjlLCKl1ogvGFdmW4EeqsGIsN
         9bAzF6SxpuHWFq9F/0nXxVkBcU7+IQiLj9HJqCchOses3LeI/tYBs7qEstaFGYDCaFCx
         AGN2vxRNC9jUirj1Yj1CulD9XKSZ7Cm7YJ2OPRZL3Ln7SIfRFjE/4VIDTuJFz/5NG9+h
         OxtPD0Zda046oicqBpXgMwmZZBU2VIJIU6TC1+dtT2GzGw0K+dBNX4f94HmBZsWtDUMk
         5Z9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kv3IYPiX5SnYfnO5a8CoHQzGWqarVJmmBtF2EGunec4=;
        b=N+YIepe5yDobTBXHEoEzcjCbaAyqCOOPfQ2m3H2o15hLTCiFKGG/HIdSTAFC26euVo
         kLAmlBzMoGPTzztpnDAy7W7pFPPyCUJXlmOmpfzbGCqcDpHf1dvZd1iDy9V3LxnWOJ2r
         uga7nqQD00t8+WmRqA0yXxgDJ7fZWfAYLgX2/5a3bTiPDyxKWQqmzBpEItx9hxbz7X6S
         XeAfm+MB3YGYHAQ5GF80zHH5ziCmpcrk1Q+Bwitlkz1jr9+y25DZ0CLztfGPMK0czpGr
         6iKAnXKAuGAa6GRbgIQqfJKEJFWV0QulHeg+b4YHHcExQzdxu9UfTHXB0Vx2fSQ0k9bK
         7sCg==
X-Gm-Message-State: AOAM531YEqRvZ/LVkabjKdZKxFghu8lMY7jFa14TJ5kc1tujP7sgAN5r
        oZckHAG3l3m1BRLxFc7qG3nnpBFbxSM=
X-Google-Smtp-Source: ABdhPJz/299ps5UDV4MwfXmvLFU8iVY0AeCO9Q1Tw5i26ajanZMCI++YiOR+pVK5FZgrFAsPSrpb3A==
X-Received: by 2002:aa7:888d:0:b0:47c:128b:ee57 with SMTP id z13-20020aa7888d000000b0047c128bee57mr1601114pfe.81.1637092189307;
        Tue, 16 Nov 2021 11:49:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id rj8sm3375066pjb.0.2021.11.16.11.49.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 11:49:48 -0800 (PST)
Subject: Re: [PATCH 5.10 000/578] 5.10.80-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211116142545.607076484@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <63702e31-15eb-6c5e-7f9b-96617afefbdb@gmail.com>
Date:   Tue, 16 Nov 2021 11:49:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211116142545.607076484@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 7:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
