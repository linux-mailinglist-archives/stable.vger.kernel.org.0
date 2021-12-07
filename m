Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6030946BC24
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 14:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhLGNJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 08:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbhLGNJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 08:09:27 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2EBC061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 05:05:56 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 133so13731189pgc.12
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 05:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FI2qt9CjwRrs4Tfemj8rDZNzeo/YDjtuHCbQrgegDa4=;
        b=Ff27IpankODa1HIFnY22UfOVCC7xNm9fN8nnjh0EkeDEjM6E7NLthQ8mM8bWDWoMWx
         Xy+RpC0cUYg0Q4TXwqk892ksP66189yQunoYgibL/EgYTuptQCz17O+hnqXCvd+ZTz1q
         KECDgk5JnyU65Ot+7GrU6bIC7i4AQEGyo5AME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FI2qt9CjwRrs4Tfemj8rDZNzeo/YDjtuHCbQrgegDa4=;
        b=jBq0LKaQeB1bfkvYa/RSdctNOa7cSSuosKOKoa+BgsUvuJg07c8DytzbHcH4qBsc8h
         GhMETPTNDlFFov6Fmdxd1H0M7jbIXWH30C/w91Wa/NH8xmY237Jaww0XLKNnyhmn6tkV
         Y7Ae6+uVbfx1bunk/FtFcu5D6dh6rP/CZCPiokuN8vn6DWbmVnROW2MhYyrqXxH+AYvc
         VCQBkDxSiTGutlSFyyWZz1ODamo674+MMfHxA0zPdRFJAehvV07jRnoQWpws1wKuWAjz
         bLU7WgexcBu96AA2H1eElP3EovlkrEOG9vXcxihTOpkv0wx+S36y3P2idfhjqQt50RIo
         KJZA==
X-Gm-Message-State: AOAM531h62nKpxpa2wiCRyn2Kzc5noFq5gjsSgehAHVAmmfMJI0BOJUt
        vngSO0qW+mc4/z52FNcuLXMisTRkwRnjVMAb
X-Google-Smtp-Source: ABdhPJy74Oo/xXy6Vq9HMkveYiPrIvtFwzoSgLOZDWADx+BG61TDesJcSn6OGCIN600lnUmnhoJQ1A==
X-Received: by 2002:aa7:88d1:0:b0:4af:844:8be with SMTP id k17-20020aa788d1000000b004af084408bemr8627109pff.43.1638882356424;
        Tue, 07 Dec 2021 05:05:56 -0800 (PST)
Received: from 47cfd395a522 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id pc10sm3181836pjb.9.2021.12.07.05.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 05:05:55 -0800 (PST)
Date:   Tue, 7 Dec 2021 13:05:47 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/207] 5.15.7-rc1 review
Message-ID: <20211207130547.GA1565144@47cfd395a522>
References: <20211206145610.172203682@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 03:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

Hi Greg,

Looking good.

Run tested on:
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition build tested on:
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
