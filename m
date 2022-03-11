Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2014D5D15
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 09:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiCKIP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 03:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiCKIPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 03:15:25 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86351017DD
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 00:14:21 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id lj8-20020a17090b344800b001bfaa46bca3so7343412pjb.2
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 00:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vjht4VjT0qP1PrjcnyRToI5pLA60dRVnlKZQmWleY/U=;
        b=oI4ar1HB51LBrLmbj/wtrBaWW6l4roM7ESsTGMRB9dhN2Hcp29WpYsyZY9rWS9EwxH
         abeTHaIOijZcALiFhzhJ5F83AIFNnYHMsdRURSoj4fxWQAoGv6uxuLT+ac26072g9mhb
         s0V8ep9BdbVbe4ESy0g5oO0jF/UarS3a4063M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vjht4VjT0qP1PrjcnyRToI5pLA60dRVnlKZQmWleY/U=;
        b=mabaW16m/PMxCrdDx1HX/JR+KaIacPuox0WaHmRIDx8h3PRlUiiP2dcqOkaBT+AgFn
         T3c/q4snk3vUAWT35Zf8tV+aCfbfwYkFnN61/TFuzbrWtCrhiNStOuOHix3NQC+7tKRA
         SJu39suhxxM4o6m3qbSmwv6Y0ZZssLHALZ7VcQ0jP0zp34HCTVP9DfAtnSfEHtAhS2Xe
         Sgwzyp78G2mO+SwCFQEYvfV+FX3SHTW1wQy1UxhQh048iuxkzPjrgTXCDbhKD+UMGoj4
         nlki4MTbxrzqZUd73VpGPno9FGu5qLoEOXN1bAs7QS9hUHUh04WSSvzD/oizPaVinWQT
         NFcA==
X-Gm-Message-State: AOAM532KlC+YW/SjlQ56EaenMxkEhyPmugjpL88osQSEUw9r6nAt+r8G
        mJaGWfv/NetA9vJIoZGSULKx1w==
X-Google-Smtp-Source: ABdhPJz/saDmNql9Jq1CQ7il2FyVSQ7Bh16oUvFbLTU8pS5XMo0dn0zdMXb1+6ruIfhTQsBNccvZGA==
X-Received: by 2002:a17:90a:e2cc:b0:1bf:711f:11e7 with SMTP id fr12-20020a17090ae2cc00b001bf711f11e7mr20407339pjb.40.1646986461176;
        Fri, 11 Mar 2022 00:14:21 -0800 (PST)
Received: from 5fcf59323384 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id c5-20020a056a00248500b004f6b5ddcc65sm9862257pfv.199.2022.03.11.00.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 00:14:20 -0800 (PST)
Date:   Fri, 11 Mar 2022 08:14:11 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/53] 5.16.14-rc2 review
Message-ID: <20220311081411.GA7@5fcf59323384>
References: <20220310140811.832630727@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 03:09:05PM +0100, Greg Kroah-Hartman wrote:
> Note, I'm sending all the patches again for all of the -rc2 releases as
> there has been a lot of churn from what was in -rc1 to -rc2.
> 
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

5.16.14-rc2 tested.

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
