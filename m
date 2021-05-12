Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A75837EDA4
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387898AbhELUkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381592AbhELTep (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:34:45 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6242CC061574;
        Wed, 12 May 2021 12:33:33 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i13so19511185pfu.2;
        Wed, 12 May 2021 12:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CtHNkomvScSZ/Zj8c7hB1gXX93xa4VU3ymdVcHoZaIw=;
        b=meXCsGDYCzphICBFoPwhalWvg1fWkq/2IzzUeIU4nulf0YfAkbpx010KOeHA/85Eui
         7tTjitBQzqnXbxyQf1ymyh3WrjxbIgDdZGNTMMskCvFv12DzHBTsUvCvv0nDwlfR4sF2
         WBwU33bp3H0wSHoE3VOo/GnzvW6ZtgekolXkbfVC8r78NKqEnUtjU6NWBkMXP7MJMh40
         hpuPNQNg1wQ0CivANGZ+DUK3xsqamtBsSvSRx+HFODTot2/zm4hLR6Fmm0/fydgxKwtp
         dbzf4nJL6UGssGr/P2CJ828hKyTZ6r4/zklIsXGXifiiggycw2LuahYuEY/DyPddYnYk
         M5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CtHNkomvScSZ/Zj8c7hB1gXX93xa4VU3ymdVcHoZaIw=;
        b=I+wCpKmlmjETAUnIk3Dl41xSG2uEQWMU/IK7Uvkxzvw7+Gd8c5sgbUwALNZDZ+c00o
         7k9rE8u1u5f9WG/gyVKEwCU6Y9u+VzlPh/74UM1s0Zn9CoDIhPW0Vn0mpe4whw9saxSN
         0yduxDCAVBm4vcfxaftGOfjRQBGLRkiThtuD98B882AfijiUOn3FJ+enHGqov90S30+2
         VL5UeQkDqkqtE1qX+kPNxacjk8LllZxprsQFrmbu3bt8cS08Sl0K6hzdCDm0xFGTKaOd
         Hzmx6zm2es8hUjACVjMNbyqttuGg1KFVMH+a6ndnPEO4M3hfZbVKZifqabnBd5rslxHP
         FkTA==
X-Gm-Message-State: AOAM531DEvwv+XZJqvQyBH5qUEfV1txBp8oniJK569QLDMY965xMIQly
        HB2PxPt4dWpNihRS9cSW60y+5c8ZeYQ=
X-Google-Smtp-Source: ABdhPJxhiYUoMLT9u2K+CgDwEi+1Clhd/BBxHBmpV3M0BC8ne1cmtxzeDXBo63Ri0Tbe2L00f4CyUA==
X-Received: by 2002:a17:90a:71c6:: with SMTP id m6mr119631pjs.174.1620848012540;
        Wed, 12 May 2021 12:33:32 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a16sm508091pfc.37.2021.05.12.12.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 12:33:31 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/530] 5.10.37-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210512144819.664462530@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e8f8f63d-a9a6-c6c1-1b90-5f2ca73181f6@gmail.com>
Date:   Wed, 12 May 2021 12:33:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/12/2021 7:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.37 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.37-rc1.gz
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
