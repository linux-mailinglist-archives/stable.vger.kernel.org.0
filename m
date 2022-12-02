Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C534E640ED1
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 20:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiLBT5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 14:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLBT5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 14:57:53 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D01BDF78;
        Fri,  2 Dec 2022 11:57:52 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id h16so6705969qtu.2;
        Fri, 02 Dec 2022 11:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E6UpE/TC2qj4+oVdALXhIZeIKkqXXSJmNthecCyn0hk=;
        b=qQ/WXxlPpIF2XwyOyjcHwhDGyLblUJ+Lkb9hr6hXAUQiL7bWcof/NhMH+kpPMzJT2O
         DIFmF4FQ3Z45BdxPjH1Rga2BgnDoOjIt81kZ63PzxRx+DmhWnEwG0Iuvh5EsCDzdwhW7
         XTYEnZFyrGRsXjKkg8AU2Z96M0qGeFp+mXfTZnILJAOEOZ6TSQIHYj5yomM4aoUG2lag
         LN2aZEh+Um/Qfm6EwnM+WR1l8UQvJD+4QgD5nIJy0fRgV4SuvOC5CX8XvA7lkTUom30M
         ywAQ0iD5X8eJyUb+Ge24qpuCcgUol1jRwyKOGaqjy5sctPxw4XCQtwdh+3lT/3D1plUB
         6M3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E6UpE/TC2qj4+oVdALXhIZeIKkqXXSJmNthecCyn0hk=;
        b=sHTntibF7QXt3AoZrxdjfk4m32gu8nZ05PYAd56IJhseSp/t0UanusLrC6dKzIriGH
         qmT32nKtjhDoFG6Bo9Win/st3/KjmVBYhuzZQKguagON3Z82j1obQ2N+3KjKMPjociqm
         LwokxkNaC47+iSq6NFFOUbdGLR/oGTl+BN37Iotlq33anpiFnVlDkPXMe6fS+QB712FI
         a2az8d88T49xXYWALo9krzCXMvQWLiiTP31CwtFYmyhllo+9u05MGVkpQw56Q5OqUMbw
         wL0mhkVar/UudiXowfhjR5wQ5M0oy40O70J61BwjwG/ac+KJXcNM2/6C2b4mZXf2lQ/W
         BGnw==
X-Gm-Message-State: ANoB5pknJdC7aOKVAkDtJ64IfybHbcStSLqE/U41xTZZzyxxcCfrpAp/
        ZYY6Av74grGp7FGpH6ltDgc=
X-Google-Smtp-Source: AA0mqf4yAuBiietYn1UxMo9lKP2dUUH6GbZaquVG0c7el97Lr9LlGR8ZNmoKn/o0CLko3ULUxhkMHA==
X-Received: by 2002:a05:620a:13d7:b0:6fb:57cb:47ce with SMTP id g23-20020a05620a13d700b006fb57cb47cemr50930432qkl.452.1670011071179;
        Fri, 02 Dec 2022 11:57:51 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bq43-20020a05620a46ab00b006ce580c2663sm5934875qkb.35.2022.12.02.11.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 11:57:50 -0800 (PST)
Message-ID: <bea1c858-dc1b-6251-8b2f-c7b88f48fe28@gmail.com>
Date:   Fri, 2 Dec 2022 11:57:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221201131113.897261583@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221201131113.897261583@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/1/22 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Dec 2022 13:10:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

