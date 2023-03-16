Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65806BD872
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 19:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCPS6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 14:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjCPS6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 14:58:54 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9DADDF2B;
        Thu, 16 Mar 2023 11:58:53 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id h19so2936123qtn.1;
        Thu, 16 Mar 2023 11:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678993132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wlCRV7G1Pgp5HRqOyDJ5n/8HXIVn3jLn2OEG+oEehvw=;
        b=dicNdp8Lkt+cSW7Czak/MMcRQyKpZQc2ZR3VTYX44XbPyo9z5zxhl0XGCTvHEEIjbZ
         Jva0SXJzb8+mXjilatGxaisM8E0x7ZVqfFnd2MmnJwLG6SCSOPmHkoiqp1v9Yvvyo/LO
         e5cQTe1SrQPswkyc72UXz8yNwV16tD7HZJ2ukW6pj/J550NDidWmjabsfnPL5rhHuED7
         x/zBwGHT3ikb96SBZWrCR2luLarhGVkImw60AKaI7lPbjiUGNe0Mv2vMoopWf7BUF5RQ
         +B+WqpYSpAMP+VBZ5+zlT8ACQNZ11Ff87US1u8IHBwTR6vyWc2jnn9FtpSPtTPne/onP
         MpcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678993132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wlCRV7G1Pgp5HRqOyDJ5n/8HXIVn3jLn2OEG+oEehvw=;
        b=jgqXmW3Xv/2V5vjsvOzUdB5LaC3uAStBDtmZrSxxsxzG/C1rmc1X1YON0XSxd+aRJh
         M/MZAgDugzmcj3/RcG6UPsZ2cDzCWVjrt3JWw0JGKv4kqnX1nKbpP42wOGk3my7gN/da
         O6lBair6C+YINgSAVqC4xv4Il3dmNliI13P9DukHNBSo7UkKt12JBuqRk/fNsPfycORM
         ashzZopSMXSEeaTLgYiMZa+++Upz7KOsKdFvKMznS9Lrl0+cIk/k3HswjHRte1OosJHV
         4qbK1/mqN46xUYGN2KzhCPFOo+SEFivRffFd92qz4NBryzwHvEGkbbgKpNI/qzab0di2
         VBGA==
X-Gm-Message-State: AO0yUKWzJI51pLqk5O+LugeMSsGYMPO9/1zCyHoXCXWZGH3kEK/PTE9X
        JLXbq5mFe+ugOlMQz0L5ahc=
X-Google-Smtp-Source: AK7set88kxIDx2a3+4F9yjKaHVtSZATvUTFAOszrSwqdWRp+PUy6Dz6mgwa+oCgfJdt+aSLoZJp6Ow==
X-Received: by 2002:a05:622a:58a:b0:3bf:d13f:207f with SMTP id c10-20020a05622a058a00b003bfd13f207fmr8052190qtb.22.1678993132637;
        Thu, 16 Mar 2023 11:58:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g19-20020a05620a40d300b007290be5557bsm110251qko.38.2023.03.16.11.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 11:58:52 -0700 (PDT)
Message-ID: <1df7ec63-5842-4589-3a48-89eb7ce76766@gmail.com>
Date:   Thu, 16 Mar 2023 11:58:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083443.411936182@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/16/23 01:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

