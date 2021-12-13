Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BFB4737DC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 23:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243827AbhLMWq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 17:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbhLMWq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 17:46:56 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5E1C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 14:46:54 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id u80so16213328pfc.9
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 14:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=16ojLEvFQl04Ei9TwQDGXgw5cA9A1Hd04uE1XtujZhE=;
        b=eH74KyAHe/mA8Q8X+xDnsgG8JgbmqRfEYay6bnUoN7XWh18/SmcVwJvXDQk/TLhl8D
         zqTl6rWavB+tFr+gEbXQ9pjJqTKKB9WqbIQqAzmp1TTmDRW7QNT13eSZlmnmZcOuTIQ9
         Q5tjNwxko0FT90JMdpha29ZKy+yeios+hTMHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=16ojLEvFQl04Ei9TwQDGXgw5cA9A1Hd04uE1XtujZhE=;
        b=wIRUlBhA7y2+IZYdKZP3tJGiyEwxG4vO7Ztz0Vn6iasTCiax3cL4ssAAv3DLGxM6Ly
         0cUwMx4rPgRYMJ4ffbrZQ5DAvi0p94NgXCmWpL14iKIn5rb7ksX1rq7XorFs49GH1hXq
         +tuwmGHqCjo0BWvLfLP1kn2guJgfguYMrFAHiR+4dtM+iKTy1ivN6ytFIwxU8qfoUdao
         1ExrhqGGfF+YiPeqkr8GfBDi9OGARKG1LszpVZhnVcnw65eM/R1M5jFInNii6KbEDe3k
         ClQ8Yl7xs4jREXOs7ouxZ5dCqYQSV9kq/ciZ4obp8nZ1fupUpwUIfBU2TMBA4maD/uen
         P8iw==
X-Gm-Message-State: AOAM5336vYplhhMDVyuQ/UeZXxX7zPxlqnuP90xZ3kpqyR7UbHinJYrG
        JGh7JnXwUhy0nt5SCFCXhDCJJNUaGirWyw==
X-Google-Smtp-Source: ABdhPJyzOzLg9ARyBlGN7LujMGC7LWQm/6ZQ4WiSneDVV9V/fdbVX9Apvz7R9ldOkXPPammi6eiyyw==
X-Received: by 2002:a05:6a00:1248:b0:4a2:5cba:89cb with SMTP id u8-20020a056a00124800b004a25cba89cbmr1044578pfi.12.1639435613557;
        Mon, 13 Dec 2021 14:46:53 -0800 (PST)
Received: from d1609ac33027 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id r16sm11101963pgk.45.2021.12.13.14.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 14:46:53 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:46:45 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/171] 5.15.8-rc1 review
Message-ID: <20211213224645.GA8@d1609ac33027>
References: <20211213092945.091487407@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:28:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.8 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.

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
