Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C967611BE0
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 22:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJ1Uz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 16:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJ1UzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 16:55:25 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9747E3471E;
        Fri, 28 Oct 2022 13:55:23 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id bb5so4231957qtb.11;
        Fri, 28 Oct 2022 13:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RYycDhbuHQh8p8GW+UONgFPTOdE3a8n45OrXqMo9C5k=;
        b=BiCYuJrP+N9tJFYpz/8kPtms6xQoqLSI2xfGLGTlQ8Ibq3MVOaZHztTSjdSNd4e3r0
         kBMIod+ECYvETJkSelTo/DN0gA4uAkamRLjkw8vlXSGP/pVIGlPg782Anqk7jwC6FIh+
         7uhHHfqpB6F9UD5oRPagKuKg+nrbrHxlhWZdesuEORNH7oSu3Gpy7RC64LI6cU/ngoF8
         Km5j+JtfeEUsQ357ra/u1xYRhklwymKJZp9Vu2TGwlAiQCn8gJKO2f4kNWvB//dpN47h
         yHgJrDMRLDFjGNHNQXXik9yATKlQA87RQy7E6/+m7mqeYRYIJfHPrs+UKl/r7Gx3onLl
         sRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RYycDhbuHQh8p8GW+UONgFPTOdE3a8n45OrXqMo9C5k=;
        b=AKYAwKNCCgi7EyM9mNtq89peKyh35ObHuJVQu2ofNP6oBD1kEGWk2QzZsfG2fSH5Tg
         k+/Y9sVTJJQo2CmKy1n/pC0QpS/uvlzfKapHUoX8pOGc3UzI1W5v/0P0TTqiJirGBXbC
         +uGPZUjdLxQmDqhgBDCjkYb3pScSC4BDHxCLJLl3hG5KNtX15mkr7mmrvUFQEuffAB51
         JJ5z1mkf6MJxdmzqHIf/fdC5awMYNq7WzXNnZ/BL7BJD2i7AoCXYiUr3H6CXJS3jSVvd
         JXxovz4Df/QXt0uwbunQcwZcPAmf7xjdMQVpsDhQk3qM4kXLBR5vUAw0qOllGe/5/y1n
         BXwg==
X-Gm-Message-State: ACrzQf3/H+3MNVHEoC6PpeRkyipfCpwm/OtKHDzLIn5cucphdo5I6UTv
        PLNSrF38+0Cv1HMbTMTgT0M=
X-Google-Smtp-Source: AMsMyM6K9ov/NtC1jJuoptk1NaSA5S7LFc3Mip5j4V7vj/9+ocEaUC6Fu0sgVoHB7y2ctI5Y7+vVog==
X-Received: by 2002:ac8:5707:0:b0:39d:c40:cf51 with SMTP id 7-20020ac85707000000b0039d0c40cf51mr1276287qtw.102.1666990522699;
        Fri, 28 Oct 2022 13:55:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g19-20020a05620a40d300b006eeb3165565sm3687064qko.80.2022.10.28.13.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 13:55:22 -0700 (PDT)
Message-ID: <461060c1-8d5f-3585-1e3a-43d0e0c5e87e@gmail.com>
Date:   Fri, 28 Oct 2022 13:55:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 00/73] 5.10.152-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221028120232.344548477@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
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

On 10/28/22 05:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.152 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.152-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

