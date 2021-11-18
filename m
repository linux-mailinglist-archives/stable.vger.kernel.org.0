Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AD2455AD3
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 12:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344091AbhKRLq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 06:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344144AbhKRLo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 06:44:59 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D07C0797B9
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 03:38:54 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 136so5134290pgc.0
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 03:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6xLgEfLcBRRNQuwWlLSMWWeHtLyuSN13BVRu4nzEte4=;
        b=lCJWdzw7Lsedo/Vtd5PLqEtvu5luaTK2boRMEY0wyJB8G1mnFbJu9WpT5f5/tb9RdL
         cAv5qVWn2XOEL2mhHKtfnOMOUUxv7T8aFO0K5y4tgDWhaxCdad8jvQ9BWY4mmxqB4qOG
         Eyq3siapPOQDZSgVpFspZHOnZERczoSWcXpy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6xLgEfLcBRRNQuwWlLSMWWeHtLyuSN13BVRu4nzEte4=;
        b=d+kYsgJjGbDS7PVOv8ZTGtznfBe3WgEZaOw3jpeE0uuN2mC6wIhVorQW6/40BWxksB
         SP5VvO6e1Vc3j4EXWZ8p3As2OU7IU30YmlChpjtvHJeMJ+ag8htQeMA+LZD9vU86O5wm
         1HzDOFqFDn3+2KqkKHWmBPivcvTD3nP0QIUuKZCqbdCiUUSIsAQ4MYcKBRANqAQsizdg
         dRb3NLG3MpeVIDOgFnmGZcWICL3GtcExeSITeWhmi4PoA5WD2Dm+bcN4Fb3okqIFBCZi
         IblaXJrd+q8JKvcMIriVSFX36vXkgcz+44I5/IpOcj4ERXoh63gvwBKaLcVNsSi6tp1z
         wUaA==
X-Gm-Message-State: AOAM531LwXmPJAOmF02ExeHyxNRRth3yS8LOdH+3bejxPCncgsrSmerR
        hcYM0Ma9F1Ud2rOeL+wvKKIL+A==
X-Google-Smtp-Source: ABdhPJy0W5qUU9LUdgLqQPn8GP7y5qgEhPYfTrtcvxChO3VnSfFtu14dif31/WgJCaCfhYaD3FoPAw==
X-Received: by 2002:a63:c143:: with SMTP id p3mr10815154pgi.366.1637235533943;
        Thu, 18 Nov 2021 03:38:53 -0800 (PST)
Received: from d7627578aa75 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id j188sm2774451pfg.51.2021.11.18.03.38.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Nov 2021 03:38:53 -0800 (PST)
Date:   Thu, 18 Nov 2021 22:38:44 +1100
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/920] 5.15.3-rc4 review
Message-ID: <20211118113836.GA21@d7627578aa75>
References: <20211118081919.507743013@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118081919.507743013@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 09:25:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 920 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Nov 2021 08:14:03 +0000.
> Anything received after that time might be too late.

Hi Greg,

Looking good - rc4 ran on the N10c (whereas rc2 hung during boot)

Run tested on:
- Radxa ROCK Pi N10c (rk3399pro)

In addition build tested on:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Intel Tiger Lake x86_64
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
-- 
Rudi
