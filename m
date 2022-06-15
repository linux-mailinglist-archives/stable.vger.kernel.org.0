Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E09854CADC
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 16:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356085AbiFOOGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 10:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356050AbiFOOGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 10:06:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6202B4A3EF
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 07:06:18 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m14so107428plg.5
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 07:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IVesxa57uPyCmDKceh3S6ZA+HPxkujqnZlbQCvL788w=;
        b=kAUlZaKOBfDV3AdLf++qBXp1upBc7IOUGLVYelDV97TyfoAVZp1rH00B7Jn6RKcaSG
         +z+B53UFSmIjNkQu31FidB9Eq9Oau3etD+MI39kcAyr2AbuTEpV5g6G2cnAzi5iOdT0L
         rk+lq5GkK8+otEXOfITH3+BRrcT71FwKz60Dk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IVesxa57uPyCmDKceh3S6ZA+HPxkujqnZlbQCvL788w=;
        b=dw4nSHVCiatoHUbx1BXSwuu9+/B59IPQ+cJ1kMJLZK77dvUlR1S5528xRObjto+JCK
         CjgGLB78XjBAgnAWIviPFsHNx5hPK80xaFkGTdD4ky5SzAwZGOtKpLf0sQkqjrlG8Ikj
         8RFZ3PHqIbnZlEsKBzalzrB+9SEUvLXEqteDh81C5cvUZW47C9kZvnwj+WalQUlc+Mpu
         Ws8xQ5SYiLnIc30ewe2FQDCk7uls7liW2LTILCV7QIP8hN1T5H5Pk0P/iq5SfBoVgM0O
         mLdYNErzhNEyeyVOaq20RDyblrVT+PH6M+E8x6ADNGKfQap/UKC1PXmgpDed9fEBG8gl
         gPBA==
X-Gm-Message-State: AJIora+PAlsphaGUJSotpy4owvvkKcT6vSSwIvQqZZZkTJdwbCf0KSI8
        trczy5zOd5tRl0NOYq3oI5NAKA==
X-Google-Smtp-Source: AGRyM1tvkzLYTMIHf6UoHPxsX7fjLCny8f1n40NPVSD1y35zDhqRrr1LZmZuIHqJLOzaIzkRAiKP8w==
X-Received: by 2002:a17:902:e88e:b0:163:ee82:ffb with SMTP id w14-20020a170902e88e00b00163ee820ffbmr10068210plg.142.1655301977634;
        Wed, 15 Jun 2022 07:06:17 -0700 (PDT)
Received: from d7a01fc38f5e (194-193-162-175.tpgi.com.au. [194.193.162.175])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090a891000b001e31fea8c85sm1787286pjn.14.2022.06.15.07.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 07:06:16 -0700 (PDT)
Date:   Wed, 15 Jun 2022 14:06:03 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/11] 5.18.5-rc1 review
Message-ID: <20220615140603.GA8@d7a01fc38f5e>
References: <20220614183720.861582392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 08:40:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.5 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.18.5-rc1 tested.

Run tested on:
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)
- Allwinner H6 (Tanix TX6)

In addition - build tested for:
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
