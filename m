Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDAF4D3FCA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 04:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbiCJDq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 22:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiCJDq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 22:46:26 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553EE11AA3F;
        Wed,  9 Mar 2022 19:45:26 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id f8so4025477pfj.5;
        Wed, 09 Mar 2022 19:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sUHugP1rkHWpowr+YZ714WfJfAa3z1nzFU6NLJ0LF6M=;
        b=Ic/bZ0l4vKgnBuvmGv+5XLkdkzIRHFMbHz/cG/H9xKYTUIReEfcFdwIXjAGSZnQTYV
         GfSdhIVphD8Ku5HzcMH8HLCUUHBFCxoWM0NFnEwCm6HZ0ETSBz2PYNxHkyNjx8cuVAxg
         vK1HYWkeZUOwTLm6tsOsLuyKbNr2JknF53FAJvp32qPU+otEpNDBtsL225Q7luXaoS1F
         LUzRbHtK27W3ODs1LT1wX+7UpwFdDcGt9l4p1ePQrD89bKBzbVK1qzc7MPRuuATxRUy7
         Ly96HL78mW7NWEIJYMNAuNqMfQhqEDtPI0EgP7txf/zJUIQiwzmxIJ4RqB9HzMzO6Eyf
         3DDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sUHugP1rkHWpowr+YZ714WfJfAa3z1nzFU6NLJ0LF6M=;
        b=dyNgXBbFFZV4jppMtxp/IIYsXr6WZaHHPDZwsQsx/OZxeY4m+aiDiuKq/s7fUy/tSV
         79MEj/dcOw00Ac4yf6a9wCo0K426t4+wP9ILAvszYC8tvArq/ctVLolikqkqqaE4jVv1
         YFS1Ppo3GXL17RJ1Z5T3X+5ZizmRI/hzlATGCzo5XVX9UQnZAlDtDkMRF+SQFU33/1Xp
         OMW9pZOgG6mn7GTH2CU5AirxrOhwRC5NvfN6qr+oj0U2EEUx5aqmkbgj9gnFE40CmUVG
         D90ladPjW8ulPGxetgNKwSF3SqbCXhDD2bPPpdMTnRz2FLO+HM/rcMxRFEbR20VlzTJo
         94+A==
X-Gm-Message-State: AOAM532AP03eOz4TXtzTYX8U/s8nJfpKXLZuabA5ehEId9sENRrw9TB9
        Uf0AemjnXP+2aB/x8qRbswk=
X-Google-Smtp-Source: ABdhPJxJLQaSq7P9QTfw2JGtRQa8BZSwlHXkKtpQ/V9fEEmU4me5Lzw9oyEm7XJdyQuR91h8ZYcEwg==
X-Received: by 2002:a63:1849:0:b0:37c:9ad9:6897 with SMTP id 9-20020a631849000000b0037c9ad96897mr2429507pgy.362.1646883925818;
        Wed, 09 Mar 2022 19:45:25 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a001a0c00b004e1307b249csm4740680pfv.69.2022.03.09.19.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 19:45:25 -0800 (PST)
Message-ID: <561a3c4f-16c6-1bde-0573-87ea12ae1a19@gmail.com>
Date:   Wed, 9 Mar 2022 19:45:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 4.9 00/24] 4.9.306-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220309155856.295480966@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220309155856.295480966@linuxfoundation.org>
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



On 3/9/2022 7:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.306 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.306-rc1.gz
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
