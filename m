Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002423D3E83
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 19:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhGWQly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 12:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGWQlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 12:41:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46635C061575;
        Fri, 23 Jul 2021 10:22:27 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so4595660pji.5;
        Fri, 23 Jul 2021 10:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oDwCL02ST1HyyrzXV52ZuPzIuQPAJ7yqctOiLr2rYbU=;
        b=SUieFDHjIOGuh+2NjChbZRdYw0TJcJIXrVt1hbBjXX15tKaU8fYuXaITEH7+mHzE4O
         4f4tGMyEOOw+ZncG0MpTToswsQxJ/KNR9PMepe/OUhIyPfaEmrYSTzz/XYPhfs5j7mCP
         jlSetcaiJuTVIVWgTxZQcXBYLShr2Bt/C/m3equpVxseG1+N+ymKlHay5fsQV/2hA37Z
         w5px4cmcMz3+uHzHDJfBp1ASiVmI/IN6z80yycvFA5l3Wdh89iSvPxDWu8GstAtcMgal
         Rz0cH9JELD+6KQHfj/T4gbZgWQbyZxYX//Pw64cueHWlaUafbOjf53rlF72BUg9fnq26
         /CgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oDwCL02ST1HyyrzXV52ZuPzIuQPAJ7yqctOiLr2rYbU=;
        b=Na9h9uFKlSzMMLt8djA1ugEIUjrAFx0tLvtztVyI1e6swg9yg26oAmWbyrMRmbaA+3
         cd9J9f7gnyKGy9XWIzfsLLnswxryumWjtiWsD5SYZZYzlFTWawx4+rdc3BIrQZb82lLF
         JLxZaiBUIJ/aI1IWBsJxcKSN0ggWusDf2uAiwLEt7l+FyiOczIZtyZM96sHcZOe/3FOb
         zNw5jBALRhzGOj0GRJXtJ3MVLEfDKN3Vi/3vRBm4tfBnoteqIwSLv8w3PCuWlZesHuow
         w9JBTkEykxugDLSjR6ycH5DtV5zRV2VtevF1shq5S2KUa3XMOktmgBQ3dFt1OoRHCrH4
         Yu9w==
X-Gm-Message-State: AOAM531nBhyjL20PcjWiR2sJoSZLE51FNY1ibTNbusZWiVK6UYym/sd+
        9QiUlc1loD32RDLwOGJ/Mbwpo9ExWWg=
X-Google-Smtp-Source: ABdhPJw6aHfNLqDW0gl+b5r3zBSdqz00TlgeD2pWobzcbvAFa+xRKFrCMaQLR2kkEQg63/humyGaEw==
X-Received: by 2002:a17:90b:20b:: with SMTP id fy11mr2820845pjb.79.1627060946352;
        Fri, 23 Jul 2021 10:22:26 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o184sm39238383pga.18.2021.07.23.10.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 10:22:25 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/156] 5.13.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210722155628.371356843@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6bbd4f54-54f0-2a5f-f5bc-a1247f5f86cf@gmail.com>
Date:   Fri, 23 Jul 2021 10:22:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/22/2021 9:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.5 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
