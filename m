Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360274F6ED2
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 01:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbiDFXk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 19:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238212AbiDFXkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 19:40:43 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCAB208300;
        Wed,  6 Apr 2022 16:38:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k14so3538008pga.0;
        Wed, 06 Apr 2022 16:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rhS7OTxGR6L+t64q04L0IHm02DXhCb8gCMHEf6NnkpI=;
        b=X70yDAE5D4pJzAsx6N9bvcw8fc5FAxSbzKdC+8JZug5OVVhB38wxgmBHOc9aq77Ofa
         2qcpDVXmCD4xXBR3UrGQFLsjgEI5DjupVh4vg/MTNJ4/avk+6+eTluRyiT8NxTfPSSUG
         e7/SukrLtwAVsIwouAm8IoyJz3azcrW0dJF6VbOTWqdLPGbb02Pd2P/Z3egWI4i0nXnx
         UMw4Rg5SvoYnZ5NXKOXWVv3zh67omcj3dwwRwVMI4RuAtI72PyPaq8Sg3pzLDgDNlgbn
         DfdNWhRoDjGI0AL3NxscGwQqvAFeAkJS2v5gCdqyxMnBT7XxRBrYYecko0EBHsRxRRgI
         K5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rhS7OTxGR6L+t64q04L0IHm02DXhCb8gCMHEf6NnkpI=;
        b=UXwsCj4oWlJ3nsYCAnv32rPtu5AjIpAtkzEwS+5O8MqeMzYSDU2QiS2rG96pmUQdF/
         cUtYzNkrTYeS5r14WEjzk9XzflqN3cp57Z3tbtUVR6aP3qv+pCmZDXZWM7auttSKfWHW
         dInZ7fu5kxe0gyi2BWz/fFaHrD2EAaSYoddiXCkmASezuM7b05sdDWgkopJPlqiiKbcG
         NGYV9f3WYbv6W6VCCMDmKVw/x6LcRciSZktWsfUSgBTlvdDOw7gsssiQV90e8WT9hU3k
         lt8EtM7y9V3j0Xe9N2eTlEyInMEsaQMgD5cxsRQsHrJhsGkQrIwLfD3APv4kRvMYwL1A
         wWqQ==
X-Gm-Message-State: AOAM531rW9mVUSbajFJjHlNrPGE95Zc9AjVKhnLacdOglBmfa9yePSqZ
        EBBHIw91P0TxRR7jpBdKqgk=
X-Google-Smtp-Source: ABdhPJyBBC+LDZ0ftU/2Gv9xlfVyDt3T+i5Nlh0ZBYVNAEic1LjKx5i7fmHZQOAGzN21xpSbb28bIQ==
X-Received: by 2002:a65:5083:0:b0:382:3b02:9799 with SMTP id r3-20020a655083000000b003823b029799mr9295626pgp.302.1649288288270;
        Wed, 06 Apr 2022 16:38:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id om16-20020a17090b3a9000b001c7bc91a89bsm6904938pjb.52.2022.04.06.16.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 16:38:07 -0700 (PDT)
Message-ID: <bdc2073a-9adf-db20-bed0-54e88d9beb81@gmail.com>
Date:   Wed, 6 Apr 2022 16:38:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 0000/1014] 5.16.19-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220406133109.570377390@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220406133109.570377390@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 06:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1014 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
