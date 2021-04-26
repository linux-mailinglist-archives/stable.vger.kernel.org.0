Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AC336B799
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 19:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbhDZRKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 13:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235308AbhDZRKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 13:10:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB77C061574;
        Mon, 26 Apr 2021 10:10:09 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y32so40467710pga.11;
        Mon, 26 Apr 2021 10:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zuB8XzhZgx1feYZQ3hKE3E0FpvAhK1clI+xF7cNImtA=;
        b=Br8qz121RbbXEBvunTTjqCTfPuGsL/1K72Br6f7r+GGI+m+SlILB1WPjFXGj7SFMWC
         GEmVzHF2TvTOWPbDKn32jFwOW06aom0TZpSKaGOpgSJSlnb1bfgFMKWIixC6PPey/JFN
         y/SRorwzYn6+lbkYxqvgOLV6I2ihCY8eNQgTvlChbYkQRoOisWiNpSZbrFTqWtt+LoHF
         23/Ps88DKKJYdBFD0WULXRffUpBVrVvr1Bfe+fgHTesVXP9XonYqHHjrw2sV8QeNL7pE
         ezXTjK3cd9sJWIU/07/6nPyXqADTTEVBqFwacir+Vg/FUpF83DAMChPKQ8ZBdd00vfms
         TDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zuB8XzhZgx1feYZQ3hKE3E0FpvAhK1clI+xF7cNImtA=;
        b=CGUwBUZIBQGaiVD6OnhStK+HYG+Blv6zVA1MJYTOCKW5u6JBKhRjGEFmBFY+ttlz03
         VR14q8NyDowtNbFwnlxhIhxKROlQWr/x1aQxCN9nsdbMGB8Gjk2P7FRReOAQjtC5/gUV
         LK2w39KMQuVR2RInIut7HxKeBbyqZl9edYw4MTcOpWhRW4xQEoe63bi+sUzK10rs8fMT
         c7HQ6+d+KQc5AWIRFF4m1Qz+oVkU2Ew5tEX7NHI9ulSSmht79pzyjG+EJbuFS1D4r2Ui
         RwLcwyd2OGt+FyvjS90hf0e1DdcnjQekjGePm3izL9CR1LvnXr7eYd0kAUK54ZmccEJb
         FRUw==
X-Gm-Message-State: AOAM532v1s5s6tR3OVmz6jPJCMC/jwqyCqnYrUYhFR8T3dktcfwuefUC
        KONXJ8VhHAEi1h0yDyBQcRK+IJXGZlU=
X-Google-Smtp-Source: ABdhPJw6qrOLWcErT5a5EQItixWKY/s9yhcotyoiXH7LTpJWOCQPOkQpJ1QHUCuJ8K1jFTIX/ZsAkA==
X-Received: by 2002:aa7:8888:0:b029:278:e19f:f629 with SMTP id z8-20020aa788880000b0290278e19ff629mr2175856pfe.57.1619457008185;
        Mon, 26 Apr 2021 10:10:08 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t19sm321732pjs.1.2021.04.26.10.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 10:10:07 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/20] 5.4.115-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210426072816.686976183@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0762af4a-9c28-1fb1-5594-240e2f05aa81@gmail.com>
Date:   Mon, 26 Apr 2021 10:10:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/21 12:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.115 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
