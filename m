Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4B74AD6EC
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 12:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356475AbiBHLah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 06:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356310AbiBHKbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 05:31:11 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C45DC03FEC1
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 02:31:08 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id i186so18159832pfe.0
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 02:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n2sPaAfs1e3r3EaCKrH3flEyvxcUKOyg9+DSgqzK2kY=;
        b=MW9d5dMmZamQEEDqf3yut7WOOWrRcS9vhDUuzD2Qffdf/ZkuPQhYNVJrqUO5rQG5Pv
         kn3LuLy1MF4EdVeySja+iqHd3GGUdxUdGhtaGb4++TeB9bN24bxPl81e7bMbbLxkMuYZ
         n0dIQqRgAafGZ04HEA3KQBKFpMY/BIIwW9rF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n2sPaAfs1e3r3EaCKrH3flEyvxcUKOyg9+DSgqzK2kY=;
        b=0dKr1Rg2tslAlfakWexGUQs3Ax5tAdMYRUgW9WWjFCAH6u2ABbVOynRCGVM2+6xvcx
         ICSGaZRuL8ruAj23eeUYTh55osLP1iwj6xQRPsRsPewwpVZuhz8k4MEnFj98AiDJwhgh
         NdScAbpEpa52+EzEwb25r6kSuFyOkdvR7sLa3Ro1RDJNuKfKYSeBqtt7kie1p8GYhzZv
         WDE7nso/tILMvrfoyCNBuvL7j/sd/B7lbpPSgNL9QFlys2GIQ90Q47ymi+Qyqw0vuRzi
         2DlniG1unLyeoVHYrcsHfi/xDTti21P++pCo1UWX1pk/uU4RwiFqxBqrsllAxa+cvMJD
         90Zw==
X-Gm-Message-State: AOAM530CsEvnJZ0JgrsXiVTo/d5oh9V3T6FUMHku94r2ia6DKfq7dH4Y
        Oq7VNrJJXd8DYJ0wTzIEAs5Q2w==
X-Google-Smtp-Source: ABdhPJw5CoJJ5j92QzzAFiXKwho86u7TKH2Dj9d4eLJJvDDSEUpwHs5VzBuY1DioqejlBbgmzCMXMQ==
X-Received: by 2002:a05:6a00:d5c:: with SMTP id n28mr3738935pfv.9.1644316267474;
        Tue, 08 Feb 2022 02:31:07 -0800 (PST)
Received: from f59db626e9e0 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id q16sm15514674pfu.194.2022.02.08.02.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 02:31:06 -0800 (PST)
Date:   Tue, 8 Feb 2022 10:30:56 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
Message-ID: <20220208103056.GA29@f59db626e9e0>
References: <20220207133856.644483064@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 03:04:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.16.8-rc2 tested.

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
