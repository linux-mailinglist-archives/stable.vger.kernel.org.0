Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434EC4E7EAF
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 03:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiCZCz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 22:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiCZCz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 22:55:27 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D181ED072
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 19:53:50 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id g3so10081134plo.6
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 19:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PSIzA3SpmPoH3dTegWNfD7Vv70zoBNgsaVOFtt43/Bc=;
        b=nSJzWQN4BaeFQPoqBygBN0ITz429JEufgDJi4BftxutV+8zfgJ5iUqWqjZ2i6nIcNx
         2EIkKIA5YrtYVGL+YOBrdwVExrNw9uoN6cF9p8YaNqx056uOnuSf/PfZlUIGbOMH9tKC
         3fwbBC4aWEx+aqf1Pz9u6UusYRKeGNff13BlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PSIzA3SpmPoH3dTegWNfD7Vv70zoBNgsaVOFtt43/Bc=;
        b=ij//mcF8BRcS6vuBjGsE91VZ4HiFZhPk330QaNUXm/Z4IX2ZdKMDW95Ls36V8q9miL
         ViLQMnSMWUPcXuyRPlLdVwFbQuupnYLD8zp/NGZPuawJkgSwF/S+djFNes8VwjAijsup
         AkRXdHCuyH20Jh5Ib+GQxsxqJmoJ4GPoX3yaiLUr/EPQG4NIDh8Fg4MpIIG2f9t5Hzxo
         cq0hC+/CM0yIQOJV0QqsUIznqVJhoyeLdjWWET34Dz/AoB18WnVX9A7Krpc9rbdNsvA1
         Dlg8FhneQZ6QeGXa+CmSEjSUbyLdVmufmn3IsTXyXPSr5u/ltY2Ei6C3M97+DSNBZ5Fs
         sOSQ==
X-Gm-Message-State: AOAM533k6lo8GghT9LAfYSulGMeFYzrLWIY4I5xmmBmWFJVUMpN45IyO
        zX9kvGh+Nbh/q36l9i/V0TWYAw==
X-Google-Smtp-Source: ABdhPJzfibpB6rdR0T7HJKExSnBJpuF/dDIcZ9CCmazvIpUr+AOvvbX2lfRPbxAu3iDexWWwFIX1dA==
X-Received: by 2002:a17:903:2444:b0:154:13b6:8850 with SMTP id l4-20020a170903244400b0015413b68850mr15054628pls.55.1648263230255;
        Fri, 25 Mar 2022 19:53:50 -0700 (PDT)
Received: from 86f5abb19214 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id w24-20020a639358000000b00385fcbf8e55sm6751036pgm.28.2022.03.25.19.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 19:53:49 -0700 (PDT)
Date:   Sat, 26 Mar 2022 02:53:38 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
Message-ID: <20220326024843.GA7@86f5abb19214>
References: <20220325150420.245733653@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 04:14:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.1 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

5.17.1-rc1 tested.

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
