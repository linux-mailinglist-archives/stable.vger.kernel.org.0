Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30E751B652
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 05:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbiEEDMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 23:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiEEDMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 23:12:47 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351EF419A5;
        Wed,  4 May 2022 20:09:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v10so2639068pgl.11;
        Wed, 04 May 2022 20:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gkNQqEbbkruVWkng/pZ8wLPYUCsyQDLfstvvroGwtmY=;
        b=FkZpbrERaZgztqu+q3tt0oQXMN56E8V3NkzluNp4lcnUA8ruIoCFrWZ8qVXsogWQbS
         4v5egGWo1mPeM+xUxCYv56PQNwGMgDYYd9nS6FYseeC7KfiWWLnvH8BsFwLMffQhV4VK
         ujL1mvQ8AzLco29S4nfuIj8x7MihRBL/18jFobRJ6FH1KP73WTKziQ1Xo76CcIDXB+Vz
         FIW5AJlCP7LmHIwHQJVeftXtBFBDm5N1gOkRStrnaLBiwYpziLOwEl8E6Tr6zLgtyVDU
         yF1IfkMJAwBc8NMRpoVyfMW/td7Kvmn20eJxjcXmS7J4c/lobPLNpziCVsmG06hAZ3nc
         pWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gkNQqEbbkruVWkng/pZ8wLPYUCsyQDLfstvvroGwtmY=;
        b=2Ph7XbpyfByiZt38Cp8eI5hky3i6torgwgCZnniyW4SpLXInnz7IbGM3shqdjdZXh7
         GZvU3Pgl1pIQISLx5l6DSD2E+kzsBOU9puxFMxYsw2C2df8HYCiwZqxkI85eUd2MObii
         xOEQPebBKAtpLsMIrrbNckZSCEw+LwIHJp246gshKC13LuL+/ktatQpwM0uCPr5rf9JT
         R9e4pFnyGA+G9ymSqb1EGOwztYB9TCGIAaM7mf+OML6vR3+J6Ib9WEqunTt3vE29eBUY
         lV9SlQ659luB9yjTCsp7XMF3Rt4sZVWVu8cLZsmSpVpk7xkxuG3ajTNRHEZTSjv577U6
         ollQ==
X-Gm-Message-State: AOAM532hSlXAN8omE92/oB0SYd5SW6uA6Q5zVccwyOZCAiXeVWrh7Ad1
        QA+g+eFz/ZBgil6IkHIlUt4=
X-Google-Smtp-Source: ABdhPJx/GbXzY7EOKpnPiPcOJ7hWH8iPNx5yh8LuSsrsWe65Z+k615Qv5N4rZUcHYA9mvoBP5H1v1A==
X-Received: by 2002:a65:6149:0:b0:3a9:7e8f:6429 with SMTP id o9-20020a656149000000b003a97e8f6429mr20407601pgv.613.1651720149564;
        Wed, 04 May 2022 20:09:09 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cb10-20020a056a00430a00b0050dc7628141sm151641pfb.27.2022.05.04.20.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 20:09:09 -0700 (PDT)
Message-ID: <b6843e9b-0a70-2564-363d-0224f017e564@gmail.com>
Date:   Wed, 4 May 2022 20:09:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.4 00/84] 5.4.192-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220504152927.744120418@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/4/2022 9:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.192 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.192-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
