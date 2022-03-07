Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52DA4D07D6
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 20:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbiCGTmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 14:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiCGTmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 14:42:03 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5F22AC67;
        Mon,  7 Mar 2022 11:41:08 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id e13so14962587plh.3;
        Mon, 07 Mar 2022 11:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G6/SEA3VCDdTTdgFNwQqU6r2THdOql9huhoycTgbW+M=;
        b=Pkx7wq+ioK+v2YCTnpFtEDXnp3tF24+lDVZZdeRROu7FZXGRFrsT2pbxSbWjqGnTP3
         qdp+0ody5XwJA0Yv+3XHz4468LWDymK44IibjiLpSUhR+IwrZCMC91Fpcffpv0WqDNN2
         KAIuykf7iAmJPZqHT4F+VvfMF3e890FpWX3KVmp7gJW0wg1TjCWQBMZ+62R76VLbCnMI
         oOYYLlrNsK9VDd3DX2Ig3GFWHuQcXZUWnOjBNluoT5t6TnVF9vQzcL+Znjc9VOb9ZsJ3
         Q0jpb7gYCkRawwxaluLMe8FC2M5j5Xg1W7XrCE0BbZ/rXrXC1eyyGRwd0Lurg/PLqBs2
         3ZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G6/SEA3VCDdTTdgFNwQqU6r2THdOql9huhoycTgbW+M=;
        b=w0QuYLXcgZrTKiUbp4D/7NF5cSNH+qxmZ5a3hoqOwEM0JKdL0V4Lyr/EeWFCfINdtC
         8TiI8meY6f6Izrk2qksuyNO3NEZfoGAk5J1lG6Gdavtkj8gKCvyI7Cu8C8mMDqPdCEvw
         aCGRKvJA56sVlpPL5+zrWQkxDkhnCE4d8uAS8x0ZftNSR1gBoXPDBAsFz+1MSlvX6uXH
         AABMxpZoI54MSI1GjYoZbYJ9cYGiVahK4ASD3DlFobB7rBFsOoWwAO0lhjhYkUOi9rzd
         +NOJAzQegLqS+uAxAFatcgXFwKOnMW8Vo2XDQ0D040f0uiI801wZtytT7kjDNCUuCOCR
         3xaA==
X-Gm-Message-State: AOAM533rG1yN5QU584rrqpnL7nXKrukMDs0cr0IVwRlc2YqhoLz3Zljd
        k8ZbjPbAGlsxyGnUIrno0rY=
X-Google-Smtp-Source: ABdhPJzeFoQcTtshzwwxjeu6QZ9II2PAplNY0yKUZSE0W974Uk8kW6hhdwpuuwNKbEUCRSAX3unlYg==
X-Received: by 2002:a17:90b:4c44:b0:1be:f4be:d69e with SMTP id np4-20020a17090b4c4400b001bef4bed69emr580812pjb.163.1646682068208;
        Mon, 07 Mar 2022 11:41:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i128-20020a626d86000000b004f3f2929d7asm15936947pfc.217.2022.03.07.11.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 11:41:07 -0800 (PST)
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307162207.188028559@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <66e161cf-1b12-7090-a8d2-558258ec403d@gmail.com>
Date:   Mon, 7 Mar 2022 11:41:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220307162207.188028559@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/7/22 8:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 256 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.27-rc2.gz
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
