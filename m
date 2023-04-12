Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CC06DFEC8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 21:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjDLThv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 15:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDLTht (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 15:37:49 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9427213A
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 12:37:48 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-760a1c94c28so2861239f.1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 12:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681328268; x=1683920268;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SA+VjG801FJzKZfXKEA6/770snka7mIpjnJyN9XxyfI=;
        b=Ct9UauyxKrxt1IguFNEfeI5UYBISUhiEUYx2BC2rKDFNat95+1S+movXXGCMiSctUs
         KmvowONKOEkuUBQu4nIm10edKsEzhW72W04UcMVMfL9HAHGSyHoSVR9CD3AekPXOOXD/
         KSluP+wtafeVuRw1pkHXVkiuBP1nMycF9r82c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681328268; x=1683920268;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SA+VjG801FJzKZfXKEA6/770snka7mIpjnJyN9XxyfI=;
        b=POdC2zPXYV9UxGGUIOPp2xz7mYMZFHtiqNRkK3Bh6RtRDznAxK7whUxCV1zpj8eEtR
         1EVdjNGKC0C+ubQzxGej1BADkobM2CIbtOS1bbITWX7ZvvcezBLPxKI4oSSCRYVibKCS
         U6SGhFYzCfquth3Rz69YnMmBogD/bZ1FFOhiiCgGPyynzhCbcGJ9VGDv5Pu8Sdy91Pfc
         nQxmvVQDoaiH9cIaIlShs4IfJYQJrGD2zlb/GNd7vHx0a3N21AOyEz6OUJSh3b9cfsCH
         0nJhvDehcf0iU8DtN3C8br32M2o01QdBU+MmwthRbnLYjq2wJ1aVclT5f73lLTjggi/p
         wVRg==
X-Gm-Message-State: AAQBX9esXaPIqC36PoB42Tn4yRH6U3nkRZqq225vw7nGYqGhVPf3nNcK
        p9wFFAnb4/tKR23QATX/3giXdA==
X-Google-Smtp-Source: AKy350ZhbHdLt/AXSMTBfteDoZtvSSKGMoJK3SmoZDVGtXm2zVlmnv9oVC2SoaR3njUq6H5e/R6dHg==
X-Received: by 2002:a92:b711:0:b0:329:552e:2040 with SMTP id k17-20020a92b711000000b00329552e2040mr946352ili.3.1681328268017;
        Wed, 12 Apr 2023 12:37:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id d9-20020a92d5c9000000b003284a6f4405sm12093ilq.1.2023.04.12.12.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 12:37:47 -0700 (PDT)
Message-ID: <b7e88931-3343-aa16-2880-ada37132aa54@linuxfoundation.org>
Date:   Wed, 12 Apr 2023 13:37:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/23 02:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
