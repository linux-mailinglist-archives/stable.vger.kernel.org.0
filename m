Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF13258DFEC
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345585AbiHITMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345553AbiHITJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:09:20 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691DA2613C;
        Tue,  9 Aug 2022 11:56:25 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id v14so3892345qkf.4;
        Tue, 09 Aug 2022 11:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=1bJiCmKyDM21OGwmYhjUxQo6l6GkJp05rnDGs1pbS3c=;
        b=WwJzjpfUuvbsJsSiSvPT3MXQKNdHgbPZrXqlLqug0wswodL7ttB4XGhZEXAjC/tPO0
         G/j+yKqGNS/vkWDKQL7mFfWzK4PwSMLL2NesYOtsmPigLOMFuQl/8hMIHN1b1M7NFVoN
         FsRrbqaCrVVZlEWoL+rqxxODga7+7zLvt7O0Or6Nc+VRhXoUO5/hjiDHCOO44EZw/MHp
         uPIb5UvTiuw2lF5JljRrFysbUbIom1shV1fgkgCY3bJbY6dGjdExx3D7aC3nJvs7kL7W
         xxqJf/4z0ZWeoPyYXtxoiLyR4Bn08MMZeJvhrn7PD+FGaSS+va0axS07LhSgN1y4LcE0
         pTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=1bJiCmKyDM21OGwmYhjUxQo6l6GkJp05rnDGs1pbS3c=;
        b=DGX1QfWe+9SUdMaNKunatlt94e0fSLKg7YZtk/kGwENAL+1Cu44IXhqCwqFmOZkkE/
         B7TWWu9v9VCNnKj4uE1ULLoUXebNmj6ZTliXnOfJiEkvZJmx/zzrR+eRVxEQWcR8M5bu
         X0+L0KO00x+mQIGiU8EH2g+1AbeLgHwKO+5x5DdC0R/hnHLWmFshvUxwL9czY83kTT9L
         Rhgo4T5+QmbFqCy2vjHXGDhHJT+MYH0HLsrSVGmWJppCSGkeictVoisXuU4WUN8ltLOf
         PfmlmsHWWrItu5nA68UPJ8vTSIHRfJf873TQk1vAuhwyZMb6NnttAdFIA5bpQc3qmUce
         ka3w==
X-Gm-Message-State: ACgBeo13roo9XNGT+tmRNTWX9hMl43d4AajMD3QUSogL8BuMUnJTgbf2
        LUZKqB6wjftE6a0AEYnj5vk=
X-Google-Smtp-Source: AA6agR6PCqU7K4gJjjfiav2HV+PG5OmvDDOS/2Mxs/OFrTSwQ1zC8nPGWVCQt7FF+H1XRziODIwZvg==
X-Received: by 2002:a05:620a:2904:b0:6b8:b1ef:2a59 with SMTP id m4-20020a05620a290400b006b8b1ef2a59mr18280702qkp.150.1660071384471;
        Tue, 09 Aug 2022 11:56:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bn42-20020a05620a2aea00b006b5e296452csm11372742qkb.54.2022.08.09.11.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 11:56:22 -0700 (PDT)
Message-ID: <cd11472a-2b64-a0db-09f6-df729ab6e8f9@gmail.com>
Date:   Tue, 9 Aug 2022 11:56:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 00/15] 5.4.210-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220809175510.312431319@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220809175510.312431319@linuxfoundation.org>
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

On 8/9/22 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.210 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.210-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested 
with BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
