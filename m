Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A931C4808B9
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 12:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhL1LMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 06:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236438AbhL1LMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 06:12:34 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F55C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 03:12:33 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id n16so13364508plc.2
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 03:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D+dYd0M066OG9f10N/Buwp7BkXPVLlMKzg/PxUAMOmw=;
        b=kBMDKYBvakLXv6qTyhsqUwNZy7i+6hGbY5t3LUw1pSTvn+1LT26Q7y9FBOwkv2FWXw
         yPwpObRiN0BG4pqtsPTBcFIoJHX2LfxG89kLypxHRBR1emnHjyfuDEGj+WoMYVVK3Rf4
         n3vDzbuL4kfVuJUhZOrbJGRK5xoC1ScryYplQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D+dYd0M066OG9f10N/Buwp7BkXPVLlMKzg/PxUAMOmw=;
        b=TmxWTxG9h/8M5poj9pFfCMddMt7N9wdmftLQ9kqhOBYeGxzjWiAw9XqJpNjP0HOvzC
         InMHc0c+YL1/dkM+9rwF1oNWS0+eyyrFbb0yNEhtLk2ZZxggK4UDUUNegsLBmleOzTjY
         7LxNjVhmDJXeIyzODtu87sNm0JP5W3ubAr6AZfbs6gofLLs7J8PdIH01+Qn4wbHxV8MB
         vENi7u3vMPmG3c0gc1ZvYMLahDiEhnvl6dWtr+gL7j6OwlamuOUwAlSNWWo7j7iuA8+z
         mdIE9dgLKZqJ0/1ujayefXSFx0r3jeE1YJBadgAahoKDVX5SFfhQOx/iIr0CaSRV8Umb
         WZ3Q==
X-Gm-Message-State: AOAM530g6uKHUIzzNJnOT+nYvgQScNI0A9LvMAHal+MkvhqWRo0Yolh9
        NqBBXZRl22VfICcxrQByDPe9Nw==
X-Google-Smtp-Source: ABdhPJymnp/O4GHxG+dl3D6czNoZ1w0DP0gS+0aRIqbjeuvw47IuvKJwXMiK1ctvOT9F9/DOkFksSQ==
X-Received: by 2002:a17:90a:fa12:: with SMTP id cm18mr25695470pjb.141.1640689952821;
        Tue, 28 Dec 2021 03:12:32 -0800 (PST)
Received: from 32c720d4cfb4 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id b21sm18798277pfv.74.2021.12.28.03.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 03:12:32 -0800 (PST)
Date:   Tue, 28 Dec 2021 11:12:22 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/128] 5.15.12-rc1 review
Message-ID: <20211228111222.GA653610@32c720d4cfb4>
References: <20211227151331.502501367@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 04:29:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.12 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

Looking good.

Run tested on:
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition: build tested on:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
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
