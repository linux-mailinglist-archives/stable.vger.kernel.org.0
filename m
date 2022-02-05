Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431074AA6A0
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 05:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378895AbiBEEkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 23:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354677AbiBEEku (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 23:40:50 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41980C061346
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 20:40:48 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id j16so6834362plx.4
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 20:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=77TATYNt7zjNful9cz6PMbglU2SavkdiXYEmdb1Z5Z8=;
        b=aU+B/GvYnrLz9LU5Lk0eeJ2tc7WynqNA5PLTW18F3whiBQuuTmv7TrVru15mOSFH3S
         xJoSrRjjCbOnlMqNYWNMJ8C6Y8uPB6CaByqVdeJp4fsU9bRIZixxG3F4orFt984OGSTp
         RF7ZrveAIbY87x4T0TZzHDT7dvY5be4PJFrmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=77TATYNt7zjNful9cz6PMbglU2SavkdiXYEmdb1Z5Z8=;
        b=otMermCendTPTmnvwrhwYiVPLj9h6GWuwOOdDISxisxm4RLovf+xLyL6CQuRAEBUFF
         MiOaG7mirUJTHYkTQTjxpOArmIM8D8dHgUylwgWmorky8ie2YUiK89IZGNuLNtHdJznl
         JcQGt3i0iRLsLd3i52zu0nXHaqPuxRDmF9vSGpbEzOVnDwViT0FaHigNoh3/IESQdWmn
         PpI3wl+aL9yzBGojW53SE0HKbbLdpob/Wg48qL3JsL3m+sx+kEZeXhaokmvrqprhwtVG
         BqYTNz1O6VLAJMiEnQ2b54ti+uVSVYGcFyAE4GR+iNuG1alYVz7uf1TihRmTnfw0Hf/q
         lTFQ==
X-Gm-Message-State: AOAM530xRAZyZn95DixGqd0mMWBySal2/kvngcYzLBBhrbLRjC9sa1su
        ttBn+F2DrWVlBkSjTdkgf61piA==
X-Google-Smtp-Source: ABdhPJwMXqY1NFsUvIRlfLhfa4dkr9eUbcQrQFg09VtFkH1Rp5P/h6gcLx9QlI+SpPDs9hQBQKWekQ==
X-Received: by 2002:a17:90b:1d8d:: with SMTP id pf13mr6840640pjb.232.1644036047562;
        Fri, 04 Feb 2022 20:40:47 -0800 (PST)
Received: from 74f11ec8ffa6 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id j3sm3017134pgs.0.2022.02.04.20.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 20:40:46 -0800 (PST)
Date:   Sat, 5 Feb 2022 04:40:36 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
Message-ID: <20220205044036.GA10@74f11ec8ffa6>
References: <20220204091917.166033635@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 10:22:07AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.16.6-rc1 tested.

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
