Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1F33545D7
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbhDERIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbhDERIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:08:49 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24D3C061756;
        Mon,  5 Apr 2021 10:08:41 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ep1-20020a17090ae641b029014d48811e37so919818pjb.4;
        Mon, 05 Apr 2021 10:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dDHnbiN26ezyuPoLSOb/efAjTnN4ef3DWAtpWgT1llo=;
        b=fj4KopJZSxt/M8KSoKgeaKpQ9c0T2CXRmh7UaZahkPzkjPb5QeO3GMOFohPwRJw8EK
         TxOko5A+FuYEPlZM8bF9qOGpl4I+oS/T37lYoItTBktM0Ga73GTOomr1LA2tbzyH6eqw
         jeS5uJlQ7pMp5f/VmnW4iLjYsXuVs2lvcCSLkK1nPRXpViPk2zIFyoQpht/vHF+RK1rx
         ibfj4SVqQJ8PL6/dfYwc9ufUz/yWhICqXTIqdG8ZfOAvLwNc6aXv9B1Lf7XquuJPyALj
         /2cNFjapQpcFjA/aGbNu+yRKnzjexuN0+mWO7yK1VOxaesWYBv7RLHtv0TSMX76wGBIu
         wwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dDHnbiN26ezyuPoLSOb/efAjTnN4ef3DWAtpWgT1llo=;
        b=ATLCCgKy158QnSkXq5IXQLziHVUJeB2CvLFKrX3s/7mQyFdRpVo0L5uMEHkaOUoNpD
         G1ykOrQ+gaD2lJ0ZXUau12Osupz/ADPtmhvEYNXAkY59sBtBzoiaSBBIOLjLeIpSVod5
         cAvqmOG1gdSpXzEb01VhZeQD786sFD6So93HxuFRP85AYkvVfczZ9R2bRkOq3JQ04y0V
         1WQenKhT86jZyT8ZlNHYWr8dKE/8uxMU80Tn+I7ZT1nzeRV1t+mKdIGNeXn53ukxbeCN
         xK8FysIJO+dWn/hOtAqaEYmV9mE1dVKXFzzAGdNGIaFFZMdxfaWxPnBKR/sLRDu4UnRT
         Hxzg==
X-Gm-Message-State: AOAM532Be6DMVnxc0ndE74lvszqs/DU6jowx0HGDgo6/3ToPvYCtHMjN
        Gt84kpgsCFg1JhB9/DYVZn19C6NHCPg=
X-Google-Smtp-Source: ABdhPJxo6+0RBSeLC0XOmdJT4yvG3fYnbLSyr6ACAr9c0j5lmr5jczxvTDRfEkzZJ7EYWfXI4+kVqQ==
X-Received: by 2002:a17:902:8218:b029:e6:190e:48e with SMTP id x24-20020a1709028218b02900e6190e048emr25037780pln.33.1617642520784;
        Mon, 05 Apr 2021 10:08:40 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l10sm15571677pfc.125.2021.04.05.10.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 10:08:40 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/126] 5.10.28-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210405085031.040238881@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <86ccfb88-5753-519a-117c-029e88e893d7@gmail.com>
Date:   Mon, 5 Apr 2021 10:08:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/5/2021 1:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.28 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.28-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
