Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B45C35A6FD
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 21:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhDITW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 15:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbhDITW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 15:22:26 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9451C061762;
        Fri,  9 Apr 2021 12:22:13 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h25so4663940pgm.3;
        Fri, 09 Apr 2021 12:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RgncBYYDsRz+GYhE3ZylKnrhPbUvz3ZuExU8slQeP0Q=;
        b=E+06DeAHIaEzALZLgdEZxZ7Runvr+XNiN5eFXLOGOAWeot6gXWYzjP+d9h3fPNmJYA
         UdrrYffhw+A6P8x9RXIB/z3dvCco6koCA0uf4bkN8KwhXTzzVjrnGAqKkBzq1HPwlXda
         g6Gc1159sHQKD3MyBhta2UnzXb/PLjAjngYUNa3G0iVvAeac6BjeceG662+JlruPG2PJ
         frUIlAUN1Zt9DCdXFOU9V7MBIF4QixUKKT3P+0m4HuV8GcMtg8Yn5U1f6y4VSSleeyYz
         Dquu//BuM9+4uYxP/U2cF2JusQHi0EcxQeKCR7MfgV+BInJMgOMrPF2/6Ulu6aU80FmV
         60SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RgncBYYDsRz+GYhE3ZylKnrhPbUvz3ZuExU8slQeP0Q=;
        b=ONiVulBWrz9P5CjXJ8eGDa8YsYMSHvTq3TQ9G51BKmCKnrsPfzXgzTlUP67MCqIpwe
         2/ZSxiwzA4d6/s1wbjOuYhk3t/oKhWK/mwSB+OBck4+AvBD1XIWl9jO/4cQwCtQqQBLx
         j/17iRGxasTIs/nOJ6Fh1NwQ883PNdkZLUJBH2Aunb5yBzLXzsToQpNkuF7Zcvs0Vs6N
         3r/e2F7lZpXob0yalWulcj7DPPTStg9EgI2/2WFAygVUaoeYZ43Vk398hWrVsQevGiZs
         CfIwzV5RqsbCfdP1AuavgvdjItrjJIWjHyV4CUbaAighheyKDHQpPiEEYvIi7bGJanWz
         W9Ew==
X-Gm-Message-State: AOAM531L0FL48ZONqJlgWb0IHEwhnMjcLUBDLpiiSEVKmthLonrQnr4e
        fpFV5gtNca1QO1GRSqSmA7bTPHw3ZxE=
X-Google-Smtp-Source: ABdhPJw+9mKbgKWdFzUlaDL8dLM54YpJHGAlDOHjciF0ZO9z1fOC12ozDp3rSpPFuDaMgvQoA8tRtA==
X-Received: by 2002:a63:1a47:: with SMTP id a7mr14738749pgm.437.1617996133059;
        Fri, 09 Apr 2021 12:22:13 -0700 (PDT)
Received: from [10.230.2.159] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id c16sm2944443pfc.112.2021.04.09.12.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 12:22:12 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/23] 5.4.111-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210409095302.894568462@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b32ef28f-5139-869c-96ba-ddd19b52beb6@gmail.com>
Date:   Fri, 9 Apr 2021 12:22:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210409095302.894568462@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/9/2021 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.111 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.111-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
