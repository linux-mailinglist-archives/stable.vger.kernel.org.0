Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ED249BAC9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386723AbiAYR5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385292AbiAYRzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:55:44 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B038C061755;
        Tue, 25 Jan 2022 09:55:39 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so2558973pjt.5;
        Tue, 25 Jan 2022 09:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FlyqvnB08PGLUJ0pfNpu3bey0wCWbKYNhle+NC/06i0=;
        b=WWS4Oc2+3vCEccHKrSF1nkQilE/IrVAKMqGKx3np7yRXsM555tdBVwe0Bd8OMjAO0X
         KCxz5KM+qUW+GW+qyBDQ2OfTU347UD8MRWOdDo8SPtVYFe1KEuw/JFEVvoDL4or3RjE/
         ueqV0zH8gDHZdvfK1fJSgReNU6X3GHov+6u8xOW6zQuKRCXEVu7fBfNiqfcAWbYdi2/S
         3LuuxpXvXInKPI8y8Ocuw4UKJcFC49G7Yp5AeR/AETkeWYpw74ojevwnnO5iiLPkYQPp
         dFOz/ejadQjXvShf+RrrwdIvfrBZoqt1xnHhLGfgv9TwT0F47BbyPY+prbbySEZimkee
         Rpeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FlyqvnB08PGLUJ0pfNpu3bey0wCWbKYNhle+NC/06i0=;
        b=Lj8G8ovGPrsXCF84PGKVkbxd5uGaUI2fXIZT5cOwAUE+dgwEAhXBQ1duCKV5F3F6wF
         q7JGyOIc05cbREOPkKxa/wbqlEmVb4krtkhangXgQP6SPr203lHYa2UifnEBipLZbZq5
         W693zVdu2H17YRswBy6xnnyYc63ZihtRFjCmxffYbhxQACLXFcPIpcKJAETGXTR/B8Bw
         FPpxDFy3BLFUJvcE7tD8N9rTM+Qopkn9Sl+mcGSiaKdgPvSSZtjGeQTrAa2RpFhN3ihj
         wSvymzeMklTKfqmEuS25imM4cJsdW2dmQScjvSnzm/chiIkIbmOKC8ityImQcCp64FPf
         wJvA==
X-Gm-Message-State: AOAM530zcQReKg+SAE40ZNOix98/5l49ZXiCsUCTy79HNm7RHJlXn7VC
        0AsJalcmW5F0456BSrupvXs=
X-Google-Smtp-Source: ABdhPJykVlAJhwh1hew7Ukkqc4KUk+zyEqpBp1aiuSpkUmQEFnRTpQrhFr/xiFbgFfuGIcmkdEKHSw==
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr4613757pjb.190.1643133338654;
        Tue, 25 Jan 2022 09:55:38 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 4sm15290719pgq.23.2022.01.25.09.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 09:55:38 -0800 (PST)
Message-ID: <ee6f5da5-a070-82d5-5aa8-9ae44ee1bb28@gmail.com>
Date:   Tue, 25 Jan 2022 09:55:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 000/560] 5.10.94-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
References: <20220125155348.141138434@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220125155348.141138434@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/25/2022 8:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 560 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.94-rc2.gz
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
