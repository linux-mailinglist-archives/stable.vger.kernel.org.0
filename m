Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A743747BE7E
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 11:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbhLUK4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 05:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbhLUK4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 05:56:54 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26259C061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 02:56:52 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id z6so11387895pfe.7
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 02:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5NCsrps1VB7zv4WoOsC/DWIopmzq24bKQXov1cHCoSE=;
        b=dgYeMu7+MhdFVkYweWszhr9AQkrcGVMxp3EZU07VL3Ok8r0pvZuPqMBdnnjJuHsqm+
         7BZoafwe0BJ2Y5+SLIFInQntcdXSMHGZg2jnjHr3juw6D6E5kjFkLcnUbZpIG6qa9TyT
         Reh6AibWU10O/XqE9fNEjAo85ByZSqbJAj1EA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5NCsrps1VB7zv4WoOsC/DWIopmzq24bKQXov1cHCoSE=;
        b=LLYK9d1faimtrkPGna5n/40RVCIuO90m0DNGXitBg9imAdrrKz2Xl0VVF9u7n4qERs
         AjkVxm+xMZYHfwJK/yt6kvuh7HUWGH0xGn83EVWAEr5ojVSOJcOm3EcbVNgPJ9CuVRsC
         JXaudnwG7+smmUBRkWs6DzeDUe8MeAaVzRhDgUlks4RJ5uA52ulbYuIoEScoSLQubsa1
         LL8tKgViJiLiovb0UqeQq4VjrLqmw2j3yXfNkKdVd3e9AfRZTL5VXXEMMPpWZstoVH1Q
         +8ht3wldrLrRbXnTRpaUrfH1y4y8ns71FnEpCIaPj15QpC21NYnCIQwU1cFNEHyhzphZ
         nYkg==
X-Gm-Message-State: AOAM533ErLbKsPtDzRGDH67a3Pr7q44VIA1s5DmEgIBxqNWqOvzDjxJx
        ugqosOVLB/Nxofv8gO68gJ3g0g==
X-Google-Smtp-Source: ABdhPJymrs4hgP/Wh1S07nIz1KLV8v0OS0zz/u4I2xbmG2psObUFhqMdRTtycPqO5hDcRrkaMGSDbA==
X-Received: by 2002:aa7:88d6:0:b0:49f:dd4b:ddbc with SMTP id k22-20020aa788d6000000b0049fdd4bddbcmr2663799pff.31.1640084211426;
        Tue, 21 Dec 2021 02:56:51 -0800 (PST)
Received: from 9d766e42b9b9 ([1.145.8.37])
        by smtp.gmail.com with ESMTPSA id k19sm3108216pff.5.2021.12.21.02.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 02:56:51 -0800 (PST)
Date:   Tue, 21 Dec 2021 10:56:43 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/177] 5.15.11-rc1 review
Message-ID: <20211221105643.GA1117674@9d766e42b9b9>
References: <20211220143040.058287525@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 03:32:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.11 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
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
