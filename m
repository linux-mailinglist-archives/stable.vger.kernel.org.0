Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443BC515100
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbiD2Qm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 12:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379206AbiD2Qm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 12:42:28 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C89DA6FA;
        Fri, 29 Apr 2022 09:39:10 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p6so7590511plf.9;
        Fri, 29 Apr 2022 09:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=F6Y+lRFI7wQpfjPajaIOgcBlrsbJOqw3dYrlK4wNbL8=;
        b=nRbbK4lu+vpjfyEIFSAqK8rYpg4mMDJb1jT50fh2G1rWeWqhN5XPaw0M/tXoUbTI4s
         ZTcisNFhrKhYBV7UHlAeP9WPHunilYyghICN3z6Yczq1c16g2OtFuamYxTdb9rr3lASG
         q+OtAAMmB+YASUOGPbe6lGaA0fiSXU1/bnLhkdAakyrC1b4abtrwBeqGUs6RCbI8SDDa
         v5pBHCY8nVlHtJfzP/277xuRfCQBgXgCilc55DANIZxV2l3ovYB3qgW9rwDPeDtVDEL5
         8DqyU4tTD7ASnDi3P++qaGVtUi6vZJ8+qdC4I5tsyRe8zivy/YZsB5JiGTglR2atXcBt
         rGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F6Y+lRFI7wQpfjPajaIOgcBlrsbJOqw3dYrlK4wNbL8=;
        b=n1AN4pKDK09ZP/APMQPe9E1EGb4YUdNcWl/2eeQLTM8FMrDsUl2xIZzfmFniORj6od
         yjr0/XUMFo61yKBRW8KITBGkm7cIKgr4z0Ud5IiwkWkcNEYdx+7MfyQbdrta17Wc28Gf
         DVBXJYfP5SYhWFqIENirPqFvah/uv8lmAkZ1Ybq83e8t4W2wKffR6mp06FOo/71bd3pA
         fQj3SGE18wQnoAm7IuQEp4ZYgaFnBx1KnhzJx42OwvO50QFlXo4PVm4pRm+QiBEkfnEn
         jtl7fnkqPTyS+QjgRPOcVS+6IULlVgiHRPsIxH9KXpv4xGurYGZRU58lG3pl3gEvwWjp
         ZYNw==
X-Gm-Message-State: AOAM530BkcB9gAIOzrs0fP4Pb7xAWPKJG2+loh6LW28/4tpS4r0n6XQb
        0OSX/mzyd8Gb6+rSV4iHIUQ=
X-Google-Smtp-Source: ABdhPJwdPea2/AP3tneEhSz4oOJG6/x7D2IgqircsD1ZhNzRBc4GxHWTg3osZY6505Jv/aDmExy3pQ==
X-Received: by 2002:a17:90a:31cf:b0:1c9:f9b8:68c7 with SMTP id j15-20020a17090a31cf00b001c9f9b868c7mr4999123pjf.34.1651250349460;
        Fri, 29 Apr 2022 09:39:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i4-20020a628704000000b0050d36b6e22bsm3545952pfe.131.2022.04.29.09.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 09:39:09 -0700 (PDT)
Message-ID: <593a67f6-9c14-ed6a-0216-885f9dfcd4fa@gmail.com>
Date:   Fri, 29 Apr 2022 09:39:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.15 00/33] 5.15.37-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220429104052.345760505@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/29/22 03:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.37 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
