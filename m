Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1D63E33CE
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 08:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhHGGmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 02:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhHGGmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 02:42:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9B4C0613D3
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 23:42:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso21359292pjo.1
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 23:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dWtD7lWvg6ukiwjgEZEx22lskT3PyFWcdyyNdMYnx0o=;
        b=DhWa8crZziO2TlIBywaSyi6P3fiRzRiCx81AXFfUlBmsJrYOOaNHwX7DmWnb9P/1gu
         mwQ2+iJqKLTkXVWjBQfAU1BZt4jYwMQdc2Ud3uMrvOQiSOVwwByHp5CiXvGZt6T3fl8H
         iNipw0G3W9xNCHcIaA9vkLVykLQ5do7RGzqnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dWtD7lWvg6ukiwjgEZEx22lskT3PyFWcdyyNdMYnx0o=;
        b=b6wVCT4Eecw8VdLwtSCIY0/9+E63HhLEtGBbOGhLGZCSBaU/GtorZnu8irB6BDJ41e
         N5yCPLpV+K95oLCkOWkJVemNxRbMAActdGKbqUdtiuc0WAq/nomk8Af3FlTPSGA5pQ2K
         9H1wWqlMBgdExy0m8p+HjMAIOKw/rdA6LYtOKc/A3m3UgY0Cozpbz4YaB54hCnOajJlL
         steWqZ+QGVqRZ3frIdSnukEI2LlPN5s20iUBuUti4FshExRlBkx7on0gg9YctO5CK6Q9
         W6L1335sF+kPmdI7Qlo5UkLVKGc8sPKhk/zyqtARWz4UM973S5PcA4jWrRxA9m6lE8Bq
         Q3RA==
X-Gm-Message-State: AOAM532nxShKLHmVn1ytx07w3XLB6/Zxq4+E8RByLl1nASNGqtMc7NW0
        Q8q+8Xp+GHPX84zqRk2XOnEQkg==
X-Google-Smtp-Source: ABdhPJxcNREsbU1DMDK5mJy0lETd6o+p1t9Os0mLrT+itxLEhJvlZH2+ErJ79gZRR4QBQVL1rYeC9Q==
X-Received: by 2002:a17:902:7208:b029:12c:9c9d:e0bb with SMTP id ba8-20020a1709027208b029012c9c9de0bbmr12144627plb.44.1628318539669;
        Fri, 06 Aug 2021 23:42:19 -0700 (PDT)
Received: from 1d975be6a764 (194-193-55-226.tpgi.com.au. [194.193.55.226])
        by smtp.gmail.com with ESMTPSA id g1sm14315943pgs.23.2021.08.06.23.42.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Aug 2021 23:42:19 -0700 (PDT)
Date:   Sat, 7 Aug 2021 16:42:12 +1000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/30] 5.10.57-rc1 review
Message-ID: <20210807064207.GA3991@1d975be6a764>
References: <20210806081113.126861800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 10:16:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.57 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Run tested on:
- Tiger Lake x86_64
- Radxa ROCK Pi N10 (rk3399pro)

In addition build tested on:
- Allwinner H3
- Allwinner H6
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
-- 
Rudi
