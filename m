Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D24F379236
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 17:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhEJPQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 11:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbhEJPQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 11:16:03 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2952C0611C9;
        Mon, 10 May 2021 07:42:58 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p17so9221033plf.12;
        Mon, 10 May 2021 07:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uVw3wvukRQjrsLK2st7F2fMfyD602tcKtTD7xRY236E=;
        b=Sr2UcDVXDe6y3MRHjPbch/SPAhGutpkt+BiyrXzLEjT5rvRpea1aFX0TKZ7YYG0IqP
         HgSfQhE0A18Egc2NecF8AXEDx22DHsazUD4gdzeVvGyyyuKAQzr3mbnW9fqZHzMgpPjt
         Q+SO3SfUc2Mqj0+mXovTPkRfJ1W94jwxigavcY7wgrzVsCI/Iyo8KAOSetlY1N6P/O3e
         iKADLImRQtewhaYgmtcKiH+jrI9NaVpt6PZaKgMgP00it/gSgQ9dRmDy4eTuTwF7ZnbR
         f/zUQCvoNoq4WjzHmjeSrawHhtCEVDiDegjrvQ5MtisAYBX5Pr5mSlhmf/js2kKdfVgt
         y2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uVw3wvukRQjrsLK2st7F2fMfyD602tcKtTD7xRY236E=;
        b=U+hPahg0SmB4WJ22h5AuSxt/J6dSI9Aqk+FSkWRClS0MImWj1aSjp2CxIyLgF4xsik
         V8LJ9eWT746W73E2seJ5yLwPG9w7C78hp/OJqbvd5BiVOm0tuofp6atJWKvExNT9WlQM
         R4YphJsbqX/9mdRPHxijCBwmc0nIE4uR88ecE2DeqIM7247ae9eljMuIkEjSJNfMiXug
         ccyO8tA61UbmNtdnhK9uUkvAv4MD/8k6c268GK3GfdvZDBsHjfzhoe2HJ42a+ynhMGxI
         6bgEQOno0RCZqYFROb2WIa3DHH7Yrgx1FNBwaSF0a6Wl+chH3PcQdQBmOcKpMD3j6eBK
         ebsw==
X-Gm-Message-State: AOAM532G5s/kqaeEkqhmA/S7Bnv40wk/dW92Ou9ea0BfzUa5hDwNiBqH
        +ag5/oAcd5CF2F3Ry5qMydHbpbOrecY=
X-Google-Smtp-Source: ABdhPJxb9IXDb2QRgTS1FkHRcjIcnbYopNctPvX2SCIGMDqp4zhEb4ISB3BKITpTKINS3esnUAi6EA==
X-Received: by 2002:a17:902:e84f:b029:ee:cd36:80e3 with SMTP id t15-20020a170902e84fb02900eecd3680e3mr24951971plg.70.1620657777898;
        Mon, 10 May 2021 07:42:57 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id v2sm2313635pfv.97.2021.05.10.07.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 07:42:57 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/299] 5.10.36-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210510102004.821838356@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7534d969-6900-d8ce-e1d1-44dd2c972c50@gmail.com>
Date:   Mon, 10 May 2021 07:42:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/10/2021 3:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.36 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
