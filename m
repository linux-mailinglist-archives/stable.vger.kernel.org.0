Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F07648F270
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 23:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiANW3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 17:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiANW3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 17:29:25 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63F8C061574;
        Fri, 14 Jan 2022 14:29:24 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id t18so14260964plg.9;
        Fri, 14 Jan 2022 14:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YG1lkdK9GCzFK3SW+vuZVT12lBuPl7qpeTukaGvP0Og=;
        b=ajOxf6M2NUUG8XMS/rYaYVlgEr9b8eIgITnKv4u4yDKEwwDwuRUh0Rvt9H4BLQghUw
         IID947mKYQcDroD2mRPzUsUa7sGDBXA4XLnnYmdulR1sphqzJQ+i46Jy5ddPy2xdKeo9
         VzybNUapRPVhyjnWI8u4jEZar2eAwyV6x1d334p42RT6ZzVO78lrp2SjP2HC78lpOaGV
         7EQ3zX4oZHBPCb8ejiXupRuBUUZQHMwhSEwBz3gUUEs0abkrg/9/b4TcVV2nBz4KbdIM
         P41W2CJhPNOCCaG/HNyxRxPz5+/R+I6OJY/Sz5GTc6kUO/hN6p+32zuAqEItyz6ZrT8r
         cuug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YG1lkdK9GCzFK3SW+vuZVT12lBuPl7qpeTukaGvP0Og=;
        b=bCMCGmIjoXy8HQ8dGVnXDskK0ebJbfRW5j9nr5s229ZdssOdrxRXLEdBlf1cLcZDKZ
         ThHmIn37l2KD0apJuwULJkbxkRv4b340jTNV2oTIrha7fG3RJ+fNdWNlve4D+tV3pqiH
         PlDL0sLIYyrg8jAFKqH3xPALeZKKGy33v67BcHNxuokcw7il8gn1sN1TcLtiF1Y4jxAZ
         Vk9FIzqQHK+R8OxKelKjaFQCjU1NCv8Be3gPO669vmrq5PrM1z65Qaah9+xmYH/+TSh9
         bNkKpkqa6wDtrKsAuMbxMgUuM1WH+1TT93enx9zlug7daY11dUnVMxMgrKfUQzH/AbgJ
         UVog==
X-Gm-Message-State: AOAM5318UTBFXTJzF6aCYKRxrBiBH+qP/OUHvi2hwW5qJ6cx0esegAe+
        xT2HJn9fZ3+4sct+0mcbJtwKm3mu/9c=
X-Google-Smtp-Source: ABdhPJwF8VfMfSkfjWLaLdbR+Ix3RoXjSWV3kWkumBzaOy5LUHi1AUWE6pGSebXkJ/cQRnVaOsC9bA==
X-Received: by 2002:a17:90a:4305:: with SMTP id q5mr22666725pjg.20.1642199364080;
        Fri, 14 Jan 2022 14:29:24 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j17sm6452841pfu.77.2022.01.14.14.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 14:29:23 -0800 (PST)
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220114081545.158363487@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b9060630-277a-e0e4-aed2-d2ca6e9deb67@gmail.com>
Date:   Fri, 14 Jan 2022 14:29:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 12:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.15 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.15-rc1.gz
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
