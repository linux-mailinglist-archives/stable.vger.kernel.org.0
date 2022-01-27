Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A4149EDBB
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 22:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiA0Vtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 16:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiA0Vtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 16:49:49 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CC0C061714;
        Thu, 27 Jan 2022 13:49:49 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id e6so4060050pfc.7;
        Thu, 27 Jan 2022 13:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PVq8VEzp7BB+YcVe2qJ2B2b4gFtgd1WOfivtkdRTNe0=;
        b=a3OLvASA8Obgp+ZutimxKdlVcMj3Hr4UKP1/LppkIZzcFLOiWI5O75FHz7+3nj/etk
         zku+G2gnQ3Vxbg1kAOT5cIk9zmQz8/XUkIHHxJTR4kdBfRUKU458ycPYx1Ud/b8zAFeU
         dve6GIqga807odeTPSGONG30GfC5ZL6f/tMbvN/dIVAlEh4QSV7EI8vc/fGjxwCqnO9S
         rjV7UjIkx/n6+sp3Fs4ghKMV8beM3k1TczVsynW5o8k4ixZfK05EMpORo2ZIiihaGkwa
         /HXY1hGb6fyPMZNJcGzMx8mb+rlN5yCLCs9qOkvPJuHY1rQt+rvWeaOuvLsaIkIw4pw7
         Y+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PVq8VEzp7BB+YcVe2qJ2B2b4gFtgd1WOfivtkdRTNe0=;
        b=yY2g8Nd1tjiISBSV9zMrh+avG54A9lbql8/t73j4bkUDJmEBDxyNJw6t+WCGCboFZH
         AwAKpoiz3+nwYBKrzvqXcv9bpRpHZ9wIHfJzb29JcrOYFZB0BIWM6+naOojJaMRbT2f2
         R1qrH2/GSE0imGCrKInUIenmMOKXLfKKyq9t9ryWVViY9BouI7UlhaeFv64AmUIrUQDg
         4FNKmZrnl/UZNAYSf+wowlPG0qAnJ512+Pp5lYeurWJjUk6KOsAlX9lAYFsVQZoLBE8Q
         hrSv2RO/YdSY9eFltqVax84XlEqFjuym2EvYr4JgPeP85cND3UPIMe261YfuMC2guqM0
         2RVg==
X-Gm-Message-State: AOAM531jJdahWUNhU3B3BzOd7SnJ9Smoz855uK5B1VRorar4jfZOtULG
        Ys8j0z7cWD8wlT3OK5/tNrE=
X-Google-Smtp-Source: ABdhPJwrREyFPoZ0568NgBTdqkFbe21I2pkKUtM4ULb8YK2LBF7gngDNLnNZGq/Y5T1uj0vXDRa/uQ==
X-Received: by 2002:a05:6a00:1a4f:: with SMTP id h15mr4642156pfv.50.1643320188471;
        Thu, 27 Jan 2022 13:49:48 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id o4sm18209650pgs.3.2022.01.27.13.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 13:49:47 -0800 (PST)
Message-ID: <f2d95fa1-8064-5630-c347-e5a43f67f8c1@gmail.com>
Date:   Thu, 27 Jan 2022 13:49:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 0/6] 5.10.95-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com
References: <20220127180258.131170405@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/27/2022 10:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.95 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
