Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996F43FDFCE
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 18:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245149AbhIAQ0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 12:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhIAQ0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 12:26:12 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D460EC061575;
        Wed,  1 Sep 2021 09:25:15 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d17so1789657plr.12;
        Wed, 01 Sep 2021 09:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oqL6EDzYuXNUvTxvrVzelOftjt/CPMA940sWYCAx/B8=;
        b=RukhJW1ke9rdVijzSf11RPwvnyI69MvAGBt3OPJ2Ll8OoECjPjSi4ySYQMBXOaZtAb
         3NNvGoJBex4bSu6Y+NZLeHMUM6KaDTEIwMB0NRQdt1MXpFttR3Z8zc1V/fV8dRdkgFjn
         j7E+VK0Jkqoa44M1o0hrWp56h42WqBcXXcq+m0StxxaENoBjQp4oH/JmaE1A8etSrtEa
         Hlkj09iUmvGV6jldmifb584HD/9G35qK/bjti6p7UgD2o0aEiw2PNA1YO2fKy97kamXx
         9SASijuJiG0BrgfLGhrkA99QeVLImyCHMsUL79MBFt/Kk0juw6H/AuUxssyJm9Ir5EQ0
         vvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oqL6EDzYuXNUvTxvrVzelOftjt/CPMA940sWYCAx/B8=;
        b=P1fEGwAeni7Kw9UEIKBAD8p5fBAQluqoJ7QZ91mIDeshIC69jbci3W2t7Z6pmyqZlt
         Gn+3gH9r9kGVsGrEwHee+VQDLi4cPZ4mwG3oTPq1d9q0tODPT0ZoU8BycHz6mI0Sj3Hh
         IA9aKt4lRUjZg3jH44nxsHP590Tbtgg79yYDPqhwC3LSLOvaUnVwIBeVc1o4+eUpYokV
         qPmHj8b6YotWBXCHjLBjqVYT8CNuboPLg7tdXW2HJ3AXGFOcAhdJYqclLT0KvIPn19uz
         T2mCojlvjAxIR2d5gkhV3LEVE2NtmoWJC/DBK67OF5ed7kIfpCkCSlWBAi6m7A2hyLbK
         Cx6g==
X-Gm-Message-State: AOAM532sMZ6Mi4g6hkdLn5kdjlXwMU/jvO0bGy+9DXeaUaHnFpsJ0Oua
        v8+F5tafig5BH1rCupLZUj8=
X-Google-Smtp-Source: ABdhPJybduXhbyw6svZ8eOybdj7+PkHjCvWGKcCqJcusNS0beuuvOqdph/hJ0aUJ1IWrTyOyXyUIrw==
X-Received: by 2002:a17:90b:4d0c:: with SMTP id mw12mr201571pjb.123.1630513515170;
        Wed, 01 Sep 2021 09:25:15 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c11sm22463pfm.55.2021.09.01.09.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:25:14 -0700 (PDT)
Message-ID: <b0766dfd-566d-8fe3-d2ef-69cb45911a0a@gmail.com>
Date:   Wed, 1 Sep 2021 09:25:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 5.13 000/113] 5.13.14-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210901122301.984263453@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/1/2021 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.14 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.14-rc1.gz
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
