Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC68A6C3739
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 17:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjCUQnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 12:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjCUQnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 12:43:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB6C43457;
        Tue, 21 Mar 2023 09:43:21 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id le6so16622990plb.12;
        Tue, 21 Mar 2023 09:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679417001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JnyYD+qGyWtHFKB/udYykGTvYk8Hn8K4Y5iyubI2Yi4=;
        b=OBy8lQWat22a/ba2tRylQDewdOXfII5Xl37c2cX2Ak1clLhQO8WYj2jo+5A7ue3AsF
         HX1S65unOKIbsIFs0SGC1syuyrS9NPpVbAqNukBkwDm1IhrZgrovdodAGxrUO9U5TQRb
         3ZITNO+0tVxaczuVIznblHu/BBi+sG2hCUVhWyp/R59vFgOr9DdoCLHh67b3ke3nEDM5
         sG9vItjZgZ4QyCw9Nbs8VDwjzEO4HQinzCBUTvYEsbZTkp7BstsRqJbU8F0w0eksGpEP
         ms9DxK4fZaPxHGHpQShzoIxTC0DLQXx7+ZzLgxiwQjpVhGqm1tJyBUPpAOjl+K9PGFTO
         LMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679417001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JnyYD+qGyWtHFKB/udYykGTvYk8Hn8K4Y5iyubI2Yi4=;
        b=SiJOdsYZMomG4cs/1iGjt7IwsJALVFCrcgHqYhuz1Vpv56SALCQ/NEGu8MOwBLhnk4
         4HfN4mtVWtZxwVXfT/jsa8StEXz+w9Zs8hnAZBs2k7gBvyQBtrg8rr76+8gN0P9T1BLa
         WlefxbV9ktm13vQQpl4ivETBCLz5KCcNOVqqMz0zdYQMRDAQ/A0g5LOWwXHezEWY7K4x
         5RzsTvb9T/ccTxLvwtdapxezvUoE7Sxw7JusS5n+ozMz01RFXZOC8hZxYDm+d0RenFgZ
         ND7Tx/WAKQPqDd3tgcmNSFd3Vt9+jfA8ba758qBEiJAOO9jnWmyz0yKvjniKRVtHhIXB
         QJzg==
X-Gm-Message-State: AO0yUKXwYQBvzaNplShSm0JrwrFYJL5MfIiHf/gF2hZH/jt2Ff7v3tSp
        3fAawJ8JezF4TSHIRlGryCQ=
X-Google-Smtp-Source: AK7set9i8a98qPwJ5k8mzGePIo2yKEWkhhw9OhqyZdA8n/Q/SWP/K/euHsH4jOG8VXNjKS0Ytbbplw==
X-Received: by 2002:a17:90b:17cb:b0:23f:5fe7:25a1 with SMTP id me11-20020a17090b17cb00b0023f5fe725a1mr468373pjb.13.1679417000997;
        Tue, 21 Mar 2023 09:43:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ca20-20020a17090af31400b00233d6547000sm8297444pjb.54.2023.03.21.09.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 09:43:20 -0700 (PDT)
Message-ID: <a7152f63-ebe5-d739-a184-d491f8477779@gmail.com>
Date:   Tue, 21 Mar 2023 09:43:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/57] 5.4.238-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230321080647.018123628@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230321080647.018123628@linuxfoundation.org>
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

On 3/21/23 01:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 08:06:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.238-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

