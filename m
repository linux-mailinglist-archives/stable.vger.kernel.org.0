Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64875AF628
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 22:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiIFUej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 16:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiIFUeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 16:34:37 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0173B7DC;
        Tue,  6 Sep 2022 13:34:33 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id d1so9254222qvs.0;
        Tue, 06 Sep 2022 13:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Kdx9eB0G/Rt4zDk8HpimlcjE6lHIxNKNY9QtTfBgxQI=;
        b=aOJeEwm4ehxc7yIky3ORR7ykpyd40h961aCP5jvcXxLpZ0BZg2OCwX9/txCE3Wi496
         JSuyFAi6EXvwY16saavXyu70oAC9YEfV/iEAyxPeUagPLuanI3KdkGP6rhfR7VLuXBQ8
         S9y2Z+OBjxrzUiGEEDt170BbT21SOXfuDtBK/+1Q1n7r0ztgGfrcqNAcQeJbImxjCwmv
         WZ4oSPDx9vwsCB7dfN0/X5rLFZTmQU4rQBaZWua9R9CtApmTdEKY7hOiqV0n59YX1+sl
         XXbpjHA70E+YT5OGb6Ug7v8e3Gb18ATXxpAulm1rABDsSo19BoBoMDE12OMKssCELjot
         0eWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Kdx9eB0G/Rt4zDk8HpimlcjE6lHIxNKNY9QtTfBgxQI=;
        b=jTpjeea3kx41bOx+zaX9Y7L2Mw2eFeMEM83QrL3eCJOtwQ7Nz7lDLT8mXSMnmmkOJt
         hKQO7gXomJBVLd/SLh1ubkAWjtv8zCBSMNvdH8scZ0wuz/dwx59bdvk0RFn8tMz1rsp7
         0JOPWCJaWs/f8DSNVG7Gegi5v0tO3105+2sZLwjQCrO8Pz7jagnYhu+0Tvs19/qJUK18
         N1thead0fjGtL9s6UH9Q8G634q69fV98FCDLuea5T7dzYEiUfeNkitVIQDW6DU/mcIPZ
         ZX0vwNPllr1PppIptCA2r8z6CEtoVBBBthL5zFucIMbgD1WhEeqX6xFBHD/U49ab0Hfn
         tDAg==
X-Gm-Message-State: ACgBeo14xoMss7yLBb+I22fDG7+8Gep5pz8Wsa2qI/i/bcjBeYS0NIpA
        pq0XNFbt1blD99PpelLdKm/xj+XC1BQ=
X-Google-Smtp-Source: AA6agR5btjk5NTbY60WEV8/Vp9q00bYFpjCsKw3+Imx0Yru3Z09SgMDq9nNY4abeuHzIswcEjga26Q==
X-Received: by 2002:ad4:5aad:0:b0:4aa:a266:d1a7 with SMTP id u13-20020ad45aad000000b004aaa266d1a7mr82877qvg.70.1662496472594;
        Tue, 06 Sep 2022 13:34:32 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u4-20020a05620a430400b0069fe1dfbeffsm12397653qko.92.2022.09.06.13.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 13:34:31 -0700 (PDT)
Message-ID: <ccbda2b4-5203-7197-4010-7f24c9493275@gmail.com>
Date:   Tue, 6 Sep 2022 13:34:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.19 000/155] 5.19.8-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220906132829.417117002@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/6/2022 6:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.8 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
