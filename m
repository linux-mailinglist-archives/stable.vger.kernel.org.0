Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1509B6D5701
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 05:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjDDDIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 23:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDDDIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 23:08:16 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B85810FF;
        Mon,  3 Apr 2023 20:08:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o11so30048095ple.1;
        Mon, 03 Apr 2023 20:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680577695; x=1683169695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MRnkaaj/cVgSaagBe9PehnJgOMpffWqdnxqVj0DdFK0=;
        b=MBoIRhcYmwFydDMClcg2UreRmhzz7xW1W3ifJjOObZVq84h7WmE/Le3zwuFS+EwjSw
         61/b2Cqr0rxDzHpSkqF6pzhykiZzzwseuoI+ACxkfNEHZayWd1c4hRe3OGnUIHJsFUFZ
         Gro4nuRj9Sz7107JS2qefjLg+ZO8miF2mfaSnULZTZl897mooDXzcDsqdewNPakI/I6o
         1wISUI+tn47fYLaHs/EmBPcFhVE72O5oCQ3P9oyUoWEQ/TvtaWEK4SwjLurFbL3s7VFO
         Db9j3SOsmbsb42IuYu0y7AGFdRNW+iEnpxULLZUbTJ/Pd9gA6WZ0Ba6acbY5Og2dhrLN
         iMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680577695; x=1683169695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MRnkaaj/cVgSaagBe9PehnJgOMpffWqdnxqVj0DdFK0=;
        b=zONPEJLHgHTolmwR+LtWE9EAVEFYEJPgUJofKCAgZZ/Q2/D+G7IK2nTe4GOP/5Y2iR
         HNAjfam3FnbcnE0tuu9cevrpKNPmRQdDON2hu+ki86fd5PRO2m+h8Uz0PrloitYUatcu
         E48RQdKwDTpjYEe2RMQBXJ5YbMs5posQQKGj2bLS9aQeYZUv2hZ2kHiAywm/EjQpcXAm
         B/3AESUR5LWp5gW6gmjW9mCeLj/d3YHVylgM5Ij/T28kTpVBT/JEHluM6dyn19yEvI5T
         t3wdQlyLlhXpiAQoIe1II76gfAVhwg+3EQ4CglJR7FCRLTNAL2NX2spOOHdgVhS7FTkb
         EDqw==
X-Gm-Message-State: AAQBX9dfYPT3EFCFmLhfoOPIy/f2rR+dFr2hSJVveMnLjUJ7QP9KG5L5
        TfUy9cjCm860m16o6QOmeSI=
X-Google-Smtp-Source: AKy350blamQxgHaeX5hc8HPO9IhB+5+NqWBQpJrec0j8+FB1pQ3uAr2PPmmNHy8w06h/XkTUUqeXnA==
X-Received: by 2002:a17:90a:4146:b0:23c:6713:45b3 with SMTP id m6-20020a17090a414600b0023c671345b3mr1398826pjg.7.1680577694750;
        Mon, 03 Apr 2023 20:08:14 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a174300b0023f545c055bsm10242115pjm.33.2023.04.03.20.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 20:08:14 -0700 (PDT)
Message-ID: <134bdc4b-e62d-7892-68d7-24f917e1e7e9@gmail.com>
Date:   Mon, 3 Apr 2023 20:08:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140416.015323160@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/3/2023 7:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
