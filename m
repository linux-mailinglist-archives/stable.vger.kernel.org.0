Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB3E4DDAF3
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 14:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiCRNxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 09:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbiCRNxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 09:53:50 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6EB180202
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 06:52:30 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c2so5098548pga.10
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 06:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S/WOxZf9jPlS+KZ6d0WxhWnz3vTChihNzbIqjjwsDig=;
        b=gjzr139SmKccOzWITyviU88PSbVMy9+CD2+AAjnqO5miXgMgnGWZSA0mtHyDG1z3IG
         wq8QPhMCWK4XyKGgyieEHrjl/pjigD8WlomCjL0M9Uq2Ps12jJOFJM686TOaqxNPKNcv
         KOkJv1oxG2w+2umwlB1E0CDfrv8Td/xi9twtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S/WOxZf9jPlS+KZ6d0WxhWnz3vTChihNzbIqjjwsDig=;
        b=LphNNoJE85IZaiaI/z0baP50cGQSW48TtTWl/aH/cCIskv+FmqC1di72pbN0UbQf9+
         MnNmbwYrGEG0b0B9KgzwhxBGdYDY1sVnMTPv11vowI8MrgYV1wtCUQRGmHqoNDwycpTw
         jSw5oN69ur10zcNKcJmXIildLbz1xrUGeimgRRxqkLXon2n/m/XJpr8mkYT2VoN9yFfB
         3dPvHBJoyF6bGvlEfjrPAQ/aCEofDQGj8kJqwp0NuhzdjAfgjiik6nXczZAZj3sLkb/m
         o92fsLeZbrNX94840fS57eB9ba9DaBa2XKNDGQ28Ouod6cvlfKDIQGjtGLFMQ0VlPQJv
         bsRw==
X-Gm-Message-State: AOAM533PUahDb26lZh5EjBBST7e0ZbY3/9p2Z+L//Zpr8pexm0Mfnbwu
        Kw3BoAYjMMjDu0bbGyYySlY8Dw==
X-Google-Smtp-Source: ABdhPJzF33yuTsf50PfRLdvtRUJaAS7UHBu03QMRK/OCJtvAbuh8BB2S3GW3BSK1p30U7S908Iep7A==
X-Received: by 2002:a62:1ad3:0:b0:4fa:686f:9938 with SMTP id a202-20020a621ad3000000b004fa686f9938mr5539736pfa.6.1647611549699;
        Fri, 18 Mar 2022 06:52:29 -0700 (PDT)
Received: from 3f265be85885 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id o21-20020a056a0015d500b004fa22955e44sm10201654pfu.159.2022.03.18.06.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:52:28 -0700 (PDT)
Date:   Fri, 18 Mar 2022 13:52:19 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/28] 5.16.16-rc1 review
Message-ID: <20220318135219.GA2020579@3f265be85885>
References: <20220317124526.768423926@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 01:45:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

5.16.16-rc1 tested.

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
