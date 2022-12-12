Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A14C64AB06
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 00:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbiLLXAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 18:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiLLXAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 18:00:47 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB65E1580C;
        Mon, 12 Dec 2022 15:00:46 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id o12so9251612qvn.3;
        Mon, 12 Dec 2022 15:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Ht/LlPGljFDR9dH0x29jG/ENJFXH6Mx1h6XvRtc6YI=;
        b=ordFqPmFcutAQwX0/fkW7+uB3h2qK8+JmcXNAkZVMrfx62sPR/Lg9/4PkG7o7RdcH2
         1lBXNODperIsg9yRXqLK5S+Mnph5tKUHiganeYo5vmnPgqWsef29Fa7taaw8ZhJa6J1a
         cH15yPHCpyEUIFv7bTlsMlfFkh/mhQm8aLMLo5azCMLWztH0RKg9w325SNsGtxtnlJca
         BcHWKrSnCcTbZ8YSoIhkNylFAoZJCgCsUKUzNEfAQG/kPDMX7Hch98Nle/e/LnHbHgxs
         OiMlqfeKRi6GyvmqYcE1UknDwCD2AfjagQ1LxK0RM0lOerjVSrG10uuiz+ABpsWd45hy
         4ltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ht/LlPGljFDR9dH0x29jG/ENJFXH6Mx1h6XvRtc6YI=;
        b=fPqwYwWRN7KY34pM6/itJx+5cuZX3/rhlY+F+XyGK20442K+22Prhgz8RCFeTZphSt
         GhJQAn4l4dz0DHBG9DG8yoO3iN4IQNJ+3O3Q25Kzv5j38MrMBEARx5l7hmRn4adaXVad
         wbVWJ+CbhiZkM3VYiDvHtEEoocU+R15Cg7USu0B9/Ll18x8wzTyAp4J0DHympYk30euT
         uPY7ju2n25Mv4/YPd4b334cYnM98jEApTtU2G6MLMCaFDqRy5+6uXeixg2mKs4rHFs48
         MtG63xg5Rz7nBrn0nNuj8lJo3YcCxkujRO+CoP4innbkOBKUzXWUZfYFWk8iJm23eJKX
         Q5IQ==
X-Gm-Message-State: ANoB5pnek4XM3l5pSCfMeFMLwWINlzhzZM6AEIp3hVXSF2q6/2Z3/TxD
        ZoyuCaVbs+3/aLdByAnJzC8=
X-Google-Smtp-Source: AA0mqf6KjJzcgbsIYYVqJ1MfuqoY2x0qrvgAgw1NOsw149Ed/RrFl8NXhWGVNm0jRoHH7Ip8dXzGVg==
X-Received: by 2002:a0c:f8cb:0:b0:4c7:539d:1992 with SMTP id h11-20020a0cf8cb000000b004c7539d1992mr25365659qvo.27.1670886045953;
        Mon, 12 Dec 2022 15:00:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t30-20020a37ea1e000000b006eef13ef4c8sm6635816qkj.94.2022.12.12.15.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:00:45 -0800 (PST)
Message-ID: <8a2642df-647a-6fe3-4c78-4c602bd5d1cd@gmail.com>
Date:   Mon, 12 Dec 2022 15:00:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130926.811961601@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
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

On 12/12/22 05:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.83-rc1.gz
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

