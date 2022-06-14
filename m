Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4547B54BC7A
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 23:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344911AbiFNVAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 17:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245736AbiFNVAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 17:00:39 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1A650068;
        Tue, 14 Jun 2022 14:00:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n18so8752767plg.5;
        Tue, 14 Jun 2022 14:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ABIwjsN01avoXfixhqq/nhjZOdRVdPjlrbZog4E+a0w=;
        b=SXD+jodpYCjHDny4B7tRwLnzq4pE6143JPpRCp4NCkoL7nzyoQmGQmw7OmUiSiNC6m
         oCCGfwwNMef3wp7EGzL46Y52yIGsrTz0lJvJGL4Dsh+PXKONnBETq9QoP1miLi/Qs6e9
         UzDzVtbDFQ2SJJuXFIkexc/7N969vfzXVSMvo0syt5UKGhul3LN1vJb6l0Z8jX/EbjrZ
         2zFMg1fOeFsX4LKGQ8fG9L2M2CCu1YXjCOtkjMKA8Z87H2FUBVPVv2cAExZmrg4h1pNA
         hdVzdgnLdKFAYvIARiZ6fJmEYv0GaM6pL2ZjYDHaU/zhWH8bZ4VzXhAEnUI2mjf1+Gya
         Utdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ABIwjsN01avoXfixhqq/nhjZOdRVdPjlrbZog4E+a0w=;
        b=N+sgkUQHC1HCVfN3oN2hqya4Mr+kQHlx6Uok3uPTyJegB4N77XKS7ZuPahb1PkTFdC
         K8Y3FG6BRzGfAA5Bj7+BNLnHKVvFT66sdczU8lgsyrxRsGjsxFX6MBb1rP/x5rMblvYc
         o6e2/HJHo9Am+qdjRHhRJKjaWOmZgnhBP/cy/+oU1kSOdNuX0LnZWt1FRLinUNOB97eA
         Ea3SnZ2FvLVmJXrIjF4EOk0bqGZXvZQZC4AMlmPz8f2vWz5B/p91yAtq380CZPgyXPhh
         VkHN2H4sUvF+v0omLPvS3otsh+Efw7yM1HMbzxaMdwGvxz8elOHRrPkNb0yZlNxGFvgL
         dXpw==
X-Gm-Message-State: AJIora+OvjNc0gFOKGn5ShQmmY3ELgDSS384WaHvMZKj39BSNp3oOSdY
        vvSFALMBxTJVi1EqF4Wh+AU=
X-Google-Smtp-Source: AGRyM1uXICEcEKElb5h6IOEsUSAw3dY1Pt+rc53YxufnNf9GLR0TeRwtnHO5tz/ZtIUz46pEPUoGKw==
X-Received: by 2002:a17:90b:4c06:b0:1e3:17fa:e387 with SMTP id na6-20020a17090b4c0600b001e317fae387mr6469302pjb.53.1655240437933;
        Tue, 14 Jun 2022 14:00:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a15-20020a1709027e4f00b00161e50e2245sm7701671pln.178.2022.06.14.14.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 14:00:37 -0700 (PDT)
Message-ID: <8156508f-71d5-3ed5-ccba-bed6062fdbf3@gmail.com>
Date:   Tue, 14 Jun 2022 14:00:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.9 00/20] 4.9.319-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220614183722.061550591@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 11:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.319 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.319-rc1.gz
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
