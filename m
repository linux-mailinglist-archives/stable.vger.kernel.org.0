Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3CE41858B
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 04:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhIZCVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 22:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhIZCVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 22:21:13 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38CCC061575
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 19:19:35 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y1so9223286plk.10
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 19:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ilIm1jM+ouXaVYUrUiQ6VhJR8B0MRPYV8/JE0W3RqsI=;
        b=iIyAuuLl07xkYz0eqRXk1hTSYyBvLlQV8BxQtdTrpbcAWwxC3baLhQE71Bjw5VGcIu
         X3I+pV621c1Z5/UiDX2WWkN1arun7C0IMxwAOj6abP17u6Dl6fcQTX0wXTZrYPDW/Tcy
         nYeEhV8/4sFG2LZa62ncLt1aujP+cq2zS/7GA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ilIm1jM+ouXaVYUrUiQ6VhJR8B0MRPYV8/JE0W3RqsI=;
        b=0ruLfvX4aDhuwN98b2+yyD1EwhuHMJYVC7HfhwUA5l37XwQrIMTLYGQq6PRFLFH8Qa
         XmbKJZS71dAf0DaVDUr+CRYGYBK+8clkA31JldfViCEXiU6oeSFpnKXpGj+IHudcE6jA
         hY8PoOcFhsWrzIzlniPEX/VaTa3WgHJTD1qcFkzi+RYwWpig2YFbxd0uISTzokw4b7EF
         jsOW8S4+8MCd41kPkh+nv1ENhBElhf0rwTxLrhPTyxxY2FeLP1Dvf+PZr7PhcDuscTw0
         OrHNCSbaiUTBF7tt9O46yWz/zDffMtbeZu6wqOIddnvASF3FcETAMvuqoa4180n8Ml+D
         c5hA==
X-Gm-Message-State: AOAM533oQzWhNkt6XEXcomcJOTbmdepl2XElKICW2JqjAzXXEeiy+dWy
        5Hrcvs23iXpKOqjNl9x8TDtXMQ==
X-Google-Smtp-Source: ABdhPJzue0jjwas/CMV21BhDClncKTYZ8qqGLRFryx/3/LgMzuOLPo9l8kHf84PznW/qKdTj3CPEag==
X-Received: by 2002:a17:90b:8ca:: with SMTP id ds10mr11287341pjb.68.1632622775033;
        Sat, 25 Sep 2021 19:19:35 -0700 (PDT)
Received: from 640de500d870 (194-193-55-226.tpgi.com.au. [194.193.55.226])
        by smtp.gmail.com with ESMTPSA id g9sm12762478pfh.13.2021.09.25.19.19.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Sep 2021 19:19:34 -0700 (PDT)
Date:   Sun, 26 Sep 2021 12:19:27 +1000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/98] 5.14.8-rc2 review
Message-ID: <20210926021922.GA1095770@640de500d870>
References: <20210925120755.238551529@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925120755.238551529@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 25, 2021 at 02:14:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.8 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.

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
