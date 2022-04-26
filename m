Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF04510351
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbiDZQcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348312AbiDZQcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:32:47 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A6018EBCD;
        Tue, 26 Apr 2022 09:29:39 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r83so16504241pgr.2;
        Tue, 26 Apr 2022 09:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XnYfmfXIXTwG573YfjtiWGvOnd0v8Gv+8m8k2jASnNk=;
        b=nqnEGc1BvjEqIWGyX2ZPh7iG09za7R8ySn3qhLamZhGh1ysRywR8A4zZCXvR11OVp6
         imEMGHVqPoJWysC0Zk8pD9HL+Tb/KHUlSjI696yz/UxqB0127dxq8L7fDvtJyaltheR/
         hhgOX3XFupckywHNRCn1QyvDluB7/Qs1UzLqN6vny0J5cyMdHiv5INzPCJPJMN3iyC1w
         5OvEMUUAyNZcLIEuDU0zi7YzzlQwv9/mIodbAF2OVhNYMjBDGavZ54oVqJe7gXsLQw6m
         xG+kzJR6VRdVB35nChpfrW4W6Ez99QArs4CkE8J2wrSt6VGMyf3y0ZYBV8aOl1zjha11
         owmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XnYfmfXIXTwG573YfjtiWGvOnd0v8Gv+8m8k2jASnNk=;
        b=scnWMP1a5e+sosAkjDux07asFGnf/WXPdGND3wmFbgmqYXxJjGEWDi7/Tbgc2w5MIR
         wjyod7JUeB7RUPb7ElzgMn+bP6O+KhzX5rmyIhvd+q6FAyBnp14iCdYlWIgnqU5PJ/2W
         sAH2G8KMFLbZIy1SqCSjrI9KkgdhgUpEC0IPd18hn91YhrWeIf1MxLq7e1hsOUdULeYN
         ktYTG9GhhdRHAtmJKta8oIyIiwlSESGlb1nXD+iqlurMrUP/rIDSDB0Q5BKJohYsGpvY
         5Lr4owjvlh5P4b3am5yVg1cEMnkKcRuqlARn3z1ufrRHXYhEj5bp3lrr+YJWkALP0BUf
         Ai0w==
X-Gm-Message-State: AOAM532QzMhCIMBlpiwNA/L2vS1kD7pl0g+cBcCag099oPD6stYFev4G
        75QAzyVqgw9biGSXgn0n77I=
X-Google-Smtp-Source: ABdhPJwGMwAhWNEMDsr5v//C8bCcVsTOizrU0Pcnc1yyuJ9ub4Xt8zDlMNJKjhxVyvTZ5k63Pi4CvA==
X-Received: by 2002:a05:6a00:2349:b0:4fa:934f:f6db with SMTP id j9-20020a056a00234900b004fa934ff6dbmr25316596pfj.44.1650990578865;
        Tue, 26 Apr 2022 09:29:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u12-20020a62d44c000000b0050d17e069f2sm13143984pfl.10.2022.04.26.09.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 09:29:38 -0700 (PDT)
Message-ID: <e82ec73c-be79-7fc3-2ad6-3da7942c91ec@gmail.com>
Date:   Tue, 26 Apr 2022 09:29:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 4.9 00/24] 4.9.312-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220426081731.370823950@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220426081731.370823950@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 01:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.312 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.312-rc1.gz
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
