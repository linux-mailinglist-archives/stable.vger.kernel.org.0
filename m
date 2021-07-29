Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683083DB014
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 01:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhG2X74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 19:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbhG2X7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 19:59:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B41C0613CF;
        Thu, 29 Jul 2021 16:59:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so18203358pjb.0;
        Thu, 29 Jul 2021 16:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JlxS3T0DwUa4mptnycUnVH7bQaMOBwE1cnaubCwbXtY=;
        b=BVmMiwJBcnvh+LsCYe4hcbQyiZHaLFylDnigDlab2EsA5l6H4SVX0trfdsbYMri1Iz
         /2X4s2Zv0ZiiHZhdw961EULM4nvwFucu5VdKBGgOCLlmydJAEVJpmd9SgskQh5j4j27E
         DMNNjHSWcGq6yq6JYOTGoLSdq7uSYe/9NaxH++hHSPKFzGsMR3fgaZm6RyMI+KXKanBr
         YKQ7tsYS22odCKw6GR/PCHkz9moRCfN/oFOi/e8L1cTEOG6snDd5boS3qyK1ztH967RG
         N8Nbgsuq9KlC8mhOs6VPKVhB/ZaVTVFO41ym5azYNUMaDLUc69WKVK7yC+wTvNmurXLE
         L3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JlxS3T0DwUa4mptnycUnVH7bQaMOBwE1cnaubCwbXtY=;
        b=WXuaEHgd6guopv7z7GFlipnAh0FEaYPf7aTna+0/9z8WuIpqxWB/Ly9aEHbutVK5A7
         8PvROHaEkVQvbqnyFRMbOdEPtaqF5C6gJORsBIw9oiLU2IFsaCJrdCt9Y6FJXdMGSMxf
         ok5x7cHTVipCjTnmtuJLr3rbkwkHgQrijLTyxN4iK27DERN4FCqv+ry5CdoXq+/WuAlA
         mnxIA7u5keMqi9dP3Tn33spyMNU0a678eI7ZugX2YncpciIGtDo51T1Li9roIibwdp//
         YunWhQ2+iZ26ISb4HbZudhnHeH2p1CLZc1TSH0Tqkzi1/oiX9zsB1SjGHXgHbPRthjcJ
         5G6g==
X-Gm-Message-State: AOAM530ePL9mqwwaP88Y23bNTjOuyXSrF3Vg48uJLb4K5FgKaD9gNZ1q
        1ymQ88fTLu5XH+a8KNLnA8+Bl7khb4I=
X-Google-Smtp-Source: ABdhPJzKBGSKeDbr8fcqH82L81rsbkJnnGAdgZne6emak4Me+mBd8Jc7kYbpoKMgQwju2MttmOjEwQ==
X-Received: by 2002:a63:f961:: with SMTP id q33mr4013585pgk.82.1627603189583;
        Thu, 29 Jul 2021 16:59:49 -0700 (PDT)
Received: from [10.67.49.140] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u3sm1943pjn.18.2021.07.29.16.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 16:59:49 -0700 (PDT)
Subject: Re: [PATCH 5.13 00/22] 5.13.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210729135137.336097792@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <899a57cd-f473-668f-09d9-a71de9ee51b4@gmail.com>
Date:   Thu, 29 Jul 2021 16:59:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/21 6:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.7 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
