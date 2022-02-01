Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE054A59E7
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 11:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiBAKWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 05:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbiBAKWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 05:22:24 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB76DC06173B
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 02:22:22 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id n32so15419900pfv.11
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 02:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CaMzrp6CD4pfO3e5Ep+eXwdfnB7JTyIu6P8uVnKFFrU=;
        b=N1oMf5jw9LrwWQqfKsvprnVPewxZi/NS23yhShpDQrHhyP4UqzhPdVOcrPSFLXxXIH
         62JXGjyJCiU2eBsVqTUZYoC7bvfprbX4GDY+hFEGwYJwDodhkzXRRV1S4bkwZhrcV1Vj
         NtOoJdDCMQSDaRdqTkfNxtPDhTueWaSTAr240=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CaMzrp6CD4pfO3e5Ep+eXwdfnB7JTyIu6P8uVnKFFrU=;
        b=nZ4VgolWyzStdow3PzkcHowmQPgga8R7g4kDfDJvk08WZnR1jj+shgqOW7OT/DrgB6
         Zirqh4dm74AqGIhlAoBIgbbZ/19+Kgs/PLv1jU4J1Xduc8Vb7gyM9ZtoZOw6B3FcHigP
         a76nk7VKJ5ix0cS6lmaOvxp2HUnsZp/bRUExsSj0PpMZTi0aU5bXQWJ5/oc9ZV1xTsoD
         VsYVZWNwJicvyZ/f7QWWHuRuoPdVP3U5LZU/6haikZbZVAaAFXYYqxEioFCFZVBRv9pT
         COiIXQQYJpv9twdh/WzxiPdC8VBAiDnv5Qd5YbqktssfxaGqDQu5UPHDSci5jES0YPKt
         eNfw==
X-Gm-Message-State: AOAM531QHiouqBcGQ2IYwPpvl7UjZY7BA1PNVeIzxxoybn1oUcfM5D8B
        l1s/4nEMObHJ/D0umFmmTDAuFw==
X-Google-Smtp-Source: ABdhPJwpqj5Cjaud7YJwIt2CFU4GZOe/GYVTB6r+TfkTtxWPKJ5Lduqatqn4YkysEWKcyD10QGxLHw==
X-Received: by 2002:a63:e302:: with SMTP id f2mr20232686pgh.451.1643710942130;
        Tue, 01 Feb 2022 02:22:22 -0800 (PST)
Received: from d7a09e6e3461 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id b22sm22471758pfl.121.2022.02.01.02.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 02:22:21 -0800 (PST)
Date:   Tue, 1 Feb 2022 10:22:12 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
Message-ID: <20220201102212.GA26@d7a09e6e3461>
References: <20220131105233.561926043@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 11:54:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.16.5-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested on:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
