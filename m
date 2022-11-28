Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A44663B489
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 22:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiK1V4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 16:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiK1V4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 16:56:07 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671A32C64C;
        Mon, 28 Nov 2022 13:56:02 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so10314202pjo.3;
        Mon, 28 Nov 2022 13:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PNE2hM5xuRQg1qTi7Jhb4FKs2enVjE/c6i2QY7o+wfk=;
        b=ggl4s4VnvSif8ARoD9mDKXN/FZRm5YDoU5oWpDdy9kdO32JLUN4xSZEOGPcHBoUWgA
         ZoObHJDHHhM10FUHSyjQt9Ko1rbfCGJ33K7Y72D53oR+DqjkBRyzeQMQC6YeWX5YSmrH
         EJkj3agiRYkp1hKpvei60t7y7yAvgJiDpYVA2xJg8rMMSb1docHC1Dlois7qzoRByu6Y
         CRXi4UnZa5+lwkQ7+N/3nzU93/3DLwmMfLLescvqsVP7gAUgcyU5umJCVjRvsryKS/rD
         gRe0/j/0UIxjoOkUpXVxvCwi8GYXAeX09/V+Ir8nMHBUT9K8JFeucMozXw+bv0QEFIBF
         CfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PNE2hM5xuRQg1qTi7Jhb4FKs2enVjE/c6i2QY7o+wfk=;
        b=o4jWO3OGzhzPGeg/qSAxyV1peuOCGoziEsaURxzqDmkim4dCZFbmRx6z/iiOSeJNp0
         fqGCOWmDV9LFnRM9EjeaePOFvVsyeXUSNStvu2/f3Px7XPCCykbzwQlBOge/h44sHkLM
         W6IcFWX1mghtNZjN2GS+2EAmG87jvjjA6/xPjA8Iq5glNtb6G7t/+xHd14ZGYctVfDAN
         SzWkWYE5wtn4pDLyDVMk8kB4/IYs32Tshx39RlNHt9XCXQPJ7tAjphz8LyuWHGn2LHAG
         7HEB7ndOhxrdMUGFQV2mDBVMJAT7X08PP4fxkma6lTSQzMZNk8CgkE7QCQMk4aVmV+H2
         QzCA==
X-Gm-Message-State: ANoB5ploK3MnkW7zI00YUE5iXjenMiFjevrG6CBxSgzT0wkdMN9NsF1n
        Ek81zze1A/IKSsQfYpuBqVI=
X-Google-Smtp-Source: AA0mqf4Ic8U/2HubojmEHBWTW6lx07dDGX5ULtU6u+Lp5wFm6qolBN7MYcPQ0ef2hXtaB5KihKcTWw==
X-Received: by 2002:a17:902:ca14:b0:188:dcfb:f2dc with SMTP id w20-20020a170902ca1400b00188dcfbf2dcmr33894941pld.5.1669672561860;
        Mon, 28 Nov 2022 13:56:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v11-20020a17090a520b00b0020ab246ac79sm2641175pjh.47.2022.11.28.13.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 13:56:01 -0800 (PST)
Message-ID: <c241736c-f50f-97c9-f662-37b65d1b8a2d@gmail.com>
Date:   Mon, 28 Nov 2022 13:55:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/76] 4.9.334-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221123084546.742331901@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
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

On 11/23/22 00:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.334 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.334-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

