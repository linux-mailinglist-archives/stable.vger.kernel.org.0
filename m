Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C107412AE8
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhIUCDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbhIUBoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 21:44:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AD1C059379;
        Mon, 20 Sep 2021 14:11:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k23-20020a17090a591700b001976d2db364so936207pji.2;
        Mon, 20 Sep 2021 14:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=JVdJjxGLLGY1GRkGrBP1UGsN1fvznTZbh/mzFYs4Abk=;
        b=Ld3y5cZokZh9hoJL3ufsAax7dsi6TZrkBKTNE5MuAgPWFxBjnobDLHM/Q1KNExEV8D
         NiiFZgN/XrQiGZmmk6JDgmf/bHiE7b/gWzp0auSShiZUJRsbR9jQ6/cjlASp6AEegBnR
         mIcgndAGr/OkxyfNrlv5XIO3rPBxDK9/GQU7IEfzauqWUzVcs7FGkYDK3TdFwPCjviOi
         kKjoPeRTgE/xqOhFEmG4y0FSxuJqpu6gbiPZCBuvPB6xUnCd/UKGhxL425qlf5g1gJVk
         FeRaPRnT5wYufmYGcHa+Kgo9xBLAL6f0vhE0xYOgYUq8EclB5hTKHvLjPtdCyFBCDGLQ
         ZdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=JVdJjxGLLGY1GRkGrBP1UGsN1fvznTZbh/mzFYs4Abk=;
        b=O7dXjhUcwhHtgM3slQ2n2HQ/HdIYcnDLAyFl+54sqIkMCvrDrUeY+VYdMOL/964yu1
         Ztfn8hhO1Z9tgcZ9J9+NuAQ97q1z4INBV/pDQ9bKY2Nf6UQmjkvVank1zJhDNx0zakAM
         YMaa9glBo1XU9n0NOVHbuQah3fTChjGPfDOnpW4uQKohQRk/97SDESKrxmLaBgKRQ53Y
         UBrFrWYD9wIAa0iKcLkHFbI4nPXjUBtRz+ZmK534nd9YCPMuX/qEUzkv3yyFa6n6ATkL
         vJgZjW+4xk5cpChATR207iP7eoUYFFO50SXttE/xSi4Py58lhJfGZDASC3O++5zoE43L
         kIPw==
X-Gm-Message-State: AOAM530FfPlNfT10I/0Ar8kzFX2iUpb2DFsxmvToMjnqZNti5QwCUoQ3
        gE1t2B+syMaEJEm7pVRzexTJ2ZuHmqMHu/6+S18=
X-Google-Smtp-Source: ABdhPJzfGOI24rst51uguJhn5uOY874xpVlbDvCd1Q81p8e2L7Nyv2kw+93I3SL7cDkduuVZdZfhZA==
X-Received: by 2002:a17:90a:1904:: with SMTP id 4mr1096990pjg.191.1632172315748;
        Mon, 20 Sep 2021 14:11:55 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id n9sm14982736pff.37.2021.09.20.14.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 14:11:54 -0700 (PDT)
Message-ID: <6148f91a.1c69fb81.f036c.85e0@mx.google.com>
Date:   Mon, 20 Sep 2021 14:11:54 -0700 (PDT)
X-Google-Original-Date: Mon, 20 Sep 2021 21:11:53 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/122] 5.10.68-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 18:42:52 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.68 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.68-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

