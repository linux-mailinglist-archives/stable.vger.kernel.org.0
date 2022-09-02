Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0809F5AB79D
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 19:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbiIBRgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 13:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbiIBRgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 13:36:49 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A90DCACA6;
        Fri,  2 Sep 2022 10:36:49 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id w28so2013930qtc.7;
        Fri, 02 Sep 2022 10:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=X/KMkJa9tNwOodhpy9YiwOnEKmKd6PupwV4wap/a+k0=;
        b=bk/V6g6SZ/wGWRhMX1z77EKu9PFE9FjKHU/gQUiTGxivtOejf45tlQCY4BEGjpjqlh
         BlwjXVlayClR4PsefaGU0kvps96GCBdAEUxmiBc5cvKrvCc6DFi3rzd6ANVqGQSpavRE
         BtJ3OEKseItsfLZA586I10YeIOTLN1UOJvxGOVJ9VTL1rGWcMUK+zZUcmwEZKfjC6p14
         ar3MErLG0cpAKWPeKFDnQYLuLL5TejiNUTz2zHePoYeJ1OZxr+8Rp/L7jKq4PkTOz5A/
         XYIr9Z18yMHSLRiUa2PBeJUIarsq5nROGQHRtLDs8Y6kElfSBKdt+qcdlifXa0jm2QGH
         1p/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=X/KMkJa9tNwOodhpy9YiwOnEKmKd6PupwV4wap/a+k0=;
        b=D6P87q5PcpDfzYqPq7Jn4lvOQP/5nJBDZ6PloQCnJljljrPzLhYPTkuXpXfL/SPo1Q
         v3kL03+h6Ih6LrE71I1BjVhrZ5lLBOeI1mdtQbfpkAxVTiUFFO8eKN8+HUMpCCZ5MDWw
         zhTxFhDPEJPRi7udN18x930PiXyXuFe/yG40dluv3DHVh6vG68WISIcou5dLG00GMwrg
         capgg+xY4ra8IM7u3/trA2qUNlM7WfmTjTalxaRV+dBKaZaEOdFNW4iv/6jpAKtspRxx
         oeKI+4r0KlTfhgBZCM7L9ThYHssN0Bm7UaqyDP2tEWgUaTz3La6ZvVShv7rTHfALfIgW
         EevA==
X-Gm-Message-State: ACgBeo3tjgHk3PTP7wBU8f2w19M/4AnTdZd9XvdN2rKaK8TAXWYfjf/v
        nQSb/NC31oUKyEzOzvbo8lVHjkSObu0=
X-Google-Smtp-Source: AA6agR7/XKS2w/Dh/O9U4i8N7mn1O0jFr85/KvH6oVqah5d9W1RAF6nXjwbgDyrFOrXyzjn36pcW8w==
X-Received: by 2002:ac8:5d49:0:b0:344:7275:dd61 with SMTP id g9-20020ac85d49000000b003447275dd61mr28899304qtx.48.1662140208206;
        Fri, 02 Sep 2022 10:36:48 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a15-20020a05622a064f00b003437a694049sm1413922qtb.96.2022.09.02.10.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 10:36:47 -0700 (PDT)
Message-ID: <58c182e2-13a0-0512-921f-34368a513979@gmail.com>
Date:   Fri, 2 Sep 2022 10:36:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.10 00/37] 5.10.141-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220902121359.177846782@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
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



On 9/2/2022 5:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.141 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.141-rc1.gz
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
